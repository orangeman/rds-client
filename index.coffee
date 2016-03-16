
module.exports = (sock, cb) ->
  t = null
  notify = {}
  sock.onopen = () ->
    @send JSON.stringify session: t = s()
    cb()

  rds = {}
  route = null
  sock.onmessage = (m) ->
    r = JSON.parse m.data
    if r.status == "deleted"
      delete rds[r.id]
    else
      rds[r.id] = r
    notify.ride r
    notify.done? r if r.me

  query: (q, d) ->
    notify.done = d if d
    if q.route
      if q.route == route
        return
      else
        rds = {}
        route = q.route
    sock.send JSON.stringify q
    @

  on: (r) -> notify.ride = r; @

  get: (id) -> rds[id]

  sort: (By) ->
    Object.keys(rds).map (r) -> rds[r]
    .sort (a, b) -> a[By] - b[By]

  token: () -> t

  close: () -> sock.close()

s = ->
  'xxxxxxxxxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)
  )
