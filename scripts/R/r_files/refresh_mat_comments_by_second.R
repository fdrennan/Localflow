library(redditor)
library(biggr)

refresh <- function() {
  con = postgres_connector()
  on.exit(dbDisconnect(con))
  dbExecute(
    conn = con, 
    statement = read_file('../../sql/materialized_views/refresh_mat_comments_by_second.sql')
  )
}

refresh()
