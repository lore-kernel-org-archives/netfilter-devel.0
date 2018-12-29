From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/9] netfilter: nf_conncount: fix argument order to find_next_bit
Date: Sat, 29 Dec 2018 13:58:03 +0100
Message-ID: <20181229125803.7415-10-pablo@netfilter.org>
References: <20181229125803.7415-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181229125803.7415-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Size and 'next bit' were swapped, this bug could cause worker to
reschedule itself even if system was idle.

Fixes: 5c789e131cbb9 ("netfilter: nf_conncount: Add list lock and gc worker, and RCU for init tree search")
Reviewed-by: Shawn Bohrer <sbohrer@cloudflare.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index f0b05dfebc6e..7554c56b2e63 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -488,7 +488,7 @@ static void tree_gc_worker(struct work_struct *work)
 	clear_bit(tree, data->pending_trees);
 
 	next_tree = (tree + 1) % CONNCOUNT_SLOTS;
-	next_tree = find_next_bit(data->pending_trees, next_tree, CONNCOUNT_SLOTS);
+	next_tree = find_next_bit(data->pending_trees, CONNCOUNT_SLOTS, next_tree);
 
 	if (next_tree < CONNCOUNT_SLOTS) {
 		data->gc_tree = next_tree;
-- 
2.11.0
