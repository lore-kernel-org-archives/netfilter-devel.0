From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 14/27] xt_helper match, revision 1
Date: Wed, 2 Jan 2008 21:29:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022129130.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56929 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYABU31 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:29:27 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit c3c5674fee490f6735136b2c9a7e39a30f25635e
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:01:06 2008 +0100

    [NETFILTER]: xt_helper match, revision 1
    
    Introduces the xt_helper match revision 1. It uses fixed types, and
    its structure size has been adjusted.
    
    The xt_helper revision 0 structure had an odd size of 34 bytes. I
    changed this into 32 bytes, which probably plays much better with
    cachelines. The invert flag is also shrunk so now there is an
    additional byte available for the name as a side effect.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_helper.h |    6 ++
 net/netfilter/xt_helper.c           |   95 +++++++++++++++++++++++---
 2 files changed, 90 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/xt_helper.h b/include/linux/netfilter/xt_helper.h
index 6b42763..39dcec8 100644
--- a/include/linux/netfilter/xt_helper.h
+++ b/include/linux/netfilter/xt_helper.h
@@ -5,4 +5,10 @@ struct xt_helper_info {
 	int invert;
 	char name[30];
 };
+
+struct xt_helper_mtinfo1 {
+	char name[31];
+	u_int8_t invert;
+};
+
 #endif /* _XT_HELPER_H */
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 5d063e5..9497d00 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -1,10 +1,11 @@
-/* iptables module to match on related connections */
 /*
- * (C) 2001 Martin Josefsson <gandalf@wlug.westbo.se>
+ *	xt_helper - Netfilter module to match on related connections
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ *	(C) 2001 Martin Josefsson <gandalf@wlug.westbo.se>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
@@ -22,13 +23,46 @@ MODULE_DESCRIPTION("iptables helper match module");
 MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
-
 static bool
 helper_mt(const struct sk_buff *skb, const struct net_device *in,
           const struct net_device *out, const struct xt_match *match,
           const void *matchinfo, int offset, unsigned int protoff,
           bool *hotdrop)
 {
+	const struct xt_helper_mtinfo1 *info = matchinfo;
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *master_help;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	bool ret = info->invert;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL || ct->master == NULL)
+		return ret;
+
+	master_help = nfct_help(ct->master);
+	if (master_help == NULL)
+		return ret;
+
+	/* rcu_read_lock()ed by nf_hook_slow */
+	helper = rcu_dereference(master_help->helper);
+	if (helper == NULL)
+		return ret;
+
+	if (info->name[0] == '\0')
+		ret = !ret;
+	else
+		ret ^= strncmp(helper->name, info->name,
+		       strlen(helper->name)) == 0;
+	return ret;
+}
+
+static bool
+helper_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
 	const struct xt_helper_info *info = matchinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *master_help;
@@ -58,9 +92,9 @@ helper_mt(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-helper_mt_check(const char *tablename, const void *inf,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
+helper_mt_check_v0(const char *tablename, const void *inf,
+                   const struct xt_match *match, void *matchinfo,
+                   unsigned int hook_mask)
 {
 	struct xt_helper_info *info = matchinfo;
 
@@ -73,6 +107,23 @@ helper_mt_check(const char *tablename, const void *inf,
 	return true;
 }
 
+static bool
+helper_mt_check(const char *tablename, const void *ip,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
+{
+	struct xt_helper_mtinfo1 *info = matchinfo;
+
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%u\n", match->family);
+		return false;
+	}
+
+	info->name[sizeof(info->name)-1] = '\0';
+	return true;
+}
+
 static void helper_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
@@ -81,20 +132,42 @@ static void helper_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match helper_mt_reg[] __read_mostly = {
 	{
 		.name		= "helper",
+		.revision	= 0,
+		.family		= AF_INET,
+		.checkentry	= helper_mt_check_v0,
+		.match		= helper_mt_v0,
+		.destroy	= helper_mt_destroy,
+		.matchsize	= sizeof(struct xt_helper_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "helper",
+		.revision	= 0,
+		.family		= AF_INET6,
+		.checkentry	= helper_mt_check_v0,
+		.match		= helper_mt_v0,
+		.destroy	= helper_mt_destroy,
+		.matchsize	= sizeof(struct xt_helper_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "helper",
+		.revision	= 1,
 		.family		= AF_INET,
 		.checkentry	= helper_mt_check,
 		.match		= helper_mt,
 		.destroy	= helper_mt_destroy,
-		.matchsize	= sizeof(struct xt_helper_info),
+		.matchsize	= sizeof(struct xt_helper_mtinfo1),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "helper",
+		.revision	= 1,
 		.family		= AF_INET6,
 		.checkentry	= helper_mt_check,
 		.match		= helper_mt,
 		.destroy	= helper_mt_destroy,
-		.matchsize	= sizeof(struct xt_helper_info),
+		.matchsize	= sizeof(struct xt_helper_mtinfo1),
 		.me		= THIS_MODULE,
 	},
 };
