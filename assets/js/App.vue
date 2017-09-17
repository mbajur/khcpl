<template>
  <div>EEELLLOOOO</div>
</template>

<script>
import gql from 'graphql-tag'

export default {
  name: 'App',

  apollo: {
    events: gql`
      events {
        edges {
          node {
            id
          }
        }
      }
    `
  }
}
</script>
