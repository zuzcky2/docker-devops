import xhttp from './xhttp'
import store from '../store'
import {Base64} from "js-base64";

const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'X-Requested-With': 'XMLHttpRequest',
}
const client = xhttp()

export default async (config = {
  url: String,
  method: String,
  timeout: [Number, null, undefined],
  data: [Object, null, undefined],
  params: [Object, null, undefined],
  token: [String, null],
  baseURL: [String, null],
  oauth: [Boolean, false],
  cache: [Boolean, false]
}) => {
  config.forceUpdate = !config.cache
  config.cache = !!config.cache
  config.headers = Object.assign({}, headers)
  config.baseURL = config.baseURL ? config.baseURL : '/api'
  try {
    let oauth = null
    if (config.oauth === true && config.token !== null)
      config.headers['X-OAuth-Client'] = Base64.encode(store.getters.getOAuthInformation.oAuthClientId + '@' + store.getters.getOAuthInformation.oAuthClientSecret)
    if (config.cache) config.headers['Cache-Control'] = 'no-cache'
    if (config.token) config.headers['Authorization'] = `Bearer ${config.token}`
    if (!config.token && !config.oauth) {
      config.headers['X-Client-Token'] = process.env.VUE_APP_API_TOKEN
    }
    let response
    if (['get', 'delete'].includes(config.method)) {
      response = await client[config.method](config.url, config)
    } else {
      response = await client[config.method](config.url, config.data || null, config)
    }
    if (response.headers['authorization-expires']) {
      await store.commit('changeOAuthExpires', response.headers['authorization-expires'])
    }
    if (config.oauth === true && config.token !== null && oauth && response.headers['x-oauth-client']) {
      await store.commit('changeOAuth', JSON.parse(Base64.decode(response.headers['x-oauth-client'])))
    }
    return response
  } catch (err) {
    store.commit('changeOverlay', false)
    throw err.response
  }
}