From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 3/4] netfilter: nfnetlink: add support for netlink descriptions
Date: Wed,  7 Feb 2018 02:37:12 +0100
Message-ID: <20180207013713.2432-4-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207013713.2432-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

NETLINK_NETFILTER is shared by several netfilter subsystems, add new
infrastructure to allow subsystems to register their own descriptions.
Hence, nfnetlink routes description requests to the corresponding
subsystem backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h      |   9 +++
 include/net/nldesc.h                     |   3 +
 include/uapi/linux/netfilter/nfnetlink.h |   7 ++
 net/netfilter/nfnetlink.c                | 108 +++++++++++++++++++++++++++++++
 4 files changed, 127 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 495ba4dd9da5..87b3d9860444 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -37,6 +37,15 @@ struct nfnetlink_subsystem {
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
 int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 
+struct nfnl_desc_subsys {
+	u16				id;
+	const struct nl_desc_cmds	*cmds;
+	const struct nl_desc_objs	*objs;
+};
+
+int nfnl_desc_register_subsys(const struct nfnl_desc_subsys *subsys);
+void nfnl_desc_unregister_subsys(const struct nfnl_desc_subsys *subsys);
+
 int nfnetlink_has_listeners(struct net *net, unsigned int group);
 int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags);
diff --git a/include/net/nldesc.h b/include/net/nldesc.h
index 19306a648f10..0d232846005a 100644
--- a/include/net/nldesc.h
+++ b/include/net/nldesc.h
@@ -19,6 +19,9 @@ struct nl_desc_objs {
 
 struct nl_desc_req {
 	u32				bus;
+	union {
+		u32			nf_subsys_id;
+	};
 };
 
 struct net;
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 5bc960f220b3..7dacf264e0b5 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -62,6 +62,13 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_NFT_COMPAT		11
 #define NFNL_SUBSYS_COUNT		12
 
+enum nfnl_desc_attr {
+	NFNL_DESC_REQ_UNSPEC,
+	NFNL_DESC_REQ_SUBSYS,
+	__NFNL_DESC_REQ_MAX
+};
+#define NFNL_DESC_REQ_MAX	(__NFNL_DESC_REQ_MAX - 1)
+
 /* Reserved control nfnetlink messages */
 #define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
 #define NFNL_MSG_BATCH_END		NLMSG_MIN_TYPE+1
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 03ead8a9e90c..df5792534935 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 
 #include <net/netlink.h>
+#include <net/nldesc.h>
 #include <linux/netfilter/nfnetlink.h>
 
 MODULE_LICENSE("GPL");
@@ -40,6 +41,7 @@ MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
+	const struct nfnl_desc_subsys __rcu	*desc;
 } table[NFNL_SUBSYS_COUNT];
 
 static const int nfnl_group2type[NFNLGRP_MAX+1] = {
@@ -513,6 +515,107 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 		netlink_rcv_skb(skb, nfnetlink_rcv_msg);
 }
 
+int nfnl_desc_register_subsys(const struct nfnl_desc_subsys *subsys)
+{
+	if (subsys->id >= NFNL_SUBSYS_COUNT)
+		return -ENOENT;
+
+	nfnl_lock(subsys->id);
+	rcu_assign_pointer(table[subsys->id].desc, subsys);
+	nfnl_unlock(subsys->id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nfnl_desc_register_subsys);
+
+void nfnl_desc_unregister_subsys(const struct nfnl_desc_subsys *subsys)
+{
+	nfnl_lock(subsys->id);
+	rcu_assign_pointer(table[subsys->id].desc, NULL);
+	nfnl_unlock(subsys->id);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(nfnl_desc_unregister_subsys);
+
+static const struct nfnl_desc_subsys *nfnl_desc_get(struct sk_buff *skb,
+						    struct nlmsghdr *nlh,
+						    struct nl_desc_req *req)
+{
+	const struct nfnl_desc_subsys *desc;
+
+	if (req->nf_subsys_id >= NFNL_SUBSYS_COUNT)
+		return ERR_PTR(-ENOENT);
+
+	desc = rcu_dereference(table[req->nf_subsys_id].desc);
+	if (!desc) {
+		rcu_read_unlock();
+		request_module("nfnetlink-subsys-%d", req->nf_subsys_id);
+		rcu_read_lock();
+		desc = rcu_dereference(table[req->nf_subsys_id].desc);
+		if (desc)
+			return ERR_PTR(-EAGAIN);
+	}
+	return desc;
+}
+
+static const struct nl_desc_cmds *nfnl_desc_getcmds(struct sk_buff *skb,
+						    struct nlmsghdr *nlh,
+						    struct nl_desc_req *req)
+{
+	const struct nfnl_desc_subsys *desc;
+
+	desc = nfnl_desc_get(skb, nlh, req);
+	if (IS_ERR(desc))
+		return (struct nl_desc_cmds *)desc;
+
+	return desc->cmds;
+}
+
+static const struct nl_desc_objs *nfnl_desc_getobjs(struct sk_buff *skb,
+						    struct nlmsghdr *nlh,
+						    struct nl_desc_req *req)
+{
+	const struct nfnl_desc_subsys *desc;
+
+	desc = nfnl_desc_get(skb, nlh, req);
+	if (IS_ERR(desc))
+		return (struct nl_desc_objs *)desc;
+
+	return desc->objs;
+}
+
+static const struct nla_policy nfnl_desc_req_policy[NFNL_DESC_REQ_MAX + 1] = {
+	[NFNL_DESC_REQ_SUBSYS]	= { .type = NLA_U32 },
+};
+
+static int nfnl_desc_parse(struct net *net, struct sk_buff *skb,
+			   struct nlmsghdr *nlh, const struct nlattr *attr,
+			   struct nl_desc_req *req)
+{
+	struct nlattr *tb[NFNL_DESC_REQ_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, NFNL_DESC_REQ_MAX, attr,
+			       nfnl_desc_req_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFNL_DESC_REQ_SUBSYS])
+		return -EINVAL;
+
+	req->nf_subsys_id = nla_get_u32(tb[NFNL_DESC_REQ_SUBSYS]);
+
+	return 0;
+}
+
+static struct nl_desc_subsys nfnl_subsys = {
+	.bus		= NETLINK_NETFILTER,
+	.getcmds	= nfnl_desc_getcmds,
+	.getobjs	= nfnl_desc_getobjs,
+	.parse		= nfnl_desc_parse,
+};
+
 #ifdef CONFIG_MODULES
 static int nfnetlink_bind(struct net *net, int group)
 {
@@ -549,6 +652,8 @@ static int __net_init nfnetlink_net_init(struct net *net)
 		return -ENOMEM;
 	net->nfnl_stash = nfnl;
 	rcu_assign_pointer(net->nfnl, nfnl);
+	nl_desc_register_subsys(&nfnl_subsys);
+
 	return 0;
 }
 
@@ -556,6 +661,7 @@ static void __net_exit nfnetlink_net_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
+	nl_desc_unregister_subsys(&nfnl_subsys);
 	list_for_each_entry(net, net_exit_list, exit_list)
 		RCU_INIT_POINTER(net->nfnl, NULL);
 	synchronize_net();
@@ -587,3 +693,5 @@ static void __exit nfnetlink_exit(void)
 }
 module_init(nfnetlink_init);
 module_exit(nfnetlink_exit);
+
+MODULE_ALIAS_NLDESC(NETLINK_NETFILTER);
-- 
2.11.0
