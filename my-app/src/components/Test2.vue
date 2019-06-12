<template lang="html">
  <v-card class="elevation-1">
    <v-toolbar flat class="vtoolbar" card floating color="primary" dark>
      <v-toolbar-title>Report Charts</v-toolbar-title>
    </v-toolbar>
    <v-spacer></v-spacer>
    <v-card-title primary-title>
      <v-layout row wrap>
        <v-flex xs6>
          <export-excel
            class = "btn btn-default"
            :data = "excel_data"
            :fields = "excel_fields"
            worksheet = "My Worksheet"
            name = "filename.xls">
              <v-tooltip bottom>
                <v-btn
                  outline
                  slot="activator"
                  :loading="loadingbtn"
                  :disabled="loadingbtn"
                  color="primary"
                  @click="loader = 'loading3'"
                >
                  Export
                  <v-icon class="fas fa-file-export" right dark></v-icon>
                </v-btn>
                <span>Export Data Table To Excel</span>
              </v-tooltip>
            </export-excel>
        </v-flex>
        <v-flex xs6>
          <v-text-field v-model="search" append-icon="search" label="Search" single-line hide-details>
          </v-text-field>
        </v-flex>
      </v-layout>
    </v-card-title>
    <v-data-table
      :headers="headers"
      :items="desserts"
      :search="search"
      no-data-text
      :loading="load"
      :pagination.sync="pagination"
    >
    <v-progress-circular :rotate="-90" :size="50" :width="5" :value="valueprogress" indeterminate slot="progress" color="green"></v-progress-circular>
      <template v-slot:items="props">
        <td>{{ props.item.fname }}</td>
        <td>{{ props.item.lname }}</td>
      </template>
      <!-- <template v-slot:footer>
        <tr class="primary white--text">
          <td>Total</td>
          <td>{{ totalRequest }}</td>
          <td>{{ totalInprocess }}</td>
          <td>{{ totalUnreceive }}</td>
          <td>{{ totalRatio }}%</td>
        </tr>
      </template> -->
      <template v-slot:no-results>
        <v-alert :value="true" color="error" icon="warning">
          Your search for "{{ search }}" found no results.
        </v-alert>
      </template>
    </v-data-table>
  </v-card>
</template>

<script>
export default {
  data () {
    return {
      loadingbtn: false,
      excel_fields: {
        'naem_fname': 'fname',
        'name_lname': 'lname'
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
        { text: 'naem_fname', align: 'left', sortable: false, value: 'fname' },
        { text: 'naem_lname', align: 'left', sortable: false, value: 'lname' }
      ],
      desserts: []
    }
  },
  created () {
    this.getData ()
  },
  methods: {
    getData () {
      this.axios.get(process.env.VUE_APP_URL + '/show_report_member').then((response) => {
        var result = response.data
        console.log('data====>',result);
        // var sumratio = 0
        var sum = 0
        this.desserts = []
        for (var i = 0; i < result.length; i++) {
          this.desserts.push({
            fname: result[i]["fname"],
            lname: result[i]["lname"],
          })
        }
        this.excel_data = this.desserts
        console.log('this.excel_data===>>',this.excel_data);
      })
      this.load = false
    }
  }
}
</script>

<style lang="css" scoped>
.vtoolbar {
  background-color: transparent;
  border-bottom-right-radius: 15px;
  margin-left: 0px;
}
</style>
