<template>
  <b-form-row class="pf-field mx-0 mb-1 px-0" align-v="center"
    v-on="forwardListeners"
  >
    <b-col v-if="$slots.prepend" cols="1" align-self="start" class="text-center col-form-label">
      <slot name="prepend"></slot>
    </b-col>
    <b-col cols="10" align-self="start">
      <component ref="component"
        :form-store-name="formStoreName"
        :form-namespace="`${formNamespace}`"
        v-model="inputValue"
        v-bind="field.attrs"
        v-on="forwardListeners"
        :is="field.component"
        :disabled="disabled"
        no-gutter
      ></component>
    </b-col>
    <b-col v-if="$slots.append" cols="1" align-self="start" class="text-center col-form-label">
      <slot name="append"></slot>
    </b-col>
  </b-form-row>
</template>

<script>
/* eslint key-spacing: ["error", { "mode": "minimum" }] */
import pfMixinForm from '@/components/pfMixinForm'

export default {
  name: 'pf-field',
  mixins: [
    pfMixinForm
  ],
  props: {
    default: {
      type: Object,
      default: () => {
        return null
      }
    },
    value: {
      type: Object,
      default: () => { return null }
    },
    field: {
      type: Object,
      default: () => { return {} }
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    inputValue: {
      get () {
        let value
        if (this.formStoreName) {
          value = { ...this.default, ...this.formStoreValue } // use FormStore
        } else {
          value = this.value // use native (v-model)
        }
        return value
      },
      set (newValue = null) {
        if (this.formStoreName) {
          this.formStoreValue = newValue // use FormStore
        } else {
          this.$emit('input', newValue) // use native (v-model)
        }
      }
    },
    forwardListeners () {
      const { input, ...listeners } = this.$listeners
      return listeners
    }
  },
  methods: {
    focus () {
      const { $refs: { component: { focus = () => {} } = {} } = {} } = this
      focus()
    }
  }
}
</script>

<style lang="scss">
.pf-field {
  .pf-form-chosen {
    .col-sm-12[role="group"] {
      padding-right: 0px;
      padding-left: 0px;
    }
  }
}
</style>
