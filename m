From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/33]: nf_conntrack: move conntrack protocol sysctls to
	individual modules
Date: Wed, 29 Nov 2006 03:09:06 +0100 (MET)
Message-ID: <20061129020906.21082.35693.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: move conntrack protocol sysctls to individual modules

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcd8d5a98d1a3c257d15c1cfa038aa0bf0e0ea44
tree 70a66b6930977099d64304a8ae13b12d5d3e6336
parent d8467cb91235e63cf7d36cdea1e6336a4df217bd
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:22 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:13:32 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   53 ---------
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   23 ++++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   55 +--------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   23 ++++
 net/netfilter/nf_conntrack_core.c              |    8 +
 net/netfilter/nf_conntrack_proto.c             |   12 ++
 net/netfilter/nf_conntrack_proto_generic.c     |   23 ++++
 net/netfilter/nf_conntrack_proto_sctp.c        |  101 ++++++-----------
 net/netfilter/nf_conntrack_proto_tcp.c         |  140 ++++++++++++++++++++++--
 net/netfilter/nf_conntrack_proto_udp.c         |   40 ++++++-
 net/netfilter/nf_conntrack_standalone.c        |  142 ------------------------
 11 files changed, 293 insertions(+), 327 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index d190708..786c4ce 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -266,44 +266,6 @@ static struct nf_hook_ops ipv4_conntrack
 	},
 };
 
