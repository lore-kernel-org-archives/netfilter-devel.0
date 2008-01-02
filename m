From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 15/27] xt_length match, revision 1
Date: Wed, 2 Jan 2008 21:29:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022129270.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56932 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbYABU3m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:29:42 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ad446d5b2c0b32ead9dd86b9c10356c4617eeaf5
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:22:16 2008 +0100

    [NETFILTER]: xt_length match, revision 1
   =20
    Introduce xt_length match revision 1. It adds support for layer4 an=
d
    layer5 length matching.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_length.h |   18 +++
 net/netfilter/xt_length.c           |  196 +++++++++++++++++++++++++--
 2 files changed, 199 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfil=
ter/xt_length.h
index 7c2b439..ac4eee6 100644
--- a/include/linux/netfilter/xt_length.h
+++ b/include/linux/netfilter/xt_length.h
@@ -6,4 +6,22 @@ struct xt_length_info {
     u_int8_t	invert;
 };
=20
+enum {
+	XT_LENGTH_INVERT =3D 1 << 0,
+
+	/* IP header plus payload */
+	XT_LENGTH_LAYER3 =3D 1 << 3,
+
+	/* TCP/UDP/etc. header plus payload */
+	XT_LENGTH_LAYER4 =3D 1 << 4,
+
+	/* TCP/UDP/etc. payload */
+	XT_LENGTH_LAYER5 =3D 1 << 5,
+};
+
+struct xt_length_mtinfo1 {
+	u_int32_t min, max;
+	u_int16_t flags;
+};
+
 #endif /*_XT_LENGTH_H*/
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index ea54578..97ad627 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -1,18 +1,32 @@
-/* Kernel module to match packet length. */
-/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
+/*
+ *	xt_length - Netfilter module to match packet length
  *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ *	(C) 1999-2001 James Morris <jmorros@intercode.com.au>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007-2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
+ *
+ *	This program is free software; you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
  */
-
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/icmp.h>
+#include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <net/ip.h>
-
-#include <linux/netfilter/xt_length.h>
+#include <net/ipv6.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_length.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#ifndef NEXTHDR_IPV4
+#	define NEXTHDR_IPV4 4
+#endif
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
+#	define WITH_IPV6 1
+#endif
=20
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 MODULE_DESCRIPTION("IP tables packet length matching module");
@@ -21,45 +35,197 @@ MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
=20
 static bool
+length_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *matc=
h,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_length_info *info =3D matchinfo;
+	u_int16_t pktlen =3D ntohs(ip_hdr(skb)->tot_len);
+
+	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->inver=
t;
+}
+
+static bool xtlength_layer5_tcp(unsigned int *length, const struct sk_=
buff *skb,
+                                unsigned int offset)
+{
+	const struct tcphdr *tcph;
+	struct tcphdr buf;
+
+	tcph =3D skb_header_pointer(skb, offset, sizeof(buf), &buf);
+	if (tcph =3D=3D NULL)
+		return false;
+
+	*length =3D skb->len - offset - 4 * tcph->doff;
+	return true;
+}
+
+static inline bool
+xtlength_layer5(unsigned int *length, const struct sk_buff *skb,
+                unsigned int prot, unsigned int offset)
+{
+	switch (prot) {
+	case IPPROTO_TCP:
+		return xtlength_layer5_tcp(length, skb, offset);
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		*length =3D skb->len - offset - sizeof(struct udphdr);
+		return true;
+	case IPPROTO_ICMP:
+		*length =3D skb->len - offset - sizeof(struct icmphdr);
+		return true;
+	case IPPROTO_ICMPV6:
+		*length =3D skb->len - offset - offsetof(struct icmp6hdr, icmp6_data=
un);
+		return true;
+	case IPPROTO_AH:
+		*length =3D skb->len - offset - sizeof(struct ip_auth_hdr);
+		return true;
+	case IPPROTO_ESP:
+		*length =3D skb->len - offset - sizeof(struct ip_esp_hdr);
+		return true;
+	}
+	return false;
+}
+
+static bool
 length_mt(const struct sk_buff *skb, const struct net_device *in,
           const struct net_device *out, const struct xt_match *match,
           const void *matchinfo, int offset, unsigned int protoff,
           bool *hotdrop)
 {
+	const struct xt_length_mtinfo1 *info =3D matchinfo;
+	const struct iphdr *iph =3D ip_hdr(skb);
+	unsigned int len =3D 0;
+	bool hit =3D true;
+
+	if (info->flags & XT_LENGTH_LAYER3)
+		len =3D ntohs(iph->tot_len);
+	else if (info->flags & XT_LENGTH_LAYER4)
+		len =3D ntohs(iph->tot_len) - protoff;
+	else if (info->flags & XT_LENGTH_LAYER5)
+		hit =3D xtlength_layer5(&len, skb, iph->protocol, protoff);
+	if (!hit)
+		return false;
+
+	return (len >=3D info->min && len <=3D info->max) ^
+	       !!(info->flags & XT_LENGTH_INVERT);
+}
+
+#ifdef WITH_IPV6
+static bool
+length_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
+              const struct net_device *out, const struct xt_match *mat=
ch,
+              const void *matchinfo, int offset, unsigned int protoff,
+              bool *hotdrop)
+{
 	const struct xt_length_info *info =3D matchinfo;
-	u_int16_t pktlen =3D ntohs(ip_hdr(skb)->tot_len);
+	const u_int16_t pktlen =3D ntohs(ipv6_hdr(skb)->payload_len) +
+				 sizeof(struct ipv6hdr);
=20
 	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->inver=
t;
 }
