from fastapi import FastAPI
from .model import Psychic

app = FastAPI()
psychic = Psychic()

@app.get("/")
def read_root():
    return {"msg": "Launched ML psychic model"}


@app.get("/predict/{history}")
def predict(history: str):
    return {"pred": psychic.predict(history)}
