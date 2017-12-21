<template>
  <div class="card">
    <div class="card-header">Simple Chatbot</div>
    <div class="card-body">
      <div class="d-flex">
        <div class="alert alert-primary bot-box">
          Hello~ Lorem ipsum dolor sit, amet consectetur adipisicing elit. Molestiae, culpa?
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
        <button class="btn btn-info btn-block" @click="addMessage">Send</button>
      </div>
      <div class="col-2">
        <button class="btn btn-dark btn-block" @mousedown="mouseDown" @mouseup="mouseUp">按住說話</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      messageInput: '',
      messages: []
    }
  },
  methods: {
    addMessage () {
      let userMessage = {type: 2, msg: this.messageInput}
      let boxMessage = {type: 1, msg: 'OK~'}
      this.messages.push(userMessage)
      this.messages.push(boxMessage)
      this.messageInput = ''
    },
    mouseDown () {
      console.log('mouseDown...')
    },
    mouseUp () {
      console.log('mousenUp...')
    }
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
