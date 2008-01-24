From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Thu, 24 Jan 2008 23:38:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801242337480.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38102 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbYAXWiJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:38:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7f1764fa749032eb8566226bbd1c5a58a8a5efc6
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 16 18:58:49 2008 +0100

    [NETFILTER]: xt_conntrack: add port and direction matching
   =20
    Extend the xt_conntrack match revision 1 by port matching (all four
    {orig,repl}{src,dst}) and by packet direction matching.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/net=
filter/xt_conntrack.h
index d2492a3..f3fd83e 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -6,9 +6,6 @@
 #define _XT_CONNTRACK_H
=20
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
-#ifdef __KERNEL__
-#	include <linux/in.h>
-#endif
=20
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+=
1))
 #define XT_CONNTRACK_STATE_INVALID (1 << 0)
@@ -18,14 +15,21 @@
 #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
=20
 /* flags, invflags: */
-#define XT_CONNTRACK_STATE	0x01
-#define XT_CONNTRACK_PROTO	0x02
-#define XT_CONNTRACK_ORIGSRC	0x04
-#define XT_CONNTRACK_ORIGDST	0x08
-#define XT_CONNTRACK_REPLSRC	0x10
-#define XT_CONNTRACK_REPLDST	0x20
-#define XT_CONNTRACK_STATUS	0x40
-#define XT_CONNTRACK_EXPIRES	0x80
+enum {
+	XT_CONNTRACK_STATE        =3D 1 << 0,
+	XT_CONNTRACK_PROTO        =3D 1 << 1,
+	XT_CONNTRACK_ORIGSRC      =3D 1 << 2,
+	XT_CONNTRACK_ORIGDST      =3D 1 << 3,
+	XT_CONNTRACK_REPLSRC      =3D 1 << 4,
+	XT_CONNTRACK_REPLDST      =3D 1 << 5,
+	XT_CONNTRACK_STATUS       =3D 1 << 6,
+	XT_CONNTRACK_EXPIRES      =3D 1 << 7,
+	XT_CONNTRACK_ORIGSRC_PORT =3D 1 << 8,
+	XT_CONNTRACK_ORIGDST_PORT =3D 1 << 9,
+	XT_CONNTRACK_REPLSRC_PORT =3D 1 << 10,
+	XT_CONNTRACK_REPLDST_PORT =3D 1 << 11,
+	XT_CONNTRACK_DIRECTION    =3D 1 << 12,
+};
=20
 /* This is exposed to userspace, so remains frozen in time. */
 struct ip_conntrack_old_tuple
@@ -70,8 +74,10 @@ struct xt_conntrack_mtinfo1 {
 	union nf_inet_addr repldst_addr, repldst_mask;
 	u_int32_t expires_min, expires_max;
 	u_int16_t l4proto;
+	__be16 origsrc_port, origdst_port;
+	__be16 replsrc_port, repldst_port;
+	u_int16_t match_flags, invert_flags;
 	u_int8_t state_mask, status_mask;
-	u_int8_t match_flags, invert_flags;
 };
=20
 #endif /*_XT_CONNTRACK_H*/
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.=
c
index e92190e..8533085 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -4,7 +4,6 @@
  *
  *	(C) 2001  Marc Boucher (marc@mbsi.ca).
  *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
- *	Jan Engelhardt <jengelh@computergmbh.de>
  *
  *	This program is free software; you can redistribute it and/or modif=
y
  *	it under the terms of the GNU General Public License version 2 as
@@ -20,6 +19,7 @@
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: connection tracking state match");
 MODULE_ALIAS("ipt_conntrack");
 MODULE_ALIAS("ip6t_conntrack");
@@ -166,6 +166,44 @@ conntrack_mt_repldst(const struct nf_conn *ct,
 	       &info->repldst_addr, &info->repldst_mask, family);
 }
=20
+static inline bool
+ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
+                    const struct nf_conn *ct)
+{
+	const struct nf_conntrack_tuple *tuple;
+
+	tuple =3D &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
+	    (tuple->dst.protonum =3D=3D info->l4proto) ^
+	    !(info->invert_flags & XT_CONNTRACK_PROTO))
+		return false;
+
+	/* Shortcut to match all recognized protocols by using ->src.all. */
+	if ((info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) &&
+	    (tuple->src.u.all =3D=3D info->origsrc_port) ^
+	    !(info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT))
+		return false;
+
+	if ((info->match_flags & XT_CONNTRACK_ORIGDST_PORT) &&
+	    (tuple->dst.u.all =3D=3D info->origdst_port) ^
+	    !(info->invert_flags & XT_CONNTRACK_ORIGDST_PORT))
+		return false;
+
+	tuple =3D &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	if ((info->match_flags & XT_CONNTRACK_REPLSRC_PORT) &&
+	    (tuple->src.u.all =3D=3D info->replsrc_port) ^
+	    !(info->invert_flags & XT_CONNTRACK_REPLSRC_PORT))
+		return false;
+
+	if ((info->match_flags & XT_CONNTRACK_REPLDST_PORT) &&
+	    (tuple->dst.u.all =3D=3D info->repldst_port) ^
+	    !(info->invert_flags & XT_CONNTRACK_REPLDST_PORT))
+		return false;
+
+	return true;
+}
+
 static bool
 conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
              const struct net_device *out, const struct xt_match *matc=
h,
@@ -200,10 +238,9 @@ conntrack_mt(const struct sk_buff *skb, const stru=
ct net_device *in,
=20
 	if (ct =3D=3D NULL)
 		return info->match_flags & XT_CONNTRACK_STATE;
-
-	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
-	    ((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum =3D=3D
-	    info->l4proto) ^ !(info->invert_flags & XT_CONNTRACK_PROTO)))
+	if ((info->match_flags & XT_CONNTRACK_DIRECTION) &&
+	    (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL) ^
+	    !!(info->invert_flags & XT_CONNTRACK_DIRECTION))
 		return false;
=20
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
@@ -226,6 +263,9 @@ conntrack_mt(const struct sk_buff *skb, const struc=
t net_device *in,
 		    !(info->invert_flags & XT_CONNTRACK_REPLDST))
 			return false;
=20
+	if (!ct_proto_port_check(info, ct))
+		return false;
+
 	if ((info->match_flags & XT_CONNTRACK_STATUS) &&
 	    (!!(info->status_mask & ct->status) ^
 	    !(info->invert_flags & XT_CONNTRACK_STATUS)))

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
