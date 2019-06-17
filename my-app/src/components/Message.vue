<template>
  <div class="text-xs-center">
    <v-menu
      v-model="menu"

      class="elevation-1"
      :nudge-bottom="30"
      offset-x
    >
    <!-- :close-on-content-click="false" -->
    <v-divider class="mx-3" inset vertical ></v-divider>
      <template v-slot:activator="{ on }">
        <v-btn fab  flat v-on="on">
          <v-badge class="align-self-center" color="red" >
            <template v-slot:badge>
              <span>0</span>
            </template>
            <v-icon>sms</v-icon>
          </v-badge>
        </v-btn>
      </template>
      <v-card @click="connect_sell === true" class="scroll-y elevation-0" width="320" >
        <v-toolbar card dense color="transparent">
          <v-toolbar-title><h4>ติดต่อผู้ขายสินค้า</h4></v-toolbar-title>
        </v-toolbar>
        <v-divider></v-divider>
    <v-card-text class="pa-0 "style="height: 360px" >
      <v-list two-line class="pa-0">
        <template v-for="item in data_alert">
          <v-divider ></v-divider>
          <v-list-tile avatar @click="test(item.index)">
            <v-list-tile-avatar >
                <v-img :src="require('../user_image/'+item.user_image)" dark style="cursor:pointer" width="40px" />
            </v-list-tile-avatar>
            <v-list-tile-content>
              <v-list-tile-sub-title class="c_red" v-html="item.full_name"></v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>
        </template>
      </v-list>
    </v-card-text>
  </v-card>
    </v-menu>
    <template>
      <!-- <v-layout row wrap> -->
        <v-flex  xl12 >
            <v-card v-if="check_show_message"class="set_chat_message" width="320" >
              <v-flex  >
                <v-card color="primary">
                  <v-list-tile avatar >
                    <v-list-tile-avatar >
                        <v-img :src="require('../user_image/'+chat_message.user_image)" dark style="cursor:pointer" width="40px" />
                    </v-list-tile-avatar>
                    <v-list-tile-content>
                      <v-list-tile-sub-title v-html="chat_message.full_name">
                      </v-list-tile-sub-title>
                    </v-list-tile-content>
                    <v-icon color="error" @click="close()">clear</v-icon>
                  </v-list-tile>
                </v-card>
              </v-flex>
              <v-flex  xl12 >
              <v-card color="white" >
                <v-card-text class="  scroll-y  elevation-0 "style="height: 300px;">
                      <div v-for="item in chat_data" >
                        <v-flex :class="item.size_chat" ><br>
                        <v-tooltip bottom >
                           <template v-slot:activator="{ on }" >
                             <v-card :color="item.set_color"  max-width="120px">
                               <div color="primary"  v-on="on">
                                 <span  max-width="120px" style="color:white; border-radius: 25px; background-position: left top;" >
                                   <h3>
                                     <v-list-tile-avatar v-if="item.name_chat!='คุณ'" >
                                       <v-img  :src="require('../user_image/'+chat_message.user_image)" dark style="cursor:pointer"/>
                                     </v-list-tile-avatar>
                                   {{item.description}}
                                 </h3>
                                 </span>
                               </div>
                             </v-card>
                           </template>
                             <span><h5>{{setDate(item.delivery_day)}}</h5></span>
                         </v-tooltip>
                      </v-flex>
                    </div>
                </v-card-text>
              </v-card>
                <v-card color="primary" >
                  <v-list-tile avatar>
                    <v-text-field
                    height="50px"
                    v-model="description"
                    color="white"
                    placeholder="พิมพ์ข้อความ"
                    clearable
                  ></v-text-field>
                      <!-- <h1 color="red"><v-text-field id = "name" v-model="description" label="พิมพ์ข้อความ"></v-text-field></h1> -->
                    <v-btn  flat fab left @click="sender()"><v-icon color="white">send</v-icon></v-btn>
                  </v-list-tile>
                </v-card>
              </v-flex>
            <!-- <v-btn block flat class="ma-0" color="error" @click="close()">close</v-btn> -->
        </v-card>
        </v-flex>
      <!-- </v-layout> -->
    </template>
  </div>
