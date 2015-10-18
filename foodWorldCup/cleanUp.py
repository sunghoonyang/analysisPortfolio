DATA = 	"./food-world-cup-data.csv"
OUTPUT = './pythonCleaned.csv'
HEADER = './header.csv'
cleanData = open(OUTPUT, 'w')
#writing column headers
with open(HEADER) as fileobj:
	for line in fileobj:
		headers = line.split(',')
		i = 0
		for col in headers:
			if "Please rate how much you like the traditional cuisine of" in col:
				col = col.rsplit(None, 1)[-1][:-1]
			i += 1
			if i < 48:
				cleanData.write(col + ",")
			else:
				cleanData.write(col + "\n")
#let's write the data now
with open(DATA) as fileobj:
	for word in fileobj:
		row = word.split(',')
		i = 0
		for cell in row:
			i+=1
			if i > 48:
				i = 0
				cleanData.write(cell + "\n")
			else:
				cleanData.write(cell + ",")

cleanData.close()

		
