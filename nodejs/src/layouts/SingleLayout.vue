<template>
  <div id="app">
    <v-app id="inspire">
      <v-main class="grey lighten-3">
        <slot />
      </v-main>
    </v-app>
  </div>
</template>

<script>
export default {
  name: "SingleLayout",
}
</script>

<style scoped>

</style>