From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC,v2 3/6] netfilter: add generic flow table infrastructure
Date: Thu,  7 Dec 2017 13:44:58 +0100
Message-ID: <20171207124501.24325-4-pablo@netfilter.org>
References: <20171207124501.24325-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171207124501.24325-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch defines the API to interact with flow tables, this allows to
add, delete and lookup for entries in the flow table. This also adds the
generic garbage code that removes entries that have expired, ie. no
traffic has been seen for a while.

Users of the flow table infrastructure can delete entries via
flow_offload_dead(), which sets the dying bit, this signals the garbage
collector to release an entry from user context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  71 +++++++++
 net/netfilter/Kconfig                 |   7 +
 net/netfilter/Makefile                |   3 +
 net/netfilter/nf_flow_table.c         | 269 ++++++++++++++++++++++++++++++++++
 4 files changed, 350 insertions(+)
 create mode 100644 net/netfilter/nf_flow_table.c

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 429833dba2d9..1a2598b4a58f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -1,7 +1,11 @@
 #ifndef _NF_FLOW_TABLE_H
 #define _NF_FLOW_TABLE_H
 
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/netdevice.h>
 #include <linux/rhashtable.h>
+#include <linux/rcupdate.h>
 
 struct nf_flowtable;
 
@@ -21,4 +25,71 @@ struct nf_flowtable {
 	struct delayed_work		gc_work;
 };
 
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
+#define	FLOW_OFFLOAD_DYING	0x4
+
+struct flow_offload {
+	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
+	u32					flags;
+	union {
+		/* Your private driver data here. */
+		u32		timeout;
+	};
+};
+
+struct flow_offload *flow_offload_alloc(struct nf_conn *ct, int *ifindex,
+					union nf_inet_addr *gw);
+void flow_offload_free(const struct flow_offload *flow);
+
+int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
+void flow_offload_del(struct nf_flowtable *flow_table, struct flow_offload *flow);
+struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
+						     struct flow_offload_tuple *tuple);
+int nf_flow_table_iterate(struct nf_flowtable *flow_table,
+			  void (*iter)(struct flow_offload *flow, void *data),
+			  void *data);
+void nf_flow_offload_work_gc(struct work_struct *work);
+
+void flow_offload_dead(struct flow_offload *flow);
+
 #endif /* _FLOW_OFFLOAD_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4a13cc8a2e7..af0f58322515 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -649,6 +649,13 @@ endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
 
+config NF_FLOW_TABLE
+	tristate "Netfilter flow table module"
+	help
+	  This option adds the flow table core infrastructure.
+
+	  To compile it as a module, choose M here.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d3891c93edd6..1f7d92bd571a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -106,6 +106,9 @@ obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
 obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
