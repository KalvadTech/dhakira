class Globr
  def initialize()
    @file_list = [] of String
  end

  def ls(path)
    files_to_load = Dir.glob("#{path}/**", match_hidden: false)
    i = 0
    while i < files_to_load.size
      if File.file?(files_to_load[i]) == true
        @file_list << files_to_load[i]
      end
      if Dir.exists?(files_to_load[i]) == true
        self.ls(files_to_load[i])
      end
      i += 1
    end
  end

  def file_list
    @file_list
  end
end
