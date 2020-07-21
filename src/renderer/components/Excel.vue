<template>
<div class="layout">
  <transition   name="pannel">
  <Pannel :bios="bios"  :list = "nextList" :secretList="secretList" @closePannel="closePannel" v-show="showPanel" class="pannel"></Pannel>
  </transition>
 
  <div class="boxBig">
    <div class="box">
    <div class="title">For_1ST</div>
    <div class="item-con" v-for="(item,i) in test1" :key="i">
      
       <item @isSelected="isSelected(1,i)"  :info="item" :index="i"></item>
     <div v-if="item.items.length" :class="{showDetail:item.showDetail }" class="showBtn" @click="showDetailClick()">

     </div>
     
    </div>


  </div>
  <div class="box">
  <div class="title">For_2ST</div>
    <div class="item-con" v-for="(item,i) in testList" :key="i">    
       <item @isSelected="isSelected(2,i)"  :info="item" :index="i"></item>
     <div v-if="item.items.length" :class="{showDetail:item.showDetail }" class="showBtn" @click="showDetailClick()">
     </div>
     
    </div>
  </div>
    <div class="box">
  <div class="title">For_3T</div>
    <div class="item-con" v-for="(item,i) in test3" :key="i">    
       <item @isSelected="isSelected(3,i)"  :info="item" :index="i"></item>

     
    </div>
  </div>
        <el-dialog

  title="机种名"
  :visible.sync="showBios"
  width="500px"
  >
    <el-input  placeholder="1.20" v-model="bios.version">
    <template slot="prepend">version:</template>
  
  </el-input>
    <el-input placeholder="06/03/2020" v-model="bios.release">
    <template slot="prepend">release:</template>
  
  </el-input>
</el-dialog>
  </div>
    <div class="btn" @click="start">Next</div>
</div>




</template>

<script>
import Item from '@/components/item'
import Pannel from '@/components/pannel'
const fs = require('fs')
/* eslint-disable*/
export default {
  data () {
    return {
      showPanel: false,
      showBios: false,
      bios:{
        version: '',
        release: ''
      },
      nextList: [],
      secretList:[],
      test1: [
      ],
      testList: [
      ],
      test3: [

      ]
    }
  },
  mounted() {
     let data = JSON.parse( fs.readFileSync('./test1.json','utf8'))
     this.test1 = data
     let data2 = JSON.parse( fs.readFileSync('./test2.json','utf8'))
     this.testList= data2
     let data3 = JSON.parse(fs.readFileSync('./test3.json','utf8'))
     this.test3 = data3
    
  },
  methods: {
    // 确认输入bios的信息
    start () {
      this.nextList = []
      this.test1.forEach((item) => {
        if (item.selected === true) {
          this.nextList.push(item)
        }
      })
      this.testList.forEach(item => {
              if (item.selected === true) {
          this.nextList.push(item)
        }
      })
      this.test3.forEach(item => {
              if (item.selected === true) {
          this.secretList.push(item)
        }
      })
      // console.log()
      this.showPanel = true
    },
    closePannel () {
this.showPanel = false
    },
    
    isSelected (index, i) {
      // console.log(i,selected)
      if (index === 1) {
        if ( this.test1[i]['name'] === 'bioschk' && (!this.bios.version || !this.bios.release)) {
        
          this.showBios = true
        } else {
          // console.log(  this.test1[i])
          this.test1[i]['selected'] = !this.test1[i]['selected']
        }
      } else if(index === 2) {
      
        if ( this.testList[i]['name'] === 'bioschk' && (!this.testList[i]['items'][0]['Version']|| !this.testList[i]['items'][1]['Release'] )) {
        
          this.showBios = true
        } else {
          // console.log(  this.testList[i])
          this.testList[i]['selected'] = !this.testList[i]['selected']
        }
      } else {

          this.test3[i]['selected'] = !this.test3[i]['selected']
        
      }

    },
    showDetailClick(i) {
      this.showBios = !this.showBios
    }
  },
  components: {
    Item,
    Pannel
  }
};
</script>

<style  scope lang="scss">
.layout{
  display: flex;
  justify-content: center;
  // align-items: center;
  // width: 100%;
  // background: red;
}
.title{
  height: 40px;
  width: 100%;


}

.pannel-enter-active, .pannel-leave-active{
 transform: translateX(0);
}
.pannel-enter, .pannel-leave-to{
   
    transform: translateX(100%);
}
.btn{
  position: fixed;
  top: 480px;
  right: 20px;
  // right: 100px;
  bottom: 20px;
  height: 50px;
  line-height: 50px;
  // line-height: ;
  width: 50px;
  outline: none;
  text-align: center;
  font-size: 20px;
  text-decoration: none !important;
  // margin: 0 auto;
  padding: 10px 20px;
  border-radius: 5px;
          color: #ffffff;
  background: -webkit-linear-gradient(top, #409eff 0%, #409eff 100%);
  background: linear-gradient(to bottom, #409eff 0%, #409eff 100%);
  border: 1px solid #409eff;
  box-shadow: 0px 4px 0px 0px #409eff, 0px 5px 12px 0px rgba(0, 0, 0, 0.6), inset 0px 0px 10px -5px ;

}
.btn:hover{
      background: -webkit-linear-gradient(top, #409eff 0%, #85e3ac 100%);
      background: linear-gradient(to bottom, #409eff 0%, #85e3ac 100%);
}
.btn:hover:active{
            border: none !important;
            top: 485px;
            box-shadow: 0px 2px 0px 0px #5cda8f, 0px 5px 12px 0px rgba(0, 0, 0, 0.6), inset 0px 0px 10px -5px #000000;
}
.boxBig{
  width: 100%;
}
.box {
  // flex: 1;
  display: flex;
  width: 90% !important;
  flex-wrap: wrap;
  margin-top: 10px;
  margin-left: 30px;
  // height: 400px;
  // width: 100%;
  // background: yellow;
  text-align: center;
  border: 2px dotted pink;
  // background: red;
  // overflow-y: scroll;
  position: relative;
  border-radius: 10px;

  
  .item-con{
    margin:5px;
    // border-radius: 5px;
    // width: px;
    // width: 100%;
  }
  .showBtn{
    position: relative;
    width: 0px;
    height: 0;
    border-top: 8px solid transparent;
    border-left: 12px solid #fff;
    border-right: 8px  solid transparent;
    border-bottom: 8px solid transparent;
    top: -30px;
    left: 1px;
    transition: all 0.3s;
    z-index: 2;
    cursor: pointer;
    transform-origin: center left;
    transition: all 0.3s;
  }
  .showDetail{
    transform: rotate(90deg);
  }
  .generate{
      position: fixed;
      top: 50%;
      transition: all 0.5s;
      transform: translateY(-60px);
      right: 200px;
      width: 120px;
      height: 120px;
      border-radius: 50%;
      background: #67c23a;
      text-align: center;
      line-height: 120px;
      font-size: 20px;
      color:#fff;
      font-weight: bold;
      cursor: pointer;
      &:hover {
        transform: translateY(-75px);
        font-size:26px ;
        width: 150px;
        height: 150px;
        line-height: 150px;
      }
  }
}
</style>