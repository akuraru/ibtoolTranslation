require "ibtoolTranslation/version"
require 'kconv'
require 'fileutils'

$debug = false
$/

module IbtoolTranslation
  class Core
    def create(dirName, sourceDir, lps, string)
      lprojs = lps.map {|lp| dirName + lp + ".lproj"}
      sourceLproj = dirName + sourceDir + ".lproj"
      storyboards = self.storyboards sourceLproj

      if (string)
        self.deleteStringsFile(sourceLproj, lprojs)
      end
      self.makeDirectory(lprojs)
      self.createTranslation(sourceLproj, lprojs, storyboards)
      unless (string)
        self.deleteStringsFile(sourceLproj, lprojs)
      end
    end
    def update(dirName, sourceDir, lps, string)
      lprojs = lps.map {|lp| dirName + lp + ".lproj"}
      sourceLproj = dirName + sourceDir + ".lproj"
      storyboards = self.storyboards sourceLproj

      if (string)
        self.deleteStringsFile(sourceLproj, lprojs)
      end
      self.makeDirectory(lprojs)
      self.createTranslation(sourceLproj, lprojs, storyboards)
      self.translateStrings(sourceLproj, lprojs, storyboards)
      unless (string)
        self.translateStoryboards(sourceLproj, lprojs, storyboards)
        self.deleteStringsFile(sourceLproj, lprojs)
      end
    end
    def makeDirectory(lprojs) 
      lprojs.each {|lproj| FileUtils.mkdir_p(lproj) }
    end
    def createTranslation(sourceDir, lprojs, storyboards)
      lprojs.each {|lproj|
        transText = self.transText("#{lproj}/Translation.strings")
        baseData = self.baseDataForTransText(transText)
        storyboards.each { |fileName|
          `ibtool --generate-stringsfile #{lproj}/#{fileName}.strings #{sourceDir}/#{fileName}.storyboard`
          addtionData = self.addtionData("#{lproj}/#{fileName}.strings")
          aData = addtionData.select{|f| baseData.include?(f) == false}
          transText = transText + aData.map{|f| "\"#{f}\";\n"}.join("")
        }
        self.writeTransText("#{lproj}/Translation.strings", transText)
      }
    end
    def translateStrings(sourceDir, lprojs, storyboards)
      lprojs.each {|lproj|
        transText = self.transText("#{lproj}/Translation.strings")        
        storyboards.each { |fileName|
          self.translateStringsFile(lproj, fileName, transText)
          puts fileName unless $debug
        }
      }
    end
    def translateStoryboards(sourceDir, lprojs, storyboards)
      lprojs.each {|lproj|      
        storyboards.each { |fileName|
          `ibtool --write #{lproj}/#{fileName}.storyboard -d #{lproj}/#{fileName}.strings  #{sourceDir}/#{fileName}.storyboard`
        }
      }
    end
    def deleteStringsFile(sourceDir, lprojs)
      storyboards = self.storyboards sourceDir

      lprojs.each {|lproj|
        storyboards.each { |fileName|
          filePath = "#{lproj}/#{fileName}.strings"
          File::delete(filePath) if FileTest.exist?(filePath)
        }
      }
    end

    def translateStringsFile(lproj, fileName, transText)
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
