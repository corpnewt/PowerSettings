#!/usr/bin/env python
import os, sys, subprocess, datetime

def cls():
  	os.system('cls' if os.name=='nt' else 'clear')

def head(text = None, width = 55):
    if text == None:
        text = "Power Settings"
    cls()
    print("  {}".format("#"*width))
    mid_len = int(round(width/2-len(text)/2)-2)
    middle = " #{}{}{}#".format(" "*mid_len, text, " "*((width - mid_len - len(text))-2))
    if len(middle) > width+1:
        # Get the difference
        di = len(middle) - width
        # Add the padding for the ...#
        di += 3
        # Trim the string
        middle = middle[:-di] + "...#"
    print(middle)
    print("#"*width)

def custom_quit():
    head()
    print("by CorpNewt\n")
    print("Thanks for testing it out, for bugs/comments/complaints")
    print("send me a message on Reddit, or check out my GitHub:\n")
    print("www.reddit.com/u/corpnewt")
    print("www.github.com/corpnewt\n")
    # Get the time and wish them a good morning, afternoon, evening, and night
    hr = datetime.datetime.now().time().hour
    if hr > 3 and hr < 12:
        print("Have a nice morning!\n\n")
    elif hr >= 12 and hr < 17:
        print("Have a nice afternoon!\n\n")
    elif hr >= 17 and hr < 21:
        print("Have a nice evening!\n\n")
    else:
        print("Have a nice night!\n\n")
    exit(0)

def run(comm):
    try:
        p = subprocess.Popen(comm, shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        bd, be = p.communicate()
        bd = bd.decode("utf-8")
    except:
        bd = ""
    return bd

def grab(prompt = "Please select an option:  "):
    if sys.version_info >= (3, 0):
        return input(prompt)
    else:
        return str(raw_input(prompt))

def resize(width=80, height=24):
        print('\033[8;{};{}t'.format(height, width))

def pm_print():
    resize()
    head("Current Power Settings")
    print("")
    pm = run(["pmset","-g"])
    pmlist = [x for x in pm.split("\n") if x.startswith(" ")]
    print("\n".join(pmlist))
    print("")
    grab("Press [enter] to return...")

def disable():
    resize()
    head("Disabling...")
    print("")
    print("Hibernate...")
    run(["sudo", "pmset", "-a", "hibernatemode", "0"])
    print("Standby...")
    run(["sudo", "pmset", "-a", "standby", "0"])
    print("AutoPowerOff...")
    run(["sudo", "pmset", "-a", "autopoweroff", "0"])
    print("")
    grab("Press [enter] to return...")

def resetpm():
    resize()
    head("Reset PowerManagement")
    print("")
    found = False
    for x in os.listdir("/Library/Preferences"):
        if not x.lower().startswith("com.apple.powermanagement"):
            continue
        found = True
        print("Removing {}...".format(x))
        run(["sudo", "rm", "/Library/Preferences/{}".format(x)])
    if not found:
        print("No PowerManagement plists found.  Nothing to do.")
    print("")
    grab("Press [enter] to return...")

def remsleep():
    resize()
    head("Remove SleepImage")
    print("")
    if not os.path.exists("/var/vm/sleepimage"):
        print("Doesn't exits.  Nothing to do.")
    else:
        print("Found at /var/vm/sleepimage - removing...")
        run(["sudo", "rm", "/var/vm/sleepimage"])
    print("")
    grab("Press [enter] to return...")

def main():
    resize()
    head()
    print("")
    print("1. List pmset -g")
    print("2. Disable Hibernate, Standby, & AutoPowerOff")
    print("3. Reset PowerManagement Settings")
    print("4. Delete /var/vm/sleepimage")
    print("")
    print("Q. Quit")
    print("")
    menu = grab().lower()
    if not len(menu):
        return
    if menu == "q":
        custom_quit()
    elif menu == "1":
        pm_print()
    elif menu == "2":
        disable()
    elif menu == "3":
        resetpm()
    elif menu == "4":
        remsleep()

if __name__ == '__main__':
    while True:
        main()