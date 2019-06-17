<template lang="html">
<v-container>
  <v-layout row wrap>
    <v-flex  offset-xs5>
        <v-btn fab  dark class="size_sell" color="warning" style="font-family: 'Kanit', sans-serif;">อยากขาย</v-btn>
        <v-btn fab  dark  color="success" style="font-family: 'Kanit', sans-serif;" @click="want_buy()">อยากซื้อ</v-btn>
  </v-flex>
  </v-layout>
  </v-container>
</template>

<script>
export default {
  data: () => ({

  }),
  methods:{
    want_buy(){
      this.$router.push('/main')
    }
  }
}
</script>

<style lang="css" scoped>
.size_sell{
  width:20%;
  height:300%;
}
.size_buy{
  width:10%;
  height:500%;
}
</style>
