<template>
  <div>
    <v-layout row wrap>
      <v-btn flat slot="activator" dark style="font-family: 'Kanit', sans-serif;" @click="manage_sell()">อยากขาย</v-btn>
      <v-menu :close-on-content-click="false" :nudge-width="200" offset-y>
      <v-btn flat slot="activator" dark   style="font-family: 'Kanit', sans-serif;">หาซื้อ<v-icon>apps</v-icon></v-btn>
      <v-card class="scroll-y" width="400">
        <v-card-text style="height: 510px">
          <v-container grid-list-xl>
            <v-layout row wrap >
              <v-flex v-for="item in getdata_img" xl4 class="px-1"  @click="get_data_icon(item.cat_id)" style="cursor:pointer">
                <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                        <v-img :src="require('../img_icon/'+item.cat_icon)" dark v-on="on"/>
                  <v-flex xl12>
                    {{ item.cat_name }}
                  </v-flex>
                </template>
                <span>{{ item.cat_name }}</span>
              </v-tooltip>
              </v-flex>
              <!-- <v-flex xs4>
                <v-img :src="require('../img_icon/'+'1.jpg')" />
              </v-flex>
              <v-flex xs4>
                <v-img :src="require('../img_icon/'+'1.jpg')" />
              </v-flex>
              <v-flex xs4>
                <v-img :src="require('../img_icon/'+'1.jpg')" />
              </v-flex> -->
            </v-layout>
          </v-container>
        </v-card-text>
       </v-card>
    </v-menu>
    <v-menu offset-y v-if="status_user=='A'">
      <v-btn flat slot="activator"  style="font-family: 'Kanit', sans-serif;"><v-icon >personal_video</v-icon></v-btn>
      <v-list>
        <v-list-tile>
          <v-btn flat pl-2 class="curse"  @click="manage_cat()" >ประเภทหมวดหมู่</v-btn>
        </v-list-tile>
        <v-list-tile>
          <v-btn flat depressed style="cursor: pointer;" @click="manage_groups()">หมวดหมู่</v-btn>
        </v-list-tile>
        <v-list-tile>
          <v-btn flat class="pl-2 " style="cursor:pointer;font-family: 'Kanit', sans-serif; "  @click="manage_user()">สมาชิก</v-btn>
        </v-list-tile>
        <v-list-tile>
          <v-btn  flat class="pl-2 "style="cursor:pointer;font-family: 'Kanit', sans-serif; "   @click="manage_sell()">การลงขาย</v-btn>
        </v-list-tile>
        <v-list-tile>
          <v-btn flat class="pl-2 " style="cursor:pointer;font-family: 'Kanit', sans-serif; "   @click="manage_buys()">การซื้อสินค้า</v-btn>
        </v-list-tile>
      </v-list>
    </v-menu>
    </v-layout>
  </div>
</template>

<script>
import { Encode, Decode } from '@/service'
  export default {
    data: () => ({
      reviews: 413,
      value: 4.5,
      // menu:false ,
      getdata_img:[],
      status_user:'',
      items: [
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me' },
        { title: 'Click Me 2' }
      ]
    }),
    created(){
    this.show_data_image()
    this.check_status_login()
  },
    methods:{
      show_data_image(){
          this.axios.get(process.env.VUE_APP_URL+'/get_category').then((result) =>{
              var data= result.data
              for (var i = 0; i < data.length; i++) {
                this.getdata_img.push({
                  cat_id:data[i]["cat_id"],
                  cat_name:data[i]["cat_name"],
                  cat_icon:data[i]["cat_icon"]
                })
              }
          })
      },
      get_data_icon(para){
        // console.log(para)
        this.$router.push('/des/'+para)
        var p =' /des/'+para
        window.location.href=p
      },
      check_status_login(){
      if (this.$cookies.get('kidakarn') != null){
            this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
            this.status_user = this.placeInfo.data[0].status
            console.log('status_user============',this.status_user);
          }
      },
      manage_user(){
        this.$router.push('/Manage_user')
      },
      manage_sell(){
        if (this.$cookies.get('kidakarn') == null){
          this.$swal('กรุณาทำการเข้าสู่ระบบ ! ', '', 'warning')
        }
        else {
          this.$router.push('/Manage_sell')
        }
      },
      manage_buys(){
        this.$router.push('/Manage_buys')
      },
      manage_cat(){
        this.$router.push('/Manage_cat')
      },
      manage_groups(){
        this.$router.push('/Manage_groups')
      }
    }
  }
</script>

<style lang="css" scoped>
.curse {
  cursor: pointer;
}
</style>
