<template>
  <v-container>
    <v-layout
      align-center
      justify-center
      row
      wrap
      fill-height
    >
      <v-flex xs6>
        <!-- <img
          :src="imageUrl"
          height="150"
          v-if="imageUrl"
        />
        <v-btn
          color="blue-grey"
          class="white--text"
          @click='pickFile'
          depressed
        >
          Upload
          <v-icon
            right
            dark
          >cloud_upload</v-icon>
        </v-btn> -->

        {{imageName}}
        <input
          type="file"
          ref="image"
          accept="image/*"
          @change="onFilePicked"
        >
        <button @click="onUpload">Upload</button>
      </v-flex>
      <v-flex xs12>
        <h1 class="title">Gallery</h1>
        <v-dialog
          v-model="dialog"
          hide-overlay
          persistent
          width="300"
        >
          <v-card
            color="primary"
            dark
          >
            <v-card-text>
              Please stand by
              <v-progress-linear
                indeterminate
                color="white"
                class="mb-0"
              ></v-progress-linear>
            </v-card-text>
          </v-card>
        </v-dialog>
        <!-- <v-progress-linear v-model="percentUpload"></v-progress-linear>
        <br>
        <p class="text-xs-center green--text" v-if="upLoadSuccess">
          Upload Success
        </p> -->
        <v-card>
          <v-container
            fluid
            grid-list-md
          >
            <v-layout
              row
              wrap
            >
              <v-flex
                xs4
                v-for="(item, index) in imageLists"
                :key="index"
              >
                <v-card
                  flat
                  tile
                >
                  <!-- <v-btn @click="getImages">get image</v-btn> -->
                  <v-img
                    :src="`/images/${item.file_name}`"
                    height="150px"
                  ></v-img>
                </v-card>
              </v-flex>
            </v-layout>
          </v-container>
        </v-card>
      </v-flex>
    </v-layout>
    <Test2  @test="test2 ()"></Test2>
  </v-container>
</template>

<script>
import Test2 from '@/components/Test2.vue'
import axios from 'axios'
export default {
  components: {
    Test2
  },
  data: () => ({
    title: 'Image Upload',
    dialog: false,
    imageLists: [],
    upLoadSuccess: false,
    percentUpload: 0,
    imageName: '',
    imageUrl: '',
    imageFile: '',
    selectedFile: null
  }),
  methods: {
    test2 () {
      alert('Test2');
    },
    pickFile () {
      this.$refs.image.click()
    },

    onFilePicked (e) {
      console.log(e)
      this.selectedFile = e.target.files[0]
      // this.selectedFile = e.target.files[0]
      // const files = e.target.files
      // if (files[0] !== undefined) {
      //   this.imageName = files[0].name
      //   if (this.imageName.lastIndexOf('.') <= 0) {
      //     return
      //   }
      //   const fr = new FileReader()
      //   fr.readAsDataURL(files[0])
      //   fr.addEventListener('load', () => {
      //     this.imageUrl = fr.result
      //     this.imageFile = files[0] // this is an image file that can be sent to server...
      //   })
      // } else {
      //   this.imageName = ''
      //   this.imageFile = ''
      //   this.imageUrl = ''
      // }
    },
    onUpload () {
      var vm = this
      vm.dialog = true
      const formData = new FormData()
      formData.append('file', this.selectedFile, this.selectedFile.name)
      // console.log(formData.get('file'))
      axios.post('http://localhost:5000/api/uploadimage',
        formData,
        {
          onUploadProgress: progressEvent => {
            var percentCompleted = Math.round((progressEvent.loaded * 100) / progressEvent.total)
            console.log(percentCompleted + '%')
            vm.percentUpload = percentCompleted
          }
        }
      ).then(function () {
        console.log('SUCCESS!!')
        vm.upLoadSuccess = true
        vm.dialog = false
      })
        .catch(function () {
          console.log('FAILURE!!')
        })
    },
    getImages () {
      var vm = this
      axios.get('http://localhost:5000/api/images')
        .then(function (response) {
          // handle success
          vm.imageLists = response.data.images
        }).catch(function (error) {
          // handle error
          console.log(error)
        })
        .then(function () {
        })
    }
  },
  created () {
    this.getImages()
  }
}
</script>

<style>
</style>
