<template>
  <div>
    <v-toolbar dark style="background-color:#1b9900">
      <h1 class="font">Sales Quotation</h1>
    </v-toolbar>

     <v-container grid-list-lg>
        <v-layout align-center justify-center align-center fill-height>
          <v-flex xs12 sm8 md6>
            <div class="divsize">
              <v-card style="padding:20px;">
                <v-img src="/img/inetlogo.png" style="margin:auto" class="logo_size"></v-img>
              </v-card>
              <v-card>
                <v-toolbar dark style="background-color:#1b9900"><v-toolbar-title style="margin:auto;">S A L E</v-toolbar-title></v-toolbar>
                <v-card-text>
                  <v-form ref="form" v-model="valid">
                    <v-text-field v-model="userName" prepend-icon="person" name="login" label="Login" type="text" :rules="emailRules" required></v-text-field>
                    <v-text-field v-model="passWord" prepend-icon="lock" name="password" label="Password" type="password" @keyup.enter="validate()" :rules="nameRules" required></v-text-field>
                  </v-form>
                </v-card-text>
                <v-card-actions style="padding:20px;">
                  <v-spacer></v-spacer>
                  <v-btn style="background-color:#1b9900;" class="btnsize" dark @click="validate()">Login</v-btn>
                </v-card-actions>
              </v-card>
            </div>



          </v-flex>
        </v-layout>
      </v-container>

      <Loading ref="loading"></Loading>
      </div>
</template>

<script>
import Loading from '@/components/Loading'
import { Encode, Decode } from '@/service'
  export default {
    components: {
      Loading
    },
    data () {
      return {
      userName:'',
      passWord:'',
      Saleuserid:null,
      Salegroup:null,
      valid: false,
      sale_group:[],
      nameRules: [
        v => !!v || 'จำเป็นต้องกรอกข้อมูลนี้',
      ],
      emailRules: [
        v => !!v || 'จำเป็นต้องกรอกข้อมูลนี้',
        v => /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) || 'รูปแบบ E-mail ไม่ถูกต้อง'
      ]
      }
    },
    methods : {
      validate () {
          if (this.$refs.form.validate()) {
            this.insert()
          }
        },
        openLoading () {
          this.$refs.loading.open()
        },
        hideLoading () {
          this.$refs.loading.hide()
        },
      insert () {
        this.openLoading()
        this.axios.get(process.env.VUE_APP_API_LOGIN + '/api/v1/login/' + this.userName + '/'+ encodeURIComponent(this.passWord), {headers: {Authorization: '3d9ca476-9340-4093-abae-51327e81fe93'}}).then((response) => {
          if (response.status === 200) {
            // console.log('======= success ======')
            this.Saleuserid = response.data.userid
            var result = response.data
            // console.log(result)
            // console.log('Before === ', result)
            // console.log('After === ', emptoken)

            // console.log(this.Saleuserid)

            // this.axios.get('http://203.154.135.191:7000/sale_api/v1/sale/'+ this.Saleuserid, {headers: {Authorization: '9ea07dc1-0447-48b3-a24c-6e8cba0feb80'}}).then((response) => {
            // this.axios.get('http://203.154.135.191:7000/sale_api/v1/sale/'+ '17006', {headers: {Authorization: '9ea07dc1-0447-48b3-a24c-6e8cba0feb80'}}).then((response) => {
              // this.axios.get('http://203.154.59.212:5000/api/v1/get_sale/'+ '58145' ).then((response) => {
              this.axios.get('https://inetcvm.one.th/api/api/v1/get_sale/'+ this.Saleuserid ).then((response) => {
              // console.log(response.data)
              // console.log(response.data.data)
              // console.log(response.data.status)
              // var getSale = response.data.data
              // console.log(response.data.data[0].sale_team_name)
              if (response.data.status === 'ok') {
                var data = {
                              department: result.department,
                              email: result.email,
                              lastname: result.lastname,
                              name: result.name,
                              service_name: result.service_name,
                              title: result.title,
                              userid: result.userid,
                              salegroup: response.data.data[0].sale_team_name,
                              status: 'login'
                          }
                // console.log(data)
                var emptoken = Encode.encode(data)
                this.$cookies.set('emptoken', emptoken, null,process.env.VUE_APP_TEST)
                this.$store.commit('setHasRegis', true)

                this.axios.post(process.env.VUE_APP_API_URL+ '/checklogin',data ).then((response) => {

                })
                this.$refs.loading.hide()
                  this.$router.push('/history')
              }
              else if (response.data.status === 'deny') {
                this.axios.get(process.env.VUE_APP_API_URL+ '/checkAdmin/' + this.Saleuserid ).then((response) => {
                  // console.log(response.data)
                  if (response.data == 'success') {
                    var data = {
                                  department: result.department,
                                  email: result.email,
                                  lastname: result.lastname,
                                  name: result.name,
                                  service_name: result.service_name,
                                  title: result.title,
                                  userid: result.userid,
                                  salegroup: 'Admin',
                                  status: 'login'
                              }
                    // console.log(data)
                    var emptoken = Encode.encode(data)
                    this.$cookies.set('emptoken', emptoken, null,process.env.VUE_APP_TEST)
                    this.$store.commit('setHasRegis', true)

                    this.axios.post(process.env.VUE_APP_API_URL+ '/checklogin', data).then((response) => {

                    })
                    this.$refs.loading.hide()
                      this.$router.push('/history')
                  }
                  else {
                    this.$refs.loading.hide()
                    this.$swal('ผิดพลาด ! ', 'เฉพาะพนักงานฝ่ายขายเท่านั้น', 'error')
                  }
                })
              }
              else {
                this.$refs.loading.hide()
                this.$swal('ผิดพลาด ! ', 'เฉพาะพนักงานฝ่ายขายเท่านั้น', 'error')
              }
            })

            // var x = this.$cookies.get('emptoken')
            // var decodeemptoken = Decode.decode(x)
            // console.log("AfterDecode :",decodeemptoken)



          }
        }).catch((err) => {
          this.$refs.loading.hide()
          if (err.response.status === 400) {
            this.$swal('ผิดพลาด ! ', 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง', 'error')
          } else if (err.response.status === 401) {
            this.$swal('ผิดพลาด ! ', 'Authorization ไม่ถูกต้อง', 'error')
          } else if (err.response.status === 404) {
            this.$swal('ผิดพลาด ! ', 'กรุณาใส่ข้อมูลให้ครบถ้วน', 'error')
          } else if (err.response.status === 500) {
            this.$swal('ผิดพลาด ! ', 'Serverมีปัญหา กรุณาติดต่อ Admin', 'error')
          }
        })
      }
    },
    created () {
      console.log(process.env.NODE_ENV)
      if (this.$cookies.get('emptoken') !== null) {
        this.$router.push('/history')
      }
    }
}
</script>
<style lang="css" scoped>
.btnsize {
  width: 200px;
}
@media screen and (min-width: 300px) {
  .btnsize {
    width:100%;
  }
  .logo_size {
    width:250px;
  }
}
@media screen and (min-width: 768px) {
  .btnsize {
    width:200px;
  }
  .logo_size {
    width:300px;
  }
}
@media screen and (min-width: 1000px) {
  .btnsize {
    width:200px;
  }
  .logo_size {
    width:250px;
  }
}
@media screen and (min-width: 1400px) {
  .btnsize {
    width:200px;
  }
  .logo_size {
    width:350px;
  }
  .divsize {
    margin:100px;
  }
}
</style>
