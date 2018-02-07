From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 2/4] netlink: add generic object description infrastructure
Date: Wed,  7 Feb 2018 02:37:11 +0100
Message-ID: <20180207013713.2432-3-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932208AbeBGBhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 20:37:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E08F7392E09
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 02:37:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9B3DDA3AD
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 02:37:21 +0100 (CET)
In-Reply-To: <20180207013713.2432-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows netlink busses to provide object descriptions to
userspace, in terms of supported attributes and its corresponding
datatypes.

Userspace sends a requests that looks like:

	netlink header
	NLA_DESC_REQ_BUS
	NLA_DESC_REQ_DATA

Where NLA_DESC_REQ_BUS is the netlink bus/protocol number, eg.
NETLINK_NETFILTER, and NLA_DESC_REQ_DATA is an attribute layout is
specific to the bus that you are inspecting, this is useful for both
nfnetlink and genetlink since they need to what subsystem in the bus
specifically you're targeting to.

Then, the netlink description subsystem response via netlink dump looks
like this:

	netlink header
	NLA_DESC_NUM_OBJS
	NLA_DESC_OBJS (nest)
		NLA_DESC_LIST_ITEM (nest)
			NLA_DESC_OBJ_ID
			NLA_DESC_OBJ_ATTRS_MAX
			NLA_DESC_OBJ_ATTRS (nest)
				NLA_DESC_LIST_ITEM (nest)
					NLA_DESC_ATTR_NUM
					NLA_DESC_ATTR_TYPE
					NLA_DESC_ATTR_LEN
					NLA_DESC_ATTR_MAXVAL
					NLA_DESC_ATTR_NEST_ID
		NLA_DESC_LIST_ITEM (nest)
			...

Each object definition is composed of an unique ID, the number of
attributes and the list of attribute definitions.

The NETLINK_DESC bus provides a generic interface to retrieve the list
of existing objects and its attributes via netlink dump. This new
description family autoloads module dependencies based on what userspace
requests.

