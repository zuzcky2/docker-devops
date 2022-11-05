<template>
  <div id="app">
    <v-app id="inspire">
      <v-main>
        <slot />
      </v-main>
    </v-app>
  </div>
</template>

<script>
export default {
  name: 'NoLayout'
};
</script>

<style scoped></style>
