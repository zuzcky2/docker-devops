<template>
  <div>
    <v-breadcrumbs
        :items="items"
        divider="-"
    ></v-breadcrumbs>
  </div>
</template>

<script>
export default {
  name: "ContentMenuTree",
  computed: {
    items () {
      const basePath = '/'
      let routes = []
      this.$route.matched.map((route, i) => {
        if (route && route.meta && route.meta.label) {
          if (route.meta.breadcrumb === undefined || route.meta.breadcrumb !== false) {
            if (i === this.$route.matched.length - 1) {
              routes.push({
                text: this.$route.meta.label,
                disabled: false,
                href: this.$route.path.indexOf(basePath) === -1 ? basePath + this.$route.path : this.$route.path
              })
            } else {
              let path = route.path.indexOf(basePath) === -1 ? basePath + route.path : route.path
              Object.keys(this.$route.params).map((v) => {
                let target_path = `:${v}`
                if (path.indexOf(target_path) !== -1) {
                  path = path.replace(target_path, this.$route.params[v])
                }
              })
              routes.push({
                text: route.meta.label,
                disabled: false,
                href: path
              })
            }
          }
        }
      })
      this.$store.commit('changeBreadCrumbs', routes)
      return routes
    },
    title () {
      if (this.routes.length > 0) {
        return this.routes.map((item) => { return item.text }).join(' > ')
      } else {
        return null
      }
    }
  }
}
</script>