#!/usr/bin/env ruby

# This script runs the code formatted on all modified and untracked files.

require 'optparse'

options = {}
optparser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} --binaries PATH --data FILENAME [OPTIONS]"
    opts.separator ""
    opts.separator "This scripts extracts an ICU data file into its component files."
    opts.separator ""
    opts.separator "OPTIONS"

    opts.on('-h', '--help', "Prints this message.") { puts optparser.help(); exit 1 }
    opts.on('-b', '--binaries PATH', "The path to the ICU utilities. Can be the relevant .hunter directory. Required.") { |value| options[:binariesPath] = value }
    opts.on('-d', '--data FILENAME', "The path to the ICU data file to manipulate. Required.") { |value| options[:dataPath] = value }
    opts.on('--unpack', "Extracts the data file into the unpack/ folder. This is the default.") { options[:unpack] = true }
    opts.on('--repack', "Recombines the ICU data file from the files in the unpack/ folder.") { options[:repack] = true }
end
optparser.parse!

if options[:binariesPath].nil? || options[:dataPath].nil?
    puts optparser.help(); exit 1
end
if !options[:unpack].nil? && !options[:repack].nil?
    puts optparser.help(); exit 1
end
if options[:repack].nil?
    options[:unpack] = true
end

if (!options[:unpack].nil?)
    puts "Getting files list..."
    system(File.join(options[:binariesPath], 'icupkg'), "-l", "-o", "files.txt", options[:dataPath])
    Dir.mkdir("unpack")
    puts "Unpacking..."
    system(File.join(options[:binariesPath], 'icupkg'), "-x", "files.txt", options[:dataPath], "-d", "unpack")
else
    puts "Building packages list..."
    files = nil
    Dir.chdir("unpack") do
        files = Dir.glob("**/*").select { |f| File.file?(f) }
    end
    File.open("files.txt", "w") do |f|
        files.each { |element| f.puts(element) }
    end
    puts "Repacking..."
    system(File.join(options[:binariesPath], 'icupkg'), "-a", "files.txt", "-s", "unpack", "-w", "new", options[:dataPath])
end

puts "Done."
