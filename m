From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: fix leaks in error path of nf_tables_newchain()
Date: Fri, 30 Jan 2015 18:38:11 +0100
Message-ID: <1422639491-9417-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33019 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbA3RfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 12:35:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release statistics and module refcount on memory allocation problems.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b543606..1ff04bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1264,8 +1264,10 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 		trans = nft_trans_alloc(&ctx, NFT_MSG_NEWCHAIN,
 					sizeof(struct nft_trans_chain));
-		if (trans == NULL)
+		if (trans == NULL) {
+			free_percpu(stats);
 			return -ENOMEM;
+		}
 
 		nft_trans_chain_stats(trans) = stats;
 		nft_trans_chain_update(trans) = true;
@@ -1321,8 +1323,10 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		hookfn = type->hooks[hooknum];
 
 		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
-		if (basechain == NULL)
+		if (basechain == NULL) {
+			module_put(type->owner);
 			return -ENOMEM;
+		}
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-- 
1.7.10.4

