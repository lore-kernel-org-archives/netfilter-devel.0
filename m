From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Wed, 16 Jan 2008 19:02:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53860 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYAPSCv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:02:51 -0500
In-Reply-To: <478CBF6D.3060309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 15 2008 15:13, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Jan 15 2008 07:48, Patrick McHardy wrote:
>> > This reminded me - while we're introducing new revisions, there
>> > are two things that have always been missing from xt_conntrack
>> > and I know of multiple patches adding this. One is port matching
>> > for both directions, the other is matching on the direction
>> > itself. Would you be interested in adding this? Otherwise I'm
>> > going to take care of it myself.
>> >
>> 
>> I will take care of that, yes.
>
> Thanks.
>

This patch also removes the ugly #include <linux/in.h>, which is already
found in netfilter.h (which is a better place).

===
commit 17934f6d825d2a6785cd8d7811997a8620cfd528
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 16 18:58:49 2008 +0100

    [NETFILTER]: xt_conntrack: add port and direction matching
    
    Extend the xt_conntrack match revision 1 by port matching (all four
    {orig,repl}{src,dst}) and by packet direction matching.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index d2492a3..9e35ccd 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -6,9 +6,6 @@
 #define _XT_CONNTRACK_H
 
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
-#ifdef __KERNEL__
-#	include <linux/in.h>
-#endif
 
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
 #define XT_CONNTRACK_STATE_INVALID (1 << 0)
@@ -18,14 +15,21 @@
 #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
 
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
+	XT_CONNTRACK_STATE        = 1 << 0,
+	XT_CONNTRACK_PROTO        = 1 << 1,
+	XT_CONNTRACK_ORIGSRC      = 1 << 2,
+	XT_CONNTRACK_ORIGDST      = 1 << 3,
+	XT_CONNTRACK_REPLSRC      = 1 << 4,
+	XT_CONNTRACK_REPLDST      = 1 << 5,
+	XT_CONNTRACK_STATUS       = 1 << 6,
+	XT_CONNTRACK_EXPIRES      = 1 << 7,
+	XT_CONNTRACK_ORIGSRC_PORT = 1 << 8,
+	XT_CONNTRACK_ORIGDST_PORT = 1 << 9,
+	XT_CONNTRACK_REPLSRC_PORT = 1 << 10,
+	XT_CONNTRACK_REPLDST_PORT = 1 << 11,
+	XT_CONNTRACK_DIRECTION    = 1 << 12,
+};
 
 /* This is exposed to userspace, so remains frozen in time. */
 struct ip_conntrack_old_tuple
@@ -70,8 +74,10 @@ struct xt_conntrack_mtinfo1 {
 	union nf_inet_addr repldst_addr, repldst_mask;
 	u_int32_t expires_min, expires_max;
 	u_int16_t l4proto;
+	u_int16_t origsrc_port, origdst_port;
+	u_int16_t replsrc_port, repldst_port;
+	u_int16_t match_flags, invert_flags;
 	u_int8_t state_mask, status_mask;
-	u_int8_t match_flags, invert_flags;
 };
 
 #endif /*_XT_CONNTRACK_H*/
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index e92190e..851cba6 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -166,6 +166,67 @@ conntrack_mt_repldst(const struct nf_conn *ct,
 	       &info->repldst_addr, &info->repldst_mask, family);
 }
 
+static inline bool
+ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
+                    const struct nf_conn *ct)
+{
+	const struct nf_conntrack_tuple *tuple;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	if (info->match_flags & XT_CONNTRACK_PROTO)
+		if ((tuple->dst.protonum == info->l4proto) ^
+		    !(info->invert_flags & XT_CONNTRACK_PROTO))
+			return false;
+
+	switch (tuple->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		/*
+		 * shortcut by using .u.all rather than
+		 * .u.tcp.port + .u.udp.port!
+		 */
+		if ((info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) &&
+		    (tuple->src.u.all != info->origsrc_port) ^
+		    !(info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT))
+			return false;
+		if ((info->match_flags & XT_CONNTRACK_ORIGDST_PORT) &&
+		    (tuple->dst.u.all != info->origdst_port) ^
+		    !(info->invert_flags & XT_CONNTRACK_ORIGDST_PORT))
+			return false;
+		break;
+	default:
+		if ((info->match_flags ^ info->invert_flags) &
+		    (XT_CONNTRACK_ORIGSRC_PORT | XT_CONNTRACK_ORIGDST_PORT))
+			return false;
+		break;
+	}
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	switch (tuple->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		/* shortcut by using ->src.all */
+		if ((info->match_flags & XT_CONNTRACK_REPLSRC_PORT) &&
+		    (tuple->src.u.all != info->replsrc_port) ^
+		    !(info->invert_flags & XT_CONNTRACK_REPLSRC_PORT))
+			return false;
+		if ((info->match_flags & XT_CONNTRACK_REPLDST_PORT) &&
+		    (tuple->dst.u.all != info->repldst_port) ^
+		    !(info->invert_flags & XT_CONNTRACK_REPLDST_PORT))
+			return false;
+		break;
+	default:
+		if ((info->match_flags ^ info->invert_flags) &
+		    (XT_CONNTRACK_REPLSRC_PORT | XT_CONNTRACK_REPLDST_PORT))
+			return false;
+		break;
+	}
+
+	return true;
+}
+
 static bool
 conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
              const struct net_device *out, const struct xt_match *match,
@@ -200,10 +261,11 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 
 	if (ct == NULL)
 		return info->match_flags & XT_CONNTRACK_STATE;
-
-	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
-	    ((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum ==
-	    info->l4proto) ^ !(info->invert_flags & XT_CONNTRACK_PROTO)))
+	if (!ct_proto_port_check(info, ct))
+		return false;
+	if ((info->match_flags & XT_CONNTRACK_DIRECTION) &&
+	    (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) ^
+	    !!(info->invert_flags & XT_CONNTRACK_DIRECTION))
 		return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
