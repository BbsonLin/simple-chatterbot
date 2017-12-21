import Vue from 'vue'
import Router from 'vue-router'
import ChatterBot from '@/components/ChatterBot'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'ChatterBot',
      component: ChatterBot
    }
  ]
})
