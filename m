From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC,v2 4/6] netfilter: flow table support for IPv4
Date: Thu,  7 Dec 2017 13:44:59 +0100
Message-ID: <20171207124501.24325-5-pablo@netfilter.org>
References: <20171207124501.24325-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171207124501.24325-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the IPv4 flow table type, that implements the datapath
flow table to forward IPv4 traffic. Rationale is:

1) Look up for the packet in the flow table, from the ingress hook.
2) If there's a hit, decrement ttl and pass it on to the neighbour layer
   for transmission.
3) If there's a miss, packet is passed up to the classic forwarding
   path.

This patch also supports layer 3 source and destination NAT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig              |   8 +
 net/ipv4/netfilter/Makefile             |   3 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 316 ++++++++++++++++++++++++++++++++
 3 files changed, 327 insertions(+)
 create mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c11eb1744ab1..8b430c1744c4 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -177,6 +177,14 @@ config NF_NAT_H323
 
 endif # NF_NAT_IPV4
 
+config NF_FLOW_TABLE_IPV4
+	select NF_FLOW_TABLE
+	tristate "Netfilter flow table IPv4 module"
+	help
+	  This option adds the flow table IPv4 support.
+
+	  To compile it as a module, choose M here.
+
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index f462fee66ac8..ae39e1c569a8 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -52,6 +52,9 @@ obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 
+# flow table support
+obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
+
 # matches
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_RPFILTER) += ipt_rpfilter.o
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
new file mode 100644
index 000000000000..090a3fbcf211
--- /dev/null
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -0,0 +1,316 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <linux/ip.h>
+#include <linux/netdevice.h>
+#include <net/ip.h>
+#include <net/neighbour.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
+/* For layer 4 checksum field offset. */
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+static int nf_flow_nat_tcp(struct sk_buff *skb, unsigned int thoff,
+			   __be32 addr, __be32 new_addr)
+{
+	struct tcphdr *tcph;
+
+	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
+	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+		return -1;
+
+	tcph = (void *)(skb_network_header(skb) + thoff);
+	inet_proto_csum_replace4(&tcph->check, skb, addr, new_addr, true);
+
+	return 0;
+}
+
+static int nf_flow_nat_udp(struct sk_buff *skb, unsigned int thoff,
+			   __be32 addr, __be32 new_addr)
+{
+	struct udphdr *udph;
+
+	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
+	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+		return -1;
+
+	udph = (void *)(skb_network_header(skb) + thoff);
+	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
+		inet_proto_csum_replace4(&udph->check, skb, addr,
+					 new_addr, true);
+		if (!udph->check)
+			udph->check = CSUM_MANGLED_0;
+	}
+
+	return 0;
+}
+
+static int nf_flow_nat_l4proto(struct sk_buff *skb, struct iphdr *iph,
+			       unsigned int thoff, __be32 addr, __be32 new_addr)
+{
+	csum_replace4(&iph->check, addr, new_addr);
+
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		if (nf_flow_nat_tcp(skb, thoff, addr, new_addr) < 0)
+			return NF_DROP;
+		break;
+	case IPPROTO_UDP:
+		if (nf_flow_nat_udp(skb, thoff, addr, new_addr) < 0)
+			return NF_DROP;
+		break;
+	}
+
+	return 0;
+}
+
+static int nf_flow_snat_ip(const struct flow_offload *flow, struct sk_buff *skb,
+			   struct iphdr *iph, unsigned int thoff,
+			   enum flow_offload_tuple_dir dir)
+{
+	__be32 addr, new_addr;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = iph->saddr;
+		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4.s_addr;
+		iph->saddr = new_addr;
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = iph->daddr;
+		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4.s_addr;
+		iph->daddr = new_addr;
+		break;
+	default:
+		return -1;
+	}
+
+	return nf_flow_nat_l4proto(skb, iph, thoff, addr, new_addr);
+}
+
+static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
+			   struct iphdr *iph, unsigned int thoff,
+			   enum flow_offload_tuple_dir dir)
+{
+	__be32 addr, new_addr;
+
+	switch (dir) {
+	case FLOW_OFFLOAD_DIR_ORIGINAL:
+		addr = iph->daddr;
+		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4.s_addr;
+		iph->daddr = new_addr;
+		break;
+	case FLOW_OFFLOAD_DIR_REPLY:
+		addr = iph->saddr;
+		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4.s_addr;
+		iph->saddr = new_addr;
+		break;
+	default:
+		return -1;
+	}
+
+	return nf_flow_nat_l4proto(skb, iph, thoff, addr, new_addr);
+}
+
+static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
+			  enum flow_offload_tuple_dir dir)
+{
+	unsigned int thoff;
+	struct iphdr *iph;
+
+	if (skb_try_make_writable(skb, sizeof(*iph)))
+		return -1;
+
+	iph = ip_hdr(skb);
+	thoff = iph->ihl * 4;
+
+	if (flow->flags & FLOW_OFFLOAD_SNAT &&
+	    nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0)
+		return -1;
+	if (flow->flags & FLOW_OFFLOAD_DNAT &&
+	    nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0)
+		return -1;
+
+	return 0;
+}
+
+/* Similar to rt_nexthop(). */
+static inline void
+nf_flow_nexthop(const struct flow_offload *flow,
+		union nf_inet_addr *nexthop, enum flow_offload_tuple_dir dir)
+{
+	if (flow->tuplehash[dir].tuple.gateway) {
+		nexthop->ip = flow->tuplehash[dir].tuple.gateway;
+		return;
+	}
+
+	nexthop->ip = flow->tuplehash[!dir].tuple.src_v4.s_addr;
+}
+
+struct flow_ports {
+	__be16 src, dst;
+};
+
+static bool ip_has_options(unsigned int thoff)
+{
+	return thoff > sizeof(struct iphdr);
+}
+
+static int nf_flow_tuple_ip(struct sk_buff *skb,
+			    struct flow_offload_tuple *tuple)
+{
+	struct flow_ports *ports;
+	unsigned int thoff;
+	struct iphdr *iph;
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return -1;
+
+	iph = ip_hdr(skb);
+	thoff = iph->ihl * 4;
+
+	if (ip_is_fragment(iph) ||
+	    unlikely(ip_has_options(thoff)))
+		return -1;
+
+	if (iph->protocol != IPPROTO_TCP &&
+	    iph->protocol != IPPROTO_UDP)
+		return -1;
+
+	thoff = iph->ihl * 4;
+	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+		return -1;
+
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+
+	tuple->src_v4.s_addr	= iph->saddr;
+	tuple->dst_v4.s_addr	= iph->daddr;
+	tuple->src_port		= ports->src;
+	tuple->dst_port		= ports->dst;
+	tuple->l3proto		= AF_INET;
+	tuple->l4proto		= iph->protocol;
+
+	return 0;
+}
+
+#define NF_FLOW_TIMEOUT	(30 * HZ)
+
+static unsigned int
+nf_flow_offload_hook(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple tuple = {};
+	union nf_inet_addr nexthop;
+	struct flow_offload *flow;
+	struct net_device *outdev;
+	struct iphdr *iph;
+
+	if (nf_flow_tuple_ip(skb, &tuple) < 0)
+		return NF_ACCEPT;
+
+	tuplehash = flow_offload_lookup(flow_table, &tuple);
+	if (tuplehash == NULL)
+		return NF_ACCEPT;
+
+	outdev = dev_get_by_index_rcu(&init_net, tuplehash->tuple.oifidx);
+	if (!outdev)
+		return NF_ACCEPT;
+
+	flow = container_of(tuplehash, struct flow_offload,
+			    tuplehash[tuplehash->tuple.dir]);
+
+	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+
+	if (flow->flags & (FLOW_OFFLOAD_SNAT | FLOW_OFFLOAD_DNAT) &&
+	    nf_flow_nat_ip(flow, skb, tuplehash->tuple.dir) < 0)
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
+	ip_decrease_ttl(iph);
+
+	skb->dev = outdev;
+	nf_flow_nexthop(flow, &nexthop, tuplehash->tuple.dir);
+
+	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+
+	return NF_STOLEN;
+}
+
+static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
+{
+	const struct flow_offload_tuple *tuple = data;
+
+	return jhash(tuple, offsetof(struct flow_offload_tuple, l4proto), seed);
+}
+
+static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct flow_offload_tuple_rhash *tuplehash = data;
+
+	return jhash(&tuplehash->tuple, offsetof(struct flow_offload_tuple, l4proto), seed);
+}
+
+static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
+					const void *ptr)
+{
+	const struct flow_offload_tuple *tuple = arg->key;
+	const struct flow_offload_tuple_rhash *x = ptr;
+
+	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, l4proto)))
+		return 1;
+
+	return 0;
+}
+
+static const struct rhashtable_params flow_offload_rhash_params = {
+	.head_offset		= offsetof(struct flow_offload_tuple_rhash, node),
+	.hashfn			= flow_offload_hash,
+	.obj_hashfn		= flow_offload_hash_obj,
+	.obj_cmpfn		= flow_offload_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
+static int nf_flow_table_ipv4_init(struct nf_flowtable *flow_table)
+{
+	INIT_DEFERRABLE_WORK(&flow_table->gc_work, nf_flow_offload_work_gc);
+	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
+	return 0;
+}
+
+static void nf_flow_table_ipv4_destroy(struct nf_flowtable *flow_table)
+{
+	cancel_delayed_work_sync(&flow_table->gc_work);
+}
+
+static struct nf_flowtable_type flowtable_ipv4 = {
+	.family		= NFPROTO_IPV4,
+	.init		= nf_flow_table_ipv4_init,
+	.destroy	= nf_flow_table_ipv4_destroy,
+	.params		= &flow_offload_rhash_params,
+	.hook		= nf_flow_offload_hook,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nf_flow_ipv4_module_init(void)
+{
+	nft_register_flowtable_type(&flowtable_ipv4);
+
+	return 0;
+}
+
+static void __exit nf_flow_ipv4_module_exit(void)
+{
+	nft_unregister_flowtable_type(&flowtable_ipv4);
+}
+
+module_init(nf_flow_ipv4_module_init);
+module_exit(nf_flow_ipv4_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_FLOWTABLE(AF_INET);
-- 
2.11.0
