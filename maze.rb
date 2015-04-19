class Maze
	attr_accessor :maze_board
	def initialize(n, m)
		#array including walls
		@maze_array = Array.new(n*2+1) { Array.new(m*2+1) }
		#array of only positions and having an array of the four boundaries around them
		@maze_board = Array.new(n) { Array.new(m) {[]} }
	end
	def load_maze(args)
        #this loads the maze string making sure that the right dimensions were put in.
		if (args.length!=(@maze_array.length)*(@maze_array[0].length))
			puts("invalid string")
			return 0
		end
        #this double loop inputs the string into the double array representing the maze
		count=0
		@maze_array.each_index do |x|
			@maze_array[x].each_index do |y|
				@maze_array[x][y]=args[count]
				count+=1
			end
		end
        #this puts an array of the 4 walls/nonwalls around every position
		@maze_board.each_index do |x|
			@maze_board[x].each_index do |y|
				temp=[]
				temp.push(@maze_array[x*2][y*2+1])
				temp.push(@maze_array[x*2+1][y*2+2])
				temp.push(@maze_array[x*2+2][y*2+1])
				temp.push(@maze_array[x*2+1][y*2])
				@maze_board[x][y].push(temp[0],temp[1],temp[2],temp[3])
			end
		end
	end
	def print_maze
        #prints the maze based on the maze_array array
		@maze_array.each_index do |x|
			@maze_array[x].each_index do |y|
                #if this spot was traced, write a o
				if (@maze_array[x][y]=='2')
					print("o")
                #if there is no wall there indicated by 0 then enter an empty " " string
				elsif (@maze_array[x][y]=='0')
					print(" ")
				else
                #if there is a wall there then print the appropriate character for it
					if(x%2==1)
						print("|")
					else
						if(y%2==0)
							print("+")
						else
							print("-")
						end
					end
				end
			end
			print("\n")
		end
	end
    #solve the maze with a depth first search using a stack to traverse and a hash (visited) to keep track of what you've already visited
	def maze_solve(begX, begY, endX, endY)
		visited={}
		stack=[]
        #push onto the stack the intial position
		stack.push([begX, begY])
        #make a key out of the hashed value of the beginning position and assign it the array of the beginning position
		visited[[begX, begY].hash]=[begX, begY]
        #set curr to the end of the stack
		curr=stack[stack.length-1]
		while(stack.length>0&&visited[[endX, endY].hash]==nil)
            #check which sides of the current position do not have walls and if they haven't been visited
            #push them to the stack, add them to the visited hash and set curr to the next position
			if(@maze_board[curr[0]][curr[1]][0]=='0'&&visited[[curr[0]-1,curr[1]].hash]==nil)
				curr=[curr[0]-1,curr[1]]
				stack.push(curr)
				visited[curr.hash]=curr
			elsif(@maze_board[curr[0]][curr[1]][1]=='0'&&visited[[curr[0],curr[1]+1].hash]==nil)
				curr=[curr[0],curr[1]+1]
				stack.push(curr)
				visited[curr.hash]=curr
			elsif(@maze_board[curr[0]][curr[1]][2]=='0'&&visited[[curr[0]+1,curr[1]].hash]==nil)
				curr=[curr[0]+1,curr[1]]
				stack.push(curr)
				visited[curr.hash]=curr
			elsif(@maze_board[curr[0]][curr[1]][3]=='0'&&visited[[curr[0],curr[1]-1].hash]==nil)
				curr=[curr[0],curr[1]-1]
				stack.push(curr)
				visited[curr.hash]=curr
            #if it is at a dead end, pop the stack and resume
			else
				stack.pop
			end
		end
		if(visited[[endX, endY].hash]==nil)
			return false
		else
			return true
		end
	end
	def maze_trace(begX, begY, endX, endY)
        #uses the maze_solve except adds a direction array which stores the visited directions
		if (maze_solve(begX, begY, endX, endY))
			directions=[]
			visited={}
            #the stack will contain the succesful path, and when paired with directions can trace the maze solve
			stack=[]
			stack.push([begX, begY])
			directions.push("begin")
			visited[[begX, begY].hash]=[begX, begY]
			curr=stack[stack.length-1]
            #same as in maze solve except also adds a direction
			while(stack.length>0&&visited[[endX, endY].hash]==nil)
				if(@maze_board[curr[0]][curr[1]][0]=='0'&&visited[[curr[0]-1,curr[1]].hash]==nil)
					curr=[curr[0]-1,curr[1]]
					stack.push(curr)
					directions.push("up")
					visited[curr.hash]=curr
				elsif(@maze_board[curr[0]][curr[1]][1]=='0'&&visited[[curr[0],curr[1]+1].hash]==nil)
					curr=[curr[0],curr[1]+1]
					stack.push(curr)
					directions.push("right")
					visited[curr.hash]=curr
				elsif(@maze_board[curr[0]][curr[1]][2]=='0'&&visited[[curr[0]+1,curr[1]].hash]==nil)
					curr=[curr[0]+1,curr[1]]
					stack.push(curr)
					directions.push("down")
					visited[curr.hash]=curr
				elsif(@maze_board[curr[0]][curr[1]][3]=='0'&&visited[[curr[0],curr[1]-1].hash]==nil)
					curr=[curr[0],curr[1]-1]
					stack.push(curr)
					directions.push("left")
					visited[curr.hash]=curr
				else
                #if it hits a dead end pop the direction and the stack to erase the wrong path
					stack.pop
					directions.pop
				end
			end
            #uses the stack to change the maze array (to include o's for visited path)
            #traces the path based on the stack and directions
			stack.each_index do |x|
				@maze_array[(stack[x][0])*2+1][(stack[x][1])*2+1]='2'
				puts("[#{stack[x][0]}, #{stack[x][1]}] #{directions[x]}")
			end
			print_maze
		end
	end





end
test=Maze.new(4, 4)
test.load_maze("111111111100010001111011101100010101101110101100000101111011101100000101111111111")
test.print_maze
test.maze_trace(0,0,1,2)


