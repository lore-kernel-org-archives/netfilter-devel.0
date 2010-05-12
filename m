From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/2] netfilter: cleanup printk messages
Date: Wed, 12 May 2010 09:29:56 -0700
Message-ID: <20100512163030.114488325@vyatta.com>
References: <20100512162954.316178344@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:59575 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab0ELQsH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 May 2010 12:48:07 -0400
Content-Disposition: inline; filename=netfilter-msg.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure all printk messages have a severity level.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


---
 net/ipv4/netfilter/arp_tables.c                |    4 ++--
 net/ipv4/netfilter/ip_tables.c                 |    2 +-
 net/ipv4/netfilter/iptable_filter.c            |    2 +-
 net/ipv4/netfilter/nf_conntrack_ipv4.mod.c     |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +++++-----
 net/ipv4/netfilter/nf_nat_h323.c               |   16 ++++++++--------
 net/ipv4/netfilter/nf_nat_h323.mod.c           |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |   16 ++++++++--------
 net/ipv4/netfilter/nf_nat_snmp_basic.mod.c     |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    4 ++--
 net/ipv6/netfilter/ip6_tables.c                |    2 +-
 net/ipv6/netfilter/ip6table_filter.c           |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c           |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   14 +++++++-------
 net/netfilter/nf_conntrack_amanda.c            |    2 +-
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/netfilter/nf_conntrack_ftp.c               |    4 ++--
 net/netfilter/nf_conntrack_h323_main.c         |    6 +++---
 net/netfilter/nf_conntrack_irc.c               |    4 ++--
 net/netfilter/nf_conntrack_netlink.c           |   12 ++++++------
 net/netfilter/nf_conntrack_proto_sctp.c        |    4 ++--
 net/netfilter/nf_conntrack_sip.c               |    4 ++--
 net/netfilter/nf_conntrack_standalone.c        |    2 +-
 net/netfilter/nf_conntrack_tftp.c              |    4 ++--
 net/netfilter/nf_internals.h                   |    2 +-
 net/netfilter/nfnetlink.c                      |    4 ++--
 net/netfilter/nfnetlink_log.c                  |    4 ++--
 27 files changed, 67 insertions(+), 67 deletions(-)

