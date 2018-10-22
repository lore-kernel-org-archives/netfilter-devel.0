From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] netfilter: nf_flow_table: do not remove offload when other netns's interface is down
Date: Mon, 22 Oct 2018 22:07:24 +0200
Message-ID: <20181022200724.25806-9-pablo@netfilter.org>
References: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

When interface is down, offload cleanup function(nf_flow_table_do_cleanup)
is called and that checks whether interface index of offload and
index of link down interface is same. but only interface index checking
is not enough because flowtable is not pernet list.
So that, if other netns's interface that has index is same with offload
is down, that offload will be removed.
This patch adds netns checking code to the offload cleanup routine.

Fixes: 59c466dd68e7 ("netfilter: nf_flow_table: add a new flow state for tearing down offloading")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d8125616edc7..c188e27972c7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -478,14 +478,17 @@ EXPORT_SYMBOL_GPL(nf_flow_table_init);
 static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
 
 	if (!dev) {
 		flow_offload_teardown(flow);
 		return;
 	}
-
-	if (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
-	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
+	if (net_eq(nf_ct_net(e->ct), dev_net(dev)) &&
+	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
+	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
 		flow_offload_dead(flow);
 }
 
-- 
2.11.0
