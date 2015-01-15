__author__ = 'Qiongcheng Xu'


def main():
    #Open txt file to read numbers
    file = open("number.txt")
    file_content = file.readlines()
    for line in file_content:
        #Split numbers in a line by space
        line_of_numbers = line.split(" ")
        #Calculate statistics of each line
        stats(line_of_numbers)
    #Close txt file
    file.close()


#Get mean, median, mode, maximum, minimum value of each line of numbers
def stats(line_of_numbers):
    #Create a list of numbers
    number_list = []
    #Append each number to number_list
    for number in line_of_numbers:
        number = number.strip()
        #Parse string to int
        number = int(number)
        number_list.append(number)
    print number_list
    #Sort number_list from small to large
    number_list.sort()
    #print number_list
    #Length of number_list
    qty = len(number_list)
    #Find mean value
    mean_value(number_list, qty)
    #Find median value
    median_value(number_list, qty)
    #Find mode value
    mode_value(number_list, qty)
    #Find maximum
    max = number_list[qty-1]
    #Find minimum
    min = number_list[0]
    print "maximum:", max
    print "minimum:", min


#Get the mean value
def mean_value(number_list, qty):
    #Sum of number_list
    sum = 0
    for number in number_list:
        sum += number
    #Mean of number_list
    mean = float(sum)/qty
    print "mean:", mean


#Get the median value
def median_value(number_list, qty):
    if qty % 2 == 1:
        m = (qty - 1) / 2
        median = number_list[m]
    else:
        m = qty / 2
        median = float(number_list[m-1] + number_list[m]) / 2
    print "median:", median


#Get the mode value
def mode_value(number_list, qty):
    #Create a dictionary number_freq to store the frequency of each number in number_list
    number_freq = dict()
    for number in number_list:
        if number in number_freq:
            number_freq[number] += 1
        else:
            number_freq[number] = 1
    #print number_freq
    #Find mode
    mode_list = []
    temp = number_list[0]
    index = 1
    #Find all most frequently occurred numbers and append to the mode_list
    while index < qty:
        number = number_list[index]
        if number_freq[number] > number_freq[temp]:
            #Store the most frequently occurred number in temp
            temp = number
            #Delete numbers stored in mode_list and insert temp as updated most frequently occurred number
            mode_list = [temp]
        elif number_freq[number] == number_freq[temp]:
            #If the number is not in the mode_list, append the number to mode_list
            if number not in mode_list:
                mode_list.append(number)
        #Increase index
        index += 1
    print "mode:", mode_list


main()