=20
+/*
+ * llayer4_proto - figure out the L4 protocol in an IPv6 packet
+ * @skb:	skb pointer
+ * @offset:	position at which L4 starts (equal to 'protoff' in IPv4 co=
de)
+ * @hotdrop:	hotdrop pointer
+ *
+ * Searches for a recognized L4 header. On success, fills in @offset a=
nd
+ * returns the protocol number. If not found, %NEXTHDR_MAX is returned=
=2E
+ * On error, @hotdrop is set.
+ */
+static unsigned int
+llayer4_proto(const struct sk_buff *skb, unsigned int *offset, bool *h=
otdrop)
+{
+	/*
+	 * Do encapsulation first so that %NEXTHDR_TCP does not hit the TCP
+	 * part in an IPv6-in-IPv6 encapsulation.
+	 */
+	static const unsigned int types[] =3D
+		{NEXTHDR_IPV6, NEXTHDR_IPV4, NEXTHDR_ESP, NEXTHDR_AUTH,
+		NEXTHDR_ICMP, NEXTHDR_TCP, NEXTHDR_UDP};
+	unsigned int i;
+	int err;
+
+	for (i =3D 0; i < ARRAY_SIZE(types); ++i) {
+		err =3D ipv6_find_hdr(skb, offset, types[i], NULL);
+		if (err >=3D 0)
+			return types[i];
+		if (err !=3D -ENOENT) {
+			*hotdrop =3D true;
+			break;
+		}
+	}
+
+	return NEXTHDR_MAX;
+}
+
 static bool
 length_mt6(const struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, const struct xt_match *match,
            const void *matchinfo, int offset, unsigned int protoff,
            bool *hotdrop)
 {
-	const struct xt_length_info *info =3D matchinfo;
-	const u_int16_t pktlen =3D ntohs(ipv6_hdr(skb)->payload_len) +
-				 sizeof(struct ipv6hdr);
+	const struct xt_length_mtinfo1 *info =3D matchinfo;
+	const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+	unsigned int len =3D 0, l4proto;
+	bool hit =3D true;
=20
-	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->inver=
t;
+	if (info->flags & XT_LENGTH_LAYER3) {
+		len =3D sizeof(struct ipv6hdr) + ntohs(iph->payload_len);
+	} else {
+		l4proto =3D llayer4_proto(skb, &protoff, hotdrop);
+		if (l4proto =3D=3D NEXTHDR_MAX)
+			return false;
+		if (info->flags & XT_LENGTH_LAYER4)
+			len =3D skb->len - protoff;
+		else if (info->flags & XT_LENGTH_LAYER5)
+			hit =3D xtlength_layer5(&len, skb, l4proto, protoff);
+	}
+	if (!hit)
+		return false;
+
+	return (len >=3D info->min && len <=3D info->max) ^
+	       !!(info->flags & XT_LENGTH_INVERT);
 }
+#endif
=20
 static struct xt_match length_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "length",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.match		=3D length_mt,
+		.match		=3D length_mt_v0,
 		.matchsize	=3D sizeof(struct xt_length_info),
 		.me		=3D THIS_MODULE,
 	},
 	{
+		.name           =3D "length",
+		.revision       =3D 1,
+		.family         =3D AF_INET,
+		.match          =3D length_mt,
+		.matchsize      =3D sizeof(struct xt_length_mtinfo1),
+		.me             =3D THIS_MODULE,
+	},
+#ifdef WITH_IPV6
+	{
 		.name		=3D "length",
+		.revision	=3D 0,
 		.family		=3D AF_INET6,
-		.match		=3D length_mt6,
+		.match		=3D length_mt6_v0,
 		.matchsize	=3D sizeof(struct xt_length_info),
 		.me		=3D THIS_MODULE,
 	},
+	{
+		.name           =3D "length",
+		.revision       =3D 1,
+		.family         =3D AF_INET6,
+		.match          =3D length_mt6,
+		.matchsize      =3D sizeof(struct xt_length_mtinfo1),
+		.me             =3D THIS_MODULE,
+	},
+#endif
 };
=20
 static int __init length_mt_init(void)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
