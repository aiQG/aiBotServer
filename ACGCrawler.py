#!python3


from lxml import etree
import requests


domain = "https://bangumi.tv/calendar"
headers = {
    'User-Agent': 'User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'}


r = requests.get(domain, headers=headers)
html = r.text.encode(r.encoding).decode('utf8')
doc = etree.HTML(html)

dic = {"Mon": [],
       "Tue": [],
       "Wed": [],
       "Thu": [],
       "Fri": [],
       "Sat": [],
       "Sun": []}

for weekday in doc.xpath('//ul/li/dl/dd[@class]'):
    for info in doc.xpath("//ul/li/dl/dd[@class=\"" + weekday.get('class') + "\"]/ul/li/div/div[@class=\"info\"]/p/a/small/em"):
        str = info.text
        for t in info.xpath("../../../../p[1]/a"):
            if t.text == None:
                break
            str = t.text  # + " (" + str + ")"
        dic[weekday.get('class')] += [str]

output = 'Weekly ACG:\n'
for key in dic:
    output += "✦" + key + "---------\n"
    for i in dic[key]:
        output += i + "\n"


print(output)
