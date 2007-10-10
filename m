From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Add ip6t_ aliases
Date: Wed, 10 Oct 2007 13:44:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, davem@davemloft.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59006 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbXJJLou (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:44:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


I think this latecomer patch should go into 2.6.24.

===

Add missing ip6t_modulename aliases.

The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
otherwise you will get

	ip6tables: No chain/target/match by that name

when xt_<modulename> is not already loaded.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_CLASSIFY.c  |    1 +
 net/netfilter/xt_CONNMARK.c  |    1 +
 net/netfilter/xt_NOTRACK.c   |    1 +
 net/netfilter/xt_connbytes.c |    1 +
 net/netfilter/xt_connmark.c  |    1 +
 net/netfilter/xt_conntrack.c |    1 +
 net/netfilter/xt_dccp.c      |    1 +
 net/netfilter/xt_sctp.c      |    1 +
 net/netfilter/xt_tcpmss.c    |    1 +
 9 files changed, 9 insertions(+)

Index: linux-2.6.23/net/netfilter/xt_CLASSIFY.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_CLASSIFY.c
+++ linux-2.6.23/net/netfilter/xt_CLASSIFY.c
@@ -24,6 +24,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@tr
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("iptables qdisc classification target module");
 MODULE_ALIAS("ipt_CLASSIFY");
+MODULE_ALIAS("ip6t_CLASSIFY");
 
 static unsigned int
 target(struct sk_buff **pskb,
Index: linux-2.6.23/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6.23/net/netfilter/xt_CONNMARK.c
@@ -27,6 +27,7 @@ MODULE_AUTHOR("Henrik Nordstrom <hno@mar
 MODULE_DESCRIPTION("IP tables CONNMARK matching module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_CONNMARK");
+MODULE_ALIAS("ip6t_CONNMARK");
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
Index: linux-2.6.23/net/netfilter/xt_NOTRACK.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_NOTRACK.c
+++ linux-2.6.23/net/netfilter/xt_NOTRACK.c
@@ -9,6 +9,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NOTRACK");
+MODULE_ALIAS("ip6t_NOTRACK");
 
 static unsigned int
 target(struct sk_buff **pskb,
Index: linux-2.6.23/net/netfilter/xt_connbytes.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6.23/net/netfilter/xt_connbytes.c
@@ -14,6 +14,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables match for matching number of pkts/bytes per connection");
 MODULE_ALIAS("ipt_connbytes");
+MODULE_ALIAS("ip6t_connbytes");
 
 static bool
 match(const struct sk_buff *skb,
Index: linux-2.6.23/net/netfilter/xt_connmark.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_connmark.c
+++ linux-2.6.23/net/netfilter/xt_connmark.c
@@ -29,6 +29,7 @@ MODULE_AUTHOR("Henrik Nordstrom <hno@mar
 MODULE_DESCRIPTION("IP tables connmark match module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
+MODULE_ALIAS("ip6t_connmark");
 
 static bool
 match(const struct sk_buff *skb,
Index: linux-2.6.23/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6.23/net/netfilter/xt_conntrack.c
@@ -18,6 +18,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables connection tracking match module");
 MODULE_ALIAS("ipt_conntrack");
+MODULE_ALIAS("ip6t_conntrack");
 
 static bool
 match(const struct sk_buff *skb,
Index: linux-2.6.23/net/netfilter/xt_dccp.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_dccp.c
+++ linux-2.6.23/net/netfilter/xt_dccp.c
@@ -24,6 +24,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Match for DCCP protocol packets");
 MODULE_ALIAS("ipt_dccp");
+MODULE_ALIAS("ip6t_dccp");
 
 #define DCCHECK(cond, option, flag, invflag) (!((flag) & (option)) \
 				  || (!!((invflag) & (option)) ^ (cond)))
Index: linux-2.6.23/net/netfilter/xt_sctp.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_sctp.c
+++ linux-2.6.23/net/netfilter/xt_sctp.c
@@ -13,6 +13,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kiran Kumar Immidi");
 MODULE_DESCRIPTION("Match for SCTP protocol packets");
 MODULE_ALIAS("ipt_sctp");
+MODULE_ALIAS("ip6t_sctp");
 
 #ifdef DEBUG_SCTP
 #define duprintf(format, args...) printk(format , ## args)
Index: linux-2.6.23/net/netfilter/xt_tcpmss.c
===================================================================
--- linux-2.6.23.orig/net/netfilter/xt_tcpmss.c
+++ linux-2.6.23/net/netfilter/xt_tcpmss.c
@@ -22,6 +22,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables TCP MSS match module");
 MODULE_ALIAS("ipt_tcpmss");
+MODULE_ALIAS("ip6t_tcpmss");
 
 static bool
 match(const struct sk_buff *skb,
