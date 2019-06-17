<template>
  <v-container grid-list-xs,sm,md,lg,xl>
    <v-layout row wrap>
      <v-flex offset-xs4 xs6 offset-sm4 sm8 offset-md11 md1 offset-lg11 lg1 offset-xl11 xl1>
          <export-excel
            class = "btn btn-default"
            :data = "excel_data"
            :fields = "excel_fields"
            worksheet = "My Worksheet"
            name = "Report_log_login.xls">
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
        <h1>รายงานการเข้าใช้ระบบ</h1>

      </v-flex>
      <v-flex  offset-xs1 xs11 offset-sm2 sm8 offset-md2 md8 offset-lg2 lg8 offset-xl2 xl8>
        <v-data-table :headers="headers" :items="result" class="elevation-1" :pagination.sync="pagination">
          <template v-slot:items="props">
            <td>{{ props.item.login_id }}</td>
            <td>{{ props.item.username }}</td>
            <td>{{ props.item.fname }}  {{ props.item.lname }}</td>
            <td>{{ props.item.login_date }}</td>
            <td>{{props.item.status_login}}</td>
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
      'รหัสการเข้าใช้/ออก': 'login_id',
      'username': 'username',
      'ผู้เข้าใช้/ออก': 'full_name',
      'วันที่เข้าใช้/ออก': 'login_date',
      'สถานะ': 'status_login'
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
      { text: 'รหัสการเข้าใช้/ออก', align: 'left', sortable: false, value: 'login_id' },
      { text: 'username', align: 'left', sortable: false, value: 'username' },
      { text: 'ผู้เข้าใช้/ออก', align: 'left', sortable: false, value: 'fname' },
      { text: 'วันที่เข้าใช้/ออก', align: 'left', sortable: false, value: 'login_date' },
      { text: 'สถานะ', align: 'left', sortable: false, value: 'status_login' }
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
        text: 'รหัสการเข้าใช้/ออก',
        align: 'left',
        value: 'login_id',
        sortable: false
      },
      { text: 'username', value: 'username',sortable: false },
      { text: 'ผู้เข้าใช้/ออก', value: 'fname',sortable: false },
      { text: 'วันที่เข้าใช้/ออก', value: 'login_date',sortable: false },
      { text: 'สถานะ', value: 'status_login',sortable: false }
    ],
  }),
  created(){
    this.show_data_log_login()
  },
  methods:{
    show_data_log_login(){
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
            this.axios.get(process.env.VUE_APP_URL+'/show_data_log_login/'+'admin').then((result) => {
             var result = result.data
             for(var i=0; i<result.length;i++){
               this.result.push({
                 username:result[i]["username"],
                 fname:result[i]["fname"],
                 lname:result[i]["lname"],
                 login_id:result[i]["login_id"],
                 login_date:result[i]["login_date"],
                 status_login:result[i]["status_login"],
                 full_name:''
               })
               this.result[i].full_name = this.result[i].fname + ' '+ this.result[i].lname
               this.result[i].login_date = this.setDate(this.result[i].login_date)
             }
             this.excel_data = this.result //โยนค่าใส่ excel
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
