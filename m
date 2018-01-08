From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 42/52] netfilter: nf_tables: remove nft_dereference()
Date: Mon,  8 Jan 2018 21:19:50 +0100
Message-ID: <20180108202000.12989-43-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This macro is unnecessary, it just hides details for one single caller.
nfnl_dereference() is just enough.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 3 ---
 net/netfilter/nf_tables_api.c     | 6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e040b6151acc..e3ec02fd0f67 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1113,9 +1113,6 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 
 void nft_trace_notify(struct nft_traceinfo *info);
 
-#define nft_dereference(p)					\
-	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
-
 #define MODULE_ALIAS_NFT_FAMILY(family)	\
 	MODULE_ALIAS("nft-afinfo-" __stringify(family))
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15773a3189ce..fa564dac66a2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1222,13 +1222,13 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
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
