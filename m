From: George Vieira <GeorgeV@citadelcomputer.com.au>
Subject: iptables -L command and other sugestions.
Date: Fri, 5 Jul 2002 14:35:39 +1000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200FAA488DE0D41194F10010B597610D2BA248@JUPITER>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'netfilter-devel@lists.samba.org'" <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Firstly awesome job on iptables/netfilter..

1st Request/Suggestion: I would like to know if it's at all possible that
the same/similar code you guys use to track and delete a rule "iptables -D
INPUT {options}" can also be used when listing a rule instead of listing the
WHOLE table?
I am currently using a PHP script to do this.. ie.
"php -q /root/bin/mrtg-iptables.php --ifout eth0 --prot tcp --dest
10.10.0.130 --sport 3128 --table HOSTS"
But embedded would be great and much faster to search as I know no other way
than filtering it out which is slow and cpu chewy..

2nd Request/Suggestion: If there is any way to make the tables save their
byte/packet count to a DB file and reread back again for the sake of
rerunning the rules.. it checks if the rule exists in the DB and reads the
count.. if none there, set it to 0. If a special iptables switch is sent
it'll clear any rules not added/matched incase some rules where removed
previously.
This would be great as I use the byte count for download checks and I can't
rerun the rules and have to manually -I or -D them because -F and then -A
just resets the count. This would be great for ISPs I would guess.
Again at the moment I'm using PHP scripts to save all rules (-L-v-x-n) to a
/var/log/iptables.db file on stop/start and when adding it checks it against
the file and adds to it until I reset the DB.. a real pain but it's in the
works so far..

3rd Request/Suggestion: Last one, trust me ;)  Sounds a bit script if too
many fired off but is it possible to fire off a command on matched rules? Of
course this could kill a server if nmap was used or something but with
careful planning using --limit etc.. this would make some things easy.. I
only know of doing something like    `tail -f /var/log/kernel | grep
"IPTINPUT" | myscript` which handles search rules..

Sorry if this isn't the right place or the suggestions are pretty lame..
it'll just help me a sh$@ load..

thanks,
George Vieira
Systems Manager
Citadel Computer Systems P/L
http://www.citadelcomputer.com.au
