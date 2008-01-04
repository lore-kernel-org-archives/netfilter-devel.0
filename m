From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Fri, 4 Jan 2008 16:28:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041625480.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <Pine.LNX.4.64.0801041603510.8731@fbirervta.pbzchgretzou.qr>
 <477E4BB2.7020503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57077 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYADP2a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:28:30 -0500
In-Reply-To: <477E4BB2.7020503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 16:07, Patrick McHardy wrote:
>
> Well, netfilter.h already includes linux/in.h, so that should work
> fine, no?
>
>
Alright the following patch works both in-kernel and iptables.


(not inside any published git tree)
=3D=3D=3D
commit 8872fff3bf309627d89e9da9dd10f8ec5a648ece
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:55:31 2008 +0100

    [NETFILTER]: xt_conntrack match, revision 1
   =20
    Introduces the xt_conntrack match revision 1. It uses fixed types, =
the
    new nf_inet_addr and comes with IPv6 support, thereby completely
    superseding xt_state.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/net=
filter/xt_conntrack.h
index 70b6f71..6ec4304 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -6,7 +6,6 @@
 #define _XT_CONNTRACK_H
=20
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
-#include <linux/in.h>
=20
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+=
1))
 #define XT_CONNTRACK_STATE_INVALID (1 << 0)
@@ -60,4 +59,16 @@ struct xt_conntrack_info
 	/* Inverse flags */
 	u_int8_t invflags;
 };
