fileConn<-file("./R_output.txt")
writeLines(c("Hello","World"), fileConn)
close(fileConn)