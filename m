From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_helper match revision 1
Date: Sat, 22 Dec 2007 03:40:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220339420.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXLVCkX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:40:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_helper match revision 1. It uses fixed types,
and its structure size has been adjusted.

The xt_helper revision 0 structure had an odd size of 34 bytes. I
changed this into 32 bytes, which probably plays much better with
cachelines. The invert flag is also shrunk so now there is an
additional byte available for the name as a side effect.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_helper.h |    6 ++
 net/netfilter/xt_helper.c           |   84 +++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 6 deletions(-)

Index: linux-2.6_nosov/include/linux/netfilter/xt_helper.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_helper.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_helper.h
@@ -5,4 +5,10 @@ struct xt_helper_info {
 	int invert;
 	char name[30];
 };
+
+struct xt_helper_match_info {
+	char name[31];
+	u_int8_t invert;
+};
+
 #endif /* _XT_HELPER_H */
Index: linux-2.6_nosov/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_helper.c
+++ linux-2.6_nosov/net/netfilter/xt_helper.c
@@ -22,13 +22,46 @@ MODULE_DESCRIPTION("iptables helper matc
 MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
-
 static bool
 helper_mt(const struct sk_buff *skb, const struct net_device *in,
           const struct net_device *out, const struct xt_match *match,
           const void *matchinfo, int offset, unsigned int protoff,
           bool *hotdrop)
 {
+	const struct xt_helper_match_info *info = matchinfo;
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
@@ -58,9 +91,9 @@ helper_mt(const struct sk_buff *skb, con
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
 
@@ -73,6 +106,23 @@ helper_mt_check(const char *tablename, c
 	return true;
 }
 
+static bool
+helper_mt_check(const char *tablename, const void *ip,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
+{
+	struct xt_helper_match_info *info = matchinfo;
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
@@ -81,20 +131,42 @@ static void helper_mt_destroy(const stru
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
+		.matchsize	= sizeof(struct xt_helper_match_info),
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
+		.matchsize	= sizeof(struct xt_helper_match_info),
 		.me		= THIS_MODULE,
 	},
 };

