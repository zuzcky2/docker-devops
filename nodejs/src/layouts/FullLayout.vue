<template>
  <v-app id="inspire">
    <full-layout-nav/>
    <v-main class="grey lighten-3" >
      <!--<content-menu-tree/>-->
      <slot />
    </v-main>
  </v-app>
</template>
<script>
import FullLayoutNav from "../components/FullLayoutNav";
//import ContentMenuTree from '../components/ContentMenuTree';

export default {
  name: "FullLayout",
  components: {
    FullLayoutNav,
    //ContentMenuTree
  },
}
</script>