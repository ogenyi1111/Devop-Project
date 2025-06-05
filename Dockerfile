# Use an official Python image
FROM python:3.10-slim

# Set working directory in container
WORKDIR /app

# Copy application code and requirements
COPY app.py /app/
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy HTML template and static assets
COPY src/html/index.html /app/templates/index.html
COPY src/html/waving-hand.png /app/static/waving-hand.png
COPY src/html/Devop-workflow.jpg /app/static/Devop-workflow.jpg

# Expose port (Flask default)
EXPOSE 5000

# Command to run the app
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
