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
    
