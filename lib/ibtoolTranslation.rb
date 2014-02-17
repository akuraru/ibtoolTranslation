require "ibtoolTranslation/version"
require 'kconv'
require 'fileutils'

module IbtoolTranslation
  class Core
  	def create(dirName, sourceDir, lps)
			self.func(dirName, dirName + sourceDir + ".lproj", lps)
		end
		def update(dirName, sourceDir, lps)
			self.func(dirName, dirName + sourceDir + ".lproj", lps)
			self.func2(dirName, dirName + sourceDir + ".lproj", lps)
		end
  	def func(dirName, sourceDir, lps)
			storyboards = self.storyboards sourceDir

			lps.each {|lp|
			  lproj = dirName + lp + ".lproj"
			  FileUtils.mkdir_p(lproj) unless FileTest.exist?(lproj)
		  	
		  	transText = self.transText("#{lproj}/Translation.strings")
		  	baseData = self.baseDataForTransText(transText)
			  storyboards.each { |fileName|
			    `ibtool --generate-stringsfile #{lproj}/#{fileName}.strings #{sourceDir}/#{fileName}.storyboard`
				  addtionData = self.addtionData("#{lproj}/#{fileName}.strings")
				  aData = addtionData.select{|f| baseData.include?(f) == false}
				  transText = transText + aData.map{|f| "\"#{f}\";\n"}.join("")
			    File::delete("#{lproj}/#{fileName}.strings")
			  }
			  self.writeTransText("#{lproj}/Translation.strings", transText)
			}
		end
  	def func2(dirName, sourceDir, lps)
			storyboards = self.storyboards sourceDir

			lps.each {|lp|
			  lproj = dirName + lp + ".lproj"
		  	transText = self.transText("#{lproj}/Translation.strings")		  	
			  storyboards.each { |fileName|
			    self.fun2(lproj, fileName, transText)
			    `ibtool --write #{lproj}/#{fileName}.storyboard -d #{lproj}/#{fileName}.strings  #{sourceDir}/#{fileName}.storyboard`
			    File::delete("#{lproj}/#{fileName}.strings")
			    puts fileName
			  }
			}
		end

		def fun2(lproj, fileName, transText)
		  translationData = self.translationData("#{lproj}/#{fileName}.strings")
		  translationDict = self.translationDict(transText)

		  aData = translate(translationData, translationDict)
		  transText = aData.map{|f| "\"#{f[0]}\" = \"#{f[1]}\";\n"}.join("")
		  File.open("#{lproj}/#{fileName}.strings", "w:UTF-16"){|f| f.write transText}
		end
		def translate(translationData, translationDict)
			translationData.map{|arr|
		    (translationDict.key? arr[1]) ? [arr[0], translationDict[arr[1]]] : arr
		  }
		end
		def translationDict(transText)
		  Hash[*(transText.scan(/"(.*)"\s*=\s*"(.*)";?\s*\n/).flatten)]
		end
		def translationData(fileName)
		  self.readFile(fileName).scan(/"(.*)" *= *"(.*)";\n/).uniq
		end
		def writeTransText(fileName, transText)
			File.open(fileName, "w:UTF-16"){|f| f.write transText}
		end
		def baseDataForTransText(transText)
      (transText.scan(/"(.*)"\s*=\s*".*";?\s*\n/) + transText.scan(/"(.*)";?\s*\n/)).flatten
		end
		def transText(fileName)
			self.readFile(fileName)
		end
		def addtionData(fileName)
		  self.readFile(fileName).scan(/".*" *= *"(.*)";\n/).uniq.flatten
		end
		def storyboards(sourceDir)
			Dir.open(sourceDir).map {|f|
				f.gsub(/(.*)\.storyboard/, '\1').gsub(/\w*\.\w*/, "")
			}.select {|f| f != "" }
		end
		def readFile(fileName)
			FileTest.exist?(fileName) ? File.read(fileName,  :mode => "rb", :encoding => "UTF-16LE").toutf8 : ""
		end
		def deleteDir(dir)
			Dir::glob(dir + "**/").sort {
			  |a,b| b.split('/').size <=> a.split('/').size
			}.each {|d|
			  Dir::foreach(d) {|f|
			    File::delete(d+f) if ! (/\.+$/ =~ f)
			  }
			  Dir::rmdir(d)
			}
		end
  end
end
