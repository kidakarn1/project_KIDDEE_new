<template lang="html">
<v-container grid-list-xs,sm,md,lg,xl>
  <v-layout row wrap>
    <v-flex offset-xs1 offset-lg5 offset-sm5 offset-xs5>
      <v-img :src="require('../img_icon/check.png')" width="30%" />
    </v-flex>
    <v-flex xs12 md12 lg12 >
      <center><h1 style="color:red">เสร็จสิ้นการสั่งซื้อ</h1></center>
    </v-flex>
    <v-flex xs12 md12 lg12>
      <center><v-btn color="primary" @click="print_bill()"><h3>ปริ้นใบเสร็จ</h3></v-btn></center>
    </v-flex>
  </v-layout>
</v-container>
</template>

<script>
export default {
    data: () => ({
    }),
    created(){
      this.checkcookies()
    },
    methods:{
      checkcookies(){
        if (this.$cookies.get('kidakarn')==null){
            this.$router.push('/Main')
        }
      },
      print_bill(){
        this.$router.push('/Print_bill')
        // window.print()
      }
    }
}
</script>

<style lang="css" scoped>
.size_done{
  width:20%;
  height:300%;
}
</style>
