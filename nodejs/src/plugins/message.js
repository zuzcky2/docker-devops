import store from '../store'
import common from "./common";
class message {
  constructor() {
    this.device = store.getters.getDevice
    this.bookTypeEnums = {
      rechargeHistory: 'recharge',
      eloadIdHistory: 'eloadId',
      eloadEmailHistory: 'eloadEmail',
      eloadCallHistory: 'eloadCall'
    }
    this.historyTypeEnums = {
      id: 'id',
      email: 'email',
      num: 'num',
    }
    this.contactType = {
      history: 'history',
      country: 'country',
      contact: 'contact'
    }
    this.messageException = {
      FailedGetValue: '값을 받아오지 못했습니다.'
    }
  }

  /**
   *
   * @param call_name
   * @param params
   * @param callback_name
   * @param callback
   * @param web
   */
  caller (call_name, params = null, callback_name = null, callback = null, web = null) {
    if (this.device.isMobile) {
      try {
        if (callback_name) {
          window[callback_name] = (result = null) => {
            const data = common.available(result) ? JSON.parse(result) : null
            callback(data ? data : web ? web : null)
            delete window[callback_name]
          }
        }
        if (this.device.platform === 'android' && common.available(window.Android)) {
          this.callAndroid(call_name, params)
        } else if (this.device.platform === 'ios' && common.available(window.webkit)) {
          this.callIos(call_name, params)
        } else {
          this.callAnonymous()
        }
      } catch (e) {
        console.log(e)
        callback(undefined)
      }
    } else {
      if (callback) {
        callback(web ? web : null)
      }
    }
  }

  callAndroid (call_name, params = null) {
    if (common.available(window.Android[call_name]) && typeof window.Android[call_name] === "function") {
      params ? window.Android[call_name](JSON.stringify(params)) : window.Android[call_name]()
    } else {
      throw `Android ${call_name} 함수를 찾을 수 없습니다.`
    }
  }

  callIos (call_name, params = null) {
    try {
      window.webkit.messageHandlers.callbackHandler.postMessage(`${call_name}(${JSON.stringify(params)})`);
    } catch (e) {
      throw `ios ${call_name} 함수를 찾을 수 없습니다.`
    }
  }

  callAnonymous () {
    throw JSON.stringify(this.device)
  }
}
export default message