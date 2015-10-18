import csv
DATA = 	"./data/food-world-cup-data.csv"
OUTPUT = './data/pythonCleaned.csv'
HEADER = './data/header.csv'
with open(OUTPUT, 'wb') as outfile:
	writer = csv.writer(outfile)

	#writing column headers
	with open(HEADER, 'rU') as infile:
		reader = csv.reader(infile)
		headerList = []
		for row in reader:
			for col in row:
				if "Please rate how much you like the traditional cuisine of" in col:
					headerList.append(col.rsplit(None, 1)[-1][:-1])
				else:
					headerList.append(col)
		writer.writerow(headerList)	

	#writing column data
	with open(DATA, 'rU') as infile:
		reader = csv.reader(infile)
		for row in reader:
			writer.writerow(row)