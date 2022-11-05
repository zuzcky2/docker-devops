// Polyfills
import 'core-js/stable'
import 'regenerator-runtime/runtime'

import Vue from 'vue'

if (process.env.NODE_ENV === 'production') {
  Vue.config.devtools = false;
  Vue.config.debug = false;
  Vue.config.silent = true;
}

import App from './App.vue'
import vuetify from './plugins/vuetify'
import './assets/css/style.scss'
import router from './router'
import store from './store'
import VueRouter from "vue-router"
import VueClipboard from 'vue-clipboard2'
import LoadScript from 'vue-plugin-load-script'
import VueMobileDetection from "vue-mobile-detection"
import numeral from 'numeral'
import numFormat from 'vue-filter-number-format'
import AsyncComputed from 'vue-async-computed'
import VueDayjs from 'vue-dayjs-plugin'
import VuetifyConfirm from 'vuetify-confirm'
import VuetifyDialog from 'vuetify-dialog'
import 'vuetify-dialog/dist/vuetify-dialog.css'
import VueMeta from 'vue-meta'
import common from '@/plugins/common.js'
import DatetimePicker from 'vuetify-datetime-picker'
import moment from 'vue-moment'
import VNumberField from "flexerant-vuetify-number-field";
import { TiptapVuetifyPlugin } from 'tiptap-vuetify'
import 'tiptap-vuetify/dist/main.css'
import 'vuetify/dist/vuetify.min.css'

Vue.use(VNumberField);
Vue.component("v-number-field", VNumberField);
Vue.use(VueMeta, {
  // optional pluginOptions
  refreshOnceOnNavigation: true
})

Vue.prototype.available = common.available
Vue.prototype.reform = common.reform

Vue.config.productionTip = false
Vue.use(VueRouter)
Vue.use(VueDayjs, { lang: 'kr' })
Vue.use(VueClipboard)
Vue.use(LoadScript)
Vue.use(VueMobileDetection)
Vue.use(AsyncComputed)
Vue.use(DatetimePicker)
Vue.use(moment);
Vue.use(VuetifyConfirm, { vuetify })
Vue.use(VuetifyDialog, { context: {
    vuetify
  } })
Vue.filter('numFormat', numFormat(numeral));
Vue.use(TiptapVuetifyPlugin, {
  // the next line is important! You need to provide the Vuetify Object to this place.
  vuetify, // same as "vuetify: vuetify"
  // optional, default to 'md' (default vuetify icons before v2.0.0)
  iconsGroup: 'mdi'
})
export default new Vue({
  el: '#app',
  store,
  router,
  vuetify,
  render: h => h(App),
})

