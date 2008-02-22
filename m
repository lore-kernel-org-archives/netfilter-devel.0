From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] Implement connection tracking event over netlink unicast
Date: Fri, 22 Feb 2008 20:30:42 +0100
Message-ID: <47BF22E2.1010204@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070405060108020009050501"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42144 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753174AbYBVTbF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:31:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070405060108020009050501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Time ago I came up with the idea of adding a new target which marks
events as volatile to explicitly tell ctnetlink not to deliver events
over netlink for the traffic that matches the rule.

Although this approach is simple, it has serious limitations. For
example, in a ulogd + conntrackd setup the user may want to log all the
traffic but only replicate certain connections to the backup node. Also,
the conntrackd user may want to replicate only ESTABLISHED states
instead of all states to reduce resource consumption in a busy firewall
but log only the destroy messages coming from ctnetlink for accounting
purposes. In both cases, this target would not help.

For that reason, I decided to start a patch which implements connection
tracking event delivery over netlink unicast in a similar fashion as
other netfilter subsystems such as log and queue.

Attached a RFC patch (yet untested with no IPv6 support and no userspace
part) that implements connection tracking event delivery over netlink
unicast. This patch introduces the NFCONNTRACK target which is similar
to NFQUEUE and NFLOG. An example of usage is:

iptables -I POSTROUTING -t events -m state ESTABLISHED -j NFCONNTRACK
--queue-num 1

With this rule, only the ESTABLISHED connection tracking events are
delivered over netlink unicast to the userspace program listening in the
queue number 1. This enables events filtering through iptables, so that
a user can tell what events are propagated to userspace. This approach
removes the limitation of my initial idea since we can do specific
filtering for ulogd and conntrackd, both listeing in different queue
numbers, without disturbing each other.

This patch introduces several important changes:

* A new table, so-called 'events', which is placed at the end of
postrouting once the connection tracking has successfully confirmed a
conntrack entry to avoid event delivery of possibly dropped packets in
the 'filter' table. In practise, this table is only loaded as module
when the user wants to perform event filtering so that it does not
introduce any overhead for users that do not need this feature.

* A new target, so-called NFCONNTRACK, which can only be inserted in the
events table.

* An extra hook which is only present if connection tracking event
delivery is enabled.

In terms of hooks, the changes are the following:

        NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
        NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
        NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,
        NF_IP_PRI_LAST = INT_MAX,

The 'events' table is placed after the conntrack confirmation, and the
final event delivery through the ecache infrastructure is placed at the
end. If we schedule for removal events delivery over netlink broadcast
we can get rid of NF_IP_PRI_CONNTRACK_EVENTS hook, however, this would
break backward anyway. Another choice to remove this hook can be to
recover the idea of the per-skbuff event cache, however, this means 4
bytes extra per skbuff.

Another argument in favor of this patch is that it homogenize the
netfilter subsystem so that they all require a target to enable netlink
features.

Comments welcome.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070405060108020009050501
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[RFC] Implement connection tracking events over unicast netlink

This patch implements connection tracking event delivery through unicast 
netlink.

Sign-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2008-02-22 18:51:48.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2008-02-22 19:29:25.000000000 +0100
@@ -7,6 +7,7 @@ enum cntl_msg_types {
 	IPCTNL_MSG_CT_GET,
 	IPCTNL_MSG_CT_DELETE,
 	IPCTNL_MSG_CT_GET_CTRZERO,
+	IPCTNL_MSG_CT_UEVENTS,
 
 	IPCTNL_MSG_MAX
 };
