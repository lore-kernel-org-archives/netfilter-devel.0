From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] manpages for 17 modules
Date: Sat, 26 Mar 2005 16:00:30 +0200
Message-ID: <42456AFE.7010000@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060306030307090808010201"
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060306030307090808010201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I sat down and put together man pages for most modules that were lacking one.

Most modules (that are affected by my patches) didn't have a manpage, with
the exception of owner-socketlookup and ownercmd. These two add to already
existing functionality, so for them I added iptables.patch in their pom-ng
directory instead so the missing stuff gets patched into the already
existing manpages in the iptables directory.

Also, the "comment" match had an libipt_comment.c both in iptables and
patch-o-matic-ng so I also added the man page into both locations.

The manpages were constructed mostly based on the "help" files and
commandline help texts from libipt_*.c source files. I also added some
wording of my own where I felt it was appropriate.

The patches only add new files, no modifications to existing files were made.

I hope you (netfilter maintainers) don't mind that I didn't provide the
manpages as separate patches or as a .tar.gz. I can still do that if you
feel like it.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCRWr6xyF48ZTvn+4RAglkAKDijTnmz4BwYmHDRrKj5qXpWblPLACeMvcv
3mRmojLhK5v1yxlQuw+cntA=
=6pAe
-----END PGP SIGNATURE-----

--------------060306030307090808010201
Content-Type: text/x-patch;
 name="xkr47-iptables-manpages-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xkr47-iptables-manpages-1.patch"

