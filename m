From: Herve Eychenne <rv@wallfire.org>
Subject: fixes to CVS iptables.8 and ip6tables.8 man pages
Date: Tue, 3 Jun 2003 03:12:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030603011200.GF581@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6Nae48J/T25AfBN4"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

 Hi,

Michael Haardt <michael@moria.de> made the suggestion that the
assertion "every packet only passes through one of the three chains"
is wrong, since both INPUT and OUTPUT chains are involved in the case
of loopback traffic. That's a little detail, but I made it clear in
both iptables and ip6tables man pages anyway.

Tatsuo Sekine <tsekine@sdri.co.jp> submitted some cosmetic fixes for
iptables(8). I adapted them to the CVS version, and ported them to CVS
ip6tables.8


For ip6tables.8, I ported some of the fixes already applied to iptables.8
in CVS: please try to keep both manpages in sync... updating only one
of them at once is the best way to forget something and get
inconsistencies... (not a big deal here, but let's try to get the
habit to do things properly ;-)
So, here they are:
- port fix "correct manpage about information on '--syn' behaviour
  (Steve Snodgrass)", 
- Martin added as Core Team Member (Jozsef)
Other fix:
- there is no NAT for ip6tables yet: example updated accordingly.


Question:
iptables supports icmp-admin-prohibited, whereas ip6tables
icmp6-adm-prohibited (adm vs. admin).  And in ip6tables, we can find
things like addr-unreach and icmp6-addr-unreachable (unreach vs.
unreachable).  Why such name inconsistencies?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables.8.patch"

--- iptables.8.old	2003-06-02 18:43:26.000000000 +0200
+++ iptables.8.new	2003-06-02 20:00:51.000000000 +0200
@@ -91,8 +91,9 @@
 that table if it is not already there.
 
 The tables are as follows:
-.TP
-.B "filter"
+.RS
+.TP .4i
+.BR "filter" :
 This is the default table (if no -t option is passed).  It contains
 the built-in chains
 .B INPUT
@@ -102,7 +103,7 @@
 .B OUTPUT
 (for locally-generated packets).
 .TP
-.B "nat"
+.BR "nat" :
 This table is consulted when a packet that creates a new
 connection is encountered.  It consists of three built-ins:
 .B PREROUTING
@@ -112,7 +113,7 @@
 .B POSTROUTING
 (for altering packets as they are about to go out).
 .TP
-.B "mangle"
+.BR "mangle" :
 This table is used for specialized packet alteration.  Until kernel
 2.4.17 it had two built-in chains:
 .B PREROUTING
@@ -126,6 +127,7 @@
 (for altering packets being routed through the box), and
 .B POSTROUTING
 (for altering packets as they are about to go out).
+.RE
 .SH OPTIONS
 The options that are recognized by
 .B iptables
@@ -166,9 +168,9 @@
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed.  As every other iptables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
-.br
+.nf
  iptables -t nat -n -L
-.br
+.fi
 Please note that it is often used with the
 .B -n
 option, in order to avoid long reverse DNS lookups.
@@ -177,9 +179,9 @@
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
-.br
+.nf
  iptables -L -v
-.br
+.fi
 .TP
 .BR "-F, --flush " "[\fIchain\fP]"
 Flush the selected chain (all the chains in the table if none is given).
@@ -450,12 +452,13 @@
 .TP
 .BI "--helper " "string"
 Matches packets related to the specified conntrack-helper.
-.TP
+.RS
+.PP
 string can be "ftp" for packets related to a ftp-session on default port.
 For other ports append -portnr to the value, ie. "ftp-2121".
-.br
+.PP
 Same rules apply for other conntrack-helpers.
