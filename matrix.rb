#
#  Class that represents a Matrix and implements operations on matrices.
#
#  Author(s): Your Name(s)
#
class Matrix

  # create getter methods for instance variables @rows and @columns
  attr_reader  :rows, :columns

  # create setter methods for instance variables @rows and @columns
  attr_writer  :rows, :columns

  # make setter methods for @rows and @columns private
  private :rows=, :columns=

  # method that initializes a newly allocated Matrix object
  # use instance variable named @data (an array) to hold matrix elements
  # raise ArgumentError exception if any of the following is true:
  #     parameters rows or columns or val is not of type Fixnum
  #     value of rows or columns is <= 0
  def initialize(rows=5, columns=5, val=0)
    if !(val.class ==  Fixnum && columns.class == Fixnum && rows.class == Fixnum)
      raise ArgumentError
    end
    if(rows <= 0 || columns <= 0)
      raise ArgumentError
    end
    @data = Array.new(rows) { Array.new(columns, val) }
    @rows = rows
    @columns = columns
  end

  # method that returns matrix element at location (i,j)
  # NOTE: row and column values are zero-index based
  # raise ArgumentError exception if any of the following is true:
  #     parameters i or j is not of type Fixnum
  #     value of i or j is outside the bounds of Matrix
  def get(i, j)
    if !(i.class == Fixnum && j.class == Fixnum)
      raise ArgumentError
    end
    if i > @rows-1 || j > @columns-1 || i < 0 || j < 0
      raise ArgumentError
    end
    @data[i][j]
  end

  # method to set the value of matrix element at location (i,j) to value of parameter val
  # NOTE: row and column values are zero-index based
  # raise ArgumentError exception if any of the following is true:
  #     parameters i or j or val is not of type Fixnum
  #     the value of i or j is outside the bounds of Matrix
  def set(i, j, val)
    if !(i.class == Fixnum && j.class == Fixnum && val.class == Fixnum)
      raise ArgumentError
    end
    if i > @rows-1 || j > @columns-1 || i < 0 || j < 0
      raise ArgumentError
    end
    @data[i][j] = val
  end

  # method that returns a new matrix object that is the sum of this and parameter matrices.
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for addition operation
  def add(m)
    if m.class != self.class
      raise ArgumentError
    end
    returnVal = Matrix.new(@rows, @columns, 0)
    if m.rows != @rows  || m.columns != @columns
      raise IncompatibleMatricesError, "m1 rows and columns not same as m2 rows columns"
    end
    for i in 0..@rows-1
      for j in 0..@columns-1
        returnVal.set(i,j,@data[i][j] + m.get(i,j))
      end
    end
    returnVal
  end

  # method that returns a new matrix object that is the difference of this and parameter matrices
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for subtraction operation
  def subtract(m)
    if m.class != self.class
      raise ArgumentError
    end
    returnVal = Matrix.new(@rows, @columns, 0)
    if m.rows != @rows || m.columns != @columns
      raise IncompatibleMatricesError, "wronog number of rows/columns"
    end
    for i in 0..@rows-1
      for j in 0..@columns-1
        returnVal.set(i,j, @data[i][j] - m.get(i,j))
      end
    end
    returnVal
  end

  # method that returns a new matrix object that is a scalar multiple of source matrix object
  # raise ArgumentError exception if the parameter k is not of type Fixnum
  def scalarmult(k)
    if k.class != Fixnum
      raise ArgumentError
    end
    returnVal = Matrix.new(@rows, @columns, 0)
    for i in 0..@rows-1
      for j in 0..@columns-1
        returnVal.set(i,j, @data[i][j] * k)
      end
    end
    returnVal
  end

  # method that returns a new matrix object that is the product of this and parameter matrices
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for multiplication operation
  def multiply(m)
    if m.class != self.class
      raise ArgumentError
    end
    if @columns != m.rows
      raise IncompatibleMatricesError, "columns is of m1 not same as rows m2"
    end
    returnArray = Matrix.new(@rows, m.columns, 0)
    for i in 0..@rows-1
      for j in 0..m.columns-1
        temp = 0
        for z in 0..@columns-1
          temp += @data[i][z] * m.get(z,j)
        end
        returnArray.set(i,j,temp)
      end
    end
    returnArray
  end

  # method that returns a new matrix object that is the transpose of the source matrix
  def transpose
    returnArray = Matrix.new(@columns, @rows, 0)
    for i in 0..@rows-1
      for j in 0..@columns-1
        returnArray.set(j,i,@data[i][j])
      end
    end
    returnArray
  end

  # overload + for matrix addition
  def +(m)
    add(m)
  end

  # overload - for matrix subtraction
  def -(m)
    subtract(m)
  end

  # overload * for matrix multiplication
  def *(m)
    multiply(m)
  end

  # class method that returns an identity matrix with size number of rows and columns
  # raise ArgumentError exception if any of the following is true:
  #     parameter size is not of type Fixnum
  #     the value of size <= 0
  def Matrix.identity(size)
    if size.class != Fixnum || size <= 0
      raise ArgumentError
    end
    returnMatrix = Matrix.new(size,size,0)
    for i in 0..size-1
      returnMatrix.set(i,i,1)
    end
    returnMatrix
  end

  # method that sets every element in the matrix to value of parameter val
  # raise ArgumentError exception if val is not of type Fixnum
  # hint: use fill() method of Array to fill the matrix
  def fill(val)
    if val.class != Fixnum
      raise ArgumentError
    end
    for i in 0..@rows-1
      for j in 0..@columns-1
        @data[i][j] = val
      end
    end
  end

  # method that return a deep copy/clone of this matrix object
  def clone
    newVal = Matrix.new(@rows, @columns, 0)
    for i in 0..@rows-1
      for j in 0..@columns-1
        newVal.set(i,j,@data[i][j])
      end
    end
    newVal
  end

  # method that returns true if this matrix object and the parameter matrix object are equal
  # (i.e., have the same number of rows, columns, and corresponding values in the two
  # matrices are equal). Otherwise, it returns false.
  # returns false if the parameter m is not of type Matrix
  def ==(m)
    bool = true
    if m.class != Matrix || m.rows != @rows || m.columns != @columns
      return false
    end
    for i in 0..@rows-1
      for j in 0..@columns-1
        if @data[i][j] != m.get(i,j)
          bool = false
        end
      end
    end
    bool
  end

  # method that returns a string representation of matrix data in table (row x col) format
  def to_s
    string = ""
    for j in 0..@columns-1
      #print "#{j}\t"
    end
    for i in 0..@rows-1
      #print "\n#{i}\t"
      for j in 0..@columns-1
        string += "#{@data[i][j]}"
        if !(j+ 1 == @columns) #apparently it fails if you leave trailing spaces
          string += " "
        end
        #print "#{@data[i][j]} "
      end
      #print "\n"
      string += "\n"
    end
    string
  end

  # method that for each element in the matrix yields with information
  # on row, column, and data value at location (i,j)
  def each
    for i in 0..@rows-1
      for j in 0..@columns-1
        yield i, j, @data[i][j]
      end
    end
  end
