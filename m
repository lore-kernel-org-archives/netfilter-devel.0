From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpage updates
Date: Sun, 8 Jun 2008 11:58:45 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806081158110.20733@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54785 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYFHJ6r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:58:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 1f81341483544759db0d5255ecd6f49de984993a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jun 8 11:57:41 2008 +0200

manpage updates
    
A number of options support negation, but the manpage did not reflect
this ("[!]" was absent). Also fix a few [] (optional arguments) to {}
(required arguments) in the option-BNF.
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_addrtype.man |    4 ++--
 extensions/libipt_ecn.man      |    6 +++---
 extensions/libipt_set.man      |    2 +-
 extensions/libxt_connbytes.man |    4 ++--
 extensions/libxt_dccp.man      |    4 ++--
 extensions/libxt_dscp.man      |    4 ++--
 extensions/libxt_hashlimit.man |    2 +-
 extensions/libxt_length.man    |    2 +-
 extensions/libxt_limit.man     |    2 +-
 extensions/libxt_multiport.man |   11 +++++++----
 extensions/libxt_pkttype.c     |    2 +-
 extensions/libxt_pkttype.man   |    2 +-
 extensions/libxt_policy.man    |   12 ++++++------
 extensions/libxt_state.man     |    2 +-
 extensions/libxt_string.c      |    4 ++--
 extensions/libxt_string.man    |    5 +++--
 extensions/libxt_time.c        |   20 ++++++++++----------
 extensions/libxt_time.man      |    2 +-
 18 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
index af5e648..275d999 100644
--- a/extensions/libipt_addrtype.man
+++ b/extensions/libipt_addrtype.man
@@ -40,10 +40,10 @@ FIXME
 .TP
 .BI "XRESOLVE"
 .TP
-.BI "--src-type " "type"
+[\fB!\fP] \fB--src-type\fP \fItype\fP
 Matches if the source address is of given type
 .TP
-.BI "--dst-type " "type"
+[\fB!\fP] \fB--dst-type\fP \fItype\fP
 Matches if the destination address is of given type
 .TP
 .BI "--limit-iface-in"
diff --git a/extensions/libipt_ecn.man b/extensions/libipt_ecn.man
index 8ecfef5..d289d08 100644
--- a/extensions/libipt_ecn.man
+++ b/extensions/libipt_ecn.man
@@ -1,11 +1,11 @@
 This allows you to match the ECN bits of the IPv4 and TCP header.  ECN is the Explicit Congestion Notification mechanism as specified in RFC3168
 .TP
-.BI "--ecn-tcp-cwr"
+[\fB!\fP] \fB--ecn-tcp-cwr\fP
 This matches if the TCP ECN CWR (Congestion Window Received) bit is set.
 .TP
-.BI "--ecn-tcp-ece"
+[\fB!\fP] \fB--ecn-tcp-ece\fP
 This matches if the TCP ECN ECE (ECN Echo) bit is set.
 .TP
-.BI "--ecn-ip-ect " "num"
+[\fB!\fP] \fB--ecn-ip-ect\fP \fInum\fP
 This matches a particular IPv4 ECT (ECN-Capable Transport). You have to specify
 a number between `0' and `3'.
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index a92a950..c8ff601 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -1,6 +1,6 @@
 This modules macthes IP sets which can be defined by ipset(8).
 .TP
-\fB--set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
+[\fB!\fP] \fB--set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
 where flags are
 .BR "src"
 and/or
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index 124ff6f..f547968 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -16,10 +16,10 @@ size is more than FROM and less than TO bytes/packets. if TO is
 omitted only FROM check is done. "!" is used to match packets not
 falling in the range.
 .TP
-\fB--connbytes-dir\fR [\fBoriginal\fR|\fBreply\fR|\fBboth\fR]
+\fB--connbytes-dir\fR {\fBoriginal\fR|\fBreply\fR|\fBboth\fR}
 which packets to consider
 .TP
-\fB--connbytes-mode\fR [\fBpackets\fR|\fBbytes\fR|\fBavgpkt\fR]
+\fB--connbytes-mode\fR {\fBpackets\fR|\fBbytes\fR|\fBavgpkt\fR}
 whether to check the amount of packets, number of bytes transferred or
 the average size (in bytes) of all packets received so far. Note that
 when "both" is used together with "avgpkt", and data is going (mainly)
