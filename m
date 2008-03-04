From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 18/24] Combine ipt and ip6t manpages
Date: Tue, 4 Mar 2008 17:11:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041711010.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36680 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591AbYCDQLk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:11:40 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 12c2ea7de631d24821c2c988cc3c55d9aa03aaab
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 03:02:55 2008 +0100

    Combine ipt and ip6t manpages
---
 extensions/libip6t_TCPMSS.man                      |   42 -----------
 extensions/libip6t_connlimit.man                   |   27 -------
 extensions/libip6t_length.man                      |    4 -
 extensions/libip6t_multiport.man                   |   20 -----
 extensions/libip6t_tcp.man                         |   45 ------------
 extensions/libipt_TRACE.man                        |   10 ---
 extensions/libipt_length.man                       |    4 -
 extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} |    8 ++-
 extensions/{libip6t_TRACE.man => libxt_TRACE.man}  |    3 +-
 .../{libipt_connlimit.man => libxt_connlimit.man}  |    0 
 extensions/libxt_length.man                        |    5 ++
 .../{libipt_multiport.man => libxt_multiport.man}  |    0 
 extensions/{libipt_tcp.man => libxt_tcp.man}       |    0 
 13 files changed, 12 insertions(+), 156 deletions(-)
 delete mode 100644 extensions/libip6t_TCPMSS.man
 delete mode 100644 extensions/libip6t_connlimit.man
 delete mode 100644 extensions/libip6t_length.man
 delete mode 100644 extensions/libip6t_multiport.man
 delete mode 100644 extensions/libip6t_tcp.man
 delete mode 100644 extensions/libipt_TRACE.man
 delete mode 100644 extensions/libipt_length.man
 rename extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} (77%)
 rename extensions/{libip6t_TRACE.man => libxt_TRACE.man} (94%)
 rename extensions/{libipt_connlimit.man => libxt_connlimit.man} (100%)
 create mode 100644 extensions/libxt_length.man
 rename extensions/{libipt_multiport.man => libxt_multiport.man} (100%)
 rename extensions/{libipt_tcp.man => libxt_tcp.man} (100%)

