<template>
  <v-container grid-list-xs,sm,md,lg,xl>
    <v-layout row wrap>
      <v-flex offset-xs4 xs6 offset-sm4 sm8 offset-md11 md1 offset-lg11 lg1 offset-xl11 xl3>
          <export-excel
            class = "btn btn-default"
            :data = "excel_data"
            :fields = "excel_fields"
            worksheet = "My Worksheet"
            name = "Report_buys.xls">
              <v-tooltip bottom>
                <v-btn
                  slot="activator"
                  :loading="loadingbtn"
                  :disabled="loadingbtn"
                  color="success"
                  @click="loader = 'loading3'"
                >
                  <v-icon>cloud_download</v-icon> Export
                  <v-icon class="fas fa-file-export" right dark></v-icon>
                </v-btn>
                <span>ส่งออกเป็น file excel</span>
              </v-tooltip>
            </export-excel>
            <v-btn color="info" @click="print()"><v-icon>print</v-icon></v-btn>
      </v-flex>
      <v-flex offset-xs3 xs8 offset-sm4 sm8 offset-md5 md8 offset-lg5 lg8 offset-xl5 xl8>
        <h1>รายงานการซื้อสินค้า</h1>

      </v-flex>
      <v-flex  offset-xs1 xs11 offset-sm2 sm8 offset-md2 md8 offset-lg2 lg8 offset-xl2 xl8>
        <v-data-table :headers="headers" :items="result" class="elevation-1" :pagination.sync="pagination">
          <template v-slot:items="props">
            <td>{{ props.item.buys_id }}</td>
            <td>{{ props.item.bill_id }}</td>
            <td>{{ props.item.sell_name }}</td>
            <td>{{ props.item.fname }}  {{ props.item.lname }}</td>
            <td>{{ props.item.sell_price }}</td>
            <td>{{ props.item.number_buy }}</td>
            <td>{{ props.item.price_total }}</td>
            <td>{{props.item.date_buy}}</td>
            <td>{{props.item.buys_expired_date}}</td>
            <td>{{props.item.buys_status}}</td>
          </template>
        </v-data-table>
        <!-- <table border="1">
          <tr>
            <th>รหัสสมาชิก</th> -->
            <!-- <th>รูป</th> -->
            <!-- <th>ชื่อ</th>
            <th>นามสกุล</th>
            <th>ที่อยู่</th>
            <th>สิทธิ์</th>
          </tr> -->
          <!-- <tr v-for="item in data_members" >
            <td>{{item.user_id}}</td> -->
            <!-- <td><v-img :src="require('../user_image/'+item.user_image)" width="100px" /></td> -->
            <!-- <td>{{item.fname}}</td>
            <td>{{item.lname}}</td>
            <td>{{item.user_address}}</td>
            <td>{{item.status}}</td>
          </tr>
        </table> -->
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import moment from 'moment'
import { Encode, Decode } from '@/service'
export default {
  data: () => ({
    result:[],
    loadingbtn: false,
    excel_fields: {
      'รหัสการซื้อ': 'buys_id',
      'หมายเลขบิล': 'bill_id',
      'ชื่อสินค้า': 'sell_name',
      'ผู้ซื้อ': 'fname',
      'ราคา/หน่วย': 'sell_price',
      'ราคารวม': 'price_total',
      'วันที่ซื้อ/ใส่ตระกร้า': 'date_buy',
      'วันที่สินค้าหมดอายุในตระกร้า': 'buys_expired_date',
      'สถานะ': 'buys_status'
    },
    excel_data: [],
    excel_meta: [
      [
        {
          'key': 'charset',
          'value': 'utf-8'
        }
      ]
    ],
    pagination: {
      sortBy: 'emp_ID',
      rowsPerPage: 25
    },
    valueprogress: 0,
    load: true,
    desserts: [],
    search: '',
    headers: [
      { text: 'รหัสการซื้อ', align: 'left', sortable: false, value: 'buys_id' },
      { text: 'หมายเลขบิล', align: 'left', sortable: false, value: 'bill_id' },
      { text: 'ชื่อสินค้า', align: 'left', sortable: false, value: 'sell_name' },
      { text: 'ผู้ซื้อ', align: 'left', sortable: false, value: 'fname' },
      { text: 'ราคา/หน่วย', align: 'left', sortable: false, value: 'sell_price' },
      { text: 'ราคารวม', align: 'left', sortable: false, value: 'price_total' },
      { text: 'วันที่ซื้อ/ใส่ตระกร้า', align: 'left', sortable: false, value: 'date_buy' },
      { text: 'วันที่สินค้าหมดอายุในตระกร้า', align: 'left', sortable: false, value: 'buys_expired_date' },
      { text: 'สถานะ', align: 'left', sortable: false, value: 'buys_status' }
    ],
    desserts: [],
    pagination: {
            sortBy: 'sell_id',
            rowsPerPage: 25
          },
    show_printer:true,
    data_members:[],
    headers: [
      {
        text: 'ลำดับ',
        align: 'left',
        value: 'buys_id'
      },
      { text: 'หมายเลขบิล', value: 'bill_id',sortable: false },
      { text: 'ชื่อสินค้า', value: 'sell_name',sortable: false },
      { text: 'ผู้ซื้อ', value: 'fname',sortable: false },
      { text: 'ราคา/หน่วย', value: 'sell_price',sortable: false },
      { text: 'จำนวน', value: 'number_buy',sortable: false },
      { text: 'ราคารวม', value: 'price_total',sortable: false },
      { text: 'วันที่ซื้อ/ใส่ตระกร้า', value: 'date_buy',sortable: false },
      { text: 'วันที่สินค้าหมดอายุในตระกร้า', value: 'date_buy',sortable: false },
      { text: 'สถานะ', value: 'buys_status',sortable: false }
    ],
  }),
  created(){
    this.show_data_buys()
  },
  methods:{
    show_data_buys(){
       var x = this.$cookies.get('kidakarn')
       var username=''
       var status =''
       var pack=[]
      if (x!=null){
        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
        var username = this.placeInfo.data[0].username
        var status = this.placeInfo.data[0].status
        var pack={username:username , status:status}
      }
      else {
        this.$router.push('/main')
      }
          if (x==null){this.$router.push('/main')}
          else {
            this.axios.get(process.env.VUE_APP_URL+'/show_data_buys').then((result) => {
             var result = result.data
             for(var i=0; i<result.length;i++){
               this.result.push({
                 bill_id:result[i]["bill_id"],
                 date_buy:result[i]["date_buy"],
                 description:result[i]["description"],
                 groups_id:result[i]["groups_id"],
                 groups_name:result[i]["groups_name"],
                 sell_address:result[i]["sell_address"],
                 sell_id:result[i]["sell_id"],
                 buys_id:result[i]["buys_id"],
                 sell_number:result[i]["sell_number"],
                 sell_image:result[i]["sell_image"],
                 sell_name:result[i]["sell_name"],
                 sell_price:result[i]["sell_price"],
                 username:result[i]["username"],
                 fname:result[i]["fname"],
                 lname:result[i]["lname"],
                 buys_status:result[i]["buys_status"],
                 number_buy:result[i]["number_buy"],
                 price_total:result[i]["number_buy"]*result[i]["sell_price"],
                 cat_id:result[i]["cat_id"],
                 cat_name:result[i]["cat_name"],
                 buys_expired_date:result[i]["buys_expired_date"]
               })
               this.result[i].date_buy = this.setDate(this.result[i].date_buy)
               this.result[i].buys_expired_date = this.setDate(this.result[i].buys_expired_date)
             }
             this.excel_data = this.result
             this.check_load=false
             console.log(this.result);
            })
          }
        },
    print(){
      var conn = confirm('คุณแน่ใจใช่มั้ยที่จะปริ้น')
      if (conn===true){
        window.print();
      }

      // if (conn===true){
      //
      // }
      console.log('print');

    },
    setDate (createAt) {
      moment.locale('th')
      var someDate = new Date(createAt)
      return moment(someDate).add(543, 'year', 7, 'hours').format('ll')
      // return moment(someDate).format('DD-MM-YYYY')date_start
    }
  }
}
</script>

<style>
/* table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  text-align: left;
  padding: 8px;
}

tr:nth-child(even){background-color: #f2f2f2}

th {
  background-color: #4CAF50;
  color: white;
} */
</style>
