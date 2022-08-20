import { createClient } from "redis";

export const redisClient = createClient({
  url: process.env.REDIS_URI,
});

(async () => {
   redisClient.on('error', (err) => console.log(err));
   await redisClient.connect();
})();

export const hGetAllRedisAsync = async (key) => {
   const value = await redisClient.hGetAll(key);
   return value;
};

export const setRedisAsync = async (key, value) => {
   await redisClient.set(key, value);
};