-#ifdef CONFIG_SYSCTL
-/* From nf_conntrack_proto_icmp.c */
-extern unsigned int nf_ct_icmp_timeout;
-static struct ctl_table_header *nf_ct_ipv4_sysctl_header;
-
-static ctl_table nf_ct_sysctl_table[] = {
-	{
-		.ctl_name	= NET_NF_CONNTRACK_ICMP_TIMEOUT,
-		.procname	= "nf_conntrack_icmp_timeout",
-		.data		= &nf_ct_icmp_timeout,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-        { .ctl_name = 0 }
-};
-
-static ctl_table nf_ct_netfilter_table[] = {
-	{
-		.ctl_name       = NET_NETFILTER,
-		.procname       = "netfilter",
-		.mode           = 0555,
-		.child          = nf_ct_sysctl_table,
-	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table nf_ct_net_table[] = {
-	{
-		.ctl_name       = CTL_NET,
-		.procname       = "net",
-		.mode           = 0555,
-		.child          = nf_ct_netfilter_table,
-	},
-	{ .ctl_name = 0 }
-};
-#endif
-
 /* Fast function for those who don't want to parse /proc (and I don't
    blame them). */
 /* Reversing the socket's dst/src point of view gives us the reply
@@ -472,20 +434,8 @@ static int __init nf_conntrack_l3proto_i
 		printk("nf_conntrack_ipv4: can't register hooks.\n");
 		goto cleanup_ipv4;
 	}
-#ifdef CONFIG_SYSCTL
-	nf_ct_ipv4_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
-	if (nf_ct_ipv4_sysctl_header == NULL) {
-		printk("nf_conntrack: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		goto cleanup_hooks;
-	}
-#endif
 	return ret;
 
-#ifdef CONFIG_SYSCTL
- cleanup_hooks:
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
-#endif
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
@@ -502,9 +452,6 @@ #endif
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
 	synchronize_net();
-#ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
-#endif
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 95fc22b..c59f281 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -25,7 +25,7 @@ #include <net/netfilter/nf_conntrack_tup
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
+static unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
 
 #if 0
 #define DEBUGP printk
@@ -321,6 +321,23 @@ static int icmp_nfattr_to_tuple(struct n
 }
 #endif
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *icmp_sysctl_header;
+static struct ctl_table icmp_sysctl_table[] = {
+	{
+		.ctl_name	= NET_NF_CONNTRACK_ICMP_TIMEOUT,
+		.procname	= "nf_conntrack_icmp_timeout",
+		.data		= &nf_ct_icmp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+        {
+		.ctl_name = 0
+	}
+};
+#endif /* CONFIG_SYSCTL */
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.l3proto		= PF_INET,
@@ -340,6 +357,10 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= icmp_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmp_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_header	= &icmp_sysctl_header,
+	.ctl_table		= icmp_sysctl_table,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_l4proto_icmp);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 9108ecc..a20615f 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -324,21 +324,7 @@ static struct nf_hook_ops ipv6_conntrack
 };
 
 #ifdef CONFIG_SYSCTL
-
-/* From nf_conntrack_proto_icmpv6.c */
-extern unsigned int nf_ct_icmpv6_timeout;
-
-static struct ctl_table_header *nf_ct_ipv6_sysctl_header;
-
-static ctl_table nf_ct_sysctl_table[] = {
-	{
-		.ctl_name	= NET_NF_CONNTRACK_ICMPV6_TIMEOUT,
-		.procname	= "nf_conntrack_icmpv6_timeout",
-		.data		= &nf_ct_icmpv6_timeout,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
+static ctl_table nf_ct_ipv6_sysctl_table[] = {
 	{
 		.ctl_name	= NET_NF_CONNTRACK_FRAG6_TIMEOUT,
 		.procname	= "nf_conntrack_frag6_timeout",
@@ -365,26 +351,6 @@ static ctl_table nf_ct_sysctl_table[] = 
 	},
         { .ctl_name = 0 }
 };
-
-static ctl_table nf_ct_netfilter_table[] = {
-	{
-		.ctl_name	= NET_NETFILTER,
-		.procname	= "netfilter",
-		.mode		= 0555,
-		.child		= nf_ct_sysctl_table,
-	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table nf_ct_net_table[] = {
-	{
-		.ctl_name	= CTL_NET,
-		.procname	= "net",
-		.mode		= 0555,
-		.child		= nf_ct_netfilter_table,
-	},
-	{ .ctl_name = 0 }
-};
 #endif
 
 #if defined(CONFIG_NF_CT_NETLINK) || \
@@ -442,6 +408,10 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= ipv6_tuple_to_nfattr,
 	.nfattr_to_tuple	= ipv6_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_path		= nf_net_netfilter_sysctl_path,
+	.ctl_table		= nf_ct_ipv6_sysctl_table,
+#endif
 	.get_features		= ipv6_get_features,
 	.me			= THIS_MODULE,
 };
@@ -492,20 +462,8 @@ static int __init nf_conntrack_l3proto_i
 		       "hook.\n");
 		goto cleanup_ipv6;
 	}
-#ifdef CONFIG_SYSCTL
-	nf_ct_ipv6_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
-	if (nf_ct_ipv6_sysctl_header == NULL) {
-		printk("nf_conntrack: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		goto cleanup_hooks;
-	}
-#endif
 	return ret;
 
-#ifdef CONFIG_SYSCTL
- cleanup_hooks:
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
-#endif
  cleanup_ipv6:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
  cleanup_icmpv6:
@@ -522,9 +480,6 @@ #endif
 static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 {
 	synchronize_net();
-#ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_ipv6_sysctl_header);
-#endif
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index b3b468c..1e8e700 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -33,7 +33,7 @@ #include <net/netfilter/nf_conntrack_l4p
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
-unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
+static unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
 
 #if 0
 #define DEBUGP printk
@@ -298,6 +298,23 @@ static int icmpv6_nfattr_to_tuple(struct
 }
 #endif
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *icmpv6_sysctl_header;
+static struct ctl_table icmpv6_sysctl_table[] = {
+	{
+		.ctl_name	= NET_NF_CONNTRACK_ICMPV6_TIMEOUT,
+		.procname	= "nf_conntrack_icmpv6_timeout",
+		.data		= &nf_ct_icmpv6_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_SYSCTL */
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l3proto		= PF_INET6,
@@ -315,6 +332,10 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= icmpv6_tuple_to_nfattr,
 	.nfattr_to_tuple	= icmpv6_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_header	= &icmpv6_sysctl_header,
+	.ctl_table		= icmpv6_sysctl_table,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_l4proto_icmpv6);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3e7c0a9..4b97279 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1070,6 +1070,8 @@ void nf_conntrack_cleanup(void)
 	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
 			    nf_conntrack_htable_size);
 
+	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_generic);
+
 	/* free l3proto protocol tables */
 	for (i = 0; i < PF_MAX; i++)
 		if (nf_ct_protos[i]) {
@@ -1195,6 +1197,10 @@ int __init nf_conntrack_init(void)
 		goto err_free_conntrack_slab;
 	}
 
+	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_generic);
+	if (ret < 0)
+		goto out_free_expect_slab;
+
 	/* Don't NEED lock here, but good form anyway. */
 	write_lock_bh(&nf_conntrack_lock);
         for (i = 0; i < AF_MAX; i++)
@@ -1212,6 +1218,8 @@ int __init nf_conntrack_init(void)
 
 	return ret;
 
+out_free_expect_slab:
+	kmem_cache_destroy(nf_conntrack_expect_cachep);
 err_free_conntrack_slab:
 	nf_conntrack_unregister_cache(NF_CT_F_BASIC);
 err_free_hash:
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 941b5c3..891c9c5 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -252,7 +252,7 @@ #ifdef CONFIG_SYSCTL
 					    l4proto->ctl_table_users);
 	}
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
-#endif
+#endif /* CONFIG_SYSCTL */
 	return err;
 }
 
