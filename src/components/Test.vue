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
              name = "filename.xlsx">
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
        <td>{{ props.item.BDName }}</td>
        <td>{{ props.item.JobRequest }}</td>
        <td>{{ props.item.JobInprocess }}</td>
        <td>{{ props.item.JobUnreceive }}</td>
        <td>{{ props.item.JobReject }}</td>
        <td>{{ props.item.JobRatio }}</td>
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
        'Service Team': 'BDName',
        'Request': 'JobRequest',
        'Receive': 'JobInprocess',
        'Unreceive': 'JobUnreceive',
        'Return': 'JobReject',
        'Raio': 'JobRatio'
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
        { text: 'Service Team', align: 'left', sortable: false, value: 'BDName' },
        { text: 'Request', align: 'left', sortable: false, value: 'JobRequest' },
        { text: 'Inprocess', align: 'left', sortable: false, value: 'JobInprocess' },
        { text: 'Unreceive', align: 'left', sortable: false, value: 'JobUnreceive' },
        { text: 'Return', align: 'left', sortable: false, value: 'JobReject' },
        { text: 'Ratio', align: 'left', sortable: false, value: 'JobRatio' }
      ],
      desserts: [],
      totalRequest: 0,
      totalInprocess: 0,
      totalUnreceive: 0,
      totalReject: 0,
      totalRatio: 0
    }
  },
  created () {
    this.getData ()
  },
  methods: {
    getData () {
      this.axios.get(process.env.VUE_APP_URL + '/getuatreportchart').then((response) => {
        var result = response.data
        // var sumratio = 0
        var sum = 0
        this.desserts = []
        for (var i = 0; i < result.request_cont_report.length; i++) {
          this.desserts.push({
            BDName: result.request_cont_report[i].BDName,
            JobRequest: result.request_cont_report[i].JobRequest,
            JobInprocess: result.request_cont_report[i].JobInprocess,
            JobUnreceive: result.request_cont_report[i].JobUnreceive,
            JobReject: result.request_cont_report[i].JobReject,
            JobRatio: result.request_cont_report[i].JobRatio.toFixed(2) +'%'
          })
          this.totalRequest = result.request_cont_report[i].JobRequest + this.totalRequest
          this.totalInprocess = result.request_cont_report[i].JobInprocess + this.totalInprocess
          this.totalUnreceive = result.request_cont_report[i].JobUnreceive + this.totalUnreceive
          this.totalReject = result.request_cont_report[i].JobReject + this.totalReject

          // sumratio = result.request_cont_report[i].JobRatio + sumratio
          sum = this.totalInprocess+this.totalUnreceive+this.totalReject
        }
        this.totalRatio = ((sum / this.totalRequest)*100).toFixed(2)
        this.excel_data = this.desserts
        this.excel_data.push({
          BDName: 'Total',
          JobRequest: this.totalRequest,
          JobInprocess: this.totalInprocess,
          JobUnreceive: this.totalUnreceive,
          JobReject: this.totalReject,
          JobRatio: this.totalRatio+ '%'
        })
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
