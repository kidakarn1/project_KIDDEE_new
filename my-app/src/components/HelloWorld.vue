<template>
  <v-container>
    <v-layout row wrap>
      <v-flex offset-xl2 xl8>
        <v-carousel>
         <v-carousel-item
           v-for="(item,i) in items"
           :key="i"
           :src="item.src"
         ></v-carousel-item>
       </v-carousel>
        <Menu/>
      </v-flex>
    </v-layout>
  </v-container>
</template>
<script>
import Menu from '@/components/Menu.vue'
import moment from 'moment'
  export default {
    components: {
      Menu,
    },
    data: () => ({
      items: [
         {
           src: '/img/1.jpg'
         },
         {
           src: 'https://www.lertmarketing.com/wp-content/uploads/2018/10/chinese-ecommerce-banner-2-800x400.png'
         },
         {
           src: 'https://revealsfunnel.com/wp-content/uploads/2019/02/mont_various_fpo.jpg'
         },
         {
           src: 'https://f.ptcdn.info/301/046/000/oe7koqcaiq30BaBGvwv-o.jpg'
         }
       ]
    }),
    created(){
      this.Cut_stock_buys()
    },
    methods:{
      Cut_stock_buys(){
        var date_pagubun = new Date()
        var year = date_pagubun.getFullYear()
        var mouth = date_pagubun.getMonth()
        var day = date_pagubun.getDate()
        mouth = mouth+1//เพราะเริ่ม index 0
        if (mouth <=9){
          mouth = "0"+mouth
        }
        if (day <=9){
          day = "0"+day
        }
        var pack = []
        pack = {year:year , mouth:mouth , day:day}
        console.log("FULL",date_pagubun+"ปี",year +"เดือน",mouth +"วัน",day)
        this.axios.post(process.env.VUE_APP_URL+'/Cut_stock_buys',pack).then((result) =>{
          var data = result.data
          if (result.status!=200){
            alert('in catch backend')
          }
        })
      },
      setDate (createAt) {
        moment.locale('th')
        var someDate = new Date(createAt)
        return moment(someDate).add(543, 'year', 7, 'hours').format('ll')
        // return moment(someDate).format('DD-MM-YYYY')date_start
      }
    }
  }
</script>
<style>
</style>
