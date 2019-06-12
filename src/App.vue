<template lang="html">
 <div id="app">
   <v-app id="inspire">

     <div v-if="check_menu">
     <v-navigation-drawer fixed :clipped="$vuetify.breakpoint.mdAndUp" app v-model="drawer" >
       <v-list dense>
         <template wrap v-for="item in items">
           <v-layout row v-if="item.heading" align-center :key="item.heading" >
             <v-flex xs6>
               <v-subheader v-if="item.heading">
                 {{ item.heading }}
               </v-subheader>
             </v-flex>
             <v-flex xs6 class="text-xs-center">
               <a href="#!" class="body-2 black--text">EDIT</a>
             </v-flex>
           </v-layout>
           <v-list-group v-else-if="item.children" v-model="item.model" :key="item.text" :prepend-icon="item.model ? item.icon : item['icon-alt']" append-icon="">
             <v-list-tile slot="activator">
               <v-list-tile-content>
                 <v-list-tile-title>
                     {{ item.text }}
                 </v-list-tile-title>
               </v-list-tile-content>
             </v-list-tile>
             <v-list-tile v-for="(child, i) in item.children" :key="i" @click="" >
               <v-list-tile-action v-if="child.icon">
                 <v-icon>{{ child.icon }}</v-icon>
               </v-list-tile-action>
               <v-list-tile-content>
                 <v-list-tile-title @click="manage(child.text)">
                   {{ child.text }}
                 </v-list-tile-title>
               </v-list-tile-content>
             </v-list-tile>
           </v-list-group>
           <v-list-tile v-else @click="" :key="item.text">
             <v-list-tile-action>
               <v-icon>{{ item.icon }}</v-icon>
             </v-list-tile-action>
             <v-list-tile-content>
               <div v-if="item.cat_id=='login'">
                 <Login/>
               </div>
               <v-list-tile-title v-if="item.cat_id!='login'" @click="manage(item.cat_id)">
                   <!-- <v-img :src="require('@/img_icon/'+item.icon)" width="25px"/> -->
                   {{ item.text }}
               </v-list-tile-title>
             </v-list-tile-content>
           </v-list-tile>
         </template>
       </v-list>
     </v-navigation-drawer>
     </div>

     <v-toolbar color="blue darken-3" dark app :clipped-left="$vuetify.breakpoint.mdAndUp" fixed>
       <v-toolbar-title style="width: 100px" class="ml-0 pl-1">
           <v-toolbar-side-icon  v-if="check_menu" @click.stop="drawer = !drawer"></v-toolbar-side-icon>
         <span style="cursor:pointer" class="hidden-sm-and-down `elevation-${hover ? 12 : 2} cursor1`" @click="nextmain">Kiddee</span>
       </v-toolbar-title>
       <v-spacer></v-spacer>
       <v-flex v-if="check_size()" offset-sm7 sm6 md12 offset-lg0>
       <v-layout>
           <div v-if="check_show_want_buy()">
             <Menu_dropdown/>
           </div>
           <!-- <Search/> -->
         <v-spacer></v-spacer>
         <v-spacer></v-spacer>
         <v-spacer></v-spacer>
         <v-spacer></v-spacer>
         <v-spacer></v-spacer>
              <v-btn @click="nextmain" flat  style="font-family: 'Kanit', sans-serif; ">หน้าหลัก</v-btn>
             <!-- <v-btn v-if="check_login()"flat  style="font-family: 'Kanit', sans-serif; " @click="register_user()">สมัครสมาชิก</v-btn> -->
             <div v-if="check_login()">
               <Register />
             </div>
             <div v-if="check_login()">
               <Login />
             </div>
       </v-layout>

       </v-flex>
             <v-btn icon v-if="check_login()===false">
         <!-- <v-icon>account_circle</v-icon> -->
             <v-menu v-if="check_login()===false" transition="scale-transition" offset-y>
             <template v-slot:activator="{ on }">
               <v-avatar size="avatarSize" fab>
                 <v-img :src="require('./user_image/'+profiles_user.user_image)" dark v-on="on"   style="cursor:pointer" width="30px" />
               </v-avatar>
             </template>
          <v-list >
               <v-list-tile>
                 <v-list-tile-title><b>คุณ {{this.profiles_user.fname}}  {{this.profiles_user.lname}}</b></v-list-tile-title>
               </v-list-tile>
                 <v-list-tile-title flat @click.stop="edit_user = true"  style="cursor:pointer" >
                   <center><h3>แก้ไขข้อมูลส่วนตัว</h3></center>
                  </v-list-tile-title>
                   <v-list-tile>
                 <v-list-tile-title style="cursor:pointer" @click="manage('ออกจากระบบ')" >ออกจากระบบ</v-list-tile-title>
               </v-list-tile>
             </v-list>
        </v-menu>
       </v-btn>

       <v-btn icon v-if="check_login()===false">
         <v-badge class="align-self-center" color="red" >
           <!-- :bottom="bottom" :left="left" :overlap="overlap" -->
           <template v-slot:badge>
             <span>{{number_user_buy.count_buy_id}}</span>
           </template>
         <v-icon @click="manage('cart')">shopping_cart</v-icon>
         </v-badge>
       </v-btn>
       <div icon v-if="check_login()===false">
         <Alert/>
       </div>
     </v-toolbar>
     <v-content>
       <router-view/>
     </v-content>

     <v-dialog v-model="edit_user" persistent max-width="350" >
       <v-card>
         <v-card-title class="headline">แก้ไขข้อมูลส่วนตัว</v-card-title>
         <v-card-text>
           <v-container grid-list-xs>
             <v-form ref="form">
                 <v-layout wrap>
                     <v-flex xs12 sm6 md12 xl6>
                       <v-text-field v-model="profiles_user.fname" :rules="fname" label="ชื่อ"></v-text-field>
                     </v-flex>
                     <v-flex xs12 sm6 md12 xl6>
                       <v-text-field v-model="profiles_user.lname" :rules="lname"label="นามสกุล"></v-text-field>
                     </v-flex>
                     <v-flex xs12 sm6 md12 xl12>
                       <v-text-field v-model="profiles_user.password" :rules="password"type="password"label="รหัสผ่าน"></v-text-field>
                     </v-flex>
                     <v-flex xs12 sm6 md12 xl12>
                       <v-text-field v-model="profiles_user.phone" type="number" :rules="phone" label="เบอร์โทรศัพท์"></v-text-field>
                       <!-- <v-text-field v-model="editedItem.status" label="ที่อยู่"></v-text-field> -->
                     </v-flex>
                     <v-flex xs12 sm6 md12 xl12>
                       <img :src="imageUrl" height="150" v-if="imageUrl"/>
                       <input type="file" ref="image" accept="image/*" @change="onFilePicked">
                       <!-- <v-text-field v-model="profiles_user.user_image" :rules="image" label="รูป"></v-text-field> -->
                     </v-flex>
                     <v-flex xs12 sm6 md12>
                       <v-textarea outline name="input-7-4" label="ที่อยู่" v-model="profiles_user.user_address" :rules="user_address"value="The Woodman set to work at once, and so sharp was his axe that the tree was soon chopped nearly through."></v-textarea>
                     </v-flex>
                 </v-layout>
                 <v-flex xs12 sm6 md12 offset-xl1>
                   <v-btn color="warning" @click="Edit_user()">ตกลง</v-btn>
                   <v-btn color="error" @click="manage('Canceled')">ยกเลิก</v-btn>
                 </v-flex>
               </v-form>
           </v-container>
         </v-card-text>
       </v-card>
     </v-dialog>
   </v-app>
   <v-content>
     <Footer/>
   </v-content>
 </div>
