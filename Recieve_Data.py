from flask import Flask, request  # Import Flask for creating the web application and request for handling incoming requests
import csv  # Import the csv module to handle CSV file operations
from datetime import datetime  # Import datetime to work with timestamps

# Initialize a Flask application
app = Flask(__name__)

# Define a route for handling POST requests to '/data'
@app.route('/data', methods=['POST'])
def receive_data():
    # Extract sensor data from the incoming request using form data
    temp = request.form.get('temp')  # Get the temperature value
    hum = request.form.get('hum')  # Get the humidity value
    smoke = request.form.get('smoke')  # Get the smoke level value

    # Generate a timestamp for when the data is received
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Open the 'sensor_data.csv' file in append mode to add new data
    with open('sensor_data.csv', 'a', newline='') as file:
        writer = csv.writer(file)  # Create a CSV writer object
        # Write a new row to the CSV file with the collected data
        writer.writerow([timestamp, temp, hum, smoke])

    # Return a success message with a 200 status code
    return "Data saved", 200

# Check if the script is run directly (not imported) and start the Flask application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Run the app on all interfaces at port 5000
