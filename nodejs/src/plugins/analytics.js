import store from '../store'
import { bootstrap } from 'vue-gtag'

class analytics {
  constructor(gtag = null, prefix = 'eload') {
    this.$gtag = gtag
    this.prefix = prefix
    this.init = false
    this.pageview = false
    this.device = store.getters.getDevice
    this.t = this.analyticsConfig()
    if (this.$gtag && this.device.isMobile) {
      bootstrap().then((gtag) => {
        this.t.config.initialize()
      }).catch(() => {})
    }
  }
  analyticsCall(action) {
    if (this.$gtag && this.init && this.pageview && this.device.isMobile) {
      action()
    }
  }

  analyticsConfig () {
    return {
      config: {
        initialize: () => {
          if (this.device.isMobile) {
            this.$gtag.query('config', process.env.VUE_APP_GOOGLE_ANALYTICS, {
              send_page_view: false,
              custom_map: {
                dimension1: 'pin_id',
                metric1: 'pin_id_event'
              }
            })
            this.init = true
          }
        }
      },
      exception: {
        error401: () => {
          this.analyticsCall(() => {
            this.$gtag.exception({ description: '401 UnAuthorized 허용되지 않은 접근입니다. 앱 인증에 실패하였거나, 접근 권한이 없습니다.', fatal: false })
          })
        }
      },
      set: {
        language: (country_locale) => {
          this.analyticsCall(() => {
            this.$gtag.set({currency: 'KRW', country: 'KR', language: country_locale})
          })
        },
        user: (pin_id) => {
          this.analyticsCall(() => {
            //this.$gtag.customMap({ 'dimension1': 'pin_id' })
            this.$gtag.event('pin_id_dimension', {'pin_id': pin_id})
            //this.$gtag.customMap({ 'metric1': 'pin_id_event' })
            this.$gtag.event('pin_id_metric', {'pin_id_event': pin_id})
            // this.$gtag.set({pin_id: user.pin_id})
          })
        }
      },
      event: {
        page_view: ($route) => {
          if (this.init && this.device.isMobile) {
            this.$gtag.pageview($route)
            this.pageview = true
          }
        },
        select_banner: (banner_id) => {
          this.analyticsCall(() => {
            this.$gtag.event('select_content', {
              content_type: `${this.prefix}#banner`,
              item_id: banner_id
            })
          })
        },
        select_favorite: (favorite_product_id) => {
          this.analyticsCall(() => {
            this.$gtag.event('select_content', {
              content_type: `${this.prefix}#product_favorite`,
              item_id: favorite_product_id
            })
          })
        },
        select_recent: (recent_product_id) => {
          this.analyticsCall(() => {
            this.$gtag.event('select_content', {
              content_type: `${this.prefix}#product_recent`,
              item_id: recent_product_id
            })
          })
        },
        select_language: (label, value) => {
          this.analyticsCall(() => {
            this.$gtag.event('click', {
              event_category: `${this.prefix}#select_language`,
              event_label: label,
              value: value
            })
          })
        },
        select_country: (label, value) => {
          this.analyticsCall(() => {
            this.$gtag.event('click', {
              event_category: `${this.prefix}#select_country`,
              event_label: label,
              value: value
            })
          })
        },
        select_category: (label, value) => {
          this.analyticsCall(() => {
            this.$gtag.event('click', {
              event_category: `${this.prefix}#select_category`,
              event_label: label,
              value: value
            })
          })
        },
        select_product: (label, value) => {
          this.analyticsCall(() => {
            this.$gtag.event('click', {
              event_category: `${this.prefix}#select_product`,
              event_label: label,
              value: value
            })
          })
        },
        select_price: (label, value) => {
          this.analyticsCall(() => {
            this.$gtag.event('click', {
              event_category: `${this.prefix}#select_price`,
              event_label: label,
              value: value
            })
          })
        },
        purchase: (transaction_id, item) => {
          this.analyticsCall(() => {
            this.$gtag.event('purchase', {
              currency: 'KRW',
              transaction_id: transaction_id,
              affiliation: 'ThePay',
              value: item.price,
              items: [item]
            })
          })
        }
      }
    }
  }
}
export default analytics