From: =?utf-8?q?T=C3=B3th=20L=C3=A1szl=C3=B3=20Attila?=
	<panther@balabit.hu>
Subject: [PATCH 2/2] Addrtype match extension: limit addrtype check on the packet's interface
Date: Fri, 5 Oct 2007 17:23:36 +0200
Message-ID: <97ecc4391f9ca03932065deb92008d9777403a44.1191598313.git.panther@balabit.hu>
References: <8801194d4668d655049cc103f7037c309ec950ac.1191598313.git.panther@balabit.hu>
To: panther@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:60189 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763383AbXJEQDl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:03:41 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 6777BC123E
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 18:03:40 +0200 (CEST)
In-Reply-To: <8801194d4668d655049cc103f7037c309ec950ac.1191598313.git.panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Addrtype match has a new revision (1), which lets address type checking
limit to the interface the current packet belongs to.

Revision 0 lets older userspace programs use the match as earlier.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

---
 include/linux/netfilter_ipv4/ipt_addrtype.h |   15 +++++++
 net/ipv4/netfilter/ipt_addrtype.c           |   59 ++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 166ed01..019ab47 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,9 +1,24 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+#define IPT_ADDRTYPE_REVISION        0x0001
+
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE = 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST   = 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE   = 0x0004,
+};
+
 struct ipt_addrtype_info {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t       flags;
+};
+
+struct ipt_addrtype_info_v0 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
 	u_int32_t	invert_source;
 	u_int32_t	invert_dest;
 };
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 59f01f7..e9d1f23 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -22,44 +22,73 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
 
-static inline bool match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(__be32 addr, const struct net_device *in, u_int16_t mask)
 {
-	return !!(mask & (1 << inet_addr_type(addr)));
+	return !!(mask & (1 << inet_addr_type_on_dev(addr, in)));
 }
 
-static bool match(const struct sk_buff *skb,
+static bool match_v0(const struct sk_buff *skb,
+		    const struct net_device *in, const struct net_device *out,
+		    const struct xt_match *match, const void *matchinfo,
+		    int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct ipt_addrtype_info_v0 *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	bool ret = true;
+
+	if (info->source)
+		ret &= match_type(iph->saddr, NULL, info->source)^info->invert_source;
+	if (ret && (info->dest))
+		ret &= match_type(iph->daddr, NULL, info->dest)^info->invert_dest;
+
+	return ret;
+}
+
+static bool match_v1(const struct sk_buff *skb,
 		  const struct net_device *in, const struct net_device *out,
 		  const struct xt_match *match, const void *matchinfo,
 		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
+	const struct net_device *limit_dev = (info->flags & IPT_ADDRTYPE_LIMIT_IFACE) ? in : NULL;
 	bool ret = true;
 
 	if (info->source)
-		ret &= match_type(iph->saddr, info->source)^info->invert_source;
-	if (info->dest)
-		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
-
+		ret &= match_type(iph->saddr, limit_dev, info->source) ^ (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && (info->dest))
+		ret &= match_type(iph->daddr, limit_dev, info->dest) ^ (info->flags & IPT_ADDRTYPE_INVERT_DEST);
+	
 	return ret;
 }
 
-static struct xt_match addrtype_match __read_mostly = {
-	.name		= "addrtype",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_addrtype_info),
-	.me		= THIS_MODULE
+ static struct xt_match addrtype_match[] = {
+ 	{
+ 		.name		= "addrtype",
+ 		.family		= AF_INET,
+ 		.revision       = 0,
+ 		.match		= match_v0,
+ 		.matchsize	= sizeof(struct ipt_addrtype_info_v0),
+ 		.me		= THIS_MODULE
+ 	},
+ 	{
+ 		.name		= "addrtype",
+ 		.family		= AF_INET,
+ 		.revision       = 1,
+ 		.match		= match_v1,
+ 		.matchsize	= sizeof(struct ipt_addrtype_info),
+ 		.me		= THIS_MODULE
+ 	}
 };
 
 static int __init ipt_addrtype_init(void)
 {
-	return xt_register_match(&addrtype_match);
+	return xt_register_matches(addrtype_match, ARRAY_SIZE(addrtype_match));
 }
 
 static void __exit ipt_addrtype_fini(void)
 {
-	xt_unregister_match(&addrtype_match);
+	xt_unregister_matches(addrtype_match, ARRAY_SIZE(addrtype_match));
 }
 
 module_init(ipt_addrtype_init);
-- 
1.5.2.5

