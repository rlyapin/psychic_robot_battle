import logging
from fastapi import FastAPI
from .model import Psychic

app = FastAPI()
psychic = Psychic()

@app.get("/")
def read_root():
    return {"msg": "Launched ML psychic model"}


@app.get("/predict/")
async def predict(history: str):
    logging.info(f"Received predict request for {history}")
    return {"pred": psychic.predict(history)}
