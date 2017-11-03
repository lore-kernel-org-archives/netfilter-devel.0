From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,WIP 2/5] netfilter: add software flow offload infrastructure
Date: Fri,  3 Nov 2017 16:26:33 +0100
Message-ID: <20171103152636.9967-3-pablo@netfilter.org>
References: <20171103152636.9967-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755819AbdKCP0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 11:26:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C268DC0B2B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD1B9B7FE3
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:46 +0100 (CET)
In-Reply-To: <20171103152636.9967-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the generic software flow offload infrastructure. This
allows users to configure fast path for established flows that will not
follow the classic forwarding path.

This adds a new hook at netfilter ingress for each existing interface.
For each packet that hits the hook, we look up for an existing flow in
the table, if there is a hit, the packet is forwarded by using the
gateway and interfaces that are cached in the flow table entry.

This comes with a kernel thread to release flow table entries if no
packets are seen after a little while, so the flow table entry is
released.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h      |  67 +++++++
 net/netfilter/Kconfig           |   7 +
 net/netfilter/Makefile          |   3 +
 net/netfilter/nf_flow_offload.c | 386 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 463 insertions(+)
 create mode 100644 include/net/flow_offload.h
 create mode 100644 net/netfilter/nf_flow_offload.c

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
new file mode 100644
index 000000000000..30bfca7ed3f1
--- /dev/null
+++ b/include/net/flow_offload.h
@@ -0,0 +1,67 @@
+#ifndef _FLOW_OFFLOAD_H
+#define _FLOW_OFFLOAD_H
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/netdevice.h>
+#include <linux/rhashtable.h>
+#include <linux/rcupdate.h>
+
+enum flow_offload_tuple_dir {
+	FLOW_OFFLOAD_DIR_ORIGINAL,
+	FLOW_OFFLOAD_DIR_REPLY,
+	__FLOW_OFFLOAD_DIR_MAX		= FLOW_OFFLOAD_DIR_REPLY,
+};
+#define FLOW_OFFLOAD_DIR_MAX	(__FLOW_OFFLOAD_DIR_MAX + 1)
+
+struct flow_offload_tuple {
+	union {
+		struct in_addr		src_v4;
+		struct in6_addr		src_v6;
+	};
+	union {
+		struct in_addr		dst_v4;
+		struct in6_addr		dst_v6;
+	};
+	struct {
+		__be16			src_port;
+		__be16			dst_port;
+	};
+
+	u8				l3proto;
+	u8				l4proto;
+	u8				dir;
+
+	int				iifidx;
+	int				oifidx;
+
+	union {
+		__be32			gateway;
+		struct in6_addr		gateway6;
+	};
+};
+
+struct flow_offload_tuple_rhash {
+	struct rhash_head		node;
+	struct flow_offload_tuple	tuple;
+};
+
+#define	FLOW_OFFLOAD_SNAT	0x1
+#define	FLOW_OFFLOAD_DNAT	0x2
+#define	FLOW_OFFLOAD_HW		0x4
+
+struct flow_offload {
+	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
+	u32					flags;
+	union {
+		/* Your private driver data here. */
+		u32		timeout;
+	};
+	struct rcu_head				rcu_head;
+};
+
+int flow_offload_add(struct flow_offload *flow);
+void flow_offload_del(struct flow_offload *flow);
+struct flow_offload_tuple_rhash *flow_offload_lookup(struct flow_offload_tuple *tuple);
+
+#endif /* _FLOW_OFFLOAD_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4a13cc8a2e7..f022ca91f49d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -436,6 +436,13 @@ config NETFILTER_SYNPROXY
 
 endif # NF_CONNTRACK
 
+config NF_FLOW_OFFLOAD
+	tristate "Netfilter Generic Flow Offload (GFO) module"
+	help
+	  This option adds the flow table core infrastructure.
+
+	  To compile it as a module, choose M here.
+
 config NF_TABLES
 	select NETFILTER_NETLINK
 	tristate "Netfilter nf_tables support"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d3891c93edd6..518f54113e06 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -69,6 +69,9 @@ obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
 # generic packet duplication from netdev family
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
+# generic flow table
+obj-$(CONFIG_NF_FLOW_OFFLOAD)+= nf_flow_offload.o
+
 # nf_tables
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_trace.o \
 		  nft_immediate.o nft_cmp.o nft_range.o nft_bitwise.o \
