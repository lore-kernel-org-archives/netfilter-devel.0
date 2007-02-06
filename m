From: esr@thyrsus.com
Subject: problems in ip6tables.8, iptables.8
Date: Tue, 6 Feb 2007 16:11:36 -0500
Message-ID: <200702062111.l16LBa17008184@snark.thyrsus.com>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is automatically generated email about problems in a man page for which
you appear to be responsible.  If you are not the right person or list, tell
me and I will attempt to correct my database.

See http://catb.org/~esr/doclifter/problems.html for details on how and
why these patches were generated.  Feel free to email me with any questions.
Note: These patches do not change the mod date of any manual page.  You
may wish to do that by hand.

Problems with ip6tables.8:

1. List syntax error. This means .IP, .TP or .RS/.RE markup is garbled.
This confuses doclifter, and may also mess up stricter troff
interpreters like Xman and Rosetta.

--- ip6tables.8-orig	2007-01-27 04:18:31.000000000 -0500
+++ ip6tables.8	2007-01-27 04:19:24.000000000 -0500
@@ -322,9 +322,9 @@
 sense is inverted.  If the interface name ends in a "+", then any
 interface which begins with this name will match.  If this option is
 omitted, any interface name will match.
-.TP
 .\" Currently not supported (header-based)
 .\" 
+.\" .TP
 .\" .B "[!] " "-f, --fragment"
 .\" This means that the rule only refers to second and further fragments
 .\" of fragmented packets.  Since there is no way to tell the source or
@@ -332,7 +332,7 @@
 .\" not match any rules which specify them.  When the "!" argument
 .\" precedes the "-f" flag, the rule will only match head fragments, or
 .\" unfragmented packets.
-.\" .TP
+.TP
 .B "-c, --set-counters " "PKTS BYTES"
 This enables the administrator to initialize the packet and byte
 counters of a rule (during
@@ -635,7 +635,7 @@
 .BI "--sid-owner " "sessionid"
 Matches if the packet was created by a process in the given session
 group.
-.TP
+.PP
 .B NOTE: pid, sid and command matching are broken on SMP
 .SS physdev
 This module matches on the bridge port input and output devices enslaved
-----------------------------
Problems with iptables.8:

1. Ambiguous or invalid backslash.  This doesn't cause groff a problem.
but it confuses doclifter and may confuse older troff implementations.

2. List syntax error. This means .IP, .TP or .RS/.RE markup is garbled.
This confuses doclifter, and may also mess up stricter troff
interpreters like Xman and Rosetta.

--- iptables.8-orig	2007-01-27 20:10:23.000000000 -0500
+++ iptables.8	2007-01-27 20:11:20.000000000 -0500
@@ -649,7 +649,7 @@
 list of packet types.  Packet types are: 
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID" .
 .TP
-\fB--dccp-option\fR [\fB!\fR\] \fInumber\fP
+\fB--dccp-option\fR [\fB!\fR] \fInumber\fP
 Match if DCP option set.
 .SS dscp
 This module matches the 6 bit DSCP field within the TOS field in the
@@ -996,7 +996,7 @@
 Matches if the packet was created by a process with the given command name.
 (this option is present only if iptables was compiled under a kernel
 supporting this feature)
-.TP
+.PP
 .B NOTE: pid, sid and command matching are broken on SMP
 .SS physdev
 This module matches on the bridge port input and output devices enslaved
@@ -1744,8 +1744,8 @@
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.TP
-(*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
+.IP *
+Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
 .SS ROUTE
 This is used to explicitly override the core network stack's routing decision.
 .B mangle
@@ -1898,7 +1898,7 @@
 .TP
 .B "--clamp-mss-to-pmtu"
 Automatically clamp MSS value to (path_MTU - 40).
-.TP
+.PP
 These options are mutually exclusive.
 .SS TOS
 This is used to set the 8-bit Type of Service field in the IP header.
-----------------------------

--
                             Eric S. Raymond
