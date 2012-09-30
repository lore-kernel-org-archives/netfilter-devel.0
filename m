From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 03/17] doc: trim "state" manpage and reference conntrack instead
Date: Sun, 30 Sep 2012 12:22:06 +0200
Message-ID: <1349000540-17508-4-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38811 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab2I3KW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:26 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The module is practically obsolete, so just pinpoint to the replacement
in short order.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_HMARK.man |    2 +-
 extensions/libxt_state.man |   28 ++++++----------------------
 2 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/extensions/libxt_HMARK.man b/extensions/libxt_HMARK.man
index 0b41884..e7b5426 100644
--- a/extensions/libxt_HMARK.man
+++ b/extensions/libxt_HMARK.man
@@ -52,7 +52,7 @@ A 32 bit random custom value to feed hash calculation.
 .PP
 \fIExamples:\fP
 .PP
-iptables \-t mangle \-A PREROUTING \-m state \-\-state NEW
+iptables \-t mangle \-A PREROUTING \-m conntrack \-\-ctstate NEW
  \-j HMARK \-\-hmark-tuple ct,src,dst,proto \-\-hmark-offset 10000
 \-\-hmark\-mod 10 \-\-hmark\-rnd 0xfeedcafe
 .PP
diff --git a/extensions/libxt_state.man b/extensions/libxt_state.man
index 37d095b..bd60468 100644
--- a/extensions/libxt_state.man
+++ b/extensions/libxt_state.man
@@ -1,24 +1,8 @@
-This module, when combined with connection tracking, allows access to
-the connection tracking state for this packet.
+The "state" module is an obsolete version of "conntrack".
+"state" allows access to the connection tracking state for this packet.
 .TP
 [\fB!\fP] \fB\-\-state\fP \fIstate\fP
-Where state is a comma separated list of the connection states to
-match.  Possible states are
-.B INVALID
-meaning that the packet could not be identified for some reason which
-includes running out of memory and ICMP errors which don't correspond to any
-known connection,
-.B ESTABLISHED
-meaning that the packet is associated with a connection which has seen
-packets in both directions,
-.B NEW
-meaning that the packet has started a new connection, or otherwise
-associated with a connection which has not seen packets in both
-directions, and
-.B RELATED
-meaning that the packet is starting a new connection, but is
-associated with an existing connection, such as an FTP data transfer,
-or an ICMP error.
-.B UNTRACKED
-meaning that the packet is not tracked at all, which happens if you use
-the NOTRACK target in raw table.
+Where state is a comma separated list of the connection states to match. Only a
+subset of the states unterstood by "conntrack" are recognized: \fBINVALID\fP,
+\fBESTABLISHED\fP, \fBNEW\fP, \fBRELATED\fP or \fBUNTRACKED\fP. For their
+description, see the "conntrack" heading in this manpage.
-- 
1.7.10.4

