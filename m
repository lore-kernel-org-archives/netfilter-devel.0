From: Eric Leblond <eric@inl.fr>
Subject: [libnfnetlink] Suppress iftable_up function which is no used.
Date: Mon, 22 Dec 2008 23:07:55 +0100
Message-ID: <1229983675-5025-1-git-send-email-eric@inl.fr>
References: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr>
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org,
	Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45501 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757588AbYLVWIB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:08:01 -0500
In-Reply-To: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following compilation warning pointed out by Jan Engelhardt, this patch
suppresses the iftable_up function which is of no use in this part of
libnfnetlink library whom goal is to do ifindex to name resolution.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/iftable.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index b6a8e72..7cca66f 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -172,23 +172,6 @@ int nlif_index2name(struct nlif_handle *h,
 	return -1;
 }
 
-static int iftable_up(struct nlif_handle *h, unsigned int index)
-{
-	unsigned int hash;
-	struct ifindex_node *this;
-
-	hash = index & 0xF;
-	list_for_each_entry(this, &h->ifindex_hash[hash], head) {
-		if (this->index == index) {
-			if (this->flags & IFF_UP)
-				return 1;
-			else
-				return 0;
-		}
-	}
-	return -1;
-}
-
 /** Initialize interface table
  *
  * Initialize rtnl interface and interface table
-- 
1.5.6.3

