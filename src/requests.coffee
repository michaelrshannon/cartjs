# Manage queues of AJAX requests.
# -------------------------------

pendingQueue = []
processingQueue = []
processing = false

Cart.enqueue = (url, data, callback, type = 'POST', dataType = 'json') ->
  queue = pendingQueue
  if processing and Cart.settings.autoCommit
    queue = processingQueue

  queue.push({
    url: url,
    data: data,
    callback: callback,
    type: type,
    dataType: dataType
  })

  if Cart.settings.autoCommit
    Cart.commit()

Cart.commit = () ->
  return if processing
  processing = true
  [].push.apply(processingQueue, pendingQueue.splice(0, pendingQueue.length))
  Cart.process()

Cart.process = () ->
  if not processingQueue.length
    processing = false
    return

  params = processingQueue.shift()
  params.complete = process
  jQuery.ajax(params)