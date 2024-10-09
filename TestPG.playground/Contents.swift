var a = 0
for i in [1, 2, 3, 4, 5] {
    print ("i = \(i)")
    for j in [6, 7, 8, 9] {
        print ("j = \(j)")
        if i == 4 {
            if j == 8 {
                break
            }
            break
        }
    }
}
