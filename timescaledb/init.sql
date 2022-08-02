CREATE TABLE IF NOT EXISTS events
(id SERIAL PRIMARY KEY, event_time timestamp, session_id VARCHAR(50), click VARCHAR(50), pred VARCHAR(50));