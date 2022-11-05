<template>
  <v-app id="inspire">
    <v-overlay :value="this.$store.getters['getOverlay']" z-index="20001">
      <v-progress-circular
          indeterminate
          color="primary"
      ></v-progress-circular>
    </v-overlay>
    <component :is="layout">
      <router-view></router-view>
    </component>
  </v-app>
</template>
<script>
import FullLayout from './layouts/FullLayout.vue';
import SingleLayout from './layouts/SingleLayout.vue';
import NoLayout from './layouts/NoLayout.vue';

export default {
  name: 'App',
  metaInfo: {
    title: '통합 API',
    titleTemplate: '%s',
    htmlAttrs: {
      lang: 'kr',
    }
  },
  components: { FullLayout, SingleLayout, NoLayout },
  computed: {
    layout() {
      return this.$route.meta.layout;
    }
  },
  watch: {
    $route (to, from) {
      this.$store.commit('changeOverlay', true)
    }
  }
};
</script>
