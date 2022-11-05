<template>
  <div class="text-center">
    <v-dialog
        v-model="setDialog"
        width="500"
    >
      <v-card>
        <v-card-title class="headline green lighten-2 white--text">
          {{ setTitle }}
        </v-card-title>

        <v-card-text class="pt-2 text-md-subtitle-1" style="word-break: keep-all">
          {{ setMessage }}
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
              color="primary"
              text
              @click="close"
          >
            확인
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  name: "MessageSuccess",
  props: {
    title: [String, null],
    message: [String, null],
    dialog: Boolean,
    callback: [Function, null]
  },
  methods: {
    close () {
      this.$emit('close');
      if (this.callback) {
        this.callback()
      }
    }
  },
  computed: {
    setDialog () {
      return this.dialog || false
    },
    setTitle () {
      return this.title || '성공'
    },
    setMessage () {
      return this.message || '정상적으로 처리되었습니다.'
    }
  }
}
</script>

<style scoped>

</style>