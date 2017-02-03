From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/27] netfilter: xt_connlimit: use rb_entry()
Date: Fri,  3 Feb 2017 13:25:18 +0100
Message-ID: <1486124738-3013-8-git-send-email-pablo@netfilter.org>
References: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connlimit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 2aff2b7c4689..660b61dbd776 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -218,7 +218,7 @@ count_tree(struct net *net, struct rb_root *root,
 		int diff;
 		bool addit;
 
-		rbconn = container_of(*rbnode, struct xt_connlimit_rb, node);
+		rbconn = rb_entry(*rbnode, struct xt_connlimit_rb, node);
 
 		parent = *rbnode;
 		diff = same_source_net(addr, mask, &rbconn->addr, family);
@@ -398,7 +398,7 @@ static void destroy_tree(struct rb_root *r)
 	struct rb_node *node;
 
 	while ((node = rb_first(r)) != NULL) {
-		rbconn = container_of(node, struct xt_connlimit_rb, node);
+		rbconn = rb_entry(node, struct xt_connlimit_rb, node);
 
 		rb_erase(node, r);
 
-- 
2.1.4