+# flow table infrastructure
+obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
+
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
new file mode 100644
index 000000000000..ff27dad268c3
--- /dev/null
+++ b/net/netfilter/nf_flow_table.c
@@ -0,0 +1,269 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <linux/netdevice.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+struct flow_offload_entry {
+	struct flow_offload	flow;
+	struct nf_conn		*ct;
+	struct rcu_head		rcu_head;
+};
+
+struct flow_offload *
+flow_offload_alloc(struct nf_conn *ct, int *iifindex, union nf_inet_addr *gw)
+{
+	struct flow_offload_entry *entry;
+	struct flow_offload *flow;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (!entry)
+		return NULL;
+
+	if (unlikely(nf_ct_is_dying(ct) ||
+	    !atomic_inc_not_zero(&ct->ct_general.use))) {
+		kfree(entry);
+		return NULL;
+	}
+	entry->ct = ct;
+
+	flow = &entry->flow;
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
+			gw[FLOW_OFFLOAD_DIR_ORIGINAL].ip;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.gateway =
+			gw[FLOW_OFFLOAD_DIR_REPLY].ip;
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
+			gw[FLOW_OFFLOAD_DIR_ORIGINAL].in6;
+		flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.gateway6 =
+			gw[FLOW_OFFLOAD_DIR_REPLY].in6;
+		break;
+        }
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port =
+		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port =
+		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port =
+		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port =
+		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port;
+
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dir =
+						FLOW_OFFLOAD_DIR_ORIGINAL;
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dir =
+						FLOW_OFFLOAD_DIR_REPLY;
+
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
+		iifindex[FLOW_OFFLOAD_DIR_ORIGINAL];
+	flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.oifidx =
+		iifindex[FLOW_OFFLOAD_DIR_REPLY];
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
+		iifindex[FLOW_OFFLOAD_DIR_REPLY];
+	flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.oifidx =
+		iifindex[FLOW_OFFLOAD_DIR_ORIGINAL];
+
+	if (ct->status & IPS_SRC_NAT)
+		flow->flags |= FLOW_OFFLOAD_SNAT;
+	else if (ct->status & IPS_DST_NAT)
+		flow->flags |= FLOW_OFFLOAD_DNAT;
+
+	return flow;
+}
+EXPORT_SYMBOL_GPL(flow_offload_alloc);
+
+void flow_offload_free(const struct flow_offload *flow)
+{
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
+	kfree(e);
+}
+EXPORT_SYMBOL_GPL(flow_offload_free);
+
+void flow_offload_dead(struct flow_offload *flow)
+{
+	flow->flags |= FLOW_OFFLOAD_DYING;
+}
+EXPORT_SYMBOL_GPL(flow_offload_dead);
+
+int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
+{
+	flow->timeout = (u32)jiffies;
+
+	rhashtable_insert_fast(&flow_table->rhashtable,
+			       &flow->tuplehash[0].node,
+			       *flow_table->type->params);
+	rhashtable_insert_fast(&flow_table->rhashtable,
+			       &flow->tuplehash[1].node,
+			       *flow_table->type->params);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(flow_offload_add);
+
+void flow_offload_del(struct nf_flowtable *flow_table,
+		      struct flow_offload *flow)
+{
+	struct flow_offload_entry *e;
+
+	rhashtable_remove_fast(&flow_table->rhashtable,
+			       &flow->tuplehash[0].node,
+			       *flow_table->type->params);
+	rhashtable_remove_fast(&flow_table->rhashtable,
+			       &flow->tuplehash[1].node,
+			       *flow_table->type->params);
+
+	e = container_of(flow, struct flow_offload_entry, flow);
+	kfree_rcu(e, rcu_head);
+}
+EXPORT_SYMBOL_GPL(flow_offload_del);
+
+struct flow_offload_tuple_rhash *
+flow_offload_lookup(struct nf_flowtable *flow_table,
+		    struct flow_offload_tuple *tuple)
+{
+	return rhashtable_lookup_fast(&flow_table->rhashtable, tuple,
+				      *flow_table->type->params);
+}
+EXPORT_SYMBOL_GPL(flow_offload_lookup);
+
+static void nf_flow_release_ct(const struct flow_offload *flow)
+{
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
+	nf_ct_delete(e->ct, 0, 0);
+	nf_ct_put(e->ct);
+}
+
+int nf_flow_table_iterate(struct nf_flowtable *flow_table,
+			  void (*iter)(struct flow_offload *flow, void *data),
+			  void *data)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct rhashtable_iter hti;
+	struct flow_offload *flow;
+	int err;
+
+	rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
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
+		iter(flow, data);
+	}
+out:
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
+
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+}
+
+static inline bool nf_flow_is_dying(const struct flow_offload *flow)
+{
+	return flow->flags & FLOW_OFFLOAD_DYING;
+}
+
+void nf_flow_offload_work_gc(struct work_struct *work)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table;
+	struct rhashtable_iter hti;
+	struct flow_offload *flow;
+	int err, counter = 0;
+
+	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
+
+	rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
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
+		if (nf_flow_has_expired(flow) ||
+		    nf_flow_is_dying(flow)) {
+			flow_offload_del(flow_table, flow);
+			nf_flow_release_ct(flow);
+		}
+		counter++;
+	}
+
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+out:
+	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_work_gc);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-- 
2.11.0
