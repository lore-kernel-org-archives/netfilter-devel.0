From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: remove nft_dereference()
Date: Sun, 31 Dec 2017 00:14:23 +0100
Message-ID: <20171230231423.5590-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdL3XO3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:14:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9480CC51A9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:14:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 860A7DA3A2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:14:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8922EDA3A2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:14:26 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 704544265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:14:26 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This macro is unnecessary, it just hides details for one single caller.
nfnl_dereference() is just enough.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 3 ---
 net/netfilter/nf_tables_api.c     | 6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 730f2898ef66..2e907f695828 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1092,9 +1092,6 @@ void nft_trace_notify(struct nft_traceinfo *info);
 int nf_tables_filter_init(void);
 void nf_tables_filter_fini(void);
 
-#define nft_dereference(p)					\
-	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
-
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6289404207b..903fb9bd0147 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1115,13 +1115,13 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 static void nft_chain_stats_replace(struct nft_base_chain *chain,
 				    struct nft_stats __percpu *newstats)
 {
+	struct nft_stats __percpu *oldstats;
+
 	if (newstats == NULL)
 		return;
 
 	if (chain->stats) {
-		struct nft_stats __percpu *oldstats =
-				nft_dereference(chain->stats);
-
+		oldstats = nfnl_dereference(chain->stats, NFNL_SUBSYS_NFTABLES);
 		rcu_assign_pointer(chain->stats, newstats);
 		synchronize_rcu();
 		free_percpu(oldstats);
-- 
2.11.0

