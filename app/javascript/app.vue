<template>
  <div id="app">
    <div id="header" class="row justify-content-between">
      <h5>Weather notes (last 15)</h5>
      <b-button @click="createNotes" class="bg-primary">Create notes</b-button>
    </div>

    <b-table striped small :items="notes" :busy="loading" :fields="fields">
      <template v-slot:table-busy>
        <div class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong>Processing...</strong>
        </div>
      </template>
    </b-table>

    <h5>Caches</h5>
    <b-table striped small :busy="loading" :items="caches">
      <template v-slot:table-busy>
        <div class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong>Processing...</strong>
        </div>
      </template>
    </b-table>
  </div>
</template>

<script>
  const API_URL = 'http://127.0.0.1:3000/api/v1'

  export default {
    data: () => ({
      loading: false,
      notes: [],
      fields: ['id', 'city', 'temp', 'note', 'created_at'],
      caches: []
    }),

    methods: {
      async createNotes() {
        this.loading = true

        try {
          await fetch(`${API_URL}/weather/create_notes`, {method: 'POST'})
          await this.refresh()
        } catch (e) {
          console.log(e.message)
        }

        this.loading = false
      },

      async refresh() {
        this.loading = true

        try {
          const notesPromise = fetch(`${API_URL}/weather`).then(res => res.json())
          const cachesPromise = fetch(`${API_URL}/weather/caches`).then(res => res.json())

          const [notesRes, cachesRes] = await Promise.all([notesPromise, cachesPromise])

          this.notes = notesRes.notes
          this.caches = cachesRes.caches.map(item => ({cache: item}))
        } catch (e) {
          console.log(e.message)
        }

        this.loading = false
      }
    },

    async created() {
      await this.refresh()
    }
  }
</script>

<style scoped>
  #header {
    padding: 5px 20px;
  }
</style>
