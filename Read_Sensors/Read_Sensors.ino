#include <WiFi.h>  // Include the WiFi library for ESP32
#include <DHT.h>   // Include the DHT sensor library

#define DHTPIN 4  // Define the pin where the DHT11 sensor is connected
#define DHTTYPE DHT11  // Define the type of DHT sensor being used (DHT11)

const char* ssid = "YourSSID";  // Replace with your WiFi SSID
const char* password = "YourPassword";  // Replace with your WiFi password
const char* serverURL = "http://your_laptop_ip:5000/data";  // Replace with your server's IP address and endpoint

DHT dht(DHTPIN, DHTTYPE);  // Create a DHT sensor object

void setup() {
    Serial.begin(115200);  // Start the serial communication at 115200 baud rate
    WiFi.begin(ssid, password);  // Connect to the WiFi network

    // Wait for the WiFi connection to establish
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);  // Wait for 1 second
        Serial.println("Connecting...");  // Print connection status
    }

    Serial.println("Connected to WiFi");  // Print success message
    dht.begin();  // Initialize the DHT sensor
}

void loop() {
    // Read temperature and humidity from the DHT sensor
    float temperature = dht.readTemperature();  // Get temperature in Celsius
    float humidity = dht.readHumidity();  // Get humidity percentage
    int smokeLevel = analogRead(34);  // Read the analog smoke sensor value from pin 34

    // Check if the temperature and humidity readings are valid
    if (!isnan(temperature) && !isnan(humidity)) {
        sendData(temperature, humidity, smokeLevel);  // Send the data to the server
    }

    delay(5000);  // Wait for 5 seconds before the next loop iteration
}

void sendData(float temp, float hum, int smoke) {
    WiFiClient client;  // Create a WiFiClient object
    // Attempt to connect to the server
    if (client.connect(serverURL, 80)) {
        // Prepare the POST data string with sensor values
        String postData = "temp=" + String(temp) + "&hum=" + String(hum) + "&smoke=" + String(smoke);

        // Send the POST request to the server
        client.print(String("POST /data HTTP/1.1\r\n") +  // HTTP method and endpoint
                     "Host: " + serverURL + "\r\n" +  // Specify the host
                     "Content-Type: application/x-www-form-urlencoded\r\n" +  // Set content type
                     "Content-Length: " + postData.length() + "\r\n\r\n" +  // Specify content length
                     postData);  // Attach the POST data
        client.stop();  // Close the connection
    }
}
