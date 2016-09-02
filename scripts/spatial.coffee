module.exports = (robot) ->
  robot.respond /探して (.*)/i, (msg) ->
    keyword = msg.match[1]
    msg.send keyword
    request = msg.http('http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates')
                          .query({
                            f: 'json',
                            singleLine: keyword
                          })
                          .get()
    request (err, res, body) ->
      if err
        msg.send 'みつからないよ〜'
        robot.emit 'error', err, res
        return

      json = JSON.parse body
      msg.send json.candidates[0].location.x + ', ' + json.candidates[0].location.y if json.candidates.length > 0
