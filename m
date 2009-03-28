From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/5] net: netfilter conntrack - add per-net functionality for UDP protocol
Date: Sun, 29 Mar 2009 01:33:33 +0300
Message-ID: <20090328223857.115414218@openvz.org>
References: <20090328223329.377542393@openvz.org>
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr, Cyrill Gorcunov <gorcunov@openvz.org>
To: kaber@trash.net, adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51733 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbZC1WiK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:38:10 -0400
Received: by bwz17 with SMTP id 17so1444085bwz.37
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2009 15:38:07 -0700 (PDT)
Content-Disposition: inline; filename=net-nf-conntrack-proto-udp
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Protocol specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    3 
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    3 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   11 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   11 +
 net/netfilter/nf_conntrack_proto_udp.c         |  163 +++++++++++++++++++++----
 5 files changed, 167 insertions(+), 24 deletions(-)

Index: linux-2.6.git/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
===================================================================
--- linux-2.6.git.orig/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ linux-2.6.git/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -27,4 +27,7 @@ extern void nf_ct_icmp_proto_fini(void);
 extern int nf_ct_tcp_proto_init(void);
 extern void nf_ct_tcp_proto_fini(void);
 
+extern int nf_ct_udp_proto_init(void);
+extern void nf_ct_udp_proto_fini(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
Index: linux-2.6.git/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
===================================================================
--- linux-2.6.git.orig/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ linux-2.6.git/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -23,4 +23,7 @@ extern struct ctl_table nf_ct_ipv6_sysct
 extern int nf_ct_tcp_proto_init(void);
 extern void nf_ct_tcp_proto_fini(void);
 
+extern int nf_ct_udp_proto_init(void);
+extern void nf_ct_udp_proto_fini(void);
+
 #endif /* _NF_CONNTRACK_IPV6_H*/
Index: linux-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ linux-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -395,10 +395,16 @@ static int __init nf_conntrack_l3proto_i
 		goto uninit_tcp;
 	}
 
+	ret = nf_ct_udp_proto_init();
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't initialize udp.\n");
+		goto cleanup_tcp;
+	}
+
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp4);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register udp.\n");
-		goto cleanup_tcp;
+		goto uninit_udp;
 	}
 
 	ret = nf_ct_icmp_proto_init();
@@ -443,6 +449,8 @@ static int __init nf_conntrack_l3proto_i
 	nf_ct_icmp_proto_fini();
  cleanup_udp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
+ uninit_udp:
+	nf_ct_udp_proto_fini();
  cleanup_tcp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
  uninit_tcp:
@@ -463,6 +471,7 @@ static void __exit nf_conntrack_l3proto_
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
 	nf_ct_icmp_proto_fini();
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp4);
+	nf_ct_udp_proto_fini();
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
 	nf_ct_tcp_proto_fini();
 	nf_unregister_sockopt(&so_getorigdst);
Index: linux-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
===================================================================
--- linux-2.6.git.orig/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ linux-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -397,10 +397,16 @@ static int __init nf_conntrack_l3proto_i
 		goto uninit_tcp;
 	}
 
+	ret = nf_ct_udp_proto_init();
+	if (ret < 0) {
+		printk("nf_conntrack_ipv6: can't initialize udp.\n");
+		goto cleanup_tcp;
+	}
+
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp6);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't register udp.\n");
-		goto cleanup_tcp;
+		goto uninit_udp;
 	}
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmpv6);
@@ -430,6 +436,8 @@ static int __init nf_conntrack_l3proto_i
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
  cleanup_udp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp6);
+ uninit_udp:
+	nf_ct_udp_proto_fini();
  cleanup_tcp:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
  uninit_tcp:
@@ -446,6 +454,7 @@ static void __exit nf_conntrack_l3proto_
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udp6);
+	nf_ct_udp_proto_fini();
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
 	nf_ct_tcp_proto_fini();
 	nf_ct_frag6_cleanup();
Index: linux-2.6.git/net/netfilter/nf_conntrack_proto_udp.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_proto_udp.c
+++ linux-2.6.git/net/netfilter/nf_conntrack_proto_udp.c
@@ -16,6 +16,9 @@
 #include <net/ip6_checksum.h>
 #include <net/checksum.h>
 
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -25,8 +28,28 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
-static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
-static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
+static DEFINE_MUTEX(proto_ref_lock);
+static int proto_ref;
+
+/* per-net specifics */
+static int udp_net_id;
+struct udp_net {
+	unsigned int udp_timeout;
+	unsigned int udp_timeout_stream;
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
+static inline struct udp_net *udp_pernet(struct net *net)
+{
+	return net_generic(net, udp_net_id);
+}
 
 static bool udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
@@ -71,15 +94,17 @@ static int udp_packet(struct nf_conn *ct
 		      u_int8_t pf,
 		      unsigned int hooknum)
 {
+	struct udp_net *un = udp_pernet(nf_ct_net(ct));
+
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout_stream);
+		nf_ct_refresh_acct(ct, ctinfo, skb, un->udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_STATUS, ct);
 	} else
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, un->udp_timeout);
 
 	return NF_ACCEPT;
 }
