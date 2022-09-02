import logging
import numpy as np
import os
import psycopg2


class Psychic:
    def __init__(self):
        self.prefix_stats = self.load_click_stats()

    def load_click_stats(self):
        prefix_stats = {}

        conn = psycopg2.connect(dbname=os.getenv("POSTGRES_PSYCHIC_DB"),
                                user=os.getenv("POSTGRES_USER"),
                                password=os.getenv("POSTGRES_PASSWORD"),
                                host=os.getenv("POSTGRES_HOSTNAME"),
                                port=os.getenv("POSTGRES_PORT"))

        cursor = conn.cursor("click_stats_cursor")
        cursor.execute("SELECT * FROM click_probs")

        for record in cursor:
            history, click, count = record
            for i in range(len(history) + 1):
                prefix = history[i:]
                if prefix not in prefix_stats:
                    prefix_stats[prefix] = {"L": 0, "R": 0}
                prefix_stats[prefix][click] += count
            logging.info(f"Ingested record: {record}")

        conn.close()

        return prefix_stats

    def predict(self, history):
        for i in range(len(history) + 1):
            prefix = history[i:]
            if prefix in self.prefix_stats:
                l_weight = self.prefix_stats[prefix]["L"] + 1
                r_weight = self.prefix_stats[prefix]["R"] + 1
                total_weight = l_weight + r_weight
                if total_weight > 25:
                    probs = [l_weight / total_weight, r_weight / total_weight]
                    logging.info(f"Sampling for {prefix} prefix at {probs} probs")
                    return np.random.choice(["L", "R"], p=probs)

        return np.random.choice(["L", "R"])
