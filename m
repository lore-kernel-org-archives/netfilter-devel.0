From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/15] netfilter: nf_tables: don't assume chain stats are set when jumplabel is set
Date: Mon, 14 May 2018 00:36:52 +0200
Message-ID: <20180513223656.10077-12-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nft_chain_stats_replace() and all other spots assume ->stats can be
NULL, but nft_update_chain_stats does not.  It must do this check,
just because the jump label is set doesn't mean all basechains have stats
assigned.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index dfd0bf3810d2..942702a2776f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -119,15 +119,22 @@ DEFINE_STATIC_KEY_FALSE(nft_counters_enabled);
 static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 					    const struct nft_pktinfo *pkt)
 {
+	struct nft_base_chain *base_chain;
 	struct nft_stats *stats;
 
-	local_bh_disable();
-	stats = this_cpu_ptr(rcu_dereference(nft_base_chain(chain)->stats));
-	u64_stats_update_begin(&stats->syncp);
-	stats->pkts++;
-	stats->bytes += pkt->skb->len;
-	u64_stats_update_end(&stats->syncp);
-	local_bh_enable();
+	base_chain = nft_base_chain(chain);
+	if (!base_chain->stats)
+		return;
+
+	stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
+	if (stats) {
+		local_bh_disable();
+		u64_stats_update_begin(&stats->syncp);
+		stats->pkts++;
+		stats->bytes += pkt->skb->len;
+		u64_stats_update_end(&stats->syncp);
+		local_bh_enable();
+	}
 }
 
 struct nft_jumpstack {
-- 
2.11.0