end

#
# Custom exception class IncompatibleMatricesError
#
class IncompatibleMatricesError < Exception
  def initialize(msg)
    super msg
  end
end


#
#  main test driver
#
def main
  m1 = Matrix.new(3,4,10)
  m2 = Matrix.new(3,4,20)
  m3 = Matrix.new(4,5,30)
  m4 = Matrix.new(3,5,40)

  puts(m1)
  puts(m2)
  puts(m3)
  puts(m4)

  puts(m1.add(m2))

  puts(m1.subtract(m2))

  puts(m1.multiply(m3))

  puts(m2.scalarmult(5))

  puts(Matrix.identity(5))

  puts(m1 + m2)

  puts(m2 - m1)

  puts(m1 * m3)

  puts(m1 + m2 - m1)

  puts(m4 + m2 * m3)

  puts(m1.clone())

  puts(m1.transpose())

  puts("Are matrices equal? #{m1 == m2}")

  puts("Are matrices equal? #{m1 == m3}")

  puts("Are matrices equal? #{m1 == m1}")

  m1.each { |i, j, val|
    puts("(#{i},#{j},#{val})")
  }

  begin
    m1.get(4,4)
  rescue ArgumentError => exp
    puts("#{exp.message} - get failed\n")
  end

  begin
    m1.set(4,5,10)
  rescue ArgumentError => exp
    puts("#{exp.message} - set failed\n")
  end

  begin
    m1.add(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2.subtract(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1.multiply(m2)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end

  begin
    m1 + m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2 - m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1 * m2
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end
end

# uncomment the following line to run the main() method
# main()
