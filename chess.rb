module ChessConstants
  NUMBER_OF_ROWS = 8
  NUMBER_OF_COLUMNS = 8
  
  L_ARRAY = ["a", "b", "c", "d", "e", "f", "g", "h"]
  N_ARRAY = ["1", "2", "3", "4", "5", "6", "7", "8"]
end

class GameController
  attr_accessor :board, :display, :white, :black, :players, :current_player
  
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @white = nil
    @black = nil
    @players = [Person.new(@board, "Player one")]
    @current_player = nil
  end

  def play_match #TODO update
    @players << set_opponet_type
    
    set_colors
    announce_colors

    @current_player = @white
    while ((checkmate? == false) && (draw? == false))
      @display.contents
      announce_current_player
      @current_player.get_move
      switch_current_player #TODO refactor
    end 
  end

  def announce_current_player
    puts "It is #{@current_player.name}'s turn."
  end

  def switch_current_player #TODO refactor
    if @current_player == @white
      @current_player = @black
    elsif @current_player == @black
      @current_player = @white
    end
  end

  def checkmate? #TODO
    return false
  end

  def draw? #TODO
    return false
  end

  def set_opponet_type
    loop do
      puts "Enter P if you would like to play agaisnt another person."
      puts "Enter C if you would like to play agaisnt a computer."

      input = gets.chomp.gsub(/\s+/, "").upcase
      puts("")

      return Person.new(@board, "Player two") if input == "P"
      
      return Computer.new(@board, "Computer") if input == "C"
    end
  end

  def set_colors
    @white = @players.sample
    
    @black = @players[0] if @players[1] == @white
    @black = @players[1] if @players[0] == @white

    @white.piece_color = "white"    
    @black.piece_color = "black"
  end

  def announce_colors
    puts "#{@white.name} will play as white."
    puts "#{@black.name} will play as black."
    puts("")
  end
end

class Node
  attr_accessor :parent, :l_notation, :n_notation, :child_array

  def initialize (parent = nil, l_notation = nil, n_notation = nil, 
                  child_array = nil)

    @parent = parent
    @l_notation = l_notation
    @n_notation = n_notation
    @child_array = child_array
  end
end

class BoardSquare
  attr_accessor :l_notation, :n_notation, :color, :piece

  def initialize(l_notation, n_notation, color, piece = nil)
    @l_notation = l_notation
    @n_notation = n_notation
    @color = color
    @piece = piece
  end

  def info #TODO test function to eventually delete
    print "#{@l_notation} #{@n_notation} #{@color} #{@piece}"
    print " nil " if @piece.nil?

    puts("")
  end
end

