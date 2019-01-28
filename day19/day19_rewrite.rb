regs = [1, 27, 0, 28, 0, 981, 0]

regs[1] = regs[1] * regs[3]
regs[3] += 1
regs[1] = regs[3] + regs[1]
regs[3] += 1
regs[1] = regs[3] * regs[1]
regs[3] += 1
regs[1] = regs[1] * 14
regs[3] += 1
regs[1] = regs[1] * regs[3]
regs[3] += 1
regs[5] = regs[5] + regs[1]
regs[3] += 1
regs[0] = 0
regs[3] += 1
# switch
regs[3] = 0
regs[3] += 1
regs[4] = 1
regs[3] += 1
regs[2] = 1
regs[3] += 1
regs[1] = regs[4] * regs[2]
regs[3] += 1
regs[1] = regs[1] == regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[1] + regs[3]
regs[3] += 1
# switch
regs[3] = regs[3] + 1
regs[3] += 1
regs[2] = regs[2] + 1
regs[3] += 1
regs[1] = regs[2] > regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[3] + regs[1]
regs[3] += 1
# switch
regs[3] = 2
regs[3] += 1
regs[1] = regs[4] * regs[2]
regs[3] += 1
regs[1] = regs[1] == regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[1] + regs[3]
regs[3] += 1
# switch
regs[3] = regs[3] + 1
regs[3] += 1
regs[2] = regs[2] + 1
regs[3] += 1
regs[1] = regs[2] > regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[3] + regs[1]
regs[3] += 1
# switch
regs[3] = 2
regs[3] += 1
regs[1] = regs[4] * regs[2]
regs[3] += 1
regs[1] = regs[1] == regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[1] + regs[3]
regs[3] += 1
# switch
regs[3] = regs[3] + 1
regs[3] += 1
regs[2] = regs[2] + 1
regs[3] += 1
regs[1] = regs[2] > regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[3] + regs[1]
regs[3] += 1
# switch
regs[3] = 2
regs[3] += 1
regs[1] = regs[4] * regs[2]
regs[3] += 1
regs[1] = regs[1] == regs[5] ? 1 : 0
regs[3] += 1
# switch
regs[3] = regs[1] + regs[3]
regs[3] += 1
# switch
regs[3] = regs[3] + 1
regs[3] += 1
regs[2] = regs[2] + 1
regs[3] += 1


p regs
p regs == [0, 0, 5, 9, 1, 10551381, 0]