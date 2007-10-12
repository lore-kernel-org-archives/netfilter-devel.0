From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH 2/2] Addrtype match extension: limit addrtype check on the packet's interface
Date: Fri, 12 Oct 2007 16:07:20 +0200
Message-ID: <11921980402033-git-send-email-panther@balabit.hu>
References: <470F7EB1.2080309@balabit.hu>
 <11921980402340-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?q?T=C3=B3th=20L=C3=A1szl=C3=B3=20Attila?=
	<panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:39228 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXJLOH0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:07:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 3DD1DC11BD
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Oct 2007 16:07:25 +0200 (CEST)
In-Reply-To: <11921980402340-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: T=C3=B3th L=C3=A1szl=C3=B3 Attila <panther@balabit.hu>

Addrtype match has a new revision (1), which lets address type checking
limit to the interface the current packet belongs to.

Revision 0 lets older userspace programs use the match as earlier.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter_ipv4/ipt_addrtype.h |   15 +++++++
 net/ipv4/netfilter/ipt_addrtype.c           |   59 +++++++++++++++++++=
+-------
 2 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linu=
x/netfilter_ipv4/ipt_addrtype.h
index 166ed01..019ab47 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -1,9 +1,24 @@
 #ifndef _IPT_ADDRTYPE_H
 #define _IPT_ADDRTYPE_H
=20
+#define IPT_ADDRTYPE_REVISION        0x0001
+
+enum
+{
+	IPT_ADDRTYPE_INVERT_SOURCE =3D 0x0001,
+	IPT_ADDRTYPE_INVERT_DEST   =3D 0x0002,
+	IPT_ADDRTYPE_LIMIT_IFACE   =3D 0x0004,
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
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt=
_addrtype.c
index 59f01f7..e9d1f23 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -22,44 +22,73 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("iptables addrtype match");
=20
-static inline bool match_type(__be32 addr, u_int16_t mask)
+static inline bool match_type(__be32 addr, const struct net_device *in=
, u_int16_t mask)
 {
-	return !!(mask & (1 << inet_addr_type(addr)));
+	return !!(mask & (1 << inet_addr_type_on_dev(addr, in)));
 }
=20
-static bool match(const struct sk_buff *skb,
+static bool match_v0(const struct sk_buff *skb,
+		    const struct net_device *in, const struct net_device *out,
+		    const struct xt_match *match, const void *matchinfo,
+		    int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct ipt_addrtype_info_v0 *info =3D matchinfo;
+	const struct iphdr *iph =3D ip_hdr(skb);
+	bool ret =3D true;
+
+	if (info->source)
+		ret &=3D match_type(iph->saddr, NULL, info->source)^info->invert_sou=
rce;
+	if (ret && (info->dest))
+		ret &=3D match_type(iph->daddr, NULL, info->dest)^info->invert_dest;
+
+	return ret;
+}
+
+static bool match_v1(const struct sk_buff *skb,
 		  const struct net_device *in, const struct net_device *out,
 		  const struct xt_match *match, const void *matchinfo,
 		  int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ipt_addrtype_info *info =3D matchinfo;
 	const struct iphdr *iph =3D ip_hdr(skb);
+	const struct net_device *limit_dev =3D (info->flags & IPT_ADDRTYPE_LI=
MIT_IFACE) ? in : NULL;
 	bool ret =3D true;
=20
 	if (info->source)
-		ret &=3D match_type(iph->saddr, info->source)^info->invert_source;
-	if (info->dest)
-		ret &=3D match_type(iph->daddr, info->dest)^info->invert_dest;
-
+		ret &=3D match_type(iph->saddr, limit_dev, info->source) ^ (info->fl=
ags & IPT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && (info->dest))
+		ret &=3D match_type(iph->daddr, limit_dev, info->dest) ^ (info->flag=
s & IPT_ADDRTYPE_INVERT_DEST);
+=09
 	return ret;
 }
=20
-static struct xt_match addrtype_match __read_mostly =3D {
-	.name		=3D "addrtype",
-	.family		=3D AF_INET,
-	.match		=3D match,
-	.matchsize	=3D sizeof(struct ipt_addrtype_info),
-	.me		=3D THIS_MODULE
+ static struct xt_match addrtype_match[] =3D {
+ 	{
+ 		.name		=3D "addrtype",
+ 		.family		=3D AF_INET,
+ 		.revision       =3D 0,
+ 		.match		=3D match_v0,
+ 		.matchsize	=3D sizeof(struct ipt_addrtype_info_v0),
+ 		.me		=3D THIS_MODULE
+ 	},
+ 	{
+ 		.name		=3D "addrtype",
+ 		.family		=3D AF_INET,
+ 		.revision       =3D 1,
+ 		.match		=3D match_v1,
+ 		.matchsize	=3D sizeof(struct ipt_addrtype_info),
+ 		.me		=3D THIS_MODULE
+ 	}
 };
=20
 static int __init ipt_addrtype_init(void)
 {
-	return xt_register_match(&addrtype_match);
+	return xt_register_matches(addrtype_match, ARRAY_SIZE(addrtype_match)=
);
 }
=20
 static void __exit ipt_addrtype_fini(void)
 {
-	xt_unregister_match(&addrtype_match);
+	xt_unregister_matches(addrtype_match, ARRAY_SIZE(addrtype_match));
 }
=20
 module_init(ipt_addrtype_init);
--=20
1.5.2.5

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