class Display
  include ChessConstants

  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def contents
    print_l_notation
    print_top_row

    N_ARRAY.reverse.each do |value| 
      print_piece_row(value)
      print_line_row unless value == N_ARRAY[0]
    end

    print_bottom_row
    print_l_notation

    puts("")
  end

  def print_l_notation
    print "   "
    L_ARRAY.each { |value| print "#{value}  "}
    puts ""
  end

  def print_top_row
    counter = 0

    print "  "
    print unicode_board(:top_left_corner)
    print unicode_board(:horizontal)
    print unicode_board(:horizontal)

    loop do
      print unicode_board(:top_mid)
      print unicode_board(:horizontal)
      print unicode_board(:horizontal)
      counter += 1
      break if counter == NUMBER_OF_COLUMNS - 1
    end
    puts unicode_board(:top_right_corner)
  end

  def print_piece_row(n_notation) 
    print(n_notation)
    print " "

    @board.array[NUMBER_OF_ROWS - n_notation.to_i].each do |board_square|
      print unicode_board(:vertical)

      if board_square.piece.nil?
        print " "
      else
        print unicode_piece(board_square.piece, board_square.piece.color)
      end
      print " "
    end

    print unicode_board(:vertical)

    print " "
    puts(n_notation)
  end
   
  def print_line_row
    counter = 0

    print "  "
    print unicode_board(:left_mid)
    print unicode_board(:horizontal)
    print unicode_board(:horizontal)

    loop do
      print unicode_board(:cross)
      print unicode_board(:horizontal)
      print unicode_board(:horizontal)
      counter += 1
      break if counter == NUMBER_OF_COLUMNS - 1
    end
    puts unicode_board(:right_mid)    
  end

  def print_bottom_row 

    counter = 0

    print "  "
    print unicode_board(:bottom_left_corner)
    print unicode_board(:horizontal)
    print unicode_board(:horizontal)

    loop do
      print unicode_board(:bottom_mid)
      print unicode_board(:horizontal)
      print unicode_board(:horizontal)
      counter += 1
      break if counter == NUMBER_OF_COLUMNS - 1
    end
    puts unicode_board(:bottom_right_corner)  
  end

  def unicode_board(key)
    hash = {horizontal: "\u2500",
            vertical: "\u2502",
            top_left_corner: "\u250C",
            top_right_corner: "\u2510",
            bottom_left_corner: "\u2514",
            bottom_right_corner: "\u2518",
            top_mid: "\u252c",
            left_mid: "\u251c",
            right_mid: "\u2524",
            bottom_mid: "\u2534",
            cross: "\u253c"}

    return hash.fetch(key).encode('utf-8')   
  end

  def unicode_piece(piece, piece_color)
   key = piece.class.to_s.downcase.to_sym

    white_hash = {king: "\u2654",
                  queen: "\u2655",
                  rook: "\u2656",
                  bishop: "\u2657",
                  knight: "\u2658",
                  pawn: "\u2659"}

   return white_hash.fetch(key).encode('utf-8') if piece_color == "white"

    black_hash = {king: "\u265A",
                  queen: "\u265B",
                  rook: "\u265C",
                  bishop: "\u265D",
                  knight: "\u265E",
                  pawn: "\u265F"}

    return black_hash.fetch(key).encode('utf-8') if piece_color == "black"
  end
end

