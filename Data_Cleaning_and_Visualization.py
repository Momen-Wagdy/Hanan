import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('sensor_data.csv', names=['timestamp', 'temperature', 'humidity', 'smoke'])

# Convert timestamp to datetime
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Cleaning: Remove any rows with NaN values
df.dropna(inplace=True)

# Plot Temperature vs Time
plt.figure()
df.plot(x='timestamp', y='temperature', title="Temperature Over Time")
plt.show()

# Plot relations between sensors
plt.figure()
df.plot(x='temperature', y='smoke', kind='scatter', title="Temperature vs Smoke Level")
plt.show()
