def main():
    startInterval = 100
    while startInterval > 0:
        if startInterval % 5 == 0:
            print('Agile')
        elif startInterval % 3 == 0:
            print('Software')
        elif startInterval % 3 == 0 and startInterval % 5 == 0:
            print('Testing')
        else:
            print(startInterval)
        startInterval -= 1

if __name__ == "__main__":
    main()