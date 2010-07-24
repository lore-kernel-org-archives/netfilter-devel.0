From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_netfilter=3A_xtables=3A_introduce_xt=5Flength_revision_2=C2=BD?=
Date: Sat, 24 Jul 2010 14:27:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007241344270.11738@obet.zrqbmnf.qr>
References: <1279961719-20479-1-git-send-email-jengelh@medozas.de> <1279971776.2451.66.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, xiaosuo@gmail.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49195 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0GXM1q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 08:27:46 -0400
In-Reply-To: <1279971776.2451.66.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-07-24 13:42, Eric Dumazet wrote:
>> +static bool
>> +length2_mt(const struct sk_buff *skb, struct xt_action_param *par)
>> +{
>> +	const struct xt_length_mtinfo2 *info =3D par->matchinfo;
>> +	const struct iphdr *iph =3D ip_hdr(skb);
>> +	unsigned int len =3D 0;
>> +	bool hit =3D true;
>> +
>> +	if (info->flags & XT_LENGTH_LAYER3)
>> +		len =3D ntohs(iph->tot_len);
>> +	else if (info->flags & XT_LENGTH_LAYER4)
>> +		len =3D ntohs(iph->tot_len) - par->thoff;
>> +	else if (info->flags & XT_LENGTH_LAYER5)
>> +		hit =3D xtlength_layer5(&len, skb, iph->protocol, par->thoff);
>> +	else if (info->flags & XT_LENGTH_LAYER7)
>> +		hit =3D xtlength_layer7(&len, skb, iph->protocol, par->thoff);
>> +	if (!hit)
>> +		return false;
>> +
>> +	return (len >=3D info->min && len <=3D info->max) ^
>> +	       !!(info->flags & XT_LENGTH_INVERT);
>> +}
>
>
>This serie of tests is expensive and useless.
>
>- A switch() would be faster,
>  - if you dont use a bit mask, but continuous values to get the layer=
=2E
>- Also, using a u16 is more expensive than a u32.
>- On x86, compiler is forced to use prefixes or conversions instructio=
ns
>  (movzwl), this makes code bigger.

I might agree with u16/u32 in that some CPUs need to run an extra
"AND" when they don't have (movw/cmpw), but... the other things
cast my doubts.

C does not specify a "speed" for switch or if. I agree that some
constructs may desire to be reworked to work around limitations of
the compiler's smartness, but in the case that is before us, it looks
like some of your arguments have no base - at least on x86_64.

length2_mt as it stands (bitmask, u16, if): 800 bytes
length2_mt with u32 flag: 800 bytes
length2_mt with switch: 800 bytes
length2_mt with continuous values and u32: 816 bytes
length2_mt with cont.v, u32, and switch: 816 bytes

The compiler is smart enough to see that a run of if tests against
the same variable with different values is transformable into a
switch statement.

>BTW, you mention "revision 2" in your patch title, while it is revisio=
n1

The description was copied from earlier; the code correctly contains
=2Erevision =3D 2. Actually, since Xt-a uses 2, I should be using 3.


parent 7df0884ce144396fc151f2af7a73d5fb305f9b03 (v2.6.35-rc1-956-g7df08=
84)
commit 5be892abc049930994dd681be0f441727279aa8a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Jul 24 10:47:08 2010 +0200

netfilter: xtables: introduce xt_length revision 3

Revision 3 adds support for layer-4, layer-5 and layer-7 length
matching. Using xt_u32 would be cumbersome to type and would not work
very well to skip an arbitrary number of IPv6 headers.

(Rev 1 and 2 were skipped to avoid confusion with other code, such as
from Xt-a.)

