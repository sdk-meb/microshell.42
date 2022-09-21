#!/bin/bash

test_line () {
	echo $@
	echo $@ >> $outres
	./$SHELL $@ >> $outres &
	sleep .250
	echo >> $outres
	leaks $SHELL > $leaksres 2> /dev/null
	if grep "ROOT LEAK" < $leaksres > /dev/null 2> /dev/null ; then
		printf "\e[0;31mLEAKS\n\e[0m"
	fi
	pid=$( pgrep $SHELL )

	printf "\e[0;31m"
	lsof -c $SHELL | grep $pid | grep -v cwd | grep -v txt | grep -v 0r | grep -v 1w | grep -v 2u | grep $SHELL

	printf "\e[0m"
	kill -9 $pid
	wait $pid 2>/dev/null
	cat -e $outres > $outres.l
}

test_()
{
	
	rm -f $outres $leaksres $outres.l
	test_line /bin/ls
	test_line /bin/cat microshell.c
	test_line /bin/ls microshell.c
	test_line /bin/ls salut
	test_line ";"
	test_line ";" ";"
	test_line ";" ";" /bin/echo OK
	test_line ";" ";" /bin/echo OK ";"
	test_line ";" ";" /bin/echo OK ";" ";"
	test_line ";" ";" /bin/echo OK ";" ";" ";" /bin/echo OK
	test_line /bin/ls "|" /usr/bin/grep microshell
	test_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro
	test_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro
	test_line /bin/ls "|" /usr/bin/grep microshell "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep micro "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell "|" /usr/bin/grep shell
	test_line /bin/ls ewqew "|" /usr/bin/grep micro "|" /bin/cat -n ";" /bin/echo dernier ";" /bin/echo
	test_line /bin/ls "|" /usr/bin/grep micro "|" /bin/cat -n ";" /bin/echo dernier ";" /bin/echo ftest ";"
	test_line /bin/echo ftest ";" /bin/echo ftewerwerwerst ";" /bin/echo werwerwer ";" /bin/echo qweqweqweqew ";" /bin/echo qwewqeqrtregrfyukui ";"
	test_line /bin/ls ftest ";" /bin/ls ";" /bin/ls werwer ";" /bin/ls microshell.c ";" /bin/ls subject.fr.txt ";"
	test_line /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";" /bin/ls "|" /usr/bin/grep micro ";"
	test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b ";" /bin/cat subject.fr.txt ";"
	test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep w ";" /bin/cat subject.fr.txt ";"
	test_line /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep w ";" /bin/cat subject.fr.txt
	test_line /bin/cat subject.fr.txt ";" /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b "|" /usr/bin/grep z ";" /bin/cat subject.fr.txt
	test_line ";" /bin/cat subject.fr.txt ";" /bin/cat subject.fr.txt "|" /usr/bin/grep a "|" /usr/bin/grep b "|" /usr/bin/grep z ";" /bin/cat subject.fr.txt
	test_line blah "|" /bin/echo OK
	test_line blah "|" /bin/echo OK ";"
	printf "\e[1;32mDone\e[0m\n"
	rm -rf microshell.dSYM $leaksres
}
SHELL=microshell
outres=out
leaksres=lres
printf "\e[1;32mCompile\n"
gcc -g -Wall -Werror -Wextra -DTEST_SH "$SHELL".c -o "$SHELL"
test_
rm -rf $SHELL
printf "\e[1;36mTest\n\e[0m"

SHELL=amicroshell
outres=aout
leaksres=alres
printf "\e[1;32mCompile\n"
rm -rf $SHELL
gcc -g -Wall -Werror -Wextra -DTEST_SH "$SHELL".c -o "$SHELL"
test_
rm -rf $SHELL
printf "\e[1;36mTest\n\e[0m"

SHELL=bmicroshell
outres=bout
leaksres=blres
printf "\e[1;32mCompile\n"
rm -rf $SHELL
gcc -g -Wall -Werror -Wextra -DTEST_SH "$SHELL".c -o "$SHELL"
test_
rm -rf $SHELL
printf "\e[1;36mTest\n\e[0m"
