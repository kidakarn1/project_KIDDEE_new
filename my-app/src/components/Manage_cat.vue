<template lang="html">
  <div>
      <v-container grid-list-xs>
          <v-toolbar flat color="white">
            <v-toolbar-title>TABLE_CAT</v-toolbar-title>
            <v-divider class="mx-2" inset vertical>
            </v-divider>
            <v-spacer></v-spacer>
            <v-dialog v-model="dialog" persistent  max-width="500px">
              <template v-slot:activator="{ on }">
                    <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                <v-btn color="primary" dark class="mb-2" @click="set_btn('insert')" v-on="on" >เพิ่มข้อมูล</v-btn>
                <v-btn
                  :loading="loading4"
                  :disabled="loading4"
                  color="warning"
                  @click="load_data()"
                >
                  โหลดข้อมูล
                  <template v-slot:loader>
                    <span class="custom-loader">
                      <v-icon light>cached</v-icon>
                    </span>
                  </template>
                </v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                  <v-container grid-list-md>
                    <v-layout wrap>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.cat_name"  label="ชื่อ ประเภท"></v-text-field>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <img :src="imageUrl" height="150" v-if="imageUrl"/>
                        <input type="file" ref="image" accept="image/*" @change="onFilePicked">

                        <!-- <v-text-field v-model="editedItem.cat_icon" label="รูป icon"></v-text-field> -->
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="error darken-1" flat @click="dialog = false">Cancel</v-btn>
                  <v-btn v-if="btn_save" color="success darken-1" flat @click="save">Save</v-btn>
                  <v-btn v-if="btn_update" color="blue darken-1" flat @click="update_data(editedItem.user_id)">Update</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
          <v-data-table :headers="headers" :items="result" :loading="check_load" :search="search" class="elevation-1" :pagination.sync="pagination">
            <template v-slot:items="props" text-lg-center>
              <td>{{ props.item.cat_id }}</td>
              <td>
                <v-img :src="require('../img_icon/'+ props.item.cat_icon)" width="50px" />
              </td>
              <td>{{ props.item.cat_name }}</td>
              <td class="justify-center layout px-0">
                <v-icon medium class="mr-2" @click="editItem(props.item)">
                  edit
                </v-icon>
                <v-icon medium slot="activator" @click="deleteItem(props.item.cat_id)">delete
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
// import Loading from '@/components/Loading'
import { Encode, Decode } from '@/service'
export default {
  data: () => ({
   loader: null,
   status_onUpload:false,
   loading: false,
   loading2: false,
   loading3: false,
   loading4: false,
    btn_update:false,
    btn_save:true,
    title: "Image Upload",
    dialog: false,
    imageName: '',
    imageUrl: '',
    imageFile: '',
    parametes:'',
    pack_update:[],
    path_query: '',
    dropdown_font: ['U', 'A'],
    pagination: {
            sortBy: 'cat_id',
            rowsPerPage: 25
          },
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
         value: 'cat_id'
       },
       { text: 'รูป  ', value: 'cat_icon' },
       { text: 'ชื่อประเภท', value: 'cat_id' },
       { text: 'การจัดการ', value: 'การจัดการ', sortable: false }
     ],
     desserts: [],
     editedIndex: -1,
     editedItem: {
       cat_name: '',
       cat_icon: 'default.png'
     },
     defaultItem: {
       cat_name: '',
       cat_icon: 'default.png'
     },
     selectedFile:''
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
     status_onUpload(val){
       console.log('watch===>',val)
     },
     dialog (val) {
       val || this.close()
     },
    loader () {
      const l = this.loader
      this[l] = !this[l]

      setTimeout(() => (this[l] = false), 3000)

      this.loader = null
    }
   },

   created () {
     this.show_data()
     // this.openLoading()
     // this.initialize()
   },

   methods: {
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
       var vm = this
       // vm.dialog = true
       const formData = new FormData()
       formData.append('file', this.selectedFile, this.selectedFile.name)
       formData.append('username',this.parameters.cat_name)
       formData.append('location_parameters', this.path_query)
       formData.append('cat_id', this.pack_update.cat_id)
       console.log('this.parameters.pk===>',this.parameters.cat_name)
        console.log('this.selectedFile.name===>',this.selectedFile.name)
       console.log('this.path_query===>',this.path_query)
       console.log('this.pack_update.cat_id===>',this.pack_update.cat_id)
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
         this.status_onUpload = true
         vm.upLoadSuccess = true
         // vm.dialog = false
       })
         .catch(function () {
           console.log('FAILURE!!')
         })
     },
     reset () {
       this.$refs.form.reset()
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
         var pack={username:username , status:status}
       }
       else {
         this.$router.push('/main')
       }
       if (x==null || status!='A'){this.$router.push('/main')}
       else {
         this.openLoading()
         this.axios.get(process.env.VUE_APP_URL+'/show_data_cat').then((result) => {
         this.hideLoading()
          var result = result.data
          for(var i=0; i<result.length;i++){
            this.result.push({
              cat_id:result[i]["cat_id"],
              cat_icon:result[i]["cat_icon"],
              cat_name:result[i]["cat_name"]
            })
          }
          this.check_load=false
          console.log(this.result);
         })
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
     update_data (para){
        this.pack_update =
         {
          cat_id:  this.editedItem.cat_id,
          cat_name: this.editedItem.cat_name,
          cat_icon: this.editedItem.cat_icon
         }
         this.parameters = {cat_name :this.pack_update.cat_name}
         console.log('pack=====',this.pack_update);
       this.axios.post(process.env.VUE_APP_URL+'/update_data_cat',this.pack_update).then((result) =>{
         if (this.selectedFile != ''){
           this.path_query = "Edit_cat"
           this.onUpload()
           this.selectedFile = ''
           this.selectedFile = {name:''}
         }
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
          // window.location.href='/Manage_cat'
       }).catch((err) => {
         console.log('2', err.result);
         alert("Updateไม่สำเร็จ");
       })
     },
     deleteItem (item) {
       var conn= confirm('Are you sure you want to delete this item?')
       if (conn==false){console.log("ไม่ลบ");}
       else{
         this.axios.get(process.env.VUE_APP_URL+'/delete_cat/'+item).then((result) => {
           console.log('result =====',result.data);
             // alert('ลบสำเร็จ');
             this.$swal('ลบสำเร็จ ! ', '', 'success')
             this.result = []
             this.show_data()
             // window.location.href='/Manage_cat'
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
           if (this.editedItem.cat_name===''){
               this.$swal('กรุณาใส่ชื่ชื่อประเภท ! ', '', 'warning')
           }
           // else if (this.editedItem.cat_icon==='') {
           //   this.$swal('กรุณาใส่รูปicon ! ', '', 'warning')
           // }
           else {
           this.request =
             {
               cat_name: this.editedItem.cat_name,
               cat_icon: this.editedItem.cat_icon
             }
             this.parameters = {cat_name :this.request.cat_name}
             console.log('this.request===>',this.request);
             console.log("data_save===",this.request);
           this.axios.post(process.env.VUE_APP_URL+'/add_data_cat',this.request).then((result) =>{
             var data = result.data
             if (this.selectedFile != ''){
               this.path_query = "Insert_cat"
               // console.log("ก่อน onload",this.request.cat_name);
               this.onUpload()
               this.selectedFile = ''
               this.selectedFile = {name:''}
             }
             if (data===200){
                // this.$swal('บันทึกสำเร็จ ! ', '', 'success')
                this.result = []
                this.editedItem = {
                  cat_name: '',
                  cat_icon: 'default.png'
                }
                this.$swal('บันทึกสำเร็จ ! ', '', 'success').then(result =>{
                  console.log("ลองใจดู");
                  this.show_data()
                  console.log("จะได้รู้");
                })

                 // window.location.href='/Manage_cat'
             }
             else if (data===150) {
                this.$swal('ชื่อประเภทนี้มีอยู่แล้ว ! ', '', 'error')
             }
             console.log("result=====",result);
           }).catch((err) =>{
             console.log(err);
           })
           if (this.editedIndex > -1) {
             Object.assign(this.desserts[this.editedIndex], this.editedItem)
           } else {
             this.desserts.push(this.editedItem)
           }
           this.close()
         }
      },
      load_data(){
        this.result = []
        this.show_data()
        this.loader = true
      }
   }
}
</script>
<style lang="css" scoped>
.custom-loader {
    animation: loader 1s infinite;
    display: flex;
  }
  @-moz-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @-webkit-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @-o-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
</style>
