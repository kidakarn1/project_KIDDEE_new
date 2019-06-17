<template>
  <v-container grid-list-xs>
    <v-layout row wrap>
    {{show}}
    </v-layout>
    <v-data-table
    :headers="headers"
    :items="result"
    class="elevation-1">
    <template slot="headerCell" slot-scope="props">
      <v-tooltip bottom>
        <template v-slot:activator="{ on }">
          <span v-on="on">
            {{ props.header.text }}
          </span>
        </template>
        <span>
          {{ props.header.text }}
        </span>
      </v-tooltip>
    </template>
    <template v-slot:items="props">
      <td>{{ props.item.user_id }}</td>
      <td>{{props.item.fname }}</td>
      <td>{{ props.item.lname }}</td>
      <td>{{ props.item.username }}</td>
      <td>{{ props.item.password }}</td>
      <td>{{ props.item.status }}</td>
    </template>
  </v-data-table>
  </v-container>
</template>

<script>
// import axios from "axios"
  export default {
    data: () => ({
      result:[],
      loop_data:'',
      check:true,
      headers: [
                {
                  text: 'ลำดับ',
                  align: 'left',
                  sortable: false,
                  value: 'name'
                },
                { text: 'ชื่อ', value: 'calories' },
                { text: 'นามสกุล', value: 'fat' },
                { text: 'username', value: 'carbs' },
                { text: 'password', value: 'protein' },
                { text: 'สถานะ', value: 'iron' }
              ],
              desserts: [
                {
                  name: 'Frozen Yogurt',
                  calories: 159,
                  fat: 6.0,
                  carbs: 24,
                  protein: 4.0,
                  iron: '1%'
                },
                {
                  name: 'Ice cream sandwich',
                  calories: 237,
                  fat: 9.0,
                  carbs: 37,
                  protein: 4.3,
                  iron: '1%'
                },
                {
                  name: 'Eclair',
                  calories: 262,
                  fat: 16.0,
                  carbs: 23,
                  protein: 6.0,
                  iron: '7%'
                },
                {
                  name: 'Cupcake',
                  calories: 305,
                  fat: 3.7,
                  carbs: 67,
                  protein: 4.3,
                  iron: '8%'
                },
                {
                  name: 'Gingerbread',
                  calories: 356,
                  fat: 16.0,
                  carbs: 49,
                  protein: 3.9,
                  iron: '16%'
                },
                {
                  name: 'Jelly bean',
                  calories: 375,
                  fat: 0.0,
                  carbs: 94,
                  protein: 0.0,
                  iron: '0%'
                },
                {
                  name: 'Lollipop',
                  calories: 392,
                  fat: 0.2,
                  carbs: 98,
                  protein: 0,
                  iron: '2%'
                },
                {
                  name: 'Honeycomb',
                  calories: 408,
                  fat: 3.2,
                  carbs: 87,
                  protein: 6.5,
                  iron: '45%'
                },
                {
                  name: 'Donut',
                  calories: 452,
                  fat: 25.0,
                  carbs: 51,
                  protein: 4.9,
                  iron: '22%'
                },
                {
                  name: 'KitKat',
                  calories: 518,
                  fat: 26.0,
                  carbs: 65,
                  protein: 7,
                  iron: '6%'
                }
              ]
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      },
      show(){
        this.axios.get(process.env.VUE_APP_URL+'/test').then((response) => {
          // var result = response.data
          // this.result = response.data
          var result = response.data
          for (var i = 0; i < result.length; i++) {
            this.result.push({
              user_id:result[i]['user_id'],
              fname:result[i]['fname'],
              lname:result[i]['lname'],
              username:result[i]['username'],
              password:result[i]['password'],
              status:result[i]['status']
            })
            // console.log('result==',result[i])
            console.log(this.result);
            // alert(result[i].user_id);
            // this.check(i<result.length)? false :tr
          }
        })
        return this.loop_data
      }
    },
    watch: {
      dialog (val) {
        val || this.close()
      }
    },

    created () {
      this.initialize()
    },

    methods: {
      initialize () {
        this.desserts = [
          {
            name: 'Frozen Yogurt',
            calories: 159,
            fat: 6.0,
            carbs: 24,
            protein: 4.0
          },
          {
            name: 'Ice cream sandwich',
            calories: 237,
            fat: 9.0,
            carbs: 37,
            protein: 4.3
          },
          {
            name: 'Eclair',
            calories: 262,
            fat: 16.0,
            carbs: 23,
            protein: 6.0
          },
          {
            name: 'Cupcake',
            calories: 305,
            fat: 3.7,
            carbs: 67,
            protein: 4.3
          },
          {
            name: 'Gingerbread',
            calories: 356,
            fat: 16.0,
            carbs: 49,
            protein: 3.9
          },
          {
            name: 'Jelly bean',
            calories: 375,
            fat: 0.0,
            carbs: 94,
            protein: 0.0
          },
          {
            name: 'Lollipop',
            calories: 392,
            fat: 0.2,
            carbs: 98,
            protein: 0
          },
          {
            name: 'Honeycomb',
            calories: 408,
            fat: 3.2,
            carbs: 87,
            protein: 6.5
          },
          {
            name: 'Donut',
            calories: 452,
            fat: 25.0,
            carbs: 51,
            protein: 4.9
          },
          {
            name: 'KitKat',
            calories: 518,
            fat: 26.0,
            carbs: 65,
            protein: 7
          }
        ]
      },
      editItem (item) {
        this.editedIndex = this.desserts.indexOf(item)
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },
      deleteItem (item) {
        const index = this.desserts.indexOf(item)
        confirm('Are you sure you want to delete this item?') && this.desserts.splice(index, 1)
      },

      close () {
        this.dialog = false
        setTimeout(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        }, 300)
      },

      save () {
        if (this.editedIndex > -1) {
          Object.assign(this.desserts[this.editedIndex], this.editedItem)
        } else {
          this.desserts.push(this.editedItem)
        }
        this.close()
      }
    }
  }
</script>

<style lang="css" scoped>
</style>
