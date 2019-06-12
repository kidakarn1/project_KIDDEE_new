import Vue from 'vue'
import Vuetify from 'vuetify'
import './plugins/vuetify'
import App from './App.vue'
import router from './router'
import store from './store'
import './registerServiceWorker'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VueSwal from 'vue-swal'
import VueCookies from 'vue-cookies'
import VueJwtDecode from 'vue-jwt-decode'
import VueSweetalert2 from 'vue-sweetalert2'
// Vue.use(require('vue-moment'))
import JsonExcel from 'vue-json-excel'
import excel from 'vue-excel-export'
Vue.use(excel)
Vue.component('downloadExcel', JsonExcel)
Vue.use(VueSweetalert2);
Vue.use(VueCookies)
Vue.use(VueSwal)
Vue.use(VueAxios, axios)
Vue.config.productionTip = false
// import VueMoment from 'vue-moment'

// Vue.use(VueMoment, {
//     moment,
// })
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
