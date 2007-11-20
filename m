From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv5 2/2] Addrtype match: limit address type checking to an interface
Date: Tue, 20 Nov 2007 09:00:43 +0100
Message-ID: <11955456453362-git-send-email-panther@balabit.hu>
References: <11955456442652-git-send-email-panther@balabit.hu>
 <11955456451525-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:44484 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbXKTIAv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:00:51 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id BA489C14D5
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2007 09:00:50 +0100 (CET)
In-Reply-To: <11955456451525-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Addrtype match has a new revision (1), which lets address type checking
limited to the interface the current packet belongs to. Either incoming
or outgoing interface can be used depending on the current hook. In the
FORWARD hook two maches should be used if both interfaces have to be checked.
The new structure is ipt_addrtype_info_v1.

Revision 0 lets older userspace programs use the match as earlier.
ipt_addrtype_info is used.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter_ipv4/ipt_addrtype.h |   17 ++++
 net/ipv4/netfilter/ipt_addrtype.c           |  116 +++++++++++++++++++++++----
 2 files changed, 116 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 166ed01..3ffb78b 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,6 +1,22 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
 
+enum
+{
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
+
+/* revision 0 */
 struct ipt_addrtype_info {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
@@ -8,4 +24,5 @@ struct ipt_addrtype_info {
 	u_int32_t	invert_dest;
 };
 
+
 #endif
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 59f01f7..0d19b7e 100644
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
@@ -21,45 +22,126 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
+MODULE_ALIAS("ipt_addrtype");
 
-static inline bool match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(__be32 addr,
+			      const struct net_device *in,
+			      u_int16_t mask)
 {
-	return !!(mask & (1 << inet_addr_type(addr)));
+	return !!(mask & (1 << inet_dev_addr_type(addr, in)));
 }
 
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in, const struct net_device *out,
-		  const struct xt_match *match, const void *matchinfo,
-		  int offset, unsigned int protoff, bool *hotdrop)
+static bool addrtype_match_v0(const struct sk_buff *skb,
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const struct xt_match *match,
+			      const void *matchinfo,
+			      int offset,
+			      unsigned int protoff,
+			      bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool ret = true;
 
 	if (info->source)
-		ret &= match_type(iph->saddr, info->source)^info->invert_source;
-	if (info->dest)
-		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
+		ret &= match_type(iph->saddr, NULL, info->source)^info->invert_source;
+	if (ret && info->dest)
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
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const struct xt_match *match,
+			      const void *matchinfo,
+			      int offset,
+			      unsigned int protoff,
+			      bool *hotdrop)
+{
+	const struct ipt_addrtype_info_v1 *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct net_device *limit_dev = NULL;
+	bool ret = true;
+
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN)
+		limit_dev = in;
+	else if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT)
+		limit_dev = out;
+
+
+	if (info->source)
+		ret &= match_type(iph->saddr, limit_dev, info->source) ^
+			(info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && info->dest)
+		ret &= match_type(iph->daddr, limit_dev, info->dest) ^
+			(info->flags & IPT_ADDRTYPE_INVERT_DEST);
+
+	return ret;
+}
+
+static bool addrtype_checkentry_v1(const char *tablename,
+				   const void *ip_void,
+				   const struct xt_match *match,
+				   void *matchinfo,
+				   unsigned int hook_mask)
+{
+	struct ipt_addrtype_info_v1 *info = matchinfo;
+
+	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: both incoming and outgoing interface "
+				"limitation cannot be selected\n");
+		return false;
+	}
+
+	if (hook_mask & (1 << NF_INET_PRE_ROUTING | 1 << NF_INET_LOCAL_IN) &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: output interface limitation "
+				"not valid in PRE_ROUTING and INPUT\n");
+		return false;
+	}
+	if (hook_mask & (1 << NF_INET_POST_ROUTING | 1 << NF_INET_LOCAL_OUT) &&
+	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printk(KERN_ERR "ipt_addrtype: input interface limitation "
+				"not valid in POST_ROUTING and OUTPUT\n");
+		return false;
+	}
+	return true;
+}
+
+static struct xt_match ipt_addrtype_match[] __read_mostly = {
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.revision	= 0,
+		.match		= addrtype_match_v0,
+		.matchsize	= sizeof(struct ipt_addrtype_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.revision	= 1,
+		.match		= addrtype_match_v1,
+		.checkentry	= addrtype_checkentry_v1,
+		.matchsize	= sizeof(struct ipt_addrtype_info_v1),
+		.me		= THIS_MODULE
+	}
 };
 
 static int __init ipt_addrtype_init(void)
 {
-	return xt_register_match(&addrtype_match);
+	return xt_register_matches(ipt_addrtype_match,
+			ARRAY_SIZE(ipt_addrtype_match));
 }
 
 static void __exit ipt_addrtype_fini(void)
 {
-	xt_unregister_match(&addrtype_match);
+	xt_unregister_matches(ipt_addrtype_match,
+			ARRAY_SIZE(ipt_addrtype_match));
 }
 
 module_init(ipt_addrtype_init);
-- 
1.5.2.5

