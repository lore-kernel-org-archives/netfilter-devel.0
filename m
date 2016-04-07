From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 5/5] conntrack: man: Add description of tables dying and unconfirmed.
Date: Thu,  7 Apr 2016 20:31:42 +0200
Message-ID: <1460053902-2200-6-git-send-email-mart.frauenlob@chello.at>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-2.mx.upcmail.net ([62.179.121.146]:47550 "EHLO
	vie01a-dmta-at01-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbcDGScW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 14:32:22 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoEj6-0006GL-9i
	for netfilter-devel@vger.kernel.org; Thu, 07 Apr 2016 20:32:20 +0200
In-Reply-To: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 conntrack.8 |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index e54951a..dfde9f0 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -48,6 +48,23 @@ mechanism used to "expect" RELATED connections to existing ones.  Expectations
 are generally used by "connection tracking helpers" (sometimes called
 application level gateways [ALGs]) for more complex protocols such as FTP,
 SIP, H.323.
+.TP
+.BR "dying" :
+This table shows the conntrack entries, that have expired and that have been
+destroyed by the connection tracking system itself, or via the conntrack utility.
+.TP
+.BR "unconfirmed" :
+This table shows new entries, that are not yet inserted into the conntrack table.
+These entries are attached to packets that are traversing the stack,
+but did not reach the confirmation point at the postrouting hook.
+.PP
+The tables "dying" and "unconfirmed" are basically only useful for debugging purposes.
+Under normal operation, it is hard to see entries in any of them.
+There are corner cases, where it is valid to see entries in the
+unconfirmed table:
+1) when packets that are enqueued via nfqueue, or
+2) when conntrackd runs in event reliable mode.
+.PP
 .SH OPTIONS
 The options recognized by 
 .B conntrack
-- 
1.7.2.5

