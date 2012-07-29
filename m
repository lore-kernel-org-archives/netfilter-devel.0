From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] netfilter: PTR_RET can be used
Date: Sun, 29 Jul 2012 08:45:50 +0800
Message-ID: <20120729004550.GA7049@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47942 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2G2Apy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 20:45:54 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This quiets the coccinelle warnings:

net/bridge/netfilter/ebtable_filter.c:107:1-3: WARNING: PTR_RET can be used
net/bridge/netfilter/ebtable_nat.c:107:1-3: WARNING: PTR_RET can be used
net/ipv6/netfilter/ip6table_filter.c:65:1-3: WARNING: PTR_RET can be used
net/ipv6/netfilter/ip6table_mangle.c:100:1-3: WARNING: PTR_RET can be used
net/ipv6/netfilter/ip6table_raw.c:44:1-3: WARNING: PTR_RET can be used
net/ipv6/netfilter/ip6table_security.c:62:1-3: WARNING: PTR_RET can be used
net/ipv4/netfilter/iptable_filter.c:72:1-3: WARNING: PTR_RET can be used
net/ipv4/netfilter/iptable_mangle.c:107:1-3: WARNING: PTR_RET can be used
net/ipv4/netfilter/iptable_raw.c:51:1-3: WARNING: PTR_RET can be used
net/ipv4/netfilter/iptable_security.c:70:1-3: WARNING: PTR_RET can be used

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 net/bridge/netfilter/ebtable_filter.c  |    4 +---
 net/bridge/netfilter/ebtable_nat.c     |    4 +---
 net/ipv4/netfilter/iptable_filter.c    |    4 +---
 net/ipv4/netfilter/iptable_mangle.c    |    4 +---
 net/ipv4/netfilter/iptable_raw.c       |    4 +---
 net/ipv4/netfilter/iptable_security.c  |    5 +----
 net/ipv6/netfilter/ip6table_filter.c   |    4 +---
 net/ipv6/netfilter/ip6table_mangle.c   |    4 +---
 net/ipv6/netfilter/ip6table_raw.c      |    4 +---
 net/ipv6/netfilter/ip6table_security.c |    5 +----
 10 files changed, 10 insertions(+), 32 deletions(-)

--- linux.orig/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:09.703759534 +0800
+++ linux/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:14.255759643 +0800
@@ -100,9 +100,7 @@ static struct nf_hook_ops ebt_ops_filter
 static int __net_init frame_filter_net_init(struct net *net)
 {
 	net->xt.frame_filter = ebt_register_table(net, &frame_filter);
-	if (IS_ERR(net->xt.frame_filter))
-		return PTR_ERR(net->xt.frame_filter);
-	return 0;
+	return PTR_RET(net->xt.frame_filter);
 }
 
 static void __net_exit frame_filter_net_exit(struct net *net)
--- linux.orig/net/bridge/netfilter/ebtable_nat.c	2012-07-29 08:41:09.671759534 +0800
+++ linux/net/bridge/netfilter/ebtable_nat.c	2012-07-29 08:41:14.255759643 +0800
@@ -100,9 +100,7 @@ static struct nf_hook_ops ebt_ops_nat[]
 static int __net_init frame_nat_net_init(struct net *net)
 {
 	net->xt.frame_nat = ebt_register_table(net, &frame_nat);
-	if (IS_ERR(net->xt.frame_nat))
-		return PTR_ERR(net->xt.frame_nat);
-	return 0;
+	return PTR_RET(net->xt.frame_nat);
 }
 
 static void __net_exit frame_nat_net_exit(struct net *net)
--- linux.orig/net/ipv4/netfilter/iptable_filter.c	2012-07-29 08:41:09.523759531 +0800
+++ linux/net/ipv4/netfilter/iptable_filter.c	2012-07-29 08:41:14.259759643 +0800
@@ -69,9 +69,7 @@ static int __net_init iptable_filter_net
 	net->ipv4.iptable_filter =
 		ipt_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_filter))
-		return PTR_ERR(net->ipv4.iptable_filter);
-	return 0;
+	return PTR_RET(net->ipv4.iptable_filter);
 }
 
 static void __net_exit iptable_filter_net_exit(struct net *net)
