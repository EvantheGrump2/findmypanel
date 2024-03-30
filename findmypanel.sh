echo Updating...
wget -q -O iplist.txt https://github.com/EvantheGrump2/findmypanel/releases/latest/download/iplist.txt
rm output.html 2> /dev/null
echo '<html><body>' > output.html
for tests in google.com yahoo.com duckduckgo.com
  do
	if curl -m 3 -Is $tests >/dev/null
	 then
		echo 'sanity ping ('$tests') - connected'
	 else
		echo 'sanity ping ('$tests') - failure!'
		echo 'Are you connected to the internet?'
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
echo 'check complete, starting scanning'
for ips in $(cat iplist.txt)
  do
	if curl -m 1 -Is $ips >/dev/null
	 then
		echo -n ''$ips' - success     \r'
 		echo '<a href="https://'$ips'" target="_blank">'$ips'</a>' >> output.html
		echo '<a href="http://'$ips'" target="_blank">(http)</a><br>' >> output.html
	 else
 		echo -n ''$ips' - fail       \r'
	fi
  done
echo 'Done ✓                         '
echo 'opening report'
if grep -q "1" "output.html"
  then
	echo hi > /dev/null
  else
        echo 'no hits ):' >> output.html
fi
xdg-open output.html > /dev/null
exit
