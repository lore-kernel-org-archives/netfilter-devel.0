From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 5/5] net: netfilter conntrack - add per-net functionality for UDPLITE protocol
Date: Sun, 29 Mar 2009 01:33:34 +0300
Message-ID: <20090328223857.258839851@openvz.org>
References: <20090328223329.377542393@openvz.org>
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr, Cyrill Gorcunov <gorcunov@openvz.org>
To: kaber@trash.net, adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35819 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZC1WiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:38:11 -0400
Received: by bwz17 with SMTP id 17so1444083bwz.37
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2009 15:38:07 -0700 (PDT)
Content-Disposition: inline; filename=net-nf-conntrack-proto-udplite
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Protocol specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 net/netfilter/nf_conntrack_proto_udplite.c |  115 ++++++++++++++++++++++++-----
 1 file changed, 96 insertions(+), 19 deletions(-)

Index: linux-2.6.git/net/netfilter/nf_conntrack_proto_udplite.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_proto_udplite.c
+++ linux-2.6.git/net/netfilter/nf_conntrack_proto_udplite.c
@@ -17,6 +17,9 @@
 #include <net/ip6_checksum.h>
 #include <net/checksum.h>
 
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -24,8 +27,21 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int nf_ct_udplite_timeout __read_mostly = 30*HZ;
-static unsigned int nf_ct_udplite_timeout_stream __read_mostly = 180*HZ;
+/* this module per-net specifics */
+static int udplite_net_id;
+struct udplite_net {
+	unsigned int udplite_timeout;
+	unsigned int udplite_timeout_stream;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+	struct ctl_table *sysctl_table;
+#endif
+};
+
+static inline struct udplite_net *udplite_pernet(struct net *net)
+{
+	return net_generic(net, udplite_net_id);
+}
 
 static bool udplite_pkt_to_tuple(const struct sk_buff *skb,
 				 unsigned int dataoff,
@@ -68,16 +84,18 @@ static int udplite_packet(struct nf_conn
 			  u_int8_t pf,
 			  unsigned int hooknum)
 {
+	struct udplite_net *un = udplite_pernet(nf_ct_net(ct));
+
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   nf_ct_udplite_timeout_stream);
+				   un->udplite_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_STATUS, ct);
 	} else
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udplite_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, un->udplite_timeout);
 
 	return NF_ACCEPT;
 }
@@ -142,13 +160,11 @@ static int udplite_error(struct net *net
 }
 
 #ifdef CONFIG_SYSCTL
-static unsigned int udplite_sysctl_table_users;
-static struct ctl_table_header *udplite_sysctl_header;
+/* template, data assigned later */
 static struct ctl_table udplite_sysctl_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nf_conntrack_udplite_timeout",
-		.data		= &nf_ct_udplite_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -156,7 +172,6 @@ static struct ctl_table udplite_sysctl_t
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nf_conntrack_udplite_timeout_stream",
-		.data		= &nf_ct_udplite_timeout_stream,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -184,11 +199,6 @@ static struct nf_conntrack_l4proto nf_co
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
-#ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &udplite_sysctl_table_users,
-	.ctl_table_header	= &udplite_sysctl_header,
-	.ctl_table		= udplite_sysctl_table,
-#endif
 };
 
 static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
@@ -207,26 +217,92 @@ static struct nf_conntrack_l4proto nf_co
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
+};
+
+static __net_init int udplite_net_init(struct net *net)
+{
+	struct udplite_net *un;
+	int err;
+
+	un = kmalloc(sizeof(*un), GFP_KERNEL);
+	if (!un)
+		return -ENOMEM;
+
+	/* default values */
+	un->udplite_timeout		= 30 * HZ;
+	un->udplite_timeout_stream	= 180 * HZ;
+
+	err = net_assign_generic(net, udplite_net_id, un);
+	if (err)
+		goto out;
+
+#ifdef CONFIG_SYSCTL
+	err = -ENOMEM;
+	un->sysctl_table = kmemdup(udplite_sysctl_table,
+			sizeof(udplite_sysctl_table), GFP_KERNEL);
+	if (!un->sysctl_table)
+		goto out;
+
+	un->sysctl_table[0].data = &un->udplite_timeout;
+	un->sysctl_table[1].data = &un->udplite_timeout_stream;
+
+	un->sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, un->sysctl_table);
+	if (!un->sysctl_header)
+		goto out_free;
+#endif /* CONFIG_SYSCTL */
+
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+out_free:
+	kfree(un->sysctl_table);
+#endif
+
+out:
+	kfree(un);
+	return err;
+}
+
+static __net_exit void udplite_net_exit(struct net *net)
+{
+	struct udplite_net *un = udplite_pernet(net);
 #ifdef CONFIG_SYSCTL
-	.ctl_table_users	= &udplite_sysctl_table_users,
-	.ctl_table_header	= &udplite_sysctl_header,
-	.ctl_table		= udplite_sysctl_table,
+	unregister_net_sysctl_table(un->sysctl_header);
+	kfree(un->sysctl_table);
 #endif
+	kfree(un);
+
+	net_assign_generic(net, udplite_net_id, NULL);
+}
+
+static struct pernet_operations udplite_net_ops = {
+	.init = udplite_net_init,
+	.exit = udplite_net_exit,
 };
 
 static int __init nf_conntrack_proto_udplite_init(void)
 {
 	int err;
 
-	err = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udplite4);
+	err = register_pernet_gen_subsys(&udplite_net_id, &udplite_net_ops);
 	if (err < 0)
 		goto err1;
-	err = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udplite6);
+
+	err = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udplite4);
 	if (err < 0)
 		goto err2;
+
+	err = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udplite6);
+	if (err < 0)
+		goto err3;
+
 	return 0;
-err2:
+
+err3:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udplite4);
+err2:
+	unregister_pernet_gen_subsys(udplite_net_id, &udplite_net_ops);
 err1:
 	return err;
 }
@@ -235,6 +311,7 @@ static void __exit nf_conntrack_proto_ud
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udplite6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_udplite4);
+	unregister_pernet_gen_subsys(udplite_net_id, &udplite_net_ops);
 }
 
 module_init(nf_conntrack_proto_udplite_init);

