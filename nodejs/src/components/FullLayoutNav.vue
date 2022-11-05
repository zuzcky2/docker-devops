<template>
  <div>
    <v-app-bar
        :clipped-left="$vuetify.breakpoint.lgAndUp"
        app
        color="blue darken-3"
        dark
    >
      <v-app-bar-nav-icon @click.stop="side = !side"></v-app-bar-nav-icon>
      <v-toolbar-title
          style="width: 300px"
          class="ml-0 pl-4"
      >
        <a href="/" class="white--text text-decoration-none"><span class="hidden-sm-and-down">통합 API</span></a>
      </v-toolbar-title>
<!--       
      <v-text-field
          flat
          solo-inverted
          hide-details
          prepend-inner-icon="mdi-magnify"
          label="Search"
          class="hidden-sm-and-down"
      ></v-text-field>
      -->
      <v-spacer></v-spacer>
      <template>
        <div class="text-center">
          <v-menu
              v-model="open"
              :close-on-content-click="false"
              :nudge-width="200"
              offset-y
          >
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                  icon
                  large
                  v-bind="attrs"
                  v-on="on"
              >
                <v-avatar
                    size="32px"
                    item
                >
                  <v-img
                      :src="require('../assets/logo.svg')"
                      alt="Vuetify"
                  ></v-img>
                </v-avatar>
              </v-btn>
            </template>

            <v-card>
              <v-list>
                <v-list-item>
                  <v-list-item-avatar>
                    <v-img
                        :src="require('../assets/logo.svg')"
                    ></v-img>
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title>손님 - Guest</v-list-item-title>
                    <v-list-item-subtitle>(guest@example.com)</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
                <v-list-item>
                  <v-list-item-action>
                    <v-icon>exit-to-app</v-icon>
                  </v-list-item-action>
                  <v-list-item-content>
                    <v-list-item-title>
                      로그아웃
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>

              <v-divider></v-divider>
            </v-card>
          </v-menu>
        </div>
      </template>
      <v-btn
          icon
          large
      >
        <v-icon>mdi-cog</v-icon>
      </v-btn>
    </v-app-bar>
    <v-navigation-drawer
        v-model="side"
        :clipped="$vuetify.breakpoint.lgAndUp"
        app
    >
      <v-list>
        <v-list-item link>
          <v-list-item-avatar>
            <v-img :src="require('../assets/logo.svg')"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-list-item-title class="title">손님 - Guest</v-list-item-title>
            <v-list-item-subtitle>그룹</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
        <v-list-item>
          <v-list-item-subtitle>guest@example.com</v-list-item-subtitle>
        </v-list-item>
      </v-list>
      <v-divider></v-divider>
      <v-list dense>
        <template v-for="item in itemsPrepare">
          <v-row
              v-if="item.heading"
              :key="item.heading"
              align="center"
          >
            <v-col cols="6">
              <v-subheader v-if="item.heading">
                {{ item.heading }}
              </v-subheader>
            </v-col>
            <v-col
                cols="6"
                class="text-center"
            >
              <a
                  href="#!"
                  class="body-2 black--text"
              >EDIT</a>
            </v-col>
          </v-row>
          <v-list-group
              v-else-if="item.children"
              :key="item.text"
              v-model="item.model"
              append-icon=""
          >
            <template v-slot:activator>
              <v-list-item-action v-if="item.icon">
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>
                  {{ item.text }}
                </v-list-item-title>
              </v-list-item-content>
            </template>
            <v-list-item class="ml-4"
                v-for="(child, i) in item.children"
                :key="i"
                :to="child.to"
                link
            >
              <v-list-item-action v-if="child.icon">
                <v-icon>{{ child.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>
                  {{ child.text }}
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list-group>
          <v-list-item
              v-else
              :key="item.text"
              :to="item.to"
              link
          >
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>
                {{ item.text }}
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-navigation-drawer>
  </div>
</template>
<script>
import apiClient from '@/store/api'
export default {
  name: "FullLayoutNav",
  data () {
    return {
      side: true,
      open: true,
      itemsPrepare: [
        {icon: 'mdi-home-outline', text: 'Home', to: { name: 'Root.Home' }, role: 'USER_ROLE_MEMBER'},
      ],
    }
  },
  methods: {
  },
  asyncComputed: {
  },
  computed: {

  }
}
</script>