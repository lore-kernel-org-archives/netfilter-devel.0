From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 01/17] doc: clean up interpunction in state list for xt_conntrack
Date: Sun, 30 Sep 2012 12:22:04 +0200
Message-ID: <1349000540-17508-2-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38809 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2I3KW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:26 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_conntrack.man |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index c397f74..c0cd24f 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -42,22 +42,22 @@ specified at all, matches packets in both directions.
 States for \fB\-\-ctstate\fP:
 .TP
 \fBINVALID\fP
-meaning that the packet is associated with no known connection
+The packet is associated with no known connection.
 .TP
 \fBNEW\fP
-meaning that the packet has started a new connection, or otherwise associated
-with a connection which has not seen packets in both directions, and
+The packet has started a new connection, or otherwise associated
+with a connection which has not seen packets in both directions.
 .TP
 \fBESTABLISHED\fP
-meaning that the packet is associated with a connection which has seen packets
-in both directions,
+The packet is associated with a connection which has seen packets
+in both directions.
 .TP
 \fBRELATED\fP
-meaning that the packet is starting a new connection, but is associated with an
+The packet is starting a new connection, but is associated with an
 existing connection, such as an FTP data transfer, or an ICMP error.
 .TP
 \fBUNTRACKED\fP
-meaning that the packet is not tracked at all, which happens if you use
+The packet is not tracked at all, which happens if you use
 the NOTRACK target in raw table.
 .TP
 \fBSNAT\fP
@@ -74,7 +74,7 @@ Statuses for \fB\-\-ctstatus\fP:
 None of the below.
 .TP
 \fBEXPECTED\fP
-This is an expected connection (i.e. a conntrack helper set it up)
+This is an expected connection (i.e. a conntrack helper set it up).
 .TP
 \fBSEEN_REPLY\fP
 Conntrack has seen packets in both directions.
-- 
1.7.10.4

