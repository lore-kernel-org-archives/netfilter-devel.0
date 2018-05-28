From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: nf_tables: disable preemption in nft_update_chain_stats()
Date: Tue, 29 May 2018 01:42:19 +0200
Message-ID: <20180528234221.31254-8-pablo@netfilter.org>
References: <20180528234221.31254-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528234221.31254-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch fixes the following splat.

[118709.054937] BUG: using smp_processor_id() in preemptible [00000000] code: test/1571
[118709.054970] caller is nft_update_chain_stats.isra.4+0x53/0x97 [nf_tables]
[118709.054980] CPU: 2 PID: 1571 Comm: test Not tainted 4.17.0-rc6+ #335
[...]
[118709.054992] Call Trace:
[118709.055011]  dump_stack+0x5f/0x86
[118709.055026]  check_preemption_disabled+0xd4/0xe4

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 942702a2776f..40e744572283 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -126,15 +126,15 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 	if (!base_chain->stats)
 		return;
 
+	local_bh_disable();
 	stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
 	if (stats) {
-		local_bh_disable();
 		u64_stats_update_begin(&stats->syncp);
 		stats->pkts++;
 		stats->bytes += pkt->skb->len;
 		u64_stats_update_end(&stats->syncp);
-		local_bh_enable();
 	}
+	local_bh_enable();
 }
 
 struct nft_jumpstack {
-- 
2.11.0
