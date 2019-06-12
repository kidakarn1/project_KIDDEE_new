<template>
  <v-container grid-list-xs,sm,md,lg,xl>
    <v-layout row wrap>
      <v-flex offset-xs4 xs6 offset-sm4 sm8 offset-md11 md1 offset-lg11 lg1 offset-xl11 xl1>
          <export-excel
            class = "btn btn-default"
            :data = "excel_data"
            :fields = "excel_fields"
            worksheet = "My Worksheet"
            name = "Report_sell.xls">
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
      </v-flex>
      <v-flex offset-xs3 xs8 offset-sm4 sm8 offset-md5 md8 offset-lg5 lg8 offset-xl5 xl8>
        <h1>รายงานการขายสินค้า</h1>
      </v-flex>
      <v-flex  offset-xs0 xs8  offset-sm1 sm8 offset-md2 md7 offset-lg6 lg3>
        <v-autocomplete v-model="model" :items="get_cat" :loading="isLoading" :search-input.sync="search" label="ค้นหาประเภทสินค้าที่ลงขาย" item-text="cat_name" item-value="cat_id" color="warning">
        </v-autocomplete>
        </v-flex>
    <v-flex  lg1>
      <v-btn  color="success"  @click="show_data_sell()">ค้นหา</v-btn>
    </v-flex>
      <v-flex  offset-xs1 xs11 offset-sm2 sm8 offset-md2 md8 offset-lg2 lg8 offset-xl2 xl8>
        <v-data-table :headers="headers" :items="result" class="elevation-1" :pagination.sync="pagination">
          <template v-slot:items="props">
            <td>{{ props.item.sell_id }}</td>
            <td>{{ props.item.cat_name }}</td>
            <td>{{ props.item.groups_name }}</td>
            <td>{{ props.item.sell_name }}</td>
            <td>{{ props.item.fname }}  {{ props.item.lname }}</td>
            <td>{{ props.item.sell_price }}</td>
            <td>{{props.item.date_start}} </td>
            <td>{{ props.item.sell_number }}</td>
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
    get_cat:[],
    isLoading: false,
    items: [],
    model: null,
    search: null,
    isEditing: false,
    result:[],
    loadingbtn: false,
    excel_fields: {
      'รหัสการขาย': 'sell_id',
      'ประเภท': 'cat_name',
      'หมวดหมู่': 'groups_name',
      'รหัสการขาย': 'sell_id',
      'ชื่อสินค้า': 'sell_name',
      'ผู้ลงขาย': 'fname',
      'ราคา/ชิ้น': 'sell_price',
      'วันที่ลงขาย':"date_start",
      'จำนวนสินค้าที่เหลือ':'sell_number'
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
    headers: [
      { text: 'รหัสการขาย', align: 'left', sortable: false, value: 'sell_id' },
      { text: 'ประเภท', align: 'left', sortable: false, value: 'cat_name' },
      { text: 'หมวดหมู่', align: 'left', sortable: false, value: 'groups_name' },
      { text: 'ชื่อสินค้า', align: 'left', sortable: false, value: 'sell_name' },
      { text: 'ผู้ลงขาย', align: 'left', sortable: false, value: 'fname' },
      { text: 'ราคา/ชิ้น', align: 'left', sortable: false, value: 'sell_price' },
      { text: 'วันที่ลงขาย', align: 'left', sortable: false, value: 'date_start' },
      { text: 'จำนวนสินค้าที่เหลือ', align: 'left', sortable: false, value: 'sell_number' },
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
          text: 'รหัสการขาย',
          sortable: false,
          value: 'sell_id'
        },
        { text: 'ประเภท ', sortable: false },
        { text: 'หมวดหมู่ ', sortable: false },
        { text: 'ชื่อสินค้า ', sortable: false },
        { text: 'ผู้ลงขาย', sortable: false },
        { text: 'ราคา/ชิ้น', sortable: false},
        { text: 'วันที่ลงขาย', sortable: false},
        { text: 'จำนวนสินค้าที่เหลือ', sortable: false}
    ]
  }),
  watch: {
    search (val) {
      // Items have already been loaded
      if (this.get_cat.length > 0) return

      this.isLoading = true

      // Lazily load input items
      fetch('https://api.coinmarketcap.com/v2/listings/')
        .then(res => res.json())
        .then(res => {
          this.get_cat = res.data
        })
        .catch(err => {
          console.log(err)
        })
        .finally(() => (this.isLoading = false))
    }
  },
  created(){
    this.show_data_sell(),
    this.get_search()
  },
  methods:{
    test(){
      console.log('this.model====>',this.model);
    },
    show_data_sell(){
      this.result = []
       var x = this.$cookies.get('kidakarn')
       var username=''
       var status =''
       var pack=[]
      if (x!=null){
        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('kidakarn')))
        var username = this.placeInfo.data[0].username
        var status = this.placeInfo.data[0].status
        if (this.model===null){
          pack={username:username , status:status , patch:'Report_sell' , para:'%'}
        }
        else {
          pack={username:username , status:status , patch:'Report_sell' , para:this.model}
        }
        console.log('pack===>',pack)
      }
      else {
        this.$router.push('/main')
      }
          if (x==null){this.$router.push('/main')}
          else {
            this.axios.post(process.env.VUE_APP_URL+'/show_data_sell',pack).then((result) => {
             var result = result.data
             for(var i=0; i<result.length;i++){
               this.result.push({
                 index:i,
                 cat_id:result[i]["cat_id"],
                 cat_name:result[i]["cat_name"],
                 date_start:result[i]["date_start"],
                 description:result[i]["description"],
                 groups_id:result[i]["groups_id"],
                 groups_name:result[i]["groups_name"],
                 sell_address:result[i]["sell_address"],
                 sell_id:result[i]["sell_id"],
                 sell_number:result[i]["sell_number"],
                 sell_image:result[i]["sell_image"],
                 sell_name:result[i]["sell_name"],
                 sell_price:result[i]["sell_price"],
                 username:result[i]["username"],
                 fname:result[i]["fname"],
                 lname:result[i]["lname"]
               })
               this.result[i].date_start = this.setDate(this.result[i].date_start)
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
    },
    get_search(){
      this.axios.get(process.env.VUE_APP_URL+'/get_category').then((result) =>{
          var data= result.data
          if (result.status===200){
            for (var i = 0; i < data.length; i++) {
              this.get_cat.push({
                cat_id:data[i]["cat_id"],
                cat_name:data[i]["cat_name"]
              })
            }
          }
        })
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
