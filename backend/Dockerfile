FROM python:3.11-slim

WORKDIR /app

# Install poetry
RUN pip install poetry==1.7.1

# Copy project configuration
COPY pyproject.toml ./

# Configure poetry to not create virtual environment
RUN poetry config virtualenvs.create false

# Install dependencies
RUN poetry install --no-interaction --no-ansi --no-root

# Copy application code
COPY backend ./backend

# Run FastAPI
CMD ["uvicorn", "backend.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
