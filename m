From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v16 5/8] sch_cake: Add NAT awareness to packet
 classifier
Date: Mon, 28 May 2018 16:27:46 +0200
Message-ID: <152751766690.30935.18178441475189968162.stgit@alrua-kau>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org, cake@lists.bufferbloat.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
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
 net/sched/sch_cake.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 68ac908470f1..fecd9caac0cc 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -71,6 +71,10 @@
 #include <net/tcp.h>
 #include <net/flow_dissector.h>
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack_core.h>
+#endif
+
 #define CAKE_SET_WAYS (8)
 #define CAKE_MAX_TINS (8)
 #define CAKE_QUEUES (1024)
@@ -516,6 +520,29 @@ static bool cobalt_should_drop(struct cobalt_vars *vars,
 	return drop;
 }
 
+static void cake_update_flowkeys(struct flow_keys *keys,
+				 const struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conntrack_tuple tuple = {};
+	bool rev = !skb->_nfct;
+
+	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
+		return;
+
+	if (!nf_ct_get_tuple_skb(&tuple, skb))
+		return;
+
+	keys->addrs.v4addrs.src = rev ? tuple.dst.u3.ip : tuple.src.u3.ip;
+	keys->addrs.v4addrs.dst = rev ? tuple.src.u3.ip : tuple.dst.u3.ip;
+
+	if (keys->ports.ports) {
+		keys->ports.src = rev ? tuple.dst.u.all : tuple.src.u.all;
+		keys->ports.dst = rev ? tuple.src.u.all : tuple.dst.u.all;
+	}
+#endif
+}
+
 /* Cake has several subtle multiple bit settings. In these cases you
  *  would be matching triple isolate mode as well.
  */
@@ -543,6 +570,9 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 	skb_flow_dissect_flow_keys(skb, &keys,
 				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
+	if (flow_mode & CAKE_FLOW_NAT_FLAG)
+		cake_update_flowkeys(&keys, skb);
+
 	/* flow_hash_from_keys() sorts the addresses by value, so we have
 	 * to preserve their order in a separate data structure to treat
 	 * src and dst host addresses as independently selectable.
@@ -1919,6 +1949,18 @@ static int cake_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_CAKE_NAT]) {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
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
 
@@ -2091,6 +2133,10 @@ static int cake_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_u32(skb, TCA_CAKE_ACK_FILTER, q->ack_filter))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_CAKE_NAT,
+			!!(q->flow_mode & CAKE_FLOW_NAT_FLAG)))
+		goto nla_put_failure;
+
 	return nla_nest_end(skb, opts);
 
 nla_put_failure:
