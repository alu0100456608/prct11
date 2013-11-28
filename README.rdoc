# Practica11

  Esta gema permite el uso de matrices densas (DenseMatrix) y matrices dispersas (SparseMatrix).
  Pese a que la representación de estas matrices sea diferentes, ambos tipos de matrices heredarán
  de un tipo de matriz básico (Matrix).
  Tendremos la jerarquía de clases
  
  class Matrix: 
    * Implementa operador abstracto de indexación.
    * Implementa operadores + - * == que usan el operador de indexación
  
  class DenseMatrix < Matrix:
    * Almacena los datos en un Array de Arrays de n x m
    * Implementa operador de indexación tradicional, para acceder al Array de Arrays
  
  class SparseMatrix < Matrix:
    * Alamcena los datos en un Array de Structs. Cada struct está compuesto por:
      * Un valor
      * Posición x en la matriz del valor
      * Posición y en la matriz del valor
    * Implementa operador de indexación que busca en el Array si existe algún valor asociado a la posición 
      indicada y lo devuelve. en caso contrario devuelve un elemento neutro (0).

## Installation

Add this line to your application's Gemfile:

    gem 'practica9'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install practica9

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
