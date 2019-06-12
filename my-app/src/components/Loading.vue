<template lang="html">
  <div class="">
    <v-dialog v-model="isLoading" persistent max-width="300px" class="pa-5">
      <v-card class="center-x center-y pa-5" flat transparent>
        <v-layout row wrap justify-center align-center>
          <v-flex xs12 class="center-x mb-2 text-xs-center">
            <v-progress-circular :size="widthscreen" width="10" color="success" indeterminate></v-progress-circular>
          </v-flex>
            <v-flex xs12 class="center-x text-xs-center"><b style="font-size:20px;" >กรุณารอสักครู่</b></v-flex>
        </v-layout>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data () {
    return {
      isLoading: false
    }
  },
  methods: {
    open() {
      this.isLoading = true
      console.log('55555')
    },
    hide () {
      this.isLoading = false
    }
  },
  computed: {

  }
}
</script>

<style scoped>
</style>
