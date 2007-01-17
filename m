From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 2/3] XT: xt_match and xt_target
Date: Wed, 17 Jan 2007 15:14:47 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701171514100.18562@yvahk01.tjqt.qr>
References: <20070114192011.GA6270@clipper.ens.fr>
	<Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
	<45AB3DCA.9020204@trash.net>
	<Pine.LNX.4.61.0701151109540.32479@yvahk01.tjqt.qr>
	<45AB54E5.6060103@trash.net>
	<Pine.LNX.4.61.0701151526300.13639@yvahk01.tjqt.qr>
	<45AB94F7.6040806@trash.net>
	<Pine.LNX.4.61.0701151725490.23841@yvahk01.tjqt.qr>
	<45ABAD74.7010808@trash.net>
	<Pine.LNX.4.61.0701151737240.23841@yvahk01.tjqt.qr>
	<45AE0919.2040109@trash.net>
	<Pine.LNX.4.61.0701171337520.18562@yvahk01.tjqt.qr>
	<45AE1956.3090501@trash.net>
	<Pine.LNX.4.61.0701171403410.18562@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701171417360.18562@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.61.0701171417360.18562@yvahk01.tjqt.qr>
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


[PATCH 2/3] XT: xt_match and xt_target

BTW, ip_nat_rule.c <-> nf_nat_rule.c seems to be an almost identical
copy. Schedule one for removal?

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, 2007-01-17

Index: linux-2.6.20-rc5/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.20-rc5.orig/include/linux/netfilter_ipv4/ip_tables.h
+++ linux-2.6.20-rc5/include/linux/netfilter_ipv4/ip_tables.h
@@ -29,8 +29,6 @@
 
 #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define IPT_TABLE_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
-#define ipt_match xt_match
-#define ipt_target xt_target
 #define ipt_table xt_table
 #define ipt_get_revision xt_get_revision
 
@@ -272,16 +270,6 @@ ipt_get_target(struct ipt_entry *e)
 #include <linux/init.h>
 extern void ipt_init(void) __init;
 
-#define ipt_register_target(tgt) 	\
-({	(tgt)->family = AF_INET;	\
- 	xt_register_target(tgt); })
-#define ipt_unregister_target(tgt) xt_unregister_target(tgt)
-
-#define ipt_register_match(mtch) 	\
-({	(mtch)->family = AF_INET;	\
-	xt_register_match(mtch); })
-#define ipt_unregister_match(mtch) xt_unregister_match(mtch)
-
 //#define ipt_register_table(tbl, repl) xt_register_table(AF_INET, tbl, repl)
 //#define ipt_unregister_table(tbl) xt_unregister_table(AF_INET, tbl)
 
