From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/49]: ipt_addrtype: limit address type checking to an interface
Date: Tue,  4 Dec 2007 13:02:06 +0100 (MET)
Message-ID: <20071204120206.2442.30418.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXLDMCI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:08 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_addrtype: limit address type checking to an interface

Addrtype match has a new revision (1), which lets address type checking
limited to the interface the current packet belongs to. Either incoming
or outgoing interface can be used depending on the current hook. In the
FORWARD hook two maches should be used if both interfaces have to be checked.
The new structure is ipt_addrtype_info_v1.

Revision 0 lets older userspace programs use the match as earlier.
ipt_addrtype_info is used.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aaa25832938c3900fc8711fc45dc753bc2885d06
tree 4da40e913eb4a2d8360da23ddc1b2baecfaa392b
parent f7856f723b508049e599b8126cd17246bdaed633
author Laszlo Attila Toth <panther@balabit.hu> Tue, 04 Dec 2007 10:47:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:22:25 +0100

 include/linux/netfilter_ipv4/ipt_addrtype.h |   14 ++++
 net/ipv4/netfilter/ipt_addrtype.c           |  104 +++++++++++++++++++++++----
 2 files changed, 102 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 166ed01..446de6a 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,6 +1,20 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+enum {
+	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+struct ipt_addrtype_info_v1 {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	flags;
+};
+
+/* revision 0 */
 struct ipt_addrtype_info {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index b75421c..14394c6 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -2,6 +2,7 @@
  *  iptables module to match inet_addr_type() of an ip.
  *
  *  Copyright (c) 2004 Patrick McHardy <kaber@trash.net>
+ *  (C) 2007 Laszlo Attila Toth <panther@balabit.hu>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -22,45 +23,116 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
 
-static inline bool match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(const struct net_device *dev, __be32 addr,
+			      u_int16_t mask)
 {
-	return !!(mask & (1 << inet_addr_type(addr)));
+	return !!(mask & (1 << inet_dev_addr_type(dev, addr)));
 }
 
 static bool
-addrtype_mt(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+addrtype_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+	       const struct net_device *out, const struct xt_match *match,
+	       const void *matchinfo, int offset, unsigned int protoff,
+	       bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool ret = true;
 
 	if (info->source)
-		ret &= match_type(iph->saddr, info->source)^info->invert_source;
+		ret &= match_type(NULL, iph->saddr, info->source) ^
+		       info->invert_source;
 	if (info->dest)
-		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
+		ret &= match_type(NULL, iph->daddr, info->dest) ^
+		       info->invert_dest;
 
 	return ret;
 }
 
-static struct xt_match addrtype_mt_reg __read_mostly = {
-	.name		= "addrtype",
-	.family		= AF_INET,
-	.match		= addrtype_mt,
-	.matchsize	= sizeof(struct ipt_addrtype_info),
-	.me		= THIS_MODULE
+static bool
+addrtype_mt_v1(const struct sk_buff *skb, const struct net_device *in,
+	       const struct net_device *out, const struct xt_match *match,
+	       const void *matchinfo, int offset, unsigned int protoff,
+	       bool *hotdrop)
+{
+	const struct ipt_addrtype_info_v1 *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct net_device *dev = NULL;
+	bool ret = true;
+
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN)
+		dev = in;
+	else if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT)
+		dev = out;
+
+	if (info->source)
+		ret &= match_type(dev, iph->saddr, info->source) ^
+		       (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && info->dest)
+		ret &= match_type(dev, iph->daddr, info->dest) ^
+		       (info->flags & IPT_ADDRTYPE_INVERT_DEST);
+	return ret;
+}
+
+static bool
+addrtype_mt_checkentry_v1(const char *tablename, const void *ip_void,
+			  const struct xt_match *match, void *matchinfo,
+			  unsigned int hook_mask)
+{
+	struct ipt_addrtype_info_v1 *info = matchinfo;
+
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: both incoming and outgoing "
+				"interface limitation cannot be selected\n");
+		return false;
+	}
+
+	if (hook_mask & (1 << NF_INET_PRE_ROUTING | 1 << NF_INET_LOCAL_IN) &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: output interface limitation "
+				"not valid in PRE_ROUTING and INPUT\n");
+		return false;
+	}
+
+	if (hook_mask & (1 << NF_INET_POST_ROUTING | 1 << NF_INET_LOCAL_OUT) &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printk(KERN_ERR "ipt_addrtype: input interface limitation "
+				"not valid in POST_ROUTING and OUTPUT\n");
+		return false;
+	}
+
+	return true;
+}
+
+static struct xt_match addrtype_mt_reg[] __read_mostly = {
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.match		= addrtype_mt_v0,
+		.matchsize	= sizeof(struct ipt_addrtype_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.revision	= 1,
+		.match		= addrtype_mt_v1,
+		.checkentry	= addrtype_mt_checkentry_v1,
+		.matchsize	= sizeof(struct ipt_addrtype_info_v1),
+		.me		= THIS_MODULE
+	}
 };
 
 static int __init addrtype_mt_init(void)
 {
-	return xt_register_match(&addrtype_mt_reg);
+	return xt_register_matches(addrtype_mt_reg,
+				   ARRAY_SIZE(addrtype_mt_reg));
 }
 
 static void __exit addrtype_mt_exit(void)
 {
-	xt_unregister_match(&addrtype_mt_reg);
+	xt_unregister_matches(addrtype_mt_reg, ARRAY_SIZE(addrtype_mt_reg));
 }
 
 module_init(addrtype_mt_init);
