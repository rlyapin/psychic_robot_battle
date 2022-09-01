<script>
  import Game from '$lib/Game.svelte'
  /** @type {import('./$types').PageData} */
  export let data;
  console.log(data)
</script>

<div class="column">
  <h1>Psychic Robot Battle</h1>

  <h2>
  A game where you should block your mind from an evil robot!
  </h2>

  <Game/>
</div>

<div class="column">
  <img src="logo.png" class="fit">
</div>