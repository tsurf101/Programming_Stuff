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
