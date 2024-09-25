#include <WiFi.h>
#include <DHT.h>
#define DHTPIN 4
#define DHTTYPE DHT11

const char* ssid = "YourSSID";
const char* password = "YourPassword";
const char* serverURL = "http://your_laptop_ip:5000/data";

DHT dht(DHTPIN, DHTTYPE);

void setup() {
    Serial.begin(115200);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting...");
    }
    Serial.println("Connected to WiFi");
    dht.begin();
}

void loop() {
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();
    int smokeLevel = analogRead(34);

    if (!isnan(temperature) && !isnan(humidity)) {
        sendData(temperature, humidity, smokeLevel);
    }

    delay(5000);  // Send data every 5 seconds
}

void sendData(float temp, float hum, int smoke) {
    WiFiClient client;
    if (client.connect(serverURL, 80)) {
        String postData = "temp=" + String(temp) + "&hum=" + String(hum) + "&smoke=" + String(smoke);
        client.print(String("POST /data HTTP/1.1\r\n") +
                     "Host: " + serverURL + "\r\n" +
                     "Content-Type: application/x-www-form-urlencoded\r\n" +
                     "Content-Length: " + postData.length() + "\r\n\r\n" +
                     postData);
        client.stop();
    }
}
