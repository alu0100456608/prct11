require "./lib/practica9/version"

module Practica9
  #Clase Matriz: Clase Madre, de la que heredarán las clases MatrizDensa y MatrizDispersa
   class Matriz
     #Métodos de acceso para los elementos de las matrices
      attr_accessor :filas, :columnas, :elementos
      def initialize (filas, columnas, elementos)
         @filas = filas
         @columnas = columnas
         @elementos = elementos
      end
      #Método at: Devuelve el valor de la posición (i,j) de la matriz.
      def at(i, j) end
      #Método to_s: Devuelve la representación en forma de cadena de la matriz.     
      def to_s
         tmp = ""
         @filas.times do |i|
            @columnas.times do |j|
               tmp << "#{at(i, j)} "
            end
            tmp << "\n"
         end
         tmp
      end
      
      #Sobrecarga del operador == para operar entre matrices
      def == (other)
         @filas.times do |i|
            @columnas.times do |j|
               if at(i, j) != other.at(i,j)
                  return false
               end
            end
         end
         
         return true
      end
   
   end
   #Clase MatrizDensa. Esta será una matriz típica, la mayoría de sus elementos seran no nulos
   class MatrizDensa < Matriz
      #El método initialize, llamado por el constructor, hace referencia al constructor de su superclase
      #El atributo elementos se refiere a un Array de Arrays.
     def initialize (filas, columnas, elementos)
         super(filas, columnas, elementos)
      end
      #Operador de indexación (para acceso)
      def [](i)
         @elementos[i]
      end
      #Definición del método at,inicialmente abstracto, para matrices densas
      def at(i,j)
          @elementos[i][j]
      end
      #Método que traspone las filas y columnas de una matriz
      def traspuesta
         new_mat = Array.new
         @columnas.times do |i|
            fila = Array.new
            @filas.times do |j|
               fila << @elementos[j][i]
            end
            new_mat << fila
         end
         MatrizDensa.new(@columnas, @filas, new_mat)
      end
      #Sobrecarga del operador + para operar con matrices, sean densas o dispersas
      # (si son dispersas, se tratarán como densas)
      def +(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @filas == other.filas && @columnas == other.columnas
         new_mat = Array.new
         @filas.times do |i|
            fila = Array.new
            @columnas.times do |j|
               fila << @elementos[i][j] + other.at(i, j)
            end
            new_mat << fila
         end
         MatrizDensa.new(@filas, @columnas,new_mat)
      end

      #Sobrecarga del operador - para operar con matrices, sean densas o dispersas
      # (si son dispersas, se tratarán como densas)
      def -(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @filas == other.filas && @columnas == other.columnas
         new_mat = Array.new
         @filas.times do |i|
            fila = Array.new
            @columnas.times do |j|
               fila << @elementos[i][j] - other.at(i, j)
            end
            new_mat << fila
         end
         MatrizDensa.new(@filas, @columnas,new_mat)
      end

      #Sobrecarga del operador * para operar con matrices, sean densas o dispersas
      # (si son dispersas, se tratarán como densas)
      def *(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @columnas == other.filas
         new_mat = Array.new
         @filas.times do |i|
            fila = Array.new
            other.columnas.times do |j|
               sum = 0
               @columnas.times do |k|
                  sum = at(i, k) * other.at(k,j) + sum
               end
               fila << sum
            end
            new_mat << fila
         end
         MatrizDensa.new(@filas, other.columnas, new_mat)
      end
      #Método maximo: Devuelve el mayor valor dentro de las posiciones de la matriz.
      def maximo
         mayor = @elementos[0][0]
         @filas.times do |i|
            @columnas.times do |j|
               mayor = @elementos[i][j] if @elementos[i][j] > mayor
            end
         end
         mayor
      end
      
      #Método minimo: Devuelve el menor valor dentro de las posiciones de la matriz.
      def minimo
         menor = @elementos[0][0]
         @filas.times do |i|
            @columnas.times do |j|
               menor = @elementos[i][j] if @elementos[i][j] < menor
            end
         end
         menor
      end
      
   end
  #Clase MatrizDispersa: Matrices en las que la mayoría de los elementos son nulos
   class MatrizDispersa < Matriz
      #El método initialize recibirá en este caso un hash de hashes "elementos"
      def initialize (filas, columnas, elementos)
         super(filas, columnas, elementos)
      end

      def [](i)
         @elementos[i]
      end
      #Método at, devuelve el valor de la posición (i,j), o 0 si este no se contempla (nil en el hash)
      def at(i,j)
         #Extrae el valor del elemento i, si no existe obtiene un 0
         tmp = @elementos.fetch(i,0)
         if tmp != 0    #Si el valor obtenido no es 0, se extrae el valor del elemento j, si no existe obtiene un 0
            tmp.fetch(j,0)
         else
            0
         end
      end
      #Método que traspone las filas y columnas de una matriz 
      def traspuesta
         new_mat = Hash.new(Hash.new())
         @elementos.each do |clave, valor|
            valor.each do |clave2, valor2|
               new_mat.merge!({clave2 => {clave => valor2}}) do |clave3, oldval, newval|
                  oldval.merge!(newval)
               end
            end
         end
         MatrizDispersa.new(@columnas, @filas, new_mat)
      end
      #Sobrecarga del operador + para operar con matrices, sean densas o dispersas
      #(Entre 2 matrices dispersas, el resultado será una matriz dispersa, en otro caso, densa)
      def +(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @filas == other.filas && @columnas == other.columnas
         if other.class == MatrizDensa
            other.+(self)
         elsif other.class == MatrizDispersa
            new_mat = @elementos.merge(other.elementos) do |clave, oldval, newval| 
               oldval.merge(newval) do |clave2, oldval2, newval2|
                  oldval2 = 0 if oldval2 == nil
                  newval2 = 0 if newval2 == nil
                  oldval2 + newval2
               end
            end
            MatrizDispersa.new(@filas, @columnas, new_mat)
         else
            raise TypeError.new("No se puede coaccionar #{other.inspect} a Matriz")
         end
      end
      #Sobrecarga del operador * para operar con matrices, sean densas o dispersas
      #(Entre 2 matrices dispersas, el resultado será una matriz dispersa, en otro caso, densa)
      def -(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @filas == other.filas && @columnas == other.columnas
         if other.class == MatrizDensa
            new_mat = Array.new
            @filas.times do |i|
               fila = Array.new
               @columnas.times do |j|
                  fila << at(i, j) - other.elementos[i][j]
               end
               new_mat << fila
            end
            MatrizDensa.new(@filas, @columnas, new_mat)
         elsif other.class == MatrizDispersa
            other.elementos.each do |i, val|
               val.each do |j, val2|
                  other.elementos[i][j] = -val2
               end
            end
            other.+(self)
         else
            raise TypeError.new("No se puede coaccionar #{other.inspect} a Matriz")
         end
      end
      
      #Sobrecarga del operador * para operar con matrices, sean densas o dispersas
      #(Entre 2 matrices dispersas, el resultado será una matriz dispersa, en otro caso, densa)
      def *(other)
         raise ArgumentError, "Las dimensiones de las matrices no coinciden" unless @columnas == other.filas
         if other.class == MatrizDensa
            new_mat = Array.new
            @filas.times do |i|
               fila = Array.new
               other.columnas.times do |j|
                  sum = 0
                  @columnas.times do |k|
                     sum = at(i,k) * other.elementos[k][j] + sum
                  end
                  fila << sum
               end
               new_mat << fila
            end
            MatrizDensa.new(@filas, other.columnas, new_mat)
         elsif other.class == MatrizDispersa
            other = other.traspuesta
            new_mat = Hash.new(Hash.new())
            @elementos.each do |key, value|
               other.elementos.each do |key1, value1|
                  suma = 0
                  value.each do |key2, value2|
                     if(value1[key2] != nil)
                           suma +=  value2 * value1[key2]
                     end
                  end
                  if(suma != 0)
                     new_mat.merge!({{key1 => suma} => hash}) do |key3, oldval, newval|
                        oldval.merge!(newval)
                     end
                  end
               end
            end
            MatrizDispersa.new(@filas, other.columnas, new_mat)
         else
            raise TypeError.new("No se puede coaccionar #{other.inspect} a Matriz")
         end      
      end
      
      #Método maximo: Devuelve el mayor valor dentro de las posiciones de la matriz.
      def maximo
         tmp = @elementos.keys
         tmp1 = tmp[0]
         tmp2 = @elementos[tmp1].keys
         tmp3 = tmp2[0]
         mayor = at(tmp1,tmp3)
         @elementos.each do |clave, valor|
            valor.each do |clave2, valor2|
               if at(clave,clave2) > mayor
                  mayor = at(clave,clave2)
               end
            end
         end
         mayor
      end
      
      #Método minimo: Devuelve el menor valor dentro de las posiciones de la matriz.
      def minimo
         tmp = @elementos.keys
         tmp1 = tmp[0]
         tmp2 = @elementos[tmp1].keys
         tmp3 = tmp2[0]
         menor = at(tmp1,tmp3)
         @elementos.each do |clave, valor|
            valor.each do |clave2, valor2|
               if at(clave,clave2) < menor
                  menor = at(clave,clave2)
               end
            end
         end
         menor
      end
      
   end
end

#Clase Fraccion: Permite el uso de números fraccionarios, que cuentan con un denominador y numerador
class Fraccion
   attr_reader :num, :denom 
   include Comparable
   #Método initialize, al crear la fraccion se calcula su mínima expresión.
   def initialize(num, denom)
      mcd = gcd(num,denom)
      @num , @denom = num/mcd, denom/mcd
   end
   #Método to_s, devuelve la fracción en forma de cadena
   def to_s
      "#{@num}/#{@denom}"
   end
   #Método to_float: Realiza la división y devuelve el resultado en formato flotante
   def to_float()
      @num.to_float/@denom
   end
   #Método abs, calcula la forma de la fraccion en valor absoluto
   def abs()
      @num.abs/@denom.abs                 
   end
   #Metodo reciprocal: Devuelve la forma recírpoca de una fracción
   def reciprocal()
      Fraccion.new(@denom, @num)
   end
   #Sobrecarga del operador + para operar entre fracciones. Permite operar fracciones con numeros.
   def +(other)
      if other.class == Fraccion
         Fraccion.new(@num*other.denom + other.num*@denom , @denom*other.denom)
      else
         Fraccion.new(@num + other*@denom , @denom)
      end
   end
  
   #Sobrecarga del operador - para operar entre fracciones. Permite operar fracciones con numeros.
   def -(other)
      if other.class == Fraccion
         Fraccion.new(@num*other.denom - other.num*@denom , @denom*other.denom)
      else
         Fraccion.new(@num - other*@denom , @denom)
      end
   end
  
   #Sobrecarga del operador * para operar entre fracciones. Permite operar fracciones con numeros.
   def *(other)
      if other.class == Fraccion
         Fraccion.new(@num * other.num, @denom * other.denom)
      else
         Fraccion.new(@num * other, @denom)
      end
   end
    
   #Sobrecarga del operador / para operar entre fracciones. 
   def /(other)
      Fraccion.new(@num * other.denom, @denom * other.num)
   end

   #Sobrecarga del operador % para operar entre fracciones. 
   def %(other)
      result = self./(other)
      result = (result.num%result.denom).to_i
   end
    #Operador <=>. La definición de este método permite utilizar el modulo comparable
   def <=>(other)
      @num.to_float/@denom <=> other.num.to_float/other.denom
   end
   
   #Metodo coerce. ante una llamada del tipo X+Fraccion,X-Fraccion,X*Fraccion, donde X no es un objeto con +(Fraccion) definido
   #devuelve los atributos alrevés, operando Fraccion+X
   def coerce(other)
      [self,other]
   end
end
#Metodo gcd: Calcula el máximo común divisor entre dos numeros
def gcd(u, v)
  u, v = u.abs, v.abs
  while v != 0
    u, v = v, u % v
  end
  u
end

if __FILE__ == $0
# Trabajo con la clase:
include Practica9
   m1=MatrizDensa.new(2,2,[[3,4],[5,6]])
   m2=MatrizDispersa.new(2,2,{1=>{0=>Fraccion.new(1,2)}})
   
   puts "m1"
   puts m1.to_s
   puts
   puts "m2"
   puts m2.to_s
   puts
   puts "m1+m2"
   puts (m1+m2).to_s
   
end
