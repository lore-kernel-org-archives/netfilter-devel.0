From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC v4] netfilter: nf_flow_table: add hardware offload support
Date: Thu, 25 Jan 2018 01:09:41 +0100
Message-ID: <20180125000941.2763-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com, ronye@mellanox.com,
        simon.horman@netronome.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44492 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932250AbeAYAJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 19:09:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 522521BFA82
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 01:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A567B7FE5
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 01:09:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the infrastructure to offload flows to hardware, in case
the nic/switch comes with built-in flow tables capabilities.

If the hardware comes with no hardware flow tables or they have
limitations in terms of features, the existing infrastructure falls back
to the software flow table implementation.

The software flow table garbage collector skips entries that resides in
the hardware, so the hardware will be responsible for releasing this
flow table entry too via flow_offload_dead().

Hardware configuration, either to add or to delete entries, is done from
the hardware offload workqueue, to ensure this is done from user context
given that we may sleep when grabbing the mdio mutex.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: More work in progress
- Decouple nf_flow_table_hw from nft_flow_offload via rcu hooks
- Consolidate ->ndo invocations, now they happen from the hw worker.
- Fix bug in list handling, use list_replace_init()
- cleanup entries on nf_flow_table_hw module removal
- add NFT_FLOWTABLE_F_HW flag to flowtables to explicit signal that user wants
  to offload entries to hardware.

 include/linux/netdevice.h                |   9 ++
 include/net/netfilter/nf_flow_table.h    |  16 +++
 include/uapi/linux/netfilter/nf_tables.h |  11 ++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_flow_table.c            |  60 +++++++++++
 net/netfilter/nf_flow_table_hw.c         | 174 +++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c            |  12 ++-
 net/netfilter/nft_flow_offload.c         |   5 +
 9 files changed, 296 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nf_flow_table_hw.c

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ed0799a12bf2..be0c12acc3f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -859,6 +859,13 @@ struct dev_ifalias {
 	char ifalias[];
 };
 
