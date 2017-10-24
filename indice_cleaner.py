import datetime
now = datetime.datetime.now()
year = str(now.year)
month = str(now.month)
day = str(now.day)

s = str(year + '.' + month + '.' + day)
d = datetime.datetime.strptime(s, '%Y.%m.%d') - datetime.timedelta(days=30)
print(d.strftime('%Y.%m.%d'))
