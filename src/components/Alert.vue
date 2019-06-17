<template>
  <div class="text-xs-center">
    <v-menu
      v-model="menu"
      :close-on-content-click="false"
      class="elevation-1"
      :nudge-bottom="30"
      offset-x
    >
    <v-divider
        class="mx-3"
        inset
        vertical
      ></v-divider>
      <template v-slot:activator="{ on }">
        <v-btn fab  flat v-on="on">
          <v-badge class="align-self-center" color="red" >
            <template v-slot:badge>
              <span>{{count_buys_of_user}}</span>
            </template>
            <v-icon>notifications</v-icon>
          </v-badge>
        </v-btn>
      </template>
      <v-card class="scroll-y elevation-0" width="320">
        <v-toolbar card dense color="transparent">
          <v-toolbar-title><h4>รายกายการขายสินค้า</h4></v-toolbar-title>
        </v-toolbar>
        <v-divider></v-divider>
    <v-card-text class="pa-0 "style="height: 360px">
      <v-list two-line class="pa-0">
        <template v-for="item in data_alert">
          <v-divider ></v-divider>
          <v-list-tile avatar>
            <v-list-tile-avatar>
                <v-img :src="require('../img_sell/'+item.sell_image)" dark style="cursor:pointer" width="50px" />
            </v-list-tile-avatar>
            <v-list-tile-content>
              <v-list-tile-sub-title class="c_red" v-html="item.sell_name"></v-list-tile-sub-title>
            <v-icon color="error" @click="show_detail_of_buys(item)">remove_red_eye</v-icon>
            </v-list-tile-content>
            <!-- <v-list-tile-action class="caption">
              {{item.timeLabel}}
            </v-list-tile-action> -->
          </v-list-tile>
        </template>
      </v-list>
        <!-- <v-divider></v-divider>
        <v-btn block flat class="ma-0" color="error">ล้างค่าการแจ้งเตือน</v-btn> -->
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
    </v-menu>

    <template>
      <v-layout row justify-center>
        <v-dialog v-model="dialog" width="600px" ><!-- persistent -->
          <template v-slot:activator="{ on }">
          </template>
          <v-card v-if="check_show_description">
            <v-card-title>
              <span class="headline">รายละเอียดสินค้าที่ขายออก</span>
            </v-card-title>
            <v-card-text>
              <center><v-img :src="require('../img_sell/'+showdetail.image_sell)" width="50%" height="100%"/></center>
              <h1><b class="c_blue">ชื่อสินค้า:</b> {{showdetail.sell_name}} </h1>
              <h2><b class="c_red">ราคาขาย:</b> {{showdetail.sell_price}} บาท</h2>
              <h3><b class="c_red">วันที่ลงขาย:</b> {{setDate(showdetail.date_start)}}</h3>
              <!-- <h3><b class="c_red">จำนวนทั้งหมด:</b> {{showdetail.number_all}}</h3> -->
              <h3><b class="c_blue">จำนวนที่ซื้อ:</b> {{showdetail.number_buy}}</h3>
              <h3><b class="c_red">จำนวนคงเหลือ:</b> {{showdetail.sell_number}}</h3>
              <h3><b class="c_blue">ชื่อผู้ซื้อสินค้า :</b> {{showdetail.fname}} {{showdetail.lname}}</h3>
              <h3><b class="c_blue">ที่อยู่ต้องการจัดส่ง:</b> {{showdetail.buys_address}}</h3>
              <h3><b class="c_blue">วันที่ซื้อ :</b> {{setDate(showdetail.date_buy)}}</h3>
              <h3><b class="c_blue">ราคารวม :</b> {{showdetail.total}} บาท</h3>
            </v-card-text>
            <!-- <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" flat="flat" @click="dialog = false">Disagree</v-btn>
              <v-btn color="green darken-1" flat="flat" @click="dialog = false">Agree</v-btn>
            </v-card-actions> -->
          </v-card>
        </v-dialog>
      </v-layout>
    </template>
  </div>
</template>
<script>
import moment from 'moment'
import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      check_show_description:false,
      dialog: false,
      fav: true,
      menu: false,
      message: false,
      hints: true,
      data:[],
      data_alert:[],
      count_buys_of_user : 0,
      show_detail:[]
    }),
    created(){
   this.showdata_sell_of_user()
 },
   methods:{
     showdata_sell_of_user(){
       if ($cookies.get('kidakarn')!=null){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         this.data = {username:this.placeInfo.data[0].username}
         this.axios.post(process.env.VUE_APP_URL+'/Alert_sell_user',this.data).then((result) =>{
           var data_of_get = result.data
           this.count_buys_of_user = data_of_get.length
           console.log('data_of_get.length',data_of_get.length);
           for (var i =0;i<data_of_get.length;i++){
             this.data_alert.push({
               bill_id: data_of_get[i]["bill_id"],
               buys_address:data_of_get[i]["buys_address"],
               buys_id: data_of_get[i]["buys_id"],
               buys_status:data_of_get[i]["buys_status"],
               date_buy: data_of_get[i]["date_buy"],
               date_start: data_of_get[i]["date_start"],
               description: data_of_get[i]["description"],
               fname:data_of_get[i]["fname"] ,
               groups_id: data_of_get[i]["groups_id"],
               lname: data_of_get[i]["lname"],
               number_buy:data_of_get[i]["number_buy"],
               password:data_of_get[i]["password"],
               phone:data_of_get[i]["phone"],
               sell_address:data_of_get[i]["sell_address"],
               sell_id:data_of_get[i]["sell_id"],
               sell_image: data_of_get[i]["sell_image"],
               sell_name: data_of_get[i]["sell_name"],
               sell_number:data_of_get[i]["sell_number"],
               sell_price:data_of_get[i]["sell_price"],
               status: data_of_get[i]["status"],
               user_address: data_of_get[i]["user_address"],
               user_id:data_of_get[i]["user_id"],
               user_image: data_of_get[i]["user_image"],
               username: data_of_get[i]["username"]
             })
           }
         })
       }
     },
     show_detail_of_buys(item){
       // console.log('item====>',item)
       this.check_show_description = true
       this.dialog = true
       this.showdetail = {
         image_sell:item.sell_image,
         sell_name:item.sell_name,
         sell_price:item.sell_price,
         date_start:item.date_start,
         fname:item.fname,
         lname:item.lname,
         number_buy:item.number_buy,
         buys_address:item.buys_address,
         sell_number:item.sell_number,
         date_buy:item.date_buy,
         total:item.sell_price * item.number_buy
       }
       // console.log('this>>>>>',this.showdetail)
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
<style media="screen">
.c_red{
  color:red
}
.c_blue{
  color:blue
}
</style>
