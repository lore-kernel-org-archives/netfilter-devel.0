From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/5] net: netfilter conntrack - add per-net functionality for ICMP protocol
Date: Sun, 29 Mar 2009 01:33:30 +0300
Message-ID: <20090328223856.687147676@openvz.org>
References: <20090328223329.377542393@openvz.org>
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr, Cyrill Gorcunov <gorcunov@openvz.org>
To: kaber@trash.net, adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:51882 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbZC1WiN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:38:13 -0400
Received: by fk-out-0910.google.com with SMTP id 18so654085fkq.5
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2009 15:38:10 -0700 (PDT)
Content-Disposition: inline; filename=net-nf-conntrack-proto-icmp
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Protocol specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    3 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   11 ++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  125 +++++++++++++++++++++++--
 3 files changed, 130 insertions(+), 9 deletions(-)

Index: linux-2.6.git/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
===================================================================
--- linux-2.6.git.orig/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ linux-2.6.git/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -21,4 +21,7 @@ extern void nf_conntrack_ipv4_compat_fin
 
 extern void need_ipv4_conntrack(void);
 
+extern int nf_ct_icmp_proto_init(void);
+extern void nf_ct_icmp_proto_fini(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
Index: linux-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ linux-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -395,10 +395,16 @@ static int __init nf_conntrack_l3proto_i
 		goto cleanup_tcp;
 	}
 
+	ret = nf_ct_icmp_proto_init();
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't initialize icmp\n");
+		goto cleanup_udp;
+	}
+
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmp);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register icmp.\n");
-		goto cleanup_udp;
+		goto uninit_icmp;
 	}
 
 	ret = nf_conntrack_l3proto_register(&nf_conntrack_l3proto_ipv4);
@@ -427,6 +433,8 @@ static int __init nf_conntrack_l3proto_i
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
+ uninit_icmp:
+	nf_ct_icmp_proto_fini();
  cleanup_udp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
  cleanup_tcp:
@@ -445,6 +453,7 @@ static void __exit nf_conntrack_l3proto_
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
+	nf_ct_icmp_proto_fini();
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
 	nf_unregister_sockopt(&so_getorigdst);
Index: linux-2.6.git/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ linux-2.6.git/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -20,7 +20,27 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int nf_ct_icmp_timeout __read_mostly = 30*HZ;
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+/* per-net specifics */
+static int icmp_net_id;
+struct icmp_net {
+	unsigned int icmp_timeout;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+	struct ctl_table *sysctl_table;
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	struct ctl_table_header *compat_sysctl_header;
+	struct ctl_table *compat_sysctl_table;
+#endif
+#endif
+};
+
+static inline struct icmp_net *icmp_pernet(struct net *net)
+{
+	return net_generic(net, icmp_net_id);
+}
 
 static bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			      struct nf_conntrack_tuple *tuple)
@@ -90,9 +110,10 @@ static int icmp_packet(struct nf_conn *c
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
 			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
+		struct icmp_net *in = icmp_pernet(nf_ct_net(ct));
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, in->icmp_timeout);
 	}
 
 	return NF_ACCEPT;
@@ -270,11 +291,10 @@ static int icmp_nlattr_tuple_size(void)
 #endif
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_table_header *icmp_sysctl_header;
+/* templates, data assigned later */
 static struct ctl_table icmp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_icmp_timeout",
-		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -287,7 +307,6 @@ static struct ctl_table icmp_sysctl_tabl
 static struct ctl_table icmp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_icmp_timeout",
-		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -318,11 +337,101 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
 	.nla_policy		= icmp_nla_policy,
 #endif
+};
+
+static __net_init int icmp_net_init(struct net *net)
+{
+	struct icmp_net *in;
+	int err;
+
+	in = kmalloc(sizeof(*in), GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	/* default values */
+	in->icmp_timeout = 30 * HZ;
+
+	err = net_assign_generic(net, icmp_net_id, in);
+	if (err)
+		goto out;
+
 #ifdef CONFIG_SYSCTL
-	.ctl_table_header	= &icmp_sysctl_header,
-	.ctl_table		= icmp_sysctl_table,
+	err = -ENOMEM;
+	in->sysctl_table = kmemdup(icmp_sysctl_table,
+			sizeof(icmp_sysctl_table), GFP_KERNEL);
+	if (!in->sysctl_table)
+		goto out;
+
+	in->sysctl_table[0].data = &in->icmp_timeout;
+
+	in->sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, in->sysctl_table);
+	if (!in->sysctl_header)
+		goto out_free;
+
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table	= icmp_compat_sysctl_table,
+	in->compat_sysctl_table = kmemdup(icmp_compat_sysctl_table,
+			sizeof(icmp_compat_sysctl_table), GFP_KERNEL);
+	if (!in->compat_sysctl_table)
+		goto out_sysctl;
+
+	in->compat_sysctl_table[0].data = &in->icmp_timeout;
+
+	in->compat_sysctl_header = register_net_sysctl_table(net,
+			nf_net_ipv4_netfilter_sysctl_path,
+			in->compat_sysctl_table);
+	if (!in->compat_sysctl_header)
+		goto out_free_compat;
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
+#endif /* CONFIG_SYSCTL */
+
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+out_free_compat:
+	kfree(in->compat_sysctl_table);
+#endif
+out_sysctl:
+	unregister_net_sysctl_table(in->sysctl_header);
+out_free:
+	kfree(in->sysctl_table);
+#endif
+
+out:
+	kfree(in);
+	return err;
+}
+
+static __net_exit void icmp_net_exit(struct net *net)
+{
+	struct icmp_net *in = icmp_pernet(net);
+#ifdef CONFIG_SYSCTL
+	unregister_net_sysctl_table(in->sysctl_header);
+	kfree(in->sysctl_table);
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	unregister_net_sysctl_table(in->compat_sysctl_header);
+	kfree(in->compat_sysctl_table);
 #endif
 #endif
+	kfree(in);
+
+	net_assign_generic(net, icmp_net_id, NULL);
+}
+
+static struct pernet_operations icmp_net_ops = {
+	.init = icmp_net_init,
+	.exit = icmp_net_exit,
 };
+
+int nf_ct_icmp_proto_init(void)
+{
+	return register_pernet_gen_subsys(&icmp_net_id, &icmp_net_ops);
+}
+EXPORT_SYMBOL_GPL(nf_ct_icmp_proto_init);
+
+void nf_ct_icmp_proto_fini(void)
+{
+	unregister_pernet_gen_subsys(icmp_net_id, &icmp_net_ops);
+}
+EXPORT_SYMBOL_GPL(nf_ct_icmp_proto_fini);

