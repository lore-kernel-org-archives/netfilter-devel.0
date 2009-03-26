From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/5] net: netfilter conntrack - add per-net functionality for UDP protocol
Date: Thu, 26 Mar 2009 19:05:48 +0300
Message-ID: <20090326160712.292302955@openvz.org>
References: <20090326160544.519118777@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
To: kaber@trash.net, netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64898 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZCZQGh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:06:37 -0400
Received: by ewy9 with SMTP id 9so649787ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 09:06:34 -0700 (PDT)
Content-Disposition: inline; filename=net-nf-conntrack-proto-udp
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Module specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion. For this reason module_init/exit
calls added.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 net/netfilter/nf_conntrack_proto_udp.c |  152 ++++++++++++++++++++++++++++-----
 1 file changed, 130 insertions(+), 22 deletions(-)

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
@@ -25,8 +28,25 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
-static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
-static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
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
@@ -71,15 +91,17 @@ static int udp_packet(struct nf_conn *ct
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
@@ -137,19 +159,16 @@ static int udp_error(struct net *net, st
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
@@ -162,14 +181,12 @@ static struct ctl_table udp_sysctl_table
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
@@ -198,14 +215,7 @@ struct nf_conntrack_l4proto nf_conntrack
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
 
@@ -226,10 +236,108 @@ struct nf_conntrack_l4proto nf_conntrack
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
 #endif
+#endif
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
+int __init nf_ct_udp_proto_init(void)
+{
+	return register_pernet_gen_subsys(&udp_net_id, &udp_net_ops);
+}
+
+void __exit nf_ct_udp_proto_fini(void)
+{
+	unregister_pernet_gen_subsys(udp_net_id, &udp_net_ops);
+}
+
+module_init(nf_ct_udp_proto_init);
+module_exit(nf_ct_udp_proto_fini);
+MODULE_LICENSE("GPL");

