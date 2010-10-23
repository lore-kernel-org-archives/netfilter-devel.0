From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
	extension
Date: Sat, 23 Oct 2010 19:23:59 +0200
Message-ID: <20101023172359.3336.21431.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab0JWRYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:24:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds flow-based timestamping for conntracks. This
conntrack extension is disabled by default. Basically, we use
two 64-bits variables to store the creation timestamp once the
conntrack has been confirmed and the other to store the deletion
time. This extension is disabled by default, to enable it, you
have to:

echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp

This patch allows to save memory for user-space flow-based
loogers such as ulogd2. In short, ulogd2 does not need to
keep a hashtable with the conntrack in user-space to know
when they were created and destroyed, instead we use the
kernel timestamp. If we want to have a sane IPFIX implementation
in user-space, this nanosecs resolution timestamps are also
useful. Other custom user-space applications can benefit from
this via libnetfilter_conntrack.

This patch does not modifies the /proc output to display
the start timestamping in nanosecs (which is not very useful).
We would need some generic functions similar to those in
xt_time to convert that output to local time in the kernel.
I think that ctnetlink is better for this, we pass the
timestamps in nanosecs and we call localtime() in the
user-space application. For that reason, I decided to only
modify the ctnetlink part (including dumping and event
notifications).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_conntrack.h |    9 ++
 include/net/netfilter/nf_conntrack_extend.h   |    2 
 include/net/netns/conntrack.h                 |    2 
 net/netfilter/Makefile                        |    2 
 net/netfilter/nf_conntrack_core.c             |   27 ++++++
 net/netfilter/nf_conntrack_netlink.c          |   42 +++++++++
 net/netfilter/nf_conntrack_timestamp.c        |  120 +++++++++++++++++++++++++
 7 files changed, 202 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_timestamp.c

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 455f0ce..e2d92c8 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -41,6 +41,7 @@ enum ctattr_type {
 	CTA_NAT_SEQ_ADJ_REPLY,
 	CTA_SECMARK,
 	CTA_ZONE,
+	CTA_TIMESTAMP,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -126,6 +127,14 @@ enum ctattr_counters {
 };
 #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
 
+enum ctattr_tstamp {
+	CTA_TIMESTAMP_UNSPEC,
+	CTA_TIMESTAMP_START,
+	CTA_TIMESTAMP_STOP,
+	__CTA_TIMESTAMP_MAX
+};
+#define CTA_TIMESTAMP_MAX (__CTA_TIMESTAMP_MAX - 1)
+
 enum ctattr_nat {
 	CTA_NAT_UNSPEC,
 	CTA_NAT_MINIP,
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 0772d29..057a0cd 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -11,6 +11,7 @@ enum nf_ct_ext_id {
 	NF_CT_EXT_ACCT,
 	NF_CT_EXT_ECACHE,
 	NF_CT_EXT_ZONE,
+	NF_CT_EXT_TSTAMP,
 	NF_CT_EXT_NUM,
 };
 
@@ -19,6 +20,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
 #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
 #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
+#define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index d4958d4..54d1e52 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -21,11 +21,13 @@ struct netns_ct {
 	int			sysctl_events;
 	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
+	int			sysctl_tstamp;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
+	struct ctl_table_header	*tstamp_sysctl_header;
 	struct ctl_table_header	*event_sysctl_header;
 #endif
 	int			hash_vmalloc;
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 441050f..70c7d24 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_tstamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index df3eedb..492b879 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -41,6 +41,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_tstamp.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_nat.h>
@@ -272,6 +273,11 @@ EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
+	struct nf_conn_tstamp *tstamp;
+
+	tstamp = nf_conn_tstamp_find(ct);
+	if (tstamp && tstamp->stop == 0)
+		tstamp->stop = ktime_to_ns(ktime_get_real());
 
 	if (!test_bit(IPS_DYING_BIT, &ct->status) &&
 	    unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
@@ -393,6 +399,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
+	struct nf_conn_tstamp *tstamp;
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
@@ -459,6 +466,15 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	atomic_inc(&ct->ct_general.use);
 	set_bit(IPS_CONFIRMED_BIT, &ct->status);
 
+	/* set conntrack timestamp, if enabled. */
+	tstamp = nf_conn_tstamp_find(ct);
+	if (tstamp) {
+		if (skb->tstamp.tv64 == 0)
+			__net_timestamp((struct sk_buff *)skb);
+
+		tstamp->start = ktime_to_ns(skb->tstamp);
+	}
+
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
 	 * guarantee that no other CPU can find the conntrack before the above
@@ -691,6 +707,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
 	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
@@ -1129,6 +1146,11 @@ struct __nf_ct_flush_report {
 static int kill_report(struct nf_conn *i, void *data)
 {
 	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
+	struct nf_conn_tstamp *tstamp;
+
+	tstamp = nf_conn_tstamp_find(i);
+	if (tstamp && tstamp->stop == 0)
+		tstamp->stop = ktime_to_ns(ktime_get_real());
 
 	/* If we fail to deliver the event, death_by_timeout() will retry */
 	if (nf_conntrack_event_report(IPCT_DESTROY, i,
@@ -1447,6 +1469,9 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_acct_init(net);
 	if (ret < 0)
 		goto err_acct;
+	ret = nf_conntrack_tstamp_init(net);
+	if (ret < 0)
+		goto err_tstamp;
 	ret = nf_conntrack_ecache_init(net);
 	if (ret < 0)
 		goto err_ecache;
@@ -1454,6 +1479,8 @@ static int nf_conntrack_init_net(struct net *net)
 	return 0;
 
 err_ecache:
+	nf_conntrack_tstamp_fini(net);
+err_tstamp:
 	nf_conntrack_acct_fini(net);
 err_acct:
 	nf_conntrack_expect_fini(net);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4b7989e..d8b50e9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -40,6 +40,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_tstamp.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
@@ -229,6 +230,33 @@ nla_put_failure:
 	return -1;
 }
 
+static int
+ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	struct nlattr *nest_count;
+	const struct nf_conn_tstamp *tstamp;
+
+	tstamp = nf_conn_tstamp_find(ct);
+	if (!tstamp)
+		return 0;
+
+	nest_count = nla_nest_start(skb, CTA_TIMESTAMP | NLA_F_NESTED);
+	if (!nest_count)
+		goto nla_put_failure;
+
+	NLA_PUT_BE64(skb, CTA_TIMESTAMP_START, cpu_to_be64(tstamp->start));
+	if (tstamp->stop != 0) {
+		NLA_PUT_BE64(skb, CTA_TIMESTAMP_STOP,
+			     cpu_to_be64(tstamp->stop));
+	}
+	nla_nest_end(skb, nest_count);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 #ifdef CONFIG_NF_CONNTRACK_MARK
 static inline int
 ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
@@ -388,6 +416,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
+	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
@@ -438,6 +467,14 @@ ctnetlink_counters_size(const struct nf_conn *ct)
 }
 
 static inline size_t
+ctnetlink_timestamp_size(const struct nf_conn *ct)
+{
+	if (!nf_ct_ext_exist(ct, NF_CT_EXT_TSTAMP))
+		return 0;
+	return nla_total_size(0) + 2 * nla_total_size(sizeof(uint64_t));
+}
+
+static inline size_t
 ctnetlink_nlmsg_size(const struct nf_conn *ct)
 {
 	return NLMSG_ALIGN(sizeof(struct nfgenmsg))
@@ -448,6 +485,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
 	       + ctnetlink_counters_size(ct)
+	       + ctnetlink_timestamp_size(ct)
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_TIMEOUT */
 	       + nla_total_size(0) /* CTA_PROTOINFO */
 	       + nla_total_size(0) /* CTA_HELP */
@@ -540,7 +578,8 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 
 	if (events & (1 << IPCT_DESTROY)) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
+		    ctnetlink_dump_timestamp(skb, ct) < 0)
 			goto nla_put_failure;
 	} else {
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
@@ -1329,6 +1368,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
new file mode 100644
index 0000000..51c8c28
--- /dev/null
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -0,0 +1,120 @@
+/*
+ * (C) 2010 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation (or any later at your option).
+ */
+
+#include <linux/netfilter.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_tstamp.h>
+
+static int nf_ct_tstamp __read_mostly;
+
+module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
+MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table tstamp_sysctl_table[] = {
+	{
+		.procname	= "nf_conntrack_timestamp",
+		.data		= &init_net.ct.sysctl_tstamp,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+#endif /* CONFIG_SYSCTL */
+
+static struct nf_ct_ext_type tstamp_extend __read_mostly = {
+	.len	= sizeof(struct nf_conn_tstamp),
+	.align	= __alignof__(struct nf_conn_tstamp),
+	.id	= NF_CT_EXT_TSTAMP,
+};
+
+#ifdef CONFIG_SYSCTL
+static int nf_conntrack_tstamp_init_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = kmemdup(tstamp_sysctl_table, sizeof(tstamp_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		goto out;
+
+	table[0].data = &net->ct.sysctl_tstamp;
+
+	net->ct.tstamp_sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, table);
+	if (!net->ct.tstamp_sysctl_header) {
+		printk(KERN_ERR "nf_ct_tstamp: can't register to sysctl.\n");
+		goto out_register;
+	}
+	return 0;
+
+out_register:
+	kfree(table);
+out:
+	return -ENOMEM;
+}
+
+static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = net->ct.tstamp_sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->ct.tstamp_sysctl_header);
+	kfree(table);
+}
+#else
+static int nf_conntrack_tstamp_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
+{
+}
+#endif
+
+int nf_conntrack_tstamp_init(struct net *net)
+{
+	int ret;
+
+	net->ct.sysctl_tstamp = nf_ct_tstamp;
+
+	if (net_eq(net, &init_net)) {
+		ret = nf_ct_extend_register(&tstamp_extend);
+		if (ret < 0) {
+			printk(KERN_ERR "nf_ct_tstamp: Unable to register "
+					"extension\n");
+			goto out_extend_register;
+		}
+	}
+
+	ret = nf_conntrack_tstamp_init_sysctl(net);
+	if (ret < 0)
+		goto out_sysctl;
+
+	return 0;
+
+out_sysctl:
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&tstamp_extend);
+out_extend_register:
+	return ret;
+}
+
+void nf_conntrack_tstamp_fini(struct net *net)
+{
+	nf_conntrack_tstamp_fini_sysctl(net);
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&tstamp_extend);
+}

