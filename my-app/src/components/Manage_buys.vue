  <template lang="html">
    <div>
        <v-container grid-list-xs>
            <v-toolbar flat color="white">
              <v-toolbar-title>TABLE_BUYS</v-toolbar-title>
              <v-divider class="mx-2" inset vertical>
              </v-divider>
              <v-spacer>
                <v-btn color="primary" @click="show_data()"><v-icon>home</v-icon>ทั้งหมด</v-btn>
                <v-btn color="primary" @click="select_buys_from_status('B')"><v-icon>add_shopping_cart </v-icon> การซื้อสินค้า</v-btn>
                <v-btn color="primary" @click="select_buys_from_status('R')"><v-icon>shopping_basket</v-icon> สินค้าที่อยู่ในตระกร้า</v-btn>
              </v-spacer>
              <v-dialog v-model="dialog" persistent max-width="500px">
                <template v-slot:activator="{ on }">
                      <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                      <!-- <v-btn color="primary" dark class="mb-2" @click="set_btn('insert')" v-on="on" >เพิ่มข้อมูล</v-btn> -->
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ formTitle }}</span>
                  </v-card-title>
                  <v-card-text>
                    <v-container grid-list-md>
                      <v-layout wrap>
                        <v-flex xs12 sm6 md12>
                          <h3>ประเภท: {{editedItem.cat_name}}</h3>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          </h3>หมวด: {{editedItem.groups_name}}</h3>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                            </h3>หัวข้อในการลงขาย: {{editedItem.sell_name}}</h3>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                            </h3>ราคา/ชิ้น: {{editedItem.sell_price}}</h3>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                        </h3>ผู้ซื้อสินค้า: {{editedItem.fname}}  {{editedItem.lname}}</h3>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field type="number" v-model="editedItem.number_buy" label="จำนวนที่ซื้อ" min="1"></v-text-field>
                        </v-flex>
                        <v-flex id="dropdown-example" grid-list-xl xs12 sm6 md12>
                          <p>สถานะการซื้อ</p>
                          <v-overflow-btn :items="dropdown_font" label="สถานะ"  v-model="editedItem.buys_status" target="#dropdown-example" ></v-overflow-btn>
                        </v-flex>
                      </v-layout>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="error darken-1" flat @click="dialog = false">Cancel</v-btn>
                    <v-btn v-if="btn_save" color="success" flat @click="save">Save</v-btn>
                    <v-btn v-if="btn_update" color="blue darken-1" flat @click="update_data()">Update</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-toolbar>
            <v-data-table :headers="headers" :items="result" :loading="check_load" :search="search" class="elevation-1" :pagination.sync="pagination">
              <template v-slot:items="props" text-lg-center>
                <td>{{ props.item.buys_id }}</td>
                <td>
                  <v-img :src="require('../img_sell/'+ props.item.sell_image)" width="100px" />
                </td>
                <td>{{ props.item.sell_name }}</td>
                <td>{{ props.item.fname }}  {{ props.item.lname }}</td>
                <td>{{ props.item.sell_price }}</td>
                <td>{{ props.item.number_buy }}</td>
                <td>{{ props.item.price_total }}</td>
                <td>{{ setDate(props.item.date_buy) }}</td>
                <td>{{ props.item.buys_status }}</td>
                <td class="justify-center">
                  <v-icon medium class="mr-2" @click="editItem(props.item)">
                    edit
                  </v-icon>
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
  import moment from 'moment'
  import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      btn_save:true,
      btn_update:false,
      pagination: {
              sortBy: 'cat_id',
              rowsPerPage: 25
            },
      dropdown_font: ['R', 'B'],
      select: { groups_name: '', groups_id: '' },
      items: [],
      dropdown_icon: [
        { text: 'list', callback: () => console.log('list') },
        { text: 'favorite', callback: () => console.log('favorite') },
        { text: 'delete', callback: () => console.log('delete') }
      ],
      dropdown_edit: [
        { text: '100%' },
        { text: '75%' },
        { text: '50%' },
        { text: '25%' },
        { text: '0%' }
      ],
       search: '',
       result:[],
       check_load:true,
       isLoading:false,
       request:[],
       dialog: false,
       // title_name_insert:['ชื่อ','นามสกุล','username','password'],
       headers: [
         {
           text: 'ลำดับ',
           align: 'left',
           value: 'sell_id'
         },
         { text: 'รูป  ', value: 'image' },
         { text: 'ชื่อสินค้า', value: 'sell_name' },
         { text: 'ชื่อ-สกุล', value: 'fname' },
         { text: 'ราคา/หน่วย', value: 'sell_price' },
         { text: 'จำนวน', value: 'number_buy' },
         { text: 'ราคารวม', value: '' },
         { text: 'วันที่ซื้อ/ใส่ตระกร้า', value: 'date_buy' },
         { text: 'สถานะ', value: 'buys_status' },
         { text: 'การจัดการ', value: 'การจัดการ', sortable: false }
       ],
       desserts: [],
       editedIndex: -1,
       editedItem: {
         groups_name: '',
         cat_name: '',
         groups_id:'',
         sell_name: '',
         sell_address: '',
         sell_price: '',
         description: '',
         sell_number: '',
         sell_image:'',
         buys_id:'',
         buys_status:''
       },
       defaultItem: {
         groups_name: '',
         cat_name: '',
         groups_id:'',
         sell_name: '',
         sell_address: '',
         sell_price: '',
         description: '',
         sell_number: '',
         sell_image:'',
         buys_id:'',
         buys_status:''
       }
     }),
     computed: {
       formTitle () {
         return this.editedIndex = 'จัดการข้อมูล'
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
       this.show_data(),
       this.get_groups()
       // this.openLoading()
       // this.initialize()
     },

     methods: {
       show_data(){
             var x = this.$cookies.get('kidakarn')
              var username=''
              var status =''
              var pack=[]
             if (x!=null){
               this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
               var username = this.placeInfo.data[0].username
               var status = this.placeInfo.data[0].status
               var pack={username:username , status:status}
             }
             else {
               this.$router.push('/main')
             }
             if (username==null || status!='A'){this.$router.push('/main')}
             else {
               this.openLoading()
               this.axios.get(process.env.VUE_APP_URL+'/show_data_buys').then((result) => {
               this.hideLoading()
               this.result=[]
                var result = result.data
                for(var i=0; i<result.length;i++){
                  this.result.push({
                    bill_id:result[i]["bill_id"],
                    date_buy:result[i]["date_buy"],
                    description:result[i]["description"],
                    groups_id:result[i]["groups_id"],
                    groups_name:result[i]["groups_name"],
                    sell_address:result[i]["sell_address"],
                    sell_id:result[i]["sell_id"],
                    buys_id:result[i]["buys_id"],
                    sell_number:result[i]["sell_number"],
                    sell_image:result[i]["sell_image"],
                    sell_name:result[i]["sell_name"],
                    sell_price:result[i]["sell_price"],
                    username:result[i]["username"],
                    fname:result[i]["fname"],
                    lname:result[i]["lname"],
                    buys_status:result[i]["buys_status"],
                    number_buy:result[i]["number_buy"],
                    price_total:result[i]["number_buy"]*result[i]["sell_price"],
                    cat_id:result[i]["cat_id"],
                    cat_name:result[i]["cat_name"]
                  })
                }
                this.check_load=false
                console.log(this.result);
               })
             }
           },
       get_groups(){
         this.axios.get(process.env.VUE_APP_URL+'/show_data_groups').then((result) => {
         this.hideLoading()
          var data = result.data
          for(var i=0; i<data.length;i++){
            this.items.push({
              groups_id:data[i]["groups_id"],
              groups_name:data[i]["groups_name"],
              cat_id:data[i]["cat_id"]
            })
          }
          this.check_load=false
          })
       },
       openLoading () {
         this.isLoading = true
       },
       hideLoading () {
         this.isLoading = false
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
         console.log('para___cat_name====',item)
         // this.select={groups_name: item.groups_name, groups_id: item.groups_id }
         this.editedIndex = this.desserts.indexOf(item)
         this.editedItem = Object.assign({}, item)
         this.set_btn('update')
         this.dialog = true
       },
       set_btn(status){
         if (status==="update"){
              this.btn_update = true
              this.btn_save = false
         }
         else{
           this.btn_update = false
           this.btn_save = true
         }
       },
       update_data (){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         console.log('=====decode', this.placeInfo.data[0].fname)
         var username = this.placeInfo.data[0].username
         Date.prototype.addDays = function(days) {
             var date = new Date(this.valueOf());
             date.setDate(date.getDate() + days);
             return date;
            }
          var date = new Date();
          var buys_expired_date = date.addDays(5)
         var pack_update =
           {
               buys_id      : this.editedItem.buys_id,
               number_buy  : this.editedItem.number_buy,
               buys_status : this.editedItem.buys_status,
               date        : buys_expired_date
           }
           console.log('pack=====',pack_update)
         this.axios.post(process.env.VUE_APP_URL+'/update_data_buys',pack_update).then((result) =>{
            // alert("Updatสำเร็จ");
            // window.location.href='/Manage_buys'
            if (result.status===200){
              // this.get_query_data()
              this.result = [] //ต่อ
              this.$swal('แก้ไขสำเร็จ ! ', '', 'success').then(result =>{
                this.imageUrl = ''
                console.log("ลองใจดู")
                this.show_data()
                console.log("จะได้รู้")
              })
            }
         }).catch((err) => {
           console.log('2', err.result);
           alert("Updateไม่สำเร็จ");
         })
       },
       deleteItem (item,number,sell_id) {
         // console.log(item,number,sell_id);
         var conn= confirm('Are you sure you want to delete this item?')
         if (conn==false){console.log("ไม่ลบ");}
         else{
           this.axios.get(process.env.VUE_APP_URL+'/delete_buys/'+item+'/'+number+'/'+sell_id).then((result) => {
             console.log('result =====',result.data);
               // alert('ลบสำเร็จ');
               // window.location.href='/Manage_buys'
               if (result.status===200){
                 // this.get_query_data()
                 this.result = [] //ต่อ
                 this.$swal('แก้ไขสำเร็จ ! ', '', 'success').then(result =>{
                   this.imageUrl = ''
                   console.log("ลองใจดู")
                   this.show_data()
                   console.log("จะได้รู้")
                 })
               }
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
             console.log('this.editedItem.sell_name===',this.editedItem.sell_name);
             console.log('select===',this.select);
             if (this.select.groups_name==''){
                 this.$swal('กรุณาเลือกหมวดหมู่ ! ', '', 'warning')
             }
             else if (this.editedItem.sell_name==='') {
               this.$swal('กรุณาใส่หัวข้อในการลงขาย ! ', '', 'warning')
             }
             else if (this.editedItem.address==='') {
               this.$swal('กรุณาใส่ที่อยู่ที่ต้องการติดต่อ ! ', '', 'warning')
             }
             else if (this.editedItem.sell_price==='') {
               this.$swal('กรุณาใส่ราคาสินค้า ! ', '', 'warning')
             }
             else if (this.editedItem.description==='') {
               this.$swal('กรุณาใส่รายละเอียด ! ', '', 'warning')
             }
             else if (this.editedItem.sell_number==='') {
               this.$swal('กรุณาใส่จำนวนสินค้า ! ', '', 'warning')
             }
             else if (this.editedItem.sell_image==='') {
               this.$swal('กรุณาใส่รูปสินค้า ! ', '', 'warning')
             }
             else {
               this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
               console.log('=====decode', this.placeInfo.data[0].fname)
               var username = this.placeInfo.data[0].username

             this.request =
               {
                 groups_id: this.select.groups_id,
                 groups_name: this.select.groups_name,
                 sell_name: this.editedItem.sell_name,
                 sell_address: this.editedItem.sell_address,
                 sell_price: this.editedItem.sell_price,
                 description: this.editedItem.description,
                 sell_number: this.editedItem.sell_number,
                 sell_image: this.editedItem.sell_image,
                 username:username
               }
               console.log(this.request)
             this.axios.post(process.env.VUE_APP_URL+'/add_data_sell',this.request).then((result) =>{
               var data = result.data
               if (data===200){
                  this.$swal('บันทึกสำเร็จ ! ', '', 'success')
               }
               console.log("result=====",result);
             }).catch((err) =>{
               console.log(err);
             })
             this.close()
           }
        },
        select_buys_from_status(status){
          console.log('status',status)
          this.openLoading()
          this.axios.get(process.env.VUE_APP_URL+'/show_data_buys_from_status/'+status).then((result) => {
          this.hideLoading()
          this.result=[]
           var result = result.data
           for(var i=0; i<result.length;i++){
             this.result.push({
               bill_id:result[i]["bill_id"],
               date_buy:result[i]["date_buy"],
               description:result[i]["description"],
               groups_id:result[i]["groups_id"],
               groups_name:result[i]["groups_name"],
               sell_address:result[i]["sell_address"],
               buys_id:result[i]["buys_id"],
               sell_number:result[i]["sell_number"],
               sell_image:result[i]["sell_image"],
               sell_name:result[i]["sell_name"],
               sell_price:result[i]["sell_price"],
               username:result[i]["username"],
               fname:result[i]["fname"],
               lname:result[i]["lname"],
               buys_status:result[i]["buys_status"],
               number_buy:result[i]["number_buy"],
               price_total:result[i]["number_buy"]*result[i]["sell_price"],
               cat_id:result[i]["cat_id"],
               cat_name:result[i]["cat_name"]
             })
           }
           this.check_load=false
           console.log(this.result);
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
  <style lang="css" scoped>
  </style>
