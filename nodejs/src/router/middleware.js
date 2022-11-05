import apiClient from '@/store/api'
import store from '../store'

const Middleware = {
  async isLogin (from, to, next) {
    if (store.getters.getUser) return next();
    return next({name: 'Auth.Login'});
  },
  async isLoginAbort (from, to, next) {
    if (store.getters.getUser) return next({name: 'Home'})
    return next();
  },
  async RoleChecker (from, to, next) {
    let user = store.getters.getUser
    let role = store.getters['getRoles']
    if (role) {
      if (user && user.role.value >= role[from.meta.role].value) {
        return next();
      } else {
        return next({name: 'Error.401'})
      }
    } else {
      return next({name: 'Error.401'})
    }
  },
  async OAuthChecker (from, to, next) {
    let oauth = await store.getters.getOAuth
    if (! oauth) {
      await store.dispatch('oAuthAccess')
    }
    next()
  },
  async webviewChecker (from, to, next) {
    const device = store.getters.getDevice
    if (device.bot) {
      next({name: 'Error.401'})
    }
    if (device.isMobile === false) {
      return Middleware.isLogin(from, to, next)
    }
    return next()
  }
}
export default Middleware