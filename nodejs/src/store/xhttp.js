import axios from 'axios';
import { cacheAdapterEnhancer } from 'axios-extensions';

export default () => {
  return axios.create({
    withCredentials: false,
    adapter: cacheAdapterEnhancer(
      axios.defaults.adapter,
      { enabledByDefault: false }
    ),
  })
}