<template>
    <div>
      <v-container grid-list-xs>
            <v-flex offset-sm1  xs12 sm10 offset-lg0 lg12 >
              <v-card  color="white darken-3" dark  :clipped-left="$vuetify.breakpoint.mdAndUp">
                <v-card-title primary-title>
                  <!-- <v-item-group>
                     <v-item>
                         <v-btn  slot-scope="{ active, toggle }" :color="active ? 'success' : 'primary'" class="d-flex align-center" dark height="200" @click="toggle">ทั้งหมด</v-btn>
                         <v-scroll-y-transition>
                           <div v-if="active" class="display-3 text-xs-center" >
                             Active
                           </div>
                         </v-scroll-y-transition>
                     </v-item>
                   </v-item-group> @click="get_para($route.params.id)"    get_data_of_group(item.groups_id);-->
                   <v-item-group>
                     <v-layout wrap>
                          <v-flex>
                            <v-item>
                              <v-btn :color="color_btn_all" @click="set_color_index($route.params.id)" >ทั้งหมด</v-btn>
                             </v-item>
                            <!-- <v-item v-if="check_btn_all=false">
                              <v-btn color="primary" @click="get_para($route.params.id)" >ทั้งหมด</v-btn>
                             </v-item> -->
                       </v-flex>
                       <v-flex v-for="item in groups">
                         <v-item>
                          <v-btn :color="item.color" @click="get_data_of_group(item.index,item.groups_id)">{{item.groups_name}}</v-btn>
                         </v-item>
                       </v-flex>
                     </v-layout>
                    </v-item-group>
                </v-card-title>
              </v-card>
              <v-flex  offset-xs0 offset-sm4 offset-md7  offset-lg0 xs11 sm12 md12 lg12>
                <Search @test="Search_sell"></Search>
                <!-- <Message/> -->
              </v-flex>
            </v-flex>
      </v-container>
      <div lg1>

        <v-layout row wrap class="container container-fluid">
          <v-flex v-for="(item,index) in get_sell":key="index" xs12 sm6 md4  lg4 xl3 >
            <v-container >
              <v-hover >
                <v-card  slot-scope="{ hover }" :class="`elevation-${hover ? 12 : 2} cursor1`" >

                    <!-- /============================================== -->
                    <v-container >

                      <v-img style="margin-left: 20%" :src="require('../img_sell/'+item.sell_image)" width="60%" height="200px" />
                    </v-container>
                    <v-container >
                  <v-card-title primary-title>
                  </v-card-title>
                    <v-card-actions>
                      <!-- <v-text-field type="number"></v-text-field> -->
                      <h2>
                        <b class="c_blue" style="font-family: 'Kanit', sans-serif;">ราคา</b> {{item.sell_price}} บาท
                      </h2>
                    </v-card-actions>
                    <v-flex xs12>
                      <h2>
                       <b class="c_green" style="font-family: 'Kanit', sans-serif;">จำนวนที่ถูกขาย</b> {{item.max_product}} ชิ้น
                      </h2>
                      <h2>
                       <b class="c_red" style="font-family: 'Kanit', sans-serif;">สินค้าชิ้นนี้มีจำนวนจำกัด</b> {{item.sell_number}} ชิ้น
                      </h2>
                      <v-flex xs12>
                        <h3 style="font-family: 'Kanit', sans-serif;"> หัวข้อ: {{item.sell_name}}</h3>
                      </v-flex>
                      </v-flex>
                      <v-flex xs12 text-xl-center>
                        <v-btn fab small outline color="error"  @click="del_number(index)">-</v-btn>{{item.buy_number}}
                        <v-btn small fab outline color="primary" @click="plus_number(index)">+</v-btn>
                      </v-flex>
                      <v-flex xs12  text-xl-center text-md-center >
                        <v-btn small color="success" dark style="font-family: 'Kanit', sans-serif; font-size:17px" @click="Buy_now(item.sell_id,item.buy_number)">ซื้อ</v-btn>
                        <v-btn small color="primary" dark style="font-family: 'Kanit', sans-serif; font-size:16px" @click="description(item)">รายละเอียด</v-btn>
                        <v-btn small color="warning" dark style="font-family: 'Kanit', sans-serif; font-size:17px" @click="Cart(item.sell_id,item.buy_number)">ใส่ตระกร้า</v-btn>
                      </v-flex>
                  </v-container>
                </v-card>
              </v-hover>
            </v-container>
          </v-flex>
      </v-layout>
    </div>

        <template>
          <v-layout row justify-center>
            <v-dialog v-model="dialog" width="600px" ><!-- persistent -->
              <template v-slot:activator="{ on }">
              </template>
              <v-card v-if="check_description">
                <v-card-title>
                  <span class="headline">รายละเอียดสินค้า</span>
                </v-card-title>
                <v-card-text>
                  <center><v-img :src="require('../img_sell/'+detail.image)" width="50%" height="100%"/></center>
                  <h1><b class="c_red">ราคา:</b> {{detail.price}} บาท</h1>
                  <h3><b class="c_red">รายละเอียด:</b> {{detail.description}}</h3>
                  <h3><b class="c_blue">ที่อยู่ติดต่อ:</b> {{detail.address}}</h3>
                  <h3><b class="c_blue">ผู้ลงประกาศขาย :</b> {{detail.fname}} {{detail.lname}}</h3>
                  <h3><b class="c_blue">เบอร์โทรศัพท์ผู้ติดต่อ :</b> {{detail.phone}}</h3>
                  <h3><b class="c_blue">วันที่ลงขาย :</b> {{detail.date_start}}</h3>
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
import Message from '@/components/Message.vue'
import Search from '@/components/Search'
import { Encode, Decode } from '@/service'
export default {
  components: {
    Search,
    Message
  },
  data: () => ({
    color_btn_all:"success",
    index_color:-1,
    check_btn_get_groups:true,
    buy_number:[],
    check_description:false,
    detail: [],
    dialog: false,
    get_sell:[],
    groups:[],
    groups1:[]
      }),
  created(){
      this.get_name_groups(),
      this.get_para(this.$route.params.id)
  },
  methods:{
    testalert(){
      alert("123456")
    },
    set_color_index(reload){
      this.color_btn_all = "success"
      for (var i = 0; i <this.groups.length; i++) {
        this.groups[i].color="primary"
        // console.log(this.groups[i]);
      }
      console.log("=====>",this.groups.length);
      this.get_para(reload)
    },
    get_para(item_para){
      this.get_sell = []
      this.axios.get(process.env.VUE_APP_URL+'/getdata_sell/'+item_para).then((result) => {
        var data = result.data
        for (var i = 0; i < data.length; i++) {
          this.get_sell.push({
            sell_id:data[i]["sell_id"],
            sell_name:data[i]["sell_name"],
            username:data[i]["username"],
            sell_image:data[i]["sell_image"],
            sell_address:data[i]["sell_address"],
            sell_price:data[i]["sell_price"],
            description:data[i]["description"],
            groups_name:data[i]["groups_name"],
            fname:data[i]["fname"],
            lname:data[i]["lname"],
            phone:data[i]["phone"],
            date_start:data[i]["date_start"],
            sell_number:data[i]["sell_number"]-1,
            check_number_plus_del:data[i]["sell_number"],
            max_product:0,
            buy_number:1,
          })
          this.get_max_sell_of_buys(this.get_sell[i].sell_id,i)
        }
        var check_cookie_data = Encode.encode(result)
        this.$cookies.set('cookie_data', check_cookie_data, null, '/', process.env.CK)
        console.log('url=====',this.$router.currentRoute.name);
      })
    },
    Search_sell(search_name){
      if (search_name===null){
        this.get_para(this.$route.params.id)
      }
      console.log('search_name===>',search_name);
      this.get_sell = []
      this.axios.get(process.env.VUE_APP_URL+'/Search_sell/'+search_name).then((result) => {
        var data = result.data
        for (var i = 0; i < data.length; i++) {
          this.get_sell.push({
            description:data[i]["description"],
            groups_id:data[i]["groups_id"],
            sell_address:data[i]["sell_address"],
            sell_id:data[i]["sell_id"],
            sell_image:data[i]["sell_image"],
            sell_name:data[i]["sell_name"],
            sell_price:data[i]["sell_price"],
            username:data[i]["username"],
            fname:data[i]["fname"],
            lname:data[i]["lname"],
            phone:data[i]["phone"],
            date_start:data[i]["date_start"],
            sell_number:data[i]["sell_number"],
            max_product:0,
            buy_number:1
          })
          this.get_max_sell_of_buys(this.get_sell[i].sell_id,i)
        }
      })
    },
    plus_number(index){
      if (this.get_sell[index].buy_number < this.get_sell[index].check_number_plus_del){
        this.get_sell[index].buy_number++
        this.get_sell[index].sell_number--

      }
      else{
        this.$swal('ขออภัย คุณสามารถซื้อสินค้าชิ้นนี้ได้ไม่เกินตามจำนวนที่กำหนด', '', 'warning')
      }
      // console.log(this.get_sell[index].buy_number);
    },
    del_number(index){
      if (this.get_sell[index].buy_number>1){
            this.get_sell[index].buy_number--
            this.get_sell[index].sell_number++
          // console.log('----====',this.get_sell[index].buy_number);
      }
    },
    get_name_groups(){
      this.axios.get(process.env.VUE_APP_URL+'/get_name_groups/'+this.$route.params.id).then((result) => {
        var data = result.data
        for (var i = 0; i < data.length; i++) {
          this.groups.push({
            index:i,
            color:"primary",
            groups_id:data[i]["groups_id"],
            groups_name:data[i]["groups_name"],
            cat_id:data[i]["cat_id"]
          })
        }
      })
    },
    get_data_of_group(index,group_id){
      this.color_btn_all = "primary"
      for (var i = 0; i <this.groups.length; i++) {
        this.groups[i].color="primary"
        // console.log(this.groups[i]);
      }
        this.groups[index].color="success"
      // console.log("index===>",index);
      // console.log("this.check_btn_all===>",this.check_btn_all);
      // console.log("this.active===>",this.active);

      this.get_sell=[]
      this.axios.get(process.env.VUE_APP_URL+'/get_data_sell_of_groups/'+group_id).then((result) => {
        var data = result.data
        for (var i = 0; i < data.length; i++) {
          this.get_sell.push({
            description:data[i]["description"],
            groups_id:data[i]["groups_id"],
            sell_address:data[i]["sell_address"],
            sell_id:data[i]["sell_id"],
            sell_image:data[i]["sell_image"],
            sell_name:data[i]["sell_name"],
            sell_price:data[i]["sell_price"],
            username:data[i]["username"],
            fname:data[i]["fname"],
            lname:data[i]["lname"],
            phone:data[i]["phone"],
            date_start:data[i]["date_start"],
            sell_number:data[i]["sell_number"],
            max_product:0,
            buy_number:1
          })
          this.get_max_sell_of_buys(this.get_sell[i].sell_id,i)
          // console.log(this.get_sell[i].sell_id);
        }
        // var p =' /des/'+this.$route.params.id
        // window.location.href=p
      // console.log(this.get_sell);
      })
    },
    get_max_sell_of_buys(sell_id,index){
      console.log('sell_id==>',sell_id);
      this.axios.get(process.env.VUE_APP_URL+'/get_max_sell_of_buys/'+sell_id).then((result) => {
        var data = result.data
         if (data==="0"){
           console.log("ไม่มีการซื้อสินค้าชิ้นนี้");
        }
        else {
          this.get_sell[index].max_product = data
           // console.log("sell_id "+index+"===>",this.get_sell[index].max_product);
           // console.log('data===>',data);
        }
      })
    },
    description (a) {
      this.check_description=true
      var date_start = this.setDate(a.date_start)
      this.detail={
        description:a.description,
        price:a.sell_price,
        image:a.sell_image,
        address:a.sell_address,
        fname:a.fname,
        lname:a.lname,
        phone:a.phone,
        date_start:date_start
      }
      this.dialog = true
      // console.log('a ===', this.detail)
    },
    Cart(sell_id,number){
      Date.prototype.addDays = function(days) {
      var date = new Date(this.valueOf());
      date.setDate(date.getDate() + days);
      return date;
      }
      var date = new Date();
      var buys_expired_date = date.addDays(5)
      // alert(date.addDays(5));
      var pack=[]
      if (this.$cookies.get('kidakarn')!=null){
           this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
              pack = {
              sell_id:sell_id,
              username:this.placeInfo.data[0].username,
              number_buy:number,
              buys_expired_date:buys_expired_date
            }
            this.axios.post(process.env.VUE_APP_URL+'/cart',pack).then((result) =>{
              var data = result.data
              console.log('data=====',data)
              // this.$swal('ใส่รถเข็นแล้ว ', '', 'success')
                this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+pack.username).then((count) => {
                  var emptoken_count = Encode.encode(count)
                  this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
                  // this.$swal('ใส่ตระกร้าเรียบร้อย', '', 'success')
                  // get_para(this.$route.params.id)
                  var p =' /des/'+this.$route.params.id
                  window.location.href=p
                })
            })
            console.log('pack====',pack)
        }
        else{
          this.$swal('กรุณาเข้าสู่ระบบเพื่อจองสินค้า', '', 'warning')
        }
      // console.log('buy===',pack);
    },
    Buy_now(sell_id,number){
      Date.prototype.addDays = function(days) {
      var date = new Date(this.valueOf());
      date.setDate(date.getDate() + days);
      return date;
      }
      var date = new Date();
      var buys_expired_date = date.addDays(5)
      var pack=[]
      if (this.$cookies.get('kidakarn')!=null){
           this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
              pack = {
              sell_id:sell_id,
              username:this.placeInfo.data[0].username,
              number_buy:number,
              buys_expired_date:buys_expired_date
            }
            console.log('pack====>',pack);
            this.axios.post(process.env.VUE_APP_URL+'/cart',pack).then((result) =>{
              var data = result.data
              console.log('data=====',data)
              // this.$swal('ใส่รถเข็นแล้ว ', '', 'success')
                this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+pack.username).then((count) => {
                  var emptoken_count = Encode.encode(count)
                  this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
                  // this.$swal('ใส่ตระกร้าเรียบร้อย', '', 'success')
                  // get_para(this.$route.params.id)
                  var p =' ../Address'
                  window.location.href=p
                })
            })
            console.log('pack====',pack)
        }
        else{
          this.$swal('กรุณาเข้าสู่ระบบซื้อสินค้า', '', 'warning')
        }
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

<style lang="css" scoped>
.c_blue{
  color:blue
}
.c_green{
  color:green
}
.c_red{
  color:red
}
</style>
