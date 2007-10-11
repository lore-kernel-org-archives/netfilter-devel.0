From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: x_tables: add missing ip6t_modulename aliases
Date: Thu, 11 Oct 2007 18:44:06 +0200 (MEST)
Message-ID: <20071011164353.31373.21835.sendpatchset@localhost.localdomain>
References: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64525 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXJKQoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:44:08 -0400
In-Reply-To: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: x_tables: add missing ip6t_modulename aliases

The patch will add MODULE_ALIAS("ip6t_<modulename>") where missing,
otherwise you will get

	ip6tables: No chain/target/match by that name

when xt_<modulename> is not already loaded.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3045023bc5004d09b4cba553e9df6e3d0f3fa6d9
tree ff50a2197669da3b377e44ceecb91c0b5d9e004c
parent c24af9fc1daa4e809ad2c5032d6504e57474bd1a
author Jan Engelhardt <jengelh@computergmbh.de> Thu, 11 Oct 2007 06:07:18 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 11 Oct 2007 06:07:18 +0200

 net/netfilter/xt_CLASSIFY.c  |    1 +
 net/netfilter/xt_CONNMARK.c  |    1 +
 net/netfilter/xt_NOTRACK.c   |    1 +
 net/netfilter/xt_connbytes.c |    1 +
 net/netfilter/xt_connmark.c  |    1 +
 net/netfilter/xt_dccp.c      |    1 +
 net/netfilter/xt_sctp.c      |    1 +
 net/netfilter/xt_tcpmss.c    |    1 +
 8 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 5194285..07a1b96 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -24,6 +24,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("iptables qdisc classification target module");
 MODULE_ALIAS("ipt_CLASSIFY");
+MODULE_ALIAS("ip6t_CLASSIFY");
 
 static unsigned int
 target(struct sk_buff **pskb,
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 5a00c54..7043c27 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -27,6 +27,7 @@ MODULE_AUTHOR("Henrik Nordstrom <hno@marasytems.com>");
 MODULE_DESCRIPTION("IP tables CONNMARK matching module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_CONNMARK");
+MODULE_ALIAS("ip6t_CONNMARK");
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index b7d6312..fec1aef 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -9,6 +9,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NOTRACK");
+MODULE_ALIAS("ip6t_NOTRACK");
 
 static unsigned int
 target(struct sk_buff **pskb,
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index dd4d79b..af79423 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -14,6 +14,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables match for matching number of pkts/bytes per connection");
 MODULE_ALIAS("ipt_connbytes");
+MODULE_ALIAS("ip6t_connbytes");
 
 static bool
 match(const struct sk_buff *skb,
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index e73fa9b..1071fc5 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -29,6 +29,7 @@ MODULE_AUTHOR("Henrik Nordstrom <hno@marasytems.com>");
 MODULE_DESCRIPTION("IP tables connmark match module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
+MODULE_ALIAS("ip6t_connmark");
 
 static bool
 match(const struct sk_buff *skb,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 83224ec..c2b1b24 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -24,6 +24,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Match for DCCP protocol packets");
 MODULE_ALIAS("ipt_dccp");
+MODULE_ALIAS("ip6t_dccp");
 
 #define DCCHECK(cond, option, flag, invflag) (!((flag) & (option)) \
 				  || (!!((invflag) & (option)) ^ (cond)))
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index c002153..f907770 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -13,6 +13,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kiran Kumar Immidi");
 MODULE_DESCRIPTION("Match for SCTP protocol packets");
 MODULE_ALIAS("ipt_sctp");
+MODULE_ALIAS("ip6t_sctp");
 
 #ifdef DEBUG_SCTP
 #define duprintf(format, args...) printk(format , ## args)
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index cd5f6d7..84d401b 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -22,6 +22,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables TCP MSS match module");
 MODULE_ALIAS("ipt_tcpmss");
+MODULE_ALIAS("ip6t_tcpmss");
 
 static bool
 match(const struct sk_buff *skb,
