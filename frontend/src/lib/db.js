// https://www.reddit.com/r/sveltejs/comments/v1d1ms/connecting_my_database_with_sveltekit/
import pg from "pg";

const pool = new pg.Pool({
  database: process.env.POSTGRES_PSYCHIC_DB,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  host: process.env.POSTGRES_HOSTNAME,
  port: process.env.POSTGRES_PORT,
});

export const connectToDB = async () => await pool.connect();