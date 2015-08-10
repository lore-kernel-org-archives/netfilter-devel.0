From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 07/14] src: early allocation of the set ID
Date: Mon, 10 Aug 2015 13:50:41 +0200
Message-ID: <1439207448-22485-8-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55995 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbHJLpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:01 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By when the set is created, so element in the batch use this set ID as
reference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    4 ----
 src/rule.c    |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 8ede8e6..0fb7b63 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1121,9 +1121,6 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	return err;
 }
 
-/* internal ID to uniquely identify a set in the batch */
-static uint32_t set_id;
-
 static int netlink_add_set_batch(struct netlink_ctx *ctx,
 				 const struct handle *h, struct set *set)
 {
@@ -1147,7 +1144,6 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	if (set->gc_int)
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_GC_INTERVAL, set->gc_int);
 
-	set->handle.set_id = ++set_id;
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
 
 	if (!(set->flags & (SET_F_CONSTANT))) {
diff --git a/src/rule.c b/src/rule.c
index 32c4a15..7f2a27f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -139,12 +139,16 @@ void cache_release(void)
 	cache_initialized = false;
 }
 
+/* internal ID to uniquely identify a set in the batch */
+static uint32_t set_id;
+
 struct set *set_alloc(const struct location *loc)
 {
 	struct set *set;
 
 	set = xzalloc(sizeof(*set));
 	set->refcnt = 1;
+	set->handle.set_id = ++set_id;
 	if (loc != NULL)
 		set->location = *loc;
 	return set;
-- 
1.7.10.4

