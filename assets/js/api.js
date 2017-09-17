import Vue from 'vue'
// import VueCookie from 'vue-cookie'
import { ApolloClient, createNetworkInterface } from 'apollo-client'

// Vue.use(VueCookie)

const networkInterface = createNetworkInterface({
  uri: '/graphql',
  transportBatching: true,
  opts: {
    credentials: 'same-origin'
  }
})

const apolloClient = new ApolloClient({
  networkInterface: networkInterface,
  connectToDevTools: true
})

export default apolloClient
