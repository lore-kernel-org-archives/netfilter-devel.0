From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 21/24] Update spelling and grammar in manpages
Date: Tue, 4 Mar 2008 17:21:02 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041719440.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35288 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762252AbYCDQVE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:21:04 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


(invalidated, needs a fine refinement. Oh yeah, posting is good. More 
eyeballs, I know :-)

===
commit 73d1d7b7441d44b1daa6b057772466955c4bc83b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Feb 29 01:08:58 2008 +0100

    Update spelling and grammar in manpages
---
 extensions/libip6t_HL.man      |    6 +++---
 extensions/libip6t_eui64.man   |    4 ++--
 extensions/libip6t_frag.man    |    2 +-
 extensions/libipt_SAME.man     |    2 +-
 extensions/libxt_NFQUEUE.man   |    2 +-
 extensions/libxt_connbytes.man |    6 +++---
 extensions/libxt_dccp.man      |    2 +-
 extensions/libxt_dscp.man      |    2 +-
 extensions/libxt_hashlimit.man |    4 ++--
 ip6tables.8.in                 |    2 +-
 iptables.8.in                  |   10 +++++-----
 11 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/extensions/libip6t_HL.man b/extensions/libip6t_HL.man
index bf46881..fd5c7be 100644
--- a/extensions/libip6t_HL.man
+++ b/extensions/libip6t_HL.man
@@ -1,7 +1,7 @@
 This is used to modify the Hop Limit field in IPv6 header. The Hop Limit field
 is similar to what is known as TTL value in IPv4.  Setting or incrementing the
 Hop Limit field can potentially be very dangerous, so it should be avoided at
-any cost. This target is only valid in
+any cost. This target is only valid in the
 .B mangle
 table.
 .TP
@@ -11,7 +11,7 @@ table.
 Set the Hop Limit to `value'.
 .TP
 .BI "--hl-dec " "value"
-Decrement the Hop Limit `value' times.
+Decrement the Hop Limit by \fIvalue\fR.
 .TP
 .BI "--hl-inc " "value"
