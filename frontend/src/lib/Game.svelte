<script>
  let uuid = crypto.randomUUID();
  let score = 0;
  let pred = "L";
  let click_history = [];
  let score_history = [];

  function userClick(button) {
    score += 1 - 2 * (button == pred);
    click_history = [...click_history.slice(-24), button];
    score_history = [...score_history, score];
  }
</script>

<p>Please click any button you like (do not forget to block your mind as you do it!)</p> 
<p>Every time evil robot correctly predicts your pick you lose 1 point, every time robot is fooled you get 1 point back.</p>

<button on:click={() => userClick("L")}>
  Left
</button>

<button on:click={() => userClick("R")}>
  Right
</button>

<p> Your score: {score} </p>

<p> Your click history (25 latest clicks): {click_history} </p>

<p> Session cookie: {uuid} </p>