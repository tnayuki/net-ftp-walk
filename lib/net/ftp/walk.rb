require 'net/ftp/list'

class Net::FTP
  def walk(dir, parser_class = Net::FTP::List, &block)
    paths = [ dir ]

    while paths.count > 0 do
      path = paths.pop

      self.list(path) do |e|
        entry = parser_class.parse(e)

        if entry.dir? then
          unless ['.', '..'].include? entry.basename then
            paths << path + '/' + entry.basename
          end
        else
          yield path, entry
        end
      end
    end
  end

  def du(dir, block_size = 4096, parser_class = Net::FTP::List)
    sum = 0

    walk(dir, parser_class) do |path, entry|
      sum += (entry.filesize + block_size - 1) / block_size * block_size
    end

    sum
  end

  def mirror(remote_dir, local_dir, includes = [], parser_class = Net::FTP::List)
    queue = []

    walk(remote_dir, parser_class) do |path, entry|
      next if includes.count > 0 && includes.select{|pattern| File.fnmatch(pattern, entry.basename)}.count == 0

      common_path = path[remote_dir.length + 1 .. -1]

      remote_file = remote_dir + '/' + common_path + '/' + entry.basename
      local_file = local_dir + '/' + common_path + '/' + entry.basename

      if not Dir.exists?(local_dir + '/' + common_path) then
        Dir.mkdir(local_dir + '/' + common_path)
      elsif File.exist?(local_file)
        next if File.size(local_file) == entry.filesize && File.mtime(local_file) == entry.mtime
      end

      queue << [remote_file, local_file, entry.mtime]
    end

    queue.each do |item|
      getbinaryfile(item[0], item[1])

      File.utime(item[2], item[2], item[1])
    end
  end
end