-.br
+.RE
 .SS icmp
 This extension is loaded if `--protocol icmp' is specified.  It
 provides the following option:
@@ -463,9 +466,9 @@
 .BR "--icmp-type " "[!] \fItypename\fP"
 This allows specification of the ICMP type, which can be a numeric
 ICMP type, or one of the ICMP type names shown by the command
-.br
+.nf
  iptables -p icmp -h
-.br
+.fi
 .SS length
 This module matches the length of a packet against a specific value
 or range of values.
@@ -650,9 +653,9 @@
 set.  Flags are:
 .BR "SYN ACK FIN RST URG PSH ALL NONE" .
 Hence the command
-.br
+.nf
  iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
-.br
+.fi
 will only match packets with the SYN flag set, and the ACK, FIN and
 RST flags unset.
 .TP
@@ -730,7 +733,8 @@
 .BR "-p udp" ).
 If no port range is specified, then the destination port will never be
 modified.
-.TP
+.RS
+.PP
 You can add several --to-destination options.  If you specify more
 than one destination address, either via an address range or multiple
 --to-destination options, a simple round-robin (one after another in
@@ -860,13 +864,15 @@
 .TP
 .BI "--reject-with " "type"
 The type given can be
-.BR icmp-net-unreachable ,
-.BR icmp-host-unreachable ,
-.BR icmp-port-unreachable ,
-.BR icmp-proto-unreachable ,
-.BR icmp-net-prohibited ,
-.BR "icmp-host-prohibited or"
-.BR "icmp-admin-prohibited (*)"
+.nf
+.B " icmp-net-unreachable"
+.B " icmp-host-unreachable"
+.B " icmp-port-unreachable"
+.B " icmp-proto-unreachable"
+.B " icmp-net-prohibited"
+.B " icmp-host-prohibited or"
+.B " icmp-admin-prohibited (*)"
+.fi
 which return the appropriate ICMP error message (\fBport-unreachable\fP is
 the default).  The option
 .B tcp-reset
@@ -898,7 +904,8 @@
 mapped to other ports below 512: those between 512 and 1023 inclusive
 will be mapped to ports below 1024, and other ports will be mapped to
 1024 or above. Where possible, no port alteration will occur.
-.TP
+.RS
+.PP
 You can add several --to-source options.  If you specify more
 than one source address, either via an address range or multiple
 --to-source options, a simple round-robin (one after another in
@@ -915,19 +922,25 @@
 problem are that everything works fine from your Linux
 firewall/router, but machines behind it can never exchange large
 packets:
-.br
- 1) Web browsers connect, then hang with no data received.
-.br
- 2) Small mail works fine, but large emails hang.
-.br
- 3) ssh works fine, but scp hangs after initial handshaking.
-.br
+.PD 0
+.RS 0.1i
+.TP 0.3i
+1)
+Web browsers connect, then hang with no data received.
+.TP
+2)
+Small mail works fine, but large emails hang.
+.TP
+3)
+ssh works fine, but scp hangs after initial handshaking.
+.RE
+.PD
 Workaround: activate this option and add a rule to your firewall
 configuration like:
-.br
+.nf
  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
-.br
              -j TCPMSS --clamp-mss-to-pmtu
+.fi
 .TP
 .BI "--set-mss " "value"
 Explicitly set MSS option to specified value.
@@ -944,9 +957,9 @@
 .TP
 .BI "--set-tos " "tos"
 You can use a numeric TOS values, or use
-.br
+.nf
  iptables -j TOS -h
-.br
+.fi
 to see the list of valid TOS names.
 .SS ULOG
 This target provides userspace logging of matching packets.  When this
@@ -994,7 +1007,8 @@
 .B OUTPUT
 are only traversed for packets coming into the local host and
 originating from the local host respectively.  Hence every packet only
-passes through one of the three chains; previously a forwarded packet
+passes through one of the three chains (except loopback traffic, which
+involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
 The other main difference is that
@@ -1011,13 +1025,11 @@
 optional extension modules.  This should simplify much of the previous
 confusion over the combination of IP masquerading and packet filtering
 seen previously.  So the following options are handled differently:
-.br
+.nf
  -j MASQ
-.br
  -M -S
-.br
  -M -L
-.br
+.fi
 There are several other changes in iptables.
 .SH SEE ALSO
 .BR iptables-save (8),
@@ -1052,7 +1064,6 @@
 James Morris, Harald Welte and Rusty Russell.
 .PP
 Man page written by Herve Eychenne <rv@wallfire.org>.
-
 .\" .. and did I mention that we are incredibly cool people?
 .\" .. sexy, too ..
 .\" .. witty, charming, powerful ..

--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ip6tables.8.patch"

--- ip6tables.8.old	2003-06-03 01:28:00.000000000 +0200
+++ ip6tables.8.new	2003-06-03 02:10:33.000000000 +0200
@@ -93,8 +93,9 @@
 that table if it is not already there.
 
 The tables are as follows:
-.TP
-.B "filter"
+.RS
+.TP .4i
+.BR "filter" :
 This is the default table (if no -t option is passed).  It contains
 the built-in chains
 .B INPUT
@@ -104,7 +105,7 @@
 .B OUTPUT
 (for locally-generated packets).
 .TP
-.B "mangle"
+.BR "mangle" :
 This table is used for specialized packet alteration.  Until kernel
 2.4.17 it had two built-in chains:
 .B PREROUTING
@@ -118,6 +119,7 @@
 (for altering packets being routed through the box), and
 .B POSTROUTING
 (for altering packets as they are about to go out).
+.RE
 .SH OPTIONS
 The options that are recognized by
 .B ip6tables
@@ -157,10 +159,10 @@
 .BR "-L, --list " "[\fIchain\fP]"
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed.  As every other iptables command, it applies to the
-specified table (filter is the default), so NAT rules get listed by
-.br
- iptables -t nat -n -L
-.br
+specified table (filter is the default), so mangle rules get listed by
+.nf
+ ip6tables -t mangle -n -L
+.fi
 Please note that it is often used with the
 .B -n
 option, in order to avoid long reverse DNS lookups.
@@ -169,9 +171,9 @@
 (zero) option as well, in which case the chain(s) will be atomically
 listed and zeroed.  The exact output is affected by the other
 arguments given. The exact rules are suppressed until you use
-.br
+.nf
  ip6tables -L -v
-.br
+.fi
 .TP
 .BR "-F, --flush " "[\fIchain\fP]"
 Flush the selected chain (all the chains in the table if none is given).
@@ -398,14 +400,14 @@
 set.  Flags are: 
 .BR "SYN ACK FIN RST URG PSH ALL NONE" .
 Hence the command
-.br
+.nf
  ip6tables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
-.br
+.fi
 will only match packets with the SYN flag set, and the ACK, FIN and
 RST flags unset.
 .TP
 .B "[!] --syn"
-Only match TCP packets with the SYN bit set and the ACK and FIN bits
+Only match TCP packets with the SYN bit set and the ACK and RST bits
 cleared.  Such packets are used to request TCP connection initiation;
 for example, blocking such packets coming in an interface will prevent
 incoming TCP connections, but outgoing TCP connections will be
@@ -438,9 +440,9 @@
 .BR "--icmpv6-type " "[!] \fItypename\fP"
 This allows specification of the ICMP type, which can be a numeric
 IPv6-ICMP type, or one of the IPv6-ICMP type names shown by the command
-.br
+.nf
  ip6tables -p ipv6-icmp -h
-.br
+.fi
 .SS mac
 .TP
 .BR "--mac-source " "[!] \fIaddress\fP"
@@ -607,15 +609,17 @@
 returned:
 .TP
 .BI "--reject-with " "type"
-The type given can be 
-.BR icmp6-no-route ,
-.BR no-route ,
-.BR icmp6-adm-prohibited ,
-.BR adm-prohibited ,
-.BR icmp6-addr-unreachable ,
-.BR addr-unreach ,
-.BR icmp6-port-unreachable ,
-.BR port-unreach ,
+The type given can be
+.nf
+.B " icmp6-no-route"
+.B " no-route"
+.B " icmp6-adm-prohibited"
+.B " adm-prohibited"
+.B " icmp6-addr-unreachable"
+.B " addr-unreach"
+.B " icmp6-port-unreachable"
+.B " port-unreach"
+.fi
 which return the appropriate IPv6-ICMP error message (\fBport-unreach\fP is
 the default). Finally, the option
 .B tcp-reset
@@ -751,7 +755,8 @@
 .B OUTPUT
 are only traversed for packets coming into the local host and
 originating from the local host respectively.  Hence every packet only
-passes through one of the three chains; previously a forwarded packet
+passes through one of the three chains (except loopback traffic, which
+involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
 The other main difference is that 
@@ -805,12 +810,11 @@
 .PP
 Harald Welte wrote the ULOG target, TTL match+target and libipulog.
 .PP
-The Netfilter Core Team is: Marc Boucher, Jozsef Kadlecsik, James Morris,
-Harald Welte and Rusty Russell.
+The Netfilter Core Team is: Marc Boucher, Jozsef Kadlecsik, Jozsef Kadlecsik,
+James Morris, Harald Welte and Rusty Russell.
 .PP
 ip6tables man page created by Andras Kis-Szabo, based on
 iptables man page written by Herve Eychenne <rv@wallfire.org>.
-
 .\" .. and did I mention that we are incredibly cool people?
 .\" .. sexy, too ..
 .\" .. witty, charming, powerful ..

--6Nae48J/T25AfBN4--
