config = {
  _id: "replication",
  version: 1,
  term: 0,
  members: [
    {_id: 0, host: "mongodb:27017"}
  ]
}
rs.initiate(config);
rs.conf();