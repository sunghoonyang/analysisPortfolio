DATA = 	"./food-world-cup-data.csv"
OUTPUT = './phytonCleaned.csv'
HEADER = './header.csv'
cleanData = open(OUTPUT, 'w')

with open(HEADER) as fileobj:
	for word in fileobj:
		row = word.split(',')
		i = 0
		for cell in row:
			if "Please rate how much you like the traditional cuisine of" in cell:
				cell = cell.rsplit(None, 1)[-1][:-1]

			cleanData.write(cell + "\t")
			i+=1
			if i == 48:
				i = 0
				cleanData.write("\n")

with open(DATA) as fileobj:
	for word in fileobj:
		row = word.split(',')
		i = 0
		for cell in row:
			cleanData.write(cell + "\t")
			i+=1
			if i == 48:
				i = 0
				cleanData.write("\n")

cleanData.close()

		
