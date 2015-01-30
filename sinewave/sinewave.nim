import portaudio as PA
from math import sin, PI

type
  TUserData = object
    count : int64
  TFloatBuffer {.unchecked.} = array[0..0, float32]

let samplerate = 44100.0

proc streamCallback(inBuf, outBuf: pointer,
                    framesPerBuf: culong,
                    timeInfo: ptr TStreamCallbackTimeInfo,
                    statusFlags: TStreamCallbackFlags,
                    userData: pointer): cint {.cdecl.} =
  var
    outBuf = cast[ptr TFloatBuffer](outBuf)
    userData = cast[ptr TUserData](userData)

  for i in 0.. <framesPerBuf.int:
    var val = 0.4 * sin((2.0 * PI * 440.0 * userData.count.float32) / samplerate)
    outBuf[i] = val
    userData.count += 1

  PA.scrContinue.cint

template check(call : expr) =
  assert(cast[TErrorCode](call) == PA.NoError)

var
  stream: PStream
  userData = TUserData(count:0)

check(PA.Initialize())
check(PA.OpenDefaultStream(cast[PStream](stream.addr),
                           numInputChannels = 0,
                           numOutputChannels = 1,
                           sampleFormat = sfFloat32,
                           sampleRate = samplerate,
                           framesPerBuffer = 512,
                           streamCallback = streamCallback,
                           userData = cast[pointer](userData.addr)))
check(PA.StartStream(stream))
PA.Sleep(2000)
check(PA.StopStream(stream))
check(PA.CloseStream(stream))
check(PA.Terminate())
