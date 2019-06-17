<template>
  <div>
    <!-- <Bar ref="Bar"></Bar> -->
    <v-app>

      <v-container grid-list-xs pa-0 mt-5>
        <v-layout row wrap justify-center align-center>
          <v-flex xs12 sm12 md11>

          <v-card class="pt-5">


          <v-toolbar flat color="white">
            <v-select v-model="filtercheck" :items="states" multiple chips persistent-hint solo style="width:10px;" prepend-inner-icon="filter_list" label="Filter"></v-select>
            <v-text-field label="Search" v-model="search_input" solo style="width:10px; margin-left: 20px;" @keyup.enter="search_data()" prepend-inner-icon="search" clearable></v-text-field><v-btn color="primary" @click="search_data()" large><v-icon>search</v-icon></v-btn>
            <!-- <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details style="width:200px;"></v-text-field> -->
            <v-spacer></v-spacer>
            <!-- <v-btn v-if="placeInfo.position === 'admin'" color="primary" :to="'/manage'">Manage Admin</v-btn> -->
            <Create ref="Create" @test="initialize ()"></Create>

          </v-toolbar>



          <v-data-table :headers="headers" :items="desserts" :search="search" class="elevation-0 px-0" hide-actions disable-initial-sort>
            <template v-slot:items="props">
              <td>{{ props.item.number_document }}</td>
              <td>{{ props.item.name_department_inet  }}</td>
              <td>{{ Fdate(props.item.create_date) }}</td>
              <td>{{ props.item.name_person }}</td>
              <td>{{ props.item.name_employee }}</td>
              <td>{{ props.item.subject }}</td>
              <td>{{ props.item.name_recipient }}</td>
              <td>{{ props.item.name_department }}</td>
              <td>{{ props.item.remark }}</td>
              <!-- <td v-if="props.item.status_document === 1" ><span style="color:red !important">Cancel</span></td>
              <td v-else></td> -->
              <td>{{ props.item.status_document }}</td>
              <td v-if="props.item.file_name !== null"><Download ref="Download" :datafordownload="props.item"></Download></td>
              <td v-else></td>
              <td v-if="props.item.status_document !== 'Cancel'"><Edit ref="Edit" @edit="initialize ()" :textdata="props.item"></Edit></td>
              <td v-else></td>
              <td v-if="props.item.status_document !== 'Cancel'"><v-tooltip right><template v-slot:activator="{ on }">
                <v-icon @click="deleteItem(props.item.id_doc)" color="red" v-on="on">cancel</v-icon></template><span>ยกเลิก</span></v-tooltip></td>

              <td v-else><v-tooltip right><template v-slot:activator="{ on }"><v-icon @click="return_data(props.item.id_doc)" v-on="on">reply</v-icon></template><span>กู้คืน</span></v-tooltip></td>
              <!-- <td class="justify-center layout">
                <v-icon small class="mr-2" @click="editItem(props.item)">edit</v-icon>
                <v-icon small  @click="deleteItem(props.item)">delete</v-icon>
              </td> -->
            </template>
            <v-alert v-slot:no-results :value="true" color="error" icon="warning">
              Your search for "{{ search }}" found no results.
            </v-alert>
          </v-data-table>
          <div class="text-xs-center">
            <v-pagination @click="change_page ()" v-model="page"  :length="length_page" ></v-pagination>
          </div>
          </v-card>
            </v-flex>
        </v-layout>
      </v-container>

  </v-app>
    <Loading ref="loading"></Loading>
    <Alert ref="alert"></Alert>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Bar from '@/components/Bar'