diff --git a/net/netfilter/nf_flow_offload.c b/net/netfilter/nf_flow_offload.c
new file mode 100644
index 000000000000..c967b29d11a6
--- /dev/null
+++ b/net/netfilter/nf_flow_offload.c
@@ -0,0 +1,386 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <linux/ip.h>
+#include <linux/netdevice.h>
+#include <net/ip.h>
+#include <net/neighbour.h>
+#include <net/flow_offload.h>
+/* For layer 4 checksum field offset. */
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/icmpv6.h>
+
+static struct rhashtable flow_table;
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
+	const struct flow_offload_tuple_rhash *x = ptr;
+	const struct flow_offload_tuple *tuple = arg->key;
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
+#define NF_FLOW_LIFETIME	15
+
+int flow_offload_add(struct flow_offload *flow)
+{
+	flow->timeout = (u32)jiffies;
+
+	rhashtable_insert_fast(&flow_table, &flow->tuplehash[0].node,
+			       flow_offload_rhash_params);
+	rhashtable_insert_fast(&flow_table, &flow->tuplehash[1].node,
+			       flow_offload_rhash_params);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(flow_offload_add);
+
+void flow_offload_del(struct flow_offload *flow)
+{
+	rhashtable_remove_fast(&flow_table, &flow->tuplehash[0].node,
+			       flow_offload_rhash_params);
+	rhashtable_remove_fast(&flow_table, &flow->tuplehash[1].node,
+			       flow_offload_rhash_params);
+	kfree_rcu(flow, rcu_head);
+}
+EXPORT_SYMBOL_GPL(flow_offload_del);
+
+struct flow_offload_tuple_rhash *
+flow_offload_lookup(struct flow_offload_tuple *tuple)
+{
+	return rhashtable_lookup_fast(&flow_table, tuple,
+				      flow_offload_rhash_params);
+}
+EXPORT_SYMBOL_GPL(flow_offload_lookup);
+
+static void nf_flow_offload_work_gc(struct work_struct *work);
+
+static DECLARE_DEFERRABLE_WORK(nf_flow_offload_gc,
+			       nf_flow_offload_work_gc);
+
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+}
+
+static void nf_flow_offload_work_gc(struct work_struct *work)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct rhashtable_iter hti;
+	struct flow_offload *flow;
+	int err, counter = 0;
+
+	rhashtable_walk_init(&flow_table, &hti, GFP_KERNEL);
+	err = rhashtable_walk_start(&hti);
+	if (err && err != -EAGAIN)
+		goto out;
+
+	while ((tuplehash = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(tuplehash)) {
+			err = PTR_ERR(tuplehash);
+			if (err != -EAGAIN)
+				goto out;
+
+			continue;
+		}
+		if (tuplehash->tuple.dir)
+			continue;
+
+		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
+
+		if (nf_flow_has_expired(flow))
+			flow_offload_del(flow);
+
+		counter++;
+	}
+
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+out:
+	queue_delayed_work(system_power_efficient_wq, &nf_flow_offload_gc,
+			   msecs_to_jiffies(1000));
+}
+
+static int nf_flow_snat_tcp(struct iphdr *iph,
+			    const struct flow_offload *flow,
+			    struct sk_buff *skb,
+			    unsigned int thoff,
+			    __be32 addr, __be32 new_addr)
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
+static int nf_flow_snat_udp(struct iphdr *iph,
+			    const struct flow_offload *flow,
+			    struct sk_buff *skb,
+			    unsigned int thoff,
+			    __be32 addr, __be32 new_addr)
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
+static int nf_flow_snat(struct iphdr *iph,
+			const struct flow_offload *flow,
+			enum flow_offload_tuple_dir dir, struct sk_buff *skb)
+{
+	__be32 new_addr, addr;
+	unsigned int thoff;
+
+	if (skb_try_make_writable(skb, sizeof(*iph)))
+		return NF_DROP;
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
+	csum_replace4(&iph->check, addr, new_addr);
+
+	ip_decrease_ttl(iph);
+
+	thoff = iph->ihl * 4;
+
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		if (nf_flow_snat_tcp(iph, flow, skb, thoff, addr, new_addr) < 0)
+			return NF_DROP;
+		break;
+	case IPPROTO_UDP:
+		if (nf_flow_snat_udp(iph, flow, skb, thoff, addr, new_addr) < 0)
+			return NF_DROP;
+		break;
+	}
+
+	return 0;
+}
+
+/* Similar to rt_nexthop(). */
+static inline __be32 nf_flow_nexthop(__be32 nexthop, __be32 daddr)
+{
+	if (nexthop)
+		return nexthop;
+
+	return daddr;
+}
+
+struct flow_ports {
+	__be16 src, dst;
+};
+
+static int nf_flow_tuple_ip(struct iphdr *iph, struct sk_buff *skb,
+			    struct flow_offload_tuple *tuple)
+{
+	struct flow_ports *ports;
+	unsigned int thoff;
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
+	struct flow_offload_tuple tuple = {};
+	struct flow_offload *flow;
+	struct net_device *outdev;
+	struct iphdr *iph;
+	__be32 nexthop;
+	int err;
+
+	switch (skb->protocol) {
+	case cpu_to_be16(ETH_P_IP):
+		if (!pskb_may_pull(skb, sizeof(*iph)))
+			return NF_ACCEPT;
+
+		iph = ip_hdr(skb);
+		if (ip_is_fragment(iph))
+			return NF_ACCEPT;
+
+		err = nf_flow_tuple_ip(iph, skb, &tuple);
+		if (err < 0)
+			return NF_ACCEPT;
+		break;
+	default:
+		return NF_ACCEPT;
+	}
+
+	tuplehash = flow_offload_lookup(&tuple);
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
+	if (flow->flags & FLOW_OFFLOAD_SNAT &&
+	    nf_flow_snat(iph, flow, tuplehash->tuple.dir, skb) < 0)
+		return NF_DROP;
+
+	skb->dev = outdev;
+	nexthop = nf_flow_nexthop(tuplehash->tuple.gateway, iph->daddr);
+
+	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+
+	return NF_STOLEN;
+}
+
+static LIST_HEAD(nf_flow_hook_list);
+
+struct nf_flow_hook_entry {
+	struct list_head	head;
+	struct nf_hook_ops	ops;
+};
+
+static int __init nf_flow_offload_module_init(void)
+{
+	struct rhashtable_params params = flow_offload_rhash_params;
+	struct nf_hook_ops flow_offload_hook = {
+		.hook		= nf_flow_offload_hook,
+		.pf		= NFPROTO_NETDEV,
+		.hooknum	= NF_NETDEV_INGRESS,
+		.priority	= -100,
+	};
+	struct nf_flow_hook_entry *entry;
+	struct net_device *dev;
+	int err;
+
+	params.key_len = offsetof(struct flow_offload_tuple, dir);
+	err = rhashtable_init(&flow_table, &params);
+	if (err < 0)
+		return err;
+
+	rtnl_lock();
+	for_each_netdev(&init_net, dev) {
+		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry) {
+			rtnl_unlock();
+			return -ENOMEM;
+		}
+		entry->ops	= flow_offload_hook;
+		entry->ops.dev	= dev;
+		list_add_tail(&entry->head, &nf_flow_hook_list);
+
+		err = nf_register_net_hook(&init_net, &entry->ops);
+		if (err < 0)
+			return err;
+
+		pr_info("register flow table for device %s\n", dev->name);
+	}
+	rtnl_unlock();
+
+	queue_delayed_work(system_power_efficient_wq, &nf_flow_offload_gc,
+			   msecs_to_jiffies(1000));
+	return err;
+}
+
+static void flow_offload_destroy(void *ptr, void *arg)
+{
+	kfree(ptr);
+}
+
+static void __exit nf_flow_offload_module_exit(void)
+{
+	struct nf_flow_hook_entry *entry, *next;
+
+	cancel_delayed_work_sync(&nf_flow_offload_gc);
+	list_for_each_entry_safe(entry, next, &nf_flow_hook_list, head) {
+		pr_info("unregister flow table for device %s\n",
+			entry->ops.dev->name);
+		nf_unregister_net_hook(&init_net, &entry->ops);
+		list_del(&entry->head);
+		kfree(entry);
+	}
+	rhashtable_free_and_destroy(&flow_table, flow_offload_destroy, NULL);
+}
+
+module_init(nf_flow_offload_module_init);
+module_exit(nf_flow_offload_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-- 
2.11.0