@@ -137,19 +162,16 @@ static int udp_error(struct net *net, st
 }
 
 #ifdef CONFIG_SYSCTL
-static unsigned int udp_sysctl_table_users;
-static struct ctl_table_header *udp_sysctl_header;
+/* templates, data assigned later */
 static struct ctl_table udp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_udp_timeout",
-		.data		= &nf_ct_udp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_udp_timeout_stream",
-		.data		= &nf_ct_udp_timeout_stream,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -162,14 +184,12 @@ static struct ctl_table udp_sysctl_table
 static struct ctl_table udp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_udp_timeout",
-		.data		= &nf_ct_udp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_udp_timeout_stream",
-		.data		= &nf_ct_udp_timeout_stream,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -198,14 +218,7 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &udp_sysctl_table_users,
-	.ctl_table_header	= &udp_sysctl_header,
-	.ctl_table		= udp_sysctl_table,
-#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table	= udp_compat_sysctl_table,
-#endif
-#endif
+	.me			= THIS_MODULE,
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
 
@@ -226,10 +239,116 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
+	.me			= THIS_MODULE,
+};
+EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);
+
+static __net_init int udp_net_init(struct net *net)
+{
+	struct udp_net *un;
+	int err;
+
+	un = kmalloc(sizeof(*un), GFP_KERNEL);
+	if (!un)
+		return -ENOMEM;
+
+	/* default values */
+	un->udp_timeout		= 30 * HZ;
+	un->udp_timeout_stream	= 180 * HZ;
+
+	err = net_assign_generic(net, udp_net_id, un);
+	if (err)
+		goto out;
+
+#ifdef CONFIG_SYSCTL
+	err = -ENOMEM;
+	un->sysctl_table = kmemdup(udp_sysctl_table,
+			sizeof(udp_sysctl_table), GFP_KERNEL);
+	if (!un->sysctl_table)
+		goto out;
+
+	un->sysctl_table[0].data = &un->udp_timeout;
+	un->sysctl_table[1].data = &un->udp_timeout_stream;
+
+	un->sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, un->sysctl_table);
+	if (!un->sysctl_header)
+		goto out_free;
+
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	un->compat_sysctl_table = kmemdup(udp_compat_sysctl_table,
+			sizeof(udp_compat_sysctl_table), GFP_KERNEL);
+	if (!un->compat_sysctl_table)
+		goto out_sysctl;
+
+	un->compat_sysctl_table[0].data = &un->udp_timeout;
+	un->compat_sysctl_table[1].data = &un->udp_timeout_stream;
+
+	un->compat_sysctl_header = register_net_sysctl_table(net,
+			nf_net_ipv4_netfilter_sysctl_path,
+			un->compat_sysctl_table);
+	if (!un->compat_sysctl_header)
+		goto out_free_compat;
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
+#endif /* CONFIG_SYSCTL */
+
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+out_free_compat:
+	kfree(un->compat_sysctl_table);
+#endif
+out_sysctl:
+	unregister_net_sysctl_table(un->sysctl_header);
+out_free:
+	kfree(un->sysctl_table);
+#endif
+
+out:
+	kfree(un);
+	return err;
+}
+
+static __net_exit void udp_net_exit(struct net *net)
+{
+	struct udp_net *un = udp_pernet(net);
 #ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &udp_sysctl_table_users,
-	.ctl_table_header	= &udp_sysctl_header,
-	.ctl_table		= udp_sysctl_table,
+	unregister_net_sysctl_table(un->sysctl_header);
+	kfree(un->sysctl_table);
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	unregister_net_sysctl_table(un->compat_sysctl_header);
+	kfree(un->compat_sysctl_table);
+#endif
 #endif
+	kfree(un);
+
+	net_assign_generic(net, udp_net_id, NULL);
+}
+
+static struct pernet_operations udp_net_ops = {
+	.init = udp_net_init,
+	.exit = udp_net_exit,
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);
+
+int nf_ct_udp_proto_init(void)
+{
+	int err = 0;
+
+	mutex_lock(&proto_ref_lock);
+	if (!proto_ref++)
+		err = register_pernet_gen_subsys(&udp_net_id, &udp_net_ops);
+	mutex_unlock(&proto_ref_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_ct_udp_proto_init);
+
+void nf_ct_udp_proto_fini(void)
+{
+	mutex_lock(&proto_ref_lock);
+	if (!--proto_ref)
+		unregister_pernet_gen_subsys(udp_net_id, &udp_net_ops);
+	mutex_unlock(&proto_ref_lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_udp_proto_fini);