This can be used for packet scheduling; specific example are online
games where all data is transferred over the same port, but the regular
gameplay has a characteristically lower packet size than bulk downloads
of game maps. (Tested with Unreal Tournament 99.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_length.h |   10 ++
 net/netfilter/xt_length.c           |  231 ++++++++++++++++++++++++++-
 2 files changed, 238 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfil=
ter/xt_length.h
index b82ed7c..457e3cc 100644
--- a/include/linux/netfilter/xt_length.h
+++ b/include/linux/netfilter/xt_length.h
@@ -8,4 +8,14 @@ struct xt_length_info {
     __u8	invert;
 };
=20
+enum {
+	XT_LENGTH_LAYERMASK =3D 0x1F,
+	XT_LENGTH_INVERT    =3D 1 << 5,
+};
+
+struct xt_length_mtinfo3 {
+	__u32 min, max;
+	__u32 flags;
+};
+
 #endif /*_XT_LENGTH_H*/
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 176e557..851d04d 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -1,20 +1,31 @@
 /* Kernel module to match packet length. */
 /* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
+ * Copyright =C2=A9 Jan Engelhardt <jengelh@medozas.de>, 2007 - 2010
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#include <linux/dccp.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/icmp.h>
+#include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/sctp.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <net/ip.h>
-
-#include <linux/netfilter/xt_length.h>
+#include <net/ipv6.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_length.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
+#	define WITH_IPV6 1
+#endif
=20
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_DESCRIPTION("Xtables: Packet length (Layer3,4,5) match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_length");
@@ -39,6 +50,202 @@ length_mt6(const struct sk_buff *skb, struct xt_act=
ion_param *par)
 	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->inver=
t;
 }
=20
+static bool
+xtlength_layer5_tcp(unsigned int *length, const struct sk_buff *skb,
+		    unsigned int offset)
+{
+	const struct tcphdr *tcph;
+	struct tcphdr buf;
+
+	tcph =3D skb_header_pointer(skb, offset, sizeof(buf), &buf);
+	if (tcph =3D=3D NULL)
+		return false;
+
+	*length =3D skb->len - offset;
+	if (*length >=3D 4 * tcph->doff)
+		*length -=3D 4 * tcph->doff;
+	return true;
+}
+
+static bool
+xtlength_layer5_dccp(unsigned int *length, const struct sk_buff *skb,
+		     unsigned int offset)
+{
+	const struct dccp_hdr *dh;
+	struct dccp_hdr dhbuf;
+
+	dh =3D skb_header_pointer(skb, offset, sizeof(dhbuf), &dhbuf);
+	if (dh =3D=3D NULL)
+		return false;
+
+	*length =3D skb->len - offset;
+	if (*length >=3D 4 * dh->dccph_doff)
+		*length -=3D 4 * dh->dccph_doff;
+	return true;
+}
+
+static inline bool
+xtlength_layer5(unsigned int *length, const struct sk_buff *skb,
+		unsigned int prot, unsigned int offset)
+{
+	switch (prot) {
+	case IPPROTO_TCP:
+		return xtlength_layer5_tcp(length, skb, offset);
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		*length =3D skb->len - offset - sizeof(struct udphdr);
+		return true;
+	case IPPROTO_SCTP:
+		*length =3D skb->len - offset - sizeof(struct sctphdr);
+		return true;
+	case IPPROTO_DCCP:
+		return xtlength_layer5_dccp(length, skb, offset);
+	case IPPROTO_ICMP:
+		*length =3D skb->len - offset - sizeof(struct icmphdr);
+		return true;
+	case IPPROTO_ICMPV6:
+		*length =3D skb->len - offset -
+		          offsetof(struct icmp6hdr, icmp6_dataun);
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
+xtlength_layer7_sctp(unsigned int *length, const struct sk_buff *skb,
+		     unsigned int offset)
+{
+	const struct sctp_chunkhdr *ch;
+	struct sctp_chunkhdr chbuf;
+	unsigned int pos;
+
+	*length =3D 0;
+	for (pos =3D sizeof(struct sctphdr); pos < skb->len;
+	     pos +=3D ntohs(ch->length)) {
+		ch =3D skb_header_pointer(skb, offset + pos,
+		     sizeof(chbuf), &chbuf);
+		if (ch =3D=3D NULL)
+			return false;
+		if (ch->type !=3D SCTP_CID_DATA)
+			continue;
+		*length +=3D ntohs(ch->length);
+	}
+	return true;
+}
+
+static bool xtlength_layer7(unsigned int *length, const struct sk_buff=
 *skb,
+			    unsigned int proto, unsigned int offset)
+{
+	switch (proto) {
+	case IPPROTO_SCTP:
+		return xtlength_layer7_sctp(length, skb, offset);
+	default:
+		return xtlength_layer5(length, skb, proto, offset);
+	}
+}
+
+static bool
+length3_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_length_mtinfo3 *info =3D par->matchinfo;
+	const unsigned int layer =3D info->flags & XT_LENGTH_LAYERMASK;
+	const struct iphdr *iph =3D ip_hdr(skb);
+	unsigned int len =3D 0;
+	bool hit =3D true;
+
+	if (layer =3D=3D 3)
+		len =3D ntohs(iph->tot_len);
+	else if (layer =3D=3D 4)
+		len =3D ntohs(iph->tot_len) - par->thoff;
+	else if (layer =3D=3D 5)
+		hit =3D xtlength_layer5(&len, skb, iph->protocol, par->thoff);
+	else if (layer =3D=3D 7)
+		hit =3D xtlength_layer7(&len, skb, iph->protocol, par->thoff);
+	if (!hit)
+		return false;
+
+	return (len >=3D info->min && len <=3D info->max) ^
+	       !!(info->flags & XT_LENGTH_INVERT);
+}
+
+#ifdef WITH_IPV6
+/**
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
+		{IPPROTO_IPV6, IPPROTO_IPIP, IPPROTO_ESP, IPPROTO_AH,
+		IPPROTO_ICMP, IPPROTO_TCP, IPPROTO_UDP, IPPROTO_UDPLITE,
+		IPPROTO_SCTP, IPPROTO_DCCP};
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
+	return NEXTHDR_MAX;
+}
+
+static bool
+length3_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_length_mtinfo3 *info =3D par->matchinfo;
+	const unsigned int layer =3D info->flags & XT_LENGTH_LAYERMASK;
+	const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+	unsigned int len =3D 0, l4proto;
+	unsigned int thoff =3D par->thoff;
+	bool hit =3D true;
+
+	if (layer =3D=3D 3) {
+		if (iph->payload_len =3D=3D 0)
+			/* Jumbograms */
+			len =3D skb->len;
+		else
+			len =3D sizeof(struct ipv6hdr) + ntohs(iph->payload_len);
+	} else {
+		l4proto =3D llayer4_proto(skb, &thoff, &par->hotdrop);
+		if (l4proto =3D=3D NEXTHDR_MAX)
+			return false;
+		if (layer =3D=3D 4)
+			len =3D skb->len - thoff;
+		else if (layer =3D=3D 5)
+			hit =3D xtlength_layer5(&len, skb, l4proto, thoff);
+		else if (layer =3D=3D 7)
+			hit =3D xtlength_layer7(&len, skb, l4proto, thoff);
+	}
+	if (!hit)
+		return false;
+
+	return (len >=3D info->min && len <=3D info->max) ^
+	       !!(info->flags & XT_LENGTH_INVERT);
+}
+#endif
+
 static struct xt_match length_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "length",
@@ -54,6 +261,24 @@ static struct xt_match length_mt_reg[] __read_mostl=
y =3D {
 		.matchsize	=3D sizeof(struct xt_length_info),
 		.me		=3D THIS_MODULE,
 	},
+	{
+		.name           =3D "length",
+		.revision       =3D 3,
+		.family         =3D NFPROTO_IPV4,
+		.match          =3D length3_mt,
+		.matchsize      =3D sizeof(struct xt_length_mtinfo3),
+		.me             =3D THIS_MODULE,
+	},
+#ifdef WITH_IPV6
+	{
+		.name           =3D "length",
+		.revision       =3D 3,
+		.family         =3D NFPROTO_IPV6,
+		.match          =3D length3_mt6,
+		.matchsize      =3D sizeof(struct xt_length_mtinfo3),
+		.me             =3D THIS_MODULE,
+	},
+#endif
 };
=20
 static int __init length_mt_init(void)
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
