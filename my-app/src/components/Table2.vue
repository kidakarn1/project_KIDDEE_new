<template lang="html">
  <div>
      <v-container grid-list-xs>
          <v-toolbar flat color="white">
            <v-toolbar-title>TABLE_USER</v-toolbar-title>
            <v-divider class="mx-2" inset vertical>
            </v-divider>
            <v-spacer></v-spacer>
            <v-dialog v-model="dialog" max-width="500px">
              <template v-slot:activator="{ on }">
                    <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details></v-text-field>
                <v-btn color="primary" dark class="mb-2" v-on="on">เพิ่มข้อมูล</v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">{{ formTitle }}</span>
                </v-card-title>

                <v-card-text>
                  <v-container grid-list-md>
                    <v-layout wrap>
                      <v-flex xs12 sm6 md12>
                        <v-text-field v-model="editedItem.fname"  label="ชื่อ"></v-text-field>
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

              <td>{{ props.item.user_id }}</td>
              <td>{{ props.item.fname }}</td>
              <td>{{ props.item.lname }}</td>
              <td>{{ props.item.username }}</td>
              <td>{{ props.item.password }}</td>
              <td>{{ props.item.status }}</td>
              <td class="justify-center layout px-0">
                <v-icon small class="mr-2" @click="editItem(props.item)">
                  edit
                </v-icon>
                <v-icon small slot="activator" @click="deleteItem(props.item.user_id)">delete
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
export default {
  data: () => ({
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
         value: 'user_id'
       },
       { text: 'ชื่อ', value: 'fname' },
       { text: 'นามสกุล', value: 'lname' },
       { text: 'username', value: 'username' },
       { text: 'password', value: 'password' },
       { text: 'สถานะ', value: 'status', sortable: false }
     ],
     desserts: [],
     editedIndex: -1,
     editedItem: {
       fname: '',
       lname: '',
       username: '',
       password: '',
       status:''
     },
     defaultItem: {
       fname: '',
       lname: '',
       username: '',
       password: '',
       status: ''
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
     // show_data(){
     //   this.openLoading()
     //   var x = this.$cookies.get('kidakarn')
     //   if (x==null){this.$router.push('/')}
     //   this.axios.get(process.env.VUE_APP_URL+'/test').then((result) => {
     //    var result = result.data
     //    for(var i=0; i<result.length;i++){
     //      this.result.push({
     //        user_id:result[i]["user_id"],
     //        fname:result[i]["fname"],
     //        lname:result[i]["lname"],
     //        username:result[i]["username"],
     //        password:result[i]["password"],
     //        status:result[i]["status"]
     //      })
     //    }
     //    this.check_load=false
     //    console.log(this.result);
     //   })
     //
     // }
   },

   watch: {
     dialog (val) {
       val || this.close()
     }
   },

   created () {
     this.show_data()
     // this.openLoading()
     // this.initialize()
   },

   methods: {
     show_data(){
       var x = this.$cookies.get('kidakarn')
       if (x==null){this.$router.push('/')}
       else {
         this.openLoading()
         this.axios.get(process.env.VUE_APP_URL+'/test').then((result) => {
         this.hideLoading()
          var result = result.data
          for(var i=0; i<result.length;i++){
            this.result.push({
              user_id:result[i]["user_id"],
              fname:result[i]["fname"],
              lname:result[i]["lname"],
              username:result[i]["username"],
              password:result[i]["password"],
              status:result[i]["status"]
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
     deleteItem (item) {
       var conn= confirm('Are you sure you want to delete this item?')
       if (conn==false){console.log("ไม่ลบ");}
       else{
         this.axios.get(process.env.VUE_APP_URL+'/delete_user/'+item).then((result) => {
           console.log('result =====',result.data);
             alert('ลบสำเร็จ');
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
      }
   }
}
</script>
<style lang="css" scoped>
</style>
