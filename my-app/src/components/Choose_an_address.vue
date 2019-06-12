<template lang="html">
<v-container grid-list-xs,sm,md,lg,xl>
  <v-layout row wrap>
      <v-flex xs12>
        <v-hover>
          <v-card slot-scope="{ hover }" :class="`elevation-${hover ? 12 : 2}`"   class="mx-auto" width="80%">
            <v-container grid-list-xs,sm,md,lg,xl>
                <v-flex offset-xs0 offset-lg4 offset-sm3 offset-md3 offset-xl5>
                    <v-container>
                      <h1  style="font-family: 'Kanit', sans-serif;">ที่อยู่ในการส่งสินค้า</h1>
                      <v-radio-group v-model="address" row>
                        <v-radio  style="font-family: 'Kanit', sans-serif;"    v-bind:value="{values_address}"
                          value="user_address" label="ที่อยู่ตามที่สมัคร" color="red" @click="switch_address('user_address')"></v-radio>
                        <v-radio  style="font-family: 'Kanit', sans-serif;"  value="new_address" label="ที่อยู่ใหม่" color="red darken-3" @click="switch_address('new_address')"></v-radio>
                      </v-radio-group>
                  </v-container>
                </v-flex>
                <v-flex v-if="address_show===true" offset-xs0 offset-lg5 offset-sm3 offset-md3 >
                  <h3>{{user_address}}</h3>
                </v-flex>
                <v-flex v-if="address_show===false" offset-xs0 offset-lg0 offset-sm0 offset-md0 lg12 offset-xl1 xl10>
                  <v-textarea outline v-model="new_address"name="input-7-4" label="ทึ่อยู่ต้องการจัดส่ง"></v-textarea>
                </v-flex>
                <v-flex  offset-xs0 offset-xs0 offset-lg5 offset-sm5 offset-md5 lg8 offset-xl1>
                  <v-btn color="primary" @click="Buy()">ตกลง</v-btn>
                </v-flex>
            </v-container>
          </v-card>
        </v-hover>
      </v-flex>
  </v-layout>
</v-container>
</template>

<script>
import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      new_address:'',
      values_address:'',
      address: 'user_address',
      address_show:true,
      buy_number:[],
      check_description:false,
      detail: [],
      dialog: false,
      get_sell:[],
      groups:[],
      groups1:[]
        }),
    created(){
      this.check_address()
    },
    watch:{
    },
    methods:{
      switch_address(paramerter_check){
        if (paramerter_check==='user_address'){
            this.address_show = true
            this.address = 'user_address'
        }
        else {
            this.address_show = false
            this.address = 'new_address'
        }
        // console.log('address====',this.address_show)
      },
      check_address(){
        if ($cookies.get('kidakarn') == null){this.$router.push('/Main')}
        if ($cookies.get('kidakarn')!=null){
          this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
          var user_address = this.placeInfo.data[0].user_address
          // console.log('address==',user_address)
          this.user_address = user_address
        }
      },
      Buy(){
        if ($cookies.get('kidakarn') != null){
          this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
          this.values_address = (this.address=='user_address')?  this.placeInfo.data[0].user_address : this.new_address
          if (this.values_address===''){
            this.$swal('กรุณาใส่ที่อยู่ของคุณที่ต้องการส่ง','','warning')
          }
          else {
            console.log('this.values_address====',this.values_address);
            var username = this.placeInfo.data[0].username
            var packgate_buy = {
                            username:this.placeInfo.data[0].username,
                            address:this.values_address
                           }
                           console.log('=====',packgate_buy)
            this.axios.post(process.env.VUE_APP_URL+'/Buys',packgate_buy).then((result) => {
             var data = result.data
               this.axios.get(process.env.VUE_APP_URL+'/count_buy/'+username).then((count) => {
                 var emptoken_count = Encode.encode(count)
                 this.$cookies.set('number_user_buy', emptoken_count, null, '/', process.env.CK)
                })
              if (result.status===200){
                alert('ซื้อสำเร็จ')
                window.location.href='/Bill'
              }
            })
          }
        }
      }
    }
  }
</script>

<style lang="css" scoped>
</style>
