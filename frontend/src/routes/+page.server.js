import { error } from '@sveltejs/kit';
import { connectToRedis } from '$lib/redis';
 
/** @type {import('./$types').PageServerLoad} */
export async function load({ params }) {
  const redis_client = await connectToRedis();
  const stats = await redis_client.hGetAll('psychic_stats');

  if (stats) {
    return stats;
  }
 
  throw error(404, 'Not found');
}