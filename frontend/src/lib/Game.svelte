<script>

  async function callPred() {
    let response = await fetch(`/apis/predict?history=${api_request}`,
                               {"headers": {"content-type": "application/json", "accept": "application/json"}});
    let pred = await response.text();
    return pred
  }

  let uuid = crypto.randomUUID();
  let score = 0;

  let pred = "N/A";

  let click_history = [];
  let score_history = [];
  $: api_request = click_history.reduce((x, y) => x + y, "");

  async function userClick(button) {
    pred = await callPred();
    score += 1 - 2 * (button === pred);
    click_history = [...click_history.slice(-24), button];
    score_history = [...score_history, score];
  }
</script>

<button on:click={async () => await userClick("L")}>
  Left
</button>

<button on:click={async () => await userClick("R")}>
  Right
</button>

<p> Your score: {score} </p>

<p> Your click history (25 latest clicks): {api_request} </p>

{#await pred}
  <p>...waiting</p>
{:then data}
  <p> Last robot prediction: {data} </p>
{/await}

<p> Session cookie: {uuid} </p>