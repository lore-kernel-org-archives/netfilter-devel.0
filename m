From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,WIP 4/5] netfilter: nf_tables: flow offload expression
Date: Fri,  3 Nov 2017 16:26:35 +0100
Message-ID: <20171103152636.9967-5-pablo@netfilter.org>
References: <20171103152636.9967-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171103152636.9967-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add new instruction for the nf_tables VM that allows us to specify what
flows are offloaded. This has an explicit dependency with the conntrack
subsystem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   9 +
 net/netfilter/Kconfig                    |   7 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_flow_offload.c         | 331 +++++++++++++++++++++++++++++++
 4 files changed, 348 insertions(+)
 create mode 100644 net/netfilter/nft_flow_offload.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 871afa4871bf..2edde548de68 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -948,6 +948,15 @@ enum nft_ct_attributes {
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
+/**
+ * enum nft_ct_offload_attributes - ct offload expression attributes
+ */
+enum nft_offload_attributes {
+	NFTA_CT_OFFLOAD_UNSPEC,
+	__NFTA_CT_OFFLOAD_MAX,
+};
+#define NFTA_CT_OFFLOAD_MAX	(__NFTA_CT_OFFLOAD_MAX - 1)
+
 enum nft_limit_type {
 	NFT_LIMIT_PKTS,
 	NFT_LIMIT_PKT_BYTES
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f022ca91f49d..0a5c33cfaeb8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -504,6 +504,13 @@ config NFT_CT
 	  This option adds the "ct" expression that you can use to match
 	  connection tracking information such as the flow state.
 
+config NFT_FLOW_OFFLOAD
+	depends on NF_CONNTRACK
+	tristate "Netfilter nf_tables hardware flow offload module"
+	help
+	  This option adds the "flow_offload" expression that you can use to
+	  choose what flows are placed into the hardware.
+
 config NFT_SET_RBTREE
 	tristate "Netfilter nf_tables rbtree set module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 518f54113e06..801ce5c25e5d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_RT)		+= nft_rt.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
+obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 obj-$(CONFIG_NFT_OBJREF)	+= nft_objref.o
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
new file mode 100644
index 000000000000..d38d185a19a5
--- /dev/null
+++ b/net/netfilter/nft_flow_offload.c
@@ -0,0 +1,331 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/flow_offload.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+union flow_gateway {
+	__be32		ip;
+	struct in6_addr	ip6;
+};
+
+static int flow_offload_iterate_cleanup(struct nf_conn *ct, void *data)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload_tuple tuple = {};
+	struct net_device *indev = data;
+	struct flow_offload *flow;
+
+	if (!test_and_clear_bit(IPS_OFFLOAD_BIT, &ct->status))
+		return 0;
+
+	tuple.src_v4 = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in;
+	tuple.dst_v4 = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in;
+	tuple.src_port = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port;
+	tuple.dst_port = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
+	tuple.l3proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	tuple.l4proto = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+
+	tuplehash = flow_offload_lookup(&tuple);
+	BUG_ON(!tuplehash);
+
+	if (indev && tuplehash->tuple.iifidx != indev->ifindex)
+		return 0;
+
+	flow = container_of(tuplehash, struct flow_offload,
+			    tuplehash[tuplehash->tuple.dir]);
+
+	flow_offload_del(flow);
+
+	/* Do not remove this conntrack from table. */
+	return 0;
+}
+
+static void flow_offload_cleanup(struct net *net,
+				 const struct net_device *dev)
+{
+	nf_ct_iterate_cleanup_net(net, flow_offload_iterate_cleanup,
+				  (void *)dev, 0, 0);
+}
+
+static int flow_offload_netdev_event(struct notifier_block *this,
+				     unsigned long event, void *ptr)
+{
+	const struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (event != NETDEV_DOWN)
+		return NOTIFY_DONE;
+
+	flow_offload_cleanup(dev_net(dev), dev);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block flow_offload_netdev_notifier = {
+	.notifier_call	= flow_offload_netdev_event,
+};
+
+static struct flow_offload *
+flow_offload_alloc(const struct nf_conn *ct, int iifindex, int oifindex,
+		   union flow_gateway *orig_gateway,
+		   union flow_gateway *reply_gateway)
+{
+	struct flow_offload *flow;
+
+	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+	if (!flow)
+		return NULL;
+
+	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num) {
+	case NFPROTO_IPV4:
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4 =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4 =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4 =
+			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.in;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4 =
+			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.in;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l3proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l3proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l4proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.gateway =
+			orig_gateway->ip;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.gateway =
+			reply_gateway->ip;
+		break;
+	case NFPROTO_IPV6:
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6 =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.in6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6 =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v6 =
+			ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.in6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v6 =
+			ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.in6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l3proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l3proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.l4proto =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.gateway6 =
+			orig_gateway->ip6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.gateway6 =
+			reply_gateway->ip6;
+		break;
+	}
+
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port =
+		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port =
+		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port =
+		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port =
+		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
+
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dir = FLOW_OFFLOAD_DIR_ORIGINAL;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dir = FLOW_OFFLOAD_DIR_REPLY;
+
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx = oifindex;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.oifidx = iifindex;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx = iifindex;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.oifidx = oifindex;
+
+	if (ct->status & IPS_SRC_NAT)
+		flow->flags |= FLOW_OFFLOAD_SNAT;
+	else if (ct->status & IPS_DST_NAT)
+		flow->flags |= FLOW_OFFLOAD_DNAT;
+
+	return flow;
+}
+
+static int nft_flow_route(const struct nft_pktinfo *pkt,
+			  const struct nf_conn *ct,
+			  union flow_gateway *orig_gw,
+			  union flow_gateway *reply_gw)
+{
+	const struct dst_entry *reply_dst = skb_dst(pkt->skb);
+	struct dst_entry *orig_dst;
+	const struct nf_afinfo *ai;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(fl));
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		fl.u.ip4.daddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip;
+		break;
+	case NFPROTO_IPV6:
+		fl.u.ip6.daddr = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6;
+		break;
+	}
+
+	ai = nf_get_afinfo(nft_pf(pkt));
+	if (ai) {
+		ai->route(nft_net(pkt), &orig_dst, &fl, false);
+		if (!orig_dst)
+			return -ENOENT;
+	}
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4: {
+		const struct rtable *orig_rt = (const struct rtable *)orig_dst;
+		const struct rtable *reply_rt =
+			(const struct rtable *)reply_dst;
+
+		orig_gw->ip = orig_rt->rt_gateway;
+		reply_gw->ip = reply_rt->rt_gateway;
+		break;
+		}
+	case NFPROTO_IPV6:
+		break;
+	default:
+		break;
+	}
+
+	dst_release(orig_dst);
+
+	return 0;
+}
+
+static void nft_flow_offload_eval(const struct nft_expr *expr,
+				  struct nft_regs *regs,
+				  const struct nft_pktinfo *pkt)
+{
+	union flow_gateway orig_gateway, reply_gateway;
+	struct net_device *outdev = pkt->xt.state->out;
+	struct net_device *indev = pkt->xt.state->in;
+	enum ip_conntrack_info ctinfo;
+	struct flow_offload *flow;
+	struct nf_conn *ct;
+	int ret;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct)
+		goto out;
+
+	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		break;
+	default:
+		goto out;
+	}
+
+	if (test_bit(IPS_HELPER_BIT, &ct->status))
+		goto out;
+
+	if (ctinfo == IP_CT_NEW ||
+	    ctinfo == IP_CT_RELATED)
+		goto out;
+
+	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
+		goto out;
+
+	if (nft_flow_route(pkt, ct, &orig_gateway, &reply_gateway) < 0)
+		goto err1;
+
+	flow = flow_offload_alloc(ct, indev->ifindex, outdev->ifindex,
+				  &orig_gateway, &reply_gateway);
+	if (!flow)
+		goto err1;
+
+	ret = flow_offload_add(flow);
+	if (ret < 0)
+		goto err2;
+
+	return;
+err2:
+	kfree(flow);
+err1:
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
+out:
+	regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_flow_offload_validate(const struct nft_ctx *ctx,
+				     const struct nft_expr *expr,
+				     const struct nft_data **data)
+{
+	unsigned int hook_mask = (1 << NF_INET_FORWARD);
+
+	return nft_chain_validate_hooks(ctx->chain, hook_mask);
+}
+
+static int nft_flow_offload_init(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nlattr * const tb[])
+{
+	return nf_ct_netns_get(ctx->net, ctx->afi->family);
+}
+
+static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
+				     const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, ctx->afi->family);
+}
+
+static int nft_flow_offload_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	return 0;
+}
+
+struct nft_expr_type nft_flow_offload_type;
+static const struct nft_expr_ops nft_flow_offload_ops = {
+	.type		= &nft_flow_offload_type,
+	.size		= NFT_EXPR_SIZE(0),
+	.eval		= nft_flow_offload_eval,
+	.init		= nft_flow_offload_init,
+	.destroy	= nft_flow_offload_destroy,
+	.validate	= nft_flow_offload_validate,
+	.dump		= nft_flow_offload_dump,
+};
+
+struct nft_expr_type nft_flow_offload_type __read_mostly = {
+	.name		= "flow_offload",
+	.ops		= &nft_flow_offload_ops,
+	.maxattr	= NFTA_CT_OFFLOAD_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_flow_offload_module_init(void)
+{
+	register_netdevice_notifier(&flow_offload_netdev_notifier);
+
+	return nft_register_expr(&nft_flow_offload_type);
+}
+
+static void __exit nft_flow_offload_module_exit(void)
+{
+	struct net *net;
+
+	nft_unregister_expr(&nft_flow_offload_type);
+	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
+	rtnl_lock();
+	for_each_net(net)
+		flow_offload_cleanup(net, NULL);
+	rtnl_unlock();
+}
+
+module_init(nft_flow_offload_module_init);
+module_exit(nft_flow_offload_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_EXPR("flow_offload");
-- 
2.11.0
