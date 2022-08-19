export async function GET({ url }) {
    const history = url.searchParams.get("history")
    console.log(history)

    // TODO: move info about model info to kubernetes configs and instead load environment variables
    // const api_endpoint = "http://psychic-pod.default-subdomain.default.svc.cluster.local:8080"
    const api_endpoint = "http://psychic:8080"
    const result = await (await fetch(`${api_endpoint}/predict/?history=${history}`, 
        {"method": "GET", "headers": {"content-type": "application/json", "accept": "application/json"}})).json();
    console.log(result)

    const pred = result.pred;

    return {
        status: 200,
        headers: {
            'access-control-allow-origin': '*'
        },
        body: pred
    };
}