Index: iptables/extensions/libipt_IPMARK.man
===================================================================
--- iptables/extensions/libipt_IPMARK.man	(revision 0)
+++ iptables/extensions/libipt_IPMARK.man	(revision 0)
@@ -0,0 +1,45 @@
+Allows you to mark a received packet basing on its IP address. This
+can replace many mangle/mark entries with only one, if you use
+firewall based classifier.
+
+This target is to be used inside the mangle table, in the PREROUTING,
+POSTROUTING or FORWARD hooks.
+.TP
+.BI "--addr " "src/dst"
+Use source or destination IP address.
+.TP
+.BI "--and-mask " "mask"
+Perform bitwise `and' on the IP address and this mask.
+.TP
+.BI "--or-mask " "mask"
+Perform bitwise `or' on the IP address and this mask.
+.P
+The order of IP address bytes is reversed to meet "human order of bytes":
+192.168.0.1 is 0xc0a80001. At first the `and' operation is performed, then
+`or'.
+
+Examples:
+
+We create a queue for each user, the queue number is adequate
+to the IP address of the user, e.g.: all packets going to/from 192.168.5.2
+are directed to 1:0502 queue, 192.168.5.12 -> 1:050c etc.
+
+We have one classifier rule:
+.IP
+tc filter add dev eth3 parent 1:0 protocol ip fw
+.P
+Earlier we had many rules just like below:
+.IP
+iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.2 -j MARK
+--set-mark 0x10502
+.IP
+iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.3 -j MARK
+--set-mark 0x10503
+.P
+Using IPMARK target we can replace all the mangle/mark rules with only one:
+.IP
+iptables -t mangle -A POSTROUTING -o eth3 -j IPMARK --addr=dst
+--and-mask=0xffff --or-mask=0x10000
+.P
+On the routers with hundreds of users there should be significant load
+decrease (e.g. twice).
Index: iptables/extensions/libipt_IPV4OPTSSTRIP.man
===================================================================
--- iptables/extensions/libipt_IPV4OPTSSTRIP.man	(revision 0)
+++ iptables/extensions/libipt_IPV4OPTSSTRIP.man	(revision 0)
@@ -0,0 +1,5 @@
+Strip all the IP options from a packet.
+
+The target doesn't take any option, and therefore is extremly easy to use :
+
+# iptables -t mangle -A PREROUTING -j IPV4OPTSSTRIP
Index: iptables/extensions/libipt_SAME.man
===================================================================
--- iptables/extensions/libipt_SAME.man	(revision 0)
+++ iptables/extensions/libipt_SAME.man	(revision 0)
@@ -0,0 +1,11 @@
+Similar to SNAT/DNAT depending on chain: it takes a range of addresses
+(`--to 1.2.3.4-1.2.3.7') and gives a client the same
+source-/destination-address for each connection.
+.TP
+.BI "--to " "<ipaddr>-<ipaddr>"
+Addresses to map source to. May be specified more than once for
+multiple ranges.
+.TP
+.B "--nodst"
+Don't use the destination-ip in the calculations when selecting the
+new source-ip
Index: iptables/extensions/libipt_TARPIT.man
===================================================================
--- iptables/extensions/libipt_TARPIT.man	(revision 0)
+++ iptables/extensions/libipt_TARPIT.man	(revision 0)
@@ -0,0 +1,34 @@
+Captures and holds incoming TCP connections using no local
+per-connection resources. Connections are accepted, but immediately
+switched to the persist state (0 byte window), in which the remote
+side stops sending data and asks to continue every 60-240 seconds.
+Attempts to close the connection are ignored, forcing the remote side
+to time out the connection in 12-24 minutes.
+
+This offers similar functionality to LaBrea
+<http://www.hackbusters.net/LaBrea/> but doesn't require dedicated
+hardware or IPs. Any TCP port that you would normally DROP or REJECT
+can instead become a tarpit.
+
+To tarpit connections to TCP port 80 destined for the current machine:
+.IP
+iptables -A INPUT -p tcp -m tcp --dport 80 -j TARPIT
+.P
+To significantly slow down Code Red/Nimda-style scans of unused address
+space, forward unused ip addresses to a Linux box not acting as a router
+(e.g. "ip route 10.0.0.0 255.0.0.0 ip.of.linux.box" on a Cisco), enable IP
+forwarding on the Linux box, and add:
+.IP
+iptables -A FORWARD -p tcp -j TARPIT
+.IP
+iptables -A FORWARD -j DROP
+.TP
+NOTE:
+If you use the conntrack module while you are using TARPIT, you should
+also use the NOTRACK target, or the kernel will unnecessarily allocate
+resources for each TARPITted connection. To TARPIT incoming
+connections to the standard IRC port while using conntrack, you could:
+.IP
+iptables -t raw -A PREROUTING -p tcp --dport 6667 -j NOTRACK
+.IP
+iptables -A INPUT -p tcp --dport 6667 -j TARPIT
Index: iptables/extensions/libipt_XOR.man
===================================================================
--- iptables/extensions/libipt_XOR.man	(revision 0)
+++ iptables/extensions/libipt_XOR.man	(revision 0)
@@ -0,0 +1,7 @@
+Encrypt TCP and UDP traffic using a simple XOR encryption
+.TP
+.BI "--key " "string"
+Set key to "string"
+.TP
+.BI "--block-size"
+Set block size
Index: iptables/extensions/libipt_account.man
===================================================================
--- iptables/extensions/libipt_account.man	(revision 0)
+++ iptables/extensions/libipt_account.man	(revision 0)
@@ -0,0 +1,47 @@
+Account traffic for all hosts in defined network/netmask.
+
+Features:
+
+- long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics
+
+- one iptables rule for all hosts in network/netmask
+
+- loading/saving counters (by reading/writting to procfs entries)
+
+.TP
+.BI "--aaddr " "network/netmask"
+defines network/netmask for which make statistics.
+.TP
+.BI "--aname " "name"
+defines name of list where statistics will be kept. If no is
+specified DEFAULT will be used.
+.TP
+.B "--ashort"
+table will colect only short statistics (only total counters
+without splitting it into protocols.
+.P
+Example usage:
+
+account traffic for/to 192.168.0.0/24 network into table mynetwork:
+
+# iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24
+
+account traffic for/to WWW serwer for 192.168.0.0/24 network into table mywwwserver:
+
+# iptables -A INPUT -p tcp --dport 80
+  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+
+# iptables -A OUTPUT -p tcp --sport 80
+  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+
+read counters:
+
+# cat /proc/net/ipt_account/mynetwork
+# cat /proc/net/ipt_account/mywwwserver
+
+set counters:
+
+# echo "ip = 192.168.0.1 packets_src = 0" > /proc/net/ipt_account/mywwserver
+
+Webpage:
+  http://www.barbara.eu.org/~quaker/ipt_account/
Index: iptables/extensions/libipt_comment.man
===================================================================
--- iptables/extensions/libipt_comment.man	(revision 0)
+++ iptables/extensions/libipt_comment.man	(revision 0)
@@ -0,0 +1,6 @@
+Allows you to add comments (up to 256 characters) to any rule.
+.TP
+.BI "--comment " "comment"
+.TP
+Example:
+iptables -A INPUT -s 192.168.0.0/16 -m comment --comment "A privatized IP block"
Index: iptables/extensions/libipt_connbytes.man
===================================================================
--- iptables/extensions/libipt_connbytes.man	(revision 0)
+++ iptables/extensions/libipt_connbytes.man	(revision 0)
@@ -0,0 +1,30 @@
+Match by how many bytes or packets a connection (or one of the two
+flows constituting the connection) have tranferred so far, or by
+average bytes per packet.
+
+The counters are 64bit and are thus not expected to overflow ;)
+
+The primary use is to detect long-lived downloads and mark them to be
+scheduled using a lower priority band in traffic control.
+
+The transfered bytes per connection can also be viewed through
+/proc/net/ip_conntrack and accessed via ctnetlink
+.TP
+[\fB!\fR]\fB --connbytes \fIfrom\fB:\fR[\fIto\fR]
+match packets from a connection whose packets/bytes/average packet
+size is more than FROM and less than TO bytes/packets. if TO is
+omitted only FROM check is done. "!" is used to match packets not
+falling in the range.
+.TP
+\fB--connbytes-dir\fR [\fBoriginal\fR|\fBreply\fR|\fBboth\fR]
+which packets to consider
+.TP
+\fB--connbytes-mode\fR [\fBpackets\fR|\fBbytes\fR|\fBavgpkt\fR]
+whether to check the amount of packets, number of bytes transferred or
+the average size (in bytes) of all packets received so far. Note that
+when "both" is used together with "avgpkt", and data is going (mainly)
+only in one direction (for example HTTP), the average packet size will
+be about half of the actual data packets.
+.TP
+Example:
+iptables .. -m connbytes --connbytes 10000:100000 --connbytes-dir both --connbytes-mode bytes ...
Index: iptables/extensions/libipt_connlimit.man
===================================================================
--- iptables/extensions/libipt_connlimit.man	(revision 0)
+++ iptables/extensions/libipt_connlimit.man	(revision 0)
@@ -0,0 +1,21 @@
+Allows you to restrict the number of parallel TCP connections to a
+server per client IP address (or address block).
+.TP
+[\fB!\fR] \fB--connlimit-above \fIn\fR
+match if the number of existing tcp connections is (not) above n
+.TP
+.BI "--connlimit-mask " "bits"
+group hosts using mask
+.P
+Examples:
+.TP
+# allow 2 telnet connections per client host
+iptables -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+.TP
+# you can also match the other way around:
+iptables -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+.TP
+# limit the nr of parallel http requests to 16 per class C sized \
+network (24 bit netmask)
+iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
+--connlimit-mask 24 -j REJECT
Index: iptables/extensions/libipt_hashlimit.man
===================================================================
--- iptables/extensions/libipt_hashlimit.man	(revision 0)
+++ iptables/extensions/libipt_hashlimit.man	(revision 0)
@@ -0,0 +1,35 @@
+This patch adds a new match called 'hashlimit'.
+The idea is to have something like 'limit', but either per
+destination-ip or per (destip,destport) tuple.
+
+It gives you the ability to express
+.IP
+ '1000 packets per second for every host in 192.168.0.0/16'
+.IP
+ '100 packets per second for every service of 192.168.1.1'
+.P
+with a single iptables rule.
+.TP
+.BI "--hashlimit " "rate"
+A rate just like the limit match
+.TP
+.BI "--hashlimit-burst " "num"
+Burst value, just like limit match
+.TP
+.BI "--hashlimit-mode " "destip | destip-destport"
+Limit per IP or per port
+.TP
+.BI "--hashlimit-name " "foo"
+The name for the /proc/net/ipt_hashlimit/foo entry
+.TP
+.BI "--hashlimit-htable-size " "num"
+The number of buckets of the hash table
+.TP
+.BI "--hashlimit-htable-max " "num"
+Maximum entries in the hash
+.TP
+.BI "--hashlimit-htable-expire " "num"
+After how many miliseconds do hash entries expire
+.TP
+.BI "--hashlimit-htable-gcinterval " "num"
+How many miliseconds between garbage collection intervals
Index: iptables/extensions/libipt_osf.man
===================================================================
--- iptables/extensions/libipt_osf.man	(revision 0)
+++ iptables/extensions/libipt_osf.man	(revision 0)
@@ -0,0 +1,47 @@
+The idea of passive OS fingerprint matching exists for quite a long time,
+but was created as extension fo OpenBSD pf only some weeks ago.
+Original idea was lurked in some OpenBSD mailing list (thanks
+grange@open...) and than adopted for Linux netfilter in form of this code.
+
+Original fingerprint table was created by Michal Zalewski <lcamtuf@coredump.cx>.
+
+This module compares some data(WS, MSS, options and it's order, ttl,
+df and others) from first SYN packet (actually from packets with SYN
+bit set) with dynamically loaded OS fingerprints.
+.TP
+.B "--log 1/0" 
+If present, OSF will log determined genres even if they don't match
+desired one.	
+0 - log all determined entries, 
+1 - only first one.
+
+In syslog you find something like this:
+.IP
+ipt_osf: Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 -> 11.22.33.44:139
+.IP
+ipt_osf: Unknown: 16384:106:1:48:020405B401010402 44.33.22.11:1239 -> 11.22.33.44:80
+.TP
+.B "--smart"
+if present, OSF will use some smartness to determine remote OS.
+OSF will use initial TTL only if source of connection is in our local network.
+.TP
+.B "--netlink"
+If present, OSF will log all events also through netlink NETLINK_NFLOG groupt 1.
+.TP
+.BI "--genre " "[!] string"
+Match a OS genre by passive fingerprinting
+.P
+Example:
+
+#iptables -I INPUT -j ACCEPT -p tcp -m osf --genre Linux --log 1 --smart
+
+NOTE: -p tcp is obviously required as it is a TCP match.
+
+Fingerprints can be loaded and read through /proc/sys/net/ipv4/osf file.
+One can flush all fingerprints with following command:
+.IP
+echo -en FLUSH > /proc/sys/net/ipv4/osf
+.P
+Only one fingerprint per open/write/close.
+
+Fingerprints can be downloaded from http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os
Index: iptables/extensions/libipt_psd.man
===================================================================
--- iptables/extensions/libipt_psd.man	(revision 0)
+++ iptables/extensions/libipt_psd.man	(revision 0)
@@ -0,0 +1,18 @@
+Attempt to detect TCP and UDP port scans. This match was derived from
+Solar Designer's scanlogd.
+.TP
+.BI "--psd-weight-threshold " "threshold"
+Total weight of the latest TCP/UDP packets with different
+destination ports coming from the same host to be treated as port
+scan sequence.
+.TP
+.BI "--psd-delay-threshold " "delay"
+Delay (in hundredths of second) for the packets with different
+destination ports coming from the same host to be treated as
+possible port scan subsequence.
+.TP
+.BI "--psd-lo-ports-weight " "weight"
+Weight of the packet with privileged (<=1024) destination port.
+.TP
+.BI "--psd-hi-ports-weight " "weight"
+Weight of the packet with non-priviliged destination port.
Index: iptables/extensions/libipt_sctp.man
===================================================================
--- iptables/extensions/libipt_sctp.man	(revision 0)
+++ iptables/extensions/libipt_sctp.man	(revision 0)
@@ -0,0 +1,28 @@
+.TP
+\fB--source-port\fR,\fB--sport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+.TP
+\fB--destination-port\fR,\fB--dport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+.TP
+\fB--chunk-types\fR [\fB!\fR] \fBall\fR|\fBany\fR|\fBonly \fIchunktype\fR[\fB:\fIflags\fR] [...]
+The flag letter in upper case indicates that the flag is to match if set,
+in the lower case indicates to match if unset.
+
+Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK
+
+chunk type            available flags      
+.br
+DATA                  U B E u b e         
+.br
+ABORT                 T t                 
+.br
+SHUTDOWN_COMPLETE     T t                 
+
+(lowercase means flag should be "off", uppercase means "on")
+.P
+Examples:
+
+iptables -A INPUT -p sctp --dport 80 -j DROP
+
+iptables -A INPUT -p sctp --chunk-types any DATA,INIT -j DROP
+
+iptables -A INPUT -p sctp --chunk-types any DATA:Be -j ACCEPT
Index: iptables/extensions/libipt_u32.man
===================================================================
--- iptables/extensions/libipt_u32.man	(revision 0)
+++ iptables/extensions/libipt_u32.man	(revision 0)
@@ -0,0 +1,8 @@
+U32 allows you to extract quantities of up to 4 bytes from a packet,
+AND them with specified masks, shift them by specified amounts and
+test whether the results are in any of a set of specified ranges.
+The specification of what to extract is general enough to skip over
+headers with lengths stored in the packet, as in IP or TCP header
+lengths.
+
+Details and examples are in the kernel module source.

--------------060306030307090808010201
Content-Type: text/x-patch;
 name="xkr47-pom-manpages-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xkr47-pom-manpages-1.patch"

Index: patch-o-matic/comment/iptables/extensions/libipt_comment.man
===================================================================
--- patch-o-matic/comment/iptables/extensions/libipt_comment.man	(revision 0)
+++ patch-o-matic/comment/iptables/extensions/libipt_comment.man	(revision 0)
@@ -0,0 +1,6 @@
+Allows you to add comments (up to 256 characters) to any rule.
+.TP
+.BI "--comment " "comment"
+.TP
+Example:
+iptables -A INPUT -s 192.168.0.0/16 -m comment --comment "A privatized IP block"
Index: patch-o-matic/geoip/iptables/extensions/libipt_geoip.man
===================================================================
--- patch-o-matic/geoip/iptables/extensions/libipt_geoip.man	(revision 0)
+++ patch-o-matic/geoip/iptables/extensions/libipt_geoip.man	(revision 0)
@@ -0,0 +1,15 @@
+Match a packet by its source or destination country.
+.TP
+[\fB!\fR] \fB--src-cc\fR, \fB--source-country \fIcountry\fR[\fB,\fIcountry\fB,\fIcountry\fB,\fI...\fR]
+Match packet coming from (one of) the specified country(ies)
+.TP
+[\fB!\fR] \fB--dst-cc\fR, \fB--destination-country \fIcountry\fR[\fB,\fIcountry\fB,\fIcountry\fB,\fI...\fR]
+Match packet going to (one of) the specified country(ies)
+.TP
+NOTE:
+The country is inputed by its ISO3166 code.
+.P
+The only extra files you need is a binary db (geoipdb.bin) & its index file (geoipdb.idx).
+Both files are generated from a countries & subnets database with the csv2bin tool,
+available at www.cookinglinux.org/geoip/. Both files MUST also be moved in /var/geoip/
+as the shared library is statically looking for that pathname (ex.: /var/geoip/geoipdb.bin).
Index: patch-o-matic/owner-socketlookup/iptables.patch
===================================================================
--- patch-o-matic/owner-socketlookup/iptables.patch	(revision 0)
+++ patch-o-matic/owner-socketlookup/iptables.patch	(revision 0)
@@ -0,0 +1,16 @@
+--- orig-iptables/extensions/libipt_owner.man	2004-10-10 12:56:26.000000000 +0300
++++ iptables/extensions/libipt_owner.man	2005-03-26 12:45:15.000000000 +0200
+@@ -1,8 +1,9 @@
+ This module attempts to match various characteristics of the packet
+-creator, for locally-generated packets.  It is only valid in the
+-.B OUTPUT
+-chain, and even this some packets (such as ICMP ping responses) may
+-have no owner, and hence never match.
++creator, for locally-generated packets. It is valid in the
++\fBINPUT\fR, \fBOUTPUT\fR and \fBPOSTROUTING\fR chains, however in the
++\fBINPUT\fR chain only TCP and UDP packets can be matched. Also note
++that some packets (such as ICMP ping responses) may have no owner, and
++hence never match.
+ .TP
+ .BI "--uid-owner " "userid"
+ Matches if the packet was created by a process with the given
Index: patch-o-matic/ownercmd/iptables.patch
===================================================================
--- patch-o-matic/ownercmd/iptables.patch	(revision 0)
+++ patch-o-matic/ownercmd/iptables.patch	(revision 0)
@@ -0,0 +1,12 @@
+--- orig-iptables/extensions/libip6t_owner.man	2004-10-10 12:56:24.000000000 +0300
++++ iptables/extensions/libip6t_owner.man	2005-03-26 12:53:03.000000000 +0200
+@@ -20,4 +20,9 @@
+ Matches if the packet was created by a process in the given session
+ group.
+ .TP
++.BI "--cmd-owner " "name"
++Matches if the packet was created by a process with the given command name.
++(this option is present only if iptables was compiled under a kernel
++supporting this feature)
++.TP
+ .B NOTE: pid, sid and command matching are broken on SMP

--------------060306030307090808010201--
