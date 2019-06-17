<template lang="html">
  <v-container>
      <v-layout row wrap >
          <v-flex v-for="item in getdata_img" xs12 sm4>
            <v-container >
            <v-card >
              <v-container >
              <v-img :src="require('../image/'+item.image)" width="100%" height="200px"/>
            </v-container>
              <!-- <v-img src="../image/1.jpg" aspect-ratio="2.75"></v-img> -->
              <v-card-title primary-title>
                <div>
                  <h3 class="headline mb-0"><b class="color_red">หัวข้อ:</b>   {{item.title}}</h3>
                  <div>
                    <b class="color_font">
                    รายละเอียด:
                  </b>
                    {{ item.description }}
                  </div>
                </div>
              </v-card-title>
              <v-card-actions>
                <v-btn flat color="orange">ที่อยู่</v-btn>
                <v-btn flat color="orange">Explore</v-btn>
              </v-card-actions>
            </v-card>
          </v-container>
          </v-flex>
        </v-layout>
    </v-container>
</template>

<script>
export default {
  data: () => ({
    getdata_img:[]
      }),
  created () {
      this.show_data_image()
    },
  methods:{
    show_data_image(){
      var x = this.$cookies.get('kidakarn')
      if (x==null){this.$router.push('/')}
      else{
        this.axios.get(process.env.VUE_APP_URL+'/get_image_database').then((result) =>{
            var data= result.data
            for (var i = 0; i < data.length; i++) {
              this.getdata_img.push({
                img_id:data[i]["img_id"],
                user_id:data[i]["user_id"],
                title:data[i]["title"],
                image:data[i]["image"],
                address:data[i]["address"],
                description:data[i]["description"]
              })
            }
        })
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
</style>
