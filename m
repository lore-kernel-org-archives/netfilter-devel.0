From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/16] netfilter: nf_conncount: remove wrong condition check routine
Date: Wed, 28 Nov 2018 11:17:40 +0100
Message-ID: <20181128101741.20924-16-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

All lists that reach the tree_nodes_free() function have both zero
counter and true dead flag. The reason for this is that lists to be
release are selected by nf_conncount_gc_list() which already decrements
the list counter and sets on the dead flag. Therefore, this if statement
in tree_nodes_free() is unnecessary and wrong.

Fixes: 31568ec09ea0 ("netfilter: nf_conncount: fix list_del corruption in conn_free")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8acae4a3e4c0..b6d0f6deea86 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -323,11 +323,8 @@ static void tree_nodes_free(struct rb_root *root,
 	while (gc_count) {
 		rbconn = gc_nodes[--gc_count];
 		spin_lock(&rbconn->list.list_lock);
-		if (rbconn->list.count == 0 && rbconn->list.dead == false) {
-			rbconn->list.dead = true;
-			rb_erase(&rbconn->node, root);
-			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
-		}
+		rb_erase(&rbconn->node, root);
+		call_rcu(&rbconn->rcu_head, __tree_nodes_free);
 		spin_unlock(&rbconn->list.list_lock);
 	}
 }
-- 
2.11.0
