import Vue from 'vue'
import Vuex from 'vuex'
import {Base64} from "js-base64";
import apiClient from "@/store/api";
import DeviceDetector from "device-detector-js";
Vue.use(Vuex)

const session_key = '__IAPI__Session';
const user_key = '__IAPI__User';
const deviceDetector = new DeviceDetector();

export default new Vuex.Store({
  state: {
    $overlay: true,
    session: window.localStorage.getItem(session_key) ? Base64.decode(window.localStorage.getItem(session_key)).toString() : null,
    oauth: null,
    device: deviceDetector.parse(navigator.userAgent.toLowerCase()),
    breadcrumbs: [],
  },
  mutations: {
    changeOverlay(state, overlay) {
      state.$overlay = overlay
    },
    changeSession(state, session) {
      if (session) {
        state.session = session
        window.localStorage.setItem(session_key, Base64.encode(session).toString())
      } else {
        window.localStorage.removeItem(session_key)
      }
      state.session = session
    },
    changeBreadCrumbs(state, items) {
      state.breadcrumbs = items
    }
  },
  getters: {
    getOverlay (state) {
      return state.$overlay
    },
    getSession (state) {
      return state.session
    },
    getDevice (state) {
      let device = state.device
      if (device.device.type.toLowerCase() === 'desktop') {
        device.isMobile = false
        device.platform = 'web'
      } else {
        device.isMobile = true
        device.platform = 'etc'
        if (device.os.name.toLowerCase() === 'android') {
          device.platform = 'android'
        } else if (device.os.name.toLowerCase() === 'ios') {
          device.platform = 'ios'
        }
      }
      return device
    },
    getBreadcrumbs (state) {
      return state.breadcrumbs
    }
  },
  actions: {
  },
  modules: {
  }
})
