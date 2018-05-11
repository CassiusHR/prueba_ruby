$notas = Array.new


def main_menu
  puts "Seleccione una opcion:"
  puts "1- Exportar promedio de notas"
  puts "2- Inasistencias totales"
  puts "3- Mostrar alumnos aprobados (definir nota)"
  puts "4- Salir"
end

def parse(name, nota1, nota2, nota3, nota4, nota5)
  alumni_grades = Hash.new
  alumni_grades[name] = [nota1, nota2, nota3, nota4, nota5]
  alumni_grades
end

def getfile_data
  file = File.open("notas.csv", "r")
  grades = file.readlines.map(&:chomp)
  file.close
  data = Array.new
  grades.map do |i|
    data << parse(*i.split(", "))
  end
  data
end
$notas = getfile_data

def total_grades_average
  values = Array.new
  grades = Array.new
  $notas.each do |i|
    values << i.values.flatten
  end
  values.each do |p|
    p.each do |i|
      grades << i.to_i if i.to_i
    end
  end
  grades.inject(0){|sum, x| sum += x } /grades.size.to_f
end


def grades_average
  keys = Array.new
  values = Array.new
  means = Array.new
  $notas.each do |i|
    keys << i.keys
    values << i.values.flatten
  end
  values.each do |p|
    p.each_with_index do |e, index|
      if e == "A"
        p[index.to_i] = "0"
      end
    end
    means << p.inject(0){|sum, x| sum += x.to_i } /p.size.to_f
  end
  user_means = keys.flatten.zip means
  user_means
end

def check_passing_grade(grade)
  grades = grades_average
  grades.each do |i|
    if i[1].to_i >= grade.to_i
      puts i[0] + " aprobado"
    end
  end
end

def skip_record
    values = Array.new
    skips = Array.new
    $notas.each do |i|
      values << i.values.flatten
    end
    values.each do |p|
      p.each do |i|
        skips << i.to_s if i == "A"
      end
    end
    skips.count
end

option= 0

while option != 4
  puts "#{main_menu}"
  print "Ingresar opcion:"
  option = gets.chomp.to_i

  case option
    when 1
      File.open("promedio.csv", "w") {|f| f.write("#{grades_average}") }
      puts ""
      puts "Promedio exportado"
      puts ""
    when 2
      puts ""
      puts "#{skip_record} Inasistencias totales"
      puts ""
    when 3
      passing_grade = 5
      puts "ingrese nota de aprobación"
      passing_grade = gets.chomp.to_i
      check_passing_grade(passing_grade)
      puts "Seleccione nota valida" if passing_grade > 10 || passing_grade < 1
  end
  puts "Seleccione opcion valida" if option > 6 || option < 1
end
