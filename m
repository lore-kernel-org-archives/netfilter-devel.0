From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v3 4/7] src: early allocation of the set ID
Date: Thu,  2 Jul 2015 20:25:09 +0200
Message-ID: <1435861512-23572-5-git-send-email-pablo@netfilter.org>
References: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbbGBSTr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 14:19:47 -0400
In-Reply-To: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By when the set is created, so element in the batch use this set ID as
reference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    4 ----
 src/rule.c    |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 4b57aab..1f28bf6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1117,9 +1117,6 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	return err;
 }
 
-/* internal ID to uniquely identify a set in the batch */
-static uint32_t set_id;
-
 static int netlink_add_set_batch(struct netlink_ctx *ctx,
 				 const struct handle *h, struct set *set)
 {
@@ -1143,7 +1140,6 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	if (set->gc_int)
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_GC_INTERVAL, set->gc_int);
 
-	set->handle.set_id = ++set_id;
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
 
 	if (!(set->flags & (SET_F_CONSTANT))) {
diff --git a/src/rule.c b/src/rule.c
index 838bd7e..7491ee7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -56,6 +56,9 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->comment = xstrdup(src->comment);
 }
 
+/* internal ID to uniquely identify a set in the batch */
+static uint32_t set_id;
+
 struct set *set_alloc(const struct location *loc)
 {
 	struct set *set;
@@ -64,6 +67,8 @@ struct set *set_alloc(const struct location *loc)
 	set->refcnt = 1;
 	if (loc != NULL)
 		set->location = *loc;
+
+	set->handle.set_id = ++set_id;
 	return set;
 }
 
-- 
1.7.10.4