--- a/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:26.447006714 -0700
+++ b/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:44.287371327 -0700
@@ -108,7 +108,7 @@ static int amanda_help(struct sk_buff *s
 	dataoff = protoff + sizeof(struct udphdr);
 	if (dataoff >= skb->len) {
 		if (net_ratelimit())
-			printk("amanda_help: skblen = %u\n", skb->len);
+			printk(KERN_ERR "amanda_help: skblen = %u\n", skb->len);
 		return NF_ACCEPT;
 	}
 
--- a/net/netfilter/nf_conntrack_core.c	2010-05-12 09:28:26.437007901 -0700
+++ b/net/netfilter/nf_conntrack_core.c	2010-05-12 09:28:44.287371327 -0700
@@ -1335,7 +1335,7 @@ static int nf_conntrack_init_init_net(vo
 	}
 	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
 
-	printk("nf_conntrack version %s (%u buckets, %d max)\n",
+	printk(KERN_INFO "nf_conntrack version %s (%u buckets, %d max)\n",
 	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
 	       nf_conntrack_max);
 
--- a/net/netfilter/nf_conntrack_ftp.c	2010-05-12 09:28:26.507006610 -0700
+++ b/net/netfilter/nf_conntrack_ftp.c	2010-05-12 09:28:44.307404481 -0700
@@ -573,8 +573,8 @@ static int __init nf_conntrack_ftp_init(
 				 ftp[i][j].tuple.src.l3num, ports[i]);
 			ret = nf_conntrack_helper_register(&ftp[i][j]);
 			if (ret) {
-				printk("nf_ct_ftp: failed to register helper "
-				       " for pf: %d port: %d\n",
+				printk(KERN_ERR "nf_ct_ftp: failed to register"
+				       " helper for pf: %d port: %d\n",
 					ftp[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_ftp_fini();
 				return ret;
--- a/net/netfilter/nf_conntrack_h323_main.c	2010-05-12 09:28:26.487079953 -0700
+++ b/net/netfilter/nf_conntrack_h323_main.c	2010-05-12 09:28:44.327402516 -0700
@@ -607,7 +607,7 @@ static int h245_help(struct sk_buff *skb
       drop:
 	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
-		printk("nf_ct_h245: packet dropped\n");
+		pr_info("nf_ct_h245: packet dropped\n");
 	return NF_DROP;
 }
 
@@ -1152,7 +1152,7 @@ static int q931_help(struct sk_buff *skb
       drop:
 	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
-		printk("nf_ct_q931: packet dropped\n");
+		pr_info("nf_ct_q931: packet dropped\n");
 	return NF_DROP;
 }
 
@@ -1727,7 +1727,7 @@ static int ras_help(struct sk_buff *skb,
       drop:
 	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
-		printk("nf_ct_ras: packet dropped\n");
+		pr_info("nf_ct_ras: packet dropped\n");
 	return NF_DROP;
 }
 
--- a/net/netfilter/nf_conntrack_irc.c	2010-05-12 09:28:26.477055529 -0700
+++ b/net/netfilter/nf_conntrack_irc.c	2010-05-12 09:28:44.347429904 -0700
@@ -235,7 +235,7 @@ static int __init nf_conntrack_irc_init(
 	char *tmpname;
 
 	if (max_dcc_channels < 1) {
-		printk("nf_ct_irc: max_dcc_channels must not be zero\n");
+		printk(KERN_ERR "nf_ct_irc: max_dcc_channels must not be zero\n");
 		return -EINVAL;
 	}
 
@@ -267,7 +267,7 @@ static int __init nf_conntrack_irc_init(
 
 		ret = nf_conntrack_helper_register(&irc[i]);
 		if (ret) {
-			printk("nf_ct_irc: failed to register helper "
+			printk(KERN_ERR "nf_ct_irc: failed to register helper "
 			       "for pf: %u port: %u\n",
 			       irc[i].tuple.src.l3num, ports[i]);
 			nf_conntrack_irc_fini();
--- a/net/netfilter/nf_conntrack_netlink.c	2010-05-12 09:28:26.517058016 -0700
+++ b/net/netfilter/nf_conntrack_netlink.c	2010-05-12 09:28:44.367368088 -0700
@@ -2057,29 +2057,29 @@ static int __init ctnetlink_init(void)
 {
 	int ret;
 
-	printk("ctnetlink v%s: registering with nfnetlink.\n", version);
+	pr_info("ctnetlink v%s: registering with nfnetlink.\n", version);
 	ret = nfnetlink_subsys_register(&ctnl_subsys);
 	if (ret < 0) {
-		printk("ctnetlink_init: cannot register with nfnetlink.\n");
+		pr_err("ctnetlink_init: cannot register with nfnetlink.\n");
 		goto err_out;
 	}
 
 	ret = nfnetlink_subsys_register(&ctnl_exp_subsys);
 	if (ret < 0) {
-		printk("ctnetlink_init: cannot register exp with nfnetlink.\n");
+		pr_err("ctnetlink_init: cannot register exp with nfnetlink.\n");
 		goto err_unreg_subsys;
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ret = nf_conntrack_register_notifier(&ctnl_notifier);
 	if (ret < 0) {
-		printk("ctnetlink_init: cannot register notifier.\n");
+		pr_err("ctnetlink_init: cannot register notifier.\n");
 		goto err_unreg_exp_subsys;
 	}
 
 	ret = nf_ct_expect_register_notifier(&ctnl_notifier_exp);
 	if (ret < 0) {
-		printk("ctnetlink_init: cannot expect register notifier.\n");
+		pr_err("ctnetlink_init: cannot expect register notifier.\n");
 		goto err_unreg_notifier;
 	}
 #endif
@@ -2100,7 +2100,7 @@ err_out:
 
 static void __exit ctnetlink_exit(void)
 {
-	printk("ctnetlink: unregistering from nfnetlink.\n");
+	pr_info("ctnetlink: unregistering from nfnetlink.\n");
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(&ctnl_notifier_exp);
--- a/net/netfilter/nf_conntrack_proto_sctp.c	2010-05-12 09:28:26.457036269 -0700
+++ b/net/netfilter/nf_conntrack_proto_sctp.c	2010-05-12 09:28:44.387023109 -0700
@@ -717,12 +717,12 @@ static int __init nf_conntrack_proto_sct
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_sctp4);
 	if (ret) {
-		printk("nf_conntrack_l4proto_sctp4: protocol register failed\n");
+		pr_err("nf_conntrack_l4proto_sctp4: protocol register failed\n");
 		goto out;
 	}
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_sctp6);
 	if (ret) {
-		printk("nf_conntrack_l4proto_sctp6: protocol register failed\n");
+		pr_err("nf_conntrack_l4proto_sctp6: protocol register failed\n");
 		goto cleanup_sctp4;
 	}
 
--- a/net/netfilter/nf_conntrack_sip.c	2010-05-12 09:28:26.527053124 -0700
+++ b/net/netfilter/nf_conntrack_sip.c	2010-05-12 09:28:44.396725053 -0700
@@ -1549,8 +1549,8 @@ static int __init nf_conntrack_sip_init(
 
 			ret = nf_conntrack_helper_register(&sip[i][j]);
 			if (ret) {
-				printk("nf_ct_sip: failed to register helper "
-				       "for pf: %u port: %u\n",
+				printk(KERN_ERR "nf_ct_sip: failed to register"
+				       " helper for pf: %u port: %u\n",
 				       sip[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_sip_fini();
 				return ret;
--- a/net/netfilter/nf_conntrack_standalone.c	2010-05-12 09:28:26.547029821 -0700
+++ b/net/netfilter/nf_conntrack_standalone.c	2010-05-12 09:28:44.407025584 -0700
@@ -446,7 +446,7 @@ out_kmemdup:
 	if (net_eq(net, &init_net))
 		unregister_sysctl_table(nf_ct_netfilter_header);
 out:
-	printk("nf_conntrack: can't register to sysctl.\n");
+	printk(KERN_ERR "nf_conntrack: can't register to sysctl.\n");
 	return -ENOMEM;
 }
 
--- a/net/netfilter/nf_conntrack_tftp.c	2010-05-12 09:28:26.497031450 -0700
+++ b/net/netfilter/nf_conntrack_tftp.c	2010-05-12 09:28:44.417029519 -0700
@@ -138,8 +138,8 @@ static int __init nf_conntrack_tftp_init
 
 			ret = nf_conntrack_helper_register(&tftp[i][j]);
 			if (ret) {
-				printk("nf_ct_tftp: failed to register helper "
-				       "for pf: %u port: %u\n",
+				printk(KERN_ERR "nf_ct_tftp: failed to register"
+				       " helper for pf: %u port: %u\n",
 					tftp[i][j].tuple.src.l3num, ports[i]);
 				nf_conntrack_tftp_fini();
 				return ret;
--- a/net/netfilter/nf_internals.h	2010-05-12 09:28:26.537005930 -0700
+++ b/net/netfilter/nf_internals.h	2010-05-12 09:28:44.427024013 -0700
@@ -6,7 +6,7 @@
 #include <linux/netdevice.h>
 
 #ifdef CONFIG_NETFILTER_DEBUG
-#define NFDEBUG(format, args...)  printk(format , ## args)
+#define NFDEBUG(format, args...)  printk(KERN_DEBUG format , ## args)
 #else
 #define NFDEBUG(format, args...)
 #endif
--- a/net/netfilter/nfnetlink.c	2010-05-12 09:28:26.507006610 -0700
+++ b/net/netfilter/nfnetlink.c	2010-05-12 09:28:44.437029564 -0700
@@ -212,13 +212,13 @@ static struct pernet_operations nfnetlin
 
 static int __init nfnetlink_init(void)
 {
-	printk("Netfilter messages via NETLINK v%s.\n", nfversion);
+	pr_info("Netfilter messages via NETLINK v%s.\n", nfversion);
 	return register_pernet_subsys(&nfnetlink_net_ops);
 }
 
 static void __exit nfnetlink_exit(void)
 {
-	printk("Removing netfilter NETLINK layer.\n");
+	pr_info("Removing netfilter NETLINK layer.\n");
 	unregister_pernet_subsys(&nfnetlink_net_ops);
 }
 module_init(nfnetlink_init);
--- a/net/netfilter/nfnetlink_log.c	2010-05-12 09:28:26.467014250 -0700
+++ b/net/netfilter/nfnetlink_log.c	2010-05-12 09:28:44.446716840 -0700
@@ -297,7 +297,7 @@ nfulnl_alloc_skb(unsigned int inst_size,
 	n = max(inst_size, pkt_size);
 	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
-		PRINTR("nfnetlink_log: can't alloc whole buffer (%u bytes)\n",
+		pr_notice("nfnetlink_log: can't alloc whole buffer (%u bytes)\n",
 			inst_size);
 
 		if (n > pkt_size) {
@@ -306,7 +306,7 @@ nfulnl_alloc_skb(unsigned int inst_size,
 
 			skb = alloc_skb(pkt_size, GFP_ATOMIC);
 			if (!skb)
-				PRINTR("nfnetlink_log: can't even alloc %u "
+				pr_err("nfnetlink_log: can't even alloc %u "
 				       "bytes\n", pkt_size);
 		}
 	}
--- a/net/ipv4/netfilter/arp_tables.c	2010-05-12 09:28:42.927371402 -0700
+++ b/net/ipv4/netfilter/arp_tables.c	2010-05-12 09:29:04.837346678 -0700
@@ -222,7 +222,7 @@ static unsigned int
 arpt_error(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("arp_tables: error: '%s'\n",
+		pr_err("arp_tables: error: '%s'\n",
 		       (const char *)par->targinfo);
 
 	return NF_DROP;
@@ -385,7 +385,7 @@ static int mark_source_chains(const stru
 			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_ARP_NUMHOOKS)) {
-				printk("arptables: loop hook %u pos %u %08X.\n",
+				pr_notice("arptables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
--- a/net/ipv4/netfilter/ip_tables.c	2010-05-12 09:28:42.927371402 -0700
+++ b/net/ipv4/netfilter/ip_tables.c	2010-05-12 09:29:04.837346678 -0700
@@ -481,7 +481,7 @@ mark_source_chains(const struct xt_table
 			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
+				pr_err("iptables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
--- a/net/ipv4/netfilter/iptable_filter.c	2010-05-12 09:28:26.367056476 -0700
+++ b/net/ipv4/netfilter/iptable_filter.c	2010-05-12 09:29:04.837346678 -0700
@@ -89,7 +89,7 @@ static int __init iptable_filter_init(vo
 	int ret;
 
 	if (forward < 0 || forward > NF_MAX_VERDICT) {
-		printk("iptables forward must be 0 or 1\n");
+		pr_err("iptables forward must be 0 or 1\n");
 		return -EINVAL;
 	}
 
--- a/net/ipv4/netfilter/nf_conntrack_ipv4.mod.c	2010-05-12 09:28:26.387062224 -0700
+++ b/net/ipv4/netfilter/nf_conntrack_ipv4.mod.c	2010-05-12 09:29:04.897403181 -0700
@@ -93,4 +93,4 @@ __attribute__((section(".modinfo"))) =
 "depends=nf_conntrack,nf_defrag_ipv4";
 
 
-MODULE_INFO(srcversion, "EFDB1F0E6E638976C941D6A");
+MODULE_INFO(srcversion, "08B879A69F4DA59EB9557B5");
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2010-05-12 09:28:26.327056684 -0700
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2010-05-12 09:29:04.857399992 -0700
@@ -382,32 +382,32 @@ static int __init nf_conntrack_l3proto_i
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_tcp4);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register tcp.\n");
+		pr_err("nf_conntrack_ipv4: can't register tcp.\n");
 		goto cleanup_sockopt;
 	}
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp4);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register udp.\n");
+		pr_err("nf_conntrack_ipv4: can't register udp.\n");
 		goto cleanup_tcp;
 	}
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmp);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register icmp.\n");
+		pr_err("nf_conntrack_ipv4: can't register icmp.\n");
 		goto cleanup_udp;
 	}
 
 	ret = nf_conntrack_l3proto_register(&nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register ipv4\n");
+		pr_err("nf_conntrack_ipv4: can't register ipv4\n");
 		goto cleanup_icmp;
 	}
 
 	ret = nf_register_hooks(ipv4_conntrack_ops,
 				ARRAY_SIZE(ipv4_conntrack_ops));
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register hooks.\n");
+		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
 		goto cleanup_ipv4;
 	}
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
--- a/net/ipv4/netfilter/nf_nat_h323.c	2010-05-12 09:28:26.377013348 -0700
+++ b/net/ipv4/netfilter/nf_nat_h323.c	2010-05-12 09:29:04.867403241 -0700
@@ -43,7 +43,7 @@ static int set_addr(struct sk_buff *skb,
 					      addroff, sizeof(buf),
 					      (char *) &buf, sizeof(buf))) {
 			if (net_ratelimit())
-				printk("nf_nat_h323: nf_nat_mangle_tcp_packet"
+				pr_notice("nf_nat_h323: nf_nat_mangle_tcp_packet"
 				       " error\n");
 			return -1;
 		}
@@ -59,7 +59,7 @@ static int set_addr(struct sk_buff *skb,
 					      addroff, sizeof(buf),
 					      (char *) &buf, sizeof(buf))) {
 			if (net_ratelimit())
-				printk("nf_nat_h323: nf_nat_mangle_udp_packet"
+				pr_notice("nf_nat_h323: nf_nat_mangle_udp_packet"
 				       " error\n");
 			return -1;
 		}
@@ -215,7 +215,7 @@ static int nat_rtp_rtcp(struct sk_buff *
 	/* Run out of expectations */
 	if (i >= H323_RTP_CHANNEL_MAX) {
 		if (net_ratelimit())
-			printk("nf_nat_h323: out of expectations\n");
+			pr_notice("nf_nat_h323: out of expectations\n");
 		return 0;
 	}
 
@@ -234,7 +234,7 @@ static int nat_rtp_rtcp(struct sk_buff *
 
 	if (nated_port == 0) {	/* No port available */
 		if (net_ratelimit())
-			printk("nf_nat_h323: out of RTP ports\n");
+			pr_notice("nf_nat_h323: out of RTP ports\n");
 		return 0;
 	}
 
@@ -291,7 +291,7 @@ static int nat_t120(struct sk_buff *skb,
 
 	if (nated_port == 0) {	/* No port available */
 		if (net_ratelimit())
-			printk("nf_nat_h323: out of TCP ports\n");
+			pr_notice("nf_nat_h323: out of TCP ports\n");
 		return 0;
 	}
 
@@ -341,7 +341,7 @@ static int nat_h245(struct sk_buff *skb,
 
 	if (nated_port == 0) {	/* No port available */
 		if (net_ratelimit())
-			printk("nf_nat_q931: out of TCP ports\n");
+			pr_notice("nf_nat_q931: out of TCP ports\n");
 		return 0;
 	}
 
@@ -425,7 +425,7 @@ static int nat_q931(struct sk_buff *skb,
 
 	if (nated_port == 0) {	/* No port available */
 		if (net_ratelimit())
-			printk("nf_nat_ras: out of TCP ports\n");
+			pr_notice("nf_nat_ras: out of TCP ports\n");
 		return 0;
 	}
 
@@ -507,7 +507,7 @@ static int nat_callforwarding(struct sk_
 
 	if (nated_port == 0) {	/* No port available */
 		if (net_ratelimit())
-			printk("nf_nat_q931: out of TCP ports\n");
+			pr_notice("nf_nat_q931: out of TCP ports\n");
 		return 0;
 	}
 
--- a/net/ipv4/netfilter/nf_nat_h323.mod.c	2010-05-12 09:28:26.377013348 -0700
+++ b/net/ipv4/netfilter/nf_nat_h323.mod.c	2010-05-12 09:29:04.907402864 -0700
@@ -47,4 +47,4 @@ __attribute__((section(".modinfo"))) =
 "depends=nf_conntrack,nf_conntrack_h323,nf_nat";
 
 
-MODULE_INFO(srcversion, "48BB6B7E63B6F772BFA1748");
+MODULE_INFO(srcversion, "AD1DC1ED755807AA042D5CA");
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c	2010-05-12 09:28:26.347034535 -0700
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c	2010-05-12 09:29:04.877403963 -0700
@@ -401,7 +401,7 @@ static unsigned char asn1_octets_decode(
 	*octets = kmalloc(eoc - ctx->pointer, GFP_ATOMIC);
 	if (*octets == NULL) {
 		if (net_ratelimit())
-			printk("OOM in bsalg (%d)\n", __LINE__);
+			pr_notice("OOM in bsalg (%d)\n", __LINE__);
 		return 0;
 	}
 
@@ -452,7 +452,7 @@ static unsigned char asn1_oid_decode(str
 	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
 	if (*oid == NULL) {
 		if (net_ratelimit())
-			printk("OOM in bsalg (%d)\n", __LINE__);
+			pr_notice("OOM in bsalg (%d)\n", __LINE__);
 		return 0;
 	}
 
@@ -729,7 +729,7 @@ static unsigned char snmp_object_decode(
 			if (*obj == NULL) {
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			(*obj)->syntax.l[0] = l;
@@ -746,7 +746,7 @@ static unsigned char snmp_object_decode(
 				kfree(p);
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			memcpy((*obj)->syntax.c, p, len);
@@ -761,7 +761,7 @@ static unsigned char snmp_object_decode(
 			if (*obj == NULL) {
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			if (!asn1_null_decode(ctx, end)) {
@@ -782,7 +782,7 @@ static unsigned char snmp_object_decode(
 				kfree(lp);
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			memcpy((*obj)->syntax.ul, lp, len);
@@ -803,7 +803,7 @@ static unsigned char snmp_object_decode(
 				kfree(p);
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			memcpy((*obj)->syntax.uc, p, len);
@@ -821,7 +821,7 @@ static unsigned char snmp_object_decode(
 			if (*obj == NULL) {
 				kfree(id);
 				if (net_ratelimit())
-					printk("OOM in bsalg (%d)\n", __LINE__);
+					pr_notice("OOM in bsalg (%d)\n", __LINE__);
 				return 0;
 			}
 			(*obj)->syntax.ul[0] = ul;
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.mod.c	2010-05-12 09:28:26.317061313 -0700
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.mod.c	2010-05-12 09:29:04.917396747 -0700
@@ -42,4 +42,4 @@ __attribute__((section(".modinfo"))) =
 "depends=nf_conntrack";
 
 
-MODULE_INFO(srcversion, "7FA04207FEE53E706985922");
+MODULE_INFO(srcversion, "16F24BA3C5A0A51AFEB0592");
--- a/net/ipv4/netfilter/nf_nat_standalone.c	2010-05-12 09:28:26.357060122 -0700
+++ b/net/ipv4/netfilter/nf_nat_standalone.c	2010-05-12 09:29:04.887396025 -0700
@@ -293,12 +293,12 @@ static int __init nf_nat_standalone_init
 #endif
 	ret = nf_nat_rule_init();
 	if (ret < 0) {
-		printk("nf_nat_init: can't setup rules.\n");
+		pr_err("nf_nat_init: can't setup rules.\n");
 		goto cleanup_decode_session;
 	}
 	ret = nf_register_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
 	if (ret < 0) {
-		printk("nf_nat_init: can't register hooks.\n");
+		pr_err("nf_nat_init: can't register hooks.\n");
 		goto cleanup_rule_init;
 	}
 	return ret;
--- a/net/ipv6/netfilter/ip6_tables.c	2010-05-12 09:28:42.927371402 -0700
+++ b/net/ipv6/netfilter/ip6_tables.c	2010-05-12 09:29:09.207943911 -0700
@@ -495,7 +495,7 @@ mark_source_chains(const struct xt_table
 			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
+				pr_err("iptables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
--- a/net/ipv6/netfilter/ip6table_filter.c	2010-05-12 09:28:26.287057201 -0700
+++ b/net/ipv6/netfilter/ip6table_filter.c	2010-05-12 09:29:09.207943911 -0700
@@ -81,7 +81,7 @@ static int __init ip6table_filter_init(v
 	int ret;
 
 	if (forward < 0 || forward > NF_MAX_VERDICT) {
-		printk("iptables forward must be 0 or 1\n");
+		pr_err("iptables forward must be 0 or 1\n");
 		return -EINVAL;
 	}
 
--- a/net/ipv6/netfilter/ip6table_mangle.c	2010-05-12 09:28:26.267035260 -0700
+++ b/net/ipv6/netfilter/ip6table_mangle.c	2010-05-12 09:29:09.227966963 -0700
@@ -43,7 +43,7 @@ ip6t_mangle_out(struct sk_buff *skb, con
 	if (skb->len < sizeof(struct iphdr) ||
 	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
 		if (net_ratelimit())
-			printk("ip6t_hook: happy cracking.\n");
+			pr_warning("ip6t_hook: happy cracking.\n");
 		return NF_ACCEPT;
 	}
 #endif
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2010-05-12 09:28:26.267035260 -0700
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2010-05-12 09:29:09.247970888 -0700
@@ -280,7 +280,7 @@ static unsigned int ipv6_conntrack_local
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct ipv6hdr)) {
 		if (net_ratelimit())
-			printk("ipv6_conntrack_local: packet too short\n");
+			pr_notice("ipv6_conntrack_local: packet too short\n");
 		return NF_ACCEPT;
 	}
 	return __ipv6_conntrack_in(dev_net(out), hooknum, skb, okfn);
@@ -406,37 +406,37 @@ static int __init nf_conntrack_l3proto_i
 
 	ret = nf_ct_frag6_init();
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't initialize frag6.\n");
+		pr_err("nf_conntrack_ipv6: can't initialize frag6.\n");
 		return ret;
 	}
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_tcp6);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register tcp.\n");
+		pr_err("nf_conntrack_ipv6: can't register tcp.\n");
 		goto cleanup_frag6;
 	}
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_udp6);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register udp.\n");
+		pr_err("nf_conntrack_ipv6: can't register udp.\n");
 		goto cleanup_tcp;
 	}
 
 	ret = nf_conntrack_l4proto_register(&nf_conntrack_l4proto_icmpv6);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register icmpv6.\n");
+		pr_err("nf_conntrack_ipv6: can't register icmpv6.\n");
 		goto cleanup_udp;
 	}
 
 	ret = nf_conntrack_l3proto_register(&nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register ipv6\n");
+		pr_err("nf_conntrack_ipv6: can't register ipv6\n");
 		goto cleanup_icmpv6;
 	}
 
 	ret = nf_register_hooks(ipv6_conntrack_ops,
 				ARRAY_SIZE(ipv6_conntrack_ops));
 	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register pre-routing defrag "
+		pr_err("nf_conntrack_ipv6: can't register pre-routing defrag "
 		       "hook.\n");
 		goto cleanup_ipv6;
 	}


