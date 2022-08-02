// https://www.reddit.com/r/sveltejs/comments/v1d1ms/connecting_my_database_with_sveltekit/
import pg from "pg";

const pool = new pg.Pool({
  database: "psychic",
  user: "postgres",
  host: "timescaledb-pod.timescaledb-service.default.svc.cluster.local",
  port: 5432,
});

export const connectToDB = async () => await pool.connect();