from flask import Flask, request
import csv
from datetime import datetime

app = Flask(__name__)

@app.route('/data', methods=['POST'])
def receive_data():
    temp = request.form.get('temp')
    hum = request.form.get('hum')
    smoke = request.form.get('smoke')
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    with open('sensor_data.csv', 'a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([timestamp, temp, hum, smoke])

    return "Data saved", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
