config = {
  _id: "replication",
  version: 1,
  term: 0,
  members: [
    {_id: 0, host: "61.111.2.104:27012"},
    {_id: 1, host: "61.111.2.59:27012"},
    {_id: 2, host: "61.111.2.70:47013", arbiterOnly: true},
  ]
}
rs.initiate(config);
rs.conf();