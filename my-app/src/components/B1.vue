<template lang="html">
  <div>

          <v-dialog v-model="dialog" persistent scrollable max-width="800px">
            <template v-slot:activator="{ on }">
              <v-btn color="primary" dark v-on="on" large>Create</v-btn>
            </template>
          <v-card>
            <!-- <v-container grid-list-xs>
              <v-layout row wrap justify-center class="paddingx_layout">
                <v-flex xs12 md12> -->
                  <h1 class="text-xs-center header py-3">C R E A T E</h1>


                    <!-- <v-layout row wrap justify-center>
                      <v-flex xs4 md3 class="h3center"><h3>ประเภท</h3></v-flex>
                      <v-flex xs8 md6><v-select  :items="it" label="ภายนอก"  v-model="type"></v-select></v-flex>
                    </v-layout> -->


                <v-divider></v-divider>
                <v-card-text style="max-height: 600px;">
                  <v-container grid-list-xs>
                    <v-layout row wrap justify-center>
                      <v-flex xs4 md3 class="h3center"><h3>วันที่</h3></v-flex>
                      <v-flex xs8 md6><v-text-field :value="Fdate" readonly></v-text-field></v-flex>
                    </v-layout>


                    <v-form ref="form" v-model="valid">
                    <v-layout row wrap justify-center>
                      <v-flex xs4 md3 class="h3center"><h3>ชื่อฝ่าย</h3></v-flex>
                      <v-flex xs8 md6><v-autocomplete v-model="section" :items="it" :rules="nameRules" required label="ชื่อฝ่าย"></v-autocomplete></v-flex>
                    </v-layout>




                  <v-layout row wrap justify-center>
                    <v-flex xs4 md3 class="h3center"><h3>เรื่อง</h3></v-flex>
                    <v-flex xs8 md6><v-text-field  label="เรื่อง"  :rules="nameRules" required v-model="subject"></v-text-field></v-flex>
                  </v-layout>



                  <v-layout row wrap justify-center>
                    <v-flex xs4 md3 class="h3center"><h3>ชื่อผู้ลงนามในเอกสาร</h3></v-flex>
                    <v-flex xs8 md6><v-text-field  label="ชื่อผู้ลงนามในเอกสาร" :rules="nameRules" required v-model="name_send"></v-text-field></v-flex>
                  </v-layout>

                  <v-layout row wrap justify-center>
                    <v-flex xs4 md3 class="h3center"><h3>ชื่อผู้รับเอกสาร</h3></v-flex>
                    <v-flex xs8 md6><v-text-field  label="ชื่อผู้รับเอกสาร"  :rules="nameRules" required v-model="name_save"></v-text-field></v-flex>
                  </v-layout>

                  <v-layout row wrap justify-center>
                    <v-flex xs4 md3 class="h3center"><h3>หน่วยงานที่รับเอกสาร</h3></v-flex>
                    <v-flex xs8 md6><v-combobox v-model="department_save"  :rules="nameRules" required :items="items" label="หน่วยงานที่รับเอกสาร"></v-combobox></v-flex>
                  </v-layout>

                  <v-layout row wrap justify-center class="my-5">
                    <v-flex xs4 md3 class="h3center"><h3>Upload File</h3></v-flex>
                    <v-flex xs8 md6 class="text-xs-center">
                      <v-layout row wrap justify-center>


                      <v-flex xs12 sm8 md6>
                        <div class="bg" style="min-height: 20px !important; max-height: 1800px !important;">
                          <div class="pt-2 pb-2">
                            <div class="subtitle pl-2" >
                            </div>
                            <v-chip
                            v-for="(files, key) in files"
                            @input="removeChipFile(key, files.name)"
                            :key="key"
                            close
                            color="blue-grey " text-color="white"
                            >
                            {{ files.name }}
                          </v-chip></br>
                        </div>
                        </div>
                        </v-flex>
                        <v-flex xs6 md6>
                          <form enctype=multipart/form-data>
                            <div class="form-group" xs12>
                              <input type="file" id="files" ref="files" multiple @change="handleFilesUpload()"/>
                            </div>
                            <v-btn flat outline @click="addFiles()" color="blue darken-4" style="margin:0px;">Select PDF ONLY</v-btn>
                          </form>
                        </v-flex>


                      </v-layout>
                    </v-flex>
                  </v-layout>

                  <v-layout row wrap justify-center>
                    <v-flex xs4 md3 class="h3center"><h3>หมายเหตุ</h3></v-flex>
                    <v-flex xs8 md6><v-textarea label="หมายเหตุ" v-model="other"></v-textarea></v-flex>
                  </v-layout>
                </v-form>
                </v-container>
              </v-card-text>
            <v-divider></v-divider>

                  <v-card-actions>
                    <p style="color:red;">* กรุณาแสกนเอกสารหนังสือภายนอกที่ท่านได้ออก กลับมาที่ inet-ga@inet.co.th ค่ะ</p>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" flat @click="close">Cancel</v-btn>
                    <v-btn color="blue darken-1" flat @click="validate()">Save</v-btn>
                  </v-card-actions>

                <!-- </v-flex>
              </v-layout>
            </v-container> -->
            <Loading ref="loading" style="display:none"></Loading>
          </v-card>
        </v-dialog>

  </div>
</template>

