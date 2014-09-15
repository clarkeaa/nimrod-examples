import tables
from strutils import split, replace, toUpper, Letters, parseInt
from sequtils import filter
from times import getTime
from os import paramCount, paramStr

type
  TNode = object
    edges : seq[string]
  PNode = ref TNode
  TNodeTable = TTable[seq[string], PNode]

let 
  puncSet = {'.', '?', '!'}
  stripSet = {',', '"', '\'', 
              '_', ';', ':', 
              '(', '[', ']', ')'}
  sentenceDelim = "MARKOV_SENTENCE"
  nodeLength = 2

proc newNode() : PNode =
  new(result)
  result.edges = @[]

proc makeStartWordQueue() : seq[string] =
  result = @[]
  for i in 0..nodeLength-1:
    result.add(sentenceDelim)

proc isRealWord(str:string) : bool =
  if len(str) > 0:
    for x in str:
      if x in Letters:
        return true
    return false
  else:
    return false

proc mapCharacters(line:string) : string =
  result = ""  
  for ch in line:
    if ch in puncSet:
      result.add(" " & sentenceDelim & " ")
    elif ch in stripSet:
      discard
    elif ch == '-':
      result.add(" ")
    else:
      result.add(ch)

proc pushPop[T](sequence:var seq[T], x:T) =
  sequence.insert(x)
  discard sequence.pop()

proc getOrMake[A, B](table : var TTable[A,B], key : A, maker : proc() : B) : B =
  if table.haskey(key):
    return table[key]
  else:
    var newItem = maker()
    table[key] = newItem
    return newItem
  
proc loadFile(nodes: var TNodeTable, filename: string) =
  var 
    infile = open(filename, fmRead)
    wordQueue = makeStartWordQueue()
  
  while not endOfFile(infile):
    let 
      line = readLine(infile)
      withoutPunc = mapCharacters(line)     
      words = withoutPunc.split(" ")    
      realWords = filter(words, isRealWord)
      mappedWords = map(realWords, toUpper)

    for nextWord in mappedWords:            
      var node = nodes.getOrMake(wordQueue, proc() : PNode = newNode())
      node.edges.add(nextWord)

      if nextWord == sentenceDelim:
        wordQueue = makeStartWordQueue()
      else:
        pushPop(wordQueue, nextWord)

  infile.close()

#\note nimrods default rand wasn't working for me
proc crand() : cint {.importc: "rand".}
proc csrand(seed : cint) {.importc:"srand".}

proc randItem[T](sequence : seq[T]) : T = 
  let index = cast[int](crand()) %% len(sequence)
  return sequence[index]

proc generate(nodes: TNodeTable, count: int) = 
  csrand(cast[cint](getTime()))
  var 
    wordQueue = makeStartWordQueue()
    tally = 0
  while tally < count:
    let
      node : PNode = nodes[wordQueue]
      nextWord = randItem(node.edges)
    if nextWord == sentenceDelim:
      echo "."
      tally += 1
      wordQueue = makeStartWordQueue()
    else:
      write(stdout, nextWord & " ")
      pushPop(wordQueue, nextWord)
  
if paramCount() != 2:
  echo "markov_chain <filename> <num sentences>"
else:
  var nodes = initTable[seq[string], PNode](1024*256)
  echo "loading chains..."
  nodes.loadFile(paramStr(1))
  echo "sentences:"
  generate(nodes, parseInt(paramStr(2)))
