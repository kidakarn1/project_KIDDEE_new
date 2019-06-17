  <template lang="html">
    <div>
        <v-container grid-list-xs>
            <v-toolbar flat color="white">
              <v-toolbar-title>TABLE_SELL</v-toolbar-title>
              <v-divider class="mx-2" inset vertical>
              </v-divider>
              <v-spacer></v-spacer>
              <v-dialog v-model="dialog" persistent max-width="500px">
                <template v-slot:activator="{ on }">
                      <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                      <v-btn color="primary" dark class="mb-2" v-on="on" @click="set_btn('insert')">เพิ่มข้อมูล</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">{{ formTitle }}</span>
                  </v-card-title>
                  <v-card-text>
                    <v-container grid-list-md>
                      <v-layout wrap>
                        <v-flex id="dropdown-example" grid-list-xl xs12 sm6 md12>
                          <v-select
                            v-model="select_cat"
                            :hint="`${select_cat.text}, ${select_cat.cat_id}`"
                            :items="list_cat"
                            item-text="text"
                            item-value="cat_id"
                            label="ประเภทสินค้า"
                            persistent-hint
                            return-object
                            single-line
                            @change="to_groups"
                          ></v-select>
                        </v-flex>
                          <v-flex v-if = "show_groups===true" id="dropdown-example" grid-list-xl xs12 sm6 md12>
                            <v-select
                              v-model="select"
                              :hint="`${select.groups_name}, ${select.groups_id}`"
                              :items="items"
                              item-text="groups_name"
                              item-value="groups_id"
                              label="หมวดหมู่"
                              persistent-hint
                              return-object
                              single-line
                            ></v-select>
                          </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field v-model="editedItem.sell_name" label="ชื่อสินค้าที่ต้องการขาย"></v-text-field>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field v-model="editedItem.sell_address" label="ที่อยู่ที่ต้องการมารับจากการขาย"></v-text-field>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field type="number" v-model="editedItem.sell_price" label="ราคา/ชิ้น" min="1"></v-text-field>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field v-model="editedItem.description" label="รายละเอียด"></v-text-field>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <v-text-field type="number" v-model="editedItem.sell_number" label="จำนวนที่ลงขาย" min="1"></v-text-field>
                        </v-flex>
                        <v-flex xs12 sm6 md12>
                          <!-- <v-text-field v-model="editedItem.sell_image" label="รูปสินค้า"></v-text-field> -->
                          <img :src="imageUrl" height="150" v-if="imageUrl"/>
                          <input type="file" ref="image" accept="image/*" @change="onFilePicked">
                        </v-flex>
                      </v-layout>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="error darken-1" flat @click="dialog = false">Cancel</v-btn>
                    <v-btn v-if="btn_save" color="success darken-1" flat @click="save">Save</v-btn>
                    <v-btn v-if="btn_update" color="blue darken-1" flat @click="update_data()">Update</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-toolbar>
            <v-data-table :headers="headers" :items="result" :loading="check_load" :search="search" class="elevation-1" :pagination.sync="pagination">
              <template v-slot:items="props" text-lg-center>
                <td>{{ props.item.sell_id }}</td>
                <td>
                  <v-img :src="require('../img_sell/'+ props.item.sell_image)" width="100px" />
                </td>
                <td>{{ props.item.sell_name }}</td>
                <td>{{ props.item.fname }}  {{ props.item.lname }}</td>
                <td>{{ props.item.sell_price }}</td>
                <td>{{setDate(props.item.date_start)}} </td>
                <td>{{ props.item.sell_number }}</td>
                <td class="justify-center ">
                  <v-icon medium class="mr-2" @click="editItem(props.item)">
                    edit
                  </v-icon>
                  <v-icon medium slot="activator" @click="deleteItem(props.item.sell_id)">delete
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
      btn_update:false,
      btn_save:true,
      title: "Image Upload",
      dialog: false,
      imageName: '',
      imageUrl: '',
      imageFile: '',
      pagination: {
              sortBy: 'cat_id',
              rowsPerPage: 25
            },
      show_groups:false,
      selectedFile:'',
      pack_update:[],
      path_query:"",
      parameters:'',
      list_cat:[],
      select: { groups_name: '', groups_id: '' },
      select_cat: { cat_id: '', text: '' },
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
         { text: 'ชื่อสืนค้า', value: 'sell_name' },
         { text: 'ชื่อ-สกุลผู้ลงขาย', value: 'fname' },
         { text: 'ราคา/ชิ้น', value: 'lname' },
         { text: 'วันที่ลงขาย', value: 'username' },
         { text: 'จำนวน', value: 'password' },
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
         sell_image:'default.png'
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
         sell_image:'default.png'
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
       },
       select(val){
         console.log('select====>',val);
       }
     },

     created () {
       this.show_data(),
       this.show_data_cat()
        // this.openLoading()
       // this.initialize()
     },

     methods: {
       to_groups(){
         console.log(this.select);
         this.select =  { groups_name: '', groups_id: '' }
         this.get_groups()
         this.show_groups = true
       },
       show_data_cat(){
           this.axios.get(process.env.VUE_APP_URL+'/get_category').then((result) =>{
               var data= result.data
                   this.length_data = result.data
               for (var i = 0; i < data.length; i++) {
                 this.list_cat.push({
                   cat_id:data[i]["cat_id"],
                   text:data[i]["cat_name"],
                   cat_icon:data[i]["cat_icon"]
                 })
               }
           })
           console.log(this.list_cat);
       },
       pickFile () {
         this.$refs.image.click()
       },

       onFilePicked (e) {
         console.log(e)
         this.selectedFile = e.target.files[0]
         const files = e.target.files
         if(files[0] !== undefined) {
           this.imageName = files[0].name
           if(this.imageName.lastIndexOf('.') <= 0) {
             return
           }
           const fr = new FileReader ()
           fr.readAsDataURL(files[0])
           fr.addEventListener('load', () => {
             this.imageUrl = fr.result
             this.imageFile = files[0] // this is an image file that can be sent to server...
           })
         } else {
           this.imageName = ''
           this.imageFile = ''
           this.imageUrl = ''
         }
         // this.selectedFile = e.target.files[0]
         // const files = e.target.files
         // if (files[0] !== undefined) {
         //   this.imageName = files[0].name
         //   if (this.imageName.lastIndexOf('.') <= 0) {
         //     return
         //   }
         //   const fr = new FileReader()
         //   fr.readAsDataURL(files[0])
         //   fr.addEventListener('load', () => {
         //     this.imageUrl = fr.result
         //     this.imageFile = files[0] // this is an image file that can be sent to server...
         //   })
         // } else {
         //   this.imageName = ''
         //   this.imageFile = ''
         //   this.imageUrl = ''
         // }
       },
       onUpload () {
         var str = this.selectedFile.name;
         var new_name_image = str.toLowerCase()
         var vm = this
         // vm.dialog = true
         const formData = new FormData()
         formData.append('file', this.selectedFile, new_name_image)
         formData.append('username',this.parameters.username)
         formData.append('location_parameters', this.path_query)
         formData.append('sell_id', this.pack_update.sell_id)

          console.log('this.selectedFile.name',this.selectedFile.name)
         console.log('this.parameters.username',this.parameters.username)
          console.log('this.path_query',this.path_query)
          console.log('this.pack_update.sell_id',this.pack_update.sell_id)
         // formData.append('cat_id', this.pack_update.cat_id)
         // console.log(formData.get('file'))
         this.axios.post('http://localhost:5000/api/uploadimage',
           formData,
           {
             onUploadProgress: progressEvent => {
               var percentCompleted = Math.round((progressEvent.loaded * 100) / progressEvent.total)
               console.log(percentCompleted + '%')
               vm.percentUpload = percentCompleted
             }
           }
         ).then(function () {
           console.log('SUCCESS!!')
           vm.upLoadSuccess = true
           // vm.dialog = false
         })
           .catch(function () {
             console.log('FAILURE!!')
           })
       },
       show_data(){
          var x = this.$cookies.get('kidakarn')
          var username=''
          var status =''
          var pack=[]
         if (x!=null){
           this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
           var username = this.placeInfo.data[0].username
           var status = this.placeInfo.data[0].status
           pack={username:username , status:status , patch:'Manage_sell' , para:'%'}
         }
         else {
           this.$router.push('/main')
         }
             if (x==null){this.$router.push('/main')}
             else {
               this.openLoading()
               this.axios.post(process.env.VUE_APP_URL+'/show_data_sell',pack).then((result) => {
               this.hideLoading()
                var result = result.data
                for(var i=0; i<result.length;i++){
                  this.result.push({
                    index:i,
                    cat_id:result[i]["cat_id"],
                    cat_name:result[i]["cat_name"],
                    date_start:result[i]["date_start"],
                    description:result[i]["description"],
                    groups_id:result[i]["groups_id"],
                    groups_name:result[i]["groups_name"],
                    sell_address:result[i]["sell_address"],
                    sell_id:result[i]["sell_id"],
                    sell_number:result[i]["sell_number"],
                    sell_image:result[i]["sell_image"],
                    sell_name:result[i]["sell_name"],
                    sell_price:result[i]["sell_price"],
                    username:result[i]["username"],
                    fname:result[i]["fname"],
                    lname:result[i]["lname"]
                  })
                }
                this.check_load=false
                console.log(this.result);
               })
             }
           },
       get_groups(){
         console.log(this.select_cat.cat_id);
         this.items = []
         this.axios.get(process.env.VUE_APP_URL+'/show_data_groups_cat/'+this.select_cat.cat_id).then((result) => {
         this.hideLoading()
          var data = result.data
          for(var i=0; i<data.length;i++){
            this.items.push({
              groups_id:data[i]["groups_id"],
              groups_name:data[i]["groups_name"],
              cat_id:data[i]["cat_id"]
            })
          }
          console.log('group===>',data)
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
         this.select_cat={text: item.cat_name, cat_id: item.cat_id }
         this.to_groups()
         this.select = {groups_name: item.groups_name, groups_id: item.groups_id }
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
         if (this.select_cat.text==''){
             this.$swal('กรุณาเลือกประเภทสินค้า ! ', '', 'warning')
         }
         else if (this.select.groups_name==''){
             this.$swal('กรุณาเลือกหมวดหมู่ ! ', '', 'warning')
         }
         else if (this.editedItem.sell_name==='') {
           this.$swal('กรุณาใส่ชื่อสินค้าที่ต้องการขาย ! ', '', 'warning')
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
         else {
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         console.log('=====decode', this.placeInfo.data[0].fname)
         var username = this.placeInfo.data[0].username
         var date = new Date("YYYY-mm-dd hh:mm:ss");
         this.pack_update =
           {
               sell_id: this.editedItem.sell_id,
               groups_id: this.select.groups_id,
               groups_name: this.select.groups_name,
               sell_name: this.editedItem.sell_name,
               sell_address: this.editedItem.sell_address,
               sell_price: this.editedItem.sell_price,
               description: this.editedItem.description,
               sell_number: this.editedItem.sell_number,
               sell_image: this.editedItem.sell_image,
               username:username,
               date:date
           }
           this.parameters = {username :this.pack_update.username}
           console.log('pack_update=====',this.pack_update)
         this.axios.post(process.env.VUE_APP_URL+'/update_data_sell',this.pack_update).then((result) =>{
           if (this.selectedFile != ''){
             this.path_query = "Edit_sell"
             this.onUpload()
             this.selectedFile = ''
             this.selectedFile = {name:''}
           }
           if (result.status===200){
              this.result = []
           }
           this.$swal('แก้ไขสำเร็จ ! ', '', 'success').then(result =>{
             this.show_data()
           })
            // alert("Updatสำเร็จ");
            // window.location.href='/Manage_sell'
         }).catch((err) => {
           console.log('2', err.result);
           alert("Updateไม่สำเร็จ");
         })
       }
     },
       deleteItem (item) {
         var conn= confirm('Are you sure you want to delete this item?')
         if (conn==false){console.log("ไม่ลบ");}
         else{
           this.axios.get(process.env.VUE_APP_URL+'/delete_sell/'+item).then((result) => {
             console.log('result =====',result.data);
             if (result.status===200){
               this.result = []
             }
             this.$swal('ลบสำเร็จ ! ', '', 'success').then(result =>{
               this.show_data()
             })
               // alert('ลบสำเร็จ');
               // window.location.href='/Manage_sell'
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
             if (this.select_cat.text==''){
                 this.$swal('กรุณาเลือกประเภทสินค้า ! ', '', 'warning')
             }
             else if (this.select.groups_name==''){
                 this.$swal('กรุณาเลือกหมวดหมู่ ! ', '', 'warning')
             }
             else if (this.editedItem.sell_name==='') {
               this.$swal('กรุณาใส่ชื่อสินค้าที่ต้องการขาย ! ', '', 'warning')
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
             // else if (this.editedItem.sell_image==='') {
             //   this.$swal('กรุณาใส่รูปสินค้า ! ', '', 'warning')
             // }
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
                this.parameters = {username:username}
               console.log(this.request)
             this.axios.post(process.env.VUE_APP_URL+'/add_data_sell',this.request).then((result) =>{
               var data = result.data
               if (this.selectedFile != ''){
                 this.path_query = "Insert_sell"
                 // console.log("ก่อน onload",this.request.cat_name);
                 this.onUpload()
                 this.selectedFile = ''
                 this.selectedFile = {name:''}
               }
               if (data===200){
                     this.result = []
                     this.editedItem = {
                       groups_name: '',
                       cat_name: '',
                       groups_id:'',
                       sell_name: '',
                       sell_address: '',
                       sell_price: '',
                       description: '',
                       sell_number: '',
                       sell_image:'default.png'
                   }
                }
                this.$swal('บันทึกสำเร็จ ! ', '', 'success').then(result =>{
                  this.show_data()
                })
             }).catch((err) =>{
               console.log(err);
             })
             this.close()
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
  </style>
