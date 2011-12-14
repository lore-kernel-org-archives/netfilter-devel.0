From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: add extended accounting infrastructure over nfnetlink
Date: Wed, 14 Dec 2011 12:00:42 +0100
Message-ID: <1323860443-7129-2-git-send-email-pablo@netfilter.org>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net, jengelh@medozas.de,
	thomas.jarosch@intra2net.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56419 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1LNLBY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:01:24 -0500
In-Reply-To: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

We currently have two ways to account traffic in netfilter:

- iptables chain and rule counters:

 # iptables -L -n -v
Chain INPUT (policy DROP 3 packets, 867 bytes)
 pkts bytes target     prot opt in     out     source               destination
    8  1104 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0

- use flow-based accounting provided by ctnetlink:

 # conntrack -L
tcp      6 431999 ESTABLISHED src=192.168.1.130 dst=212.106.219.168 sport=58152 dport=80 packets=47 bytes=7654 src=212.106.219.168 dst=192.168.1.130 sport=80 dport=58152 packets=49 bytes=66340 [ASSURED] mark=0 use=1

While trying to display real-time accounting statistics, we require
to pool the kernel periodically to obtain this information. This is
OK if the number of flows is relatively low. However, in case that
the number of flows is huge, we can spend a considerable amount of
cycles to iterate over the list of flows that have been obtained.

Moreover, if we want to obtain the sum of the flow accounting results
that match some criteria, we have to iterate over the whole list of
existing flows, look for matchings and update the counters.

This patch adds the extended accounting infrastructure for
nfnetlink which aims to allow displaying real-time traffic accounting
without the need of complicated and resource-consuming implementation
in user-space. Basically, this new infrastructure allows you to create
accounting objects. One accounting object is composed of packet and
byte counters.

In order to manipulate create accounting objects, you require the
new libnetfilter_acct library. It contains several examples of use:

libnetfilter_acct/examples# ./nfacct-add http-traffic
libnetfilter_acct/examples# ./nfacct-get
http-traffic = { pkts = 000000000000,   bytes = 000000000000 };

Then, you can use one of this accounting objects in several iptables
rules using the new NFACCT target (which comes in a follow-up patch):

 # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
 # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic

The idea is simple: if one packet matches the rule, the NFACCT target
updates the counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/Kbuild           |    1 +
 include/linux/netfilter/nfnetlink.h      |    3 +-
 include/linux/netfilter/nfnetlink_acct.h |   34 +++
 net/netfilter/Kconfig                    |    8 +
 net/netfilter/Makefile                   |    1 +
 net/netfilter/nfnetlink_acct.c           |  352 ++++++++++++++++++++++++++++++
 6 files changed, 398 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 net/netfilter/nfnetlink_acct.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index a1b410c..8995867 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -6,6 +6,7 @@ header-y += nf_conntrack_sctp.h
 header-y += nf_conntrack_tcp.h
 header-y += nf_conntrack_tuple_common.h
 header-y += nfnetlink.h
+header-y += nfnetlink_acct.h
 header-y += nfnetlink_compat.h
 header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 74d3386..b64454c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -48,7 +48,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ULOG		4
 #define NFNL_SUBSYS_OSF			5
 #define NFNL_SUBSYS_IPSET		6
-#define NFNL_SUBSYS_COUNT		7
+#define NFNL_SUBSYS_ACCT		7
+#define NFNL_SUBSYS_COUNT		8
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
new file mode 100644
index 0000000..9a1a119
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -0,0 +1,34 @@
+#ifndef _NFNL_ACCT_H_
+#define _NFNL_ACCT_H_
+#include <linux/netfilter/nfnetlink.h>
+
+#define NFACCT_NAME_MAX		64
+
+enum nfnl_acct_msg_types {
+	NFNL_MSG_ACCT_NEW,
+	NFNL_MSG_ACCT_GET,
+	NFNL_MSG_ACCT_GET_CTRZERO,
+	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_MAX
+};
+
+enum nfnl_acct_type {
+	NFACCT_UNSPEC,
+	NFACCT_NAME,
+	NFACCT_PKTS,
+	NFACCT_BYTES,
+	__NFACCT_MAX
+};
+#define NFACCT_MAX (__NFACCT_MAX - 1)
+
+#ifdef __KERNEL__
+
+struct nf_acct;
+
+extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
+extern void nfnl_acct_put(struct nf_acct *acct);
+extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
+
+#endif /* __KERNEL__ */
+
+#endif /* _NFNL_ACCT_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d5597b7..77326ac 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -4,6 +4,14 @@ menu "Core Netfilter Configuration"
 config NETFILTER_NETLINK
 	tristate
 
+config NETFILTER_NETLINK_ACCT
+tristate "Netfilter NFACCT over NFNETLINK interface"
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK
+	help
+	  If this option is enabled, the kernel will include support
+	  for extended accounting via NFNETLINK.
+
 config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1a02853..4da1c87 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -7,6 +7,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
+obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
 
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
new file mode 100644
index 0000000..3ec407f
--- /dev/null
+++ b/net/netfilter/nfnetlink_acct.c
@@ -0,0 +1,352 @@
+/*
+ * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2011 Intra2net AG <http://www.intra2net.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation (or any later at your option).
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/netlink.h>
+#include <linux/rculist.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <net/netlink.h>
+#include <net/sock.h>
+#include <asm/atomic.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_acct.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastructure");
+
+static LIST_HEAD(nfnl_acct_list);
+
+struct nf_acct {
+	struct rcu_head		rcu_head;
+	struct list_head	head;
+	spinlock_t		lock;	/* to update the counters. */
+	atomic_t		refcnt;
+
+	char			name[NFACCT_NAME_MAX];
+	__u64			pkts;
+	__u64			bytes;
+};
+
+static void nfnl_acct_free_rcu(struct rcu_head *rcu_head)
+{
+	struct nf_acct *acct = container_of(rcu_head, struct nf_acct, rcu_head);
+
+	kfree(acct);
+}
+
+static int
+nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
+{
+	int ret;
+	struct nf_acct *acct, *matching = NULL;
+	char *acct_name;
+
+	if (!tb[NFACCT_NAME])
+		return -EINVAL;
+
+	acct_name = nla_data(tb[NFACCT_NAME]);
+
+	rcu_read_lock();
+	list_for_each_entry(acct, &nfnl_acct_list, head) {
+		if (strncmp(acct->name, acct_name, NFACCT_NAME_MAX) != 0)
+			continue;
+
+                if (nlh->nlmsg_flags & NLM_F_EXCL) {
+			rcu_read_unlock();
+			ret = -EEXIST;
+			goto err;
+		}
+		matching = acct;
+        }
+	rcu_read_unlock();
+
+	acct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
+	if (acct == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	spin_lock_init(&acct->lock);
+	strncpy(acct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
+	if (tb[NFACCT_BYTES])
+		acct->bytes = be64_to_cpu(nla_get_u64(tb[NFACCT_BYTES]));
+	if (tb[NFACCT_PKTS])
+		acct->pkts = be64_to_cpu(nla_get_u64(tb[NFACCT_PKTS]));
+
+	atomic_inc(&acct->refcnt);
+
+	/* We are protected by nfnl mutex. */
+	if (matching) {
+		list_del_rcu(&matching->head);
+		if (atomic_dec_and_test(&matching->refcnt))
+			call_rcu(&matching->rcu_head, nfnl_acct_free_rcu);
+
+	}
+	list_add_tail_rcu(&acct->head, &nfnl_acct_list);
+	return 0;
+err:
+	return ret;
+}
+
+static int
+nfnl_acct_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
+		   int event, struct nf_acct *acct)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfmsg;
+	unsigned int flags = pid ? NLM_F_MULTI : 0;
+
+	event |= NFNL_SUBSYS_ACCT << 8;
+	nlh = nlmsg_put(skb, pid, seq, event, sizeof(*nfmsg), flags);
+	if (nlh == NULL)
+		goto nlmsg_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family = AF_UNSPEC;
+	nfmsg->version = NFNETLINK_V0;
+	nfmsg->res_id = 0;
+
+	NLA_PUT_STRING(skb, NFACCT_NAME, acct->name);
+	NLA_PUT_BE64(skb, NFACCT_PKTS, cpu_to_be64(acct->pkts));
+	NLA_PUT_BE64(skb, NFACCT_BYTES, cpu_to_be64(acct->bytes));
+
+	nlmsg_end(skb, nlh);
+	return skb->len;
+
+nlmsg_failure:
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -1;
+}
+
+static int
+nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nf_acct *cur, *last;
+
+	if (cb->args[2])
+		return 0;
+
+	last = (struct nf_acct *)cb->args[1];
+	if (cb->args[1])
+		cb->args[1] = 0;
+
+	rcu_read_lock();
+	list_for_each_entry(cur, &nfnl_acct_list, head) {
+		if (last && cur != last)
+			continue;
+
+		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).pid,
+				       cb->nlh->nlmsg_seq,
+				       NFNL_MSG_ACCT_NEW, cur) < 0) {
+			cb->args[1] = (unsigned long)cur;
+			break;
+		}
+
+		if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) ==
+						NFNL_MSG_ACCT_GET_CTRZERO) {
+			spin_lock_bh(&cur->lock);
+			cur->pkts = 0;
+			cur->bytes = 0;
+			spin_unlock_bh(&cur->lock);
+		}
+	}
+	if (!cb->args[1])
+		cb->args[2] = 1;
+	rcu_read_unlock();
+	return skb->len;
+}
+
+static int
+nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
+{
+	int ret = 0;
+	struct nf_acct *cur;
+	char *acct_name;
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		return netlink_dump_start(nfnl, skb, nlh, nfnl_acct_dump,
+					  NULL, 0);
+	}
+
+	if (!tb[NFACCT_NAME])
+		return -EINVAL;
+	acct_name = nla_data(tb[NFACCT_NAME]);
+
+	rcu_read_lock();
+	list_for_each_entry(cur, &nfnl_acct_list, head) {
+		struct sk_buff *skb2;
+
+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
+			continue;
+
+		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+		if (skb2 == NULL)
+			break;
+
+		ret = nfnl_acct_fill_info(skb2, NETLINK_CB(skb).pid,
+					 nlh->nlmsg_seq,
+					 NFNL_MSG_ACCT_NEW, cur);
+		if (ret <= 0)
+			kfree_skb(skb2);
+
+		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
+						NFNL_MSG_ACCT_GET_CTRZERO) {
+			spin_lock_bh(&cur->lock);
+			cur->pkts = 0;
+			cur->bytes = 0;
+			spin_unlock_bh(&cur->lock);
+		}
+		break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int
+nfnl_acct_del(struct sock *nfnl, struct sk_buff *skb,
+	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
+{
+	char *acct_name;
+	struct nf_acct *cur;
+	int ret = -ENOENT;
+
+	if (!tb[NFACCT_NAME]) {
+		rcu_read_lock();
+		list_for_each_entry(cur, &nfnl_acct_list, head) {
+			/* We are protected by nfnl mutex. */
+			list_del_rcu(&cur->head);
+			if (atomic_dec_and_test(&cur->refcnt))
+				call_rcu(&cur->rcu_head, nfnl_acct_free_rcu);
+		}
+		rcu_read_lock();
+		return 0;
+	}
+	acct_name = nla_data(tb[NFACCT_NAME]);
+
+	rcu_read_lock();
+	list_for_each_entry(cur, &nfnl_acct_list, head) {
+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX) != 0)
+			continue;
+
+		/* We are protected by nfnl mutex. */
+		list_del_rcu(&cur->head);
+		if (atomic_dec_and_test(&cur->refcnt))
+			call_rcu(&cur->rcu_head, nfnl_acct_free_rcu);
+		ret = 0;
+		break;
+	}
+	rcu_read_lock();
+	return ret;
+}
+
+static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
+	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
+	[NFACCT_BYTES] = { .type = NLA_U64 },
+	[NFACCT_PKTS] = { .type = NLA_U64 },
+};
+
+static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
+	[NFNL_MSG_ACCT_NEW]		= { .call = nfnl_acct_new,
+					    .attr_count = NFACCT_MAX,
+					    .policy = nfnl_acct_policy },
+	[NFNL_MSG_ACCT_GET] 		= { .call = nfnl_acct_get,
+					    .attr_count = NFACCT_MAX,
+					    .policy = nfnl_acct_policy },
+	[NFNL_MSG_ACCT_GET_CTRZERO] 	= { .call = nfnl_acct_get,
+					    .attr_count = NFACCT_MAX,
+					    .policy = nfnl_acct_policy },
+	[NFNL_MSG_ACCT_DEL]		= { .call = nfnl_acct_del,
+					    .attr_count = NFACCT_MAX,
+					    .policy = nfnl_acct_policy },
+};
+
+static const struct nfnetlink_subsystem nfnl_acct_subsys = {
+	.name				= "acct",
+	.subsys_id			= NFNL_SUBSYS_ACCT,
+	.cb_count			= NFNL_MSG_ACCT_MAX,
+	.cb				= nfnl_acct_cb,
+};
+
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
+
+struct nf_acct *nfnl_acct_find_get(const char *acct_name)
+{
+	struct nf_acct *cur, *acct = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry(cur, &nfnl_acct_list, head) {
+		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
+			continue;
+
+		acct = cur;
+		atomic_inc(&acct->refcnt);
+		break;
+	}
+	rcu_read_unlock();
+	return acct;
+}
+EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
+
+void nfnl_acct_put(struct nf_acct *acct)
+{
+	if (atomic_dec_and_test(&acct->refcnt))
+		call_rcu(&acct->rcu_head, nfnl_acct_free_rcu);
+}
+EXPORT_SYMBOL_GPL(nfnl_acct_put);
+
+void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
+{
+	spin_lock_bh(&nfacct->lock);
+	nfacct->pkts++;
+	nfacct->bytes += skb->len;
+	spin_unlock_bh(&nfacct->lock);
+}
+EXPORT_SYMBOL_GPL(nfnl_acct_update);
+
+static int __init nfnl_acct_init(void)
+{
+	int ret;
+
+	pr_info("nfnl_acct: registering with nfnetlink.\n");
+	ret = nfnetlink_subsys_register(&nfnl_acct_subsys);
+	if (ret < 0) {
+		pr_err("nfnl_acct_init: cannot register with nfnetlink.\n");
+		goto err_out;
+	}
+	return 0;
+err_out:
+	return ret;
+}
+
+static void __exit nfnl_acct_exit(void)
+{
+	struct nf_acct *cur, *tmp;
+
+	pr_info("nfnl_acct: unregistering from nfnetlink.\n");
+	nfnetlink_subsys_unregister(&nfnl_acct_subsys);
+
+	/* if we can remove this module, it means that it has no clients. */
+	list_for_each_entry_safe(cur, tmp, &nfnl_acct_list, head) {
+		list_del_rcu(&cur->head);
+		if (atomic_dec_and_test(&cur->refcnt))
+			kfree(cur);
+	}
+}
+
+module_init(nfnl_acct_init);
+module_exit(nfnl_acct_exit);
-- 
1.7.2.5