diff --git a/extensions/libxt_dccp.man b/extensions/libxt_dccp.man
index d962ef0..0320af4 100644
--- a/extensions/libxt_dccp.man
+++ b/extensions/libxt_dccp.man
@@ -3,10 +3,10 @@
 .TP
 [\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-\fB--dccp-types\fR [\fB!\fR] \fImask\fP
+[\fB!\fP] \fB--dccp-types\fR \fImask\fP
 Match when the DCCP packet type is one of 'mask'. 'mask' is a comma-separated
 list of packet types.  Packet types are: 
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID" .
 .TP
-\fB--dccp-option\fR [\fB!\fR\] \fInumber\fP
+[\fB!\fP] \fB--dccp-option\fR \fInumber\fP
 Match if DCP option set.
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index 4a42278..e2357db 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -1,10 +1,10 @@
 This module matches the 6 bit DSCP field within the TOS field in the
 IP header.  DSCP has superseded TOS within the IETF.
 .TP
-.BI "--dscp " "value"
+[\fB!\fP] \fB--dscp\fP \fIvalue\fP
 Match against a numeric (decimal or hex) value [0-63].
 .TP
-\fB--dscp-class\fP \fIclass\fP
+[\fB!\fP] \fB--dscp-class\fP \fIclass\fP
 Match the DiffServ class. This value may be any of the
 BE, EF, AFxx or CSx classes.  It will then be converted
 into its according numeric value.
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index e449406..84642ca 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -28,7 +28,7 @@ Maximum initial number of packets to match: this number gets recharged by one
 every time the limit specified above is not reached, up to this number; the
 default is 5.
 .TP
-\fB--hashlimit-mode\fR [\fBsrcip\fR|\fBsrcport\fR|\fBdstip\fR|\fBdstport\fR[\fB,\fR...]]
+\fB--hashlimit-mode\fR {\fBsrcip\fR|\fBsrcport\fR|\fBdstip\fR|\fBdstport\fR}\fB,\fP...
 A comma-separated list of objects to take into consideration. If no
 --hashlimit-mode option is given, hashlimit acts like limit, but at the
 expensive of doing the hash housekeeping.
diff --git a/extensions/libxt_length.man b/extensions/libxt_length.man
index 5a8198b..27236ae 100644
--- a/extensions/libxt_length.man
+++ b/extensions/libxt_length.man
@@ -2,4 +2,4 @@ This module matches the length of the layer-3 payload (e.g. layer-4 packet)
 f a packet against a specific value
 or range of values.
 .TP
-.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
+[\fB!\fP] \fB--length\fP \fIlength\fP[\fB:\fP\fIlength\fP]
diff --git a/extensions/libxt_limit.man b/extensions/libxt_limit.man
index 84b63d4..0419c50 100644
--- a/extensions/libxt_limit.man
+++ b/extensions/libxt_limit.man
@@ -4,7 +4,7 @@ A rule using this extension will match until this limit is reached
 .B LOG
 target to give limited logging, for example.
 .TP
-.BI "--limit " "rate"
+[\fB!\fP] \fB--limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Maximum average matching rate: specified as a number, with an optional
 `/second', `/minute', `/hour', or `/day' suffix; the default is
 3/hour.
diff --git a/extensions/libxt_multiport.man b/extensions/libxt_multiport.man
index cbd87e7..b8e5e49 100644
--- a/extensions/libxt_multiport.man
+++ b/extensions/libxt_multiport.man
@@ -5,16 +5,19 @@ ports.  It can only be used in conjunction with
 or
 .BR "-p udp" .
 .TP
-[\fB!\fP] \fB--source-ports\fP,\fB--sport\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
+[\fB!\fP] \fB--source-ports\fP,\fB--sport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if the source port is one of the given ports.  The flag
 .B --sports
-is a convenient alias for this option.
+is a convenient alias for this option. Multiple ports or port ranges are
+separated using a comma, and a port range is specified using a colon.
+\fB53,1024:65535\fP would therefore match ports 53 and all from 1024 through
+65535.
 .TP
-[\fB!\fP] \fB--destination-ports\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
+[\fB!\fP] \fB--destination-ports\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-[\fB!\fP] \fB--ports\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
+[\fB!\fP] \fB--ports\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if either the source or destination ports are equal to one of
 the given ports.
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 69c6da8..2554101 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -59,7 +59,7 @@ static void pkttype_help(void)
 {
 	printf(
 "pkttype match options:\n"
-"  --pkt-type [!] packettype\tmatch packet type\n");
+"[!] --pkt-type packettype    match packet type\n");
 	print_types();
 }
 
diff --git a/extensions/libxt_pkttype.man b/extensions/libxt_pkttype.man
index 127d80a..ecc6061 100644
--- a/extensions/libxt_pkttype.man
+++ b/extensions/libxt_pkttype.man
@@ -1,3 +1,3 @@
 This module matches the link-layer packet type.
 .TP
-\fB--pkt-type\fP {\fIunicast\fP|\fIbroadcast\fP|\fImulticast\fP}
+[\fB!\fP] \fB--pkt-type\fP {\fBunicast\fP|\fBbroadcast\fP|\fBmulticast\fP}
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
index 0c16273..7b7cb2d 100644
--- a/extensions/libxt_policy.man
+++ b/extensions/libxt_policy.man
@@ -19,27 +19,27 @@ Matches if the packet is subject to IPsec processing.
 Selects whether to match the exact policy or match if any rule of
 the policy matches the given policy.
 .TP
-.BI "--reqid " "id"
+[\fB!\fP] \fB--reqid\fP \fIid\fP
 Matches the reqid of the policy rule. The reqid can be specified with
 .B setkey(8)
 using
 .B unique:id
 as level.
 .TP
-.BI "--spi " "spi"
+[\fB!\fP] \fB--spi\fP \fIspi\fP
 Matches the SPI of the SA.
 .TP
-\fB--proto\fP {\fBah\fP|\fBesp\fP|\fBipcomp\fP}
+[\fB!\fP] \fB--proto\fP {\fBah\fP|\fBesp\fP|\fBipcomp\fP}
 Matches the encapsulation protocol.
 .TP
-\fB--mode\fP {\fBtunnel\fP|\fBtransport\fP}
+[\fB!\fP] \fB--mode\fP {\fBtunnel\fP|\fBtransport\fP}
 Matches the encapsulation mode.
 .TP
-\fB--tunnel-src\fP \fIaddr\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB--tunnel-src\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the source end-point address of a tunnel mode SA.
 Only valid with \fB--mode tunnel\fP.
 .TP
-\fB--tunnel-dst\fP \fIaddr\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB--tunnel-dst\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the destination end-point address of a tunnel mode SA.
 Only valid with \fB--mode tunnel\fP.
 .TP
diff --git a/extensions/libxt_state.man b/extensions/libxt_state.man
index 7107868..8e943c3 100644
--- a/extensions/libxt_state.man
+++ b/extensions/libxt_state.man
@@ -1,7 +1,7 @@
 This module, when combined with connection tracking, allows access to
 the connection tracking state for this packet.
 .TP
-.BI "--state " "state"
+[\fB!\fP] \fB--state\fP \fIstate\fP
 Where state is a comma separated list of the connection states to
 match.  Possible states are
 .B INVALID
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 82deb2a..5eec44b 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -38,8 +38,8 @@ static void string_help(void)
 "--from                       Offset to start searching from\n"
 "--to                         Offset to stop searching\n"
 "--algo	                      Algorithm\n"
-"--string [!] string          Match a string in a packet\n"
-"--hex-string [!] string      Match a hex string in a packet\n");
+"[!] --string string          Match a string in a packet\n"
+"[!] --hex-string string      Match a hex string in a packet\n");
 }
 
 static const struct option string_opts[] = {
diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 9e3b25c..01e15c2 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -9,7 +9,8 @@ Set the offset from which it starts looking for any matching. If not passed, def
 .BI "--to " "offset"
 Set the offset from which it starts looking for any matching. If not passed, default is the packet size.
 .TP
-.BI "--string " "pattern"
+[\fB!\fP] \fB--string\fP \fIpattern\fP
 Matches the given pattern.
-.BI "--hex-string " "pattern"
+.TP
+[\fB!\fP] \fB--hex-string\fP \fIpattern\fP
 Matches the given pattern in hex notation.
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 7072d71..97bb0d3 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -51,16 +51,16 @@ static void time_help(void)
 {
 	printf(
 "time match options:\n"
-"  --datestart time     Start and stop time, to be given in ISO 8601\n"
-"  --datestop time      (YYYY[-MM[-DD[Thh[:mm[:ss]]]]])\n"
-"  --timestart time     Start and stop daytime (hh:mm[:ss])\n"
-"  --timestop time      (between 00:00:00 and 23:59:59)\n"
-"  --monthdays value    List of days on which to match, separated by comma\n"
-"                       (Possible days: 1 to 31; defaults to all)\n"
-"  --weekdays value     List of weekdays on which to match, sep. by comma\n"
-"                       (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7\n"
-"                       Defaults to all weekdays.)\n"
-"  --localtz/--utc      Time is interpreted as UTC/local time\n");
+"    --datestart time     Start and stop time, to be given in ISO 8601\n"
+"    --datestop time      (YYYY[-MM[-DD[Thh[:mm[:ss]]]]])\n"
+"    --timestart time     Start and stop daytime (hh:mm[:ss])\n"
+"    --timestop time      (between 00:00:00 and 23:59:59)\n"
+"[!] --monthdays value    List of days on which to match, separated by comma\n"
+"                         (Possible days: 1 to 31; defaults to all)\n"
+"[!] --weekdays value     List of weekdays on which to match, sep. by comma\n"
+"                         (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7\n"
+"                         Defaults to all weekdays.)\n"
+"    --localtz/--utc      Time is interpreted as UTC/local time\n");
 }
 
 static void time_init(struct xt_entry_match *m)
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index a07d49e..ab4a09c 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -19,7 +19,7 @@ Only match during the given daytime. The possible time range is 00:00:00 to
 23:59:59. Leading zeroes are allowed (e.g. "06:03") and correctly interpreted
 as base-10.
 .TP
-[\fB!\fR] \fB--monthday\fR \fIday\fR[\fB,\fR\fIday\fR...]
+[\fB!\fR] \fB--monthdays\fR \fIday\fR[\fB,\fR\fIday\fR...]
 .IP
 Only match on the given days of the month. Possible values are \fB1\fR
 to \fB31\fR. Note that specifying \fB31\fR will of course not match