diff --git a/extensions/libip6t_TCPMSS.man b/extensions/libip6t_TCPMSS.man
deleted file mode 100644
index b4c357e..0000000
--- a/extensions/libip6t_TCPMSS.man
+++ /dev/null
@@ -1,42 +0,0 @@
-This target allows to alter the MSS value of TCP SYN packets, to control
-the maximum size for that connection (usually limiting it to your
-outgoing interface's MTU minus 60).  Of course, it can only be used
-in conjunction with
-.BR "-p tcp" .
-It is only valid in the
-.BR mangle
-table.
-.br
-This target is used to overcome criminally braindead ISPs or servers
-which block ICMPv6 Packet Too Big packets or are unable to send them.
-The symptoms of this problem are that everything works fine from your 
-Linux firewall/router, but machines behind it can never exchange large
-packets:
-.PD 0
-.RS 0.1i
-.TP 0.3i
-1)
-Web browsers connect, then hang with no data received.
-.TP
-2)
-Small mail works fine, but large emails hang.
-.TP
-3)
-ssh works fine, but scp hangs after initial handshaking.
-.RE
-.PD
-Workaround: activate this option and add a rule to your firewall
-configuration like:
-.nf
- ip6tables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
-             -j TCPMSS --clamp-mss-to-pmtu
-.fi
-.TP
-.BI "--set-mss " "value"
-Explicitly set MSS option to specified value.
-.TP
-.B "--clamp-mss-to-pmtu"
-Automatically clamp MSS value to (path_MTU - 60).
-.TP
-These options are mutually exclusive.
-
diff --git a/extensions/libip6t_connlimit.man b/extensions/libip6t_connlimit.man
deleted file mode 100644
index d1a4447..0000000
--- a/extensions/libip6t_connlimit.man
+++ /dev/null
@@ -1,27 +0,0 @@
-Allows you to restrict the number of parallel connections to a server per
-client IP address (or client address block).
-.TP
-[\fB!\fR] \fB--connlimit-above \fIn\fR
-Match if the number of existing connections is (not) above \fIn\fR.
-.TP
-\fB--connlimit-mask\fR \fIprefix_length\fR
-Group hosts using the prefix length. For IPv4, this must be a number between
-(including) 0 and 32. For IPv6, between 0 and 128.
-.P
-Examples:
-.TP
-# allow 2 telnet connections per client host
-ip6tables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
-.TP
-# you can also match the other way around:
-ip6tables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
-.TP
-# limit the number of parallel HTTP requests to 16 per class C sized \
-network (24 bit netmask)
-ip6tables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
---connlimit-mask 24 -j REJECT
-.TP
-# limit the number of parallel HTTP requests to 16 for the link local network \
-(ipv6)
-ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
-16 --connlimit-mask 64 -j REJECT
diff --git a/extensions/libip6t_length.man b/extensions/libip6t_length.man
deleted file mode 100644
index d781a04..0000000
--- a/extensions/libip6t_length.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This module matches the length of the IPv6 payload in octets, or range of it.
-IPv6 header itself isn't counted.
-.TP
-.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
diff --git a/extensions/libip6t_multiport.man b/extensions/libip6t_multiport.man
deleted file mode 100644
index 6f75a6e..0000000
--- a/extensions/libip6t_multiport.man
+++ /dev/null
@@ -1,20 +0,0 @@
-This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  It can only be used in conjunction
-with
-.B "-p tcp"
-or
-.BR "-p udp" .
-.TP
-.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the source port is one of the given ports.  The flag
-.B --sports
-is a convenient alias for this option.
-.TP
-.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the destination port is one of the given ports.  The flag
-.B --dports
-is a convenient alias for this option.
-.TP
-.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the both the source and destination ports are equal to each
-other and to one of the given ports.
diff --git a/extensions/libip6t_tcp.man b/extensions/libip6t_tcp.man
deleted file mode 100644
index 41b89a4..0000000
--- a/extensions/libip6t_tcp.man
+++ /dev/null
@@ -1,45 +0,0 @@
-These extensions can be used if `--protocol tcp' is specified. It
-provides the following options:
-.TP
-.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
-Source port or port range specification. This can either be a service
-name or a port number. An inclusive range can also be specified,
-using the format
-.IR port : port .
-If the first port is omitted, "0" is assumed; if the last is omitted,
-"65535" is assumed.
-If the second port greater then the first they will be swapped.
-The flag
-.B --sport
-is a convenient alias for this option.
-.TP
-.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
-Destination port or port range specification.  The flag
-.B --dport
-is a convenient alias for this option.
-.TP
-.BR "--tcp-flags " "[!] \fImask\fP \fIcomp\fP"
-Match when the TCP flags are as specified.  The first argument is the
-flags which we should examine, written as a comma-separated list, and
-the second argument is a comma-separated list of flags which must be
-set.  Flags are: 
-.BR "SYN ACK FIN RST URG PSH ALL NONE" .
-Hence the command
-.nf
- ip6tables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
-.fi
-will only match packets with the SYN flag set, and the ACK, FIN and
-RST flags unset.
-.TP
-.B "[!] --syn"
-Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits
-cleared.  Such packets are used to request TCP connection initiation;
-for example, blocking such packets coming in an interface will prevent
-incoming TCP connections, but outgoing TCP connections will be
-unaffected.
-It is equivalent to \fB--tcp-flags SYN,RST,ACK,FIN SYN\fP.
-If the "!" flag precedes the "--syn", the sense of the
-option is inverted.
-.TP
-.BR "--tcp-option " "[!] \fInumber\fP"
-Match if TCP option set.
diff --git a/extensions/libipt_TRACE.man b/extensions/libipt_TRACE.man
deleted file mode 100644
index 7fbe8e7..0000000
--- a/extensions/libipt_TRACE.man
+++ /dev/null
@@ -1,10 +0,0 @@
-This target marks packes so that the kernel will log every rule which match 
-the packets as those traverse the tables, chains, rules. (The ipt_LOG module 
-is required for the logging.) The packets are logged with the string prefix: 
-"TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
-plain rule, "return" for implicit rule at the end of a user defined chain 
-and "policy" for the policy of the built in chains. 
-.br
-It can only be used in the
-.BR raw
-table.
diff --git a/extensions/libipt_length.man b/extensions/libipt_length.man
deleted file mode 100644
index 43bbdcf..0000000
--- a/extensions/libipt_length.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This module matches the length of a packet against a specific value
-or range of values.
-.TP
-.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
diff --git a/extensions/libipt_TCPMSS.man b/extensions/libxt_TCPMSS.man
similarity index 77%
rename from extensions/libipt_TCPMSS.man
rename to extensions/libxt_TCPMSS.man
index 30668b0..82f93e0 100644
--- a/extensions/libipt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -1,6 +1,7 @@
 This target allows to alter the MSS value of TCP SYN packets, to control
 the maximum size for that connection (usually limiting it to your
-outgoing interface's MTU minus 40).  Of course, it can only be used
+outgoing interface's MTU minus 40 for IPv4 or 60 for IPv6, respectively).
+Of course, it can only be used
 in conjunction with
 .BR "-p tcp" .
 It is only valid in the
@@ -8,7 +9,8 @@ It is only valid in the
 table.
 .br
 This target is used to overcome criminally braindead ISPs or servers
-which block ICMP Fragmentation Needed packets.  The symptoms of this
+which block "ICMP Fragmentation Needed" or "ICMPv6 Packet Too Big"
+packets.  The symptoms of this
 problem are that everything works fine from your Linux
 firewall/router, but machines behind it can never exchange large
 packets:
@@ -36,6 +38,6 @@ configuration like:
 Explicitly set MSS option to specified value.
 .TP
 .B "--clamp-mss-to-pmtu"
-Automatically clamp MSS value to (path_MTU - 40).
+Automatically clamp MSS value to (path_MTU - 40 for IPv4; -60 for IPv6).
 .TP
 These options are mutually exclusive.
diff --git a/extensions/libip6t_TRACE.man b/extensions/libxt_TRACE.man
similarity index 94%
rename from extensions/libip6t_TRACE.man
rename to extensions/libxt_TRACE.man
index ca3895a..d28c3a0 100644
--- a/extensions/libip6t_TRACE.man
+++ b/extensions/libxt_TRACE.man
@@ -1,5 +1,6 @@
 This target marks packes so that the kernel will log every rule which match 
-the packets as those traverse the tables, chains, rules. (The ip6t_LOG module 
+the packets as those traverse the tables, chains, rules. (The ipt_LOG or
+ip6t_LOG module 
 is required for the logging.) The packets are logged with the string prefix: 
 "TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
 plain rule, "return" for implicit rule at the end of a user defined chain 
diff --git a/extensions/libipt_connlimit.man b/extensions/libxt_connlimit.man
similarity index 100%
rename from extensions/libipt_connlimit.man
rename to extensions/libxt_connlimit.man
diff --git a/extensions/libxt_length.man b/extensions/libxt_length.man
new file mode 100644
index 0000000..5a8198b
--- /dev/null
+++ b/extensions/libxt_length.man
@@ -0,0 +1,5 @@
+This module matches the length of the layer-3 payload (e.g. layer-4 packet)
+f a packet against a specific value
+or range of values.
+.TP
+.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
diff --git a/extensions/libipt_multiport.man b/extensions/libxt_multiport.man
similarity index 100%
rename from extensions/libipt_multiport.man
rename to extensions/libxt_multiport.man
diff --git a/extensions/libipt_tcp.man b/extensions/libxt_tcp.man
similarity index 100%
rename from extensions/libipt_tcp.man
rename to extensions/libxt_tcp.man
