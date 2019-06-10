<template lang="html">
  <div>
      <v-container grid-list-xs>
          <v-toolbar flat color="white">
            <v-toolbar-title>รายละเอียดสินค้า</v-toolbar-title>
            <v-divider class="mx-2" inset vertical>
            </v-divider>
            <v-spacer></v-spacer>
            <v-dialog v-model="dialog" max-width="500px">
              <template v-slot:activator="{ on }">
                    <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                <!-- <v-btn color="primary" dark class="mb-2" v-on="on">เพิ่มข้อมูล</v-btn> -->
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                  <v-container grid-list-md>
                    <v-layout wrap>
                      <v-flex xs12 sm6 md12>
                        <center><v-img :src="require('../img_sell/'+'a.jpg')" width="50%" height="100%"/></center>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.lname" label="นามสกุล"></v-text-field>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.username" label="ชื่อผู้ใช้"></v-text-field>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.password" label="รหัสผ่าน"></v-text-field>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.status" label="สถานะ"></v-text-field>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
                  <v-btn color="blue darken-1" flat @click="save">Save</v-btn>
                  <v-btn color="blue darken-1" flat @click="update_data(editedItem.user_id)">Update</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
          <v-data-table :headers="headers" :items="result" :loading="check_load" :search="search" class="elevation-1">
            <template v-slot:items="props">
              <td>
                <v-img :src="require('../img_sell/'+props.item.sell_image)" width="50%" height="100%"/>
              </td>
              <td>{{ props.item.sell_name }}</td>
              <td>
              <v-btn fab small outline color="error"  @click="del_number(props.item.key_index)">-</v-btn>
              {{ props.item.number_buy }}
              <v-btn small fab outline color="primary" @click="plus_number(props.item.key_index)">+</v-btn>
              </td>
              <td>{{ props.item.sell_price }}</td>
              <td>{{ props.item.sum }}</td>
              <td><p style="color:red;">{{ setDate(props.item.buys_expired_date) }}</p></td>
              <td class="justify-center layout px-0">
                <!-- <v-icon small class="mr-2" @click="editItem(props.item)">
                  edit
                </v-icon> -->
                <v-icon  slot="activator" @click="deleteItem(props.item.buys_id,props.item.number_buy,props.item.sell_id )">delete
                </v-icon>
              </td>
            </template>
            <template v-slot:no-results>
              <v-alert :value="true" color="error" icon="warning">
                Your search for "{{ search }}" found no results.
              </v-alert>
            </template>
          </v-data-table>
          <v-flex offset-lg10>
            <table border="1" bgcolor="#FFFFFF">
              <tr>
                <td>
                    <h3>สินค้าที่จัดส่งทั้งหมด {{this.number_total}} ชิ้น</h3>
                </td>
                <td><h3>ยอดรวมทั้งหมด {{this.Net_amount}} บาท</h3></td>
              </tr>
            </table>
          </v-flex>
          <v-flex offset-xs5  v-if="number_in_cart > 0 ">
            <v-btn  color="success" @click="check_Address()">สั่งซื้อ</v-btn>
          </v-flex>
        <!-- <Loading ref="Loading"></Loading> -->
        </v-container>
        <v-dialog v-model="isLoading" persistent max-width="300px" class="pa-5">
          <v-card class="center-x center-y pa-5" flat transparent>
            <v-layout row wrap justify-center align-center>
              <v-flex xs12 class="center-x mb-2 text-xs-center">
                <v-progress-circular :size="widthscreen" width="10" color="success" indeterminate></v-progress-circular>
              </v-flex>
                <v-flex xs12 class="center-x text-xs-center"><b style="font-size:20px;" >กรุณารอสักครู่</b></v-flex>
            </v-layout>
          </v-card>
        </v-dialog>
    </div>
