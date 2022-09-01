<script>

  async function callPred() {
    let response = await fetch(`/apis/predict?history=${api_request}`,
                               {"headers": {"content-type": "application/json", "accept": "application/json"}});
    let pred = await response.text();
    return pred
  }

  async function log(button) {
    let response = await fetch(`/apis/log?session=${uuid}&click=${button}&pred=${pred}`,
                               {"method": "POST", 
                                "headers": {"content-type": "application/json", "accept": "application/json"}});
    let result = await response.text();
    return result
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
    score_history = [...score_history.slice(-24), score];
    await log(button);
  }
</script>

<p>Please click any button you like (do not forget to block your mind as you do it!)</p>

<div class="centre">
  <button on:click={async () => await userClick("L")}>
    Left
  </button>

  <button on:click={async () => await userClick("R")}>
    Right
  </button>
</div>

<p>Every time evil robot correctly predicts your pick you lose 1 point, every time robot is fooled you get 1 point back.</p>

<p> Your score: {score} </p>

<p> Your click history (25 latest clicks): {api_request} </p>

{#await pred}
  <p>...waiting</p>
{:then data}
  <p> Last robot prediction: {data} </p>
{/await}

<p> Session cookie: {uuid} </p>