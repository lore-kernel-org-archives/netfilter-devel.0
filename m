From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/51] netfilter: nf_flow_table: clean up flow_offload_alloc
Date: Mon,  7 May 2018 00:46:26 +0200
Message-ID: <20180506224709.29100-9-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Reduce code duplication and make it much easier to read

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table.c | 93 ++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 59 deletions(-)

diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index ec410cae9307..db0673a40b97 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -16,6 +16,38 @@ struct flow_offload_entry {
 	struct rcu_head		rcu_head;
 };
 
+static void
+flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
+		      struct nf_flow_route *route,
+		      enum flow_offload_tuple_dir dir)
+{
+	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+
+	ft->dir = dir;
+
+	switch (ctt->src.l3num) {
+	case NFPROTO_IPV4:
+		ft->src_v4 = ctt->src.u3.in;
+		ft->dst_v4 = ctt->dst.u3.in;
+		break;
+	case NFPROTO_IPV6:
+		ft->src_v6 = ctt->src.u3.in6;
+		ft->dst_v6 = ctt->dst.u3.in6;
+		break;
+	}
+
+	ft->l3proto = ctt->src.l3num;
+	ft->l4proto = ctt->dst.protonum;
+	ft->src_port = ctt->src.u.tcp.port;
+	ft->dst_port = ctt->dst.u.tcp.port;
+
+	ft->iifidx = route->tuple[dir].ifindex;
+	ft->oifidx = route->tuple[!dir].ifindex;
+
+	ft->dst_cache = route->tuple[dir].dst;
+}
+
 struct flow_offload *
 flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 {
@@ -40,65 +72,8 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 
 	entry->ct = ct;
 
-	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num) {
-	case NFPROTO_IPV4:
-		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4 =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4 =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4 =
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.in;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4 =
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.in;
-		break;
-	case NFPROTO_IPV6:
-		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6 =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6 =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v6 =
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.in6;
-		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v6 =
-			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.in6;
-		break;
-	}
-
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l3proto =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l3proto =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l4proto =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
-
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache =
-		  route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache =
-		  route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst;
-
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port =
-		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port =
-		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
-
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dir =
-						FLOW_OFFLOAD_DIR_ORIGINAL;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dir =
-						FLOW_OFFLOAD_DIR_REPLY;
-
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
-		route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].ifindex;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.oifidx =
-		route->tuple[FLOW_OFFLOAD_DIR_REPLY].ifindex;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
-		route->tuple[FLOW_OFFLOAD_DIR_REPLY].ifindex;
-	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.oifidx =
-		route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].ifindex;
+	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
-- 
2.11.0
