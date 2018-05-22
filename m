From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet
 classifier
Date: Tue, 22 May 2018 15:57:38 +0200
Message-ID: <152699745846.21931.4558451708304709296.stgit@alrua-kau>
References: <152699741881.21931.11656377745581563912.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org, cake@lists.bufferbloat.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152699741881.21931.11656377745581563912.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When CAKE is deployed on a gateway that also performs NAT (which is a
common deployment mode), the host fairness mechanism cannot distinguish
internal hosts from each other, and so fails to work correctly.

To fix this, we add an optional NAT awareness mode, which will query the
kernel conntrack mechanism to obtain the pre-NAT addresses for each packet
and use that in the flow and host hashing.

When the shaper is enabled and the host is already performing NAT, the cost
of this lookup is negligible. However, in unlimited mode with no NAT being
performed, there is a significant CPU cost at higher bandwidths. For this
reason, the feature is turned off by default.

Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/sched/sch_cake.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 68ac908470f1..6f7cae705c84 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -71,6 +71,12 @@
 #include <net/tcp.h>
 #include <net/flow_dissector.h>
 
+#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 #define CAKE_SET_WAYS (8)
 #define CAKE_MAX_TINS (8)
 #define CAKE_QUEUES (1024)
@@ -516,6 +522,60 @@ static bool cobalt_should_drop(struct cobalt_vars *vars,
 	return drop;
 }
 
+#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
+
+static void cake_update_flowkeys(struct flow_keys *keys,
+				 const struct sk_buff *skb)
+{
+	const struct nf_conntrack_tuple *tuple;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	bool rev = false;
+
+	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
+		return;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		tuple = nf_ct_tuple(ct, CTINFO2DIR(ctinfo));
+	} else {
+		const struct nf_conntrack_tuple_hash *hash;
+		struct nf_conntrack_tuple srctuple;
+
+		if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+				       NFPROTO_IPV4, dev_net(skb->dev),
+				       &srctuple))
+			return;
+
+		hash = nf_conntrack_find_get(dev_net(skb->dev),
+					     &nf_ct_zone_dflt,
+					     &srctuple);
+		if (!hash)
+			return;
+
+		rev = true;
+		ct = nf_ct_tuplehash_to_ctrack(hash);
+		tuple = nf_ct_tuple(ct, !hash->tuple.dst.dir);
+	}
+
+	keys->addrs.v4addrs.src = rev ? tuple->dst.u3.ip : tuple->src.u3.ip;
+	keys->addrs.v4addrs.dst = rev ? tuple->src.u3.ip : tuple->dst.u3.ip;
+
+	if (keys->ports.ports) {
+		keys->ports.src = rev ? tuple->dst.u.all : tuple->src.u.all;
+		keys->ports.dst = rev ? tuple->src.u.all : tuple->dst.u.all;
+	}
+	if (rev)
+		nf_ct_put(ct);
+}
+#else
+static void cake_update_flowkeys(struct flow_keys *keys,
+				 const struct sk_buff *skb)
+{
+	/* There is nothing we can do here without CONNTRACK */
+}
+#endif
+
 /* Cake has several subtle multiple bit settings. In these cases you
  *  would be matching triple isolate mode as well.
  */
@@ -543,6 +603,9 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 	skb_flow_dissect_flow_keys(skb, &keys,
 				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
+	if (flow_mode & CAKE_FLOW_NAT_FLAG)
+		cake_update_flowkeys(&keys, skb);
+
 	/* flow_hash_from_keys() sorts the addresses by value, so we have
 	 * to preserve their order in a separate data structure to treat
 	 * src and dst host addresses as independently selectable.
@@ -1919,6 +1982,18 @@ static int cake_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_CAKE_NAT]) {
+#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
+		q->flow_mode &= ~CAKE_FLOW_NAT_FLAG;
+		q->flow_mode |= CAKE_FLOW_NAT_FLAG *
+			!!nla_get_u32(tb[TCA_CAKE_NAT]);
+#else
+		NL_SET_ERR_MSG_ATTR(extack, "No conntrack support in kernel",
+				    tb[TCA_CAKE_NAT]);
+		return -EOPNOTSUPP;
+#endif
+	}
+
 	if (tb[TCA_CAKE_BASE_RATE64])
 		q->rate_bps = nla_get_u64(tb[TCA_CAKE_BASE_RATE64]);
 
@@ -2091,6 +2166,10 @@ static int cake_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_u32(skb, TCA_CAKE_ACK_FILTER, q->ack_filter))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_CAKE_NAT,
+			!!(q->flow_mode & CAKE_FLOW_NAT_FLAG)))
+		goto nla_put_failure;
+
 	return nla_nest_end(skb, opts);
 
 nla_put_failure:
