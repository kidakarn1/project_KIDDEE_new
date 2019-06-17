<template>
  <v-container grid-list-xs,sm,md,lg,xl>
    <v-layout row wrap>
      <v-flex offset-xs4 xs6 offset-sm4 sm8 offset-md11 md1 offset-lg11 lg1 offset-xl11 xl1>
          <export-excel
            class = "btn btn-default"
            :data = "excel_data"
            :fields = "excel_fields"
            worksheet = "My Worksheet"
            name = "Report_member.xls">
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
        <h1>รายงานสมาชิก</h1>

      </v-flex>
      <v-flex  offset-xs1 xs11 offset-sm2 sm8 offset-md2 md8 offset-lg2 lg8 offset-xl2 xl8>
        <v-data-table :headers="headers" :items="data_members" class="elevation-1" :pagination.sync="pagination">
          <template v-slot:items="props">
            <td>{{ props.item.user_id }}</td>
            <td>{{ props.item.fname }}</td>
            <td>{{ props.item.lname }}</td>
            <td>{{ props.item.user_address }}</td>
            <td>{{ props.item.status }}</td>
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
export default {
  data: () => ({
    loadingbtn: false,
    excel_fields: {
      'รหัสสมาชิก': 'user_id',
      'ชื่อ': 'fname',
      'สกุล': 'lname',
      'เบอร์โทรศัพท์': 'phone',
      'ที่อยู่':"user_address",
      'สถานะ':'status'
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
      { text: 'รหัสสมาชิก', align: 'left', sortable: false, value: 'user_id' },
      { text: 'ชื่อ', align: 'left', sortable: false, value: 'fname' },
      { text: 'สกุล', align: 'left', sortable: false, value: 'lname' },
      { text: 'เบอร์โทรศัพท์', align: 'left', sortable: false, value: 'phone' },
      { text: 'ที่อยู่', align: 'left', sortable: false, value: 'user_address' },
      { text: 'สถานะ', align: 'left', sortable: false, value: 'status' },
    ],
    desserts: [],
    pagination: {
            sortBy: 'cat_id',
            rowsPerPage: 25
          },
    show_printer:true,
    data_members:[],
    headers: [
        {
          text: 'รหัสสมาชิก',
          sortable: false,
          value: 'name'
        },
        { text: 'ชื่อ', sortable: false },
        { text: 'นามสกุล', sortable: false },
        { text: 'ที่อยู่', sortable: false},
        { text: 'สิทธิ์', sortable: false}
    ]
  }),
  created(){
    this.show_report_member()
  },
  methods:{
    show_report_member(){
      this.axios.get(process.env.VUE_APP_URL+'/show_report_member').then((result) =>{
        var data = result.data
        for (var i = 0; i < data.length; i++) {
        this.data_members.push({
          user_id:data[i]["user_id"],
          username:data[i]["username"],
          password:data[i]["password"],
          fname:data[i]["fname"],
          lname:data[i]["lname"],
          status:data[i]["status"],
          phone:data[i]["phone"],
          user_image:data[i]["user_image"],
          user_address:data[i]["user_address"]
        })
      }
      this.excel_data = this.data_members
      })
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
