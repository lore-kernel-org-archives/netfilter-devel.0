From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] netfilter: nf_conncount: use rb_link_node_rcu() instead of rb_link_node()
Date: Thu, 13 Dec 2018 02:06:31 +0100
Message-ID: <20181213010631.9753-6-pablo@netfilter.org>
References: <20181213010631.9753-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213010631.9753-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

rbnode in insert_tree() is rcu protected pointer.
So, in order to handle this pointer, _rcu function should be used.
rb_link_node_rcu() is a rcu version of rb_link_node().

Fixes: 34848d5c896e ("netfilter: nf_conncount: Split insert and traversal")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index b6d0f6deea86..9cd180bda092 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -427,7 +427,7 @@ insert_tree(struct net *net,
 	count = 1;
 	rbconn->list.count = count;
 
-	rb_link_node(&rbconn->node, parent, rbnode);
+	rb_link_node_rcu(&rbconn->node, parent, rbnode);
 	rb_insert_color(&rbconn->node, root);
 out_unlock:
 	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
-- 
2.11.0
