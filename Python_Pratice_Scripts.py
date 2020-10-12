# Python Pratice File 
# I created this file in order to store pratice scripts, anything from easy to hard 

# ------------------------------------------------------
# running sum for an array

nums = [1, 2, 3, 4] # test array 

  def runningSum(self, nums: List[int]) -> List[int]:
      list = []
      list.append(nums[0])
      
      for i in range(1, len(nums)):
        list.append(list[i-1]+nums[i])
       
      return(list)
# ------------------------------------------------------
# Kids With the Greatest Number of Candies

candies = [2,3,5,1,3]
extraCandies = 3

# two solutions 
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]:
        return [ True if i + extraCandies >= max(candies) else False for i in candies ]
    
    
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]
      for i in range(0, len(candies)):
          if extraCandies + candies[i] >= max(candies):
              list.append("True")
          else:
              list.append("False")
      return(list)

# ------------------------------------------------------
# Shuffle the Array

    def shuffle(self, nums: List[int], n: int) -> List[int]:
        size= len(nums) # length of our array
        result=list(([0]*size)) # Creating empty list 
        j = 0
        for i  in range(n): # notice how we are going to n
            result[j]=nums[i] # add the ith value to the 1st 
            result[j+1]= nums[i+n] # add the i+nth one, this is the key trick in the code 
            j = j+2 # increment j after loop through. 
        return result

# ------------------------------------------------------
# Shuffle String
# Given a string s and an integer array indices of the same length.
# The string s will be shuffled such that the character at the ith position moves to indices[i] in the shuffled string.
s = "codeleet"
indices = [4,5,6,7,0,2,1,3]

    def restoreString(self, s: str, indices: List[int]) -> str:
        zipped_list = zip(indices, s) # pair them together with an iterable object
        sorted__zipped_lists = sorted(zipped_list) # sort it based off the indicies given to me 
        sorted_list1 = [element for _, element in sorted__zipped_lists] # unpack items 
        return(''.join(sorted_list1)) # return the joined object 







    
    