@@ -266,7 +266,7 @@ #ifdef CONFIG_SYSCTL
 					l4proto->ctl_table,
 					l4proto->ctl_table_users);
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
-#endif
+#endif /* CONFIG_SYSCTL */
 }
 
 /* FIXME: Allow NULL functions and sub in pointers to generic for
@@ -280,6 +280,9 @@ int nf_conntrack_l4proto_register(struct
 		goto out;
 	}
 
+	if (l4proto == &nf_conntrack_l4proto_generic)
+		return nf_ct_l4proto_register_sysctl(l4proto);
+
 retry:
 	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_protos[l4proto->l3proto]) {
@@ -346,6 +349,11 @@ int nf_conntrack_l4proto_unregister(stru
 		goto out;
 	}
 
+	if (l4proto == &nf_conntrack_l4proto_generic) {
+		nf_ct_l4proto_unregister_sysctl(l4proto);
+		goto out;
+	}
+
 	write_lock_bh(&nf_conntrack_lock);
 	if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto]
 	    != l4proto) {
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index f44811e..15306b9 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -17,7 +17,7 @@ #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
+static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 
 static int generic_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
@@ -71,6 +71,23 @@ static int new(struct nf_conn *conntrack
 	return 1;
 }
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *generic_sysctl_header;
+static struct ctl_table generic_sysctl_table[] = {
+	{
+		.ctl_name	= NET_NF_CONNTRACK_GENERIC_TIMEOUT,
+		.procname	= "nf_conntrack_generic_timeout",
+		.data		= &nf_ct_generic_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_SYSCTL */
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l3proto		= PF_UNSPEC,
@@ -82,4 +99,8 @@ struct nf_conntrack_l4proto nf_conntrack
 	.print_conntrack	= generic_print_conntrack,
 	.packet			= packet,
 	.new			= new,
+#ifdef CONFIG_SYSCTL
+	.ctl_table_header	= &generic_sysctl_header,
+	.ctl_table		= generic_sysctl_table,
+#endif
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5115619..cc69330 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -509,36 +509,10 @@ static int sctp_new(struct nf_conn *conn
 	return 1;
 }
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
-	.l3proto	 = PF_INET,
-	.l4proto 	 = IPPROTO_SCTP,
-	.name 		 = "sctp",
-	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
-	.invert_tuple 	 = sctp_invert_tuple, 
-	.print_tuple 	 = sctp_print_tuple, 
-	.print_conntrack = sctp_print_conntrack,
-	.packet 	 = sctp_packet, 
-	.new 		 = sctp_new, 
-	.destroy 	 = NULL, 
-	.me 		 = THIS_MODULE 
-};
-
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
-	.l3proto	 = PF_INET6,
-	.l4proto 	 = IPPROTO_SCTP,
-	.name 		 = "sctp",
-	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
-	.invert_tuple 	 = sctp_invert_tuple, 
-	.print_tuple 	 = sctp_print_tuple, 
-	.print_conntrack = sctp_print_conntrack,
-	.packet 	 = sctp_packet, 
-	.new 		 = sctp_new, 
-	.destroy 	 = NULL, 
-	.me 		 = THIS_MODULE 
-};
-
 #ifdef CONFIG_SYSCTL
