From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: libxt_conntrack.man extraneous commas
Date: Sun, 18 Aug 2013 15:44:13 -0400
Message-ID: <1376855053-6228-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:44586 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3HRToR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:44:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Laurence J. Lane" <ljlane@debian.org>

The first might work. The second doesn't.

(The other corrections in the bug report are already implemented.)

http://bugs.debian.org/654983

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/libxt_conntrack.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index 15fd1dd..4b13f0f 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -45,7 +45,7 @@ States for \fB\-\-ctstate\fP:
 The packet is associated with no known connection.
 .TP
 \fBNEW\fP
-The packet has started a new connection, or otherwise associated
+The packet has started a new connection or otherwise associated
 with a connection which has not seen packets in both directions.
 .TP
 \fBESTABLISHED\fP
@@ -54,7 +54,7 @@ in both directions.
 .TP
 \fBRELATED\fP
 The packet is starting a new connection, but is associated with an
-existing connection, such as an FTP data transfer, or an ICMP error.
+existing connection, such as an FTP data transfer or an ICMP error.
 .TP
 \fBUNTRACKED\fP
 The packet is not tracked at all, which happens if you explicitly untrack it
-- 
1.8.4.rc2