@@ -149,4 +150,15 @@ enum ctattr_help {
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
 
+enum ctevents {
+	CTA_UEVENT_CFG_BIND,
+	CTA_UEVENT_CFG_UNBIND,
+	__CTA_UEVENT_MAX,
+};
+#define CTA_UEVENT_MAX (__CTA_UEVENT_MAX - 1)
+
+#ifdef __KERNEL__
+extern int nf_ct_send_uevent(const struct nf_conn *ct, int queue_num);
+#endif /* __KERNEL__ */
+
 #endif /* _IPCONNTRACK_NETLINK_H */
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-02-22 19:32:03.000000000 +0100
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -411,41 +412,35 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-static int ctnetlink_conntrack_event(struct notifier_block *this,
-				     unsigned long events, void *ptr)
+static struct sk_buff *
+ctnetlink_build_event_msg(const struct nf_conn *ct,
+			  unsigned int events,
+			  int *group)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	struct nf_conn *ct = (struct nf_conn *)ptr;
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
-	unsigned int flags = 0, group;
-
-	/* ignore our fake conntrack entry */
-	if (ct == &nf_conntrack_untracked)
-		return NOTIFY_DONE;
+	unsigned int flags = 0;
 
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
-		group = NFNLGRP_CONNTRACK_DESTROY;
+		*group = NFNLGRP_CONNTRACK_DESTROY;
 	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		group = NFNLGRP_CONNTRACK_NEW;
+		*group = NFNLGRP_CONNTRACK_NEW;
 	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
-		group = NFNLGRP_CONNTRACK_UPDATE;
+		*group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
 		return NOTIFY_DONE;
 
-	if (!nfnetlink_has_listeners(group))
-		return NOTIFY_DONE;
-
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
-		return NOTIFY_DONE;
+		return NULL;
 
 	b = skb->tail;
 
@@ -517,14 +512,199 @@ static int ctnetlink_conntrack_event(str
 	}
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, 0, group, 0);
-	return NOTIFY_DONE;
+	return skb;
 
 nlmsg_failure:
 nla_put_failure:
 	kfree_skb(skb);
+	return NULL;
+}
+
+static int ctnetlink_conntrack_event(struct notifier_block *this,
+				     unsigned long events, void *ptr)
+{
+	unsigned int group;
+	struct nf_conn *ct = (struct nf_conn *) ptr;
+	struct sk_buff *skb;
+
+	/* ignore our fake conntrack entry */
+	if (ct == &nf_conntrack_untracked)
+		return NOTIFY_DONE;
+
+	if (!nfnetlink_has_listeners(group))
+		return NOTIFY_DONE;
+
+	skb = ctnetlink_build_event_msg(ct, events, &group);
+	if (!skb)
+		return NOTIFY_DONE;
+
+	nfnetlink_send(skb, 0, group, 0);
+
 	return NOTIFY_DONE;
 }
