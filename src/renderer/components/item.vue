<template>
<div>
  <div @click="itemClick" class="item" :class="{'isSelected': info.selected}">
    <div class="bg" >
        {{info.name}}
    </div>

    <span >{{info.name}}</span>
  </div>

</div>

</template>
<script>
export default {
  props: {
    info: {
      type: Object,
      default: {}
    },
    index: {
      type: Number,
      default: 0
    }
  },
  methods: {
    itemClick () {
      this.$emit('isSelected', this.index, !this.info.selected)
      // console.log(this.info.selected)
    }
  }
}
</script>

<style lang="scss" scoped>
.item {
  
    position: relative;
    display: inline-block;
    text-align: center;
    min-width: 40px;
    height: 10px;
    line-height: 10px;
    padding: 10px 5px 10px 5px ;
    overflow: hidden;
    background: #fff;
    transition: all 0.5s;
    border-radius: 4px;
    transform-origin: left center;
    .show-text{
      
      background: #fff;
    }
   span {
     display: inline-block;
     transform: translateX(0);
     transition: all 0.3s;
      user-select:none;
   }
    //  background:  #409eff;
     color:#666;
     cursor: pointer;
    // border: 1px solid #409eff;
    // border-radius: 5px;
    font-weight: bold;
    font-size: 12px;
    .bg{
      transition: all 0.3s;
      position: absolute;
      text-align: center;
      line-height: 30px;
      color:#fff;
      top:0;
      right: 0;
      left: 0;
      bottom: 0;
      background-color: #409eff;
      transform:translateX(calc(-100% - 1px));
    }

    
}
.item:hover{
  // transform: scale(1.1);
}
.isSelected {
   border: 1px solid #fff;
  
  span {
    transform: translateX(calc(100% + 20px));
  }
  // background: red!important;
  .bg {
    // background: red!important;
    transform:translateX(0);
  }
}
    
</style>
