<script>
  import Game from '$lib/Game.svelte'
  /** @type {import('./$types').PageData} */
  export let data;
  console.log(data)
</script>

<h1>Psychic Robot Battle</h1>

<h2>
A game where you should block your mind from an evil robot!
</h2>

<p>Please click any button you like (do not forget to block your mind as you do it!)</p>
<p>Every time evil robot correctly predicts your pick you lose 1 point, every time robot is fooled you get 1 point back.</p>

<Game/>
