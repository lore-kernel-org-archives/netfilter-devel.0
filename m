From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: fix crash when adding new non-base chain
Date: Wed, 18 Mar 2015 18:13:41 +0100
Message-ID: <1426698821-5130-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbbCRRJz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 13:09:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix crash when adding a non-base chain introduced by acdfae9 ("src:
allow to specify the default policy for base chains").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2d1fb79..bd6aa93 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -500,17 +500,19 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nft_chain(h);
-	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-				       chain->hooknum);
-		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
-				       chain->priority);
-		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
-				       chain->type);
+	if (chain != NULL) {
+		if (chain->flags & CHAIN_F_BASECHAIN) {
+			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
+					       chain->hooknum);
+			nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
+					       chain->priority);
+			nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
+					       chain->type);
+		}
+		if (chain->policy != -1)
+			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
+					       chain->policy);
 	}
-	if (chain->policy != -1)
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
-				       chain->policy);
 
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
@@ -531,17 +533,19 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nft_chain(h);
-	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-				       chain->hooknum);
-		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
-				       chain->priority);
-		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
-				       chain->type);
+	if (chain != NULL) {
+		if (chain->flags & CHAIN_F_BASECHAIN) {
+			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
+					       chain->hooknum);
+			nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
+					       chain->priority);
+			nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
+					       chain->type);
+		}
+		if (chain->policy != -1)
+			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
+					       chain->policy);
 	}
-	if (chain->policy != -1)
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
-				       chain->policy);
 
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_batch_add(nlc, excl ? NLM_F_EXCL : 0,
-- 
1.7.10.4

