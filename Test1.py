check_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
def find_solution(step):
    for num in xrange(step, 999999999, step):
        if all(num % n == 0 for n in check_list):
            return num
    return None
if __name__ == '__main__':
    solution = find_solution(2520)
    if solution is None:
        print "No answer found"
    else:
        print "found an answer:", solution

        #Test

        
