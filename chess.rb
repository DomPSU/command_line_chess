module ChessConstants
  NUMBER_OF_ROWS = 8
  NUMBER_OF_COLUMNS = 8
  
  L_ARRAY = ["a", "b", "c", "d", "e", "f", "g", "h"]
  N_ARRAY = [1, 2, 3, 4, 5, 6, 7, 8]
end

class GameControl
  attr_accessor :board, :display, :current_player
  
  def initialize(board)
    @board = Board.new
    @display = Display.new(@board)
    @current_player = nil
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
  attr_accessor :l_notation, :n_notation, :color, :piece, :piece_color

  def initialize(l_notation, n_notation, color, piece = nil, piece_color = nil)
    @l_notation = l_notation
    @n_notation = n_notation
    @color = color
    @piece = piece
    @piece_color = piece_color
  end

  def info #TODO test function to eventually delete
    print "#{@l_notation} #{@n_notation} #{@color} #{@piece} #{@piece_color}"
    print " nil " if @piece.nil?
    print " nil " if @piece_color.nil?
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

    @board.board_array[NUMBER_OF_ROWS-n_notation].each do |board_square|
      print unicode_board(:vertical)

      if board_square.piece.nil?
        print " "
      else
        print unicode_piece(board_square.piece, board_square.piece_color)
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

  def unicode_piece(key, piece_color)
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

  attr_accessor :board_array

  def initialize
    @board_array = Array.new(8) {Array.new(8)}

    @board_array[0][0] = BoardSquare.new("a", 8, "white")
    @board_array[0][1] = BoardSquare.new("b", 8, "black")
    @board_array[0][2] = BoardSquare.new("c", 8, "white")
    @board_array[0][3] = BoardSquare.new("d", 8, "black")
    @board_array[0][4] = BoardSquare.new("e", 8, "white")
    @board_array[0][5] = BoardSquare.new("f", 8, "black")
    @board_array[0][6] = BoardSquare.new("g", 8, "white")
    @board_array[0][7] = BoardSquare.new("h", 8, "black")

    @board_array[1][0] = BoardSquare.new("a", 7, "black")
    @board_array[1][1] = BoardSquare.new("b", 7, "white")
    @board_array[1][2] = BoardSquare.new("c", 7, "black")
    @board_array[1][3] = BoardSquare.new("d", 7, "white")
    @board_array[1][4] = BoardSquare.new("e", 7, "black")
    @board_array[1][5] = BoardSquare.new("f", 7, "white")
    @board_array[1][6] = BoardSquare.new("g", 7, "black")
    @board_array[1][7] = BoardSquare.new("h", 7, "white")

    @board_array[2][0] = BoardSquare.new("a", 6, "white")
    @board_array[2][1] = BoardSquare.new("b", 6, "black")
    @board_array[2][2] = BoardSquare.new("c", 6, "white")
    @board_array[2][3] = BoardSquare.new("d", 6, "black")
    @board_array[2][4] = BoardSquare.new("e", 6, "white")
    @board_array[2][5] = BoardSquare.new("f", 6, "black")
    @board_array[2][6] = BoardSquare.new("g", 6, "white")
    @board_array[2][7] = BoardSquare.new("h", 6, "black")

    @board_array[3][0] = BoardSquare.new("a", 5, "black")
    @board_array[3][1] = BoardSquare.new("b", 5, "white")
    @board_array[3][2] = BoardSquare.new("c", 5, "black")
    @board_array[3][3] = BoardSquare.new("d", 5, "white")
    @board_array[3][4] = BoardSquare.new("e", 5, "black")
    @board_array[3][5] = BoardSquare.new("f", 5, "white")
    @board_array[3][6] = BoardSquare.new("g", 5, "black")
    @board_array[3][7] = BoardSquare.new("h", 5, "white")

    @board_array[4][0] = BoardSquare.new("a", 4, "white")
    @board_array[4][1] = BoardSquare.new("b", 4, "black")
    @board_array[4][2] = BoardSquare.new("c", 4, "white")
    @board_array[4][3] = BoardSquare.new("d", 4, "black")
    @board_array[4][4] = BoardSquare.new("e", 4, "white")
    @board_array[4][5] = BoardSquare.new("f", 4, "black")
    @board_array[4][6] = BoardSquare.new("g", 4, "white")
    @board_array[4][7] = BoardSquare.new("h", 4, "black")

    @board_array[5][0] = BoardSquare.new("a", 3, "black")
    @board_array[5][1] = BoardSquare.new("b", 3, "white")
    @board_array[5][2] = BoardSquare.new("c", 3, "black")
    @board_array[5][3] = BoardSquare.new("d", 3, "white")
    @board_array[5][4] = BoardSquare.new("e", 3, "black")
    @board_array[5][5] = BoardSquare.new("f", 3, "white")
    @board_array[5][6] = BoardSquare.new("g", 3, "black")
    @board_array[5][7] = BoardSquare.new("h", 3, "white")

    @board_array[6][0] = BoardSquare.new("a", 2, "white")
    @board_array[6][1] = BoardSquare.new("b", 2, "black")
    @board_array[6][2] = BoardSquare.new("c", 2, "white")
    @board_array[6][3] = BoardSquare.new("d", 2, "black")
    @board_array[6][4] = BoardSquare.new("e", 2, "white")
    @board_array[6][5] = BoardSquare.new("f", 2, "black")
    @board_array[6][6] = BoardSquare.new("g", 2, "white")
    @board_array[6][7] = BoardSquare.new("h", 2, "black")

    @board_array[7][0] = BoardSquare.new("a", 1, "black")
    @board_array[7][1] = BoardSquare.new("b", 1, "white")
    @board_array[7][2] = BoardSquare.new("c", 1, "black")
    @board_array[7][3] = BoardSquare.new("d", 1, "white")
    @board_array[7][4] = BoardSquare.new("e", 1, "black")
    @board_array[7][5] = BoardSquare.new("f", 1, "white")
    @board_array[7][6] = BoardSquare.new("g", 1, "black")
    @board_array[7][7] = BoardSquare.new("h", 1, "white")

    Rook.new("a", 8, "black", self)
    Knight.new("b", 8, "black", self)
    Bishop.new("c", 8, "black", self)
    Queen.new("d", 8, "black", self)
    King.new("e", 8, "black", self)
    Bishop.new("f", 8, "black", self)
    Knight.new("g", 8, "black", self)
    Rook.new("h", 8, "black", self)

    Pawn.new("a", 7, "black", self)
    Pawn.new("b", 7, "black", self)
    Pawn.new("c", 7, "black", self)
    Pawn.new("d", 7, "black", self)
    Pawn.new("e", 7, "black", self)
    Pawn.new("f", 7, "black", self)
    Pawn.new("g", 7, "black", self)
    Pawn.new("h", 7, "black", self)

    Pawn.new("a", 2, "white", self)
    Pawn.new("b", 2, "white", self)
    Pawn.new("c", 2, "white", self)
    Pawn.new("d", 2, "white", self)
    Pawn.new("e", 2, "white", self)
    Pawn.new("f", 2, "white", self)
    Pawn.new("g", 2, "white", self)
    Pawn.new("h", 2, "white", self)

    Rook.new("a", 1, "white", self)
    Knight.new("b", 1, "white", self)
    Bishop.new("c", 1, "white", self)
    Queen.new("d", 1, "white", self)
    King.new("e", 1, "white", self)
    Bishop.new("f", 1, "white", self)
    Knight.new("g", 1, "white", self)
    Rook.new("h", 1, "white", self)

  end

  def get_square_from_notation(l_notation, n_notation)
    @board_array.each do |sub_array|        
      sub_array.each do |board_square|
           if ((board_square.l_notation == l_notation)\
             && (board_square.n_notation == n_notation))
        
            return board_square
          end
      end
    end
  end

  def square_notation_exists?(l_notation, n_notation)
    return true if @letter_array.include?(l_notation) && 
                   @number_array.include?(n_notation)

    return false
  end

  def get_square_from_index(l_n_index, n_n_index)
    @board_array.each do |sub_array|        
      sub_array.each do |board_square|
           if ((L_ARRAY.index(board_square.l_notation) == l_n_index)\
             && (N_ARRAY.index(board_square.n_notation) == n_n_index))
        
            return board_square
          end
      end
    end
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