@@ -290,7 +278,7 @@ extern int ipt_register_table(struct ipt
 extern void ipt_unregister_table(struct ipt_table *table);
 
 /* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
-extern struct ipt_target *ipt_find_target(const char *name, u8 revision);
+extern struct xt_target *ipt_find_target(const char *name, u8 revision);
 
 /* Standard entry. */
 struct ipt_standard
Index: linux-2.6.20-rc5/include/linux/netfilter_ipv6/ip6_tables.h
===================================================================
--- linux-2.6.20-rc5.orig/include/linux/netfilter_ipv6/ip6_tables.h
+++ linux-2.6.20-rc5/include/linux/netfilter_ipv6/ip6_tables.h
@@ -29,9 +29,6 @@
 
 #define IP6T_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define IP6T_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
-
-#define ip6t_match xt_match
-#define ip6t_target xt_target
 #define ip6t_table xt_table
 #define ip6t_get_revision xt_get_revision
 
@@ -286,16 +283,6 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
 
-#define ip6t_register_target(tgt) 		\
-({	(tgt)->family = AF_INET6;		\
- 	xt_register_target(tgt); })
-#define ip6t_unregister_target(tgt) xt_unregister_target(tgt)
-
-#define ip6t_register_match(match)		\
-({	(match)->family = AF_INET6;		\
-	xt_register_match(match); })
-#define ip6t_unregister_match(match) xt_unregister_match(match)
-
 extern int ip6t_register_table(struct ip6t_table *table,
 			       const struct ip6t_replace *repl);
 extern void ip6t_unregister_table(struct ip6t_table *table);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ip_nat_rule.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ip_nat_rule.c
@@ -99,7 +99,7 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const struct ipt_target *target,
+				    const struct xt_target *target,
 				    const void *targinfo)
 {
 	struct ip_conntrack *ct;
@@ -141,7 +141,7 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
-				    const struct ipt_target *target,
+				    const struct xt_target *target,
 				    const void *targinfo)
 {
 	struct ip_conntrack *ct;
@@ -166,7 +166,7 @@ static unsigned int ipt_dnat_target(stru
 
 static int ipt_snat_checkentry(const char *tablename,
 			       const void *entry,
-			       const struct ipt_target *target,
+			       const struct xt_target *target,
 			       void *targinfo,
 			       unsigned int hook_mask)
 {
@@ -182,7 +182,7 @@ static int ipt_snat_checkentry(const cha
 
 static int ipt_dnat_checkentry(const char *tablename,
 			       const void *entry,
-			       const struct ipt_target *target,
+			       const struct xt_target *target,
 			       void *targinfo,
 			       unsigned int hook_mask)
 {
@@ -257,8 +257,9 @@ int ip_nat_rule_find(struct sk_buff **ps
 	return ret;
 }
 
-static struct ipt_target ipt_snat_reg = {
+static struct xt_target ipt_snat_reg = {
 	.name		= "SNAT",
+	.family		= AF_INET,
 	.target		= ipt_snat_target,
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
@@ -266,8 +267,9 @@ static struct ipt_target ipt_snat_reg = 
 	.checkentry	= ipt_snat_checkentry,
 };
 
-static struct ipt_target ipt_dnat_reg = {
+static struct xt_target ipt_dnat_reg = {
 	.name		= "DNAT",
+	.family		= AF_INET,
 	.target		= ipt_dnat_target,
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
@@ -282,27 +284,27 @@ int __init ip_nat_rule_init(void)
 	ret = ipt_register_table(&nat_table, &nat_initial_table.repl);
 	if (ret != 0)
 		return ret;
-	ret = ipt_register_target(&ipt_snat_reg);
+	ret = xt_register_target(&ipt_snat_reg);
 	if (ret != 0)
 		goto unregister_table;
 
-	ret = ipt_register_target(&ipt_dnat_reg);
+	ret = xt_register_target(&ipt_dnat_reg);
 	if (ret != 0)
 		goto unregister_snat;
 
 	return ret;
 
  unregister_snat:
-	ipt_unregister_target(&ipt_snat_reg);
+	xt_unregister_target(&ipt_snat_reg);
  unregister_table:
-	ipt_unregister_table(&nat_table);
+	xt_unregister_table(&nat_table);
 
 	return ret;
 }
 
 void ip_nat_rule_cleanup(void)
 {
-	ipt_unregister_target(&ipt_dnat_reg);
-	ipt_unregister_target(&ipt_snat_reg);
+	xt_unregister_target(&ipt_dnat_reg);
+	xt_unregister_target(&ipt_snat_reg);
 	ipt_unregister_table(&nat_table);
 }
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ip_tables.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ip_tables.c
@@ -507,7 +507,7 @@ check_entry(struct ipt_entry *e, const c
 static inline int check_match(struct ipt_entry_match *m, const char *name,
 				const struct ipt_ip *ip, unsigned int hookmask)
 {
-	struct ipt_match *match;
+	struct xt_match *match;
 	int ret;
 
 	match = m->u.kernel.match;
@@ -531,7 +531,7 @@ find_check_match(struct ipt_entry_match 
 	    unsigned int hookmask,
 	    unsigned int *i)
 {
-	struct ipt_match *match;
+	struct xt_match *match;
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
@@ -557,7 +557,7 @@ err:
 static inline int check_target(struct ipt_entry *e, const char *name)
 {
  	struct ipt_entry_target *t;
- 	struct ipt_target *target;
+ 	struct xt_target *target;
  	int ret;
 
 	t = ipt_get_target(e);
@@ -580,7 +580,7 @@ find_check_entry(struct ipt_entry *e, co
 	    unsigned int *i)
 {
 	struct ipt_entry_target *t;
-	struct ipt_target *target;
+	struct xt_target *target;
 	int ret;
 	unsigned int j;
 
@@ -1437,7 +1437,7 @@ compat_check_calc_match(struct ipt_entry
 	    unsigned int hookmask,
 	    int *size, int *i)
 {
-	struct ipt_match *match;
+	struct xt_match *match;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
 						   m->u.user.revision),
@@ -1466,7 +1466,7 @@ check_compat_entry_size_and_hooks(struct
 			   const char *name)
 {
 	struct ipt_entry_target *t;
-	struct ipt_target *target;
+	struct xt_target *target;
 	unsigned int entry_offset;
 	int ret, off, h, j;
 
@@ -1550,7 +1550,7 @@ static int compat_copy_entry_from_user(s
 	struct xt_table_info *newinfo, unsigned char *base)
 {
 	struct ipt_entry_target *t;
-	struct ipt_target *target;
+	struct xt_target *target;
 	struct ipt_entry *de;
 	unsigned int origsize;
 	int ret, h;
@@ -2124,7 +2124,7 @@ icmp_checkentry(const char *tablename,
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct ipt_target ipt_standard_target = {
+static struct xt_target ipt_standard_target = {
 	.name		= IPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET,
@@ -2135,7 +2135,7 @@ static struct ipt_target ipt_standard_ta
 #endif
 };
 
-static struct ipt_target ipt_error_target = {
+static struct xt_target ipt_error_target = {
 	.name		= IPT_ERROR_TARGET,
 	.target		= ipt_error,
 	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
@@ -2158,7 +2158,7 @@ static struct nf_sockopt_ops ipt_sockopt
 #endif
 };
 
-static struct ipt_match icmp_matchstruct = {
+static struct xt_match icmp_matchstruct = {
 	.name		= "icmp",
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -26,6 +26,7 @@
 
 #include <linux/netfilter_arp.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <net/netfilter/nf_conntrack_compat.h>
@@ -329,7 +330,7 @@ target(struct sk_buff **pskb,
 	if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP
 	    && (ctinfo == IP_CT_RELATED 
 		|| ctinfo == IP_CT_RELATED+IP_CT_IS_REPLY))
-		return IPT_CONTINUE;
+		return XT_CONTINUE;
 
 	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO, 
 	 * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
@@ -367,7 +368,7 @@ target(struct sk_buff **pskb,
 	 * actually a unicast IP packet. TCP doesn't like PACKET_MULTICAST */
 	(*pskb)->pkt_type = PACKET_HOST;
 
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int
@@ -470,8 +471,9 @@ static void destroy(const struct xt_targ
 	nf_ct_l3proto_module_put(target->family);
 }
 
-static struct ipt_target clusterip_tgt = {
+static struct xt_target clusterip_tgt = {
 	.name		= "CLUSTERIP",
+	.family		= AF_INET,
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
 	.checkentry	= checkentry,
@@ -727,7 +729,7 @@ static int __init ipt_clusterip_init(voi
 {
 	int ret;
 
-	ret = ipt_register_target(&clusterip_tgt);
+	ret = xt_register_target(&clusterip_tgt);
 	if (ret < 0)
 		return ret;
 
@@ -753,7 +755,7 @@ cleanup_hook:
 	nf_unregister_hook(&cip_arp_ops);
 #endif /* CONFIG_PROC_FS */
 cleanup_target:
-	ipt_unregister_target(&clusterip_tgt);
+	xt_unregister_target(&clusterip_tgt);
 	return ret;
 }
 
@@ -765,7 +767,7 @@ static void __exit ipt_clusterip_fini(vo
 	remove_proc_entry(clusterip_procdir->name, clusterip_procdir->parent);
 #endif
 	nf_unregister_hook(&cip_arp_ops);
-	ipt_unregister_target(&clusterip_tgt);
+	xt_unregister_target(&clusterip_tgt);
 }
 
 module_init(ipt_clusterip_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_ECN.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ECN.c
@@ -9,12 +9,14 @@
  * ipt_ECN.c,v 1.5 2002/08/18 19:36:51 laforge Exp
 */
 
+#include <linux/in.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <net/checksum.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
@@ -95,7 +97,7 @@ target(struct sk_buff **pskb,
 		if (!set_ect_tcp(pskb, einfo))
 			return NF_DROP;
 
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int
@@ -119,7 +121,7 @@ checkentry(const char *tablename,
 		return 0;
 	}
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR))
-	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & IPT_INV_PROTO))) {
+	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
 		printk(KERN_WARNING "ECN: cannot use TCP operations on a "
 		       "non-tcp rule\n");
 		return 0;
@@ -127,8 +129,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_target ipt_ecn_reg = {
+static struct xt_target ipt_ecn_reg = {
 	.name		= "ECN",
+	.family		= AF_INET,
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_ECN_info),
 	.table		= "mangle",
@@ -138,12 +141,12 @@ static struct ipt_target ipt_ecn_reg = {
 
 static int __init ipt_ecn_init(void)
 {
-	return ipt_register_target(&ipt_ecn_reg);
+	return xt_register_target(&ipt_ecn_reg);
 }
 
 static void __exit ipt_ecn_fini(void)
 {
-	ipt_unregister_target(&ipt_ecn_reg);
+	xt_unregister_target(&ipt_ecn_reg);
 }
 
 module_init(ipt_ecn_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_LOG.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_LOG.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_LOG.c
@@ -20,7 +20,7 @@
 #include <net/route.h>
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 
 MODULE_LICENSE("GPL");
@@ -432,7 +432,7 @@ ipt_log_target(struct sk_buff **pskb,
 
 	ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
 	               loginfo->prefix);
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int ipt_log_checkentry(const char *tablename,
@@ -455,8 +455,9 @@ static int ipt_log_checkentry(const char
 	return 1;
 }
 
-static struct ipt_target ipt_log_reg = {
+static struct xt_target ipt_log_reg = {
 	.name		= "LOG",
+	.family		= AF_INET,
 	.target		= ipt_log_target,
 	.targetsize	= sizeof(struct ipt_log_info),
 	.checkentry	= ipt_log_checkentry,
@@ -472,7 +473,7 @@ static struct nf_logger ipt_log_logger =
 static int __init ipt_log_init(void)
 {
 	int ret;
-	if ((ret = ipt_register_target(&ipt_log_reg)) < 0)
+	if ((ret = xt_register_target(&ipt_log_reg)) < 0)
 		return ret;
 	if (nf_log_register(PF_INET, &ipt_log_logger) < 0) {
 		printk(KERN_WARNING "ipt_LOG: not logging via system console "
@@ -487,7 +488,7 @@ static int __init ipt_log_init(void)
 static void __exit ipt_log_fini(void)
 {
 	nf_log_unregister_logger(&ipt_log_logger);
-	ipt_unregister_target(&ipt_log_reg);
+	xt_unregister_target(&ipt_log_reg);
 }
 
 module_init(ipt_log_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -25,7 +25,7 @@
 #else
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #endif
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
@@ -190,8 +190,9 @@ static struct notifier_block masq_inet_n
 	.notifier_call	= masq_inet_event,
 };
 
-static struct ipt_target masquerade = {
+static struct xt_target masquerade = {
 	.name		= "MASQUERADE",
+	.family		= AF_INET,
 	.target		= masquerade_target,
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
@@ -204,7 +205,7 @@ static int __init ipt_masquerade_init(vo
 {
 	int ret;
 
-	ret = ipt_register_target(&masquerade);
+	ret = xt_register_target(&masquerade);
 
 	if (ret == 0) {
 		/* Register for device down reports */
@@ -218,7 +219,7 @@ static int __init ipt_masquerade_init(vo
 
 static void __exit ipt_masquerade_fini(void)
 {
-	ipt_unregister_target(&masquerade);
+	xt_unregister_target(&masquerade);
 	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
 }
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_NETMAP.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_NETMAP.c
@@ -15,6 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/x_tables.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_rule.h>
 #else
@@ -88,8 +89,9 @@ target(struct sk_buff **pskb,
 	return ip_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct ipt_target target_module = { 
+static struct xt_target target_module = {
 	.name 		= MODULENAME,
+	.family		= AF_INET,
 	.target 	= target, 
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
@@ -101,12 +103,12 @@ static struct ipt_target target_module =
 
 static int __init ipt_netmap_init(void)
 {
-	return ipt_register_target(&target_module);
+	return xt_register_target(&target_module);
 }
 
 static void __exit ipt_netmap_fini(void)
 {
-	ipt_unregister_target(&target_module);
+	xt_unregister_target(&target_module);
 }
 
 module_init(ipt_netmap_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_REDIRECT.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_REDIRECT.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -18,6 +18,7 @@
 #include <net/protocol.h>
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/x_tables.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_rule.h>
 #else
@@ -104,8 +105,9 @@ redirect_target(struct sk_buff **pskb,
 	return ip_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct ipt_target redirect_reg = {
+static struct xt_target redirect_reg = {
 	.name		= "REDIRECT",
+	.family		= AF_INET,
 	.target		= redirect_target,
 	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
 	.table		= "nat",
@@ -116,12 +118,12 @@ static struct ipt_target redirect_reg = 
 
 static int __init ipt_redirect_init(void)
 {
-	return ipt_register_target(&redirect_reg);
+	return xt_register_target(&redirect_reg);
 }
 
 static void __exit ipt_redirect_fini(void)
 {
-	ipt_unregister_target(&redirect_reg);
+	xt_unregister_target(&redirect_reg);
 }
 
 module_init(ipt_redirect_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_REJECT.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_REJECT.c
@@ -22,6 +22,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
 #include <net/dst.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
 #ifdef CONFIG_BRIDGE_NETFILTER
@@ -230,7 +231,7 @@ static int check(const char *tablename,
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP
-		    || (e->ip.invflags & IPT_INV_PROTO)) {
+		    || (e->ip.invflags & XT_INV_PROTO)) {
 			DEBUGP("REJECT: TCP_RESET invalid for non-tcp\n");
 			return 0;
 		}
@@ -238,8 +239,9 @@ static int check(const char *tablename,
 	return 1;
 }
 
-static struct ipt_target ipt_reject_reg = {
+static struct xt_target ipt_reject_reg = {
 	.name		= "REJECT",
+	.family		= AF_INET,
 	.target		= reject,
 	.targetsize	= sizeof(struct ipt_reject_info),
 	.table		= "filter",
@@ -251,12 +253,12 @@ static struct ipt_target ipt_reject_reg 
 
 static int __init ipt_reject_init(void)
 {
-	return ipt_register_target(&ipt_reject_reg);
+	return xt_register_target(&ipt_reject_reg);
 }
 
 static void __exit ipt_reject_fini(void)
 {
-	ipt_unregister_target(&ipt_reject_reg);
+	xt_unregister_target(&ipt_reject_reg);
 }
 
 module_init(ipt_reject_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_SAME.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_SAME.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_SAME.c
@@ -34,6 +34,7 @@
 #include <net/protocol.h>
 #include <net/checksum.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/x_tables.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_rule.h>
 #else
@@ -186,8 +187,9 @@ same_target(struct sk_buff **pskb,
 	return ip_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct ipt_target same_reg = { 
+static struct xt_target same_reg = {
 	.name		= "SAME",
+	.family		= AF_INET,
 	.target		= same_target,
 	.targetsize	= sizeof(struct ipt_same_info),
 	.table		= "nat",
@@ -199,12 +201,12 @@ static struct ipt_target same_reg = { 
 
 static int __init ipt_same_init(void)
 {
-	return ipt_register_target(&same_reg);
+	return xt_register_target(&same_reg);
 }
 
 static void __exit ipt_same_fini(void)
 {
-	ipt_unregister_target(&same_reg);
+	xt_unregister_target(&same_reg);
 }
 
 module_init(ipt_same_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_TCPMSS.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -14,6 +14,7 @@
 #include <linux/ip.h>
 #include <net/tcp.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_TCPMSS.h>
 
@@ -74,7 +75,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 				printk(KERN_ERR "ipt_tcpmss_target: "
 				       "unknown or invalid path-MTU (%d)\n",
 				       dst_mtu((*pskb)->dst));
-			return NF_DROP; /* or IPT_CONTINUE ?? */
+			return NF_DROP; /* or XT_CONTINUE ?? */
 		}
 
 		newmss = dst_mtu((*pskb)->dst) - sizeof(struct iphdr) -
@@ -92,14 +93,14 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 
 			if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU &&
 			    oldmss <= newmss)
-				return IPT_CONTINUE;
+				return XT_CONTINUE;
 
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = (newmss & 0x00ff);
 
 			nf_proto_csum_replace2(&tcph->check, *pskb,
 						htons(oldmss), htons(newmss), 0);
-			return IPT_CONTINUE;
+			return XT_CONTINUE;
 		}
 	}
 
@@ -141,7 +142,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	newtotlen = htons(ntohs(iph->tot_len) + TCPOLEN_MSS);
 	nf_csum_replace2(&iph->check, iph->tot_len, newtotlen);
 	iph->tot_len = newtotlen;
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 #define TH_SYN 0x02
@@ -184,8 +185,9 @@ ipt_tcpmss_checkentry(const char *tablen
 	return 0;
 }
 
-static struct ipt_target ipt_tcpmss_reg = {
+static struct xt_target ipt_tcpmss_reg = {
 	.name		= "TCPMSS",
+	.family		= AF_INET,
 	.target		= ipt_tcpmss_target,
 	.targetsize	= sizeof(struct ipt_tcpmss_info),
 	.proto		= IPPROTO_TCP,
@@ -195,12 +197,12 @@ static struct ipt_target ipt_tcpmss_reg 
 
 static int __init ipt_tcpmss_init(void)
 {
-	return ipt_register_target(&ipt_tcpmss_reg);
+	return xt_register_target(&ipt_tcpmss_reg);
 }
 
 static void __exit ipt_tcpmss_fini(void)
 {
-	ipt_unregister_target(&ipt_tcpmss_reg);
+	xt_unregister_target(&ipt_tcpmss_reg);
 }
 
 module_init(ipt_tcpmss_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_TOS.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TOS.c
@@ -13,7 +13,7 @@
 #include <linux/ip.h>
 #include <net/checksum.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_TOS.h>
 
 MODULE_LICENSE("GPL");
@@ -40,7 +40,7 @@ target(struct sk_buff **pskb,
 		iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
 		nf_csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
 	}
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int
@@ -63,8 +63,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_target ipt_tos_reg = {
+static struct xt_target ipt_tos_reg = {
 	.name		= "TOS",
+	.family		= AF_INET,
 	.target		= target,
 	.targetsize	= sizeof(struct ipt_tos_target_info),
 	.table		= "mangle",
@@ -74,12 +75,12 @@ static struct ipt_target ipt_tos_reg = {
 
 static int __init ipt_tos_init(void)
 {
-	return ipt_register_target(&ipt_tos_reg);
+	return xt_register_target(&ipt_tos_reg);
 }
 
 static void __exit ipt_tos_fini(void)
 {
-	ipt_unregister_target(&ipt_tos_reg);
+	xt_unregister_target(&ipt_tos_reg);
 }
 
 module_init(ipt_tos_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TTL.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_TTL.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_TTL.c
@@ -12,7 +12,7 @@
 #include <linux/ip.h>
 #include <net/checksum.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_TTL.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -59,7 +59,7 @@ ipt_ttl_target(struct sk_buff **pskb,
 		iph->ttl = new_ttl;
 	}
 
-	return IPT_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int ipt_ttl_checkentry(const char *tablename,
@@ -80,8 +80,9 @@ static int ipt_ttl_checkentry(const char
 	return 1;
 }
 
-static struct ipt_target ipt_TTL = { 
+static struct xt_target ipt_TTL = {
 	.name 		= "TTL",
+	.family		= AF_INET,
 	.target 	= ipt_ttl_target, 
 	.targetsize	= sizeof(struct ipt_TTL_info),
 	.table		= "mangle",
@@ -91,12 +92,12 @@ static struct ipt_target ipt_TTL = { 
 
 static int __init ipt_ttl_init(void)
 {
-	return ipt_register_target(&ipt_TTL);
+	return xt_register_target(&ipt_TTL);
 }
 
 static void __exit ipt_ttl_fini(void)
 {
-	ipt_unregister_target(&ipt_TTL);
+	xt_unregister_target(&ipt_TTL);
 }
 
 module_init(ipt_ttl_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_ULOG.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ULOG.c
@@ -57,7 +57,7 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 #include <net/sock.h>
 #include <linux/bitops.h>
@@ -132,7 +132,6 @@ static void ulog_send(unsigned int nlgro
 	ub->qlen = 0;
 	ub->skb = NULL;
 	ub->lastnlh = NULL;
-
 }
 
 
@@ -314,7 +313,7 @@ static unsigned int ipt_ulog_target(stru
 
 	ipt_ulog_packet(hooknum, *pskb, in, out, loginfo, NULL);
  
- 	return IPT_CONTINUE;
+ 	return XT_CONTINUE;
 }
  
 static void ipt_logfn(unsigned int pf,
@@ -363,8 +362,9 @@ static int ipt_ulog_checkentry(const cha
 	return 1;
 }
 
-static struct ipt_target ipt_ulog_reg = {
+static struct xt_target ipt_ulog_reg = {
 	.name		= "ULOG",
+	.family		= AF_INET,
 	.target		= ipt_ulog_target,
 	.targetsize	= sizeof(struct ipt_ulog_info),
 	.checkentry	= ipt_ulog_checkentry,
@@ -400,7 +400,7 @@ static int __init ipt_ulog_init(void)
 	if (!nflognl)
 		return -ENOMEM;
 
-	if ((ret = ipt_register_target(&ipt_ulog_reg)) != 0) {
+	if ((ret = xt_register_target(&ipt_ulog_reg)) != 0) {
 		sock_release(nflognl->sk_socket);
 		return ret;
 	}
@@ -419,7 +419,7 @@ static void __exit ipt_ulog_fini(void)
 
 	if (nflog)
 		nf_log_unregister_logger(&ipt_ulog_logger);
-	ipt_unregister_target(&ipt_ulog_reg);
+	xt_unregister_target(&ipt_ulog_reg);
 	sock_release(nflognl->sk_socket);
 
 	/* remove pending timers and free allocated skb's */
@@ -435,7 +435,6 @@ static void __exit ipt_ulog_fini(void)
 			ub->skb = NULL;
 		}
 	}
-
 }
 
 module_init(ipt_ulog_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_addrtype.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_addrtype.c
@@ -16,7 +16,7 @@
 #include <net/route.h>
 
 #include <linux/netfilter_ipv4/ipt_addrtype.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
@@ -44,8 +44,9 @@ static int match(const struct sk_buff *s
 	return ret;
 }
 
-static struct ipt_match addrtype_match = {
+static struct xt_match addrtype_match = {
 	.name		= "addrtype",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_addrtype_info),
 	.me		= THIS_MODULE
@@ -53,12 +54,12 @@ static struct ipt_match addrtype_match =
 
 static int __init ipt_addrtype_init(void)
 {
-	return ipt_register_match(&addrtype_match);
+	return xt_register_match(&addrtype_match);
 }
 
 static void __exit ipt_addrtype_fini(void)
 {
-	ipt_unregister_match(&addrtype_match);
+	xt_unregister_match(&addrtype_match);
 }
 
 module_init(ipt_addrtype_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_ah.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ah.c
@@ -6,12 +6,13 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/in.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 
 #include <linux/netfilter_ipv4/ipt_ah.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
@@ -86,8 +87,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_match ah_match = {
+static struct xt_match ah_match = {
 	.name		= "ah",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_ah),
 	.proto		= IPPROTO_AH,
@@ -97,12 +99,12 @@ static struct ipt_match ah_match = {
 
 static int __init ipt_ah_init(void)
 {
-	return ipt_register_match(&ah_match);
+	return xt_register_match(&ah_match);
 }
 
 static void __exit ipt_ah_fini(void)
 {
-	ipt_unregister_match(&ah_match);
+	xt_unregister_match(&ah_match);
 }
 
 module_init(ipt_ah_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_ecn.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ecn.c
@@ -9,10 +9,13 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/tcp.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
@@ -109,8 +112,9 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static struct ipt_match ecn_match = {
+static struct xt_match ecn_match = {
 	.name		= "ecn",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_ecn_info),
 	.checkentry	= checkentry,
@@ -119,12 +123,12 @@ static struct ipt_match ecn_match = {
 
 static int __init ipt_ecn_init(void)
 {
-	return ipt_register_match(&ecn_match);
+	return xt_register_match(&ecn_match);
 }
 
 static void __exit ipt_ecn_fini(void)
 {
-	ipt_unregister_match(&ecn_match);
+	xt_unregister_match(&ecn_match);
 }
 
 module_init(ipt_ecn_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_iprange.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_iprange.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 MODULE_LICENSE("GPL");
@@ -63,22 +63,22 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static struct ipt_match iprange_match = {
+static struct xt_match iprange_match = {
 	.name		= "iprange",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_iprange_info),
-	.destroy	= NULL,
 	.me		= THIS_MODULE
 };
 
 static int __init ipt_iprange_init(void)
 {
-	return ipt_register_match(&iprange_match);
+	return xt_register_match(&iprange_match);
 }
 
 static void __exit ipt_iprange_fini(void)
 {
-	ipt_unregister_match(&iprange_match);
+	xt_unregister_match(&iprange_match);
 }
 
 module_init(ipt_iprange_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_owner.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_owner.c
@@ -15,7 +15,7 @@
 #include <net/sock.h>
 
 #include <linux/netfilter_ipv4/ipt_owner.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
@@ -68,8 +68,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_match owner_match = {
+static struct xt_match owner_match = {
 	.name		= "owner",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_owner_info),
 	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING),
@@ -79,12 +80,12 @@ static struct ipt_match owner_match = {
 
 static int __init ipt_owner_init(void)
 {
-	return ipt_register_match(&owner_match);
+	return xt_register_match(&owner_match);
 }
 
 static void __exit ipt_owner_fini(void)
 {
-	ipt_unregister_match(&owner_match);
+	xt_unregister_match(&owner_match);
 }
 
 module_init(ipt_owner_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_recent.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_recent.c
@@ -12,6 +12,7 @@
  * Copyright 2002-2003, Stephen Frost, 2.5.x port by laforge@netfilter.org
  */
 #include <linux/init.h>
+#include <linux/ip.h>
 #include <linux/moduleparam.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -24,7 +25,7 @@
 #include <linux/skbuff.h>
 #include <linux/inet.h>
 
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_recent.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
@@ -462,8 +463,9 @@ static struct file_operations recent_fop
 };
 #endif /* CONFIG_PROC_FS */
 
-static struct ipt_match recent_match = {
+static struct xt_match recent_match = {
 	.name		= "recent",
+	.family		= AF_INET,
 	.match		= ipt_recent_match,
 	.matchsize	= sizeof(struct ipt_recent_info),
 	.checkentry	= ipt_recent_checkentry,
@@ -479,13 +481,13 @@ static int __init ipt_recent_init(void)
 		return -EINVAL;
 	ip_list_hash_size = 1 << fls(ip_list_tot);
 
-	err = ipt_register_match(&recent_match);
+	err = xt_register_match(&recent_match);
 #ifdef CONFIG_PROC_FS
 	if (err)
 		return err;
 	proc_dir = proc_mkdir("ipt_recent", proc_net);
 	if (proc_dir == NULL) {
-		ipt_unregister_match(&recent_match);
+		xt_unregister_match(&recent_match);
 		err = -ENOMEM;
 	}
 #endif
@@ -495,7 +497,7 @@ static int __init ipt_recent_init(void)
 static void __exit ipt_recent_exit(void)
 {
 	BUG_ON(!list_empty(&tables));
-	ipt_unregister_match(&recent_match);
+	xt_unregister_match(&recent_match);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("ipt_recent", proc_net);
 #endif
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_tos.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_tos.c
@@ -8,11 +8,12 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/ip.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
 #include <linux/netfilter_ipv4/ipt_tos.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("iptables TOS match module");
@@ -32,8 +33,9 @@ match(const struct sk_buff *skb,
 	return (skb->nh.iph->tos == info->tos) ^ info->invert;
 }
 
-static struct ipt_match tos_match = {
+static struct xt_match tos_match = {
 	.name		= "tos",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_tos_info),
 	.me		= THIS_MODULE,
@@ -41,12 +43,12 @@ static struct ipt_match tos_match = {
 
 static int __init ipt_multiport_init(void)
 {
-	return ipt_register_match(&tos_match);
+	return xt_register_match(&tos_match);
 }
 
 static void __exit ipt_multiport_fini(void)
 {
-	ipt_unregister_match(&tos_match);
+	xt_unregister_match(&tos_match);
 }
 
 module_init(ipt_multiport_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ttl.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/ipt_ttl.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/ipt_ttl.c
@@ -9,11 +9,12 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/ip.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
 #include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IP tables TTL matching module");
@@ -48,8 +49,9 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static struct ipt_match ttl_match = {
+static struct xt_match ttl_match = {
 	.name		= "ttl",
+	.family		= AF_INET,
 	.match		= match,
 	.matchsize	= sizeof(struct ipt_ttl_info),
 	.me		= THIS_MODULE,
@@ -57,13 +59,12 @@ static struct ipt_match ttl_match = {
 
 static int __init ipt_ttl_init(void)
 {
-	return ipt_register_match(&ttl_match);
+	return xt_register_match(&ttl_match);
 }
 
 static void __exit ipt_ttl_fini(void)
 {
-	ipt_unregister_match(&ttl_match);
-
+	xt_unregister_match(&ttl_match);
 }
 
 module_init(ipt_ttl_init);
Index: linux-2.6.20-rc5/net/ipv4/netfilter/nf_nat_rule.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv4/netfilter/nf_nat_rule.c
+++ linux-2.6.20-rc5/net/ipv4/netfilter/nf_nat_rule.c
@@ -290,7 +290,7 @@ int nf_nat_rule_find(struct sk_buff **ps
 	return ret;
 }
 
-static struct ipt_target ipt_snat_reg = {
+static struct xt_target ipt_snat_reg = {
 	.name		= "SNAT",
 	.target		= ipt_snat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6_tables.c
@@ -530,7 +530,7 @@ check_match(struct ip6t_entry_match *m,
 	    unsigned int hookmask,
 	    unsigned int *i)
 {
-	struct ip6t_match *match;
+	struct xt_match *match;
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
@@ -564,14 +564,14 @@ err:
 	return ret;
 }
 
-static struct ip6t_target ip6t_standard_target;
+static struct xt_target ip6t_standard_target;
 
 static inline int
 check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	    unsigned int *i)
 {
 	struct ip6t_entry_target *t;
-	struct ip6t_target *target;
+	struct xt_target *target;
 	int ret;
 	unsigned int j;
 
@@ -1348,13 +1348,13 @@ icmp6_checkentry(const char *tablename,
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct ip6t_target ip6t_standard_target = {
+static struct xt_target ip6t_standard_target = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET6,
 };
 
-static struct ip6t_target ip6t_error_target = {
+static struct xt_target ip6t_error_target = {
 	.name		= IP6T_ERROR_TARGET,
 	.target		= ip6t_error,
 	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
@@ -1371,7 +1371,7 @@ static struct nf_sockopt_ops ip6t_sockop
 	.get		= do_ip6t_get_ctl,
 };
 
-static struct ip6t_match icmp6_matchstruct = {
+static struct xt_match icmp6_matchstruct = {
 	.name		= "icmp6",
 	.match		= &icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_HL.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_HL.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_HL.c
@@ -9,12 +9,13 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6t_HL.h>
 
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("IP tables Hop Limit modification module");
+MODULE_DESCRIPTION("IP6 tables Hop Limit modification module");
 MODULE_LICENSE("GPL");
 
 static unsigned int ip6t_hl_target(struct sk_buff **pskb, 
@@ -55,7 +56,7 @@ static unsigned int ip6t_hl_target(struc
 	if (new_hl != ip6h->hop_limit)
 		ip6h->hop_limit = new_hl;
 
-	return IP6T_CONTINUE;
+	return XT_CONTINUE;
 }
 
 static int ip6t_hl_checkentry(const char *tablename,
@@ -79,8 +80,9 @@ static int ip6t_hl_checkentry(const char
 	return 1;
 }
 
-static struct ip6t_target ip6t_HL = { 
+static struct xt_target ip6t_HL = {
 	.name 		= "HL", 
+	.family		= AF_INET6,
 	.target		= ip6t_hl_target, 
 	.targetsize	= sizeof(struct ip6t_HL_info),
 	.table		= "mangle",
@@ -90,12 +92,12 @@ static struct ip6t_target ip6t_HL = { 
 
 static int __init ip6t_hl_init(void)
 {
-	return ip6t_register_target(&ip6t_HL);
+	return xt_register_target(&ip6t_HL);
 }
 
 static void __exit ip6t_hl_fini(void)
 {
-	ip6t_unregister_target(&ip6t_HL);
+	xt_unregister_target(&ip6t_HL);
 }
 
 module_init(ip6t_hl_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_LOG.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_LOG.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_LOG.c
@@ -21,6 +21,7 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
@@ -442,7 +443,7 @@ ip6t_log_target(struct sk_buff **pskb,
 
 	ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
 	                loginfo->prefix);
-	return IP6T_CONTINUE;
+	return XT_CONTINUE;
 }
 
 
@@ -466,8 +467,9 @@ static int ip6t_log_checkentry(const cha
 	return 1;
 }
 
-static struct ip6t_target ip6t_log_reg = {
+static struct xt_target ip6t_log_reg = {
 	.name 		= "LOG",
+	.family		= AF_INET6,
 	.target 	= ip6t_log_target, 
 	.targetsize	= sizeof(struct ip6t_log_info),
 	.checkentry	= ip6t_log_checkentry, 
@@ -483,7 +485,7 @@ static struct nf_logger ip6t_logger = {
 static int __init ip6t_log_init(void)
 {
 	int ret;
-	if ((ret = ip6t_register_target(&ip6t_log_reg)) < 0)
+	if ((ret = xt_register_target(&ip6t_log_reg)) < 0)
 		return ret;
 	if (nf_log_register(PF_INET6, &ip6t_logger) < 0) {
 		printk(KERN_WARNING "ip6t_LOG: not logging via system console "
@@ -498,7 +500,7 @@ static int __init ip6t_log_init(void)
 static void __exit ip6t_log_fini(void)
 {
 	nf_log_unregister_logger(&ip6t_logger);
-	ip6t_unregister_target(&ip6t_log_reg);
+	xt_unregister_target(&ip6t_log_reg);
 }
 
 module_init(ip6t_log_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_REJECT.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_REJECT.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_REJECT.c
@@ -26,6 +26,7 @@
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 #include <net/flow.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
@@ -234,7 +235,7 @@ static int check(const char *tablename,
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ipv6.proto != IPPROTO_TCP
-		    || (e->ipv6.invflags & IP6T_INV_PROTO)) {
+		    || (e->ipv6.invflags & XT_INV_PROTO)) {
 			DEBUGP("ip6t_REJECT: TCP_RESET illegal for non-tcp\n");
 			return 0;
 		}
@@ -242,8 +243,9 @@ static int check(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_target ip6t_reject_reg = {
+static struct xt_target ip6t_reject_reg = {
 	.name		= "REJECT",
+	.family		= AF_INET6,
 	.target		= reject6_target,
 	.targetsize	= sizeof(struct ip6t_reject_info),
 	.table		= "filter",
@@ -255,12 +257,12 @@ static struct ip6t_target ip6t_reject_re
 
 static int __init ip6t_reject_init(void)
 {
-	return ip6t_register_target(&ip6t_reject_reg);
+	return xt_register_target(&ip6t_reject_reg);
 }
 
 static void __exit ip6t_reject_fini(void)
 {
-	ip6t_unregister_target(&ip6t_reject_reg);
+	xt_unregister_target(&ip6t_reject_reg);
 }
 
 module_init(ip6t_reject_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_ah.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_ah.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_ah.c
@@ -15,6 +15,7 @@
 #include <net/checksum.h>
 #include <net/ipv6.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_ah.h>
 
@@ -118,8 +119,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_match ah_match = {
+static struct xt_match ah_match = {
 	.name		= "ah",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_ah),
 	.checkentry	= checkentry,
@@ -128,12 +130,12 @@ static struct ip6t_match ah_match = {
 
 static int __init ip6t_ah_init(void)
 {
-	return ip6t_register_match(&ah_match);
+	return xt_register_match(&ah_match);
 }
 
 static void __exit ip6t_ah_fini(void)
 {
-	ip6t_unregister_match(&ah_match);
+	xt_unregister_match(&ah_match);
 }
 
 module_init(ip6t_ah_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_eui64.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_eui64.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_eui64.c
@@ -12,6 +12,7 @@
 #include <linux/ipv6.h>
 #include <linux/if_ether.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 MODULE_DESCRIPTION("IPv6 EUI64 address checking match");
@@ -61,8 +62,9 @@ match(const struct sk_buff *skb,
 	return 0;
 }
 
-static struct ip6t_match eui64_match = {
+static struct xt_match eui64_match = {
 	.name		= "eui64",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(int),
 	.hooks		= (1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
@@ -72,12 +74,12 @@ static struct ip6t_match eui64_match = {
 
 static int __init ip6t_eui64_init(void)
 {
-	return ip6t_register_match(&eui64_match);
+	return xt_register_match(&eui64_match);
 }
 
 static void __exit ip6t_eui64_fini(void)
 {
-	ip6t_unregister_match(&eui64_match);
+	xt_unregister_match(&eui64_match);
 }
 
 module_init(ip6t_eui64_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_frag.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_frag.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_frag.c
@@ -14,6 +14,7 @@
 #include <net/checksum.h>
 #include <net/ipv6.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
@@ -135,8 +136,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_match frag_match = {
+static struct xt_match frag_match = {
 	.name		= "frag",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_frag),
 	.checkentry	= checkentry,
@@ -145,12 +147,12 @@ static struct ip6t_match frag_match = {
 
 static int __init ip6t_frag_init(void)
 {
-	return ip6t_register_match(&frag_match);
+	return xt_register_match(&frag_match);
 }
 
 static void __exit ip6t_frag_fini(void)
 {
-	ip6t_unregister_match(&frag_match);
+	xt_unregister_match(&frag_match);
 }
 
 module_init(ip6t_frag_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_hbh.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_hbh.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_hbh.c
@@ -16,6 +16,7 @@
 
 #include <asm/byteorder.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_hl.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_hl.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_hl.c
@@ -8,11 +8,12 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/ipv6.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
 #include <linux/netfilter_ipv6/ip6t_hl.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
 MODULE_DESCRIPTION("IP tables Hop Limit matching module");
@@ -48,8 +49,9 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static struct ip6t_match hl_match = {
+static struct xt_match hl_match = {
 	.name		= "hl",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_hl_info),
 	.me		= THIS_MODULE,
@@ -57,13 +59,12 @@ static struct ip6t_match hl_match = {
 
 static int __init ip6t_hl_init(void)
 {
-	return ip6t_register_match(&hl_match);
+	return xt_register_match(&hl_match);
 }
 
 static void __exit ip6t_hl_fini(void)
 {
-	ip6t_unregister_match(&hl_match);
-
+	xt_unregister_match(&hl_match);
 }
 
 module_init(ip6t_hl_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_ipv6header.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_ipv6header.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -18,6 +18,7 @@
 #include <net/checksum.h>
 #include <net/ipv6.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
@@ -140,8 +141,9 @@ ipv6header_checkentry(const char *tablen
 	return 1;
 }
 
-static struct ip6t_match ip6t_ipv6header_match = {
+static struct xt_match ip6t_ipv6header_match = {
 	.name		= "ipv6header",
+	.family		= AF_INET6,
 	.match		= &ipv6header_match,
 	.matchsize	= sizeof(struct ip6t_ipv6header_info),
 	.checkentry	= &ipv6header_checkentry,
@@ -151,12 +153,12 @@ static struct ip6t_match ip6t_ipv6header
 
 static int __init ipv6header_init(void)
 {
-	return ip6t_register_match(&ip6t_ipv6header_match);
+	return xt_register_match(&ip6t_ipv6header_match);
 }
 
 static void __exit ipv6header_exit(void)
 {
-	ip6t_unregister_match(&ip6t_ipv6header_match);
+	xt_unregister_match(&ip6t_ipv6header_match);
 }
 
 module_init(ipv6header_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_owner.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_owner.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_owner.c
@@ -16,6 +16,7 @@
 
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("IP6 tables owner matching module");
@@ -69,8 +70,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_match owner_match = {
+static struct xt_match owner_match = {
 	.name		= "owner",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_owner_info),
 	.hooks		= (1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING),
@@ -80,12 +82,12 @@ static struct ip6t_match owner_match = {
 
 static int __init ip6t_owner_init(void)
 {
-	return ip6t_register_match(&owner_match);
+	return xt_register_match(&owner_match);
 }
 
 static void __exit ip6t_owner_fini(void)
 {
-	ip6t_unregister_match(&owner_match);
+	xt_unregister_match(&owner_match);
 }
 
 module_init(ip6t_owner_init);
Index: linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_rt.c
===================================================================
--- linux-2.6.20-rc5.orig/net/ipv6/netfilter/ip6t_rt.c
+++ linux-2.6.20-rc5/net/ipv6/netfilter/ip6t_rt.c
@@ -16,6 +16,7 @@
 
 #include <asm/byteorder.h>
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_rt.h>
 
@@ -221,8 +222,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_match rt_match = {
+static struct xt_match rt_match = {
 	.name		= "rt",
+	.family		= AF_INET6,
 	.match		= match,
 	.matchsize	= sizeof(struct ip6t_rt),
 	.checkentry	= checkentry,
@@ -231,12 +233,12 @@ static struct ip6t_match rt_match = {
 
 static int __init ip6t_rt_init(void)
 {
-	return ip6t_register_match(&rt_match);
+	return xt_register_match(&rt_match);
 }
 
 static void __exit ip6t_rt_fini(void)
 {
-	ip6t_unregister_match(&rt_match);
+	xt_unregister_match(&rt_match);
 }
 
 module_init(ip6t_rt_init);
