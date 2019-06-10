<template>
  <v-layout row justify-center>
    <v-btn flat @click.stop="dialog = true" flat slot="activator" dark style="font-family: 'Kanit', sans-serif;" >
      สมัครสมาชิก
    </v-btn>
    <v-dialog v-model="dialog" max-width="350" >
      <v-card>
        <v-card-title class="headline">สมัครสมาชิก</v-card-title>
        <v-card-text>
          <v-container grid-list-xs>
            <v-form ref="form">
                <v-layout wrap>
                    <v-flex xs12 sm6 md12 xl6>
                      <v-text-field v-model="insert_user.fname" :rules="fname" label="ชื่อ"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md12 xl6>
                      <v-text-field v-model="insert_user.lname" :rules="lname"label="นามสกุล"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md12 xl6>
                      <v-text-field v-model="insert_user.username" :rules="username"label="ชื่อผู้ใช้"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md12 xl6>
                      <v-text-field v-model="insert_user.password" :rules="password"type="password"label="รหัสผ่าน"></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md12 xl12>
                      <v-text-field v-model="insert_user.phone" type="number":rules="phone" label="เบอร์โทรศัพท์"></v-text-field>
                      <!-- <v-text-field v-model="editedItem.status" label="ที่อยู่"></v-text-field> -->
                    </v-flex>
                    <v-flex xs12 sm6 md12 xl12>

                      <img :src="imageUrl" height="150" v-if="imageUrl"/>
                      <input type="file" ref="image" accept="image/*" @change="onFilePicked">
                      <!-- <v-text-field v-model="insert_user.image" :rules="image" label="รูป"></v-text-field> -->
                    </v-flex>
                    <v-flex xs12 sm6 md12>
                      <v-textarea outline name="input-7-4" label="ที่อยู่" v-model="insert_user.user_address" :rules="user_address"value="The Woodman set to work at once, and so sharp was his axe that the tree was soon chopped nearly through."></v-textarea>
                    </v-flex>
                </v-layout>
                <v-flex xs12 sm6 md12 offset-xl3>
                  <v-btn color="success" @click="register_user()">สมัคร</v-btn>
                </v-flex>
              </v-form>
          </v-container>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-layout>
</template>
<script>
import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      title: "Image Upload",
      dialog: false,
      imageName: '',
      imageUrl: '',
      imageFile: '',
      valid: true,
      request:[],
      insert_user:{
                    fname:'',
                    lname:'',
                    username:'',
                    password:'',
                    phone:'',
                    image:'default.png',
                    status:'U',
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
      de:null,
      dialog: false,
      getdata_login:[],
      decodeemptoken:[],
      valid: true,
      user:'',
      pass:'',
      name: '',
      result:[],
      email: '',
      selectedFile:''
    }),
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
        vm.dialog = true
        const formData = new FormData()
        formData.append('file', this.selectedFile, this.selectedFile.name)
        formData.append('username', this.insert_user.username)
        formData.append('location_parameters', 'Insert_user')
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
          vm.dialog = false
        })
          .catch(function () {
            console.log('FAILURE!!')
          })
      },
      reset () {
        this.$refs.form.reset()
      },
      register_user(){
        if (this.$refs.form.validate(true)){
          console.log(this.insert_user)
          this.axios.post(process.env.VUE_APP_URL+'/add_data',this.insert_user).then((result) =>{
            var data = result.data
            if (this.selectedFile != ''){
              this.onUpload()
              this.selectedFile = ''
              this.selectedFile = {name:''}
            }
            if (data===200){
              this.$swal('สมัครสำเร็จ ! ', '', 'success')
              this.dialog  = false
              this.insert_user = {
                            fname:'',
                            lname:'',
                            username:'',
                            password:'',
                            phone:'',
                            image:'default.png',
                            status:'U',
                            user_address:''
              }
              this.$refs.form.resetValidation()
            }
            else if (data===150) {
              this.$swal('usernameนี้มีการใช้งานแล้ว ! ', '', 'error')
            }
            console.log("result=====",result);
          }).catch((err) =>{
            console.log(err);
          })
        }
      }
    }
  }
</script>
<style lang="css" scoped>
  .form-dark .font-small {
    font-size: 0.8rem; }

  .form-dark [type="radio"] + label,
  .form-dark [type="checkbox"] + label {
    font-size: 0.8rem; }

  .form-dark [type="checkbox"] + label:before {
    top: 2px;
    width: 15px;
    height: 15px; }

  .form-dark .md-form label {
    color: #fff; }

  .form-dark input[type=text]:focus:not([readonly]) {
    border-bottom: 1px solid #00C851;
    -webkit-box-shadow: 0 1px 0 0 #00C851;
    box-shadow: 0 1px 0 0 #00C851; }

  .form-dark input[type=text]:focus:not([readonly]) + label {
    color: #fff; }

  .form-dark input[type=password]:focus:not([readonly]) {
    border-bottom: 1px solid #00C851;
    -webkit-box-shadow: 0 1px 0 0 #00C851;
    box-shadow: 0 1px 0 0 #00C851; }

  .form-dark input[type=password]:focus:not([readonly]) + label {
   color: #fff; }

  .form-dark input[type="checkbox"] + label:before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 17px;
    height: 17px;
    z-index: 0;
    border: 1.5px solid #fff;
    border-radius: 1px;
    margin-top: 2px;
    -webkit-transition: 0.2s;
    transition: 0.2s; }

  .form-dark input[type="checkbox"]:checked + label:before {
    top: -4px;
    left: -3px;
    width: 12px;
    height: 22px;
    border-style: solid;
    border-width: 2px;
    border-color: transparent #00c851 #00c851 transparent;
    -webkit-transform: rotate(40deg);
    -ms-transform: rotate(40deg);
    transform: rotate(40deg);
    -webkit-backface-visibility: hidden;
    -webkit-transform-origin: 100% 100%;
    -ms-transform-origin: 100% 100%;
    transform-origin: 100% 100%; }
</style>