import Edit from '@/components/Edit'
import Create from '@/components/Create'
import Alert from '@/components/Alert'
import moment from 'moment'
import { Encode,Decode } from '@/service'
import Loading from '@/components/Loading'
import Download from '@/components/Download'
  export default {
    components: {
      Bar,
      Create,
      Edit,
      Loading,
      Download,
      Alert
    },
    data: () => ({
      headers: [
        { text: 'เลขที่', value: 'number_document' },
        { text: 'ฝ่าย', value: 'name_department' },
        { text: 'วันที่', value: 'create_date' },
        { text: 'ผู้จัดทำ', value: 'name_person' },
        { text: 'ผู้ลงนามในเอกสาร', value: 'name_employee' },
        { text: 'เรื่อง', value: 'subject' },
        { text: 'ชื่อผู้รับเอกสาร', value: 'name_recipient' },
        { text: 'หน่วยงานที่รับเอกสาร', value: 'name_department_inet' },
        { text: 'หมายเหตุ', value: 'remark' },
        { text: 'สถานะ', value: 'status_document' },
        { text: 'ไฟล์', value: 'file_name' },
        { text: '', value: '' },
        { text: '', value: '' }
      ],
      desserts: [],
      placeInfo: null,
      page: 1,
      length_page : 1,
      search: '',
      search_input:'',
      filtercheck: [],

      states:['Cancel','Success','Waiting']
      // editedIndex: -1,
      // editedItem: {
      //   calories: 0,
      //   fat: 0,
      //   carbs: 0,
      //   protein: 0
      // },
      // defaultItem: {
      //   calories: 0,
      //   fat: 0,
      //   carbs: 0,
      //   protein: 0
      // }
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      }
    },

    watch: {
      page() {
        // console.log(this.page)
        this.desserts = []
        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('savedata')))
        this.axios.post(process.env.VUE_APP_API_URL + '/getDocument',{'data': this.placeInfo,'page_number' : this.page}).then((response) => {
          // console.log(response.data)
          var result = response.data.data
          this.desserts = result
          // for (var i = 0; i < result.length; i++) {
          //   this.desserts.push({
          //     id_doc : result[i].id_doc,
          //     number_document : result[i].number_document,
          //     name_department : result[i].name_department,
          //     create_date : result[i].create_date,
          //     name_person : result[i].name_person,
          //     name_employee : result[i].name_employee,
          //     subject : result[i].subject,
          //     name_recipient : result[i].name_recipient,
          //     name_department_inet : result[i].name_department_inet,
          //     remark : result[i].remark,
          //     status_document : result[i].status_document,
          //     status_nontification_file : result[i].status_nontification_file,
          //     file_name : result[i].file_name
          //   })
          //   // console.log("this.items=====",result[i])
          // }
          // console.log('result ==== ', this.desserts)
          // console.log("this.vitems=====",this.desserts)
        })
      },
      search_input (val) {
        // console.log(val)
        // console.log(this.search_input.length)
        // console.log(this.filtercheck.length)
        if (val === null){
          this.search_input = ''
        }
        // if (val === null) {
        //   if (this.filtercheck.length !== 0) {
        //     this.initialize()
        //   } else {
        //     this.search_data()
        //   }
        // } else {
        //   this.search_data()
        // }


        // if (this.filtercheck.length !== 0 || this.search_input.length !== 0) {
        //   this.desserts = []
        //   this.placeInfo = this.$cookies.get('savedata')
        //   this.axios.post(process.env.VUE_APP_API_URL + '/getdocument_search',{'filtercheck': this.filtercheck,'filtertext': this.search_input,'page_number' : this.page , 'data':this.placeInfo}).then((response) => {
        //     this.desserts = response.data.data
        //   })
        // } else {
        //   this.initialize ()
        // }





      },
      filtercheck (val) {
        // console.log(this.filtercheck)
        if (this.filtercheck.length !== 0 || this.search_input.length !== 0) {
          this.desserts = []
          this.placeInfo = this.$cookies.get('savedata')
          this.axios.post(process.env.VUE_APP_API_URL + '/getdocument_search',{'filtercheck': this.filtercheck,'filtertext': this.search_input,'page_number' : this.page , 'data':this.placeInfo}).then((response) => {
            this.desserts = response.data.data
          })
        } else {
          this.initialize ()
        }
      }

    },
    mounted () {
      this.$refs.alert.open()
    },
    created () {

      this.initialize ()
      // console.log(this.placeInfo.position)
      var x = this.$cookies.get('savedata')
      var decodeemptoken = Decode.decode(x)
      this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('savedata')))
    },

    methods: {
      // get_length_page () {
      //   this.placeInfo = this.$cookies.get('savedata')
      //   this.axios.post(process.env.VUE_APP_API_URL + '/getlength_page',{'data': this.placeInfo}).then((response) => {
      //
      //     this.length_page = response.data.length_page
      //   })
      // },

      search_data () {
        if (this.search_input.length !== 0 || this.filtercheck.length !== 0) {
          this.desserts = []
          this.placeInfo = this.$cookies.get('savedata')
          // console.log(this.filtercheck)
          this.axios.post(process.env.VUE_APP_API_URL + '/getdocument_search',{'filtercheck': this.filtercheck,'filtertext': this.search_input,'page_number' : this.page , 'data': this.placeInfo}).then((response) => {
            this.desserts = response.data.data
          })
        }
        else {
          this.initialize ()
        }
      },
      initialize () {
        this.desserts = []
        this.placeInfo = this.$cookies.get('savedata')
        // console.log(this.placeInfo)
        // var page_num = JSON.parse(Encode.encode(t  his.page))
        this.axios.post(process.env.VUE_APP_API_URL + '/getlength_page',{'data': this.placeInfo}).then((response) => {
          this.length_page = response.data.length_page
          if (response.data.status === 'success') {
            this.axios.post(process.env.VUE_APP_API_URL + '/getDocument',{'data': this.placeInfo,'page_number' : this.page}).then((response) => {
              // console.log(response.data)
              var result = response.data.data
              this.desserts = result
              // console.log(result)
              // for (var i = 0; i < result.length; i++) {
              //   this.desserts.push({
              //     id_doc : result[i].id_doc,
              //     number_document : result[i].number_document,
              //     name_department : result[i].name_department,
              //     create_date : result[i].create_date,
              //     name_person : result[i].name_person,
              //     name_employee : result[i].name_employee,
              //     subject : result[i].subject,
              //     name_recipient : result[i].name_recipient,
              //     name_department_inet : result[i].name_department_inet,
              //     remark : result[i].remark,
              //     status_document : result[i].status_document,
              //     status_nontification_file : result[i].status_nontification_file,
              //     file_name : result[i].file_name
              //   })
              //   // console.log("this.items=====",result[i])
              // }
              // console.log('result ==== ', this.desserts)
              // console.log("this.vitems=====",this.desserts)
            })
          }




        })

        var x = this.$cookies.get('savedata')
        var decodeemptoken = Decode.decode(x)
        this.placeInfo = JSON.parse(Decode.decode(this.$cookies.get('savedata')))
      },
      return_data (id_doc_return) {
        this.$swal({
          title: 'คุณต้องการกู้คืนหรือไม่ ?',
          type: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'ยืนยัน',
          cancelButtonText: 'ยกเลิก'
        }).then((result) => {
          if (result) {
            this.$refs.loading.open()
        this.axios.post(process.env.VUE_APP_API_URL + '/cancel_terminateData',{'data': id_doc_return}).then((response) => {
          if (response.data === 'success') {
            this.initialize ()
            this.$refs.loading.hide()
            this.$swal('เรียบร้อย ! ', '','success')
          }
        })
      }
    })
      },
      deleteItem (id_doc_delete) {
        this.$swal({
          title: 'คุณต้องการยกเลิกหรือไม่ ?',
          type: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'ยืนยัน',
          cancelButtonText: 'ยกเลิก'
        }).then((result) => {
          if (result) {
            this.$refs.loading.open()
        this.axios.post(process.env.VUE_APP_API_URL + '/terminateData',{'data': id_doc_delete}).then((response) => {
          console.log(response)
          if (response.data === 'success') {
            this.initialize ()
            this.$refs.loading.hide()
            this.$swal('เรียบร้อย ! ', '','success')
          }
        })
      }
    })
  },
      Fdate (create_date) {
        moment.locale('th')
        return moment(create_date).add(543, 'year').format('DD/MM/YYYY')
      },
      getfile_downlaod (id_doc_getfile) {
        this.axios.post(process.env.VUE_APP_API_URL + '/getfile_doc',{'data': id_doc_getfile}).then((response) => {
          // console.log(response.data)
        })
      },
      download (file_download) {
        // console.log(file_download)
        this.axios.post(process.env.VUE_APP_API_URL + '/download_pdf', {source: file_download.file_name},{responseType: 'blob'}).then((response) => {
          if (response) {
            let blob = new Blob([response.data], {type: 'application/pdf'})
            let link = document.createElement('a')
            link.href = window.URL.createObjectURL(blob)
            link.download = file_download.file_name
            document.body.appendChild(link)
            link.click()
          }

        })
      }

      // editItem (item) {
      //   this.editedIndex = this.desserts.indexOf(item)
      //   this.editedItem = Object.assign({}, item)
      //   this.dialog = true
      // },
      //
      // deleteItem (item) {
      //   const index = this.desserts.indexOf(item)
      //   confirm('Are you sure you want to delete this item?') && this.desserts.splice(index, 1)
      // },

      // close () {
      //   this.dialog = false
      //   setTimeout(() => {
      //     this.editedItem = Object.assign({}, this.defaultItem)
      //     this.editedIndex = -1
      //   }, 300)
      // },

      // save () {
      //   if (this.editedIndex > -1) {
      //     Object.assign(this.desserts[this.editedIndex], this.editedItem)
      //   } else {
      //     this.desserts.push(this.editedItem)
      //   }
      //   this.close()
      // }
    }
  }
</script>

<style lang="css" scoped>

</style>
