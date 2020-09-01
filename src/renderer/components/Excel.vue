<template>
<div class="layout">
  <transition   name="pannel">
  <Pannel ref="pannel" :tl396="tl396" :tl423="tl423" :usb2="usb2" :usb3="usb3" :bios="bios"  :nextList1 ="nextList1" :nextList2="nextList2" :secretList="secretList" @closePannel="closePannel" v-show="showPanel" class="pannel"></Pannel>
  </transition>
 
  <div class="boxBig">
    <div class="box">
    <div class="title">For_1ST</div>
    <div class="item-con" v-for="(item,i) in test1" :key="i">
      
       <item @isSelected="isSelected(1,i)"  :info="item" :index="i"></item>
     <div v-if="item.items.length" :class="{showDetail:item.showDetail }" class="showBtn" @click="showDetailClick(item.name)">
     </div>
     
    </div>
  </div>
  <div class="box">
  <div class="title">For_2ST</div>
    <div class="item-con" v-for="(item,i) in testList" :key="i">    
       <item @isSelected="isSelected(2,i)"  :info="item" :index="i"></item>
      <div v-if="item.items.length" :class="{showDetail:item.showDetail }" class="showBtn" @click="showDetailClick(item.name)">
     </div>
    </div>
  </div>
    <div class="box">
  <div class="title">For_3T</div>
    <div class="item-con" v-for="(item,i) in test3" :key="i">    
       <item @isSelected="isSelected(3,i)"  :info="item" :index="i"></item>

    <div v-if="item.items.length" :class="{showDetail:item.showDetail }" class="showBtn" @click="showDetailClick(item.name)">
     </div>
    </div>
  </div>
        <el-dialog
        :show-close="false"
  :close-on-click-modal="false"
  title="BIOS设定"
  :visible.sync="showBios"
  width="500px"
  >
    <el-input  placeholder="1.20" v-model="bios.version">
    <template slot="prepend">version:</template>
  
  </el-input>
    <el-input placeholder="06/03/2020" v-model="bios.release">
    <template slot="prepend">release:</template>
  
  </el-input>
  <el-button @click="setBios"  type="primary">确定</el-button>
  <el-button @click="closeBios"  type="primary">取消</el-button>
</el-dialog>
<el-dialog    width="500px"  :visible.sync="showUSB"      :show-close="false"
  :close-on-click-modal="false" title="USB和tl396等设置">
    <el-input type="number" placeholder="请输入USB2的数量" v-model.number="usb2">
    <template slot="prepend">USB2:</template>
  
  </el-input>
    <el-input type="number" placeholder="请输入USB3的数量" v-model.number="usb3">
    <template slot="prepend">USB3:</template>
  
  </el-input>
    <el-input type="number" placeholder="请输入tl396的总数" v-model.number="tl396">
    <template slot="prepend">tl396:</template>
  
  </el-input>
    <el-input type="number" placeholder="请输入tl423的数量" v-model.number="tl423">
    <template slot="prepend">tl423:</template>
  
  </el-input>
 <el-button @click="setUSB"  type="primary">确定</el-button>
 <el-button @click="hideUSB"  type="primary">取消</el-button>
</el-dialog>
<el-dialog    width="500px"  :visible.sync="showLan"      :show-close="false"
  :close-on-click-modal="false" title="Lan设置">
   <div ref="lan" v-for="item in lanInfo " :key="item.title" style="margin-bottom: 10px;border-bottom: 1px solid #eee">
     <div class="title" style="font-size: 14px;font-weight: bold">{{item.title}}:</div>
      <el-checkbox v-for="city in item.children" :label="city.name" :key="city.name">{{city.name}}</el-checkbox>
   </div>
  
  
 <el-button @click="setLan"  type="primary">确定</el-button>
 <el-button @click="showLan = false"  type="primary">取消</el-button>