<script>
import axios from 'axios'
import { Encode, Decode } from '@/service'
import Loading from '@/components/Loading'
import moment from 'moment'
export default {
  components: {
    Loading
  },
  data () {
    return {
      // type:'',
      dialog: false,
      section:'',
      subject:'',
      name_do:'',
      name_send:'',
      name_save:'',
      department_save: null,
      other:' ',
      it: [],
      items: [],
      Username:'',
      valid: false,
      Userlastname:'',
      formData:'',
      files: [],
      fileAllowed: ['txt', 'pdf', 'png', 'jpg', 'jpeg', 'PNG', 'JPEG', 'JPG', 'xlsx','xls','doc','docx','ppt','pptx'],
      fileNameMulti: [],
      nameRules: [
        v => !!v || 'จำเป็นต้องกรอกข้อมูลนี้',
      ]
    }
  },
  methods: {
    validate () {
          if (this.$refs.form.validate()) {
            this.insertdata ()
          }
        },
    Department_inet () {
      this.axios.get('http://hr.devops.inet.co.th:9999/api/v1/orgname', {headers: {Authorization: 'abb4e985-221b-45d3-8b1b-699f55acba5e'}}).then((response) => {
        // console.log(response.data.employee_detail)
        var result = response.data.employee_detail
        for (var i = 0; i < result.length; i++) {
          this.it.push(result[i].orgname)
          // console.log("this.items=====",result[i].orgname)
        }
      })
    },
    getDepartment () {
      this.axios.post(process.env.VUE_APP_API_URL + '/getDepartment').then((response) => {
        // console.log(response.data)
        var result = response.data
        for (var i = 0; i < result.data.length; i++) {
          this.items.push(result.data[i].name)
          // console.log("this.items=====",result[i])
        }
        // console.log('result ==== ', result.data)
        // console.log("this.vitems=====",this.items)
      })
    },
    insertdata () {
      this.$refs.loading.open()
      var datacreate = Encode.encode({
        // type : this.type,
        section : this.section,
        subject : this.subject,
        name_do : this.name_do,
        name_send : this.name_send,
        name_save : this.name_save,
        department_save : this.department_save,
        other : this.other,
        user : JSON.parse(Decode.decode(this.$cookies.get('savedata')))
      })
      this.formData.append('datacreate', datacreate)
      // this.formData.append('filename', this.files.name)
      // this.formData.append('file', this.files)
      for (var i = 0; i < this.files.length; i++) {
        this.formData.append('filename', this.files[i].name)
      }
      for (var j = 0; j < this.files.length; j++) {
        this.formData.append('file', this.files[j])
      }
      // console.log(this.formData.getAll('file'))
      const instance = axios.create({
        timeout: 120000,
        headers: {'Content-Type': 'application/json'}
      });
      instance.post(process.env.VUE_APP_API_URL + '/insertdata',this.formData).then((response) => {
        this.formData = new FormData()

        // console.log(response.data)
        // console.log(response.status)
        if (response.data.status === 'success') {
          // console.log(this.formData)
          // this.dialog = false
          this.$emit('test')
          this.$swal('บันทึกสำเร็จ ! ', '','success')
          this.close ()
          this.getDepartment()
          this.Department_inet ()
          this.$refs.loading.hide()


          // this.$refs.form.reset()


          // this.axios.post(process.env.VUE_APP_API_URL + '/upload_user', this.formData).then((response) => {
          //   console.log("ssssssssssssssssssssss")
          //
          // })
        }
        else {
          this.$swal('บันทึกไม่สำเร็จ ! ', '','error')
          this.$refs.loading.hide()
        }


      }).catch((err) => {
        this.$swal('บันทึกไม่สำเร็จ ! ', '','error')
        this.$refs.loading.hide()
        // console.log('=================',response.status)
      })
    },
    close () {

      this.$refs.form.reset()
      this.section = ''
      this.subject = ''
      this.name_do = ''
      this.name_send = ''
      this.name_save = ''
      this.department_save = null
      this.other = ' '
      this.files = []
      this.dialog = false
    },
    removeChipFile (key, name) {
      this.files.splice(key, 1)
      this.fileNameMulti.splice(key, 1)
    },
    addFiles () {
      this.$refs.files.click()
    },
    handleFilesUpload () {
      let uploadedFiles = this.$refs.files.files
      for (var i = 0; i < uploadedFiles.length; i++) {
        if (this.fileAllowed.includes(this.getMultiFileExtension(uploadedFiles[i].name))) {
          this.files.push(uploadedFiles[i])
          this.fileNameMulti.push(uploadedFiles[i].name)
          if (this.$refs.files.files[i]) {
          }
        } else {
          this.$swal('ผิดพลาด', 'นามสกุลไฟล์ไม่ถูกต้อง', 'warning')
        }
      }
    },
    getMultiFileExtension (filename) {
      return filename.split('.').pop()
    },

    save () {
      if (this.editedIndex > -1) {
        Object.assign(this.desserts[this.editedIndex], this.editedItem)
      } else {
        this.desserts.push(this.editedItem)
      }
      this.close()
    }

  },
  created () {
    this.formData = new FormData()


  },
  computed: {
    Fdate () {
        moment.locale('th')
        return moment(new Date()).add(543, 'year').format('DD/MM/YYYY')
      }
  },
  watch: {
    dialog (val) {
      if (this.dialog === true) {
        this.getDepartment()
        this.Department_inet ()
      }
    }
  }
}
</script>

<style lang="css" scoped>
input[type="file"]{
  position: absolute;
  top: -500px;
  display:none;
}
.header {
  font-size: 50px;
}
.paddingx_layout {
  padding-left: 50px;
  padding-right: 50px;
}
.h3center {
  margin-right: 20px;
}
.v-text-field {
  margin:0px;
  padding:0px;
}
.bg{
  background: #ffffff;
}
</style>
