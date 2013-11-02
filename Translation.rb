require 'kconv'
require 'fileutils'

if ARGV.count < 3
  puts "need more than three argv"
  exit(3)
end
dirName = ARGV[0]
sourceDir = dirName + ARGV[1] + ".lproj"
lps = ARGV[2..-1]

storyboards = []
begin
  Dir.open(sourceDir).each {|f|
    if /(.*)\.storyboard/ =~ f
      storyboards = storyboards + [$1]
    end
  }
end

def fun(lproj, fileName)
  addtionData = []
  File.open("#{lproj}/#{fileName}.strings",  :mode => "rb", :encoding => "UTF-16LE") {|file|
    data = file.read.toutf8.scan(/".*" *= *"(.*)";\n/).uniq
    addtionData = data.flatten
  }
  transText = ""
  baseData = []
  begin
    File.open("#{lproj}/Translation.strings",  :mode => "rb", :encoding => "UTF-16LE") {|f|
      transText = f.read.toutf8
      data = transText.scan(/"(.*)"\s*=\s*".*";?\s*\n/)
      data = data + transText.scan(/"(.*)";?\s*\n/)
      baseData = data.flatten
    }
  rescue
  end
  aData = addtionData.select{|f| baseData.include?(f) == false}
  transText += aData.map{|f| "\"#{f}\"\n"}.join("")
  File.open("#{lproj}/Translation.strings", "w:UTF-16"){|f| f.write transText}
end

def fun2(lproj, fileName)
  translationData = []
  File.open("#{lproj}/#{fileName}.strings",  :mode => "rb", :encoding => "UTF-16LE") {|file|
    translationData = file.read.toutf8.scan(/"(.*)" *= *"(.*)";\n/).uniq
  }
  baseData = []
  File.open("#{lproj}/Translation.strings", :mode => "rb", :encoding => "UTF-16LE") {|f|
    baseData = f.read.toutf8.scan(/"(.*)"\s*=\s*"(.*)";?\s*\n/).inject({}){ |acc, item|
  acc[item[0]] = item[1]
      acc
    }
  }

  aData = translationData.map{|arr|
    if baseData.key? arr[1]
      arr[1] = baseData[arr[1]]
    end
    arr
  }
  transText = aData.map{|f| "\"#{f[0]}\" = \"#{f[1]}\";"}.join("\n")
  File.open("#{lproj}/#{fileName}.strings", "w:UTF-16"){|f| f.write transText}
end

lps.each {|lp|
  lproj = dirName + lp + ".lproj"
  FileUtils.mkdir_p(lproj) unless FileTest.exist?(lproj)
  storyboards.each { |fileName|
    puts fileName
    `ibtool --generate-stringsfile #{lproj}/#{fileName}.strings #{sourceDir}/#{fileName}.storyboard`
    fun(lproj, fileName)
    fun2(lproj, fileName)
    `ibtool --write #{lproj}/#{fileName}.storyboard -d #{lproj}/#{fileName}.strings  #{sourceDir}/#{fileName}.storyboard`
  }
}