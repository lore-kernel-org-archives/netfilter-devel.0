From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 2/4] xt_TEE
Date: Sun, 25 Nov 2007 20:06:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.de>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37590 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXKYTGc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:06:32 -0500
In-Reply-To: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Netfilter: Import xt_TEE


Originally from Sebastian Classen.
xt_TEE is the logical successor to ipt_ROUTE; routing based on packet
charactersitics is done using xt_MARK/iproute2/fwmark nowadays, so
what remains of ipt_ROUTE is the --tee option, which xt_TEE implements.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sebastian Classen <sebastian.classen@freenet.de>

---
 include/linux/netfilter/xt_TEE.h |   12 +
 net/netfilter/Kconfig            |   13 ++
 net/netfilter/Makefile           |    1=20
 net/netfilter/xt_TEE.c           |  240 ++++++++++++++++++++++++++++++=
+++++++++
 4 files changed, 266 insertions(+)

Index: linux-2.6/include/linux/netfilter/xt_TEE.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/include/linux/netfilter/xt_TEE.h
@@ -0,0 +1,12 @@
+#ifndef _XT_TEE_TARGET_H
+#define _XT_TEE_TARGET_H
+
+struct xt_tee_target_info {
+	union {
+		/* Address of gateway */
+		u_int32_t gateway_v4;
+		u_int32_t gateway_v6[4];
+	};
+};
+
+#endif /* _XT_TEE_TARGET_H */
Index: linux-2.6/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -411,6 +411,19 @@ config NETFILTER_XT_TARGET_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TEE
+	tristate '"TEE" target support'
+	depends on NETFILTER_XTABLES && IP_NF_MANGLE
+	---help---
+	  This option adds a "TEE" target, which enables you to duplicate
+	  packets and route those duplicates to a different gateway.
+
+	  The target has to be used inside the mangle table.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt. The module will be called xt_TEE.ko.
+	  If unsure, say N.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Makefile
+++ linux-2.6/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) +=3D xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
=20
 # matches
