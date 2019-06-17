<template lang="html">
  <div>
      <v-container grid-list-xs>
          <v-toolbar flat color="white">
            <v-toolbar-title>TABLE_GROUPS</v-toolbar-title>
            <v-divider class="mx-2" inset vertical>
            </v-divider>
            <v-spacer></v-spacer>
            <v-dialog v-model="dialog" persistent max-width="500px">
              <template v-slot:activator="{ on }">
                    <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                    <v-btn color="primary" dark class="mb-2" @click="set_btn('insert')" v-on="on" >เพิ่มข้อมูล</v-btn>
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
                          v-model="select"
                          :hint="`${select.cat_name}, ${select.cat_id}`"
                          :items="items"
                          item-text="cat_name"
                          item-value="cat_id"
                          label="ประเภทหมวดหมู่"
                          persistent-hint
                          return-object
                          single-line
                        ></v-select>
                      </v-flex>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.groups_name" label="ชื่อหมวดหมู่"></v-text-field>
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
          <v-data-table :headers="headers" :items="result" :loading="check_load" :search="search" class="elevation-1" :pagination.sync="pagination" >
            <template v-slot:items="props" text-lg-center>
              <td>{{ props.item.groups_id }}</td>
              <td>{{ props.item.groups_name }}</td>
              <td>{{ props.item.cat_name }}</td>
              <td class="justify-center ">
                <v-icon medium class="mr-2" @click="editItem(props.item)">
                  edit
                </v-icon>
                <v-icon medium slot="activator" @click="deleteItem(props.item.groups_id)">delete
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
    btn_update:false,
    btn_save:true,
    pagination: {
            sortBy: 'cat_id',
            rowsPerPage: 25
          },
    select: { cat_name: '', cat_id: '' },
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
         value: 'cat_id'
       },
       { text: 'ชื่อหมวดหมู่', value: 'groups_id' },
       { text: 'ปรเภทหมวดหมู่', value: 'groups_name' },
       { text: 'การจัดการ', value: 'การจัดการ', sortable: false }
     ],
     desserts: [],
     editedIndex: -1,
     editedItem: {
       groups_name: '',
       cat_name: ''
     },
     defaultItem: {
       groups_name: '',
       cat_name: ''
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
     this.get_cat()
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
       if (x==null || status!='A'){this.$router.push('/main')}
       else {
         this.openLoading()
         this.axios.get(process.env.VUE_APP_URL+'/show_data_groups').then((result) => {
         this.hideLoading()
          var result = result.data
          for(var i=0; i<result.length;i++){
            this.result.push({
              groups_id:result[i]["groups_id"],
              groups_name:result[i]["groups_name"],
              cat_id:result[i]["cat_id"],
              cat_name:result[i]["cat_name"]
            })
          }
          this.check_load=false
          // console.log(this.result);
         })
       }
     },
     get_cat(){
       this.axios.get(process.env.VUE_APP_URL+'/show_data_cat').then((result) => {
       this.hideLoading()
        var data = result.data
        for(var i=0; i<data.length;i++){
          this.items.push({
            cat_id:data[i]["cat_id"],
            cat_icon:data[i]["cat_icon"],
            cat_name:data[i]["cat_name"]
          })
        }
        this.check_load=false
        // console.log('dropdown_font=====',this.items);
        })
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
       console.log('para___cat_name====',item)
       this.select={cat_name: item.cat_name, cat_id: item.cat_id }
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
       var pack_update =
         {
          groups_id  :  this.editedItem.groups_id,
          groups_name:  this.editedItem.groups_name,
          cat_id     :  this.select.cat_id
         }
         console.log('pack=====',pack_update)
       this.axios.post(process.env.VUE_APP_URL+'/update_data_groups',pack_update).then((result) =>{
         if (result.status==200){
             this.result = []
             this.$swal('แก้ไขสำเร็จ ! ', '', 'success').then(result =>{
             this.show_data()
           })
         }
          // alert("Updatสำเร็จ");
          // window.location.href='/Manage_groups'
       }).catch((err) => {
         console.log('2', err.result);
         alert("Updateไม่สำเร็จ");
       })
     },
     deleteItem (item) {
       var conn= confirm('Are you sure you want to delete this item?')
       if (conn==false){console.log("ไม่ลบ");}
       else{
         this.axios.get(process.env.VUE_APP_URL+'/delete_groups/'+item).then((result) => {
           console.log('result =====',result.data);
           if (result.status==200){
               this.result = []
               this.$swal('ลบสำเร็จ ! ', '', 'success').then(result =>{
               this.show_data()
             })
           }
             // alert('ลบสำเร็จ');
             // window.location.href='/Manage_groups'
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
           if (this.select.cat_id===''){
               this.$swal('กรุณาเลือกประเภทหมวดหมู่ ! ', '', 'warning')
           }
           else if (this.editedItem.groups_name==='') {
             this.$swal('กรุณาใส่ชื่อหมวดหมู่ ! ', '', 'warning')
           }
           else {
           this.request =
             {
               groups_name: this.editedItem.groups_name,
               cat_id: this.select.cat_id
             }
             console.log(this.request);
           this.axios.post(process.env.VUE_APP_URL+'/add_data_groups',this.request).then((result) =>{
             var data = result.data
             if (data===200){
                this.$swal('บันทึกสำเร็จ ! ', '', 'success').then(result =>{
                  console.log("ลองใจดู");
                  this.show_data()
                  console.log("จะได้รู้");
                })
             }
             else if (data===150) {
                this.$swal('ชื่อหมวดนี้มีอยู่แล้ว ! ', '', 'error')
             }
             console.log("result=====",result);
           }).catch((err) =>{
             console.log(err);
           })
           this.close()
         }
      }
   }
}
</script>
<style lang="css" scoped>
</style>
