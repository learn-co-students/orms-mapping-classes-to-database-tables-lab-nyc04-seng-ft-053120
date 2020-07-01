class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Only attr_reader for :id. The only place id can be set equal to something is inside the initialize method, via: @id = id
  
  def initialize(name, grade, id = nil)
    # when we create a new Student instance, we will not assign them an id (it is the responsibility of the database)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    # class method that creates the students table
    # write out the sql query and save it in a var (sql)
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL

    # call connection to db, use .execute to execute the query
    DB[:conn].execute(sql)
  end

  def self.drop_table
    # this will drop the students table
    # write out the sql query to drop table and save it in a var (sql)
    sql = "DROP TABLE IF EXISTS students"

    # call connection to db, use .execute to execute the query
    DB[:conn].execute(sql)
  end

  def save
    # instance method that saves the attributes describing a student to the students table in our db (it doesn't actually save the student instance object)

    # create a var called sql, write out the query

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    # call connection to the database, use .execute to execute the query
    DB[:conn].execute(sql, self.name, self.grade)

    # grab the value of the ID column of the last inserted row, set that equal to the given student instance's id attribute
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    # class method that uses keyword arguments name: and grade:

    # instantiate a new student
    student = Student.new(name, grade)
    # saves the student to the db table students
    student.save
    # return the student instance
    student
  end
  
end
