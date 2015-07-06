From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 10/16] rule: fix use of intervals in set declarations
Date: Mon,  6 Jul 2015 20:17:02 +0200
Message-ID: <1436206628-23894-11-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbbGFSLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:43 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft add table test
 # nft add set test myset { type ipv4_addr\; flags interval\; }
 # nft add element test myset { 1.2.3.0/24 }

Then the listing shows:

 set myset2 {
         type ipv4_addr
         flags interval
         elements = { 1.2.3.0/24}
 }

This patch relies on the table and set caches.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=994
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 2b663f5..0077f8e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -746,10 +746,26 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct expr *expr)
+			   struct expr *expr)
 {
+	struct table *table;
+	struct set *set;
+
+	table = table_lookup(h);
+	if (table == NULL)
+		return -1;
+
+	set = set_lookup(table, h->set);
+	if (set == NULL)
+		return -1;
+
+	if (set->flags & SET_F_INTERVAL &&
+	    set_to_intervals(ctx->msgs, set, expr) < 0)
+		return -1;
+
 	if (netlink_add_setelems(ctx, h, expr) < 0)
 		return -1;
+
 	return 0;
 }
 
-- 
1.7.10.4

