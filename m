From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 04/17] doc: have NOTRACK manpage point to CT instead
Date: Sun, 30 Sep 2012 12:22:07 +0200
Message-ID: <1349000540-17508-5-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38810 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2I3KW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:26 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The module is obsolete, so point to CT --notrack instead.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_NOTRACK.man   |    6 ++----
 extensions/libxt_conntrack.man |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_NOTRACK.man b/extensions/libxt_NOTRACK.man
index c2cdf5a..633b965 100644
--- a/extensions/libxt_NOTRACK.man
+++ b/extensions/libxt_NOTRACK.man
@@ -1,5 +1,3 @@
 This target disables connection tracking for all packets matching that rule.
-.PP
-It can only be used in the
-.B raw
-table.
+It is obsoleted by \-j CT \-\-notrack. Like CT, NOTRACK can only be used in
+the \fBraw\fP table.
diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index c0cd24f..15fd1dd 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -57,8 +57,8 @@ The packet is starting a new connection, but is associated with an
 existing connection, such as an FTP data transfer, or an ICMP error.
 .TP
 \fBUNTRACKED\fP
-The packet is not tracked at all, which happens if you use
-the NOTRACK target in raw table.
+The packet is not tracked at all, which happens if you explicitly untrack it
+by using \-j CT \-\-notrack in the raw table.
 .TP
 \fBSNAT\fP
 A virtual state, matching if the original source address differs from the reply
-- 
1.7.10.4

