# Program Assignment: Asignacion 2
# Name: José Alfredo Gallegos Chavarría
# Enrollment number: 1383375
# Date: 22/10/2015
# Description: LOC counter for ruby programs according to previously submitted coding and counting standards
# After receiving and parsing ruby source as a parameter, the program computes and outputs:
# - total LOC in program
# - total LOC per part in program
# - total items per part, and LOC per each item per part in program
# - and total LOC per type in program
#
# How to call the program: from your preferred shell, invoke:
#       asignacion_2.rb testfile1.rb testfile2.rb testfile3.rb [...]

################################################################
# The following program section rejects running the program unless
# the user satisfies the requirements to point it to same-directory
# ruby source files. It also displays an explanatory message in that case,
# and also in the case that the user is looking for help with the program
################################################################
if ARGV.length == 0 || ARGV[0] == "-h" || ARGV[0] == "--help"                                                                              #Code type A
  puts "Program Assignment: Asignacion 2"                                                                                                  #Code type A
  puts "Name: José Alfredo Gallegos Chavarría"                                                                                             #Code type A
  puts "Enrollment number: 1383375"                                                                                                        #Code type A
  puts "Date: 22/10/2015"                                                                                                                  #Code type A
  puts "Description: LOC counter for ruby programs according to previously submitted coding and counting standards"                        #Code type A
  puts "After receiving and parsing ruby source as a parameter, the program computes and outputs:"                                         #Code type A
  puts "- total LOC in program"                                                                                                            #Code type A
  puts "- total LOC per part in program"                                                                                                   #Code type A
  puts "- total LOC per each item per part in program"                                                                                     #Code type A
  puts "- and total LOC per type in program (globally)"                                                                                    #Code type A
  puts "Usage: from your preferred shell, invoke the program with the file names of"                                                       #Code type A
  puts "programs you wish to measure as arguments"                                                                                         #Code type A
  puts "  asignacion_2.rb testfile1.rb testfile2.rb testfile3.rb [...]"                                                                    #Code type A
  puts "Then, see the magic happen"                                                                                                        #Code type A
  exit                                                                                                                                     #Code type A
end                                                                                                                                        #Code type A

