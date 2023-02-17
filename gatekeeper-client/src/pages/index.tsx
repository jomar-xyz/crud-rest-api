import { useRouter } from "next/router";
import { send } from "process";
import { useEffect, useState,useRef } from "react";
import axios from 'axios'; 
var md5 = require('md5')


const Index = () => {
  const router = useRouter();
  const [userMessage, setUserMessage] = useState("inbound-welcome: erc-tax-credit")
  const [uniqueID, setUniqueID] = useState(Math.ceil(Math.random()*100000) )
  const [messages, setMessages] =useState([])
   const [openChat, setOpenChat] = useState(true)
 
  // const[voiceId, setVoiceId] =useState()
  
  const myRef = useRef(null);
  // let messages=[];

  // useEffect(()=>{
  //   if(!uniqueID){
   
  //     let new_num=Math.ceil(Math.random()*100000) 
  //     setUniqueID(new_num)
   
  //   }

  // },[])

  useEffect(()=>{ 
    send()
    generateVoice("THANK YOU")
  },[uniqueID])
  const send =()=>{
    // setMessages([...messages,{"agent": "erc-taxcredit"}])
    axios.post(`https://ivmx16gbe3.execute-api.us-east-2.amazonaws.com/staging/v1/dialogflow/fulfillment/boom-agent-staging-bcml/${uniqueID}`,{ "text": userMessage })
    .then(function (response) {
      // handle success
    

      const parser = new DOMParser();
const xmlDoc = parser.parseFromString(response.data.queryResult.fulfillmentMessages[0].text.text[0], 'text/xml');
const audioElement = xmlDoc.getElementsByTagName('audio')[0];
const srcValue = audioElement.getAttribute('src');
let sound = new Audio(srcValue); 
const audioText = audioElement.textContent; 
  let agent_message={"agent" : audioText,"audio": srcValue  }

  
 
  
  if(response.data.queryResult?.intent.displayName.includes("Fallback")){
   
     axios.post("http://73fa-34-90-243-224.ngrok.io/gatekeeper", {data:userMessage }).then((data)=>{
     
      // agent_message= {"agent" : data.data.bot_response}
      setMessages([...messages,{"agent" : data.data.bot_response}]) 
     }
    ) .catch(function (error) {
      // handle error
      console.log(error);
    })
  
     
    // setMessages([...messages,new_message])
 
  }else{
    sound.play();
  setMessages([...messages,agent_message])

  // audioElement?.play()
  console.log(audioElement,srcValue, "audioElement")
   }
    })
    .catch(function (error) {
      // handle error
      console.log(error);
    })
  
    
 setUserMessage("")
  }
  console.log(messages, "messages ")

  useEffect(() => {
    myRef.current.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);



const createHash = (str = '') => {
  // This is to avoid issues with the old audios hashes created before
  const choiceRex = str.includes('-') ? /[^A-Za-z0-9\-]/g : /[^A-Za-z0-9]/g

  var generate = md5(
    str
      .replace(choiceRex, '')
      .toLowerCase()
      .replace(/[^\x00-\x7F]/g, '')
  )

  return generate
}

const generateVoice =(text)=>{

const audioHash= createHash(text)
console.log(text, "text")

// let payload={"xi-api-key": "  "}
//   axios.post(`https://api.elevenlabs.io/v1/text-to-speech/${text}`,payload)
//   .then(function (response) {
//     // handle success
//     console.log(response , "GENERATE VOICE")
//     // checkStatusVoice(response.data.data.session_id)
//     // setVoiceId(response.data.data.session_id)
    
     
//   })
//   .catch(function (error) {
//     // handle error
//     console.log(error);
//   })
//  let payload={"source_voice_id":"c59d5676-3d1d-436b-9d50-8f574ff2cd8f","text_array":[{"audioHash":audioHash,"text":text}]}
//   axios.post(`https://services.boom.ai/speaktome/api/audio/generate`,payload)
//   .then(function (response) {
//     // handle success
//     console.log(response.data.data.session_id,text, "GENERATE VOICE")
//     checkStatusVoice(response.data.data.session_id)
//     // setVoiceId(response.data.data.session_id)
    
     
//   })
//   .catch(function (error) {
//     // handle error
//     console.log(error);
//   })
}

const checkStatusVoice =(voiceId)=>{

  


    axios.post(`https://services.boom.ai/speaktome/api/audio/status/${voiceId}`)
    .then(function (response) {
      // handle success
      console.log(response, "GENERATE VOICE")
      console.log(voiceId,response,"CHECK STATUS")
      
       
    })
    .catch(function (error) {
      // handle error
      console.log(error);
    })
  }

  return (
    <div className="overflow-hidden">
      <div
        className="bg-white"
        style={{
          padding: 10,
        }}
      >
        <div
          className="w-full bg-gray-200 rounded-lg flex"
         
        >
          <div className="w-4/6 ">
            <div className="flex space-x-2 items-center p-5 relative mb-3">
              <img
                src="https://i.ibb.co/4tPyY8T/favicon-1.png"
                alt="favicon-1"
                border="0"
              />
              <span className="tracking-widest font-bold">BOOM AI</span>
              <div
                className="p-1"
                style={{
                  background: "#F6F6FB",
                }}
              >
                AGENT
              </div>
              <img
              onClick={()=>setOpenChat(!openChat)}
                src="https://i.ibb.co/XzbnBB9/image-8-2-1.png"
                alt="image-8-2-1"
                border="0"
                className="absolute bottom-0 right-0"
              ></img>
            </div>
            <div
              className="w-full shadow-md rounded relative ml-2"
              style={{
                background: "rgba(104, 22, 130, 0.2)",
                height: 590,
              }}
            >
              <audio id="binary-audio" src="binary-response.mp3"></audio>
              <img
                src="https://i.ibb.co/bX5kkbN/image-8-1-1.png"
                alt="image-8-1-1"
                border="0"
                className="absolute"
                style={{
                  left: 20,
                  top: 20,
                }}
              ></img>
              <img
                src="https://i.ibb.co/sqhcY3F/image-1.png"
                alt="image-1"
                border="0"
                className="mx-auto"
              ></img>
              <div className="w-full p-2 absolute bottom-0 text-center">
                <span>1:20</span>
              </div>
            </div>
            <div className="m-5 w-full flex items-center justify-center space-x-4">
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/hfswz4h/image-8-1.png"
                  alt="image-8-1"
                  border="0"
                />
              </div>
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/ygycPWW/image-6-1.png"
                  alt="image-6-1"
                  border="0"
                />
              </div>
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/DCFZnS9/image-9-1.png"
                  alt="image-9-1"
                  border="0"
                />
              </div>
            </div>
          </div>
          <div className="flex-1 h-full flex items-center p-5">
            <div
              className="w-full flex flex-col bg-white rounded-lg shadow-lg"
              style={{
                height: 739,
              }}
            >
              <div className="w-full flex justify-between p-3">
                <span>TRANSCRIBE</span> <span>x</span>
              </div>
              <div className="flex-1 overflow-scroll overflow-x-hidden" style={{
                height: "90%",
              }}>

                {  messages?.map((item,index)=>{
                  console.log(item, "ITEM")
                  

          
                  console.log(item.audio, "AUIDO")
                  if(item.agent){
                  return <><div className="flex space-x-2 p-3   ">
                  <img
                     class="h-[40px]"
                    src="https://i.ibb.co/7zDRKB3/201231-Calling-Screen-ai-1.png"
                    alt="201231-Calling-Screen-ai-1"
             
                  />
                  <div
                    className="bg-gray-200 flex-1   text-[12px] p-3 rounded-lg"
                    // style={{
                    //   maxWidth: "60%",
                    // }}
          
                  >{item.agent}</div>
                </div></>}
                else if(item?.user){
                  return <> 
                <div className="flex justify-end space-x-2 p-3 ">
                  <div
                    className="  text-[12px] p-3 rounded-lg"
                    style={{
                      background: "rgba(104, 22, 130, 0.2)",
                  
                    }}
                    // style={{
                    //   maxWidth: "60%",
                    // }}
                  >{item.user}</div>
                  <img
                    src="https://i.ibb.co/p4X69dV/201231-Calling-Screen-ai-1-1.png"
                    alt="201231-Calling-Screen-ai-1-1"
                    border="0"
                    class="h-[40px]"
                  />
                </div></>}
                })}
                <div ref={myRef}></div>
                  {/* <div className="flex space-x-2 p-3">
                    <img
                      src="https://i.ibb.co/7zDRKB3/201231-Calling-Screen-ai-1.png"
                      alt="201231-Calling-Screen-ai-1"
                      border="0"
                    />
                    <div
                      className="bg-gray-200 flex-1 w-1/2"
                      style={{
                        maxWidth: "60%",
                      }}
                    ></div>
                  </div>
                  <div className="flex justify-end space-x-2 p-3">
                    <div
                      className="bg-gray-200 w-1/2"
                      style={{
                        maxWidth: "60%",
                      }}
                    ></div>
                    <img
                      src="https://i.ibb.co/p4X69dV/201231-Calling-Screen-ai-1-1.png"
                      alt="201231-Calling-Screen-ai-1-1"
                      border="0"
                    />
                  </div> */}
              </div>
              <div
                className="flex text-gray-500 p-3"
                style={{
                  height: 70,
                }}
              >
                <input
                  type="text"
                  value={userMessage}
                  onChange={(e)=>{setUserMessage(e.target.value) 
                  }}
                  placeholder="Write your message!"
                  className="flex-1 focus:outline-none focus:placeholder-gray-400 text-gray-600 placeholder-gray-600 pl-12 bg-gray-200 rounded-md py-3"
                /> <button className="w-20 bg-blue-500 mx-1 rounded text-white" onClick={()=>{
                  send()
                  let user_message={"user" :userMessage }
    messages.push(user_message)
  }}>SEND</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        className="bg-white hidden"
        style={{
          padding: 136,
        }}
      >
        <div
          className="w-full bg-gray-200 rounded-lg flex hidden"
          style={{
            height: 820,
          }}
        >
          <div className="w-4/6 ">
            <div className="flex space-x-2 items-center p-5 relative mb-3">
              <img
                src="https://i.ibb.co/4tPyY8T/favicon-1.png"
                alt="favicon-1"
                border="0"
              />
              <span className="tracking-widest font-bold">BOOM AI</span>
              <div
                className="p-1"
                style={{
                  background: "#F6F6FB",
                }}
              >
                AGENT
              </div>
              <img
                src="https://i.ibb.co/XzbnBB9/image-8-2-1.png"
                alt="image-8-2-1"
                border="0"
                className="absolute bottom-0 right-0"
              ></img>
            </div>
            <div
              className="w-full shadow-md rounded relative ml-2"
              style={{
                background: "rgba(104, 22, 130, 0.2)",
                height: 590,
              }}
            >
              <img
                src="https://i.ibb.co/bX5kkbN/image-8-1-1.png"
                alt="image-8-1-1"
                border="0"
                className="absolute"
                style={{
                  left: 20,
                  top: 20,
                }}
              ></img>
              <div className="w-full h-full flex flex-col justify-center items-center">
                <p className="uppercase text-3xl text-gray-800 tracking-widest font-bold">
                  transfer call
                </p>
                <p className="uppercase text-gray-800 tracking-widest">
                  waiting time 5secs
                </p>
              </div>
              <div className="w-full p-2 absolute bottom-0 text-center">
                <span>1:20</span>
              </div>
            </div>
            <div className="m-5 w-full flex items-center justify-center space-x-4">
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/hfswz4h/image-8-1.png"
                  alt="image-8-1"
                  border="0"
                />
              </div>
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/ygycPWW/image-6-1.png"
                  alt="image-6-1"
                  border="0"
                />
              </div>
              <div className="w-20 h-20 rounded-lg bg-white flex items-center justify-center">
                <img
                  src="https://i.ibb.co/DCFZnS9/image-9-1.png"
                  alt="image-9-1"
                  border="0"
                />
              </div>
            </div>
          </div>
          <div className="flex-1 h-full flex items-center p-5">
            {openChat && <div
              className="w-full flex flex-col bg-white rounded-lg shadow-lg"
              style={{
                height: 739,
              }}
            >
              <div className="w-full flex justify-between p-3">
                <span>TRANSCRIBE</span> <span>x</span>
              </div>
              <div className="flex-1">
                <div className="flex space-x-2 p-3">
                  <img
                    src="https://i.ibb.co/7zDRKB3/201231-Calling-Screen-ai-1.png"
                    alt="201231-Calling-Screen-ai-1"
                    border="0"
                  />
                  <div
                    className="bg-gray-200 flex-1 w-1/2"
                    style={{
                      maxWidth: "60%",
                    }}
                  ></div>
                </div>
                <div className="flex justify-end space-x-2 p-3">
                  <div
                    className="bg-gray-200 w-1/2"
                    style={{
                      maxWidth: "60%",
                    }}
                  ></div>
                  <img
                    src="https://i.ibb.co/p4X69dV/201231-Calling-Screen-ai-1-1.png"
                    alt="201231-Calling-Screen-ai-1-1"
                    border="0"
                  />
                </div>
              </div>
              <div
                className="text-gray-500"
                style={{
                  height: 250,
                }}
              >
                <div className="flex items-center">
                  <hr className="flex-1"></hr>
                  <span className="mx-2">Transfer call</span>
                  <hr className="flex-1"></hr>
                </div>
                <div className="text-center py-3">
                  <p className="text-sm">Waiting time 5secs</p>
                </div>
              </div>
            </div>}
            
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