-Increment the Hop Limit `value' times.
+Increment the Hop Limit by \fIvalue\fR.
diff --git a/extensions/libip6t_eui64.man b/extensions/libip6t_eui64.man
index cd80b98..b5c70a7 100644
--- a/extensions/libip6t_eui64.man
+++ b/extensions/libip6t_eui64.man
@@ -1,6 +1,6 @@
-This module matches the EUI-64 part of a stateless autoconfigured IPv6 address.
+This module matches the EUI-64 part of a stateless auto-configured IPv6 address.
 It compares the EUI-64 derived from the source MAC address in Ethernet frame
-with the lower 64 bits of the IPv6 source address. But "Universal/Local"
+with the lower 64 bits of the IPv6 source address, but the "Universal/Local"
 bit is not compared. This module doesn't match other link layer frame, and
 is only valid in the
 .BR PREROUTING ,
diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index 5ac13a4..8937b55 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -17,4 +17,4 @@ Matches on the first fragment.
 Matches if there are more fragments.
 .TP
 .BR "[--fraglast]"
-Matches if this is the last fragement.
+Matches if this is the last fragment.
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
index 4e88d48..d038615 100644
--- a/extensions/libipt_SAME.man
+++ b/extensions/libipt_SAME.man
@@ -11,5 +11,5 @@ Don't use the destination-ip in the calculations when selecting the
 new source-ip
 .TP
 .B "--random"
-Port mapping will be forcely randomized to avoid attacks based on 
+Port mapping will be forcibly randomized to avoid attacks based on 
 port prediction (kernel >= 2.6.21).
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index c4e9d11..090a136 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -3,7 +3,7 @@ you to put a packet into any specific queue, identified by its 16-bit queue
 number.  
 .TP
 .BR "--queue-num " "\fIvalue"
-This specifies the QUEUE number to use. Valud queue numbers are 0 to 65535. The default value is 0.
+This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
 .TP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index ce7b665..5b9c251 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -1,5 +1,5 @@
 Match by how many bytes or packets a connection (or one of the two
-flows constituting the connection) have tranferred so far, or by
+flows constituting the connection) have transferred so far, or by
 average bytes per packet.
 
 The counters are 64bit and are thus not expected to overflow ;)
@@ -7,8 +7,8 @@ The counters are 64bit and are thus not expected to overflow ;)
 The primary use is to detect long-lived downloads and mark them to be
 scheduled using a lower priority band in traffic control.
 
-The transfered bytes per connection can also be viewed through
-/proc/net/ip_conntrack and accessed via ctnetlink
+The transferred bytes per connection can also be viewed through
+/proc/net/nf_conntrack and accessed via ctnetlink
 .TP
 [\fB!\fR]\fB --connbytes \fIfrom\fB:\fR[\fIto\fR]
 match packets from a connection whose packets/bytes/average packet
diff --git a/extensions/libxt_dccp.man b/extensions/libxt_dccp.man
index 6443ec3..d716b81 100644
--- a/extensions/libxt_dccp.man
+++ b/extensions/libxt_dccp.man
@@ -9,4 +9,4 @@ list of packet types.  Packet types are:
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID" .
 .TP
 \fB--dccp-option\fR [\fB!\fR\] \fInumber\fP
-Match if DCP option set.
+Match if DCCP option set.
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index cb0b6f3..29ff3b2 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -7,4 +7,4 @@ Match against a numeric (decimal or hex) value [0-63].
 .BI "--dscp-class " "\fIDiffServ Class\fP"
 Match the DiffServ class. This value may be any of the
 BE, EF, AFxx or CSx classes.  It will then be converted
-into it's according numeric value.
+into its according numeric value.
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index e74aedf..e449406 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -53,7 +53,7 @@ The number of buckets of the hash table
 Maximum entries in the hash.
 .TP
 \fB--hashlimit-htable-expire\fR \fImsec\fR
-After how many miliseconds do hash entries expire.
+After how many milliseconds do hash entries expire.
 .TP
 \fB--hashlimit-htable-gcinterval\fR \fImsec\fR
-How many miliseconds between garbage collection intervals.
+How many milliseconds between garbage collection intervals.
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 8528b8e..f103363 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -478,7 +478,7 @@ James Morris wrote the TOS target, and tos match.
 .PP
 Jozsef Kadlecsik wrote the REJECT target.
 .PP
-Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, aswell as TTL match+target and libipulog.
+Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, as well as TTL match+target and libipulog.
 .PP
 The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Yasuyuki Kozakai,
 Jozsef Kadlecsik, Patrick McHardy, James Morris, Pablo Neira Ayuso,
diff --git a/iptables.8.in b/iptables.8.in
index 9904c48..4024027 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -55,7 +55,7 @@ a `target', which may be a jump to a user-defined chain in the same
 table.
 
 .SH TARGETS
-A firewall rule specifies criteria for a packet, and a target.  If the
+A firewall rule specifies criteria for a packet and a target.  If the
 packet does not match, the next rule in the chain is the examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
@@ -155,9 +155,9 @@ The options that are recognized by
 .B iptables
 can be divided into several different groups.
 .SS COMMANDS
-These options specify the specific action to perform.  Only one of them
-can be specified on the command line unless otherwise specified
-below.  For all the long versions of the command and option names, you
+These options specify the action to perform. Only one of them
+can be specified on the command line unless otherwise stated
+below. For long versions of the command and option names, you
 need to use only enough letters to ensure that
 .B iptables
 can differentiate it from all other options.
@@ -188,7 +188,7 @@ fail.  Rules are numbered starting at 1.
 .TP
 .BR "-L, --list " "[\fIchain\fP]"
 List all rules in the selected chain.  If no chain is selected, all
-chains are listed.  As every other iptables command, it applies to the
+chains are listed. Like every other iptables command, it applies to the
 specified table (filter is the default), so NAT rules get listed by
 .nf
  iptables -t nat -n -L
