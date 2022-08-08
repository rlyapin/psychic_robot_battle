// https://www.reddit.com/r/sveltejs/comments/v1d1ms/connecting_my_database_with_sveltekit/
import pg from "pg";

const db = process.env.POSTGRES_DB;
const user = process.env.POSTGRES_USER;
const pwd = process.env.POSTGRES_PASSWORD;

const pool = new pg.Pool({
  database: db,
  user: user,
  password: pwd,
  host: "timescaledb.default.svc.cluster.local",
  port: 5432,
});

export const connectToDB = async () => await pool.connect();