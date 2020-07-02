class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id
  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        ) 
      SQL
      DB[:conn].execute(sql)
  end

  def save

    sql = <<-SQL 
    INSERT INTO students (name, grade)VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    get_student_id_array = <<-SQL
      SELECT students.id 
      FROM students 
      WHERE students.name = ? 
      AND students.grade = ?
      SQL
      # run execute with the result of sql and the input with correleating info
      # this will update the currents object to the result  fo the below
    @id = DB[:conn].execute(get_student_id_array,self.name, self.grade)[0][0]
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(hash)
    new_student = Student.new(hash[:name], hash[:grade])
    new_student.save
    new_student
  end
  
end
