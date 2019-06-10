import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Main from '@/components/HelloWorld.vue'
import Table from '@/components/Table.vue'
import Table2 from '@/components/Table2.vue'
import Login from '@/components/Login.vue'
import Image from '@/components/Image.vue'
import Menu from '@/components/Menu.vue'
import Menu_dropdown from '@/components/Menu_dropdown.vue'
import Description from '@/components/Description.vue'
import Test from '@/components/Test.vue'
import Index from '@/components/Index.vue'
import Check_purchase from '@/components/Check_purchase.vue'
import Manage_user from '@/components/Manage_user.vue'
import Manage_sell from '@/components/Manage_sell.vue'
import Manage_buys from '@/components/Manage_buys.vue'
import Manage_cat from '@/components/Manage_cat.vue'
import Manage_groups from '@/components/Manage_groups.vue'
import Bill from '@/components/Bill.vue'
import Print_bill from '@/components/Print_bill.vue'
import Address from '@/components/Choose_an_address.vue'
import Register from '@/components/Register_user.vue'
import Alert from '@/components/Alert.vue'
import Test2 from '@/components/Test2.vue'
import Cut_stock from '@/components/Cut_stock.vue'
import Search from '@/components/Search.vue'
Vue.use(Router)
export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {path: '/Menu_dropdown',name: 'Menu_dropdown',component: Menu_dropdown},
    {path: '/Main',name: 'Main',component: Main},
    {path: '/home',name: 'home',component: Home},
    {path: '/table',name: 'Table',component: Table},
    {path: '/table2',name: 'Table2',component: Table2},
    {path: '/',name: 'Login',component: Login},
    {path: '/image',name: 'Image',component: Image},
    {path: '/Menu',name: 'Menu',component: Menu},
    {path: '/Test',name: 'Test',component: Test},
    {path: '/des/:id',name: 'Description',component: Description},
    {path: '/Index',name: 'Index',component: Index},
    {path: '/Check',name: 'Check_purchase',component: Check_purchase},
    {path: '/Manage_user',name: 'Manage_user',component: Manage_user},
    {path: '/Manage_sell',name: 'Manage_sell',component: Manage_sell},
    {path: '/Manage_buys',name: 'Manage_buys',component: Manage_buys},
    {path: '/Manage_cat',name: 'Manage_cat',component: Manage_cat},
    {path: '/Manage_groups',name: 'Manage_groups',component: Manage_groups},
    {path: '/Bill',name: 'Bill',component: Bill},
    {path: '/Print_bill',name: 'Print_bill',component: Print_bill},
    {path: '/Address',name: 'Address',component: Address},
    {path: '/Register',name: 'Register',component: Register},
    {path: '/Alert',name: 'Alert',component: Alert},
    {path: '/Test2',name: 'Test2',component: Test2},
    {path: '/Cut_stock',name: 'Cut_stock',component: Cut_stock},
    {path: '/Search',name: 'Search',component: Search},
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    }
  ]
})
