FROM python:3.10-slim

WORKDIR /app

# Copy necessary files
COPY app.py requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask assets
COPY templates/ ./templates/
COPY static/ ./static/

# Expose Flask port
EXPOSE 5000

# Run the app using Gunicorn
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