+
+static HLIST_HEAD(equeue_list);
+static DEFINE_SPINLOCK(equeue_lock);
+
+struct nfct_equeue {
+	struct hlist_node hlist;
+	struct rcu_head rcu;
+
+	int queue_num;
+	int peer_pid;
+};
+
+static struct nfct_equeue *ctnetlink_lookup_equeue(int queue_num)
+{
+	struct hlist_node *pos;
+	struct nfct_equeue *this;
+
+	hlist_for_each_entry_rcu(this, pos, &equeue_list, hlist) {
+		if (this->queue_num == queue_num)
+			return this;
+	}
+	return NULL;
+}
+
+static int ctnetlink_create_equeue(u_int16_t queue_num, int pid)
+{
+	int ret = 0;
+	struct nfct_equeue *equeue;
+
+	spin_lock(&equeue_lock);
+
+	if (ctnetlink_lookup_equeue(queue_num)) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
+	if (!try_module_get(THIS_MODULE)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	equeue = kzalloc(sizeof(*equeue), GFP_ATOMIC);
+	if (!equeue) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	INIT_RCU_HEAD(&equeue->rcu);
+	equeue->queue_num = queue_num;
+	equeue->peer_pid = pid;
+
+	hlist_add_head_rcu(&equeue->hlist, &equeue_list);
+
+out_unlock:
+	spin_unlock(&equeue_lock);
+
+	return ret;
+}
+
+static void equeue_destroy_rcu(struct rcu_head *head)
+{
+	struct nfct_equeue *this = container_of(head, struct nfct_equeue, rcu);
+
+	kfree(this);
+	module_put(THIS_MODULE);
+}
+
+static void __ctnetlink_destroy_equeue(struct nfct_equeue *equeue)
+{
+	hlist_del_rcu(&equeue->hlist);
+	call_rcu(&equeue->rcu, equeue_destroy_rcu);
+}
+
+static void ctnetlink_destroy_equeue(u_int16_t queue_num, int pid)
+{
+	struct nfct_equeue *equeue;
+
+	spin_lock(&equeue_lock);
+
+	equeue = ctnetlink_lookup_equeue(queue_num);
+	BUG_ON(equeue == NULL);
+
+	__ctnetlink_destroy_equeue(equeue);
+
+	spin_unlock(&equeue_lock);
+}
+
+static const struct nla_policy ct_events_nla_policy[CTA_UEVENT_MAX+1] = {
+	[CTA_UEVENT_CFG_BIND] 	= { .type = NLA_U16 },
+	[CTA_UEVENT_CFG_UNBIND] = { .type = NLA_U16 },
+};
+
+static int
+ctnetlink_uevents_conntrack(struct sock *ctnl, struct sk_buff *skb,
+			    struct nlmsghdr *nlh, struct nlattr *cda[])
+{
+	int ret;
+
+	if (cda[CTA_UEVENT_CFG_BIND]) {
+		u_int16_t queue_num = nla_get_be16(cda[CTA_UEVENT_CFG_BIND]);
+
+		ret = ctnetlink_create_equeue(queue_num, NETLINK_CB(skb).pid);
+		if (ret < 0)
+			return ret;
+	}
+	if (cda[CTA_UEVENT_CFG_UNBIND]) {
+		u_int16_t queue_num = nla_get_be16(cda[CTA_UEVENT_CFG_UNBIND]);
+
+		ctnetlink_destroy_equeue(queue_num, NETLINK_CB(skb).pid);
+		return 0;
+	}
+
+	return -ENOTSUPP;
+}
+
+static int
+ctnetlink_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	struct nfct_equeue *equeue;
+	struct hlist_node *tmp, *tmp2;
+	struct netlink_notify *n = ptr;
+
+	if (event != NETLINK_URELEASE ||
+	    n->protocol != NETLINK_NETFILTER || !n->pid)
+	    	return NOTIFY_DONE;
+
+	spin_lock(&equeue_lock);
+	hlist_for_each_entry_safe(equeue, tmp, tmp2, &equeue_list, hlist) {
+		if ((n->net == &init_net) && (n->pid == equeue->peer_pid)) {
+		    	__ctnetlink_destroy_equeue(equeue);
+		}
+	}
+	spin_unlock(&equeue_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nfct_rtnl_notifier = {
+	.notifier_call  = ctnetlink_nl_event,
+};
+
+int nf_ct_send_uevent(const struct nf_conn *ct, int queue_num)
+{
+	struct sk_buff *skb;
+	struct nfct_equeue *equeue;
+	unsigned int group;
+	unsigned int events;
+
+	equeue = ctnetlink_lookup_equeue(queue_num);
+	if (!equeue)
+		return -1;
+
+	if (!nf_ct_get_current_events(ct, &events))
+		return -1;
+
+	skb = ctnetlink_build_event_msg(ct, events, &group);
+	if (!skb)
+		return -1;
+
+	return nfnetlink_unicast(skb, equeue->peer_pid, MSG_DONTWAIT);
+}
+EXPORT_SYMBOL_GPL(nf_ct_send_uevent);
+
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static int ctnetlink_done(struct netlink_callback *cb)
@@ -1773,6 +1953,9 @@ static const struct nfnl_callback ctnl_c
 	[IPCTNL_MSG_CT_GET_CTRZERO] 	= { .call = ctnetlink_get_conntrack,
 					    .attr_count = CTA_MAX,
 					    .policy = ct_nla_policy },
+	[IPCTNL_MSG_CT_UEVENTS]		= { .call = ctnetlink_uevents_conntrack,
+					    .attr_count = CTA_UEVENT_MAX,
+					    .policy = ct_events_nla_policy },
 };
 
 static const struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
@@ -1823,6 +2006,8 @@ static int __init ctnetlink_init(void)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+	netlink_register_notifier(&nfct_rtnl_notifier);
+
 	ret = nf_conntrack_register_notifier(&ctnl_notifier);
 	if (ret < 0) {
 		printk("ctnetlink_init: cannot register notifier.\n");
@@ -1842,6 +2027,7 @@ static int __init ctnetlink_init(void)
 err_unreg_notifier:
 	nf_conntrack_unregister_notifier(&ctnl_notifier);
 err_unreg_exp_subsys:
+	netlink_unregister_notifier(&nfct_rtnl_notifier);
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 #endif
 err_unreg_subsys:
Index: net-2.6.git/net/netfilter/xt_NFCONNTRACK.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ net-2.6.git/net/netfilter/xt_NFCONNTRACK.c	2008-02-22 19:33:35.000000000 +0100
@@ -0,0 +1,75 @@
+/* iptables module for using new netfilter netlink conntrack unicast events
+ *
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NFCONNTRACK.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("[ip,ip6]_tables NFCONNTRACK target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_NFCONNTRACK");
+MODULE_ALIAS("ip6t_NFCONNTRACK");
+
+static unsigned int
+nfct_tg(struct sk_buff *skb, const struct net_device *in,
+	const struct net_device *out, unsigned int hooknum,
+	const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_NFCT_info *tinfo = targinfo;
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return XT_CONTINUE;
+
+	/* ignore our fake conntrack entry */
+	if (ct == &nf_conntrack_untracked)
+		return XT_CONTINUE;
+
+	return nf_ct_send_uevent(ct, tinfo->queuenum);
+}
+
+static struct xt_target nfct_tg_reg[] __read_mostly = {
+	{
+		.name		= "NFCONNTRACK",
+		.family		= AF_INET,
+		.target		= nfct_tg,
+		.targetsize	= sizeof(struct xt_NFCT_info),
+		.table		= "events",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "NFCONNTRACK",
+		.family		= AF_INET6,
+		.target		= nfct_tg,
+		.targetsize	= sizeof(struct xt_NFCT_info),
+		.table		= "events",
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init nfct_tg_init(void)
+{
+	return xt_register_targets(nfct_tg_reg, ARRAY_SIZE(nfct_tg_reg));
+}
+
+static void __exit nfct_tg_exit(void)
+{
+	xt_unregister_targets(nfct_tg_reg, ARRAY_SIZE(nfct_tg_reg));
+}
+
+module_init(nfct_tg_init);
+module_exit(nfct_tg_exit);
Index: net-2.6.git/include/linux/netfilter_ipv4.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter_ipv4.h	2008-02-22 18:51:48.000000000 +0100
+++ net-2.6.git/include/linux/netfilter_ipv4.h	2008-02-22 18:53:39.000000000 +0100
@@ -62,9 +62,11 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_FILTER = 0,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
-	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
-	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
-	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
+	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 4,
+	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 3,
+	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
+	NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
+	NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,
 	NF_IP_PRI_LAST = INT_MAX,
 };
 
Index: net-2.6.git/net/ipv4/netfilter/Kconfig
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/Kconfig	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/Kconfig	2008-02-22 18:53:39.000000000 +0100
@@ -359,6 +359,18 @@ config IP_NF_RAW
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config IP_NF_EVENTS
+	tristate  'events table support (required for NFCONNTRACK)'
+	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a `events' table to iptables. This table is the very
+	  last in the netfilter framework and hooks in at the POSTROUTING
+	  chain.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
Index: net-2.6.git/net/ipv4/netfilter/Makefile
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/Makefile	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/Makefile	2008-02-22 18:53:39.000000000 +0100
@@ -39,6 +39,7 @@ obj-$(CONFIG_IP_NF_FILTER) += iptable_fi
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
 obj-$(CONFIG_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
+obj-$(CONFIG_IP_NF_EVENTS) += iptable_events.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
Index: net-2.6.git/net/netfilter/nf_conntrack_ecache.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_ecache.c	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_ecache.c	2008-02-22 19:03:12.000000000 +0100
@@ -42,7 +42,6 @@ __nf_ct_deliver_cached_events(struct nf_
 		atomic_notifier_call_chain(&nf_conntrack_chain, ecache->events,
 				    ecache->ct);
 
-	ecache->events = 0;
 	nf_ct_put(ecache->ct);
 	ecache->ct = NULL;
 }
@@ -72,6 +71,7 @@ void __nf_ct_event_cache_init(struct nf_
 	if (ecache->ct)
 		__nf_ct_deliver_cached_events(ecache);
 	/* initialize for this conntrack/packet */
+	ecache->events = 0;
 	ecache->ct = ct;
 	nf_conntrack_get(&ct->ct_general);
 }
@@ -91,6 +91,23 @@ void nf_ct_event_cache_flush(void)
 	}
 }
 
+int nf_ct_get_current_events(const struct nf_conn *ct, unsigned int *events)
+{
+	struct nf_conntrack_ecache *ecache;
+	int ret = 0;
+
+	local_bh_disable();
+	ecache = &__get_cpu_var(nf_conntrack_ecache);
+	if (ecache->ct == ct) {
+		ret = 1;
+		*events = ecache->events;
+	}
+	local_bh_enable();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_current_events);
+
 int nf_conntrack_register_notifier(struct notifier_block *nb)
 {
 	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
Index: net-2.6.git/include/net/netfilter/nf_conntrack_core.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack_core.h	2008-02-22 18:51:48.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack_core.h	2008-02-22 18:53:39.000000000 +0100
@@ -68,11 +68,9 @@ static inline int nf_conntrack_confirm(s
 	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 	int ret = NF_ACCEPT;
 
-	if (ct) {
-		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-			ret = __nf_conntrack_confirm(skb);
-		nf_ct_deliver_cached_events(ct);
-	}
+	if (ct && !nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+		ret = __nf_conntrack_confirm(skb);
+
 	return ret;
 }
 
Index: net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2008-02-22 19:12:03.000000000 +0100
@@ -183,6 +183,23 @@ static unsigned int ipv4_conntrack_local
 	return nf_conntrack_in(PF_INET, hooknum, skb);
 }
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+static unsigned int
+ipv4_conntrack_events(unsigned int hooknum,
+		      struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      int (*okfn)(struct sk_buff *))
+{
+	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
+
+	if (ct)
+		nf_ct_deliver_cached_events(ct);
+
+	return NF_ACCEPT;
+}
+#endif
+
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
 static struct nf_hook_ops ipv4_conntrack_ops[] __read_mostly = {
@@ -244,6 +261,16 @@ static struct nf_hook_ops ipv4_conntrack
 	},
 };
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+static struct nf_hook_ops ipv4_conntrack_events_op __read_mostly = {
+	.hook		= ipv4_conntrack_events,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_INET_POST_ROUTING,
+	.priority	= NF_IP_PRI_CONNTRACK_EVENTS,
+};
+#endif
+
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
@@ -463,6 +490,14 @@ static int __init nf_conntrack_l3proto_i
 		printk("nf_conntrack_ipv4: can't register hooks.\n");
 		goto cleanup_ipv4;
 	}
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	ret = nf_register_hook(&ipv4_conntrack_events_op);
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't register event hook.\n");
+		goto cleanup_events;
+	}
+#endif
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
 	ret = nf_conntrack_ipv4_compat_init();
 	if (ret < 0)
@@ -473,6 +508,10 @@ static int __init nf_conntrack_l3proto_i
  cleanup_hooks:
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 #endif
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+ cleanup_events:
+	nf_unregister_hook(&ipv4_conntrack_events_op);
+#endif
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
Index: net-2.6.git/net/ipv4/netfilter/iptable_events.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ net-2.6.git/net/ipv4/netfilter/iptable_events.c	2008-02-22 18:53:39.000000000 +0100
@@ -0,0 +1,94 @@
+/*
+ * 'event' table, which is the very last hooked in at POST_ROUTING.
+ *
+ * Copyright (C) 2008 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * Derived from 'raw' table.
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/ip.h>
+
+#define EVENT_VALID_HOOKS (1 << NF_INET_POST_ROUTING)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("iptables events table");
+
+static struct
+{
+	struct ipt_replace repl;
+	struct ipt_standard entries;
+	struct ipt_error term;
+} initial_table __initdata = {
+	.repl = {
+		.name = "events",
+		.valid_hooks = EVENT_VALID_HOOKS,
+		.num_entries = 2,
+		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
+		.hook_entry = {
+			[NF_INET_POST_ROUTING] = 0,
+		},
+		.underflow = {
+			[NF_INET_POST_ROUTING] = 0,
+		},
+	},
+	.entries = IPT_STANDARD_INIT(NF_ACCEPT),
+	.term = IPT_ERROR_INIT,
+};
+
+static struct xt_table packet_event = {
+	.name = "events",
+	.valid_hooks =  EVENT_VALID_HOOKS,
+	.lock = RW_LOCK_UNLOCKED,
+	.me = THIS_MODULE,
+	.af = AF_INET,
+};
+
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ipt_hook(unsigned int hook,
+	 struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	return ipt_do_table(skb, hook, in, out, &packet_event);
+}
+
+/* 'events' is the last table. */
+static struct nf_hook_ops ipt_ops __read_mostly = {
+	.hook = ipt_hook,
+	.pf = PF_INET,
+	.hooknum = NF_INET_POST_ROUTING,
+	.priority = NF_IP_PRI_EVENTS_TABLE,
+	.owner = THIS_MODULE,
+};
+
+static int __init iptable_event_init(void)
+{
+	int ret;
+
+	ret = ipt_register_table(&packet_event, &initial_table.repl);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_register_hook(&ipt_ops);
+	if (ret < 0)
+		goto cleanup_table;
+
+	return ret;
+
+ cleanup_table:
+	ipt_unregister_table(&packet_event);
+	return ret;
+}
+
+static void __exit iptable_event_fini(void)
+{
+	nf_unregister_hook(&ipt_ops);
+	ipt_unregister_table(&packet_event);
+}
+
+module_init(iptable_event_init);
+module_exit(iptable_event_fini);
Index: net-2.6.git/include/linux/netfilter/xt_NFCONNTRACK.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ net-2.6.git/include/linux/netfilter/xt_NFCONNTRACK.h	2008-02-22 18:53:39.000000000 +0100
@@ -0,0 +1,9 @@
+#ifndef _XT_NFCT_TARGET_H
+#define _XT_NFCT_TARGET_H
+
+/* target info */
+struct xt_NFCT_info {
+	u_int16_t queuenum;
+};
+
+#endif /* _XT_NFCT_TARGET_H */
Index: net-2.6.git/net/netfilter/Kconfig
===================================================================
--- net-2.6.git.orig/net/netfilter/Kconfig	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/netfilter/Kconfig	2008-02-22 19:32:51.000000000 +0100
@@ -348,6 +348,19 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_NFCONNTRACK
+	tristate '"NFCONNTRACK" target support'
+	depends on NETFILTER_XTABLES
+	depends on NF_CT_NETLINK
+	depends on NETFILTER_ADVANCED
+	help
+	  This option enables the NFCONNTRACK target, which allows to
+	  send connection tracking events messages through the netfilter
+	  netlink connection tracking API. It supports 65535 different
+	  queues.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_NFLOG
 	tristate '"NFLOG" target support'
 	depends on NETFILTER_XTABLES
Index: net-2.6.git/net/netfilter/Makefile
===================================================================
--- net-2.6.git.orig/net/netfilter/Makefile	2008-02-22 18:51:47.000000000 +0100
+++ net-2.6.git/net/netfilter/Makefile	2008-02-22 18:53:39.000000000 +0100
@@ -45,6 +45,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) +
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFCONNTRACK) += xt_NFCONNTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
Index: net-2.6.git/include/net/netfilter/nf_conntrack_ecache.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack_ecache.h	2008-02-22 19:19:46.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack_ecache.h	2008-02-22 19:33:18.000000000 +0100
@@ -26,6 +26,8 @@ extern int nf_conntrack_unregister_notif
 extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
 extern void __nf_ct_event_cache_init(struct nf_conn *ct);
 extern void nf_ct_event_cache_flush(void);
+extern int nf_ct_get_current_events(const struct nf_conn *ct,
+				    unsigned int *events);
 
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event,
@@ -70,6 +72,8 @@ static inline void nf_ct_deliver_cached_
 static inline void nf_ct_expect_event(enum ip_conntrack_expect_events event,
 				      struct nf_conntrack_expect *exp) {}
 static inline void nf_ct_event_cache_flush(void) {}
+static inline int nf_ct_get_current_events(const struct nf_conn *ct,
+					   unsigned int *events) {}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 #endif /*_NF_CONNTRACK_ECACHE_H*/

--------------070405060108020009050501--
