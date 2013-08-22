From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: allow to specify the base chain type
Date: Thu, 22 Aug 2013 17:26:31 +0200
Message-ID: <1377185191-9961-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab3HVP0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:26:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to specify the type of the base chain, eg.

	add table mangle
	add chain mangle OUTPUT { type route hook NF_INET_LOCAL_OUT 0; }

The chain type determines the semantics of the chain, we currently
have three types:

* filter, used for plain packet filtering.
* nat, it only sees the first packet of the flow.
* route, which is the equivalent of the iptables mangle table, that
  triggers a re-route if there is any change in some of the packet header
  fields, eg. IP TOS/DSCP, or the packet metainformation, eg. mark.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    2 ++
 src/netlink.c  |   26 ++++++++++++++++++++------
 src/parser.y   |   14 ++++++++------
 src/rule.c     |    5 ++---
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 2577cff..4f68431 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -100,6 +100,7 @@ enum chain_flags {
  * @flags:	chain flags
  * @hooknum:	hook number (base chains)
  * @priority:	hook priority (base chains)
+ * @type:	chain type
  * @rules:	rules contained in the chain
  */
 struct chain {
@@ -109,6 +110,7 @@ struct chain {
 	uint32_t		flags;
 	unsigned int		hooknum;
 	unsigned int		priority;
+	const char		*type;
 	struct scope		scope;
 	struct list_head	rules;
 };
diff --git a/src/netlink.c b/src/netlink.c
index 5129cac..962561f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -461,6 +461,8 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 				       chain->hooknum);
 		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
 				       chain->priority);
+		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
+				       chain->type);
 	}
 	netlink_dump_chain(nlc);
 	err = mnl_nft_chain_add(nf_sock, nlc, NLM_F_EXCL);
@@ -524,10 +526,17 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
 	chain->handle.handle =
 		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
-	chain->hooknum       =
-		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
-	chain->priority      =
-		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+
+	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE)) {
+		chain->hooknum       =
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+		chain->priority      =
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+		chain->type          =
+			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
+	}
 	list_add_tail(&chain->list, &ctx->list);
 
 	return 0;
@@ -579,8 +588,13 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 	chain->handle.family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
 	chain->handle.table  = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
 	chain->handle.handle = nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
-	chain->hooknum       = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
-	chain->priority      = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO)) {
+		chain->hooknum       = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+		chain->priority      = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+		chain->type          = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
+	}
 	list_add_tail(&chain->list, &ctx->list);
 
 	nft_chain_free(nlc);
diff --git a/src/parser.y b/src/parser.y
index ff8de47..f0eb8e3 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -766,16 +766,18 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
-hook_spec		:	HOOK		HOOKNUM		NUM
+hook_spec		:	TYPE		STRING		HOOK		HOOKNUM		NUM
 			{
-				$<chain>0->hooknum	= $2;
-				$<chain>0->priority	= $3;
+				$<chain>0->type		= $2;
+				$<chain>0->hooknum	= $4;
+				$<chain>0->priority	= $5;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
-			|	HOOK		HOOKNUM		DASH	NUM
+			|	TYPE		STRING		HOOK		HOOKNUM		DASH	NUM
 			{
-				$<chain>0->hooknum	= $2;
-				$<chain>0->priority	= -$4;
+				$<chain>0->type		= $2;
+				$<chain>0->hooknum	= $4;
+				$<chain>0->priority	= -$6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
 			;
diff --git a/src/rule.c b/src/rule.c
index 8368624..fb0387c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -250,9 +250,8 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->hooknum) {
-		printf("\t\t hook %s %u;\n",
-		hooknum2str(chain->hooknum),
-		chain->priority);
+		printf("\t\t type %s hook %s %u;\n", chain->type,
+		       hooknum2str(chain->hooknum), chain->priority);
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
-- 
1.7.10.4

