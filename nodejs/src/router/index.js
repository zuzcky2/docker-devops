import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import multiguard from 'vue-router-multiguard';
import middleware from "@/router/middleware";
import VueGtag from "vue-gtag";

Vue.use(VueRouter)

const routes = [
  {
    path: '*',
    redirect: '/errors/404'
  }, {
    path: '',
    name: 'Parent',
    redirect: '/',
    component: () => import('../views/Index'),
    children: [
      {
        path: '/auth',
        name: 'Auth',
        component: () => import('../views/Auth/Index'),
        meta: {
          layout: 'FullLayout',
          label: '인증',
          parentName: null,
          role: 'USER_ROLE_MANAGER'
        },
        children: [
          {
            path: 'login',
            name: 'Auth.Login',
            component: () => import('../views/Auth/Login'),
            beforeEnter: multiguard([middleware.isLoginAbort]),
            meta: {
              layout: 'SingleLayout',
              label: '로그인',
              parentName: 'Auth',
              role: 'USER_ROLE_GUEST'
            }
          }
        ]
      }, {
        path: '/',
        name: 'Root',
        redirect: '/home',
        component: () => import('../views/Index'),
        children: [
          {
            path: 'home',
            name: 'Root.Home',
            component: () => import('../views/Home'),
            meta: {
              layout: 'FullLayout',
              label: 'Home',
              parentName: null,
              role: 'USER_ROLE_MEMBER'
            }
          }
        ]
      }
    ]
  }, {
    path: '/errors',
    name: 'Error',
    component: () => import('../views/Errors/Index'),
    children: [
      {
        path: '401',
        name: 'Error.401',
        component: () => import('../views/Errors/Error401'),
        meta: {
          layout: 'SingleLayout',
          label: 'Error401',
          parentName: null,
          role: 'USER_ROLE_GUEST'
        }
      }, {
        path: '404',
        name: 'Error.404',
        component: () => import('../views/Errors/Error404'),
        meta: {
          layout: 'SingleLayout',
          label: 'Error404',
          parentName: null,
          role: 'USER_ROLE_GUEST'
        }
      }, {
        path: '400',
        name: 'Error.400',
        component: () => import('../views/Errors/Error400'),
        meta: {
          layout: 'SingleLayout',
          label: 'Error400',
          parentName: null,
          role: 'USER_ROLE_GUEST'
        }
      }, {
        path: '500',
        name: 'Error.500',
        component: () => import('../views/Errors/Error500'),
        meta: {
          layout: 'SingleLayout',
          label: 'Error500',
          parentName: null,
          role: 'USER_ROLE_GUEST'
        }
      }
    ]
  }

]
let nextPath
const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})
router.beforeEach((to, from, next) => {
  if (['ThePay.Eload'].includes(to.name)) {
    Vue.use(VueGtag, {
      config: {
        id: process.env.VUE_APP_GOOGLE_ANALYTICS,
        params: {
          send_page_view: false
        }
      },
      bootstrap: false,
      appName: 'ThePay',
    }, router);
  }

  nextPath = to.fullPath
  return next()
})
router.onError((error) => {
  if (/loading chunk \d* failed./i.test(error.message) || error.name === 'ChunkLoadError') {
    if (nextPath) {
      window.location.href = nextPath
    } else {
      window.location.reload()
    }
  }
})

export default router
