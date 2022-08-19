import createClient from "redis";

const client = createClient({
  url: process.env.REDIS_URI
});

client.on('error', (err) => console.log('Redis Client Error', err));

export const connectToRedis = async () => await client.connect();
