<template>
  <v-layout row wrap>
    <v-flex v-for="item in getdata_img" class='xs12 sm6 md4 lg4 xl'>
        <v-layout row wrap>
          <v-container>
            <v-hover>
              <v-card  slot-scope="{ hover }" :class="`elevation-${hover ? 12 : 2} cursor1`" @click="get_para(item.cat_id)">
                <v-img :src="require('../img_icon/'+item.cat_icon)"  height="250px"/>
                <v-card-title primary-title>
                </v-card-title>
                <v-card-actions>
                  <h3>{{item.cat_name}}</h3>
                </v-card-actions>
              </v-card>
            </v-hover>
          </v-container>
        </v-layout>
    </v-flex>
  </v-layout>

</template>

<script>
export default {
  data: () => ({
    size_res:'',
    getdata_img:[]
      }),
  created () {
      this.show_data_image(),
      this.check_cookie_data_of_Description()
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
            this.$cookies.set('pk_sell','', null, '/', process.env.CK)
        })
    },
    get_para(para){
      console.log(para);
      this.$router.push('/des/'+para)
      // var p =' /des/'+para
      // window.location.href=p
    },
    check_cookie_data_of_Description(){
      if(this.$cookies.get('cookie_data')!=null){
        this.$cookies.remove('cookie_data')
      }
    },
    test1(){
      if (this.isMobile = window.innerWidth < 1620){
        this.size_res ='xs6 sm6 md6'
        return this.size_res
      }
      else{
        this.size = 2
        this.size_res ='xs6 sm6 md2'
        return this.size_res
      }
    }
  }
}
</script>

<style lang="css" scoped>
.color_font{
  color:#0000FF
}
.color_red{
  color:red
}
.in-progress {
  cursor: progress;
}
.cursor1{
  Cursor: pointer
}
.m_w {
  max-width: 150px;
}
</style>
