FROM python:3.9-slim-buster

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt
RUN pip install .

CMD ["uvicorn", "psychic.server:app", "--host", "0.0.0.0", "--port", "8080"]
