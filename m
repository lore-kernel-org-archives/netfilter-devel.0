From: Patrick McHardy <kaber@trash.net>
Subject: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 10:05:15 +0100
Message-ID: <4B5575CB.5050207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050501090909010701070006"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41452 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab0ASJFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:05:19 -0500
Received: from [192.168.0.100] (unknown [78.42.107.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 27F42B2C48
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2010 10:05:17 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050501090909010701070006
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

The attached two patches add a 'CT' target to specify parameters
used during conntrack creation. This can be used to manually attach
a helper to a connection. A couple of patches I'm still working
on will additionally use this for the "conntrack zones" classification.

I'm wondering if anyone has further ideas of parameters that might
make sense to support. We could for example move parameters like
sip_direct_signalling and sip_direct_media into the helper structure
and allow to set them dynamically for each connection. Or perhaps
selectively enable netlink events.

Any suggestions?

--------------050501090909010701070006
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 549db1232fad40206a2ab6e334f0a4359602be5e
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Jan 19 09:57:14 2010 +0100

    netfilter: xtables: add CT target
    
    Add a new target for the raw table, which can be used to specify conntrack
    parameters for specific connections, f.i. the conntrack helper.
    
    The target attaches a "template" connection tracking entry to the skb, which
    is used by the conntrack core when initializing the new conntrack.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index a374787..75f3150 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -72,6 +72,10 @@ enum ip_conntrack_status {
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Conntrack is a template */
+	IPS_TEMPLATE_BIT = 11,
+	IPS_TEMPLATE = (1 << IPS_TEMPLATE_BIT),
 };
 
 #ifdef __KERNEL__
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
new file mode 100644
index 0000000..70c3239
--- /dev/null
+++ b/include/linux/netfilter/xt_CT.h
@@ -0,0 +1,11 @@
+#ifndef _XT_CT_H
+#define _XT_CT_H
+
+struct xt_ct_target_info {
+	char		helper[16];
+
+	/* Used internally by the kernel */
+	struct nf_conn	*ct __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CT_H */
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d015de9..61cbc6d 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -42,12 +42,16 @@ struct nf_conntrack_helper {
 extern struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name);
 
+extern struct nf_conntrack_helper *
+nf_conntrack_helper_try_module_get(const char *name);
+
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
 extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
-extern int __nf_ct_try_assign_helper(struct nf_conn *ct, gfp_t flags);
+extern int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
+				     gfp_t flags);
 
 extern void nf_ct_helper_destroy(struct nf_conn *ct);
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 634d14a..2cd1415 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -341,6 +341,11 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_CT
+	tristate '"CT" target support'
+	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
+
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 49f62ee..f873644 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0e98c32..08a7c60 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -618,7 +618,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_free);
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct nf_conntrack_tuple_hash *
-init_conntrack(struct net *net,
+init_conntrack(struct net *net, struct nf_conn *tmpl,
 	       const struct nf_conntrack_tuple *tuple,
 	       struct nf_conntrack_l3proto *l3proto,
 	       struct nf_conntrack_l4proto *l4proto,
@@ -673,7 +673,7 @@ init_conntrack(struct net *net,
 		nf_conntrack_get(&ct->master->ct_general);
 		NF_CT_STAT_INC(net, expect_new);
 	} else {
-		__nf_ct_try_assign_helper(ct, GFP_ATOMIC);
+		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 		NF_CT_STAT_INC(net, new);
 	}
 
@@ -694,7 +694,7 @@ init_conntrack(struct net *net,
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
 static inline struct nf_conn *
-resolve_normal_ct(struct net *net,
+resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 		  struct sk_buff *skb,
 		  unsigned int dataoff,
 		  u_int16_t l3num,
@@ -718,7 +718,8 @@ resolve_normal_ct(struct net *net,
 	/* look for tuple match */
 	h = nf_conntrack_find_get(net, &tuple);
 	if (!h) {
-		h = init_conntrack(net, &tuple, l3proto, l4proto, skb, dataoff);
+		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
+				   skb, dataoff);
 		if (!h)
 			return NULL;
 		if (IS_ERR(h))
@@ -755,7 +756,7 @@ unsigned int
 nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		struct sk_buff *skb)
 {
-	struct nf_conn *ct;
+	struct nf_conn *ct, *tmpl = NULL;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_l4proto *l4proto;
@@ -764,10 +765,14 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	int set_reply = 0;
 	int ret;
 
-	/* Previously seen (loopback or untracked)?  Ignore. */
 	if (skb->nfct) {
-		NF_CT_STAT_INC_ATOMIC(net, ignore);
-		return NF_ACCEPT;
+		/* Previously seen (loopback or untracked)?  Ignore. */
+		tmpl = (struct nf_conn *)skb->nfct;
+		if (!test_bit(IPS_TEMPLATE_BIT, &tmpl->status)) {
+			NF_CT_STAT_INC_ATOMIC(net, ignore);
+			return NF_ACCEPT;
+		}
+		skb->nfct = NULL;
 	}
 
 	/* rcu_read_lock()ed by nf_hook_slow */
@@ -778,7 +783,8 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		pr_debug("not prepared to track yet or error occured\n");
 		NF_CT_STAT_INC_ATOMIC(net, error);
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
-		return -ret;
+		ret = -ret;
+		goto out;
 	}
 
 	l4proto = __nf_ct_l4proto_find(pf, protonum);
@@ -791,22 +797,25 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		if (ret <= 0) {
 			NF_CT_STAT_INC_ATOMIC(net, error);
 			NF_CT_STAT_INC_ATOMIC(net, invalid);
-			return -ret;
+			ret = -ret;
+			goto out;
 		}
 	}
 
-	ct = resolve_normal_ct(net, skb, dataoff, pf, protonum,
+	ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,
 			       l3proto, l4proto, &set_reply, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
-		return NF_ACCEPT;
+		ret = NF_ACCEPT;
+		goto out;
 	}
 
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
 		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return NF_DROP;
+		ret = NF_DROP;
+		goto out;
 	}
 
 	NF_CT_ASSERT(skb->nfct);
@@ -821,11 +830,15 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
 		if (ret == -NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(net, drop);
-		return -ret;
+		ret = -ret;
+		goto out;
 	}
 
 	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
 		nf_conntrack_event_cache(IPCT_STATUS, ct);
+out:
+	if (tmpl)
+		nf_ct_put(tmpl);
 
 	return ret;
 }
@@ -864,7 +877,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 		return;
 
 	rcu_read_lock();
-	__nf_ct_try_assign_helper(ct, GFP_ATOMIC);
+	__nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 65c2a7b..0424a64 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -81,6 +81,25 @@ __nf_conntrack_helper_find_byname(const char *name)
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find_byname);
 
+struct nf_conntrack_helper *
+nf_conntrack_helper_try_module_get(const char *name)
+{
+	struct nf_conntrack_helper *h;
+
+	h = __nf_conntrack_helper_find_byname(name);
+#ifdef CONFIG_MODULES
+	if (h == NULL) {
+		if (request_module("nfct-helper-%s", name) == 0)
+			h = __nf_conntrack_helper_find_byname(name);
+	}
+#endif
+	if (h != NULL && !try_module_get(h->me))
+		h = NULL;
+
+	return h;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
 	struct nf_conn_help *help;
@@ -94,13 +113,22 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
-int __nf_ct_try_assign_helper(struct nf_conn *ct, gfp_t flags)
+int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
+			      gfp_t flags)
 {
+	struct nf_conntrack_helper *helper = NULL;
+	struct nf_conn_help *help;
 	int ret = 0;
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help = nfct_help(ct);
 
-	helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	if (tmpl != NULL) {
+		help = nfct_help(tmpl);
+		if (help != NULL)
+			helper = help->helper;
+	}
+
+	help = nfct_help(ct);
+	if (helper == NULL)
+		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	if (helper == NULL) {
 		if (help)
 			rcu_assign_pointer(help->helper, NULL);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 79478df..8bc57c9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1244,7 +1244,7 @@ ctnetlink_create_conntrack(struct net *net,
 		}
 	} else {
 		/* try an implicit helper assignation */
-		err = __nf_ct_try_assign_helper(ct, GFP_ATOMIC);
+		err = __nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
 		if (err < 0)
 			goto err2;
 	}
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
new file mode 100644
index 0000000..115b23d
--- /dev/null
+++ b/net/netfilter/xt_CT.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (c) 2010 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/selinux.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_CT.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+
+static unsigned int xt_ct_target(struct sk_buff *skb,
+				 const struct xt_target_param *par)
+{
+	const struct xt_ct_target_info *info = par->targinfo;
+	struct nf_conn *ct = info->ct;
+
+	atomic_inc(&ct->ct_general.use);
+	skb->nfct = &ct->ct_general;
+	skb->nfctinfo = IP_CT_NEW;
+
+	return XT_CONTINUE;
+}
+
+static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
+{
+	struct xt_ct_target_info *info = par->targinfo;
+	struct nf_conntrack_tuple t;
+	struct nf_conn_help *help;
+	struct nf_conn *ct;
+
+	if (nf_ct_l3proto_try_module_get(par->family) < 0)
+		goto err1;
+
+	memset(&t, 0, sizeof(t));
+	ct = nf_conntrack_alloc(par->net, &t, &t, GFP_KERNEL);
+	if (IS_ERR(ct))
+		goto err2;
+
+	if (info->helper[0]) {
+		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		if (help == NULL)
+			goto err3;
+
+		help->helper = nf_conntrack_helper_try_module_get(info->helper);
+		if (help->helper == NULL)
+			goto err3;
+	}
+
+	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	info->ct = ct;
+	return true;
+
+err3:
+	nf_conntrack_free(ct);
+err2:
+	nf_ct_l3proto_module_put(par->family);
+err1:
+	return false;
+}
+
+static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	struct xt_ct_target_info *info = par->targinfo;
+	struct nf_conn *ct = info->ct;
+	struct nf_conn_help *help;
+
+	help = nfct_help(ct);
+	if (help)
+		module_put(help->helper->me);
+
+	nf_ct_l3proto_module_put(par->family);
+	nf_ct_put(info->ct);
+}
+
+static struct xt_target xt_ct_tg __read_mostly = {
+	.name		= "CT",
+	.family		= NFPROTO_UNSPEC,
+	.targetsize	= XT_ALIGN(sizeof(struct xt_ct_target_info)),
+	.checkentry	= xt_ct_tg_check,
+	.destroy	= xt_ct_tg_destroy,
+	.target		= xt_ct_target,
+	.table		= "raw",
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_ct_tg_init(void)
+{
+	return xt_register_target(&xt_ct_tg);
+}
+
+static void __exit xt_ct_tg_exit(void)
+{
+	return xt_unregister_target(&xt_ct_tg);
+}
+
+module_init(xt_ct_tg_init);
+module_exit(xt_ct_tg_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: connection tracking target");
+MODULE_ALIAS("ipt_CT");
+MODULE_ALIAS("ip6t_CT");

--------------050501090909010701070006
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 88f70e95fb12fb1ac629bd3342444d0972ca5441
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Jan 18 14:20:54 2010 +0100

    netfilter: add struct net * to target parameters
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 3caf5e1..91f14c4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -249,6 +249,7 @@ struct xt_target_param {
  * Other fields see above.
  */
 struct xt_tgchk_param {
+	struct net *net;
 	const char *table;
 	const void *entryinfo;
 	const struct xt_target *target;
@@ -259,6 +260,7 @@ struct xt_tgchk_param {
 
 /* Target destructor parameters */
 struct xt_tgdtor_param {
+	struct net *net;
 	const struct xt_target *target;
 	void *targinfo;
 	u_int8_t family;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1aa0e4c..12beb58 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -579,13 +579,14 @@ ebt_cleanup_match(struct ebt_entry_match *m, struct net *net, unsigned int *i)
 }
 
 static inline int
-ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
+ebt_cleanup_watcher(struct ebt_entry_watcher *w, struct net *net, unsigned int *i)
 {
 	struct xt_tgdtor_param par;
 
 	if (i && (*i)-- == 0)
 		return 1;
 
+	par.net      = net;
 	par.target   = w->u.watcher;
 	par.targinfo = w->data;
 	par.family   = NFPROTO_BRIDGE;
@@ -606,10 +607,11 @@ ebt_cleanup_entry(struct ebt_entry *e, struct net *net, unsigned int *cnt)
 	/* we're done */
 	if (cnt && (*cnt)-- == 0)
 		return 1;
-	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, NULL);
+	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, net, NULL);
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, net, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 
+	par.net      = net;
 	par.target   = t->u.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_BRIDGE;
@@ -674,7 +676,7 @@ ebt_check_entry(struct ebt_entry *e,
 	}
 	i = 0;
 
-	mtpar.net	= net;
+	mtpar.net	= tgpar.net       = net;
 	mtpar.table     = tgpar.table     = name;
 	mtpar.entryinfo = tgpar.entryinfo = e;
 	mtpar.hook_mask = tgpar.hook_mask = hookmask;
@@ -730,7 +732,7 @@ ebt_check_entry(struct ebt_entry *e,
 	(*cnt)++;
 	return 0;
 cleanup_watchers:
-	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, &j);
+	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, net, &j);
 cleanup_matches:
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, net, &i);
 	return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cfaba0e..7fde8f6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -638,10 +638,11 @@ err:
 	return ret;
 }
 
-static int check_target(struct ipt_entry *e, const char *name)
+static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 {
 	struct ipt_entry_target *t = ipt_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -697,7 +698,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 
@@ -788,6 +789,7 @@ cleanup_entry(struct ipt_entry *e, struct net *net, unsigned int *i)
 	IPT_MATCH_ITERATE(e, cleanup_match, net, NULL);
 	t = ipt_get_target(e);
 
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_IPV4;
@@ -1675,7 +1677,7 @@ compat_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto cleanup_matches;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9f1d45f..0376ed6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -669,10 +669,11 @@ err:
 	return ret;
 }
 
-static int check_target(struct ip6t_entry *e, const char *name)
+static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 {
 	struct ip6t_entry_target *t = ip6t_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -729,7 +730,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 
@@ -820,6 +821,7 @@ cleanup_entry(struct ip6t_entry *e, struct net *net, unsigned int *i)
 	IP6T_MATCH_ITERATE(e, cleanup_match, net, NULL);
 	t = ip6t_get_target(e);
 
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_IPV6;
@@ -1710,7 +1712,7 @@ static int compat_check_entry(struct ip6t_entry *e, struct net *net,
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto cleanup_matches;
 

--------------050501090909010701070006--
