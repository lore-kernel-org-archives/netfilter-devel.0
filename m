From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: correct erroneous markup
Date: Sat, 9 Aug 2008 23:17:03 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808092314560.14334@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57443 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYHJDRG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:17:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Aug 9 23:11:43 2008 -0400

manpages: correct erroneous markup

Text paragraphs should use .PP, since .TP makes it a list item with
indented description.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.man      |    2 +-
 extensions/libipt_REJECT.man   |    2 +-
 extensions/libipt_SET.man      |    2 +-
 extensions/libipt_TTL.man      |    4 ++--
 extensions/libipt_addrtype.man |    2 +-
 extensions/libxt_NFQUEUE.man   |    2 +-
 extensions/libxt_NOTRACK.man   |    2 +-
 extensions/libxt_TCPMSS.man    |    2 +-
 extensions/libxt_statistic.man |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_HL.man b/extensions/libip6t_HL.man
index bf46881..050641f 100644
--- a/extensions/libip6t_HL.man
+++ b/extensions/libip6t_HL.man
@@ -4,7 +4,7 @@ Hop Limit field can potentially be very dangerous, so it should be avoided at
 any cost. This target is only valid in
 .B mangle
 table.
-.TP
+.PP
 .B Don't ever set or increment the value on packets that leave your local network!
 .TP
 .BI "--hl-set " "value"
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 174bf7b..d738a3d 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -30,5 +30,5 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.TP
+.PP
 (*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
diff --git a/extensions/libipt_SET.man b/extensions/libipt_SET.man
index 4da73ca..e2e2727 100644
--- a/extensions/libipt_SET.man
+++ b/extensions/libipt_SET.man
@@ -11,6 +11,6 @@ where flags are
 and/or
 .BR "dst"
 and there can be no more than six of them.
-.TP
+.PP
 The bindings to follow must previously be defined in order to use 
 multilevel adding/deleting by the SET target.
diff --git a/extensions/libipt_TTL.man b/extensions/libipt_TTL.man
index 97c46c4..25a4438 100644
--- a/extensions/libipt_TTL.man
+++ b/extensions/libipt_TTL.man
@@ -1,10 +1,10 @@
 This is used to modify the IPv4 TTL header field.  The TTL field determines
 how many hops (routers) a packet can traverse until it's time to live is
 exceeded.
-.TP
+.PP
 Setting or incrementing the TTL field can potentially be very dangerous,
 so it should be avoided at any cost.  
-.TP
+.PP
 .B Don't ever set or increment the value on packets that leave your local network!
 .B mangle
 table.
diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
index 275d999..88e7c66 100644
--- a/extensions/libipt_addrtype.man
+++ b/extensions/libipt_addrtype.man
@@ -2,7 +2,7 @@ This module matches packets based on their
 .B address type.
 Address types are used within the kernel networking stack and categorize
 addresses into various groups.  The exact definition of that group depends on the specific layer three protocol.
-.TP
+.PP
 The following address types are possible:
 .TP
 .BI "UNSPEC"
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index acd45e9..d76721a 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -4,7 +4,7 @@ number.
 .TP
 \fB--queue-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
-.TP
+.PP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
 the
 .B
diff --git a/extensions/libxt_NOTRACK.man b/extensions/libxt_NOTRACK.man
index 30e830a..c2cdf5a 100644
--- a/extensions/libxt_NOTRACK.man
+++ b/extensions/libxt_NOTRACK.man
@@ -1,5 +1,5 @@
 This target disables connection tracking for all packets matching that rule.
-.TP
+.PP
 It can only be used in the
 .B raw
 table.
diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index 82f93e0..1cb1fcc 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -39,5 +39,5 @@ Explicitly set MSS option to specified value.
 .TP
 .B "--clamp-mss-to-pmtu"
 Automatically clamp MSS value to (path_MTU - 40 for IPv4; -60 for IPv6).
-.TP
+.PP
 These options are mutually exclusive.
diff --git a/extensions/libxt_statistic.man b/extensions/libxt_statistic.man
index 007251d..7e17256 100644
--- a/extensions/libxt_statistic.man
+++ b/extensions/libxt_statistic.man
@@ -2,7 +2,7 @@ This module matches packets based on some statistic condition.
 It supports two distinct modes settable with the 
 .B --mode
 option.
-.TP
+.PP
 Supported options:
 .TP
 .BI "--mode " "mode"