</template>

<script>
import Search from '@/components/Search.vue'
import Register from '@/components/Register_user.vue'
import Menu_dropdown from '@/components/Menu_dropdown.vue'
import Alert from '@/components/Alert.vue'
import Login from '@/components/Login.vue'
import Footer from '@/components/Footer.vue'
import { Encode, Decode } from '@/service'
export default {
 components: {
   Register,
   Footer,
   Menu_dropdown,
   Login,
   Alert,
   Search
  },
 data: () => ({
   imageUrl: '',
   selectedFile:'',
   pack_update:[],
   path_query:"",
   parameters:'',
   status_check_image : false,
   edit_user: false,
   profiles_user:{
                 fname:'',
                 lname:'',
                 username:'',
                 password:'',
                 phone:'',
                 image:'',
                 status:'',
                 user_address:''
   },
   fname: [
     v => !!v || 'กรุณาใส่ชื่อผู้สมัคร'
   ],
   lname: [
     v => !!v || 'กรุณาใส่นามสกุลผู้สมัคร'
   ],
   username: [
     v => !!v || 'กรุณาใส่ชื่อผู้ใช้'
   ],
   password: [
     v => !!v || 'กรุณาใส่รหัสผ่าน'
   ],
   phone: [
     v => !!v || 'กรุณาใส่เบอร์มือถือ'
   ],
   image: [
     v => !!v || 'กรุณาใส่รูปของผู้สมัคร'
   ],
   user_address: [
     v => !!v || 'กรุณาใส่ที่อยู่'
   ],
   number_user_buy:0,
   name: null,
   path:'',
   placeInfo:[],
   profile_data:[],
   profiles_user:[],
   items_profile: [],
   length_data:0,
   check_menu:false,
     name_login:[
               {text:'เมนู'},
               {text:'เข้าสู่ระบบ'},
               {text:'การแจ้งเตือน'},
               {text:'สมัครสมาชิก'}
             ],
     dialog: false,
     drawer: null,
     check_show:false,
     items: [
       { cat_id:'login',icon: 'contacts', text: 'เข้าสู่ระบบ' },
       { cat_id:'home',icon: 'contacts', text: 'หน้าหลัก' },
       {
         icon: 'keyboard_arrow_up',
         'icon-alt': 'keyboard_arrow_down',
         text: 'ดูหมวดหมู่อื่นๆ',
         model: true,
         children: [
           { icon: '-', text: 'ผู้ใช้' },
           { icon: '-', text: 'รูป' }
         ],
       }
     ]
   }),
   created(){
     // this.Home(),
     this.show_data_image(),
     this.check_login(),
     this.getdata_profile(),
     this.check_show_want_buy(),
     this.count_buy_number_user()
     // var x = this.$cookies.get('kidakarn')
     // var decodeemptoken = Decode.decode(x)
   },
   methods:{
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

       console.log('this.parameters.username',this.parameters.username)
       console.log('this.path_query',this.path_query)
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
     manage (item){
       console.log('item======',item);
       if (item=='login'){
         // this.login()
       }
       if (item=='ออกจากระบบ'){
         this.logout()
       }
       else if (item=='cart') {
         console.log('cart');
         this.Cart()
       }
       else if (item=='home') {
         this.Home()
       }
       else if (item=='ผู้ใช้') {
         this.manage_user()
       }
       else if (item=='รูป') {
         this.manage_image()
       }
      else if (item=='Canceled'){
        this.edit_user = false
      }
       else {
         this.get_parameter(item)
       }
     },
     logout(){
       if (this.$cookies.get('kidakarn')!=null){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
         var user = this.placeInfo.data[0].username
         this.axios.get(process.env.VUE_APP_URL+'/logout/'+user).then((result) =>{
           if (result.status===200)
           this.$cookies.remove('kidakarn')
           this.$cookies.remove('number_user_buy')
           window.location.href='/main'
         })
         // this.$router.push('/m')
         // this.$swal('ออกจากระบบ ! ', 'ทำการออกจากระบบเรียบร้อย', 'success')
       }
     },
     manage_user(){
       this.$router.push('/table2')
       // console.log('manage_user');
     },
     Cart(){
       this.$router.push('/Check')
     },
     Home(){
           // this.show_navbar=true
           // this.check_show=false
             this.$router.push('/Main')
     },
     manage_image(){
           this.$router.push('/image')
     },
     nextmain(){
         this.$router.push('/main')
     },
     check_size(){
       if (this.isMobile = window.innerWidth < 1620){
         this.check_menu=true
         return false
       }
       else{
         this.check_menu=false
         return true
       }
     },
     get_parameter(parameter){
       this.$router.push('/des/'+parameter)
       var p =' /des/'+parameter
       window.location.href=p
       // console.log('parameter',parameter);
     },
     show_data_image(){
         this.axios.get(process.env.VUE_APP_URL+'/get_category').then((result) =>{
             var data= result.data
                 this.length_data = result.data
             for (var i = 0; i < data.length; i++) {
               this.items.push({
                 cat_id:data[i]["cat_id"],
                 text:data[i]["cat_name"],
                 cat_icon:data[i]["cat_icon"]
               })
             }
             this.items.push({ icon: '',   text:'ออกจากระบบ'})
         })
         console.log(this.items);
     },
     check_login(){
       if ($cookies.get('kidakarn') == null){
         return true
       }
       else {
         return false
       }
     },
     getdata_profile(){
       if (this.$cookies.get('kidakarn')!=null){
            this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
            console.log('=====decode', this.placeInfo.data[0])
            this.profiles_user = {
                                user_id:this.placeInfo.data[0].user_id,
                                fname:this.placeInfo.data[0].fname,
                                lname:this.placeInfo.data[0].lname,
                                username:this.placeInfo.data[0].username,
                                password:this.placeInfo.data[0].password,
                                phone:this.placeInfo.data[0].phone,
                                status:this.placeInfo.data[0].status,
                                user_image:this.placeInfo.data[0].user_image,
                                user_address:this.placeInfo.data[0].user_address
                                 }
             // console.log('user_id========',this.profiles_user.user_id)
        }
     },
     check_show_want_buy(){
         if (this.$router.currentRoute.name!='Main' && this.$router.currentRoute.name!='Index'){
           return true
         }
         else {
           return false
         }
     },
     count_buy_number_user(){
       if(this.$cookies.get('kidakarn')!=null){
         this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('number_user_buy')))
         this.number_user_buy = {count_buy_id:this.placeInfo.data[0].count_buy_id}
       }
     },
     Edit_user(){
       var pack_update =
         {
          user_id:this.profiles_user.user_id,
          fname: this.profiles_user.fname,
          lname: this.profiles_user.lname,
          username: this.profiles_user.username,
          password: this.profiles_user.password,
          status: this.profiles_user.status,
          phone: this.profiles_user.phone,
          image: this.profiles_user.user_image,
          user_address: this.profiles_user.user_address
         }
         if (this.selectedFile != ''){
           pack_update =  pack_update =
             {
              user_id:this.profiles_user.user_id,
              fname: this.profiles_user.fname,
              lname: this.profiles_user.lname,
              username: this.profiles_user.username,
              password: this.profiles_user.password,
              status: this.profiles_user.status,
              phone: this.profiles_user.phone,
              image: this.selectedFile.name,
              user_address: this.profiles_user.user_address
             }
         }
         var user = this.profiles_user.username
         var pass = this.profiles_user.password
         var condtion_if_cookies = 0
         this.parameters = {username:user}
         console.log('user===',user)
         console.log('pass===',pass)
       this.axios.post(process.env.VUE_APP_URL+'/update_data',pack_update).then((result) =>{
             if (this.selectedFile != ''){
                 this.path_query = "Edit_user"
                 this.onUpload()
                 this.selectedFile = ''
                 this.selectedFile = {name:''}
               }
               this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
               var user = this.placeInfo.data[0].username
               var pass = this.placeInfo.data[0].password
               this.axios.get(process.env.VUE_APP_URL+'/login/'+user+'/'+pass).then((result_data_new) => {
                 this.$cookies.remove('kidakarn')
                 var emptoken = Encode.encode(result_data_new)
                 this.$cookies.set('kidakarn', emptoken, null, '/', process.env.CK)
                 console.log('result data===>',result_data_new);
                  if (result.status===200){
                    this.$swal('แก้ไขสำเร็จ ! ', '', 'success').then(result =>{
                      this.axios.get(process.env.VUE_APP_URL+'/login/'+user+'/'+pass).then((res) => {
                        this.imageUrl = ''
                       var emptoken2 = Encode.encode(res)
                        this.$cookies.set('kidakarn', emptoken2, null, '/', process.env.CK)
                        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
                        this.profiles_user = {
                        user_id:this.placeInfo.data[0].user_id,
                        fname:this.placeInfo.data[0].fname,
                        lname:this.placeInfo.data[0].lname,
                        username:this.placeInfo.data[0].username,
                        password:this.placeInfo.data[0].password,
                        phone:this.placeInfo.data[0].phone,
                        status:this.placeInfo.data[0].status,
                        user_image:this.placeInfo.data[0].user_image,
                        user_address:this.placeInfo.data[0].user_address
                       }
                      })
                       // console.log('=====decode ', this.placeInfo.data[0])
                    })
                  }
                // alert("แก้ไขข้อมูลส่วนตัวสำเร็จ")
                // window.location.href='/Main'
               })
         console.log('status_check_image',this.status_check_image)
       }).catch((err) => {
         console.log('2', err.result);
         alert("Updateไม่สำเร็จ");
       })
     }
   },
   props: {
     source: String
   }
}
</script>

<style lang="css" scoped>
.in-progress {
 cursor: progress;
}
.cursor1{
 Cursor: pointer
}
.circle{
 border-radius: 50%; /* ปรับเป็น 50% คือความโค้งของเส้นขอบ*/
}
</style>
