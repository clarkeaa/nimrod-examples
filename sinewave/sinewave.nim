import portaudio as PA
from math import sin, pi

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
    var val = 0.4 * sin((2.0 * pi * 440.0 * userData.count.float32) / samplerate)
    outBuf[i] = val
    userData.count += 1

  PA.scrContinue.cint

template check(call : expr) =
  assert(cast[TErrorCode](call) == PA.noError)

var
  stream: PStream
  userData = TUserData(count:0)

check(PA.initialize())
check(PA.openDefaultStream(cast[PStream](stream.addr),
                           numInputChannels = 0,
                           numOutputChannels = 1,
                           sampleFormat = sfFloat32,
                           sampleRate = samplerate,
                           framesPerBuffer = 512,
                           streamCallback = streamCallback,
                           userData = cast[pointer](userData.addr)))
check(PA.startStream(stream))
PA.sleep(2000)
check(PA.stopStream(stream))
check(PA.closeStream(stream))
check(PA.terminate())
