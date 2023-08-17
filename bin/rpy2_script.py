import rpy2.robjects as robjects

r = robjects.r
output_text = "Hello, world!"
r("cat('{}\\n', file='rpy2_output.txt')".format(output_text))