</template>
<script>
import { Encode, Decode } from '@/service'
import moment from 'moment'
export default {
  data: () => ({
    username:'',
     search: '',
     number_in_cart:0,
     number_total:0,
     Net_amount:0,
     check_query_image:false,
     result:[],
     check_load:true,
     isLoading:false,
     request:[],
     dialog: false,
     // title_name_insert:['ชื่อ','นามสกุล','username','password'],
     headers: [
       {text:'รูปสินค้า',value:'sell_image'},
       { text: 'ชื่อสินค้า', value: 'fname' },
       { text: 'จำนวน', value: 'lname' },
       { text: 'ราคา/ชิ้น', value: 'sell_number' },
       { text: 'ราคารวม', value: 'password' },
       { text: 'วันหมดอายุของสินค้า', value: 'buys_expired_date' },
       { text: 'จัดการสินค้า', value: 'status', sortable: false }
     ],
     desserts: [],
     editedIndex: -1,
     editedItem: {
       fname: '',
       lname: '',
       username: '',
       password: '',
       status:'',
       sell_id:''
     },
     defaultItem: {
       fname: '',
       lname: '',
       username: '',
       password: '',
       status: '',
       sell_id:''
     }
   }),

   computed: {
     formTitle () {
       return this.editedIndex === -1 ? 'เพิ่มข้อมูล' : 'แก้ไขข้อมูล'
     },
     widthscreen () {
       var n = 0
       if (this.$vuetify.breakpoint.width >= 300) {
         n = 170
       }
       return n
     }
   },

   watch: {
     dialog (val) {
       val || this.close()
     }
   },

   created () {
     this.show_data()
     this.check_cart()
   },

   methods: {
     show_data(){
       var x = this.$cookies.get('kidakarn')
          if (x==null){this.$router.push('/')}
       else {
         this.openLoading()
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         var username = {user:this.placeInfo.data[0].username}
         this.username = this.placeInfo.data[0].username
         this.axios.get(process.env.VUE_APP_URL+'/show_user_buys/'+username.user).then((result) => {
         this.hideLoading()
          var data = result.data
          console.log('data=======',data)
          var total_number = 0
          for(var i=0; i<data.length;i++){
            this.result.push({
            key_index    :i,
            buys_id      : data[i]["buys_id"],
            date_buy     : data[i]["date_buy"],
            date_start   : data[i]["date_start"],
            description  : data[i]["description"],
            groups_id    : data[i]["groups_id"],
            number_buy   : data[i]["number_buy"],
            sell_address : data[i]["sell_address"],
            sell_id      : data[i]["sell_id"],
            sell_image   : data[i]["sell_image"],
            sell_name    : data[i]["sell_name"],
            sell_number  : data[i]["sell_number"],
            sell_price   : data[i]["sell_price"],
            status       : data[i]["status"],
            username     : data[i]["username"],
            buys_expired_date : data[i]["buys_expired_date"],
            sum          : data[i]["number_buy"]*data[i]["sell_price"],
            default_number_sell: data[i]["number_buy"]+data[i]["sell_number"]
            })
            this.Net_amount+=this.result[i].sum
            this.number_total+=this.result[i].number_buy
            // total_number=this.result[0].total
          }
          // total_number = this.result.data.sum + this.result.data.sum
          this.check_query_image = true
          this.check_load = false
        })
       }
     },
     check_cart(){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         var username = this.placeInfo.data[0].username
         this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+username).then((count) => {
           var data = count.data[0].count_buy_id
           this.number_in_cart = data
           console.log('this.number_in_cart====',this.number_in_cart)
         })
     },
     check_Address(){
       if ($cookies.get('kidakarn') != null){
         this.$router.push('/Address')
         // this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         // var username = this.placeInfo.data[0].username
         // this.axios.get(process.env.VUE_APP_URL+'/Buys/'+username).then((result) => {
         //  var data = result.data
         //    this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+username).then((count) => {
         //      var emptoken_count = Encode.encode(count)
         //      this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
         //    })
         //   if (result.status===200){
         //     alert('ซื้อสำเร็จ')
         //     window.location.href='/Bill'
         //   }
         // })
       }
     },
     openLoading () {
       // this.$refs.Loading.open()
       this.isLoading = true
       // console.log('open');
     },
     hideLoading () {
       // this.$refs.loading.hide()
       this.isLoading = false
       // console.log('hide');
     },
     initialize () {
       this.desserts = [
         {
           name: 'Frozen Yogurt',
           calories: 159,
           fat: 6.0,
           carbs: 24,
           protein: 4.0
         },
         {
           name: 'Ice cream sandwich',
           calories: 237,
           fat: 9.0,
           carbs: 37,
           protein: 4.3
         },
         {
           name: 'Eclair',
           calories: 262,
           fat: 16.0,
           carbs: 23,
           protein: 6.0
         },
         {
           name: 'Cupcake',
           calories: 305,
           fat: 3.7,
           carbs: 67,
           protein: 4.3
         },
         {
           name: 'Gingerbread',
           calories: 356,
           fat: 16.0,
           carbs: 49,
           protein: 3.9
         },
         {
           name: 'Jelly bean',
           calories: 375,
           fat: 0.0,
           carbs: 94,
           protein: 0.0
         },
         {
           name: 'Lollipop',
           calories: 392,
           fat: 0.2,
           carbs: 98,
           protein: 0
         },
         {
           name: 'Honeycomb',
           calories: 408,
           fat: 3.2,
           carbs: 87,
           protein: 6.5
         },
         {
           name: 'Donut',
           calories: 452,
           fat: 25.0,
           carbs: 51,
           protein: 4.9
         },
         {
           name: 'KitKat',
           calories: 518,
           fat: 26.0,
           carbs: 65,
           protein: 7
         }
       ]
     },
     editItem (item) {
       this.editedIndex = this.desserts.indexOf(item)
       this.editedItem = Object.assign({}, item)
       this.dialog = true
     },
     update_data (para){
       var pack_update =
         {
          user_id:this.editedItem.user_id,
          fname: this.editedItem.fname,
          lname: this.editedItem.lname,
          username: this.editedItem.username,
          password: this.editedItem.password,
          status: this.editedItem.status
         }
         console.log(pack_update);
       this.axios.post(process.env.VUE_APP_URL+'/update_data',pack_update).then((result) =>{
          alert("Updatสำเร็จ");
       }).catch((err) => {
         console.log('2', err.result);
         alert("Updateไม่สำเร็จ");
       })
     },
     deleteItem (item,number,sell_id) {
       console.log('item');
       var conn= confirm('Are you sure you want to delete this item?')
       if (conn==false){console.log("ไม่ลบ");}
       else{
         this.axios.get(process.env.VUE_APP_URL+'/delete_buys/'+item+'/'+number+'/'+sell_id).then((result) => {
           this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+this.username).then((count) => {
             this.$cookies.remove('number_user_buy')
             var emptoken_count = Encode.encode(count)
             this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
           })
           console.log('result =====',result.data);
             alert('ลบสำเร็จ');
             window.location.href='/Check'
         }).catch((err) => {
           console.log('2', err.result);
           alert("ลบไม่สำเร็จ");
         })
       }
     },
     close () {
       this.dialog = false
       setTimeout(() => {
         this.editedItem = Object.assign({}, this.defaultItem)
         this.editedIndex = -1
       }, 300)
     },
     save () {
       console.log(name);
           if (this.editedItem.fname===''){
               this.$swal('กรุณาใส่ชื่อ ! ', '', 'warning')
           }
           else if (this.editedItem.lname==='') {
             this.$swal('กรุณาใส่นามสกุล ! ', '', 'warning')
           }
           else if (this.editedItem.username==='') {
             this.$swal('กรุณาใส่ชื่อผู้ใช้ ! ', '', 'warning')
           }
           else if (this.editedItem.password==='') {
             this.$swal('กรุณาใส่รหัสผ่าน ! ', '', 'warning')
           }
           else if (this.editedItem.status==='') {
             this.$swal('กรุณาใส่สถานะ ! ', '', 'warning')
           }
           else {
           this.request =
             {
              fname: this.editedItem.fname,
              lname: this.editedItem.lname,
              username: this.editedItem.username,
              password: this.editedItem.password,
              status: this.editedItem.status
             }
             console.log(this.request);
           this.axios.post(process.env.VUE_APP_URL+'/add_data',this.request).then((result) =>{
             var data = result.data
             if (data===200){
                this.$swal('บันทึกสำเร็จ ! ', '', 'success')
             }
             else if (data===150) {
                this.$swal('usernameนี้มีการใช้งานแล้ว ! ', '', 'error')
             }
             console.log("result=====",result);
           }).catch((err) =>{
             console.log(err);
           })
           // if (this.editedIndex > -1) {
           //   Object.assign(this.desserts[this.editedIndex], this.editedItem)
           // } else {
           //   this.desserts.push(this.editedItem)
           // }
           this.close()
         }
      },
      plus_number(index){
        if (this.result[index].number_buy < this.result[index].default_number_sell){
            this.result[index].number_buy++
            this.result[index].sum = this.result[index].number_buy * this.result[index].sell_price
            this.Net_amount+=this.result[index].sell_price
            this.number_total++
            this.update_sell_and_buys(index,'plus')
        }
        else{
          this.$swal('ขออภัย คุณสามารถซื้อสินค้าชิ้นนี้ได้ไม่เกินตามจำนวนที่กำหนด', '', 'warning')
        }
        // console.log(this.result[0].number_buy);
      },
      del_number(index){
        if (this.result[index].number_buy>1){
              this.result[index].number_buy--
              this.result[index].sum = this.result[index].number_buy * this.result[index].sell_price
              this.Net_amount-=this.result[index].sell_price
              this.number_total--
              this.update_sell_and_buys(index,'del')
            // console.log('----====',this.get_sell[index].buy_number);
        }
      },
      setDate (createAt) {
        moment.locale('th')
        var someDate = new Date(createAt)
        return moment(someDate).add(543, 'year', 7, 'hours').format('ll')
        // return moment(someDate).format('DD-MM-YYYY')date_start
      },
      update_sell_and_buys(index,event_status){
        var pack=[]
        Date.prototype.addDays = function(days) {
        var date = new Date(this.valueOf());
        date.setDate(date.getDate() + days);
        return date;
        }
        var date = new Date();
        var buys_expired_date = date.addDays(5)
        if (this.$cookies.get('kidakarn')!=null){
             this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
                pack = {
                sell_id:this.result[index].sell_id,
                username:this.placeInfo.data[0].username,
                number_buy:this.result[index].number_buy,
                event_status:event_status,
                buys_expired_date:buys_expired_date
              }
                this.axios.post(process.env.VUE_APP_URL+'/update_sell_and_buys_plus',pack).then((result) =>{
                  var data = result.data
                  // this.result[index].default_number_sell--
                  // // this.result[index].default_number_sell =
                  // console.log('database_sell_number',data);
                  // console.log('ค่าปัจจุบัน',this.result[index].number_buy);
                  // console.log('check_if',this.result[index].default_number_sell);
                })
              console.log('pack====',pack)
          }
      }
   }
}
</script>
<style lang="css" scoped>
</style>
