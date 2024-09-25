import pandas as pd  # Import the pandas library for data manipulation and analysis
import matplotlib.pyplot as plt  # Import the matplotlib library for plotting graphs

# Load data from a CSV file into a DataFrame
df = pd.read_csv('sensor_data.csv', names=['timestamp', 'temperature', 'humidity', 'smoke'])

# Convert the 'timestamp' column to datetime format for easier plotting and manipulation
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Data Cleaning: Remove any rows that contain NaN (Not a Number) values to ensure clean data for analysis
df.dropna(inplace=True)

# Create a new figure for the Temperature vs Time plot
plt.figure()

# Plot the temperature data against time, with 'timestamp' on the x-axis and 'temperature' on the y-axis
# Add a title to the plot for clarity
df.plot(x='timestamp', y='temperature', title="Temperature Over Time")

# Display the Temperature vs Time plot
plt.show()

# Create a new figure for the scatter plot of Temperature vs Smoke Level
plt.figure()

# Plot the relationship between temperature and smoke level using a scatter plot
# The 'temperature' column is on the x-axis, and the 'smoke' column is on the y-axis
# Add a title to the plot for clarity
df.plot(x='temperature', y='smoke', kind='scatter', title="Temperature vs Smoke Level")

# Display the scatter plot of Temperature vs Smoke Level
plt.show()