class Knight
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :knight
    @board_square.piece_color = piece_color
  end


  def build_move_tree(start_square, final_square)
    root = Node.new(nil, start_square.l_notation, start_square.n_notation)
    
    queue = [root]
    current_node = queue[0]

    while node_equal_to_square?(current_node, final_square) == false
      add_children_to_queue(current_node, queue)
      queue.shift
      current_node = queue[0]
    end
    return current_node
  end

  def node_equal_to_square?(node, square)
    return true if ((node.l_notation == square.l_notation) && 
                   (node.n_notation == square.n_notation))

    return false
  end

  def get_all_moves(node)
    move_array = [node]
    
    while move_array[-1].parent != nil
      move_array << move_array[-1].parent
    end
    return move_array.reverse
  end

  def move(start_square_array, end_square_array)
    s_s_l_n = start_square_array[0]
    s_s_n_n = start_square_array[1]

    e_s_l_n = end_square_array[0]
    e_s_n_n = end_square_array[1]

    start_square = @board.get_square_from_notation(s_s_l_n, s_s_n_n)
    end_square = @board.get_square_from_notation(e_s_l_n, e_s_n_n)

    move_array = get_all_moves(build_move_tree(start_square, end_square))
    
    puts("You made it in #{move_array.size} moves! Here is your path:")
    
    move_array.each{|square| puts("#{square.l_notation} #{square.n_notation}")}
  end

  def add_children_to_queue(parent, queue)
    parent.child_array = get_child_array(parent)
    parent.child_array.each do |child|
      queue << Node.new(parent, child.l_notation, child.n_notation)
    end
  end

  def get_child_array(parent = @board_square)
    child_array = []
    parent_l_n_index = @board.l_array.index(parent.l_notation)
    parent_n_n_index = @board.n_array.index(parent.n_notation)

    child_array << nil_unless_exists(parent_l_n_index + 1, parent_n_n_index + 2)
    child_array << nil_unless_exists(parent_l_n_index + 2, parent_n_n_index + 1)

    child_array << nil_unless_exists(parent_l_n_index + 2, parent_n_n_index - 1)
    child_array << nil_unless_exists(parent_l_n_index + 1, parent_n_n_index - 2)

    child_array << nil_unless_exists(parent_l_n_index - 1, parent_n_n_index - 2)
    child_array << nil_unless_exists(parent_l_n_index - 2, parent_n_n_index - 1)

    child_array << nil_unless_exists(parent_l_n_index - 2, parent_n_n_index + 1) 
    child_array << nil_unless_exists(parent_l_n_index - 1, parent_n_n_index + 2)

    return child_array.compact
  end

  def nil_unless_exists(new_l_n_index, new_n_n_index)
    if @board.square_index_exists?(new_l_n_index, new_n_n_index)
      return @board.get_square_from_index(new_l_n_index, new_n_n_index)
    end
  end
end

class Rook
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :rook
    @board_square.piece_color = piece_color
  end
end

class Bishop
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :bishop
    @board_square.piece_color = piece_color
  end
end

class Queen
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :queen
    @board_square.piece_color = piece_color
  end
end

class King
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :king
    @board_square.piece_color = piece_color
  end
end

class Pawn
  attr_accessor :board, :board_square

  def initialize(l_notation, n_notation, piece_color, board)
    @board = board
    @board_square = @board.get_square_from_notation(l_notation, n_notation)
    @board_square.piece = :pawn
    @board_square.piece_color = piece_color
  end
end

class Player
end

class Computer
end

board = Board.new()

display = Display.new(board)

display.contents




