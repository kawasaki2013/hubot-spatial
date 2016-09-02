module.exports = (robot) ->
  robot.respond /探して (.*)/i, (msg) ->
    keyword = msg.match[1]
    msg.send keyword + '周辺の無料 wifi スポットだよ！'
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
      appUrl = 'https://bl.ocks.org/ynunokawa/raw/8ec5c70d089a55bcabf7e3fd5dce9e39/?lat=' + json.candidates[0].location.y + '&lng=' + json.candidates[0].location.x
      msg.send appUrl if json.candidates.length > 0
