<template>
  <div>
    <div class="mask" v-show="showMask">
      loading...
    </div>
      <div @click="closePannel" class="close">《=  Back</div>
      <div class="showError"  @click="showErrPanel">!查看错误信息</div>
      <div class="title">
        <div class="name">For_1ST</div>
      
        </div>
        <div style="border-bottom:2px solid #409eff">
               <div class="item" v-for="(item,index) in nextList1" :key="item.name">

       {{index + 1}}. {{item.name}}
      </div> 
        </div>

             <div class="title">
        <div class="name">For_2ST</div>
      
        </div>
        <div  style="border-bottom:2px solid #409eff">
      <div class="item" v-for="(item,index) in nextList2" :key="item.name">

       {{index + 1}}. {{item.name}}
      </div>
        </div>

          <div class="title">
        <div class="name">For_3ST</div>
      
        </div>
        <div  style="border-bottom:2px solid #409eff">
      <div class="item" v-for="(item,index) in  secretList" :key="item.name">

       {{index + 1}}. {{item.name}}
      </div>

        </div>

      <div class="input">
         <div>导入({{src}})</div>
  <!-- <input type="file" @change="changeInputSrc($event,0)" ref="inputSrc" style="opacity: 0" webkitdirectory  /> -->
 
      </div>
    
      <div @click="test" class="export">    
             <div>导出({{testExport}})</div>
  <!-- <input type="file"  @change="changeInputSrc($event,1)" ref="exportSrc" style="opacity: 0" webkitdirectory  /> -->
 </div>
      <!-- <div class="start" @click="testBatStart">生成</div> -->
      <el-dialog
      ref="log"

  title="机种名"
  :visible.sync="showName"
  width="300px"
  top="300px"
  :modal= "mask"
  >
    <el-input  placeholder="请输入机种名" v-model="name">
    <template slot="prepend">机种名: 601-</template>
  
    
  </el-input>
<el-button @click="comfirm" style="margin-top:20px" type="primary">确定</el-button>
</el-dialog>
<div class="errorPanel" v-show="showErr"     
  >
  <div class="centerP">
    <div class="close-btn" @click="showErr=false">x</div>
  <div class="err-title" >缺少批处理文件</div>
    <div class="item" v-for="(item) in  lackBatList.values()" :key="item.name">

       {{item}}
   </div>
  <div class="err-title">缺少处理文件对应的文件夹</div>
      <div class="item" v-for="item in  lackFileList" :key="item.name">
       {{Object.keys(item)[0]}}.bat中缺乏引用{{Object.values(item)[0]}}的文件夹
      </div>
  
  </div>


