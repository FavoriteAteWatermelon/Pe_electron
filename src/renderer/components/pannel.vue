<template>
  <div>
    <div class="mask" v-show="showMask">
      loading...
    </div>
      <div @click="closePannel" class="close">《=  Back</div>
      <div class="item" v-for="(item,index) in list" :key="item.name">
       {{index + 1}}. {{item.name}}
      </div>
      <div class="input">
         <div>导入({{src}})</div>
  <!-- <input type="file" @change="changeInputSrc($event,0)" ref="inputSrc" style="opacity: 0" webkitdirectory  /> -->
 
      </div>
    
      <div class="export">    
             <div>导出({{testExport}})</div>
  <!-- <input type="file"  @change="changeInputSrc($event,1)" ref="exportSrc" style="opacity: 0" webkitdirectory  /> -->
 </div>
      <div class="start" @click="testBatStart">生成</div>
      <el-dialog

  title="机种名"
  :visible.sync="showName"
  width="30%"
  :modal= "mask"
  >
    <el-input  placeholder="请输入机种名" v-model="name">
    <template slot="prepend">机种名:</template>
  
    
  </el-input>
<el-button @click="comfirm" style="margin-top:20px" type="primary">确定</el-button>
</el-dialog>
  </div>
</template>

<script>
/* eslint-disable*/
const {ipcRenderer} = require('electron')
const fs =require('fs')
const fsDir = require('fs-extra')
const process = require('child_process')
  export default {
    props: {
      list: {
        type: Array,
        default:[]
      },
      secretList:{
        type: Array,
        default: []
      }
    },
    data () {
      return {
        src: 'D:/SRC',
        testExport: 'D:/TESTAP',
        showMask: false,
        name: '',
        mask: false,
        showName: false
      }

    },
    mounted () {
      // console.log(this.secretList)

    },

    methods: {
     testBatStart() {
      this.showName = true
  
 
    

      },
      comfirm() {
        if (this.name === '') {
          alert('请输入主板名')
         this.showName= false
          return
        } else{
          
          this.showName= false

          setTimeout(() => {
            this.start(`echo ${this.name} Function testing......`)
          }, 1000);
      
        }

      },
    start(name) {
      console.log(name)
      this.showMask = true
      setTimeout(async()=>{
      fsDir.remove(this.testExport,async(err)=>{
      // await fs.mkdirSync(this.testExport)
      await fsDir.copySync(this.src+ '/'+'TESTAP',this.testExport)
      this.list.forEach(async (item,index)=>{
        let content = await  fs.readFileSync(`${this.src}/BACKUP/${item.name.toUpperCase()}.bat`,'utf-8')
        let re = /.*(cd\\testap\\.*).*/g
        let dirList = content.match(re)
        if (dirList.length > 0) {
          dirList.forEach(async (mitem,i) =>{
            let str = mitem.replace('cd\\testap\\','').toUpperCase().trim()
            if(mitem != 'cd\\testap\\backup'){
              // console.log(this.exportSrc + '/' + str)
               await fsDir.copySync(this.src + '/' + str,this.testExport + '/' + str )
            }
           
          })
          
        } 
        // await fsDir.copySync(`${this.src}/${item.name.toLowerCase()}`,`${this.testExport}/${item.name.toLowerCase()}`)
      },1000)
      
        let info = fs.readFileSync(this.src+ '/' + 'test.bat','utf8')
        
        let tem1 = ''
        let tem2 = ''
        this.list.forEach((item,index)=>{
          if (item.station === 1) {
            tem1 = tem1 + 'call ' + item.name + '.bat' + '\r\n'
           
          } else {
            tem2 = tem2 + 'call ' + item.name +'.bat' + '\r\n'
          }
        })
        let result =  info.replace( new RegExp(/#1/,'g'), tem1).replace(new RegExp(/#2/,'g'),tem2).replace(new RegExp(/#name/,'g'),name)

        
        await fs.writeFileSync(this.testExport + '/' + 'test.bat',result,'utf8')
        // console.log(this.secretList)
        // 处理加密文件MSITEST.xml

        let xmlInfo = fs.readFileSync(this.src+ '/' + 'MSITEST.xml','utf8')
        
        let  tem3 = ''
        this.secretList.forEach((item,index)=>{
     
            tem3 = tem3 + `<Point ID="${index + 1}"><Desc>${item.name}</Desc></Point>` + '\r\n'
 
        })
        
        let xmlRes = xmlInfo.replace(new RegExp(/#name/,'g'), `<Model>${this.name}</Model>`).replace(new RegExp(/#item/,'g'),tem3)
        
        await fs.writeFileSync(this.testExport + '/' + 'MSITEST.xml',xmlRes,'utf8')
        this.decodeXml()
        await fs.mkdirSync(this.testExport + '/BATCH')
        this.secretList.forEach((item,index)=>{
          // console.log(item)
          this.decodeAll(item.name)
        })
        this.name = ''
        this.showMask = false
        alert('success!')
      })


      })
      },
      decodeXml () {
        var data = ''
        let l =0
        let kList = [2,1,2,1,3,2,1]
        // @ 64
        // console.log('A'.charCodeAt())
        var readerStream = fs.createReadStream(`${this.testExport}/MSITEST.xml`,{highWaterMark:1});
                readerStream.setEncoding('UTF8');

        // 处理流事件 --> data, end, and error
        readerStream.on('data', function(chunk) {
          // console.log(chunk)
          l ++
          chunk= String.fromCharCode(chunk.charCodeAt() + kList[l % 7] ) 
          data += chunk;
        
      });
      let that = this
      readerStream.on('end',function(){
        console.log(`${that.testExport}/MSITEST.xml`)
       fs.writeFileSync(`${that.testExport}/MSITEST.xml`,data,'utf8')
      });
      },
     decodeAll (name) {
      var data = ''
        let l =0
        let kList = [2,1,2,1,3,2,1]
        // @ 64
        // console.log('A'.charCodeAt())
        var readerStream = fs.createReadStream(`${this.src}/testxml/${name.toUpperCase()}.bat`,{highWaterMark:1});

        // 设置编码为 utf8。
        readerStream.setEncoding('UTF8');

        // 处理流事件 --> data, end, and error
        readerStream.on('data', function(chunk) {
          l ++
          chunk= String.fromCharCode(chunk.charCodeAt() + kList[l % 7] ) 
          data += chunk;
        
      });
      let that = this
      readerStream.on('end',function(){
       fs.writeFileSync(that.testExport + '/BATCH/' + name+'.bat',data,'utf8')
      });

      readerStream.on('error', function(err){
        console.log(err.stack);
      });
      },
      closePannel () {
        this.$emit('closePannel')
      },
      inputChange(type) {
        if (type === 0) {
            this.$refs.inputSrc.click()
       
        }else {
           this.$refs.exportSrc.click()
        }
        
      },
      changeInputSrc(e,type) {
        if (e.target.files[0]) {
          if(type === 0) {
            this.src = e.target.files[0]['path']
          } else {
            this.testExport = e.target.files[0]['path']
          }

        }
        
      },
    }
  }
</script>

<style lang="scss" scoped>
.pannel{
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding-left: 40px;
  background: #ffffff;
  z-index: 300;
  transition: all 0.5s;
}
.mask{
  position: absolute;
  display: flex;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: #000000;
  opacity: 0.5;
  justify-content: center;
  align-items: center;
  color: #FFFFFF;
  z-index: 20;
}
.close{
  margin-top: 10px;
  width: 140px;
  height: 40px;
  background: #565334;
  color: #ffffff;
  border-radius: 5px;
  text-align: center;
  line-height: 40px;
  cursor: pointer;
  margin-left: 5px;
  margin-bottom: 20px;

}
.item{
display: inline-block;
padding: 5px 8px;
background:#409eff ;
color: #ffffff;
font-size: 12px;
// width: 60px;
margin: 5px;
}
.input{
  position: absolute;
  bottom: 60px;
  width: 100px;
  line-height: 20px;
  height: 20px;
  padding: 5px 10px;
  text-align: center;
  background: #409eff;
  color: #ffffff;
  border-radius: 5px;
  cursor: pointer;

}
.export{
    position: absolute;
  bottom: 60px;
  width: 140px;
  left: 200px;
  line-height: 20px;
  height: 20px;
  padding: 5px 10px;
  text-align: center;
  background: #409eff;
  color: #ffffff;
  border-radius: 5px;
  cursor: pointer;
}
.start{
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
.start:hover{
  background: -webkit-linear-gradient(top, #409eff 0%, #85e3ac 100%);
      background: linear-gradient(to bottom, #409eff 0%, #85e3ac 100%);
}
.start:hover:active{
     border: none !important;
            top: 485px;
            box-shadow: 0px 2px 0px 0px #5cda8f, 0px 5px 12px 0px rgba(0, 0, 0, 0.6), inset 0px 0px 10px -5px #000000;

}
</style>