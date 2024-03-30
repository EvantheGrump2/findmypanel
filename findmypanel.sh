wget https://github.com/EvantheGrump2/findmypanel/blob/main/iplist.txt
rm output.html 2> /dev/null
echo '<html><body>' > output.html
for tests in google.com yahoo.com duckduckgo.com
  do
	if curl -m 1 -Is $tests >/dev/null
	 then
		echo '\e[1;37msanity ping ('$tests') - \e[1;32mconnected'
	 else
		echo '\e[1;33msanity ping ('$tests') - \e[1;31mfailure!'
		echo '\e[1;33mAre you connected to the internet?\033[0m'
		read -r -p "Continue anyway? {y/N} " response
		case "$response" in
		[yY][eE][sS]|[yY])
		\
		;;
		*)
		echo bye bye
		exit
		;;
		esac
	fi
  done
echo '\e[1;37mcheck complete, starting scanning'
for ips in $(cat iplist.txt)
  do
	if curl -m 1 -Is $ips >/dev/null
	 then
		echo -n '\e[1;37m'$ips' -  \e[1;32msuccess     \r'
 		echo '<a href="https://'$ips'" target="_blank">'$ips'</a>' >> output.html
		echo '<a href="http://'$ips'" target="_blank">(http)</a><br>' >> output.html
	 else
 		echo -n '\e[1;37m'$ips' - \e[1;31mfail       \r'
	fi
  done
echo '\e[1;37mDone \e[1;32m✓                         '
echo '\e[1;37mopening report'
if grep -q "1" "output.html"
  then
	echo hi > /dev/null
  else
        echo 'no hits ):' >> output.html
fi
x-www-browser output.html > /dev/null
exit
