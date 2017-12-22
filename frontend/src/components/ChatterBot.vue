<template>
  <div class="card">
    <div class="card-header">Simple Chatbot</div>
    <div id="chat-box" class="card-body">
      <div class="d-flex">
        <div class="alert alert-primary bot-box">
          歡迎~ 您可以跟我說些話喔~
        </div>
      </div>
      <div class="d-flex"
          :class="{'justify-content-end': msg.type == 2 }"
          :key="i"
          v-for="(msg, i) in messages">
        <div class="alert"
            :class="{'alert-primary bot-box': msg.type == 1,
                      'alert-success user-box': msg.type == 2}">
          {{ msg.msg }}
        </div>
      </div>
    </div>
    <div class="card-footer form-row">
      <div class="col-7">
        <input type="text" class="form-control" @keyup.enter="addMessage" v-model="messageInput">
      </div>
      <div class="col-3">
        <button class="btn btn-info btn-block" @click="addMessage">送出</button>
      </div>
      <div class="col-2">
        <button class="btn btn-dark btn-block" @mousedown="startRecord" @mouseup="stopRecord">按住說話</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      messageInput: '',
      messages: [],
      recorder: null,
      audio_context: null
    }
  },
  methods: {
    addMessage () {
      let userMessage = {type: 2, msg: this.messageInput}
      this.pushMessage(userMessage)
      axios.get('/reply', {params: userMessage}).then(res => {
        let botMessage = {type: 1, msg: res.data.msg}
        this.pushMessage(botMessage)
        this.messageInput = ''
      })
    },
    startUserMedia (stream) {
      var input = this.audio_context.createMediaStreamSource(stream)
      // console.log('Media stream created.')

      this.recorder = new Recorder(input)
      // console.log('Recorder initialised.', this.recorder)
    },
    startRecord () {
      this.recorder.record()
    },
    stopRecord () {
      this.recorder.stop()
      this.saveWavFile()
      this.recorder.clear()
      this.messageInput = ''
    },
    saveWavFile () {
      this.recorder.exportWAV((blob) => {
        let fd = new FormData()
        fd.append('blob', blob, 'listen.wav')
        axios.post('/listen', fd).then(res => {
          let userMessage = {type: 2, msg: res.data.msg}
          this.pushMessage(userMessage)
          return axios.get('/reply', {params: userMessage})
        }).then(res => {
          let botMessage = {type: 1, msg: res.data.msg}
          this.pushMessage(botMessage)
        }).catch(err => {
          let botMessage = {type: 1, msg: '抱歉我沒聽清楚 請您再說一次~'}
          this.pushMessage(botMessage)
        })
      })
    },
    pushMessage (msg) {
      this.messages.push(msg)
      this.$nextTick(this.scollBottom)
    },
    scollBottom () {
      let el = document.getElementById('chat-box')
      let isScrolledToBottom = el.scrollHeight - el.clientHeight <= el.scrollTop + 1
      if (!isScrolledToBottom) {
        el.scrollTop = el.scrollHeight - el.clientHeight
      }
    }
  },
  created () {
    try {
      // webkit shim
      window.AudioContext = window.AudioContext || window.webkitAudioContext
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
      window.URL = window.URL || window.webkitURL

      this.audio_context = new AudioContext
      // console.log('Audio context set up.')
      // console.log('navigator.getUserMedia ' + (navigator.getUserMedia ? 'available.' : 'not present!'))
    } catch (e) {
      alert('No web audio support in this browser!')
    }

    navigator.getUserMedia({audio: true}, this.startUserMedia, function(e) {
      console.log('No live audio input: ' + e)
    })
  }
}
</script>

<style lang="scss">
.card {
  margin: 1rem;
  height: 100%;

  .card-body {
    height: 100%;
    overflow-y: auto;
    flex-direction: column;
  }

  .card-footer.form-row {
    margin: 0;
  }
}

.box {
  display: inline-block;
  border: 1px solid black;
}

.bot-box, .user-box{
  max-width: 50%;
}

.user-box {
  text-align: right;
}
</style>
