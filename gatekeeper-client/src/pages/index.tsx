import { useRouter } from "next/router";

const Index = () => {
  const router = useRouter();

  return (
    <div className="w-full">
      <div
        className="bg-white"
        style={{
          padding: 136,
        }}
      >
        <div
          className="w-full bg-gray-200 rounded-lg flex"
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
                className="flex text-gray-500 p-3"
                style={{
                  height: 70,
                }}
              >
                <input
                  type="text"
                  placeholder="Write your message!"
                  className="flex-1 focus:outline-none focus:placeholder-gray-400 text-gray-600 placeholder-gray-600 pl-12 bg-gray-200 rounded-md py-3"
                /> <button className="w-20 bg-blue-500 mx-1 rounded text-white">SEND</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        className="bg-white"
        style={{
          padding: 136,
        }}
      >
        <div
          className="w-full bg-gray-200 rounded-lg flex"
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
            <div
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
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
