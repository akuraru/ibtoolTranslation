require './lib/IbtoolTranslation'
require 'fileutils'

$debug = true

describe IbtoolTranslation::Core, "load" do
	before do
		@i = IbtoolTranslation::Core.new
	  @baseDataArray = ["B", "hoge\\npiyo\\nfuga", "to D", "numberOfLines : 2", "D", "NumberOfLines", "Root View Controller", "C", "numberOfLines : 1", "Beyond Segue", "numberOfLines : 0"]
	  @baseDataText = '"B";
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
	end
	it "storyboards" do
		@i.storyboards("./storyboards/en.lproj/").should == ["Main"]
	end
	it "addtionData" do
		@i.addtionData("./storyboards/en.lproj/Main.strings").should == @baseDataArray
	end
	it "non transText is empty" do
		@i.transText("./storyboards/en.lproj/Translation.strings").should == ""
	end
	it "baseDataForTransText" do
		@i.baseDataForTransText(@baseDataText).should == @baseDataArray
	end
	it "translationData" do
		@i.translationData("./storyboards/fr.lproj/Translation.strings").should == [["B", "β"], ["C", "γ"]]
	end
	it "translationDict" do
		t = @i.transText("./storyboards/fr.lproj/Translation.strings")
		@i.translationDict(t).should == {"B" => "β", "C" => "γ"}
	end
	it "translate" do
		@i.translate([["x", "A"], ["y", "B"]], {"B" => "β", "C" => "γ"}).should == [["x", "A"], ["y", "β"]]
	end
	context "create" do
		before do
			@i.create("./storyboards/", "en", ["ja"], false)
		end
		after do
			@i.deleteDir "./storyboards/ja.lproj/"
		end
		it "ja transText is " do
			@i.transText("./storyboards/ja.lproj/Translation.strings").should == @baseDataText
		end
		it "Main.strings don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.strings").should == false
		end
		it "Main.storyboard don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.storyboard").should == false
		end
	end
	context "reset and update ja" do 
		before do
			@i.update("./storyboards/", "en", ["ja"], false)
		end
		after do
			@i.deleteDir "./storyboards/ja.lproj/"
		end
		it "ja transText is " do
			@i.transText("./storyboards/ja.lproj/Translation.strings").should == @baseDataText
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
			@i.update("./storyboards/", "en", ["dd"], false)
		end
		after do
			filePath = "./storyboards/dd.lproj/Main.storyboard"
			File::delete(filePath) if FileTest.exist?(filePath)
			filePath = "./storyboards/dd.lproj/Main.String"
			File::delete(filePath) if FileTest.exist?(filePath)
		end
		it "Main.strings don't exist" do
			FileTest.exist?("./storyboards/ja.lproj/Main.strings").should == false
		end
		it "storyboard not same" do
			expect(@i.transText("./storyboards/en.lproj/Main.storyboard")).not_to eq @i.transText("./storyboards/dd.lproj/Main.storyboard")
		end
	end
	describe "update en ja -s" do
		before do
			@i.update("./storyboards/", "en", ["ja"], true)
		end
		after do
			@i.deleteDir "./storyboards/ja.lproj/"
		end
		it "ja transText is " do
			expect(@i.transText("./storyboards/ja.lproj/Translation.strings")).to eq @baseDataText
		end
		it "Main.strings" do
		  expect(@i.addtionData("./storyboards/ja.lproj/Main.strings")).to eq @baseDataArray
		end
		it "storyboard do not exist" do
			expect(FileTest.exist?("./storyboards/ja.lproj/Main.storyboard")).to eq false
		end
	end
	describe "update en dd -s" do
		before do
			@i.update("./storyboards/", "en", ["dd"], true)
		end
		after do
			filePath = "./storyboards/dd.lproj/Main.storyboard"
			File::delete(filePath) if FileTest.exist?(filePath)
			filePath = "./storyboards/dd.lproj/Main.String"
			File::delete(filePath) if FileTest.exist?(filePath)
		end
		it "ja transText is " do
			expect(@i.transText("./storyboards/dd.lproj/Translation.strings")).not_to eq @baseDataText
		end
		it "Main.strings" do
		  expect(@i.addtionData("./storyboards/dd.lproj/Main.strings")).not_to eq @baseDataArray
		end
		it "storyboard do not exist" do
			expect(FileTest.exist?("./storyboards/dd.lproj/Main.storyboard")).to eq false
		end
	end
end