Each bus needs to register a struct nl_desc_subsys definition, that
provides the lookup and parse callbacks. These route the description
requests to the corresponding backend subsystem for genetlink and
nfnetlink. The lookup callback returns struct nl_desc_objs that provides
the array of object descriptions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h  |   1 +
 include/net/nldesc.h         | 160 ++++++++++++++
 include/uapi/linux/netlink.h |  67 ++++++
 net/netlink/Makefile         |   2 +-
 net/netlink/desc.c           | 499 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 728 insertions(+), 1 deletion(-)
 create mode 100644 include/net/nldesc.h
 create mode 100644 net/netlink/desc.c

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index f8a84a2c2341..0921b1d7acfe 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -78,6 +78,7 @@ struct net {
 
 	struct sock 		*rtnl;			/* rtnetlink socket */
 	struct sock		*genl_sock;
+	struct sock		*nl_desc_sock;
 
 	struct list_head 	dev_base_head;
 	struct hlist_head 	*dev_name_head;
diff --git a/include/net/nldesc.h b/include/net/nldesc.h
new file mode 100644
index 000000000000..19306a648f10
--- /dev/null
+++ b/include/net/nldesc.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_NLDESC_H
+#define __NET_NLDESC_H
+
+#include <linux/types.h>
+
+struct nl_desc_cmd;
+struct nl_desc_obj;
+
+struct nl_desc_cmds {
+	int				max;
+	const struct nl_desc_cmd	*table;
+};
+
+struct nl_desc_objs {
+	int				max;
+	const struct nl_desc_obj	**table;
+};
+
+struct nl_desc_req {
+	u32				bus;
+};
+
+struct net;
+struct sk_buff;
+struct nlmsghdr;
+struct nlattr;
+
+struct nl_desc_subsys {
+	struct list_head		list;
+	u32				bus;
+	const struct nl_desc_cmds *	(*getcmds)(struct sk_buff *skb,
+						   struct nlmsghdr *nlh,
+						   struct nl_desc_req *req);
+	const struct nl_desc_objs *	(*getobjs)(struct sk_buff *skb,
+						   struct nlmsghdr *nlh,
+						   struct nl_desc_req *req);
+	int				(*parse)(struct net *net,
+						 struct sk_buff *skb,
+						 struct nlmsghdr *nlh,
+						 const struct nlattr *data,
+						 struct nl_desc_req *req);
+};
+
+/**
+ * struct nl_desc_attr - netlink attribute description
+ * @nest: netlink description for nested attribute
+ * @attr: attribute number
+ * @type: attribute datatype (see NLA_* enumeration)
+ * @len: attribute payload length
+ * @max: attribute maximum value (upper limit if any, zero means unset)
+ */
+struct nl_desc_attr {
+	const struct nl_desc_obj	*nest;
+	u16				attr;
+	u16				type;
+	u16				len;
+	u16				max;
+};
+
+/**
+ * struct nl_desc_obj - netlink object description
+ * @id: unique ID to identify this netlink object
+ * @max: number of attributes to describe this object
+ * @attrs: array of attribute descriptions
+ */
+struct nl_desc_obj {
+	u16				id;
+	u16				attr_max;
+	const struct nl_desc_attr	*attrs;
+};
+
+#define NLDESC_OBJ(__id, __attrs, __max)		\
+	{						\
+		.id		= __id,			\
+		.attr_max	= __max,		\
+		.attrs		= __attrs,		\
+	}
+
+#define NLDESC_OBJ_END	{ 0, 0, NULL }
+
+#define NLDESC_ATTR_MAX(__attr, __type, __len, __max)	\
+	{						\
+		.attr		= __attr,		\
+		.type		= __type,		\
+		.len		= __len,		\
+		.max		= __max,		\
+	}
+
+#define NLDESC_ATTR(__attr, __type, __len)		\
+	NLDESC_ATTR_MAX(__attr, __type, __len, 0)
+
+#define NLDESC_ATTR_NESTED(__attr, __nest)		\
+	{						\
+		.attr		= __attr,		\
+		.type		= NLA_NESTED,		\
+		.nest		= __nest,		\
+	}
+
+#define NLDESC_ATTR_STRING(__attr, __len)		\
+	NLDESC_ATTR(__attr, NLA_STRING, __len)
+
+#define NLDESC_ATTR_NUL_STRING(__attr)			\
+	NLDESC_ATTR(__attr, NLA_NUL_STRING, 0)
+
+#define NLDESC_ATTR_U8_MAX(__attr, __max)		\
+	NLDESC_ATTR_MAX(__attr, NLA_U8, sizeof(u8), __max)
+
+#define NLDESC_ATTR_U16_MAX(__attr, __max)		\
+	NLDESC_ATTR_MAX(__attr, NLA_U16, sizeof(u16), __max)
+
+#define NLDESC_ATTR_U32_MAX(__attr, __max)		\
+	NLDESC_ATTR_MAX(__attr, NLA_U32, sizeof(u32), __max)
+
+#define NLDESC_ATTR_U64_MAX(__attr, __max)		\
+	NLDESC_ATTR_MAX(__attr, NLA_U64, sizeof(u64), __max)
+
+#define NLDESC_ATTR_U8(__attr)				\
+	NLDESC_ATTR_U8_MAX(__attr, 0)
+
+#define NLDESC_ATTR_U16(__attr)				\
+	NLDESC_ATTR_U16_MAX(__attr, 0)
+
+#define NLDESC_ATTR_U32(__attr)				\
+	NLDESC_ATTR_U32_MAX(__attr, 0)
+
+#define NLDESC_ATTR_U64(__attr)				\
+	NLDESC_ATTR_U64_MAX(__attr, 0)
+
+#define NLDESC_ATTR_BINARY(__attr, __len)		\
+	NLDESC_ATTR(__attr, NLA_BINARY, __len)
+
+#define NLDESC_ATTR_PAD(__attr)				\
+	NLDESC_ATTR(__attr, NLA_PAD, 0)
+
+/**
+ * struct nl_desc_cmd - netlink command description
+ * @cmd: command identifier
+ * @obj_id: netlink object that this command takes
+ */
+struct nl_desc_cmd {
+	u16				cmd;
+	u16				obj_id;
+};
+
+#define NLDESC_CMD(__cmd, __obj_id)			\
+	{						\
+		.cmd		= __cmd,		\
+		.obj_id		= __obj_id,		\
+	}
+
+#define NLDESC_CMD_END	{ 0, 0 }
+
+int nl_desc_register_subsys(struct nl_desc_subsys *subsys);
+void nl_desc_unregister_subsys(struct nl_desc_subsys *subsys);
+
+#define MODULE_ALIAS_NLDESC(bus) \
+        MODULE_ALIAS("nl-desc-" __stringify(bus))
+
+#endif
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 776bc92e9118..208946e84893 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -29,6 +29,7 @@
 #define NETLINK_RDMA		20
 #define NETLINK_CRYPTO		21	/* Crypto layer */
 #define NETLINK_SMC		22	/* SMC monitoring */
+#define NETLINK_DESC		23
 
 #define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
 
@@ -248,4 +249,70 @@ struct nla_bitfield32 {
 	__u32 selector;
 };
 
+enum {
+	NLDESC_GET_CMDS		= 16,
+	NLDESC_NEW_CMDS,
+	NLDESC_GET_OBJS,
+	NLDESC_NEW_OBJS,
+};
+
+enum nft_nldesc_req_attributes {
+	NLA_DESC_REQ_UNSPEC,
+	NLA_DESC_REQ_BUS,
+	NLA_DESC_REQ_DATA,
+	__NLA_DESC_REQ_MAX,
+};
+#define NLA_DESC_REQ_MAX	(__NLA_DESC_REQ_MAX - 1)
+
+enum nft_nldesc_attributes {
+	NLA_DESC_UNSPEC,
+	NLA_DESC_NUM_OBJS,
+	NLA_DESC_OBJS,
+	__NLA_DESC_MAX,
+};
+#define NLA_DESC_MAX		(__NLA_DESC_MAX - 1)
+
+enum nft_nldesc_cmds_attributes {
+	NLA_DESC_CMDS_UNSPEC,
+	NLA_DESC_CMDS_NUM,
+	NLA_DESC_CMDS,
+	__NLA_DESC_CMDS_MAX,
+};
+#define NLA_DESC_CMDS_MAX	(__NLA_DESC_CMDS_MAX - 1)
+
+enum nft_nldesc_list_attributes {
+	NLA_DESC_LIST_UNSPEC,
+	NLA_DESC_LIST_ITEM,
+	__NLA_DESC_LIST_MAX,
+};
+#define NLA_DESC_LIST_MAX	(__NLA_DESC_LIST_MAX - 1)
+
+enum nft_nldesc_obj_attributes {
+	NLA_DESC_OBJ_UNSPEC,
+	NLA_DESC_OBJ_ID,
+	NLA_DESC_OBJ_ATTRS_MAX,
+	NLA_DESC_OBJ_ATTRS,
+	__NLA_DESC_OBJ_MAX,
+};
+#define NLA_DESC_OBJ_MAX	(__NLA_DESC_OBJ_MAX - 1)
+
+enum nft_nldesc_attr_attributes {
+	NLA_DESC_ATTR_UNSPEC,
+	NLA_DESC_ATTR_NUM,
+	NLA_DESC_ATTR_TYPE,
+	NLA_DESC_ATTR_LEN,
+	NLA_DESC_ATTR_MAXVAL,
+	NLA_DESC_ATTR_NEST_ID,
+	__NLA_DESC_ATTR_MAX,
+};
+#define NLA_DESC_ATTR_MAX	(__NLA_DESC_ATTR_MAX - 1)
+
+enum nft_nldesc_cmd_attributes {
+	NLA_DESC_CMD_UNSPEC,
+	NLA_DESC_CMD_ID,
+	NLA_DESC_CMD_OBJ,
+	__NLA_DESC_CMD_MAX,
+};
+#define NLA_DESC_CMD_MAX	(__NLA_DESC_CMD_MAX - 1)
+
 #endif /* _UAPI__LINUX_NETLINK_H */
diff --git a/net/netlink/Makefile b/net/netlink/Makefile
index e837917f6c03..0e44f10a084b 100644
--- a/net/netlink/Makefile
+++ b/net/netlink/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the netlink driver.
 #
 
-obj-y  				:= af_netlink.o genetlink.o
+obj-y  				:= af_netlink.o genetlink.o desc.o
 
 obj-$(CONFIG_NETLINK_DIAG)	+= netlink_diag.o
 netlink_diag-y			:= diag.o
diff --git a/net/netlink/desc.c b/net/netlink/desc.c
new file mode 100644
index 000000000000..55aaf6da0a24
--- /dev/null
+++ b/net/netlink/desc.c
@@ -0,0 +1,499 @@
+#include <net/net_namespace.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/netlink.h>
+#include <net/nldesc.h>
+#include <net/sock.h>
+
+static DEFINE_MUTEX(nl_desc_mutex);
+static LIST_HEAD(nl_desc_subsys_list);
+
+static int nl_fill_desc_attr_info(struct sk_buff *skb,
+				  const struct nl_desc_attr *entry)
+{
+	if (nla_put_u32(skb, NLA_DESC_ATTR_NUM, entry->attr) ||
+	    nla_put_u32(skb, NLA_DESC_ATTR_TYPE, entry->type))
+		goto nla_put_failure;
+
+	if (entry->nest && entry->nest->id) {
+		if (nla_put_u32(skb, NLA_DESC_ATTR_NEST_ID, entry->nest->id))
+			goto nla_put_failure;
+	} else if (nla_put_u32(skb, NLA_DESC_ATTR_LEN, entry->len)) {
+		goto nla_put_failure;
+	}
+
+	if (entry->max && nla_put_u32(skb, NLA_DESC_ATTR_MAXVAL, entry->max))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nl_fill_desc_attr_item_info(struct sk_buff *skb,
+				       const struct nl_desc_attr *entry)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, NLA_DESC_LIST_ITEM | NLA_F_NESTED);
+	if (!nest)
+		return -1;
+
+	if (nl_fill_desc_attr_info(skb, entry) < 0)
+		return -1;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+}
+
+static int nl_fill_desc_attrs_info(struct sk_buff *skb,
+				   const struct nl_desc_attr *attrs,
+				   int attrs_max)
+{
+	struct nlattr *nest;
+	int k;
+
+	nest = nla_nest_start(skb, NLA_DESC_OBJ_ATTRS | NLA_F_NESTED);
+	if (!nest)
+		return -1;
+
+	for (k = 0; k < attrs_max; k++) {
+		if (nl_fill_desc_attr_item_info(skb, &attrs[k]))
+			return -1;
+	}
+	nla_nest_end(skb, nest);
+
+	return 0;
+}
+
+static int nl_fill_desc_objs(struct sk_buff *skb,
+			     const struct nl_desc_obj *desc)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, NLA_DESC_LIST_ITEM | NLA_F_NESTED);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, NLA_DESC_OBJ_ID, desc->id) ||
+	    nla_put_u32(skb, NLA_DESC_OBJ_ATTRS_MAX, desc->attr_max))
+		goto nla_put_failure;
+
+	if (nl_fill_desc_attrs_info(skb, desc->attrs, desc->attr_max) < 0)
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+static int nl_fill_desc_cmds(struct sk_buff *skb,
+			     const struct nl_desc_cmd *desc)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, NLA_DESC_LIST_ITEM | NLA_F_NESTED);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, NLA_DESC_CMD_ID, desc->cmd) ||
+	    nla_put_u32(skb, NLA_DESC_CMD_OBJ, desc->obj_id))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+#define NLDESC_DUMP_DONE	~0ULL
+
+static void nl_dump_desc_objs_info(struct sk_buff *skb, unsigned long *index,
+				   const struct nl_desc_obj *nl_desc_obj_array[],
+				   u32 num_objects)
+{
+	const struct nl_desc_obj *desc, *last = (struct nl_desc_obj *)*index;
+	struct nlattr *nest;
+	int i, j;
+
+	if (!last && nla_put_u32(skb, NLA_DESC_NUM_OBJS, num_objects))
+		goto out;
+
+	nest = nla_nest_start(skb, NLA_DESC_OBJS | NLA_F_NESTED);
+	if (!nest)
+		goto out;
+
+	for (i = 0; nl_desc_obj_array[i]; i++) {
+		for (j = 0; nl_desc_obj_array[i][j].id; j++) {
+			desc = &nl_desc_obj_array[i][j];
+			if (last) {
+				if (last != desc)
+					continue;
+				else
+					last = NULL;
+			}
+
+			if (nl_fill_desc_objs(skb, desc))
+				goto nla_put_failure;
+		}
+	}
+	nla_nest_end(skb, nest);
+out:
+	*index = NLDESC_DUMP_DONE;
+	return;
+
+nla_put_failure:
+	nla_nest_end(skb, nest);
+	*index = (unsigned long)desc;
+	return;
+}
+
+static void nl_dump_desc_cmds_info(struct sk_buff *skb, unsigned long *index,
+				   const struct nl_desc_cmd nl_desc_cmd_array[],
+				   u32 num_cmds)
+{
+	const struct nl_desc_cmd *desc, *last = (struct nl_desc_cmd *)*index;
+	struct nlattr *nest;
+	int i;
+
+	if (!last && nla_put_u32(skb, NLA_DESC_CMDS_NUM, num_cmds))
+		goto out;
+
+	nest = nla_nest_start(skb, NLA_DESC_CMDS | NLA_F_NESTED);
+	if (!nest)
+		goto out;
+
+	for (i = 0; nl_desc_cmd_array[i].obj_id; i++) {
+		desc = &nl_desc_cmd_array[i];
+		if (last) {
+			if (last != desc)
+				continue;
+			else
+				last = NULL;
+		}
+		if (nl_fill_desc_cmds(skb, desc))
+			goto nla_put_failure;
+	}
+	nla_nest_end(skb, nest);
+out:
+	*index = NLDESC_DUMP_DONE;
+	return;
+
+nla_put_failure:
+	nla_nest_end(skb, nest);
+	*index = (unsigned long)desc;
+	return;
+}
+
+static struct nl_desc_subsys *nl_desc_find(struct net *net, int bus)
+{
+	struct nl_desc_subsys *subsys;
+
+	list_for_each_entry_rcu(subsys, &nl_desc_subsys_list, list) {
+		if (subsys->bus != bus)
+			continue;
+
+		return subsys;
+	}
+
+	return NULL;
+}
+
+static int nl_dump_nldesc_cmds_callback(struct sk_buff *skb,
+					struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nl_desc_req *req = cb->data;
+	const struct nl_desc_cmds *cmds;
+	struct nl_desc_subsys *subsys;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (cb->args[0] == NLDESC_DUMP_DONE)
+		return 0;
+
+	rcu_read_lock();
+	subsys = nl_desc_find(net, req->bus);
+	if (!subsys) {
+		err = -ENOENT;
+		goto err;
+	}
+
+	cmds = subsys->getcmds(skb, nlh, req);
+	if (IS_ERR(cmds)) {
+		err = PTR_ERR(cmds);
+		goto err;
+	}
+	rcu_read_unlock();
+
+	nlh = nlmsg_put(skb, NETLINK_CB(skb).portid, cb->nlh->nlmsg_seq,
+			NLDESC_NEW_CMDS, 0, 0);
+	if (nlh == NULL)
+		return -ENOMEM;
+
+	nl_dump_desc_cmds_info(skb, &cb->args[0], cmds->table, cmds->max);
+	nlmsg_end(skb, nlh);
+
+	return skb->len;
+err:
+	rcu_read_unlock();
+	return err;
+}
+
+static int nl_dump_nldesc_objs_callback(struct sk_buff *skb,
+					struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nl_desc_req *req = cb->data;
+	const struct nl_desc_objs *objs;
+	struct nl_desc_subsys *subsys;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (cb->args[0] == NLDESC_DUMP_DONE)
+		return 0;
+
+	rcu_read_lock();
+	subsys = nl_desc_find(net, req->bus);
+	if (!subsys) {
+		err = -ENOENT;
+		goto err;
+	}
+
+	objs = subsys->getobjs(skb, nlh, req);
+	if (IS_ERR(objs)) {
+		err = PTR_ERR(objs);
+		goto err;
+	}
+	rcu_read_unlock();
+
+	nlh = nlmsg_put(skb, NETLINK_CB(skb).portid, cb->nlh->nlmsg_seq,
+			NLDESC_NEW_OBJS, 0, 0);
+	if (nlh == NULL)
+		return -ENOMEM;
+
+	nl_dump_desc_objs_info(skb, &cb->args[0], objs->table, objs->max);
+	nlmsg_end(skb, nlh);
+
+	return skb->len;
+err:
+	rcu_read_unlock();
+	return err;
+}
+
+static int nl_dump_nldesc_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+
+	return 0;
+}
+
+static int nl_desc_handle(struct net *net, struct sk_buff *skb,
+			  struct nlmsghdr *nlh, struct nl_desc_req *req,
+			  int (*nl_dump_nldesc)(struct sk_buff *skb,
+						struct netlink_callback *cb))
+{
+	struct netlink_dump_control c = {
+		.dump 	= nl_dump_nldesc,
+		.done	= nl_dump_nldesc_done,
+		.data 	= req,
+	};
+
+	return netlink_dump_start(net->nl_desc_sock, skb, nlh, &c);
+}
+
+static const struct nla_policy nl_desc_policy[NLA_DESC_REQ_MAX + 1] = {
+	[NLA_DESC_REQ_BUS]	= { .type = NLA_U32 },
+	[NLA_DESC_REQ_DATA]	= { .type = NLA_NESTED },
+};
+
+static int nl_desc_handle_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack)
+{
+	int min_len = nlmsg_total_size(0);
+	struct nlattr *attr = (void *)nlh + min_len;
+	struct nlattr *tb[NLA_DESC_REQ_MAX + 1];
+	int attrlen = nlh->nlmsg_len - min_len;
+	struct net *net = sock_net(skb->sk);
+	const struct nl_desc_subsys *subsys;
+	const struct nl_desc_objs *objs;
+	const struct nl_desc_cmds *cmds;
+	struct nl_desc_req *req;
+	u32 bus;
+	int err;
+
+	if (nlh->nlmsg_len < nlmsg_msg_size(0))
+		return -EINVAL;
+
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!(nlh->nlmsg_flags & NLM_F_DUMP))
+		return -EOPNOTSUPP;
+
+	if (nlh->nlmsg_type != NLDESC_GET_CMDS &&
+	    nlh->nlmsg_type != NLDESC_GET_OBJS)
+		return -EOPNOTSUPP;
+
+	err = nla_parse(tb, NLA_DESC_REQ_MAX, attr, attrlen, nl_desc_policy,
+			extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[NLA_DESC_REQ_BUS])
+		return -EINVAL;
+
+	bus = nla_get_u32(tb[NLA_DESC_REQ_BUS]);
+
+	rcu_read_lock();
+	subsys = nl_desc_find(net, bus);
+	if (!subsys) {
+#ifdef CONFIG_MODULES
+		rcu_read_unlock();
+		request_module("nl-desc-%u", bus);
+		rcu_read_lock();
+#endif
+		subsys = nl_desc_find(net, bus);
+		if (!subsys) {
+			err = -ENOENT;
+			goto err;
+		}
+	}
+
+	req = kzalloc(sizeof(struct nl_desc_req), GFP_ATOMIC);
+	if (!req) {
+		err = -ENOMEM;
+		goto err;
+	}
+	req->bus = subsys->bus;
+
+	if (tb[NLA_DESC_REQ_DATA]) {
+		/* This may return -EAGAIN to autoload module dependencies. */
+		err = subsys->parse(net, skb, nlh, tb[NLA_DESC_REQ_DATA], req);
+		if (err < 0) {
+			kfree(req);
+			goto err;
+		}
+		/* Make sure subsystem is loaded before starting netlink dump. */
+		switch (nlh->nlmsg_type) {
+		case NLDESC_GET_CMDS:
+			cmds = subsys->getcmds(skb, nlh, req);
+			if (IS_ERR(cmds)) {
+				err = PTR_ERR(cmds);
+				goto err;
+			}
+			break;
+		case NLDESC_GET_OBJS:
+			objs = subsys->getobjs(skb, nlh, req);
+			if (IS_ERR(objs)) {
+				err = PTR_ERR(objs);
+				goto err;
+			}
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	switch (nlh->nlmsg_type) {
+	case NLDESC_GET_CMDS:
+		err = nl_desc_handle(net, skb, nlh, req,
+				     nl_dump_nldesc_cmds_callback);
+		break;
+	case NLDESC_GET_OBJS:
+		err = nl_desc_handle(net, skb, nlh, req,
+				     nl_dump_nldesc_objs_callback);
+		break;
+	}
+	return err;
+err:
+	rcu_read_unlock();
+	return err;
+}
+
+static int nl_desc_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			   struct netlink_ext_ack *extack)
+{
+	bool retry = false;
+	int err;
+
+	do {
+		err = nl_desc_handle_msg(skb, nlh, extack);
+		if (err == -EAGAIN && !retry) {
+			retry = true;
+			continue;
+		}
+		break;
+	} while (1);
+
+	return err;
+}
+
+static void nl_desc_rcv(struct sk_buff *skb)
+{
+	netlink_rcv_skb(skb, &nl_desc_rcv_msg);
+}
+
+int nl_desc_register_subsys(struct nl_desc_subsys *subsys)
+{
+	if (subsys->bus >= MAX_LINKS)
+		return -ENOENT;
+
+	mutex_lock(&nl_desc_mutex);
+	list_add_rcu(&subsys->list, &nl_desc_subsys_list);
+	mutex_unlock(&nl_desc_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nl_desc_register_subsys);
+
+void nl_desc_unregister_subsys(struct nl_desc_subsys *subsys)
+{
+	mutex_lock(&nl_desc_mutex);
+	list_del_rcu(&subsys->list);
+	mutex_unlock(&nl_desc_mutex);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(nl_desc_unregister_subsys);
+
+static int __net_init nl_desc_pernet_init(struct net *net)
+{
+	struct netlink_kernel_cfg cfg = {
+		.input		= nl_desc_rcv,
+	};
+
+	net->nl_desc_sock = netlink_kernel_create(net, NETLINK_DESC, &cfg);
+	if (!net->nl_desc_sock && net_eq(net, &init_net))
+		panic("Cannot initialize netlink description bus\n");
+
+	if (!net->nl_desc_sock)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __net_exit nl_desc_pernet_exit(struct net *net)
+{
+	netlink_kernel_release(net->nl_desc_sock);
+	net->nl_desc_sock = NULL;
+}
+
+static struct pernet_operations nl_desc_pernet_ops = {
+	.init = nl_desc_pernet_init,
+	.exit = nl_desc_pernet_exit,
+};
+
+static int __init nl_desc_init(void)
+{
+	return register_pernet_subsys(&nl_desc_pernet_ops);
+}
+subsys_initcall(nl_desc_init);
-- 
2.11.0