+
+struct xt_conntrack_mtinfo1 {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	u_int32_t expires_min, expires_max;
+	u_int16_t l4proto;
+	u_int8_t state_mask, status_mask;
+	u_int8_t match_flags, invert_flags;
+};
+
 #endif /*_XT_CONNTRACK_H*/
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.=
c
index 3f8bfba..dc9e737 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -1,15 +1,19 @@
-/* Kernel module to match connection tracking information.
- * Superset of Rusty's minimalistic state match.
+/*
+ *	xt_conntrack - Netfilter module to match connection tracking
+ *	information. (Superset of Rusty's minimalistic state match.)
  *
- * (C) 2001  Marc Boucher (marc@mbsi.ca).
+ *	(C) 2001  Marc Boucher (marc@mbsi.ca).
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	Jan Engelhardt <jengelh@computergmbh.de>
  *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ *	This program is free software; you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <net/ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_conntrack.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -18,12 +22,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables connection tracking match module");
 MODULE_ALIAS("ipt_conntrack");
+MODULE_ALIAS("ip6t_conntrack");
=20
 static bool
-conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *matc=
h,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+conntrack_mt_v0(const struct sk_buff *skb, const struct net_device *in=
,
+                const struct net_device *out, const struct xt_match *m=
atch,
+                const void *matchinfo, int offset, unsigned int protof=
f,
+                bool *hotdrop)
 {
 	const struct xt_conntrack_info *sinfo =3D matchinfo;
 	const struct nf_conn *ct;
@@ -112,6 +117,134 @@ conntrack_mt(const struct sk_buff *skb, const str=
uct net_device *in,
 }
=20
 static bool
+conntrack_addrcmp(const union nf_inet_addr *kaddr,
+                  const union nf_inet_addr *uaddr,
+                  const union nf_inet_addr *umask, unsigned int l3prot=
o)
+{
+	if (l3proto =3D=3D AF_INET)
+		return (kaddr->ip & umask->ip) =3D=3D uaddr->ip;
+	else if (l3proto =3D=3D AF_INET6)
+		return ipv6_masked_addr_cmp(&kaddr->in6, &umask->in6,
+		       &uaddr->in6) =3D=3D 0;
+	else
+		return false;
+}
+
+static inline bool
+conntrack_mt_origsrc(const struct nf_conn *ct,
+                     const struct xt_conntrack_mtinfo1 *info,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src=
=2Eu3,
+	       &info->origsrc_addr, &info->origsrc_mask, family);
+}
+
+static inline bool
+conntrack_mt_origdst(const struct nf_conn *ct,
+                     const struct xt_conntrack_mtinfo1 *info,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst=
=2Eu3,
+	       &info->origdst_addr, &info->origdst_mask, family);
+}
+
+static inline bool
+conntrack_mt_replsrc(const struct nf_conn *ct,
+                     const struct xt_conntrack_mtinfo1 *info,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3=
,
+	       &info->replsrc_addr, &info->replsrc_mask, family);
+}
+
+static inline bool
+conntrack_mt_repldst(const struct nf_conn *ct,
+                     const struct xt_conntrack_mtinfo1 *info,
+                     unsigned int family)
+{
+	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3=
,
+	       &info->repldst_addr, &info->repldst_mask, family);
+}
+
+static bool
+conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *matc=
h,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_conntrack_mtinfo1 *info =3D matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	unsigned int statebit;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+
+	if (ct =3D=3D &nf_conntrack_untracked)
+		statebit =3D XT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct !=3D NULL)
+		statebit =3D XT_CONNTRACK_STATE_BIT(ctinfo);
+	else
+		statebit =3D XT_CONNTRACK_STATE_INVALID;
+
+	if (info->match_flags & XT_CONNTRACK_STATE) {
+		if (ct !=3D NULL) {
+			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
+				statebit |=3D XT_CONNTRACK_STATE_SNAT;
+			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
+				statebit |=3D XT_CONNTRACK_STATE_DNAT;
+		}
+		if ((info->state_mask & statebit) ^
+		    !(info->invert_flags & XT_CONNTRACK_STATE))
+			return false;
+	}
+
+	if (ct =3D=3D NULL)
+		return info->match_flags & XT_CONNTRACK_STATE;
+
+	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
+	    ((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum =3D=3D
+	    info->l4proto) ^ !(info->invert_flags & XT_CONNTRACK_PROTO)))
+		return false;
+
+	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
+		if (conntrack_mt_origsrc(ct, info, match->family) ^
+		    !(info->invert_flags & XT_CONNTRACK_ORIGSRC))
+			return false;
+
+	if (info->match_flags & XT_CONNTRACK_ORIGDST)
+		if (conntrack_mt_origdst(ct, info, match->family) ^
+		    !(info->invert_flags & XT_CONNTRACK_ORIGDST))
+			return false;
+
+	if (info->match_flags & XT_CONNTRACK_REPLSRC)
+		if (conntrack_mt_replsrc(ct, info, match->family) ^
+		    !(info->invert_flags & XT_CONNTRACK_REPLSRC))
+			return false;
+
+	if (info->match_flags & XT_CONNTRACK_REPLDST)
+		if (conntrack_mt_repldst(ct, info, match->family) ^
+		    !(info->invert_flags & XT_CONNTRACK_REPLDST))
+			return false;
+
+	if ((info->match_flags & XT_CONNTRACK_STATUS) &&
+	    (!!(info->status_mask & ct->status) ^
+	    !(info->invert_flags & XT_CONNTRACK_STATUS)))
+		return false;
+
+	if (info->match_flags & XT_CONNTRACK_EXPIRES) {
+		unsigned long expires =3D 0;
+
+		if (timer_pending(&ct->timeout))
+			expires =3D (ct->timeout.expires - jiffies) / HZ;
+		if ((expires >=3D info->expires_min &&
+		    expires <=3D info->expires_max) ^
+		    !(info->invert_flags & XT_CONNTRACK_EXPIRES))
+			return false;
+	}
+	return true;
+}
+
+static bool
 conntrack_mt_check(const char *tablename, const void *ip,
                    const struct xt_match *match, void *matchinfo,
                    unsigned int hook_mask)
@@ -144,7 +277,7 @@ struct compat_xt_conntrack_info
 	u_int8_t			invflags;
 };
=20
-static void conntrack_mt_compat_from_user(void *dst, void *src)
+static void conntrack_mt_compat_from_user_v0(void *dst, void *src)
 {
 	const struct compat_xt_conntrack_info *cm =3D src;
 	struct xt_conntrack_info m =3D {
@@ -161,7 +294,7 @@ static void conntrack_mt_compat_from_user(void *dst=
, void *src)
 	memcpy(dst, &m, sizeof(m));
 }
=20
-static int conntrack_mt_compat_to_user(void __user *dst, void *src)
+static int conntrack_mt_compat_to_user_v0(void __user *dst, void *src)
 {
 	const struct xt_conntrack_info *m =3D src;
 	struct compat_xt_conntrack_info cm =3D {
@@ -179,29 +312,53 @@ static int conntrack_mt_compat_to_user(void __use=
r *dst, void *src)
 }
 #endif
=20
-static struct xt_match conntrack_mt_reg __read_mostly =3D {
-	.name		=3D "conntrack",
-	.match		=3D conntrack_mt,
-	.checkentry	=3D conntrack_mt_check,
-	.destroy	=3D conntrack_mt_destroy,
-	.matchsize	=3D sizeof(struct xt_conntrack_info),
+static struct xt_match conntrack_mt_reg[] __read_mostly =3D {
+	{
+		.name       =3D "conntrack",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.match      =3D conntrack_mt_v0,
+		.checkentry =3D conntrack_mt_check,
+		.destroy    =3D conntrack_mt_destroy,
+		.matchsize  =3D sizeof(struct xt_conntrack_info),
+		.me         =3D THIS_MODULE,
 #ifdef CONFIG_COMPAT
-	.compatsize	=3D sizeof(struct compat_xt_conntrack_info),
-	.compat_from_user =3D conntrack_mt_compat_from_user,
-	.compat_to_user	=3D conntrack_mt_compat_to_user,
+		.compatsize       =3D sizeof(struct compat_xt_conntrack_info),
+		.compat_from_user =3D conntrack_mt_compat_from_user_v0,
+		.compat_to_user   =3D conntrack_mt_compat_to_user_v0,
 #endif
-	.family		=3D AF_INET,
-	.me		=3D THIS_MODULE,
+	},
+	{
+		.name       =3D "conntrack",
+		.revision   =3D 1,
+		.family     =3D AF_INET,
+		.matchsize  =3D sizeof(struct xt_conntrack_mtinfo1),
+		.match      =3D conntrack_mt,
+		.checkentry =3D conntrack_mt_check,
+		.destroy    =3D conntrack_mt_destroy,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "conntrack",
+		.revision   =3D 1,
+		.family     =3D AF_INET6,
+		.matchsize  =3D sizeof(struct xt_conntrack_mtinfo1),
+		.match      =3D conntrack_mt,
+		.checkentry =3D conntrack_mt_check,
+		.destroy    =3D conntrack_mt_destroy,
+		.me         =3D THIS_MODULE,
+	},
 };
=20
 static int __init conntrack_mt_init(void)
 {
-	return xt_register_match(&conntrack_mt_reg);
+	return xt_register_matches(conntrack_mt_reg,
+	       ARRAY_SIZE(conntrack_mt_reg));
 }
=20
 static void __exit conntrack_mt_exit(void)
 {
-	xt_unregister_match(&conntrack_mt_reg);
+	xt_unregister_matches(conntrack_mt_reg, ARRAY_SIZE(conntrack_mt_reg))=
;
 }
=20
 module_init(conntrack_mt_init);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index a776dc3..24804a3 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -81,6 +81,8 @@ static struct xt_match state_mt_reg[] __read_mostly =3D=
 {
=20
 static int __init state_mt_init(void)
 {
+	printk(KERN_NOTICE "xt_state is obsolete, please use "
+	       "xt_conntrack instead.\n");
 	return xt_register_matches(state_mt_reg, ARRAY_SIZE(state_mt_reg));
 }
=20
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
