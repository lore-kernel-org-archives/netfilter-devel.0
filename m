From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/21] netfilter: nf_tables: flow event notifier must use transaction mutex
Date: Sun,  5 Aug 2018 23:21:31 +0200
Message-ID: <20180805212141.3033-12-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Fixes: f102d66b335a4 ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f18085639807..06d6af067619 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5940,13 +5940,13 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	if (!net)
 		return 0;
 
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	mutex_lock(&net->nft.commit_mutex);
 	list_for_each_entry(table, &net->nft.tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
 			nft_flowtable_event(event, dev, flowtable);
 		}
 	}
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+	mutex_unlock(&net->nft.commit_mutex);
 	put_net(net);
 	return NOTIFY_DONE;
 }
-- 
2.11.0