class Board
  include ChessConstants

  attr_accessor :array

  def initialize
    @array = Array.new(8) {Array.new(8)}

    @array[0][0] = BoardSquare.new("a", "8", "white", Rook.new("black", self))
    @array[0][1] = BoardSquare.new("b", "8", "black", Knight.new("black", self))
    @array[0][2] = BoardSquare.new("c", "8", "white", Bishop.new("black", self))
    @array[0][3] = BoardSquare.new("d", "8", "black", Queen.new("black", self))
    @array[0][4] = BoardSquare.new("e", "8", "white", King.new("black", self))
    @array[0][5] = BoardSquare.new("f", "8", "black", Bishop.new("black", self))
    @array[0][6] = BoardSquare.new("g", "8", "white", Knight.new("black", self))
    @array[0][7] = BoardSquare.new("h", "8", "black", Rook.new("black", self))

    @array[1][0] = BoardSquare.new("a", "7", "black", Pawn.new("black", self))
    @array[1][1] = BoardSquare.new("b", "7", "white", Pawn.new("black", self))
    @array[1][2] = BoardSquare.new("c", "7", "black", Pawn.new("black", self))
    @array[1][3] = BoardSquare.new("d", "7", "white", Pawn.new("black", self))
    @array[1][4] = BoardSquare.new("e", "7", "black", Pawn.new("black", self))
    @array[1][5] = BoardSquare.new("f", "7", "white", Pawn.new("black", self))
    @array[1][6] = BoardSquare.new("g", "7", "black", Pawn.new("black", self))
    @array[1][7] = BoardSquare.new("h", "7", "white", Pawn.new("black", self))

    @array[2][0] = BoardSquare.new("a", "6", "white")
    @array[2][1] = BoardSquare.new("b", "6", "black")
    @array[2][2] = BoardSquare.new("c", "6", "white")
    @array[2][3] = BoardSquare.new("d", "6", "black")
    @array[2][4] = BoardSquare.new("e", "6", "white")
    @array[2][5] = BoardSquare.new("f", "6", "black")
    @array[2][6] = BoardSquare.new("g", "6", "white")
    @array[2][7] = BoardSquare.new("h", "6", "black")

    @array[3][0] = BoardSquare.new("a", "5", "black")
    @array[3][1] = BoardSquare.new("b", "5", "white")
    @array[3][2] = BoardSquare.new("c", "5", "black")
    @array[3][3] = BoardSquare.new("d", "5", "white")
    @array[3][4] = BoardSquare.new("e", "5", "black")
    @array[3][5] = BoardSquare.new("f", "5", "white")
    @array[3][6] = BoardSquare.new("g", "5", "black")
    @array[3][7] = BoardSquare.new("h", "5", "white")

    @array[4][0] = BoardSquare.new("a", "4", "white")
    @array[4][1] = BoardSquare.new("b", "4", "black")
    @array[4][2] = BoardSquare.new("c", "4", "white")
    @array[4][3] = BoardSquare.new("d", "4", "black")
    @array[4][4] = BoardSquare.new("e", "4", "white")
    @array[4][5] = BoardSquare.new("f", "4", "black")
    @array[4][6] = BoardSquare.new("g", "4", "white")
    @array[4][7] = BoardSquare.new("h", "4", "black")

    @array[5][0] = BoardSquare.new("a", "3", "black")
    @array[5][1] = BoardSquare.new("b", "3", "white")
    @array[5][2] = BoardSquare.new("c", "3", "black")
    @array[5][3] = BoardSquare.new("d", "3", "white")
    @array[5][4] = BoardSquare.new("e", "3", "black")
    @array[5][5] = BoardSquare.new("f", "3", "white")
    @array[5][6] = BoardSquare.new("g", "3", "black")
    @array[5][7] = BoardSquare.new("h", "3", "white")

    @array[6][0] = BoardSquare.new("a", "2", "white", Pawn.new("white", self))
    @array[6][1] = BoardSquare.new("b", "2", "black", Pawn.new("white", self))
    @array[6][2] = BoardSquare.new("c", "2", "white", Pawn.new("white", self))
    @array[6][3] = BoardSquare.new("d", "2", "black", Pawn.new("white", self))
    @array[6][4] = BoardSquare.new("e", "2", "white", Pawn.new("white", self))
    @array[6][5] = BoardSquare.new("f", "2", "black", Pawn.new("white", self))
    @array[6][6] = BoardSquare.new("g", "2", "white", Pawn.new("white", self))
    @array[6][7] = BoardSquare.new("h", "2", "black", Pawn.new("white", self))

    @array[7][0] = BoardSquare.new("a", "1", "black", Rook.new("white", self))
    @array[7][1] = BoardSquare.new("b", "1", "white", Knight.new("white", self))
    @array[7][2] = BoardSquare.new("c", "1", "black", Bishop.new("white", self))
    @array[7][3] = BoardSquare.new("d", "1", "white", Queen.new("white", self))
    @array[7][4] = BoardSquare.new("e", "1", "black", King.new("white", self))
    @array[7][5] = BoardSquare.new("f", "1", "white", Bishop.new("white", self))
    @array[7][6] = BoardSquare.new("g", "1", "black", Knight.new("white", self))
    @array[7][7] = BoardSquare.new("h", "1", "white", Rook.new("white", self))
  end

  def get_square_from_piece(piece)
    @array.each do |sub_array|        
      sub_array.each do |board_square|
        return board_square if board_square.piece == piece
      end
    end
    return nil
  end

  def get_square_from_notation(l_notation, n_notation)
    @array.each do |sub_array|        
      sub_array.each do |board_square|
           if ((board_square.l_notation == l_notation)\
             && (board_square.n_notation == n_notation))
        
            return board_square
          end
      end
    end
    return nil
  end

  def square_notation_exists?(l_notation, n_notation)
    return true if @letter_array.include?(l_notation) && 
                   @number_array.include?(n_notation)

    return false
  end

  def get_square_from_index(l_n_index, n_n_index)
    @array.each do |sub_array|        
      sub_array.each do |board_square|
           if ((L_ARRAY.index(board_square.l_notation) == l_n_index)\
             && (N_ARRAY.index(board_square.n_notation) == n_n_index))
        
            return board_square
          end
      end
    end
    return nil
  end

  def square_index_exists?(l_n_index, n_n_index)
      return true if (l_n_index.between?(0, 7) && n_n_index.between?(0, 7))

      return false
  end

  def display_info #TODO test function delete when finished
    self.board_array.each do |sub_array|   
      puts("")     
      sub_array.each do |board_square|
         board_square.info
      end
    end
  end
