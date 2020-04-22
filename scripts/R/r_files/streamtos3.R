library(biggr)
library(redditor)

tryCatch({
  nowtime <- as.character(now(tzone = 'UTC'))
  nowtime <- str_replace(nowtime, ' ', '_')
  now_time_csv <- glue('stream_{nowtime}.csv')
  now_time_zip <- glue('stream_{nowtime}.zip')
  fs::file_move(path = 'stream.csv', new_path = now_time_csv)
  zip(zipfile = now_time_zip, files = now_time_csv)
  s3_upload_file(bucket = 'reddit-dumps', from = now_time_zip, to = now_time_zip, make_public = TRUE)
  file_size <- as.character(fs::file_info(now_time_csv)$size)
  file_delete(now_time_csv)
  file_delete(now_time_zip)
  sns_send_message(phone_number = Sys.getenv('MY_PHONE'), message = glue('File uploaded\n{file_size}')) 
}, error = function(e) {
  file_size <- as.character(fs::file_info(now_time_csv)$size)
  sns_send_message(phone_number = Sys.getenv('MY_PHONE'), message = 'Something went wrong') 
})