Index: linux-2.6/net/netfilter/xt_TEE.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/net/netfilter/xt_TEE.c
@@ -0,0 +1,240 @@
+/*
+ * This implements the TEE target.
+ *
+ * Copyright (C) 2007 Sebastian Classen <sebastian.classen@freenet.de>=
 and
+ * CC Computer Consultants GmbH, 2007
+ * (Contact: Jan Engelhardt <jengelh@computergmbh.de>)
+ *
+ * based on ipt_ROUTE.c from C=C3=A9dric de Launois <delaunois@info.uc=
l.ac.be>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ */
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/route.h>
+#include <linux/skbuff.h>
+#include <net/checksum.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/route.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TEE.h>
+
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE=
)
+#	define WITH_CONNTRACK 1
+#	include <net/netfilter/nf_conntrack.h>
+static struct nf_conn tee_track;
+#endif
+
+/*
+ * Try to route the packet according to the routing keys specified in
+ * route_info. Keys are :
+ *  - ifindex :
+ *      0 if no oif preferred,
+ *      otherwise set to the index of the desired oif
+ *  - route_info->gateway :
+ *      0 if no gateway specified,
+ *      otherwise set to the next host to which the pkt must be routed
+ * If success, skb->dev is the output device to which the packet must
+ * be sent and skb->dst is not NULL
+ *
+ * RETURN: false - if an error occured
+ *         true  - if the packet was succesfully routed to the
+ *                 destination desired
+ */
+static bool tee_routing(struct sk_buff *skb,
+                        const struct xt_tee_target_info *info)
+{
+	int err;
+	struct rtable *rt;
+	struct iphdr *iph =3D ip_hdr(skb);
+	struct flowi fl =3D {
+		.nl_u =3D {
+			.ip4_u =3D {
+				.daddr =3D iph->daddr,
+				.tos   =3D RT_TOS(iph->tos),
+				.scope =3D RT_SCOPE_UNIVERSE,
+			}
+		}
+	};
+
+	/* The destination address may be overloaded by the target */
+	if (info->gateway_v4 !=3D 0)
+		fl.fl4_dst =3D info->gateway_v4;
+
+	/* Trying to route the packet using the standard routing table. */
+	err =3D ip_route_output_key(&rt, &fl);
+	if (err !=3D 0) {
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME
+			         ": could not route packet (%d)", err);
+		return false;
+	}
+
+	/* Drop old route. */
+	dst_release(skb->dst);
+	skb->dst =3D NULL;
+
+	/*
+	 * Success if no oif specified or if the oif correspond to the
+	 * one desired.
+	 * [SC]: always the case, because we have no oif.
+	 */
+	skb->dst      =3D &rt->u.dst;
+	skb->dev      =3D skb->dst->dev;
+	skb->protocol =3D htons(ETH_P_IP);
+	return true;
+}
+
+/*
+ * Stolen from ip_finish_output2
+ * PRE : skb->dev is set to the device we are leaving by
+ *       skb->dst is not NULL
+ * POST: the packet is sent with the link layer header pushed
+ *       the packet is destroyed
+ */
+static void tee_ip_direct_send(struct sk_buff *skb)
+{
+	const struct dst_entry *dst  =3D skb->dst;
+	const struct net_device *dev =3D dst->dev;
+	unsigned int hh_len =3D LL_RESERVED_SPACE(dev);
+
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops !=3D NULL)=
) {
+		struct sk_buff *skb2;
+
+		skb2 =3D skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
+		if (skb2 =3D=3D NULL) {
+			kfree_skb(skb);
+			return;
+		}
+		if (skb->sk !=3D NULL)
+			skb_set_owner_w(skb2, skb->sk);
+		kfree_skb(skb);
+		skb =3D skb2;
+	}
+
+	if (dst->hh !=3D NULL) {
+		neigh_hh_output(dst->hh, skb);
+	} else if (dst->neighbour !=3D NULL) {
+		dst->neighbour->output(skb);
+	} else {
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME "no hdr & no neighbour cache!\n");
+		kfree_skb(skb);
+	}
+}
+
+/*
+ * To detect and deter routed packet loopback when using the --tee opt=
ion, we
+ * take a page out of the raw.patch book: on the copied skb, we set up=
 a fake
+ * ->nfct entry, pointing to the local &route_tee_track. We skip routi=
ng
+ * packets when we see they already have that ->nfct.
+ */
+static unsigned int
+tee_tg(struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, unsigned int hooknum,
+       const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tee_target_info *info =3D targinfo;
+
+#ifdef WITH_CONNTRACK
+	if (skb->nfct =3D=3D &tee_track.ct_general) {
+		/*
+		 * Loopback - a packet we already routed, is to be
+		 * routed another time. Avoid that, now.
+		 */
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME "loopback - DROP!\n");
+		return NF_DROP;
+	}
+#endif
+
+	/*
+	 * If we are in INPUT, the checksum must be recalculated since
+	 * the length could have changed as a result of defragmentation.
+	 */
+	if (hooknum =3D=3D NF_INET_LOCAL_IN) {
+		struct iphdr *iph =3D ip_hdr(skb);
+		iph->check =3D 0;
+		iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
+	}
+
+	/*
+	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE f=
or
+	 * the original skb, which should continue on its way as if nothing h=
as
+	 * happened. The copy should be independantly delivered to the TEE --=
gw.
+	 */
+	skb =3D skb_copy(skb, GFP_ATOMIC);
+	if (skb =3D=3D NULL) {
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME "copy failed!\n");
+		return XT_CONTINUE;
+	}
+
+#ifdef WITH_CONNTRACK
+	/*
+	 * Tell conntrack to forget this packet since it may get confused
+	 * when a packet is leaving with dst address =3D=3D our address.
+	 * Good idea? Dunno. Need advice.
+	 *
+	 * NEW: mark the skb with our &tee_track, so we avoid looping
+	 * on any already routed packet.
+	 */
+	nf_conntrack_put(skb->nfct);
+	skb->nfct     =3D &tee_track.ct_general;
+	skb->nfctinfo =3D IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+#endif
+
+	if (info->gateway_v4 !=3D 0) {
+		if (tee_routing(skb, info))
+			tee_ip_direct_send(skb);
+	} else {
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME ": no parameter!\n");
+	}
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target tee_tg_reg __read_mostly =3D {
+	.name       =3D "TEE",
+	.family     =3D AF_INET,
+	.table      =3D "mangle",
+	.target     =3D tee_tg,
+	.targetsize =3D sizeof(struct xt_tee_target_info),
+	.me         =3D THIS_MODULE,
+};
+
+static int __init tee_tg_init(void)
+{
+#ifdef WITH_CONNTRACK
+	/*
+	 * Set up fake conntrack (stolen from raw.patch):
+	 * - to never be deleted, not in any hashes
+	 */
+	atomic_set(&tee_track.ct_general.use, 1);
+
+	/* - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &tee_track.status);
+
+	/* Initialize fake conntrack so that NAT will skip it */
+	tee_track.status |=3D IPS_NAT_DONE_MASK;
+#endif
+
+	return xt_register_target(&tee_tg_reg);
+}
+
+static void __exit tee_tg_exit(void)
+{
+	xt_unregister_target(&tee_tg_reg);
+	/* [SC]: shoud not we cleanup tee_track here? */
+}
+
+module_init(tee_tg_init);
+module_exit(tee_tg_exit);
+MODULE_AUTHOR("Sebastian Classen <sebastian.classen@freenet.ag>, Jan E=
ngelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("netfilter \"TEE\" target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TEE");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
