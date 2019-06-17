
<template>
  <v-layout row justify-center>
    <v-btn flat @click.stop="dialog = true" flat slot="activator" dark style="font-family: 'Kanit', sans-serif;" >
      เข้าสู่ระบบ
    </v-btn>
    <v-dialog v-model="dialog" max-width="350" >
      <v-card>
        <v-card-title class="headline">เข้าสู่ระบบ</v-card-title>
        <v-card-text>
          <v-container grid-list-xs>
              <v-form ref="form" lazy-validation>
                <v-text-field v-model="user" :counter="10" :rules="username" label="ชื่อผู้ใช้" required></v-text-field>
                <v-text-field type="password" v-model="pass" :rules="password_user"label="รหัสผ่าน" required ></v-text-field>
                <v-btn  color="primary"  v-on:keyup.enter="validate" @click="validate">
                  เข้าสู่ระบบ
                </v-btn>
                <v-btn color="error" @click="reset">
                  ยกเลิก
                </v-btn>
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
      de:null,
      dialog: false,
      getdata_login:[],
      decodeemptoken:[],
      valid: true,
      user:'',
      pass:'',
      name: '',
      result:[],
      username: [
        v => !!v || 'กรุณาใส่ชื่อผู้ใช้',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters'
      ],
      email: '',
      password_user: [
        v => !!v || 'กรุณาใส่รหัสผ่าน'
      ]
    }),
    methods: {
      validate () {
        if (this.$refs.form.validate()) {
          this.snackbar = true
          var pack_login = {
            username:this.user,
            password:this.pass
          }
          // console.log(pack_login);
          this.axios.get(process.env.VUE_APP_URL+'/login/'+this.user+'/'+this.pass).then((result) => {
            // var t = result.data
            var data = result.data
            console.log('==================',data);
            if (result.data==='NO_DATA'){
              this.$swal('ฮั่นแน่ ! ', 'คุณยังไม่ได้สมัครสมาชิก', 'warning')
              console.log('No success');
            }
            else if (data.length>0) {
              console.log('login_success');
                this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+this.user).then((count) => {
                  var emptoken_count = Encode.encode(count)
                  var data_count = count.data
                  console.log('count======',data_count[0].count_buy_id)
                  this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
                  var emptoken = Encode.encode(result)
                  this.$cookies.set('kidakarn', emptoken, null, '/', process.env.CK)
                  var x = this.$cookies.get('kidakarn')
                  // this.decodeemptoken = {obj:Decode.decode(x)}
                  // console.log("decodeemptoken=======",this.decodeemptoken.obj);
                  this.check_show=true
                  // this.$swal('ถูกต้อง ! ', 'สามารถเข้าระบบได้', 'success')
                  // this.$router.push('/main')
                  this.dialog = false
                  window.location.href='/main'
                })
            }
            else {
                this.$swal('ผิดพลาด ! ', 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง', 'error')
                console.log('data====>',data);
            }
          })
        }
      },
      reset () {
        this.$refs.form.reset()
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
