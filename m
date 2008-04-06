From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 24/24] manpages: update to reflect fine-grained control
Date: Sun,  6 Apr 2008 17:27:21 +0200
Message-ID: <4f528874ed5d6772fac59772527cd6f0af4fffe6.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56500 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYDFP13 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:29 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some manpages (DNAT for example) specifies
	--to-destination ip[-ip][:port-port]
while it is actually
	--to-destination ip[-ip][:port[-port]]
---
 extensions/libip6t_frag.man   |    4 ++--
 extensions/libipt_DNAT.man    |    2 +-
 extensions/libipt_SAME.man    |    2 +-
 extensions/libipt_SNAT.man    |    2 +-
 extensions/libxt_connmark.man |    2 +-
 extensions/libxt_helper.man   |    2 +-
 extensions/libxt_iprange.man  |    4 ++--
 extensions/libxt_mark.man     |    2 +-
 extensions/libxt_owner.man    |   10 +++++-----
 extensions/libxt_tos.man      |    4 ++--
 10 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index 8937b55..cc13e79 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -13,8 +13,8 @@ Matches if the reserved fields are filled with zero.
 .BR "--fragfirst "
 Matches on the first fragment.
 .TP
-.BR "[--fragmore]"
+\fB--fragmore\fP
 Matches if there are more fragments.
 .TP
-.BR "[--fraglast]"
+\fB--fraglast\fP
 Matches if this is the last fragment.
diff --git a/extensions/libipt_DNAT.man b/extensions/libipt_DNAT.man
index f11f4e2..65c152c 100644
--- a/extensions/libipt_DNAT.man
+++ b/extensions/libipt_DNAT.man
@@ -10,7 +10,7 @@ should be modified (and all future packets in this connection will
 also be mangled), and rules should cease being examined.  It takes one
 type of option:
 .TP
