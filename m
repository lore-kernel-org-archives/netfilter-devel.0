From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 02/13] netfilter: nf_tables: restore chain change atomicity
Date: Thu,  9 Jan 2014 18:42:32 +0000
Message-ID: <1389292963-4089-3-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaAISnO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:14 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chain counter validation is performed after the chain policy has
potentially been changed. Move counter validation/setting before
changing of the chain policy to fix this.

Additionally fix a memory leak if chain counter allocation fails
for new chains, remove an unnecessary free_percpu() and move
counter allocation for new chains

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 30fad4f..d275d38 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -880,9 +880,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		    !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
 			return -EEXIST;
 
-		if (nla[NFTA_CHAIN_POLICY])
-			nft_base_chain(chain)->policy = policy;
-
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
@@ -893,6 +890,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 				return err;
 		}
 
+		if (nla[NFTA_CHAIN_POLICY])
+			nft_base_chain(chain)->policy = policy;
+
 		if (nla[NFTA_CHAIN_HANDLE] && name)
 			nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
@@ -934,6 +934,24 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (basechain == NULL)
 			return -ENOMEM;
 
+		if (nla[NFTA_CHAIN_COUNTERS]) {
+			err = nf_tables_counters(basechain,
+						 nla[NFTA_CHAIN_COUNTERS]);
+			if (err < 0) {
+				kfree(basechain);
+				return err;
+			}
+		} else {
+			struct nft_stats __percpu *newstats;
+
+			newstats = alloc_percpu(struct nft_stats);
+			if (newstats == NULL) {
+				kfree(basechain);
+				return -ENOMEM;
+			}
+			rcu_assign_pointer(basechain->stats, newstats);
+		}
+
 		basechain->type = type;
 		chain = &basechain->chain;
 
@@ -953,25 +971,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 		chain->flags |= NFT_BASE_CHAIN;
 		basechain->policy = policy;
-
-		if (nla[NFTA_CHAIN_COUNTERS]) {
-			err = nf_tables_counters(basechain,
-						 nla[NFTA_CHAIN_COUNTERS]);
-			if (err < 0) {
-				free_percpu(basechain->stats);
-				kfree(basechain);
-				return err;
-			}
-		} else {
-			struct nft_stats __percpu *newstats;
-
-			newstats = alloc_percpu(struct nft_stats);
-			if (newstats == NULL)
-				return -ENOMEM;
-
-			rcu_assign_pointer(nft_base_chain(chain)->stats,
-					   newstats);
-		}
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
-- 
1.8.4.2

