import sys
import pyfiglet

if len(sys.argv) < 2:
    print("Podaj tekst jako argument")
    sys.exit(1)

text = sys.argv[1]
ascii_art = pyfiglet.figlet_format(text)
print(ascii_art)