-.BR "--to-destination " "[\fIipaddr\fP][-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
+\fB--to-destination\fP [\fIipaddr\fP][\fB-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB-\fP\fIport\fP]]
 which can specify a single new destination IP address, an inclusive
 range of IP addresses, and optionally, a port range (which is only
 valid if the rule also specifies
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
index d038615..7e28ca5 100644
--- a/extensions/libipt_SAME.man
+++ b/extensions/libipt_SAME.man
@@ -2,7 +2,7 @@ Similar to SNAT/DNAT depending on chain: it takes a range of addresses
 (`--to 1.2.3.4-1.2.3.7') and gives a client the same
 source-/destination-address for each connection.
 .TP
-.BI "--to " "<ipaddr>-<ipaddr>"
+\fB--to\fP \fIipaddr\fP[\fB-\fP\fIipaddr\fP]
 Addresses to map source to. May be specified more than once for
 multiple ranges.
 .TP
diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
index 7b34799..34939af 100644
--- a/extensions/libipt_SNAT.man
+++ b/extensions/libipt_SNAT.man
@@ -7,7 +7,7 @@ modified (and all future packets in this connection will also be
 mangled), and rules should cease being examined.  It takes one type
 of option:
 .TP
-.BR "--to-source  " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
+\fB--to-source\fP \fIipaddr\fP[\fB-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB-\fP\fIport\fP]]
 which can specify a single new source IP address, an inclusive range
 of IP addresses, and optionally, a port range (which is only valid if
 the rule also specifies
diff --git a/extensions/libxt_connmark.man b/extensions/libxt_connmark.man
index 193a4ca..a50c537 100644
--- a/extensions/libxt_connmark.man
+++ b/extensions/libxt_connmark.man
@@ -1,6 +1,6 @@
 This module matches the netfilter mark field associated with a connection
 (which can be set using the \fBCONNMARK\fR target below).
 .TP
-\fB--mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+[\fB!\fP] \fB--mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
 Matches packets in connections with the given mark value (if a mask is
 specified, this is logically ANDed with the mark before the comparison).
diff --git a/extensions/libxt_helper.man b/extensions/libxt_helper.man
index c3221ad..3df1d05 100644
--- a/extensions/libxt_helper.man
+++ b/extensions/libxt_helper.man
@@ -1,6 +1,6 @@
 This module matches packets related to a specific conntrack-helper.
 .TP
-.BI "--helper " "string"
+[\fB!\fP] \fB--helper\fP \fIstring\fP
 Matches packets related to the specified conntrack-helper.
 .RS
 .PP
diff --git a/extensions/libxt_iprange.man b/extensions/libxt_iprange.man
index 5acb3b3..1941a3b 100644
--- a/extensions/libxt_iprange.man
+++ b/extensions/libxt_iprange.man
@@ -1,7 +1,7 @@
 This matches on a given arbitrary range of IP addresses.
 .TP
-[\fB!\fR] \fB--src-range\fR \fIfrom\fR-\fIto\fR
+[\fB!\fR] \fB--src-range\fR \fIfrom\fR[\fB-\fP\fIto\fR]
 Match source IP in the specified range.
 .TP
-[\fB!\fR] \fB--dst-range\fR \fIfrom\fR-\fIto\fR
+[\fB!\fR] \fB--dst-range\fR \fIfrom\fR[\fB-\fP\fIto\fR]
 Match destination IP in the specified range.
diff --git a/extensions/libxt_mark.man b/extensions/libxt_mark.man
index a2a1395..4b29cd0 100644
--- a/extensions/libxt_mark.man
+++ b/extensions/libxt_mark.man
@@ -3,7 +3,7 @@ This module matches the netfilter mark field associated with a packet
 .B MARK
 target below).
 .TP
-.BR "--mark " "\fIvalue\fP[/\fImask\fP]"
+[\fB!\fP] \fB--mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches packets with the given unsigned mark value (if a \fImask\fP is
 specified, this is logically ANDed with the \fImask\fP before the
 comparison).
diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index 344ce2e..0bc0c65 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -3,17 +3,17 @@ for locally generated packets. This match is only valid in the OUTPUT and
 POSTROUTING chains. Forwarded packets do not have any socket associated with
 them. Packets from kernel threads do have a socket, but usually no owner.
 .TP
-\fB--uid-owner\fR \fIusername\fR
+[\fB!\fP] \fB--uid-owner\fP \fIusername\fP
 .TP
-\fB--uid-owner\fR \fIuserid\fR[\fB-\fR\fIuserid\fR]
+[\fB!\fP] \fB--uid-owner\fP \fIuserid\fP[\fB-\fP\fIuserid\fP]
 Matches if the packet socket's file structure (if it has one) is owned by the
 given user. You may also specify a numerical UID, or an UID range.
 .TP
-\fB--gid-owner\fR \fIgroupname\fR
+[\fB!\fP] \fB--gid-owner\fP \fIgroupname\fP
 .TP
-\fB--gid-owner\fR \fIgroupid\fR[\fB-\fR\fIgroupid\fR]
+[\fB!\fP] \fB--gid-owner\fP \fIgroupid\fP[\fB-\fR\fIgroupid\fP]
 Matches if the packet socket's file structure is owned by the given group.
 You may also specify a numerical GID, or a GID range.
 .TP
-\fB--socket-exists\fR
+[\fB!\fP] \fB--socket-exists\fP
 Matches if the packet is associated with a socket.
diff --git a/extensions/libxt_tos.man b/extensions/libxt_tos.man
index 0420105..cd72e95 100644
--- a/extensions/libxt_tos.man
+++ b/extensions/libxt_tos.man
@@ -2,11 +2,11 @@ This module matches the 8-bit Type of Service field in the IPv4 header (i.e.
 including the "Precedence" bits) or the (also 8-bit) Priority field in the IPv6
 header.
 .TP
-\fB--tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+[\fB!\fP] \fB--tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
 Matches packets with the given TOS mark value. If a mask is specified, it is
 logically ANDed with the TOS mark before the comparison.
 .TP
-\fB--tos\fR \fIsymbol\fR
+[\fB!\fP] \fB--tos\fR \fIsymbol\fR
 You can specify a symbolic name when using the tos match for IPv4. The list of
 recognized TOS names can be obtained by calling iptables with \fB-m tos -h\fR.
 Note that this implies a mask of 0x3F, i.e. all but the ECN bits.
-- 
1.5.5.rc3

