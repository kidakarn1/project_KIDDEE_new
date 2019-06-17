<template lang="html">
  <v-container grid-list-xs,sm,md,lg,xl>
    <center>
      <table border="1">
        <thead>
          <tr>
            <th>ชื่อสินค้า</th>
            <th>ชื่อ-สกุลผู้ขาย</th>
            <th>เบอร์โทรผู้ขาย</th>
            <th>จำนวนที่ซื้อ</th>
            <th>ราคา/หน่วย</th>
            <th>รวมราคา</th>
          </tr>
        </thead>
        <tbody >
          <tr v-for="item in data_bill">
            <td>{{item.sell_name}}</td>
            <td>{{item.fname}} {{item.lname}}</td>
            <td>{{item.phone}}</td>
            <td>{{item.number_buy}}</td>
            <td>{{item.sell_price}}</td>
            <td>{{item.sum}}</td>
          </tr>
          <tr>
            <td colspan="3"></td>
            <td><h3>สินค้าทั้งหมด {{number_total}} ชิ้น</h3></td>
            <td colspan="2"><h3>ราคารวมทั้งหมด {{Net_amount}} บาท</h3></td>
          </tr>
        </tbody>
      </table>
      <v-btn color="primary" v-if="check_status_print===true" @click="print_bill()">ปริ้นใบเสร็จ</v-btn>
    </center>
  </v-container>
</template>

<script>
import { Encode, Decode } from '@/service'
export default {
  data: () => ({
    check_status_print:true,
    data_bill:[],
    Net_amount:0,
    number_total:0
  }),
  computed:{
  },
  watch:{
    check_status_print:{
      function(val){
        check_status_print = false
        console.log('hih===',check_status_print);
      }
    }
 },
  created(){
    this.show_data_buy()
  },
  methods:{
      show_data_buy(){
        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
        var username = {user:this.placeInfo.data[0].username}
        this.axios.post(process.env.VUE_APP_URL+'/show_user_buys_status',username).then((result) => {
          var data = result.data
          console.log(data)
          for (var i = 0; i < data.length; i++) {
            this.data_bill.push({
              bill_id   :data[i]["bill_id"],
              sell_name :data[i]["sell_name"],
              number_buy:data[i]["number_buy"],
              sell_price:data[i]["sell_price"],
              date_buy  :data[i]["date_buy"],
              fname     :data[i]["fname"],
              lname     :data[i]["lname"],
              phone     :data[i]["phone"],
              sum       :data[i]["number_buy"]*data[i]["sell_price"]
            })
            this.Net_amount+=this.data_bill[i].sum
            this.number_total+=this.data_bill[i].number_buy
          }
          console.log('====',this.data_bill[0].bill_id);
      })
    },
    print_bill(){
      this.check_status_print=false
      if (this.check_status_print===false){
          window.print()
          this.check_status_print=true
      }
    }
  }
}
</script>

<style lang="css" scoped>
</style>
