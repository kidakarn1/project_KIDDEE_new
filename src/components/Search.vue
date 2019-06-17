<template lang="html">
  <v-layout row wrap>
    <v-flex  offset-lg8 lg3>
    <v-autocomplete
        v-model="model"
        :items="get_sell"
        :loading="isLoading"
        :search-input.sync="search"
        label="ค้นหาสินค้า"
        item-text="sell_name"
        item-value="sell_name"
        color="warning"
        :keyup.enter="t()"
      >
      </v-autocomplete>
  </v-flex>
  <v-flex  lg1>
    <v-btn  color="success"  @click="handler()">ค้นหา</v-btn>
  </v-flex>
    <!-- <v-autocomplete
      v-model="model"
      :items="get_sell"
      :loading="isLoading"
      :search-input.sync="search"
      chips
      clearable
      hide-details
      item-text="sell_name"
      item-value="sell_name"
      label="ค้นหาสินค้า"
      color="red"
      flat
      :keyup.enter="t()"
    >
      <template v-slot:no-data>
        <v-list-tile>
          <v-list-tile-title>
            Search for your favorite
            <strong>Cryptocurrency</strong>
          </v-list-tile-title>
        </v-list-tile>
      </template>
    </v-autocomplete> -->
    </v-layout>
</template>

<script>
  export default {
    data: () => ({
      get_sell:[],
      isLoading: false,
      items: [],
      model: null,
      search: null,
      isEditing: false
    }),
    watch: {
      search (val) {
        // Items have already been loaded
        if (this.get_sell.length > 0) return

        this.isLoading = true

        // Lazily load input items
        fetch('https://api.coinmarketcap.com/v2/listings/')
          .then(res => res.json())
          .then(res => {
            this.get_sell = res.data
          })
          .catch(err => {
            console.log(err)
          })
          .finally(() => (this.isLoading = false))
      }
    },
    created(){
      this.get_search()
    },
    methods:{
      t(){
        console.log(this.model);
      },
      get_search(){
        this.axios.get(process.env.VUE_APP_URL+'/get_sell_and_groups').then((result) =>{
            var data= result.data
            if (result.status===200){
              for (var i = 0; i < data.length; i++) {
                this.get_sell.push({
                  description:data[i]["description"],
                  groups_id:data[i]["groups_id"],
                  groups_name:data[i]["groups_name"],
                  sell_address:data[i]["sell_address"],
                  sell_id:data[i]["sell_id"],
                  sell_image:data[i]["sell_image"],
                  sell_name:data[i]["sell_name"],
                  sell_price:data[i]["sell_price"],
                  username:data[i]["username"],
                  fname:data[i]["fname"],
                  lname:data[i]["lname"],
                  phone:data[i]["phone"],
                  date_start:data[i]["date_start"],
                  sell_number:data[i]["sell_number"],
                  max_product:0,
                  buy_number:1
                })
              }
            }
      })
    },
      handler() {
        console.log('this.model===>',this.model);
        this.$emit('test',this.model)
      }
    }
  }
</script>

<style lang="css" scoped>
</style>