+struct flow_offload;
+
+enum flow_offload_type {
+	FLOW_OFFLOAD_ADD	= 0,
+	FLOW_OFFLOAD_DEL,
+};
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1316,6 +1323,8 @@ struct net_device_ops {
 	int			(*ndo_bridge_dellink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags);
+	int			(*ndo_flow_offload)(enum flow_offload_type type,
+						    struct flow_offload *flow);
 	int			(*ndo_change_carrier)(struct net_device *dev,
 						      bool new_carrier);
 	int			(*ndo_get_phys_port_id)(struct net_device *dev,
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ed49cd169ecf..69067deb61b6 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -22,7 +22,9 @@ struct nf_flowtable_type {
 struct nf_flowtable {
 	struct rhashtable		rhashtable;
 	const struct nf_flowtable_type	*type;
+	u32				flags;
 	struct delayed_work		gc_work;
+	possible_net_t			ft_net;
 };
 
 enum flow_offload_tuple_dir {
@@ -65,6 +67,7 @@ struct flow_offload_tuple_rhash {
 #define FLOW_OFFLOAD_SNAT	0x1
 #define FLOW_OFFLOAD_DNAT	0x2
 #define FLOW_OFFLOAD_DYING	0x4
+#define FLOW_OFFLOAD_HW		0x8
 
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
@@ -119,6 +122,19 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
 
+void nf_flow_offload_hw_add(struct net *net, struct flow_offload *flow,
+			    struct nf_conn *ct);
+void nf_flow_offload_hw_del(struct net *net, struct flow_offload *flow);
+
+struct nf_flow_table_hw {
+	void (*add)(struct net *net, struct flow_offload *flow,
+		    struct nf_conn *ct);
+	void (*del)(struct net *net, struct flow_offload *flow);
+};
+
+int nf_flow_table_hw_register(const struct nf_flow_table_hw *offload);
+void nf_flow_table_hw_unregister(const struct nf_flow_table_hw *offload);
+
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 66dceee0ae30..1974829d6440 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1334,6 +1334,15 @@ enum nft_object_attributes {
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
 
 /**
+ * enum nft_flowtable_flags - nf_tables table flags
+ *
+ * @NFT_FLOWTABLE_F_HW: this flowtable resides in hardware
+ */
+enum nft_flowtable_flags {
+	NFT_FLOWTABLE_F_HW	= 0x1,
+};
+
+/**
  * enum nft_flowtable_attributes - nf_tables flow table netlink attributes
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
@@ -1341,6 +1350,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
+ * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1350,6 +1360,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
+	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9019fa98003d..2351f563214c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -681,6 +681,15 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_HW
+	tristate "Netfilter flow table hardware offload module"
+	depends on NF_FLOW_TABLE
+	help
+	  This option adds hardware offload support for the flow table core
+	  infrastructure.
+
+	  To compile it as a module, choose M here.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5d9b8b959e58..77604f1046c0 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
+obj-$(CONFIG_NF_FLOW_TABLE_HW)	+= nf_flow_table_hw.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index 29978866af10..78fb5c377a33 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -232,15 +232,22 @@ static inline bool nf_flow_is_dying(const struct flow_offload *flow)
 	return flow->flags & FLOW_OFFLOAD_DYING;
 }
 
+static inline bool nf_flow_in_hw(const struct flow_offload *flow)
+{
+	return flow->flags & FLOW_OFFLOAD_HW;
+}
+
 void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
+	struct net *net;
 	int err;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
+	net = read_pnet(&flow_table->ft_net);
 
 	err = rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
 	if (err)
@@ -261,10 +268,16 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
+		if (nf_flow_in_hw(flow) &&
+		    !nf_flow_is_dying(flow))
+			continue;
+
 		if (nf_flow_has_expired(flow) ||
 		    nf_flow_is_dying(flow)) {
 			flow_offload_del(flow_table, flow);
 			nf_flow_release_ct(flow);
+			if (nf_flow_in_hw(flow))
+				nf_flow_offload_hw_del(net, flow);
 		}
 	}
 out:
@@ -448,5 +461,52 @@ void nf_flow_table_cleanup(struct net *net, struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static const struct nf_flow_table_hw __rcu *nf_flow_table_hw_hook;
+
+/* Must be called from user context. */
+void nf_flow_offload_hw_add(struct net *net, struct flow_offload *flow,
+			    struct nf_conn *ct)
+{
+	const struct nf_flow_table_hw *offload;
+
+	rcu_read_lock();
+	offload = rcu_dereference(nf_flow_table_hw_hook);
+	if (offload)
+		offload->add(net, flow, ct);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_hw_add);
+
+/* Must be called from user context. */
+void nf_flow_offload_hw_del(struct net *net, struct flow_offload *flow)
+{
+	const struct nf_flow_table_hw *offload;
+
+	rcu_read_lock();
+	offload = rcu_dereference(nf_flow_table_hw_hook);
+	if (offload)
+		offload->del(net, flow);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_hw_del);
+
+int nf_flow_table_hw_register(const struct nf_flow_table_hw *offload)
+{
+	if (rcu_access_pointer(nf_flow_table_hw_hook))
+		return -EBUSY;
+
+	rcu_assign_pointer(nf_flow_table_hw_hook, offload);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_hw_register);
+
+void nf_flow_table_hw_unregister(const struct nf_flow_table_hw *offload)
+{
+	WARN_ON(rcu_access_pointer(nf_flow_table_hw_hook) != offload);
+	rcu_assign_pointer(nf_flow_table_hw_hook, NULL);
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_hw_unregister);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nf_flow_table_hw.c b/net/netfilter/nf_flow_table_hw.c
new file mode 100644
index 000000000000..5876800f4a36
--- /dev/null
+++ b/net/netfilter/nf_flow_table_hw.c
@@ -0,0 +1,174 @@
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
+static DEFINE_SPINLOCK(flow_offload_hw_pending_list_lock);
+static LIST_HEAD(flow_offload_hw_pending_list);
+
+static DEFINE_MUTEX(nf_flow_offload_hw_mutex);
+static struct work_struct nft_flow_offload_hw_work;
+
+struct flow_offload_hw {
+	struct list_head	list;
+	enum flow_offload_type	type;
+	struct flow_offload	*flow;
+	struct nf_conn		*ct;
+	possible_net_t		flow_hw_net;
+};
+
+static int do_flow_offload_hw(struct net *net, struct flow_offload *flow,
+			      int type)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = dev_get_by_index(net, ifindex);
+	if (WARN_ON(!indev))
+		return 0;
+
+	mutex_lock(&nf_flow_offload_hw_mutex);
+	ret = indev->netdev_ops->ndo_flow_offload(type, flow);
+	mutex_unlock(&nf_flow_offload_hw_mutex);
+
+	dev_put(indev);
+
+	return ret;
+}
+
+static void flow_offload_hw_work_add(struct flow_offload_hw *offload)
+{
+	struct net *net;
+	int ret;
+
+	if (nf_ct_is_dying(offload->ct))
+		return;
+
+	net = read_pnet(&offload->flow_hw_net);
+	ret = do_flow_offload_hw(net, offload->flow, FLOW_OFFLOAD_ADD);
+	if (ret >= 0)
+		offload->flow->flags |= FLOW_OFFLOAD_HW;
+}
+
+static void flow_offload_hw_work_del(struct flow_offload_hw *offload)
+{
+	struct net *net = read_pnet(&offload->flow_hw_net);
+
+	do_flow_offload_hw(net, offload->flow, FLOW_OFFLOAD_DEL);
+}
+
+static void flow_offload_hw_work(struct work_struct *work)
+{
+	struct flow_offload_hw *offload, *next;
+	LIST_HEAD(hw_offload_pending);
+
+	spin_lock_bh(&flow_offload_hw_pending_list_lock);
+	list_replace_init(&flow_offload_hw_pending_list, &hw_offload_pending);
+	spin_unlock_bh(&flow_offload_hw_pending_list_lock);
+
+	list_for_each_entry_safe(offload, next, &hw_offload_pending, list) {
+		switch (offload->type) {
+		case FLOW_OFFLOAD_ADD:
+			flow_offload_hw_work_add(offload);
+			break;
+		case FLOW_OFFLOAD_DEL:
+			flow_offload_hw_work_del(offload);
+			break;
+		}
+		if (offload->ct)
+			nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+}
+
+static void flow_offload_queue_work(struct flow_offload_hw *offload)
+{
+	spin_lock_bh(&flow_offload_hw_pending_list_lock);
+	list_add_tail(&offload->list, &flow_offload_hw_pending_list);
+	spin_unlock_bh(&flow_offload_hw_pending_list_lock);
+
+	schedule_work(&nft_flow_offload_hw_work);
+}
+
+static void flow_offload_hw_add(struct net *net, struct flow_offload *flow,
+				struct nf_conn *ct)
+{
+	struct flow_offload_hw *offload;
+
+	offload = kmalloc(sizeof(struct flow_offload_hw), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	nf_conntrack_get(&ct->ct_general);
+	offload->type = FLOW_OFFLOAD_ADD;
+	offload->ct = ct;
+	offload->flow = flow;
+	write_pnet(&offload->flow_hw_net, net);
+
+	flow_offload_queue_work(offload);
+}
+
+static void flow_offload_hw_del(struct net *net, struct flow_offload *flow)
+{
+	struct flow_offload_hw *offload;
+
+	offload = kmalloc(sizeof(struct flow_offload_hw), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	offload->type = FLOW_OFFLOAD_DEL;
+	offload->ct = NULL;
+	offload->flow = flow;
+	write_pnet(&offload->flow_hw_net, net);
+
+	flow_offload_queue_work(offload);
+}
+
+static const struct nf_flow_table_hw flow_offload_hw = {
+	.add	= flow_offload_hw_add,
+	.del	= flow_offload_hw_del,
+};
+
+static int __init nf_flow_table_hw_module_init(void)
+{
+	INIT_WORK(&nft_flow_offload_hw_work, flow_offload_hw_work);
+	nf_flow_table_hw_register(&flow_offload_hw);
+
+	return 0;
+}
+
+static void __exit nf_flow_table_hw_module_exit(void)
+{
+	struct flow_offload_hw *offload, *next;
+	LIST_HEAD(hw_offload_pending);
+	struct net *net;
+
+	nf_flow_table_hw_unregister(&flow_offload_hw);
+	cancel_work_sync(&nft_flow_offload_hw_work);
+
+	list_for_each_entry_safe(offload, next, &hw_offload_pending, list) {
+		if (offload->ct)
+			nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+
+	rtnl_lock();
+	for_each_net(net)
+		nf_flow_table_cleanup(net, NULL);
+	rtnl_unlock();
+}
+
+module_init(nf_flow_table_hw_module_init);
+module_exit(nf_flow_table_hw_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0791813a1e7d..a31c59ce3049 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5089,10 +5089,19 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	}
 
 	flowtable->data.type = type;
+	write_pnet(&flowtable->data.ft_net, net);
+
 	err = rhashtable_init(&flowtable->data.rhashtable, type->params);
 	if (err < 0)
 		goto err3;
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flowtable->data.flags =
+			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flowtable->data.flags & ~NFT_FLOWTABLE_F_HW)
+			return -EINVAL;
+	}
+
 	err = nf_tables_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
 					     flowtable);
 	if (err < 0)
@@ -5192,7 +5201,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
-			 NFTA_FLOWTABLE_PAD))
+			 NFTA_FLOWTABLE_PAD) ||
+	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ea24a17d4df9..7647fd83a68d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -66,6 +66,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	const struct net_device *indev = nft_in(pkt);
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -110,6 +111,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
+	if (flowtable->flags & NFT_FLOWTABLE_F_HW &&
+	    indev->netdev_ops->ndo_flow_offload)
+		nf_flow_offload_hw_add(nft_net(pkt), flow, ct);
+
 	return;
 
 err_flow_add:
-- 
2.11.0

