From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv2 2/2] Addrtype match extension: limit addrtype check on the packet's interface
Date: Wed, 24 Oct 2007 16:21:30 +0200
Message-ID: <1193235691956-git-send-email-panther@balabit.hu>
References: <11932356911253-git-send-email-panther@balabit.hu>
 <1193235691233-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:51474 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbXJXOVj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:21:39 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 5B907C1159
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Oct 2007 16:21:38 +0200 (CEST)
In-Reply-To: <1193235691233-git-send-email-panther@balabit.hu>
Message-Id: <364a3c83187b863e5a7fd28803383b05fb29b6e6.1193232178.git.panther@balabit.hu>
In-Reply-To: <69d5a58b11473e65f29837c537a6d29b4e02e19b.1193232178.git.panther@balabit.hu>
References: <69d5a58b11473e65f29837c537a6d29b4e02e19b.1193232178.git.panther@balabit.hu>
In-Reply-To: <20071024-160736-1193234856.panther@balabit.hu>
References: <20071024-160736-1193234856.panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Addrtype match has a new revision (1), which lets address type checking
limit to the interface the current packet belongs to. The limitation
cannot be applied in the FORWARD hook.

Revision 0 lets older userspace programs use the match as earlier.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter_ipv4/ipt_addrtype.h |   15 ++++-
 net/ipv4/netfilter/ipt_addrtype.c           |   90 +++++++++++++++++++++-----
 2 files changed, 86 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 166ed01..856c79d 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,7 +1,20 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
-struct ipt_addrtype_info {
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE = 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST   = 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE   = 0x0004,
+};
+
+struct ipt_addrtype_info_v1 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t       flags;
+};
+
+struct ipt_addrtype_info_v0 {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
 	u_int32_t	invert_source;
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 59f01f7..7abe2f7 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -22,44 +22,98 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
 
-static inline bool match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(__be32 addr, const struct net_device *in, u_int16_t mask)
 {
-	return !!(mask & (1 << inet_addr_type(addr)));
+	return !!(mask & (1 << inet_dev_addr_type(addr, in)));
 }
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in, const struct net_device *out,
-		  const struct xt_match *match, const void *matchinfo,
-		  int offset, unsigned int protoff, bool *hotdrop)
+static bool addrtype_match_v0(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const struct xt_match *match, const void *matchinfo,
+		int offset, unsigned int protoff, bool *hotdrop)
 {
-	const struct ipt_addrtype_info *info = matchinfo;
+	const struct ipt_addrtype_info_v0 *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool ret = true;
 
 	if (info->source)
-		ret &= match_type(iph->saddr, info->source)^info->invert_source;
-	if (info->dest)
-		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
+		ret &= match_type(iph->saddr, NULL, info->source)^info->invert_source;
+	if (ret && (info->dest))
+		ret &= match_type(iph->daddr, NULL, info->dest)^info->invert_dest;
 
 	return ret;
 }
 
-static struct xt_match addrtype_match __read_mostly = {
-	.name		= "addrtype",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_addrtype_info),
-	.me		= THIS_MODULE
+static bool addrtype_match_v1(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const struct xt_match *match, const void *matchinfo,
+		int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct ipt_addrtype_info_v1 *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct net_device *limit_dev = NULL;
+	bool ret = true;
+
+	/* not valid in the FORWARD hook */
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE)
+		limit_dev = (in ? in : out); 
+
+	if (info->source)
+		ret &= match_type(iph->saddr, limit_dev, info->source) ^
+			(info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && (info->dest))
+		ret &= match_type(iph->daddr, limit_dev, info->dest) ^
+			(info->flags & IPT_ADDRTYPE_INVERT_DEST);
+	
+	return ret;
+}
+
+static bool addrtype_checkentry_v1(const char *tablename, const void *ip_void,
+		const struct xt_match *match,
+		void *matchinfo, unsigned int hook_mask)
+{
+	struct ipt_addrtype_info_v1 *info = matchinfo;
+
+	if (hook_mask & (1 << NF_IP_FORWARD)
+	   && info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {
+		printk(KERN_ERR "ipt_addrtype: limit-interface not valid in "
+				"FORWARD\n");
+		return false;
+	}
+	return true;
+}
+
+
+static struct xt_match addrtype_match[] __read_mostly = {
+ 	{
+ 		.name		= "addrtype",
+ 		.family		= AF_INET,
+ 		.revision       = 0,
+ 		.match		= addrtype_match_v0,
+ 		.matchsize	= sizeof(struct ipt_addrtype_info_v0),
+ 		.me		= THIS_MODULE
+ 	},
+ 	{
+ 		.name		= "addrtype",
+ 		.family		= AF_INET,
+ 		.revision       = 1,
+ 		.match		= addrtype_match_v1,
+		.checkentry	= addrtype_checkentry_v1,
+ 		.matchsize	= sizeof(struct ipt_addrtype_info_v1),
+ 		.me		= THIS_MODULE
+ 	}
 };
 
 static int __init ipt_addrtype_init(void)
 {
-	return xt_register_match(&addrtype_match);
+	return xt_register_matches(addrtype_match,
+			ARRAY_SIZE(addrtype_match));
 }
 
 static void __exit ipt_addrtype_fini(void)
 {
-	xt_unregister_match(&addrtype_match);
+	xt_unregister_matches(addrtype_match,
+			ARRAY_SIZE(addrtype_match));
 }
 
 module_init(ipt_addrtype_init);
-- 
1.5.2.5

