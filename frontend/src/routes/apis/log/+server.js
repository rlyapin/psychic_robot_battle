import { json } from '@sveltejs/kit';
import { connectToDB } from '$lib/db';

export async function POST({ url }) {
    const client = await connectToDB();

    const session = url.searchParams.get("session");
    const click = url.searchParams.get("click");
    const pred = url.searchParams.get("pred");

    const query = 'INSERT INTO events(event_time, session_id, click, pred) VALUES($1, $2, $3, $4) RETURNING *';
    const values = ['NOW()', session, click, pred];

    client.query(query, values, (err, res) => {
        console.log(err ? err.stack : res.rows[0]);
        client.release();
    });

    return json({message: "ok"});
}