</template>
<script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.0.4/socket.io.js" charset="utf-8"></script>
<script src="socket-lib/socket.io.js"></script>
<script type="text/javascript" charset="utf-8">
import moment from 'moment'
import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      time_clock: null,
      chat_data:[],
      data_chat:[],
      recipient:null,
      data:[],
      description:null,
      user:null,
      chat_message :[],
      connect_sell:false,
      check_show_message:false,
      check_show_description:false,
      dialog: false,
      fav: true,
      menu: false,
      message: false,
      hints: true,
      data_alert:[],
      count_buys_of_user : 0,
      show_detail:[]
    }),
    created(){
   this.showdata_sell_of_user()
   // this.startTime()
  },
  filters:{
    sub(string){
        return (string.substring(0,5).innerHTML("<br>"))
    }
  },
   methods:{
    //  startTime() {
    //     var today = new Date();
    //     var h = today.getHours();
    //     var m = today.getMinutes();
    //     var s = today.getSeconds();
    //     m = this.checkTime(m);
    //     s = this.checkTime(s);
    //     var check = s+3
    //     if (s!=check){
    //       this.show_chat_data()
    //     }
    //     // console.log('default===>',s +'new_time3======>',check);
    //     this.time_clock = h + ":" + m + ":" + s;
    //     var t = setTimeout(this.startTime, 500);
    //   },
    // checkTime(i) {
    //   if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
    //   return i;
    // },
     test(index){
       this.chat_message = {
        username   :this.data_alert[index].username,
        full_name :this.data_alert[index].full_name,
        user_image:this.data_alert[index].user_image
        }
        this.recipient = this.chat_message.username
        this.check_show_message=true
        console.log('data====>',this.chat_message);
        this.show_chat_data()
     },
     show_chat_data(){
       if ($cookies.get('kidakarn')!=null){
         this.chat_data = []
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         this.data = {
           sender:this.placeInfo.data[0].username,
           recipient:this.recipient
         }
         console.log('this.data===>',this.data);
         this.axios.post(process.env.VUE_APP_URL+'/show_chat_data',this.data).then((result) =>{
         var data = result.data
         if (result.status===200){
           for (var i = 0; i < data.length; i++) {
             this.chat_data.push({
               index:i,
               chat_id: data[i]["chat_id"],
               sender: data[i]["sender"],
               description: data[i]["description"],
               recipient: data[i]["recipient"],
               delivery_day: data[i]["delivery_day"],
               name_chat:'',
               size_chat:null,
               set_color:'blue'
             })
             if ($cookies.get('kidakarn')!=null){
               this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
                 if (this.chat_data[i].sender===this.placeInfo.data[0].username){
                    this.chat_data[i].name_chat = 'คุณ'
                    this.chat_data[i].set_color = 'primary'
                    this.chat_data[i].size_chat = 'offset-xs6 xs6'
                }
                else {
                    this.chat_data[i].name_chat = this.chat_data[i].sender
                    this.chat_data[i].set_color = '#616161'
                    this.chat_data[i].size_chat = 'xs6'
                }
             }
           }
           console.log('ออก===>',this.chat_data)
         }
     })
   }
     },
     sender(){
       if (this.description!=null){
         console.log(this.description.length);
         var start=0,cuts=12
         var res = this.description
         var des_tring = ''
         for (var i = 0; i <this.description.length; i++) {
           if (this.description.length>=12){
             var res = this.description.substring(start,cuts);
              console.log('this.description====>',res);
             start= start+12
             cuts = cuts+12
           }
           des_tring += res+"\n"
         }
         this.description = des_tring
         console.log('des_tring====>'+des_tring);
       if ($cookies.get('kidakarn')!=null){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         this.data = {
           sender:this.placeInfo.data[0].username,
           description:this.description,
           recipient:this.recipient
         }
         console.log('data_sen==>',this.data);
         this.axios.post(process.env.VUE_APP_URL+'/sender_Chat',this.data).then((result) =>{
           var data = result.data
           if (result.status===200){
             this.show_chat_data()
             this.description = ''
             console.log('data===>',data)
           }
       })
     }
   }
     },
     showdata_sell_of_user(){
       if ($cookies.get('kidakarn')!=null){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         this.data = {username:this.placeInfo.data[0].username}
         this.axios.get(process.env.VUE_APP_URL+'/test').then((result) =>{
           var data_of_get = result.data
           this.count_buys_of_user = data_of_get.length
           console.log('data_of_get.length',data_of_get.length);
           for (var i =0;i<data_of_get.length;i++){
             this.data_alert.push({
               index:i,
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
               username: data_of_get[i]["username"],
               full_name:data_of_get[i]["fname"] + ' '+data_of_get[i]["lname"]
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
     },
     close(){
       this.check_show_message=false
       console.log('close');
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
.set_chat_message{
   margin-top: 1320px;
  /* margin-top: 1320px; */
  /* border: 1px solid #4CAF50; */
}
</style>
