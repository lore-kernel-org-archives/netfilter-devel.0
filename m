From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [12/13] [NETFILTER]: xt_realm: enable for IPv6
Date: Fri, 1 Feb 2008 00:23:54 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010021340.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56873 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYAaXX4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:23:56 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Dunno why xt_realm was not registered for AF_INET6 before. iproute2 
does not seem to display IPv6 realms - leaves me wondering.

===
commit 05ec5f1b7e9d1497dd4738210df137722038d6b5
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 31 23:36:04 2008 +0100

    [NETFILTER]: xt_realm: enable for IPv6
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/xt_realm.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 7df1627..f18b6e9 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -20,6 +20,7 @@ MODULE_AUTHOR("Sampsa Ranta <sampsa@netsonic.fi>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: Routing realm match");
 MODULE_ALIAS("ipt_realm");
+MODULE_ALIAS("ip6t_realm");
 
 static bool
 realm_mt(const struct sk_buff *skb, const struct net_device *in,
@@ -33,24 +34,41 @@ realm_mt(const struct sk_buff *skb, const struct net_device *in,
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static struct xt_match realm_mt_reg __read_mostly = {
-	.name		= "realm",
-	.match		= realm_mt,
-	.matchsize	= sizeof(struct xt_realm_info),
-	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= AF_INET,
-	.me		= THIS_MODULE
+static struct xt_match realm_mt_reg[] __read_mostly = {
+	{
+		.name      = "realm",
+		.revision  = 0,
+		.family    = AF_INET,
+		.match     = realm_mt,
+		.matchsize = sizeof(struct xt_realm_info),
+		.hooks     = (1 << NF_INET_LOCAL_IN) |
+		             (1 << NF_INET_FORWARD) |
+		             (1 << NF_INET_LOCAL_OUT) |
+		             (1 << NF_INET_POST_ROUTING),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "realm",
+		.revision  = 0,
+		.family    = AF_INET6,
+		.match     = realm_mt,
+		.matchsize = sizeof(struct xt_realm_info),
+		.hooks     = (1 << NF_INET_LOCAL_IN) |
+		             (1 << NF_INET_FORWARD) |
+		             (1 << NF_INET_LOCAL_OUT) |
+		             (1 << NF_INET_POST_ROUTING),
+		.me        = THIS_MODULE,
+	},
 };
 
 static int __init realm_mt_init(void)
 {
-	return xt_register_match(&realm_mt_reg);
+	return xt_register_matches(realm_mt_reg, ARRAY_SIZE(realm_mt_reg));
 }
 
 static void __exit realm_mt_exit(void)
 {
-	xt_unregister_match(&realm_mt_reg);
+	xt_unregister_matches(realm_mt_reg, ARRAY_SIZE(realm_mt_reg));
 }
 
 module_init(realm_mt_init);