-static ctl_table nf_ct_sysctl_table[] = {
+static unsigned int sctp_sysctl_table_users;
+static struct ctl_table_header *sctp_sysctl_header;
+static struct ctl_table sctp_sysctl_table[] = {
 	{
 		.ctl_name	= NET_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
 		.procname	= "nf_conntrack_sctp_timeout_closed",
@@ -595,31 +569,47 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table nf_ct_netfilter_table[] = {
 	{
-		.ctl_name	= NET_NETFILTER,
-		.procname	= "netfilter",
-		.mode		= 0555,
-		.child		= nf_ct_sysctl_table,
-	},
-	{ .ctl_name = 0 }
+		.ctl_name = 0
+	}
 };
+#endif
 
-static ctl_table nf_ct_net_table[] = {
-	{
-		.ctl_name	= CTL_NET,
-		.procname	= "net",
-		.mode		= 0555, 
-		.child		= nf_ct_netfilter_table,
-	},
-	{ .ctl_name = 0 }
+struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
+	.l3proto		= PF_INET,
+	.l4proto 		= IPPROTO_SCTP,
+	.name 			= "sctp",
+	.pkt_to_tuple 		= sctp_pkt_to_tuple,
+	.invert_tuple 		= sctp_invert_tuple,
+	.print_tuple 		= sctp_print_tuple,
+	.print_conntrack	= sctp_print_conntrack,
+	.packet 		= sctp_packet,
+	.new 			= sctp_new,
+	.me 			= THIS_MODULE,
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &sctp_sysctl_table_users,
+	.ctl_table_header	= &sctp_sysctl_header,
+	.ctl_table		= sctp_sysctl_table,
+#endif
 };
 
-static struct ctl_table_header *nf_ct_sysctl_header;
+struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
+	.l3proto		= PF_INET6,
+	.l4proto 		= IPPROTO_SCTP,
+	.name 			= "sctp",
+	.pkt_to_tuple 		= sctp_pkt_to_tuple,
+	.invert_tuple 		= sctp_invert_tuple,
+	.print_tuple 		= sctp_print_tuple,
+	.print_conntrack	= sctp_print_conntrack,
+	.packet 		= sctp_packet,
+	.new 			= sctp_new,
+	.me 			= THIS_MODULE,
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &sctp_sysctl_table_users,
+	.ctl_table_header	= &sctp_sysctl_header,
+	.ctl_table		= sctp_sysctl_table,
 #endif
+};
 
 int __init nf_conntrack_proto_sctp_init(void)
 {
@@ -636,20 +626,8 @@ int __init nf_conntrack_proto_sctp_init(
 		goto cleanup_sctp4;
 	}
 
-#ifdef CONFIG_SYSCTL
-	nf_ct_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
-	if (nf_ct_sysctl_header == NULL) {
-		printk("nf_conntrack_proto_sctp: can't register to sysctl.\n");
-		goto cleanup;
-	}
-#endif
-
 	return ret;
 
-#ifdef CONFIG_SYSCTL
- cleanup:
-	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
-#endif
  cleanup_sctp4:
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
  out:
@@ -662,9 +640,6 @@ void __exit nf_conntrack_proto_sctp_fini
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
-#ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_sysctl_header);
-#endif
 	DEBUGP("SCTP conntrack module unloaded\n");
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 32b88b7..6f6f9a0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -93,22 +93,22 @@ #define MINS * 60 SECS
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-unsigned int nf_ct_tcp_timeout_syn_sent __read_mostly =      2 MINS;
-unsigned int nf_ct_tcp_timeout_syn_recv __read_mostly =     60 SECS;
-unsigned int nf_ct_tcp_timeout_established __read_mostly =   5 DAYS;
-unsigned int nf_ct_tcp_timeout_fin_wait __read_mostly =      2 MINS;
-unsigned int nf_ct_tcp_timeout_close_wait __read_mostly =   60 SECS;
-unsigned int nf_ct_tcp_timeout_last_ack __read_mostly =     30 SECS;
-unsigned int nf_ct_tcp_timeout_time_wait __read_mostly =     2 MINS;
-unsigned int nf_ct_tcp_timeout_close __read_mostly =        10 SECS;
+static unsigned int nf_ct_tcp_timeout_syn_sent __read_mostly =      2 MINS;
+static unsigned int nf_ct_tcp_timeout_syn_recv __read_mostly =     60 SECS;
+static unsigned int nf_ct_tcp_timeout_established __read_mostly =   5 DAYS;
+static unsigned int nf_ct_tcp_timeout_fin_wait __read_mostly =      2 MINS;
+static unsigned int nf_ct_tcp_timeout_close_wait __read_mostly =   60 SECS;
+static unsigned int nf_ct_tcp_timeout_last_ack __read_mostly =     30 SECS;
+static unsigned int nf_ct_tcp_timeout_time_wait __read_mostly =     2 MINS;
+static unsigned int nf_ct_tcp_timeout_close __read_mostly =        10 SECS;
 
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds 
    to ~13-30min depending on RTO. */
-unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
+static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
  
-static unsigned int * tcp_timeouts[]
-= { NULL,                              /* TCP_CONNTRACK_NONE */
+static unsigned int * tcp_timeouts[] = {
+    NULL,                              /* TCP_CONNTRACK_NONE */
     &nf_ct_tcp_timeout_syn_sent,       /* TCP_CONNTRACK_SYN_SENT, */
     &nf_ct_tcp_timeout_syn_recv,       /* TCP_CONNTRACK_SYN_RECV, */
     &nf_ct_tcp_timeout_established,    /* TCP_CONNTRACK_ESTABLISHED, */
@@ -1168,7 +1168,113 @@ static int nfattr_to_tcp(struct nfattr *
 	return 0;
 }
 #endif
-  
+
+#ifdef CONFIG_SYSCTL
+static unsigned int tcp_sysctl_table_users;
+static struct ctl_table_header *tcp_sysctl_header;
+static struct ctl_table tcp_sysctl_table[] = {
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
+		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
+		.data		= &nf_ct_tcp_timeout_syn_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
+		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
+		.data		= &nf_ct_tcp_timeout_syn_recv,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
+		.procname	= "nf_conntrack_tcp_timeout_established",
+		.data		= &nf_ct_tcp_timeout_established,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
+		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
+		.data		= &nf_ct_tcp_timeout_fin_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
+		.procname	= "nf_conntrack_tcp_timeout_close_wait",
+		.data		= &nf_ct_tcp_timeout_close_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
+		.procname	= "nf_conntrack_tcp_timeout_last_ack",
+		.data		= &nf_ct_tcp_timeout_last_ack,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
+		.procname	= "nf_conntrack_tcp_timeout_time_wait",
+		.data		= &nf_ct_tcp_timeout_time_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
+		.procname	= "nf_conntrack_tcp_timeout_close",
+		.data		= &nf_ct_tcp_timeout_close,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
+		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
+		.data		= &nf_ct_tcp_timeout_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_LOOSE,
+		.procname	= "nf_conntrack_tcp_loose",
+		.data		= &nf_ct_tcp_loose,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_BE_LIBERAL,
+		.procname       = "nf_conntrack_tcp_be_liberal",
+		.data           = &nf_ct_tcp_be_liberal,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_TCP_MAX_RETRANS,
+		.procname	= "nf_conntrack_tcp_max_retrans",
+		.data		= &nf_ct_tcp_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_SYSCTL */
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 {
 	.l3proto		= PF_INET,
@@ -1188,6 +1294,11 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &tcp_sysctl_table_users,
+	.ctl_table_header	= &tcp_sysctl_header,
+	.ctl_table		= tcp_sysctl_table,
+#endif
 };
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
@@ -1209,6 +1320,11 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &tcp_sysctl_table_users,
+	.ctl_table_header	= &tcp_sysctl_header,
+	.ctl_table		= tcp_sysctl_table,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_l4proto_tcp4);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 200d7d3..d86749c 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -29,8 +29,8 @@ #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
-unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
-unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
+static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
+static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
 
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
@@ -148,6 +148,32 @@ static int udp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
+#ifdef CONFIG_SYSCTL
+static unsigned int udp_sysctl_table_users;
+static struct ctl_table_header *udp_sysctl_header;
+static struct ctl_table udp_sysctl_table[] = {
+	{
+		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT,
+		.procname	= "nf_conntrack_udp_timeout",
+		.data		= &nf_ct_udp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
+		.procname	= "nf_conntrack_udp_timeout_stream",
+		.data		= &nf_ct_udp_timeout_stream,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+#endif /* CONFIG_SYSCTL */
+
 struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 {
 	.l3proto		= PF_INET,
@@ -165,6 +191,11 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &udp_sysctl_table_users,
+	.ctl_table_header	= &udp_sysctl_header,
+	.ctl_table		= udp_sysctl_table,
+#endif
 };
 
 struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
@@ -184,6 +215,11 @@ #if defined(CONFIG_NF_CT_NETLINK) || \
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	= nf_ct_port_nfattr_to_tuple,
 #endif
+#ifdef CONFIG_SYSCTL
+	.ctl_table_users	= &udp_sysctl_table_users,
+	.ctl_table_header	= &udp_sysctl_header,
+	.ctl_table		= udp_sysctl_table,
+#endif
 };
 
 EXPORT_SYMBOL(nf_conntrack_l4proto_udp4);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2283a26..9d89068 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -330,28 +330,6 @@ #endif /* CONFIG_PROC_FS */
 int nf_conntrack_checksum __read_mostly = 1;
 
 #ifdef CONFIG_SYSCTL
-
-/* From nf_conntrack_proto_tcp.c */
-extern unsigned int nf_ct_tcp_timeout_syn_sent;
-extern unsigned int nf_ct_tcp_timeout_syn_recv;
-extern unsigned int nf_ct_tcp_timeout_established;
-extern unsigned int nf_ct_tcp_timeout_fin_wait;
-extern unsigned int nf_ct_tcp_timeout_close_wait;
-extern unsigned int nf_ct_tcp_timeout_last_ack;
-extern unsigned int nf_ct_tcp_timeout_time_wait;
-extern unsigned int nf_ct_tcp_timeout_close;
-extern unsigned int nf_ct_tcp_timeout_max_retrans;
-extern int nf_ct_tcp_loose;
-extern int nf_ct_tcp_be_liberal;
-extern int nf_ct_tcp_max_retrans;
-
-/* From nf_conntrack_proto_udp.c */
-extern unsigned int nf_ct_udp_timeout;
-extern unsigned int nf_ct_udp_timeout_stream;
-
-/* From nf_conntrack_proto_generic.c */
-extern unsigned int nf_ct_generic_timeout;
-
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;
@@ -392,94 +370,6 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
-		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
-		.data		= &nf_ct_tcp_timeout_syn_sent,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
-		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
-		.data		= &nf_ct_tcp_timeout_syn_recv,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
-		.procname	= "nf_conntrack_tcp_timeout_established",
-		.data		= &nf_ct_tcp_timeout_established,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
-		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
-		.data		= &nf_ct_tcp_timeout_fin_wait,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
-		.procname	= "nf_conntrack_tcp_timeout_close_wait",
-		.data		= &nf_ct_tcp_timeout_close_wait,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
-		.procname	= "nf_conntrack_tcp_timeout_last_ack",
-		.data		= &nf_ct_tcp_timeout_last_ack,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
-		.procname	= "nf_conntrack_tcp_timeout_time_wait",
-		.data		= &nf_ct_tcp_timeout_time_wait,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
-		.procname	= "nf_conntrack_tcp_timeout_close",
-		.data		= &nf_ct_tcp_timeout_close,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT,
-		.procname	= "nf_conntrack_udp_timeout",
-		.data		= &nf_ct_udp_timeout,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
-		.procname	= "nf_conntrack_udp_timeout_stream",
-		.data		= &nf_ct_udp_timeout_stream,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_GENERIC_TIMEOUT,
-		.procname	= "nf_conntrack_generic_timeout",
-		.data		= &nf_ct_generic_timeout,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
 		.ctl_name	= NET_NF_CONNTRACK_LOG_INVALID,
 		.procname	= "nf_conntrack_log_invalid",
 		.data		= &nf_ct_log_invalid,
@@ -490,38 +380,6 @@ static ctl_table nf_ct_sysctl_table[] = 
 		.extra1		= &log_invalid_proto_min,
 		.extra2		= &log_invalid_proto_max,
 	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
-		.procname	= "nf_conntrack_tcp_timeout_max_retrans",
-		.data		= &nf_ct_tcp_timeout_max_retrans,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_LOOSE,
-		.procname	= "nf_conntrack_tcp_loose",
-		.data		= &nf_ct_tcp_loose,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_BE_LIBERAL,
-		.procname       = "nf_conntrack_tcp_be_liberal",
-		.data           = &nf_ct_tcp_be_liberal,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-	{
-		.ctl_name	= NET_NF_CONNTRACK_TCP_MAX_RETRANS,
-		.procname	= "nf_conntrack_tcp_max_retrans",
-		.data		= &nf_ct_tcp_max_retrans,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 
 	{ .ctl_name = 0 }
 };