--- linux.orig/net/ipv4/netfilter/iptable_mangle.c	2012-07-29 08:41:09.495759530 +0800
+++ linux/net/ipv4/netfilter/iptable_mangle.c	2012-07-29 08:41:14.259759643 +0800
@@ -104,9 +104,7 @@ static int __net_init iptable_mangle_net
 	net->ipv4.iptable_mangle =
 		ipt_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_mangle))
-		return PTR_ERR(net->ipv4.iptable_mangle);
-	return 0;
+	return PTR_RET(net->ipv4.iptable_mangle);
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
--- linux.orig/net/ipv4/netfilter/iptable_raw.c	2012-07-29 08:41:09.467759529 +0800
+++ linux/net/ipv4/netfilter/iptable_raw.c	2012-07-29 08:41:14.259759643 +0800
@@ -48,9 +48,7 @@ static int __net_init iptable_raw_net_in
 	net->ipv4.iptable_raw =
 		ipt_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_raw))
-		return PTR_ERR(net->ipv4.iptable_raw);
-	return 0;
+	return PTR_RET(net->ipv4.iptable_raw);
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
--- linux.orig/net/ipv4/netfilter/iptable_security.c	2012-07-29 08:41:09.439759529 +0800
+++ linux/net/ipv4/netfilter/iptable_security.c	2012-07-29 08:41:14.259759643 +0800
@@ -66,10 +66,7 @@ static int __net_init iptable_security_n
 	net->ipv4.iptable_security =
 		ipt_register_table(net, &security_table, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_security))
-		return PTR_ERR(net->ipv4.iptable_security);
-
-	return 0;
+	return PTR_RET(net->ipv4.iptable_security);
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
--- linux.orig/net/ipv6/netfilter/ip6table_filter.c	2012-07-29 08:41:09.643759533 +0800
+++ linux/net/ipv6/netfilter/ip6table_filter.c	2012-07-29 08:41:14.259759643 +0800
@@ -61,9 +61,7 @@ static int __net_init ip6table_filter_ne
 	net->ipv6.ip6table_filter =
 		ip6t_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_filter))
-		return PTR_ERR(net->ipv6.ip6table_filter);
-	return 0;
+	return PTR_RET(net->ipv6.ip6table_filter);
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
--- linux.orig/net/ipv6/netfilter/ip6table_mangle.c	2012-07-29 08:41:09.615759532 +0800
+++ linux/net/ipv6/netfilter/ip6table_mangle.c	2012-07-29 08:41:14.259759643 +0800
@@ -97,9 +97,7 @@ static int __net_init ip6table_mangle_ne
 	net->ipv6.ip6table_mangle =
 		ip6t_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_mangle))
-		return PTR_ERR(net->ipv6.ip6table_mangle);
-	return 0;
+	return PTR_RET(net->ipv6.ip6table_mangle);
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
--- linux.orig/net/ipv6/netfilter/ip6table_raw.c	2012-07-29 08:41:09.583759532 +0800
+++ linux/net/ipv6/netfilter/ip6table_raw.c	2012-07-29 08:41:14.259759643 +0800
@@ -40,9 +40,7 @@ static int __net_init ip6table_raw_net_i
 	net->ipv6.ip6table_raw =
 		ip6t_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_raw))
-		return PTR_ERR(net->ipv6.ip6table_raw);
-	return 0;
+	return PTR_RET(net->ipv6.ip6table_raw);
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
--- linux.orig/net/ipv6/netfilter/ip6table_security.c	2012-07-29 08:41:09.555759531 +0800
+++ linux/net/ipv6/netfilter/ip6table_security.c	2012-07-29 08:41:14.259759643 +0800
@@ -58,10 +58,7 @@ static int __net_init ip6table_security_
 	net->ipv6.ip6table_security =
 		ip6t_register_table(net, &security_table, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_security))
-		return PTR_ERR(net->ipv6.ip6table_security);
-
-	return 0;
+	return PTR_RET(net->ipv6.ip6table_security);
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
