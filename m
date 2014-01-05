From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: set maximum length in constant sets
Date: Sun,  5 Jan 2014 22:28:11 +0100
Message-ID: <1388957291-3745-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52316 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaAEV2S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:28:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is used to optimize the size of the set in the kernel in
case that the hash type is selected.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    4 ++++
 src/rule.c    |   14 ++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 59bd8e4..0ff65e1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -785,6 +785,10 @@ int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
 				     set->datalen / BITS_PER_BYTE);
 	}
+	if (set->flags & NFT_SET_CONSTANT) {
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_MAX_ELEMS,
+				     set->init->size);
+	}
 	netlink_dump_set(nls);
 
 	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..c9c8bb0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -474,14 +474,16 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		      struct set *set)
 {
+	if (set->init != NULL && set->flags & SET_F_INTERVAL)
+		set_to_intervals(set);
+
 	if (netlink_add_set(ctx, h, set) < 0)
 		return -1;
-	if (set->init != NULL) {
-		if (set->flags & SET_F_INTERVAL)
-			set_to_intervals(set);
-		if (do_add_setelems(ctx, &set->handle, set->init) < 0)
-			return -1;
-	}
+
+	if (set->init != NULL &&
+	    do_add_setelems(ctx, &set->handle, set->init) < 0)
+		return -1;
+
 	return 0;
 }
 
-- 
1.7.10.4