end

class Piece
  include ChessConstants

  attr_accessor :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def valid_move?(new_l_n_index, new_n_n_index)
    if @board.square_index_exists?(new_l_n_index, new_n_n_index)
      return @board.get_square_from_index(new_l_n_index, new_n_n_index)
    end
  end
end

class Knight < Piece
=begin
  def build_move_tree(start_square, depth)
    root = Node.new(nil, start_square.l_notation, start_square.n_notation)
    
    queue = [root]
    current_node = queue[0]

    while depth > 0
      add_children_to_queue(current_node, queue)
      queue.shift
      current_node = queue[0]
      depth -= 1
    end
    return nil
  end

  def add_children_to_queue(parent, queue)
    parent.child_array = get_child_array(parent)
    parent.child_array.each do |child|
      queue << Node.new(parent, child.l_notation, child.n_notation)
    end
  end
=end

  def get_child_array
    parent = @board.get_square_from_piece(self)    

    child_array = []
    parent_l_n_index = L_ARRAY.index(parent.l_notation)
    parent_n_n_index = N_ARRAY.index(parent.n_notation)

    child_array << valid_move?(parent_l_n_index + 1, parent_n_n_index + 2)
    child_array << valid_move?(parent_l_n_index + 2, parent_n_n_index + 1)

    child_array << valid_move?(parent_l_n_index + 2, parent_n_n_index - 1)
    child_array << valid_move?(parent_l_n_index + 1, parent_n_n_index - 2)

    child_array << valid_move?(parent_l_n_index - 1, parent_n_n_index - 2)
    child_array << valid_move?(parent_l_n_index - 2, parent_n_n_index - 1)

    child_array << valid_move?(parent_l_n_index - 2, parent_n_n_index + 1) 
    child_array << valid_move?(parent_l_n_index - 1, parent_n_n_index + 2)

    return child_array.compact
  end
end

class Rook < Piece
end

class Bishop < Piece

end

class Queen < Piece

end

class King < Piece
end

class Pawn < Piece
end

class Player
  attr_accessor :board, :name, :piece_color

  def initialize(board, name = nil)
    @board = board
    @name = name
    @piece_color = nil
  end

  def valid_piece_to_move(l_notation, n_notation)
    #square exists
    #square has a piece
    #piece color is same as player
    #movement will not cause check
    #has a valid square to move to (specifically king cannot move into check)
  end

  def valid_square_to_place_piece?(l_notation, n_notation)
    #square exists
    #square does not contain piece with same color and player
  end
end

class Person < Player
  include ChessConstants

  def get_move
    puts "Please enter the board square of the piece you want to move."
    input = get_valid_input #TODO need to check if piece color is correct/move is valid    

    prior_square = @board.get_square_from_notation(input[0], input[1])

    puts "Please the board square for where to move the piece."
    input = get_valid_input #TODO need to check is move is valid 
    
    new_square = @board.get_square_from_notation(input[0], input[1])
    new_square.piece = prior_square.piece
    prior_square.piece = nil
  end
  
  def get_valid_input
    loop do
      puts "Please enter a board square with correct notation. (eg. e4)"
      input = gets.chomp.gsub(/\s+/, "").downcase
      if ((input.length == 2)\
         && L_ARRAY.include?(input[0])\
         && N_ARRAY.include?(input[1])) 

        return input
      end
    end
	end

end

class Computer < Player
  
end

game_controller = GameController.new()

game_controller.play_match