</el-dialog>
<el-dialog    width="500px"  :visible.sync="showAudio"      :show-close="false"
  :close-on-click-modal="false" title="Audio设置">
  <div >
    <el-radio-group @change="changeAudio" v-model="audio">
    <el-radio :label="F3">F3</el-radio>
    <el-radio :label="F5">F5</el-radio>
    <el-radio :label="F6">F6</el-radio>
  </el-radio-group>
  </div>

 <el-button style="margin-top: 20px" @click="setLan"  type="primary">确定</el-button>
 <el-button @click="showAudio = false"  type="primary">取消</el-button>
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
      showUSB: false,
      showLan: false,
      showAudio: false,
      audio: 'f3',
      bios:{
        version: '',
        release: ''
      },
      usb2: 0,
      usb3: 0,
      tl396: 0,
      tl423: 0,
      nextList1: [],
      nextList2:[],
      secretList:[],
      test1: [
      ],
      testList: [
      ],
      test3: [
      ],
      lanInfo: []
    }
  },
  mounted() {
     let data = JSON.parse( fs.readFileSync('./test1.json','utf8'))
     this.test1 = data
     let data2 = JSON.parse( fs.readFileSync('./test2.json','utf8'))
     this.testList= data2
     let data3 = JSON.parse(fs.readFileSync('./test3.json','utf8'))
     this.test3 = data3
     this.lanInfo = JSON.parse(fs.readFileSync('./lan.json','utf8'))
    
  },
  methods: {
    changeAudio () {
      console.log(this.audio)
    },
    setLan () {
      // console.log(this.$refs.lan[0].children[1].classList.length)
      console.log(this.$refs.lan[0].children[1].innerText)
      // innerText
    },
    setUSB () {
      if (this.usb2 >0 && this.usb3 >0 && this.tl423 >=0 && this.tl396 >= 0) {
        this.$message({
          duration: 3000,
          type: 'success',
          message: 'USB和tl设定成功!'
          });
        this.showUSB = false
      } else {
        this.$message({
          duration: 3000,
          type: 'error',
          message: 'USB设置必须为大于0的整数!'
          });
      }
    },
    setBios() {
      // console.log( typeof(this.bios.release) )
      if(this.bios.version.length === 4 && /[0-1][0-9]\/[0-3][0-9]\/2\d\d\d/.test(this.bios.release)) {
        this.$message({
          duration: 3000,
          type: 'success',
          message: '设定成功!'
          });
          this.showBios = false
      }else {
        this.$message({
          duration: 3000,
          type: 'warning',
          message: '设置不正确!'
          });
      }
    },
    hideUSB() {
      this.showUSB = false
    },
    closeBios() {
      // this.bios.version = ''
      // this.bios.release = ''
      this.showBios= false
    },
    // 确认输入bios的信息
    start () {
      this.nextList1 = []
      this.nextList2 = []
      this.secretList = []
      this.test1.forEach((item) => {
        if (item.selected === true) {
          this.nextList1.push(item)
        }
      })
      this.testList.forEach(item => {
              if (item.selected === true) {
          this.nextList2.push(item)
        }
      })
      this.test3.forEach(item => {
              if (item.selected === true) {
          this.secretList.push(item)
        }
      })
      // console.log()
      this.showPanel = true
      this.$refs.pannel.showName =true
    },
    closePannel () {
this.showPanel = false
    },
    
    isSelected (index, i) {
      // console.log(i,selected)
      if (index === 1) {
        if ( this.test1[i]['name'] === 'bioschk' && (!this.bios.version || !this.bios.release)) {
        
          this.showBios = true
        } else if ((this.usb2 === 0 || this.usb3 === 0) && (this.test1[i]['name'] === 'usb20' || this.test1[i]['name'] === 'usb30'||  this.test1[i]['name'] === 'tl396'|| this.test1[i]['name'] === 'tl423')){
          // console.log(  this.test1[i])
            this.showUSB = true
        }else {
          if (this.test1[i]['name'] === 'tl423' &&  this.tl423 === 0) {
              this.showUSB = true
          } else if (this.test1[i]['name'] === 'tl396' &&  this.tl396 === 0) {
             this.showUSB = true
          } else {
             this.test1[i]['selected'] = !this.test1[i]['selected']
          }
           
        }
      } else if(index === 2) {
         if (this.testList[i]['name'] === 'bioschk' && (!this.bios.version || !this.bios.release)) {
            this.showBios = true
         }else if((this.usb2 === 0 || this.usb3 === 0) && (this.testList[i]['name'] === 'usb20' || this.testList[i]['name'] === 'usb30'||  this.testList[i]['name'] === 'tl396'|| this.testList[i]['name'] === 'tl423')) {
              this.showUSB = true
         } else {
            if (this.testList[i]['name'] === 'tl423' &&  this.tl423 === 0) {
              this.showUSB = true
          } else if (this.testList[i]['name'] === 'tl396' &&  this.tl396 === 0) {
             this.showUSB = true
          } else {
          this.testList[i]['selected'] = !this.testList[i]['selected']
            }
         }

          // console.log(  this.testList[i])
          
        
      } else {
        // console.log(this.test3)
        if ((this.usb2 === 0 || this.usb3 === 0) && (this.test3[i]['name'] === 'usb20' || this.test3[i]['name'] === 'usb30'||  this.test3[i]['name'] === 'tl396'|| this.test3[i]['name'] === 'tl423' )) {
        
            this.showUSB = true
        } else {
          if (this.test3[i]['name'] === 'tl423' &&  this.tl423 === 0) {
              this.showUSB = true
          } else if (this.test3[i]['name'] === 'tl396' &&  this.tl396 === 0) {
             this.showUSB = true
          } else {
             this.test3[i]['selected'] = !this.test3[i]['selected']
          }
           
        }        
      }

    },
    showDetailClick(name) {
      if (name === 'bioschk') {
        this.showBios = true
      } else if (name === 'usb20' || name === 'usb30' || name === 'tl396' || name === 'tl423') {
        this.showUSB = true
      }else if (name === 'lan_w') {
        // console.log(this.lanInfo)
        this.showLan = true
      } else {
        this.showAudio = true
      }
      
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
    border-top: 12px solid #fff;
    border-left: 8px solid transparent;
    border-right: 8px  solid transparent;
    border-bottom: 8px solid transparent;
    top: -4px;
    left: calc(50% - 6px);
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