###################################################################
# The following program section defines a class that we can instantiate to use for the assignment
# which encapsulates regex-based checks to count lines of code in the current program
###################################################################
class LineCounter                                                                                                                          #Code type A

  attr_accessor :index, :b_lines, :a_lines, :m_lines, :d_lines, :r_lines, :lines                                                           #Code type A

  def line_is_void?(line)                                                                                                                  #Code type A
    ( line.match(/^\s*\#.*/) || line.match(/^\s*\n/) ) ? true : false                                                                      #Code type A
  end                                                                                                                                      #Code type A

  # initialize the proper instance variables for LOC counts
  def initialize(i)                                                                                                                        #Code type A
    @index = i                                                                                                                             #Code type A

    @b_lines = 0 #Base lines                                                                                                               #Code type A
    @a_lines = 0 #Added lines                                                                                                              #Code type A
    @r_lines = 0 #Reused lines                                                                                                             #Code type A
    @m_lines = 0 #Modified lines                                                                                                           #Code type A
    @d_lines = 0 #Deleted lines                                                                                                            #Code type A

    @lines = 0 #Global Count                                                                                                               #Code type A

    #a bi-dimensional hash to store all the part stats into
    @data = Hash.new { |item, part| item[part] = Hash.new { |size, item| size[item] = 0 } }                                                #Code type A

    @current_part = nil                                                                                                                    #Code type A
    @current_item = nil                                                                                                                    #Code type A
  end                                                                                                                                      #Code type A

  def report_lines(filename)                                                                                                               #Code type A

    #compute size per part
    sums = @data.map do |part, item|                                                                                                       #Code type A
      item.values.reduce(&:+)                                                                                                              #Code type A
    end                                                                                                                                    #Code type A

    # BEGIN REPORT
    puts "-----------------------------------"                                                                                             #Code type A
    puts "Program #{@index + 1}: #{filename}"                                                                                              #Code type A

    #marry parts to computed sizes in a hash
    sizes = Hash[@data.keys.zip sums]                                                                                                      #Code type A

    sizes.each do |part, part_size|                                                                                                        #Code type A
      puts "-----------------------------------"                                                                                           #Code type A
      puts "Part: #{part}"                                                                                                                 #Code type A

      @data[part].each do |item, size|                                                                                                     #Code type A
        puts "  Item:\t#{item}\tSize:\t#{size}\n"                                                                                          #Code type A
      end                                                                                                                                  #Code type A

      puts "\nTotal Items:\t#{@data[part].keys.length}"                                                                                    #Code type A
      puts "Size of part:\t#{part_size}"                                                                                                   #Code type A
    end                                                                                                                                    #Code type A

    #and report all the lines per type in the file
    puts "-----------------------------------"                                                                                             #Code type A
    puts "Global program stats: \n\n"                                                                                                      #Code type A
    puts "Base lines:\t#{@b_lines}"                                                                                                        #Code type A
    puts "Added lines:\t#{@a_lines}"                                                                                                       #Code type A
    puts "Reused lines:\t#{@r_lines}"                                                                                                      #Code type A
    puts "Modified lines:\t#{@m_lines}"                                                                                                    #Code type A
    puts "Deleted lines:\t#{@d_lines}"                                                                                                     #Code type A
    puts "-----------------------------------"                                                                                             #Code type A
    puts "Total LOC (counting standard):\t\t#{@lines}"                                                                                     #Code type A
    #and also displaying total lines according to the PSP standard
    #see the course materials for more details
    #T = B + A + R - D
    puts "Total LOC (PSP: T = B + A + R - D):\t#{@b_lines + @a_lines + r_lines - @d_lines}"                                                #Code type A
    puts "-----------------------------------"                                                                                             #Code type A
  end                                                                                                                                      #Code type A

  def read_file(file)                                                                                                                      #Code type A
    file.each do |line| # reading the source file line by line                                                                             #Code type A
      # global count
      @lines += 1 unless line_is_void?(line) # line is counted if not a comment or whitespace                                              #Code type A

      # count line types
      @b_lines += 1 if line.match(/\# *Code Type B$/i)                                                                                     #Code type A
      @a_lines += 1 if line.match(/\# *Code Type A$/i)                                                                                     #Code type A
      @m_lines += 1 if line.match(/\# *Code Type M$/i)                                                                                     #Code type A
      @r_lines += 1 if line.match(/\# *Code Type R$/i)                                                                                     #Code type A
      @d_lines += 1 if line.match(/\# *Code Type D$/i)                                                                                     #Code type A

      # PARTS
      # classes are considered "parts" of the program for our purposes
      # in ruby, classes and are defined with keyword "class
      # followed by any determined amount of alphanumeric characters, or -, or _
      if line.match(/^.*(class) (([A-Z]|[0-9]|[_-])+).*/i) ################### is part                                                     #Code type A
        @current_part = $2                                                                                                                 #Code type A
      end                                                                                                                                  #Code type A

      # ITEMS
      # methods are items of the program for our purposes and elements of a Part
      # in ruby, methods/functions are defined with keyword "def
      # followed by any determined amount of alphanumeric characters, or _, then several arguments
      # defined between *optional* parentheses
      if line.match(/.*(def) (([A-Z]|[0-9]|[_])+)\(?.*\)?/i) ######################## is item                                              #Code type A
        @current_item = $2                                                                                                                 #Code type A
      end                                                                                                                                  #Code type A

      if @current_item != nil # if there's an item, continue counting its size                                                             #Code type A
        @data[@current_part][@current_item] += 1 unless line_is_void?(line) # line is counted if not a comment or whitespace               #Code type A

        if line.match(/^  end.*/i) #if we've reached the end of the method:                                                                #Code type A
          @current_item = nil                                                                                                              #Code type A
        end                                                                                                                                #Code type A
      end                                                                                                                                  #Code type A
    end                                                                                                                                    #Code type A
  end                                                                                                                                      #Code type A
end                                                                                                                                        #Code type A

###################################################################
# The following item establishes a main() method and executes it
# to effectively start running the program
###################################################################

ARGV.each_with_index do |filename, i|                                                                                                      #Code type A
  File.open(filename, "r+") do |f| #load the source file into memory                                                                       #Code type A
    counter = LineCounter.new(i) #make the LineCounter object aware of the file of the program we'll count and its ordinality              #Code type A
    counter.read_file(f) #get the counts                                                                                                   #Code type A
    counter.report_lines(filename) #then output a report                                                                                   #Code type A
  end                                                                                                                                      #Code type A
end                                                                                                                                        #Code type A