From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 5/8] Combine ipt and ip6t manpages
Date: Mon, 14 Apr 2008 08:55:11 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804140854340.9651@fbirervta.pbzchgretzou.qr>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <b99189c17a0a98eee21175c1ea2fe9818e4b2892.1208075035.git.jengelh@computergmbh.de> <4802FD56.3080707@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57401 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYDNGzN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:55:13 -0400
In-Reply-To: <4802FD56.3080707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-04-14 08:44, Patrick McHardy wrote:
>>  delete mode 100644 extensions/libipt_policy.man
>>  rename extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} (77%)
>>  rename extensions/{libip6t_TRACE.man => libxt_TRACE.man} (94%)
>>  rename extensions/{libipt_connlimit.man => libxt_connlimit.man} (100%)
>>  create mode 100644 extensions/libxt_length.man
>>  rename extensions/{libipt_multiport.man => libxt_multiport.man} (100%)
>>  rename extensions/{libip6t_policy.man => libxt_policy.man} (100%)
>>  rename extensions/{libipt_tcp.man => libxt_tcp.man} (100%)
>
> Please send a unidiff that includes all those renames
> so I can apply it using "patch".
>
commit 94b7a2a14adc13fdd667d3f06212922e21416e43
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 03:02:55 2008 +0100

    Combine ipt and ip6t manpages

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
diff --git a/extensions/libip6t_TRACE.man b/extensions/libip6t_TRACE.man
deleted file mode 100644
index ca3895a..0000000
--- a/extensions/libip6t_TRACE.man
+++ /dev/null
@@ -1,10 +0,0 @@
-This target marks packes so that the kernel will log every rule which match 
-the packets as those traverse the tables, chains, rules. (The ip6t_LOG module 
-is required for the logging.) The packets are logged with the string prefix: 
-"TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
-plain rule, "return" for implicit rule at the end of a user defined chain 
-and "policy" for the policy of the built in chains. 
-.br
-It can only be used in the
-.BR raw
-table.
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
diff --git a/extensions/libip6t_policy.man b/extensions/libip6t_policy.man
deleted file mode 100644
index eed163e..0000000
--- a/extensions/libip6t_policy.man
+++ /dev/null
@@ -1,48 +0,0 @@
-This modules matches the policy used by IPsec for handling a packet.
-.TP
-.BI "--dir " "in|out"
-Used to select whether to match the policy used for decapsulation or the
-policy that will be used for encapsulation.
-.B in
-is valid in the
-.B PREROUTING, INPUT and FORWARD
-chains,
-.B out
-is valid in the
-.B POSTROUTING, OUTPUT and FORWARD
-chains.
-.TP
-.BI "--pol " "none|ipsec"
-Matches if the packet is subject to IPsec processing.
-.TP
-.BI "--strict"
-Selects whether to match the exact policy or match if any rule of
-the policy matches the given policy.
-.TP
-.BI "--reqid " "id"
-Matches the reqid of the policy rule. The reqid can be specified with
-.B setkey(8)
-using
-.B unique:id
-as level.
-.TP
-.BI "--spi " "spi"
-Matches the SPI of the SA.
-.TP
-.BI "--proto " "ah|esp|ipcomp"
-Matches the encapsulation protocol.
-.TP
-.BI "--mode " "tunnel|transport"
-Matches the encapsulation mode.
-.TP
-.BI "--tunnel-src " "addr[/mask]"
-Matches the source end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
-.TP
-.BI "--tunnel-dst " "addr[/mask]"
-Matches the destination end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
-.TP
-.BI "--next"
-Start the next element in the policy specification. Can only be used with
---strict
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
diff --git a/extensions/libipt_TCPMSS.man b/extensions/libipt_TCPMSS.man
deleted file mode 100644
index 30668b0..0000000
--- a/extensions/libipt_TCPMSS.man
+++ /dev/null
@@ -1,41 +0,0 @@
-This target allows to alter the MSS value of TCP SYN packets, to control
-the maximum size for that connection (usually limiting it to your
-outgoing interface's MTU minus 40).  Of course, it can only be used
-in conjunction with
-.BR "-p tcp" .
-It is only valid in the
-.BR mangle
-table.
-.br
-This target is used to overcome criminally braindead ISPs or servers
-which block ICMP Fragmentation Needed packets.  The symptoms of this
-problem are that everything works fine from your Linux
-firewall/router, but machines behind it can never exchange large
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
- iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
-             -j TCPMSS --clamp-mss-to-pmtu
-.fi
-.TP
-.BI "--set-mss " "value"
-Explicitly set MSS option to specified value.
-.TP
-.B "--clamp-mss-to-pmtu"
-Automatically clamp MSS value to (path_MTU - 40).
-.TP
-These options are mutually exclusive.
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
diff --git a/extensions/libipt_connlimit.man b/extensions/libipt_connlimit.man
deleted file mode 100644
index dd6a155..0000000
--- a/extensions/libipt_connlimit.man
+++ /dev/null
@@ -1,27 +0,0 @@
-Allows you to restrict the number of parallel connections to a server per
-client IP address (or client address block).
-.TP
-[\fB!\fP] \fB--connlimit-above\fP \fIn\fP
-Match if the number of existing connections is (not) above \fIn\fR.
-.TP
-\fB--connlimit-mask\fR \fIprefix_length\fR
-Group hosts using the prefix length. For IPv4, this must be a number between
-(including) 0 and 32. For IPv6, between 0 and 128.
-.P
-Examples:
-.TP
-# allow 2 telnet connections per client host
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
-.TP
-# you can also match the other way around:
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
-.TP
-# limit the number of parallel HTTP requests to 16 per class C sized \
-network (24 bit netmask)
-iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
---connlimit-mask 24 -j REJECT
-.TP
-# limit the number of parallel HTTP requests to 16 for the link local network \
-(ipv6)
-ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
-16 --connlimit-mask 64 -j REJECT
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
diff --git a/extensions/libipt_multiport.man b/extensions/libipt_multiport.man
deleted file mode 100644
index ba760e9..0000000
--- a/extensions/libipt_multiport.man
+++ /dev/null
@@ -1,20 +0,0 @@
-This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  A port range (port:port) counts as two
-ports.  It can only be used in conjunction with
-.B "-p tcp"
-or
-.BR "-p udp" .
-.TP
-.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
-Match if the source port is one of the given ports.  The flag
-.B --sports
-is a convenient alias for this option.
-.TP
-.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
-Match if the destination port is one of the given ports.  The flag
-.B --dports
-is a convenient alias for this option.
-.TP
-.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
-Match if either the source or destination ports are equal to one of
-the given ports.
diff --git a/extensions/libipt_policy.man b/extensions/libipt_policy.man
deleted file mode 100644
index eed163e..0000000
--- a/extensions/libipt_policy.man
+++ /dev/null
@@ -1,48 +0,0 @@
-This modules matches the policy used by IPsec for handling a packet.
-.TP
-.BI "--dir " "in|out"
-Used to select whether to match the policy used for decapsulation or the
-policy that will be used for encapsulation.
-.B in
-is valid in the
-.B PREROUTING, INPUT and FORWARD
-chains,
-.B out
-is valid in the
-.B POSTROUTING, OUTPUT and FORWARD
-chains.
-.TP
-.BI "--pol " "none|ipsec"
-Matches if the packet is subject to IPsec processing.
-.TP
-.BI "--strict"
-Selects whether to match the exact policy or match if any rule of
-the policy matches the given policy.
-.TP
-.BI "--reqid " "id"
-Matches the reqid of the policy rule. The reqid can be specified with
-.B setkey(8)
-using
-.B unique:id
-as level.
-.TP
-.BI "--spi " "spi"
-Matches the SPI of the SA.
-.TP
-.BI "--proto " "ah|esp|ipcomp"
-Matches the encapsulation protocol.
-.TP
-.BI "--mode " "tunnel|transport"
-Matches the encapsulation mode.
-.TP
-.BI "--tunnel-src " "addr[/mask]"
-Matches the source end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
-.TP
-.BI "--tunnel-dst " "addr[/mask]"
-Matches the destination end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
-.TP
-.BI "--next"
-Start the next element in the policy specification. Can only be used with
---strict
diff --git a/extensions/libipt_tcp.man b/extensions/libipt_tcp.man
deleted file mode 100644
index cfafc9e..0000000
--- a/extensions/libipt_tcp.man
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
- iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
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
diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
new file mode 100644
index 0000000..82f93e0
--- /dev/null
+++ b/extensions/libxt_TCPMSS.man
@@ -0,0 +1,43 @@
+This target allows to alter the MSS value of TCP SYN packets, to control
+the maximum size for that connection (usually limiting it to your
+outgoing interface's MTU minus 40 for IPv4 or 60 for IPv6, respectively).
+Of course, it can only be used
+in conjunction with
+.BR "-p tcp" .
+It is only valid in the
+.BR mangle
+table.
+.br
+This target is used to overcome criminally braindead ISPs or servers
+which block "ICMP Fragmentation Needed" or "ICMPv6 Packet Too Big"
+packets.  The symptoms of this
+problem are that everything works fine from your Linux
+firewall/router, but machines behind it can never exchange large
+packets:
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
+Workaround: activate this option and add a rule to your firewall
+configuration like:
+.nf
+ iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
+             -j TCPMSS --clamp-mss-to-pmtu
+.fi
+.TP
+.BI "--set-mss " "value"
+Explicitly set MSS option to specified value.
+.TP
+.B "--clamp-mss-to-pmtu"
+Automatically clamp MSS value to (path_MTU - 40 for IPv4; -60 for IPv6).
+.TP
+These options are mutually exclusive.
diff --git a/extensions/libxt_TRACE.man b/extensions/libxt_TRACE.man
new file mode 100644
index 0000000..d28c3a0
--- /dev/null
+++ b/extensions/libxt_TRACE.man
@@ -0,0 +1,11 @@
+This target marks packes so that the kernel will log every rule which match 
+the packets as those traverse the tables, chains, rules. (The ipt_LOG or
+ip6t_LOG module 
+is required for the logging.) The packets are logged with the string prefix: 
+"TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
+plain rule, "return" for implicit rule at the end of a user defined chain 
+and "policy" for the policy of the built in chains. 
+.br
+It can only be used in the
+.BR raw
+table.
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
new file mode 100644
index 0000000..dd6a155
--- /dev/null
+++ b/extensions/libxt_connlimit.man
@@ -0,0 +1,27 @@
+Allows you to restrict the number of parallel connections to a server per
+client IP address (or client address block).
+.TP
+[\fB!\fP] \fB--connlimit-above\fP \fIn\fP
+Match if the number of existing connections is (not) above \fIn\fR.
+.TP
+\fB--connlimit-mask\fR \fIprefix_length\fR
+Group hosts using the prefix length. For IPv4, this must be a number between
+(including) 0 and 32. For IPv6, between 0 and 128.
+.P
+Examples:
+.TP
+# allow 2 telnet connections per client host
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+.TP
+# you can also match the other way around:
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+.TP
+# limit the number of parallel HTTP requests to 16 per class C sized \
+network (24 bit netmask)
+iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
+--connlimit-mask 24 -j REJECT
+.TP
+# limit the number of parallel HTTP requests to 16 for the link local network \
+(ipv6)
+ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
+16 --connlimit-mask 64 -j REJECT
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
diff --git a/extensions/libxt_multiport.man b/extensions/libxt_multiport.man
new file mode 100644
index 0000000..ba760e9
--- /dev/null
+++ b/extensions/libxt_multiport.man
@@ -0,0 +1,20 @@
+This module matches a set of source or destination ports.  Up to 15
+ports can be specified.  A port range (port:port) counts as two
+ports.  It can only be used in conjunction with
+.B "-p tcp"
+or
+.BR "-p udp" .
+.TP
+.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+Match if the source port is one of the given ports.  The flag
+.B --sports
+is a convenient alias for this option.
+.TP
+.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+Match if the destination port is one of the given ports.  The flag
+.B --dports
+is a convenient alias for this option.
+.TP
+.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+Match if either the source or destination ports are equal to one of
+the given ports.
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
new file mode 100644
index 0000000..eed163e
--- /dev/null
+++ b/extensions/libxt_policy.man
@@ -0,0 +1,48 @@
+This modules matches the policy used by IPsec for handling a packet.
+.TP
+.BI "--dir " "in|out"
+Used to select whether to match the policy used for decapsulation or the
+policy that will be used for encapsulation.
+.B in
+is valid in the
+.B PREROUTING, INPUT and FORWARD
+chains,
+.B out
+is valid in the
+.B POSTROUTING, OUTPUT and FORWARD
+chains.
+.TP
+.BI "--pol " "none|ipsec"
+Matches if the packet is subject to IPsec processing.
+.TP
+.BI "--strict"
+Selects whether to match the exact policy or match if any rule of
+the policy matches the given policy.
+.TP
+.BI "--reqid " "id"
+Matches the reqid of the policy rule. The reqid can be specified with
+.B setkey(8)
+using
+.B unique:id
+as level.
+.TP
+.BI "--spi " "spi"
+Matches the SPI of the SA.
+.TP
+.BI "--proto " "ah|esp|ipcomp"
+Matches the encapsulation protocol.
+.TP
+.BI "--mode " "tunnel|transport"
+Matches the encapsulation mode.
+.TP
+.BI "--tunnel-src " "addr[/mask]"
+Matches the source end-point address of a tunnel mode SA.
+Only valid with --mode tunnel.
+.TP
+.BI "--tunnel-dst " "addr[/mask]"
+Matches the destination end-point address of a tunnel mode SA.
+Only valid with --mode tunnel.
+.TP
+.BI "--next"
+Start the next element in the policy specification. Can only be used with
+--strict
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
new file mode 100644
index 0000000..cfafc9e
--- /dev/null
+++ b/extensions/libxt_tcp.man
@@ -0,0 +1,45 @@
+These extensions can be used if `--protocol tcp' is specified. It
+provides the following options:
+.TP
+.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
+Source port or port range specification. This can either be a service
+name or a port number. An inclusive range can also be specified,
+using the format
+.IR port : port .
+If the first port is omitted, "0" is assumed; if the last is omitted,
+"65535" is assumed.
+If the second port greater then the first they will be swapped.
+The flag
+.B --sport
+is a convenient alias for this option.
+.TP
+.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
+Destination port or port range specification.  The flag
+.B --dport
+is a convenient alias for this option.
+.TP
+.BR "--tcp-flags " "[!] \fImask\fP \fIcomp\fP"
+Match when the TCP flags are as specified.  The first argument is the
+flags which we should examine, written as a comma-separated list, and
+the second argument is a comma-separated list of flags which must be
+set.  Flags are:
+.BR "SYN ACK FIN RST URG PSH ALL NONE" .
+Hence the command
+.nf
+ iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
+.fi
+will only match packets with the SYN flag set, and the ACK, FIN and
+RST flags unset.
+.TP
+.B "[!] --syn"
+Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits
+cleared.  Such packets are used to request TCP connection initiation;
+for example, blocking such packets coming in an interface will prevent
+incoming TCP connections, but outgoing TCP connections will be
+unaffected.
+It is equivalent to \fB--tcp-flags SYN,RST,ACK,FIN SYN\fP.
+If the "!" flag precedes the "--syn", the sense of the
+option is inverted.
+.TP
+.BR "--tcp-option " "[!] \fInumber\fP"
+Match if TCP option set.
