#!/usr/bin/env ruby

# Get files list
files = Dir["data/*"]
icuFilename = "icudt55l.dat"
icuFunctionName = "ICU55"

# Remove existing files
puts "Deleting old files..."
Dir["src/*"].each { |path|
    continue if path == "CMakeLists.txt"
    File.delete(path)
}
Dir["include/*"].each { |path|
    File.delete(path)
}

files.each { |path|
    puts "Generating hexadecimal for '#{path}'..."
    filename = File.basename(path)
    tempOutputPath = "#{filename}.h.temporary"

    `cat #{path}/#{icuFilename} | xxd -i > #{tempOutputPath}`

    # Generate data header(s)
    index = 0
    dataHeaderName = ""
    dataHeaders = []
    puts "Generating headers..."

    # Open first data header for output
    headerFile = nil
    linesCount = 0
    File.open(tempOutputPath).each do |line|
        if linesCount >= 1300000 or headerFile.nil?
            # Open a new file
            index = index + 1
            dataHeaderName = "src/generated.#{filename}.data#{index}.h"
            headerFile = File.open(dataHeaderName, 'w');
            dataHeaders << "generated.#{filename}.data#{index}.h"
            linesCount = 0
        end

        headerFile.puts line
        linesCount = linesCount + 1
    end

    # Close file (if still open)
    headerFile = nil

    # Remove temporary file
    File.delete(tempOutputPath)

    # Generate main header
    puts "Generating source files..."
    headerName = "include/#{filename}.#{icuFilename}.h"
    header = File.open(headerName, 'w')

    header.puts %Q|
#ifndef _#{filename.upcase}_H_
#define _#{filename.upcase}_H_

#include <cstddef>

namespace youi_private {

const unsigned char *Get#{filename.capitalize}#{icuFunctionName}Data();
size_t Get#{filename.capitalize}#{icuFunctionName}Size();

}

#endif // _#{filename.upcase}_H_
    |.strip

    # Generate source header
    sourceName = "src/#{filename}.#{icuFilename}.cpp"
    source = File.open(sourceName, 'w')

    source.puts %Q|
#include "#{filename}.#{icuFilename}.h"

namespace youi_private {

alignas(16) unsigned char g_#{filename}_#{icuFunctionName}_data[] = {
    |.strip

    dataHeaders.each { |headerName|
        source.puts "#include \"#{headerName}\""
    }

    source.puts %Q|
};

const unsigned char *Get#{filename.capitalize}#{icuFunctionName}Data()
{
    return g_#{filename}_#{icuFunctionName}_data;
}

size_t Get#{filename.capitalize}#{icuFunctionName}Size()
{
    return sizeof(g_#{filename}_#{icuFunctionName}_data);
}

}
    |.strip

}

puts "Done."
