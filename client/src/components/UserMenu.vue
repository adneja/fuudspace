<template>
    <div class="usermenu">
        <div class="usermenu-panel">
            <!-- Title -->
            <div class="title d-flex justify-content-between align-items-center mb-4">
                <div class="">{{$store.getters.userData.name}}</div>

                <button class="btn textButton" @click="close">
                    <i class="fas fa-times closeButton"></i>
                </button>
            </div>

            <div class="mb-2">
                <router-link to="/cookbook" class="menu-item">
                    <i class="fas fa-book menu-logo"></i>My cookbook
                </router-link>
            </div>

            <div class="mb-2">
                <router-link to="/createrecipe" class="menu-item">
                    <i class="fas fa-plus-circle menu-logo"></i>Create recipe
                </router-link>
            </div>

            <hr>

            <div class="mb-2">
                <router-link to="/settings" class="menu-item">
                    <i class="fas fa-cog"></i>Settings
                </router-link>
            </div>

            <div title="Log out" class="menu-item pointer" @click="logOut">
                <i class="fas fa-sign-out-alt"></i>Log out
            </div>
        </div>

        <div class="emptySpace" @click="close"></div>
    </div>
</template>

<script>
    export default {
        name: 'UserMenu',

        methods: {
            close() {
                this.$store.commit('setShowUserMenu', false);
            },

            logOut() {
                this.close();
                this.$store.dispatch('logout', this.$route)
                .then((response) => {
                    if(response) {
                        this.$router.push({name: 'Home'});
                    }
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/global.less";

    .usermenu {
        position: fixed;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100vw;
        z-index: 999999;
    }

    .usermenu-panel {
        position: absolute;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100%;
        max-width: 300px;
        background-color: @main-background;
        box-shadow: 0px 0px 6px rgba(0, 0, 0, 0.3);
        z-index: 9999999;
        padding: 20px 20px;
    }

    .emptySpace {
        width: auto;
        height: 100vh;
    }

    .title {
        font-size: 20pt;
        color: @main-color;

        button {
            width: 31px;
        }
    }

    .closeButton {
        font-size: 20pt;
    }

    .menu-item{
        color: @main-color !important;
        margin-bottom: 8px;
        font-size: 15pt;
        opacity: 0.7;

        i {
            width: 19px;
            margin-right: 7px;
        }
    }

    .menu-item:hover {
        opacity: 1;
    }

    .name {
        color: @main-color !important;
        margin-bottom: 8px;
        font-size: 15pt;
    }

    a:hover {
        text-decoration: none;
    }

    .router-link-active {
        opacity: 1;
    }
</style>