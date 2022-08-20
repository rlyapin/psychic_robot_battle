import { error } from '@sveltejs/kit';
import { hGetAllRedisAsync } from '$lib/redis';

/** @type {import('./$types').PageServerLoad} */
export async function load({ params }) {
  const stats = await hGetAllRedisAsync('psychic_stats');
  const parsed_stats = JSON.parse(JSON.stringify(stats));

  if (parsed_stats) {
    return parsed_stats;
  }
 
  throw error(404, 'App cannot find ML service stats');
}