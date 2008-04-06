From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 22/24] manpages: fix broken markup (missing close tags)
Date: Sun,  6 Apr 2008 17:27:19 +0200
Message-ID: <3489ac6539741736c53d90fd1ba499fac4d6591a.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56493 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYDFP11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:27 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rework the whole line's markup at the same time.
---
 extensions/libip6t_ah.man      |    2 +-
 extensions/libip6t_dst.man     |    2 +-
 extensions/libxt_NFQUEUE.man   |    2 +-
 extensions/libxt_connbytes.man |    2 +-
 extensions/libxt_connlimit.man |    2 +-
 extensions/libxt_dccp.man      |    4 ++--
 extensions/libxt_recent.man    |    4 ++--
 extensions/libxt_sctp.man      |    6 +++---
 extensions/libxt_u32.man       |    2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/extensions/libip6t_ah.man b/extensions/libip6t_ah.man
index 09d00fd..807f9e3 100644
--- a/extensions/libip6t_ah.man
+++ b/extensions/libip6t_ah.man
@@ -3,7 +3,7 @@ This module matches the parameters in Authentication header of IPsec packets.
 .BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
 Matches SPI.
 .TP
-.BR "--ahlen " "[!] \fIlength"
+[\fB!\fP] \fB--ahlen\fP \fIlength\fP
 Total length of this header in octets.
 .TP
 .BI "--ahres"
diff --git a/extensions/libip6t_dst.man b/extensions/libip6t_dst.man
index f42d822..d895a0e 100644
--- a/extensions/libip6t_dst.man
+++ b/extensions/libip6t_dst.man
@@ -1,6 +1,6 @@
 This module matches the parameters in Destination Options header
 .TP
-.BR "--dst-len " "[!] \fIlength"
+[\fB!\fP] \fB--dst-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
 .BR "--dst-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index c4e9d11..015effd 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -2,7 +2,7 @@ This target is an extension of the QUEUE target. As opposed to QUEUE, it allows
 you to put a packet into any specific queue, identified by its 16-bit queue
 number.  
 .TP
-.BR "--queue-num " "\fIvalue"
+\fB--queue-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valud queue numbers are 0 to 65535. The default value is 0.
 .TP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index ce7b665..7b7c313 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -10,7 +10,7 @@ scheduled using a lower priority band in traffic control.
 The transfered bytes per connection can also be viewed through
 /proc/net/ip_conntrack and accessed via ctnetlink
 .TP
-[\fB!\fR]\fB --connbytes \fIfrom\fB:\fR[\fIto\fR]
+[\fB!\fP] \fB--connbytes\fP \fIfrom\fP[\fB:\fR\fIto\fP]
 match packets from a connection whose packets/bytes/average packet
 size is more than FROM and less than TO bytes/packets. if TO is
 omitted only FROM check is done. "!" is used to match packets not
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index ca5974e..dd6a155 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -1,7 +1,7 @@
 Allows you to restrict the number of parallel connections to a server per
 client IP address (or client address block).
 .TP
-[\fB!\fR] \fB--connlimit-above \fIn\fR
+[\fB!\fP] \fB--connlimit-above\fP \fIn\fP
 Match if the number of existing connections is (not) above \fIn\fR.
 .TP
 \fB--connlimit-mask\fR \fIprefix_length\fR
diff --git a/extensions/libxt_dccp.man b/extensions/libxt_dccp.man
index 6443ec3..d962ef0 100644
--- a/extensions/libxt_dccp.man
+++ b/extensions/libxt_dccp.man
@@ -1,7 +1,7 @@
 .TP
-\fB--source-port\fR,\fB--sport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-\fB--destination-port\fR,\fB--dport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
 \fB--dccp-types\fR [\fB!\fR] \fImask\fP
 Match when the DCCP packet type is one of 'mask'. 'mask' is a comma-separated
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 6b7fc86..478ffaf 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -33,12 +33,12 @@ Check if the source address of the packet is currently in the list and if so
 that address will be removed from the list and the rule will return true. If
 the address is not found, false is returned.
 .TP
-[\fB!\fR] \fB--seconds \fIseconds\fR
+[\fB!\fP] \fB--seconds\fP \fIseconds\fP
 This option must be used in conjunction with one of \fB--rcheck\fR or
 \fB--update\fR. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
-[\fB!\fR] \fB--hitcount \fIhits\fR
+[\fB!\fP] \fB--hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB--rcheck\fR or
 \fB--update\fR. When used, this will narrow the match to only happen when the
 address is in the list and packets had been received greater than or equal to
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 97b467d..5d7a477 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -1,9 +1,9 @@
 .TP
-\fB--source-port\fR,\fB--sport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-\fB--destination-port\fR,\fB--dport \fR[\fB!\fR] \fIport\fR[\fB:\fIport\fR]
+[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-\fB--chunk-types\fR [\fB!\fR] \fBall\fR|\fBany\fR|\fBonly \fIchunktype\fR[\fB:\fIflags\fR] [...]
+[\fB!\fP] \fB--chunk-types\fP {\fBall\fP|\fBany\fP|\fBonly\fP} \fIchunktype\fP[\fB:\fP\fIflags\fP] [...]
 The flag letter in upper case indicates that the flag is to match if set,
 in the lower case indicates to match if unset.
 
diff --git a/extensions/libxt_u32.man b/extensions/libxt_u32.man
index 1ac02bc..8e00cc1 100644
--- a/extensions/libxt_u32.man
+++ b/extensions/libxt_u32.man
@@ -2,7 +2,7 @@ U32 tests whether quantities of up to 4 bytes extracted from a packet have
 specified values. The specification of what to extract is general enough to
 find data at given offsets from tcp headers or payloads.
 .TP
-[\fB!\fR]\fB --u32 \fItests\fR
+[\fB!\fP] \fB--u32\fP \fItests\fP
 The argument amounts to a program in a small language described below.
 .IP
 tests := location "=" value | tests "&&" location "=" value
-- 
1.5.5.rc3

