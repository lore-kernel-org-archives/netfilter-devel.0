From: Hendrik Schwartke <hendrik@os-t.de>
Subject: [PATCH] Changed type of chain.priority from unsigned int to int.
Date: Mon,  9 Jun 2014 23:39:32 +0200
Message-ID: <1402349972-18658-1-git-send-email-hendrik@os-t.de>
Cc: Hendrik Schwartke <hendrik@os-t.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:51122 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFIVkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:40:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This removes a bug that displays strange hook priorities
like "type route hook output priority 4294967146".
---
 include/rule.h |    2 +-
 src/netlink.c  |    6 +++---
 src/rule.c     |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ebdafe8..db91406 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -115,7 +115,7 @@ struct chain {
 	uint32_t		flags;
 	const char		*hookstr;
 	unsigned int		hooknum;
-	unsigned int		priority;
+	int			priority;
 	const char		*type;
 	struct scope		scope;
 	struct list_head	rules;
diff --git a/src/netlink.c b/src/netlink.c
index edefc76..2e7c572 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -485,7 +485,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
 		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
 				       chain->hooknum);
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
+		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
 				       chain->priority);
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
 				       chain->type);
@@ -512,7 +512,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
 		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
 				       chain->hooknum);
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
+		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
 				       chain->priority);
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
 				       chain->type);
@@ -667,7 +667,7 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		chain->hooknum       =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
 		chain->priority      =
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+			nft_chain_attr_get_s32(nlc, NFT_CHAIN_ATTR_PRIO);
 		chain->type          =
 			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
 		chain->flags        |= CHAIN_F_BASECHAIN;
diff --git a/src/rule.c b/src/rule.c
index 43a3e11..a7bc6f4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -418,7 +418,7 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s priority %u;\n", chain->type,
+		printf("\t\t type %s hook %s priority %d;\n", chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
 		       chain->priority);
 	}
@@ -439,7 +439,7 @@ void chain_print_plain(const struct chain *chain)
 	       chain->handle.table, chain->handle.chain);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf(" { type %s hook %s priority %u; }", chain->type,
+		printf(" { type %s hook %s priority %d; }", chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
 		       chain->priority);
 	}
-- 
1.7.10.4

