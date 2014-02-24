require './lib/IbtoolTranslation'
require 'fileutils'

$debug = true

describe IbtoolTranslation::Core, "load" do
	baseDataArray = ["B", "hoge\\npiyo\\nfuga", "to D", "numberOfLines : 2", "D", "NumberOfLines", "Root View Controller", "C", "numberOfLines : 1", "Beyond Segue", "numberOfLines : 0"]
	baseDataText = '"B";
"hoge\npiyo\nfuga";
"to D";
"numberOfLines : 2";
"D";
"NumberOfLines";
"Root View Controller";
"C";
"numberOfLines : 1";
"Beyond Segue";
"numberOfLines : 0";
'
	context "reset and update ja" do 
		before do
			@i = IbtoolTranslation::Core.new
			@i.deleteDir "./storyboards/ja.lproj/"
			@i.update("./storyboards/", "en", ["ja"], false)
		end
		it "ja transText is " do
			@i.transText("./storyboards/ja.lproj/Translation.strings").should == baseDataText
		end
		it "Main.strings don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.strings").should == false
		end
		it "storyboard same" do
			@i.transText("./storyboards/en.lproj/Main.storyboard").should == @i.transText("./storyboards/ja.lproj/Main.storyboard")
		end
	end
	context "update dd" do 
		before do
			@i = IbtoolTranslation::Core.new
			@i.update("./storyboards/", "en", ["dd"], false)
		end
		it "Main.strings don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.strings").should == false
		end
		it "storyboard not same" do
			@i.transText("./storyboards/en.lproj/Main.storyboard").should_not == @i.transText("./storyboards/dd.lproj/Main.storyboard")
		end
	end
	context "create" do
		before do
			@i = IbtoolTranslation::Core.new
			@i.deleteDir "./storyboards/ja.lproj/"
			@i.create("./storyboards/", "en", ["ja"], false)
		end
		it "ja transText is " do
			@i.transText("./storyboards/ja.lproj/Translation.strings").should == baseDataText
		end
		it "Main.strings don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.strings").should == false
		end
		it "Main.storyboard don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.storyboard").should == false
		end
	end
	it "storyboards" do
		IbtoolTranslation::Core.new.storyboards("./storyboards/en.lproj/").should == ["Main"]
	end
	it "addtionData" do
		IbtoolTranslation::Core.new.addtionData("./storyboards/en.lproj/Main.strings").should == baseDataArray
	end
	it "non transText is empty" do
		IbtoolTranslation::Core.new.transText("./storyboards/en.lproj/Translation.strings").should == ""
	end
	it "ja transText is " do
		IbtoolTranslation::Core.new.transText("./storyboards/ja.lproj/Translation.strings").should == baseDataText
	end
	it "baseDataForTransText" do
		IbtoolTranslation::Core.new.baseDataForTransText(baseDataText).should == baseDataArray
	end
	it "translationData" do
		IbtoolTranslation::Core.new.translationData("./storyboards/fr.lproj/Translation.strings").should == [["B", "β"], ["C", "γ"]]
	end
	it "translationDict" do
		i = IbtoolTranslation::Core.new
		t = i.transText("./storyboards/fr.lproj/Translation.strings")
		i.translationDict(t).should == {"B" => "β", "C" => "γ"}
	end
	it "translate" do
		IbtoolTranslation::Core.new.translate([["x", "A"], ["y", "B"]], {"B" => "β", "C" => "γ"}).should == [["x", "A"], ["y", "β"]]
	end
end