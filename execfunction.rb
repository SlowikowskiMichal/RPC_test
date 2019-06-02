def fun(fileToExec)
  system "ruby -wc path/to/file.rb"
end


if __FILE__ == $0
  fun("w chuj!")
end