</div>
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
      audio: {
        type: String,
        default: ''
      },
      usb2: {
        type: Number,
        default: 0
      },
      usb3: {
        type: Number,
        default: 0
      },
      tl396: {
        type: Number,
        default: 0
      },
      tl423: {
        type: Number,
        default: 0
      },
      nextList1: {
        type: Array,
        default:[]
      },
      nextList2: {
        type: Array,
        default:[]
      },
      secretList:{
        type: Array,
        default: []
      },
      bios: {
        type: Object,
        default:{}
      }
    },
    data () {
      return {
        src: 'D:/SRC',
        testExport: 'D:/TESTAP',
        lackBatList: new Set(),
        lackFileList: [],
        showMask: false,
        showErr: false,
        name: '',
        mask: false,
        showName: false
      }

    },
    mounted () {
      this.$refs.log.$el.getElementsByClassName('el-dialog')[0].style.marginRight = 0
      this.$refs.log.$el.getElementsByClassName('el-dialog')[0].style.marginBottom = 0
      this.$refs.log.$el.getElementsByClassName('el-dialog')[0].style.height = '200px'
     
      // console.log(this.secretList)

    },
    methods: {
      showErrPanel () {
        this.showMask=false,
        this.showErr = true
      },
     testBatStart() {
      this.showName = true
      },
      test() {
        // console.log(this.bios)
      },
      comfirm() {
        if (this.name === '') {
          alert('请输入主板名')
         this.showName= false
          return
        } else{
          
          this.showName= false

          setTimeout(() => {
            this.start(`echo 601-${this.name} Function testing......`)
          }, 1000);
      
        }

      },
    start(name) {
      this.showMask = true
      this.lackBatList = new Set()
      this.lackFileList = []
      setTimeout(async()=>{
      fsDir.remove(this.testExport,async(err)=>{
      // 1. 第一步复制所必须的需求文件,此步骤不会报错
      await fsDir.copySync(this.src+ '/'+'testap',this.testExport)
      this.list = this.nextList1.concat(this.nextList2)
      // 复制需求的文件
      this.list.forEach(async (item,index)=>{
        // 2. 读取需要的1端和2段程式，有可能会没有会有应该提示报错
     
        let content = ''
        try {
           content = await  fs.readFileSync(`${this.src}/backup/${item.name.toLowerCase()}.bat`,'utf-8')
        }catch(e) {
          // 第一二段缺少copy .bat
          this.lackBatList.add(item.name)
        }
        // 3. copy需要的1段和2段程式,没有的话会报错跟上面一样
        if (item.name === 'usb20') {
           let contentRes = content.replace(new RegExp(/#usb2/,'g'), `wUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 5 >nul\r\nwUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 5 >nul\r\nwUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\n`)
            await  fs.writeFileSync(`${this.testExport}/backup/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'usb30') {
           let contentRes = content.replace(new RegExp(/#usb3/,'g'),`wUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 3 >nul\r\nwUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 3 >nul\r\nwUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\n`)
            await  fs.writeFileSync(`${this.testExport}/backup/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'tl396') {
           let contentRes = content.replace(new RegExp(/#396/,'g'),`find "${this.tl396} matching device(s) found" tl396.txt`)
          await  fs.writeFileSync(`${this.testExport}/backup/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'tl423') {
          let contentRes = content.replace(new RegExp(/#423/,'g'),`Wtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\ntimeout /t 3\r\n Wtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\ntimeout /t 3\r\nWtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n`)
           await  fs.writeFileSync(`${this.testExport}/backup/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else {
          try{
              await fs.copyFileSync(`${this.src}/backup/${item.name.toLowerCase()}.bat`, `${this.testExport}/backup/${item.name.toLowerCase()}.bat`)
          }catch(e) {
            this.lackBatList.add(item.name)
          }
           
        }
       
        let re = /.*(cd\\testap\\.*).*/g
        let dirList = content.match(re)
        // console.log(dirList)
        if (dirList!==null && dirList.length > 0) {
          dirList.forEach(async (mitem,i) =>{
            let str = mitem.replace('cd\\testap\\','').toLowerCase().trim()
           
            if(mitem === 'cd\\testap\\backup' || str.trim().toLowerCase() === 'backup'){
            }else {
              // 4. 检查内容copy依赖test1和test2的file
              try{
                 await fsDir.copySync(this.src + '/' + str,this.testExport + '/' + str )
              }catch(e) {
                // 依赖文件夹没有str
                this.lackFileList.push({[item.name]:str})
              }
            }
           
          })
        } 
      },1000)
        
       
       
        // 5 处理checklog
        let logInfo = fs.readFileSync(this.src+ '/backup/' + 'chklog.bat','utf8')
        let allList = this.nextList1.concat(this.nextList2).concat(this.secretList)
        let logotem = ''
        allList.forEach((item,index) => {
          logotem = logotem +`\r\nset test=${item.name.toLowerCase()}.bat\r\nfind "%test%" d:\\testap\\test.log\r\nif errorlevel 1 goto fail\r\n\r\n`

        })
        let logRes = logInfo.replace( new RegExp(/#checklog/,'g'), logotem)
        await fs.writeFileSync(this.testExport + '/backup/' + 'chklog.bat',logRes,'utf8')
        //  6. 处理bios
        let biosInfo = await fs.readFileSync(this.src+ '/backup/'+'bioschk.bat','utf8')
        let biosRes = biosInfo.replace(new RegExp(/#Version/,'g'), `find "BIOS Version      = ${this.bios.version}" BIOS.INI`).replace(new RegExp(/#Release/,'g'), `find "BIOS Release Date = ${this.bios.release}" BIOS.INI`)
        await  fs.writeFileSync(this.testExport+ '/backup/' + 'bioschk.bat',biosRes,'utf8')
        // await  fs.writeFileSync(this.testExport+ '/BACKUP/' + '1.bat',biosRes,'utf8')
        // 7.  处理test.bat内容
        let info = fs.readFileSync(this.src+ '/' + 'test.bat','utf8')
        
        let tem1 = ''
        let tem2 = ''
        this.list = this.nextList1.concat(this.nextList2)
        this.list.forEach((item,index)=>{
          if (item.station === 1) {
            tem1 = tem1 + 'call ' + item.name + '.bat' + '\r\n'
           
          } else {
            tem2 = tem2 + 'call ' + item.name +'.bat' + '\r\n'
          }
        })

     
        let result =  info.replace( new RegExp(/#1/,'g'), tem1).replace(new RegExp(/#2/,'g'),tem2).replace(new RegExp(/#name/,'g'),name)

        
        await fs.writeFileSync(this.testExport + '/' + 'test.bat',result,'utf8')
      
    
        // 8. 处理加密文件MSITEST.xml

        let xmlInfo = fs.readFileSync(this.src+ '/' + 'MSITEST.xml','utf8')
        
        let  tem3 = ''
        this.secretList.forEach((item,index)=>{
     
            tem3 = tem3 + `<Point ID="${index + 1}"><Desc>${item.name}</Desc></Point>` + '\r\n'
 
        })
        
        let xmlRes = xmlInfo.replace(new RegExp(/#name/,'g'), `<Model>601-${this.name}</Model>`).replace(new RegExp(/#item/,'g'),tem3)
        
       
        // copy MSITEST.xml到根目录一份
        await fs.writeFileSync(this.testExport + '/' + 'MSITEST.xml',xmlRes,'utf8')
         // copy MSITEST.xml到wencode目录一份
        await fs.writeFileSync(this.testExport + '/wencode/' + 'MSITEST.xml',xmlRes,'utf8')
        // 创建testxml
        await fs.mkdirSync(this.testExport +'/testxml/')

        this.secretList.forEach(async (item,index)=>{
        // 读取加密文件的内容
        let content = ''
        try {
           content = await  fs.readFileSync(`${this.src}/testxml/${item.name.toLowerCase()}.bat`,'utf-8')
        }catch(e) {
          this.lackBatList.add(item.name)
        }
        if (item.name === 'usb20') {
           let contentRes = content.replace(new RegExp(/#usb2/,'g'), `wUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 5 >nul\r\nwUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 5 >nul\r\nwUSB2det /COUNT ${this.usb2}\r\nif not ERRORLEVEL 1 goto end\r\n`)
           await  fs.writeFileSync(`${this.testExport}/testxml/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'usb30') {
           let contentRes = content.replace(new RegExp(/#usb3/,'g'),`wUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 3 >nul\r\nwUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\nping 127.0.0.1 -n 3 >nul\r\nwUSB3det /COUNT ${this.usb3}\r\nif not ERRORLEVEL 1 goto end\r\n`)
           await  fs.writeFileSync(`${this.testExport}/testxml/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'tl396') {
           let contentRes = content.replace(new RegExp(/#396/,'g'),`find "${this.tl396} matching device(s) found" tl396.txt`)
           await  fs.writeFileSync(`${this.testExport}/testxml/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else if (item.name === 'tl423') {
           let contentRes = content.replace(new RegExp(/#423/,'g'),`Wtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\ntimeout /t 3\r\n Wtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\ntimeout /t 3\r\nWtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\ntimeout /t 3\r\nWtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\ntimeout /t 3\r\nWtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\ntimeout /t 3\r\nWtl423 /NUM:${this.tl423}\r\nif not errorlevel 1 goto pass\r\n\r\n`)
           await  fs.writeFileSync(`${this.testExport}/testxml/${item.name.toLowerCase()}.bat`,contentRes,'utf8')
        }else {
          try{
            await fs.copyFileSync(`${this.src}/testxml/${item.name.toLowerCase()}.bat`, `${this.testExport}/testxml/${item.name.toLowerCase()}.bat`)
          }catch(e) {
            this.lackBatList.add(item.name)
          }
           
        }
       
        // console.log(item.name)
        let re = /.*(cd\\testap\\.*).*/g
        let dirList = content.match(re)
        // console.log(dirList)
        if (dirList!==null && dirList.length > 0) {
          dirList.forEach(async (mitem,i) =>{
            let str = mitem.replace('cd\\testap\\','').toLowerCase().trim()
           
            if(mitem === 'cd\\testap\\backup' || str.trim().toLowerCase() === 'backup'){
              // console.log(str.trim().toLowerCase())
              // console.log(this.testExport + '/' + str)
               
            }else {
              try {
                await fsDir.copySync(this.src + '/' + str,this.testExport + '/' + str )
              }catch(e) {
                  this.lackFileList.push({[item.name]:str})
              }
            }
           
          })
          
        }
        if (item.name === 'audio') {
          // console.log(item)
           await fs.renameSync(`${this.testExport}/hdtest/F${this.audio}.cfg`, `${this.testExport}/hdtest/FRONT.cfg`)
           await fs.renameSync(`${this.testExport}/hdtest/R${this.audio}.cfg`, `${this.testExport}/hdtest/REAR.cfg`)
        } 
        // await fsDir.copySync(`${this.src}/${item.name.toLowerCase()}`,`${this.testExport}/${item.name.toLowerCase()}`)
      },1000)
        
        // 对文件加密
        this.decodeXml()
        // await fs.mkdirSync(this.testExport + '/BATCH')
        this.secretList.forEach((item,index)=>{
          // console.log(item)
          this.decodeAll(item.name)
        })
        // 9. 处理音效
        // fsDir.copyFileSync
        
        // console.log(this.audio+ this.testExport)
//  await fs.copyFileSync(`${this.src}/testxml/${item.name.toLowerCase()}.bat`, `${this.testExport}/testxml/${item.name.toLowerCase()}.bat`)
        this.name = ''
        this.showMask = false
        if (this.lackBatList.size > 0 || this.lackFileList.length > 0) {
          this.showErr = true
        } else {
          alert('success!')
        }
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
     decodeAll(name) {
      var data = ''
        let l =0
        let kList = [2,1,2,1,3,2,1]
        // @ 64
        // console.log('A'.charCodeAt())
        var readerStream = fs.createReadStream(`${this.testExport}/testxml/${name.toLowerCase()}.bat`,{highWaterMark:1});
  
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
.err-title {
  color: red;
  font-size: 20px;
  font-weight: bold;
}
.showError{
  position: absolute;
  right: 20px;
  top: 20px;
  color: red;
  padding:4px 6px;
  font-weight: bold;
  letter-spacing: 2px;
  border: 1px solid red;
  cursor: pointer;
  border-radius: 4px;
}
.errorPanel{
  position: absolute;
  top:0;
  right: 0;
  left: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  .centerP{
    position: absolute;
    left: 50%;
    top: 100px;
    margin-left: -250px;
    width: 500px;
    height: 300px;
    overflow-y: scroll;
    background: #ffffff;
    .close-btn{
      position: absolute;
      right: 10px;
      top: 0;
      font-weight: bold;
      font-size: 40px;
      cursor: pointer;
    }
  }


}
.title{
  
 
  height: 20px;
    .name {
    display: inline-block;
    width: 200px;
    height: 100%;
    color: #409eff;
  }

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