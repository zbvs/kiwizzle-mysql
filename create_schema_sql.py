

f = open("./recreate.sql")
data = f.read()
f.close()

data = data.split("\n")
result = ""

comment_depth = 0
for line in data:
    if line == "############################################################################<<":
        comment_depth += 1
        continue
    elif line == "############################################################################>>":
        comment_depth -= 1
        continue
    if comment_depth == 0:
        result += line + "\n"

f = open("./schema.sql", "w")
f.write(result)
f.close()
