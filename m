From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Wed, 25 Feb 2009 11:00:47 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr>
 <49A4133E.4070703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45618 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbZBYKAv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:00:51 -0500
In-Reply-To: <49A4133E.4070703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-24 16:33, Patrick McHardy wrote:
>>> Perhaps we can finally get this merged. IIRC the only reason agains=
t
>>> it is the IP layer duplication instead of simply using dst_output()=
=2E
>>>
>> It cannot use dst_output because that would cause reentrancy into ip=
tablse.
>> Want a patch, though?
>
> I would like to have a look at the current patch, yes. Don't
> bother fixing anything though, I mainly want to have a look
> at the routing part.
>
parent 499c9627ecb75566801d96f0e91c9da356b6a8c8 (v2.6.29-rc4-31-g499c96=
2)
commit 26f785f037f6fae3c1dad8644561e62e79cfe414
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 25 11:00:17 2009 +0100

netfilter: xtables: import xt_TEE target

The target can be used to duplicate packets and reroute them to
another destination on the local Ethernet segment.

TODO: Still has some issues: no neighbor discovery is done for IPv6
(meaning packets go nowhere if there is no neighbor entry) when TEE
sends a packet and the neighbor has not been looked up yet. I have no
idea why IPv6 won't do that, because it does work for IPv4/ARP.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_TEE.h |    8 +
 net/netfilter/Kconfig            |   10 +
 net/netfilter/Makefile           |    1 +
 net/netfilter/xt_TEE.c           |  319 ++++++++++++++++++++++++++++++
 4 files changed, 338 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 net/netfilter/xt_TEE.c

diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter=
/xt_TEE.h
new file mode 100644
index 0000000..83fa768
--- /dev/null
+++ b/include/linux/netfilter/xt_TEE.h
@@ -0,0 +1,8 @@
+#ifndef _XT_TEE_TARGET_H
+#define _XT_TEE_TARGET_H
+
+struct xt_tee_tginfo {
+	union nf_inet_addr gw;
+};
+
+#endif /* _XT_TEE_TARGET_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0eb98b4..eeb8258 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -430,6 +430,16 @@ config NETFILTER_XT_TARGET_RATEEST
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TEE
+	tristate '"TEE" target support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	---help---
+	This option adds a "TEE" target, which enables you to duplicate
+	packets and route those duplicates to a different gateway.
+	The target has to be used inside the mangle table.
+
 config NETFILTER_XT_TARGET_TPROXY
 	tristate '"TPROXY" target support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index da73ed2..ad2950c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) +=3D xt_NFQ=
UEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) +=3D xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) +=3D xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) +=3D xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
new file mode 100644
index 0000000..e7958a9
--- /dev/null
+++ b/net/netfilter/xt_TEE.c
@@ -0,0 +1,319 @@
+/*
+ *	"TEE" target extension for Xtables
+ *	Copyright =C2=A9 Sebastian Cla=C3=9Fen <sebastian.classen [at] free=
net de>, 2007
+ *	Jan Engelhardt <jengelh [at] medozas de>, 2007 - 2008
+ *
+ *	based on ipt_ROUTE.c from C=C3=A9dric de Launois
+ *	<delaunois [at] info ucl ac be>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2, as published by the Free Software Foundation.
+ */
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/route.h>
+#include <linux/skbuff.h>
+#include <net/checksum.h>
+#include <net/icmp.h>
+#include <net/ip.h>
+#include <net/ip6_route.h>
+#include <net/route.h>
+#include <linux/netfilter/x_tables.h>
+
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE=
)
+#	define WITH_CONNTRACK 1
+#	include <net/netfilter/nf_conntrack.h>
+static struct nf_conn tee_track;
+#endif
+
+#include <linux/netfilter/xt_TEE.h>
+
+static const union nf_inet_addr tee_zero_address;
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
+static bool
+tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
+{
+	int err;
+	struct rtable *rt;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(fl));
+	fl.nl_u.ip4_u.daddr =3D info->gw.ip;
+	fl.nl_u.ip4_u.scope =3D RT_SCOPE_UNIVERSE;
+
+	/* Trying to route the packet using the standard routing table. */
+	err =3D ip_route_output_key(&init_net, &rt, &fl);
+	if (err !=3D 0) {
+		if (net_ratelimit())
+			pr_debug(KBUILD_MODNAME
+			         ": could not route packet (%d)", err);
+		return false;
+	}
+
+	dst_release(skb->dst);
+	skb->dst      =3D &rt->u.dst;
+	skb->dev      =3D skb->dst->dev;
+	skb->protocol =3D htons(ETH_P_IP);
+	return true;
+}
+
+static inline bool dev_hh_avail(const struct net_device *dev)
+{
+	return dev->header_ops !=3D NULL;
+}
+
+/*
+ * Stolen from ip_finish_output2
+ * PRE : skb->dev is set to the device we are leaving by
+ *       skb->dst is not NULL
+ * POST: the packet is sent with the link layer header pushed
+ *       the packet is destroyed
+ */
+static void tee_tg_send(struct sk_buff *skb)
+{
+	const struct dst_entry *dst  =3D skb->dst;
+	const struct net_device *dev =3D dst->dev;
+	unsigned int hh_len =3D LL_RESERVED_SPACE(dev);
+
+	/* Be paranoid, rather than too clever. */
+	if (unlikely(skb_headroom(skb) < hh_len && dev_hh_avail(dev))) {
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
+tee_tg4(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_tee_tginfo *info =3D par->targinfo;
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
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	/*
+	 * If we are in INPUT, the checksum must be recalculated since
+	 * the length could have changed as a result of defragmentation.
+	 */
+	if (par->hooknum =3D=3D NF_INET_LOCAL_IN) {
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
+	/*
+	 * Normally, we would just use ip_local_out. Because iph->check is
+	 * already correct, we could take a shortcut and call dst_output
+	 * [forwards to ip_output] directly. ip_output however will invoke
+	 * Netfilter hooks and cause reentrancy. So we skip that too and go
+	 * directly to ip_finish_output. Since we should not do XFRM, control
+	 * passes to ip_finish_output2. That function is not exported, so it =
is
+	 * copied here as tee_ip_direct_send.
+	 *
+	 * We do no XFRM on the cloned packet on purpose! The choice of
+	 * iptables match options will control whether the raw packet or the
+	 * transformed version is cloned.
+	 *
+	 * Also on purpose, no fragmentation is done, to preserve the
+	 * packet as best as possible.
+	 */
+	if (tee_tg_route4(skb, info))
+		tee_tg_send(skb);
+
+	return XT_CONTINUE;
+}
+
+static bool
+tee_tg_route6(struct sk_buff *skb, const struct xt_tee_tginfo *info)
+{
+	struct dst_entry *dst;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(fl));
+	fl.nl_u.ip6_u.daddr =3D info->gw.in6;
+
+	dst =3D ip6_route_output(dev_net(skb->dev), NULL, &fl);
+	if (dst =3D=3D NULL) {
+		if (net_ratelimit())
+			printk(KERN_ERR "ip6_route_output failed for tee\n");
+		return false;
+	}
+
+	dst_release(skb->dst);
+	skb->dst      =3D dst;
+	skb->dev      =3D skb->dst->dev;
+	skb->protocol =3D htons(ETH_P_IPV6);
+	return true;
+}
+
+static unsigned int
+tee_tg6(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_tee_tginfo *info =3D par->targinfo;
+
+	/* Try silence. */
+#ifdef WITH_CONNTRACK
+	if (skb->nfct =3D=3D &tee_track.ct_general)
+		return NF_DROP;
+#endif
+
+	if ((skb =3D skb_copy(skb, GFP_ATOMIC)) =3D=3D NULL)
+		return XT_CONTINUE;
+
+#ifdef WITH_CONNTRACK
+	nf_conntrack_put(skb->nfct);
+	skb->nfct     =3D &tee_track.ct_general;
+	skb->nfctinfo =3D IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+#endif
+	if (tee_tg_route6(skb, info))
+		tee_tg_send(skb);
+
+	return XT_CONTINUE;
+}
+
+static bool tee_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tee_tginfo *info =3D par->targinfo;
+
+	/* 0.0.0.0 and :: not allowed */
+	return memcmp(&info->gw, &tee_zero_address,
+	       sizeof(tee_zero_address)) !=3D 0;
+}
+
+static struct xt_target tee_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "TEE",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_IPV4,
+		.table      =3D "mangle",
+		.target     =3D tee_tg4,
+		.targetsize =3D sizeof(struct xt_tee_tginfo),
+		.checkentry =3D tee_tg_check,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "TEE",
+		.revision   =3D 0,
+		.family     =3D NFPROTO_IPV6,
+		.table      =3D "mangle",
+		.target     =3D tee_tg6,
+		.targetsize =3D sizeof(struct xt_tee_tginfo),
+		.checkentry =3D tee_tg_check,
+		.me         =3D THIS_MODULE,
+	},
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
+	return xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+}
+
+static void __exit tee_tg_exit(void)
+{
+	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	/* [SC]: shoud not we cleanup tee_track here? */
+}
+
+module_init(tee_tg_init);
+module_exit(tee_tg_exit);
+MODULE_AUTHOR("Sebastian Cla=C3=9Fen <sebastian.classen@freenet.ag>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_DESCRIPTION("Xtables: Reroute packet copy");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TEE");
+MODULE_ALIAS("ip6t_TEE");
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
