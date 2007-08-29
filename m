From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: new target: -j TEE
Date: Wed, 29 Aug 2007 21:33:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
	<Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	<1188237343.4548.4.camel@calypso> <46D5C304.9040102@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-1062895307-1188415992=:24730"
Cc: netfilter-devel@lists.netfilter.org,
	=?ISO-8859-15?Q?Sebastian_Cla=DFen?= <Sebastian.Classen@freenet.ag>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D5C304.9040102@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1062895307-1188415992=:24730
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Aug 29 2007 21:03, Patrick McHardy wrote:
> Please don't post gzipped patches (Sebastian) or links if the
> patch isn't excessively large. I don't look at these things,
> and I suspect a lot of others neither.

I hope you don't require unidiff patches in this stage. It's just
additionss anyway. Of course, if you'd like one, I create one,
for a git tree of your choice. Posted code below is for 2.6.22.

>>> Makefile.ladd <<<
obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) +=3D xt_TEE.o

>>> Kconfig.ladd <<<
config NETFILTER_XT_TARGET_TEE
	tristate '"TEE" target support'
	depends on NETFILTER_XTABLES && IP_NF_MANGLE
	---help---
	  This option adds a "TEE" target, which enables you to duplicate
	  packets and route those duplicates to a different gateway.
=09
	  The target has to be used inside the mangle table.
	 =20
	  If you want to compile it as a module, say M here and read
	  Documentation/modules.txt. The module will be called xt_TEE.ko.
	  If unsure, say N.

>>> xt_TEE.h <<<
/* Header file for iptables ipt_TEE target
 *
 * (C) 2006 by Sebastian Classen <sebastian.classen@freenet.ag>
 * based on ipt_ROUTE.h from C=C3=A9dric de Launois <delaunois@info.ucl.a=
c.be>
 *
 * This software is distributed under GNU GPL v2, 1991
 */
#ifndef _XT_TEE_TARGET_H
#define _XT_TEE_TARGET_H

struct xt_TEE_info {
	u_int32_t gw;	/* IP address of gateway */
};

#endif /* _XT_TEE_TARGET_H */

>>> xt_TEE.c <<<
/*
 * This implements the TEE target.
 *
 * Copyright (C) 2007 Sebastian.Classen <sebastian.classen@freenet.de>
 * Jan Engelhardt <jengelh@computergmbh.de>, 2007
 * based on ipt_ROUTE.c from C=C3=A9dric de Launois <delaunois@info.ucl.a=
c.be>
 *
 * This software is distributed under GNU GPL v2, 1991
 */
#include <linux/ip.h>
#include <linux/module.h>
#include <linux/netfilter/x_tables.h>
#include <linux/route.h>
#include <linux/skbuff.h>
#include <net/checksum.h>
#include <net/icmp.h>
#include <net/ip.h>
#include <net/netfilter/nf_conntrack.h>
#include <net/route.h>
#include "xt_TEE.h"

static struct nf_conn tee_track;

/*
 * Try to route the packet according to the routing keys specified in
 * route_info. Keys are :
 *  - ifindex :=20
 *      0 if no oif preferred,=20
 *      otherwise set to the index of the desired oif
 *  - route_info->gw :
 *      0 if no gateway specified,
 *      otherwise set to the next host to which the pkt must be routed
 * If success, skb->dev is the output device to which the packet must=20
 * be sent and skb->dst is not NULL
 *
 * RETURN: -1 if an error occured
 *          1 if the packet was succesfully routed to the=20
 *            destination desired
 *          0 if the kernel routing table could not route the packet
 *            according to the keys specified
 */
static int route(struct sk_buff *skb,
                 const struct xt_TEE_info *info)
{
	int err;
	struct rtable *rt;
	struct iphdr *iph =3D ip_hdr(skb);
	struct flowi fl =3D {
		.oif =3D 0,
		.nl_u =3D {
			.ip4_u =3D {
				.daddr =3D iph->daddr,
				.saddr =3D 0,
				.tos   =3D RT_TOS(iph->tos),
				.scope =3D RT_SCOPE_UNIVERSE,
			}
		}=20
	};
=09
	/* The destination address may be overloaded by the target */
	if (info->gw !=3D 0)
		fl.fl4_dst =3D info->gw;
=09
	/* Trying to route the packet using the standard routing table. */
	if ((err =3D ip_route_output_key(&rt, &fl)) !=3D 0) {
		if (net_ratelimit())=20
			pr_debug(KBUILD_MODNAME
			         "could not route pkt (err: %d)", err);
		return -1;
	}
=09
	/* Drop old route. */
	dst_release(skb->dst);
	skb->dst =3D NULL;

	/* Success if no oif specified or if the oif correspond to the=20
	 * one desired */
	/* SC: allways the case, because we have no oif. */
	skb->dst      =3D &rt->u.dst;
	skb->dev      =3D skb->dst->dev;
	skb->protocol =3D htons(ETH_P_IP);
	return 1;
}

/* Stolen from ip_finish_output2
 * PRE : skb->dev is set to the device we are leaving by
 *       skb->dst is not NULL
 * POST: the packet is sent with the link layer header pushed
 *       the packet is destroyed
 */
static void ip_direct_send(struct sk_buff *skb)
{
	struct dst_entry *dst =3D skb->dst;
	struct net_device *dev =3D dst->dev;
	int hh_len =3D LL_RESERVED_SPACE(dev);

	/* Be paranoid, rather than too clever. */
	if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header)) {
		struct sk_buff *skb2;

		skb2 =3D skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
		if (skb2 =3D=3D NULL) {
			kfree_skb(skb);
			return;
		}
		if (skb->sk)
			skb_set_owner_w(skb2, skb->sk);
		kfree_skb(skb);
		skb =3D skb2;
	}

	if (dst->hh) {
                neigh_hh_output(dst->hh, skb);
	} else if (dst->neighbour) {
		dst->neighbour->output(skb);
	} else {
		if (net_ratelimit())
			pr_debug(KBUILD_MODNAME "no hdr & no neighbour cache!\n");
		kfree_skb(skb);
	}
}

static inline void route_gw(const struct xt_TEE_info *info, struct sk_buf=
f *skb)=20
{
	if (route(skb, info) !=3D 1)
		return;

	ip_direct_send(skb);
}


/*
 * To detect and deter routed packet loopback when using the --tee option=
, we
 * take a page out of the raw.patch book: on the copied skb, we set up a =
fake
 * ->nfct entry, pointing to the local &route_tee_track. We skip routing
 * packets when we see they already have that ->nfct.
 */


static unsigned int
xt_TEE_target(struct sk_buff **pskb, const struct net_device *in,
              const struct net_device *out, unsigned int hooknum,
              const struct xt_target *target, const void *targinfo)
{
	const struct xt_TEE_info *info =3D targinfo;
	struct sk_buff *skb =3D *pskb;

	if (skb->nfct =3D=3D &tee_track.ct_general) {
		/*
		 * Loopback - a packet we already routed, is to be
		 * routed another time. Avoid that, now.
		 */
		if (net_ratelimit())=20
			pr_debug(KBUILD_MODNAME "loopback - DROP!\n");
		return NF_DROP;
	}

	/*
	 * If we are at PREROUTING or INPUT hook,
	 * the TTL is not decreased by the IP stack
	 */
	if (hooknum =3D=3D NF_IP_PRE_ROUTING || hooknum =3D=3D NF_IP_LOCAL_IN) {
		struct iphdr *iph =3D ip_hdr(skb);

		if (iph->ttl <=3D 1) {
			struct rtable *rt;
			struct flowi fl =3D {
				.oif =3D 0,
				.nl_u =3D {
					.ip4_u =3D {
						.daddr =3D iph->daddr,
						.saddr =3D iph->saddr,
						.tos   =3D RT_TOS(iph->tos),
						.scope =3D ((iph->tos & RTO_ONLINK) ?
						         RT_SCOPE_LINK :
						         RT_SCOPE_UNIVERSE)
					}
				}=20
			};

			if (ip_route_output_key(&rt, &fl))
				return NF_DROP;

			if (skb->dev =3D=3D rt->u.dst.dev) {
				/* Drop old route */
				dst_release(skb->dst);
				skb->dst =3D &rt->u.dst;

				/*
				 * this will traverse the normal stack and=20
				 * thus call conntrack on the ICMP packet
				 */
				icmp_send(skb, ICMP_TIME_EXCEEDED,=20
				          ICMP_EXC_TTL, 0);
			}

			return NF_DROP;
		}

		/*
		 * If we are at INPUT the checksum must be recalculated since
		 * the length could change as the result of a defragmentation.
		 */
		if (hooknum =3D=3D NF_IP_LOCAL_IN) {
			--iph->ttl;
			iph->check =3D 0;
			iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
		} else {
			ip_decrease_ttl(iph);
		}
	}

	/*
	 * Copy the *pskb, and route the copy. Will later return XT_CONTINUE
	 * for the original skb, which should continue on its way as if nothing
	 * has happened. The copy should be independantly delivered to the TEE
	 * --gw.
	 */
	skb =3D skb_copy(*pskb, GFP_ATOMIC);
	if (skb =3D=3D NULL) {
		if (net_ratelimit())=20
			pr_debug(KBUILD_MODNAME "copy failed!\n");
		return XT_CONTINUE;
	}

	/*
	 * Tell conntrack to forget this packet since it may get confused=20
	 * when a packet is leaving with dst address =3D=3D our address.
	 * Good idea? Dunno. Need advice.
	 *
	 * NEW: mark the skb with our &tee_track, so we avoid looping
	 * on any already routed packet.
	 */
	nf_conntrack_put(skb->nfct);
	skb->nfct     =3D &tee_track.ct_general;
	skb->nfctinfo =3D IP_CT_NEW;
	nf_conntrack_get(skb->nfct);

	if (info->gw !=3D 0)
		route_gw(info, skb);
	else if (net_ratelimit())
		pr_debug(KBUILD_MODNAME "no parameter!\n");

	return XT_CONTINUE;
}

static struct xt_target xt_TEE_reg __read_mostly =3D {
	.name       =3D "TEE",
        .family     =3D AF_INET,
	.table      =3D "mangle",
	.hooks      =3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
	              (1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT) |
	              (1 << NF_IP_POST_ROUTING),
	.target     =3D xt_TEE_target,
	.targetsize =3D sizeof(struct xt_TEE_info),
	.me         =3D THIS_MODULE,
};

static int __init xt_TEE_init(void)
{
	/*
	 * Set up fake conntrack (stolen from raw.patch):
	 * - to never be deleted, not in any hashes
	 */
	atomic_set(&tee_track.ct_general.use, 1);

	/* - and look it like as a confirmed connection */
	set_bit(IPS_CONFIRMED_BIT, &tee_track.status);

	/* Initialize fake conntrack so that NAT will skip it */
	tee_track.status |=3D IPS_NAT_DONE_MASK;

	return xt_register_target(&xt_TEE_reg);
}

static void __exit xt_TEE_exit(void)
{
	xt_unregister_target(&xt_TEE_reg);
	/* SC: shoud not we cleanup tee_track here? */
}

module_init(xt_TEE_init);
module_exit(xt_TEE_exit);
MODULE_AUTHOR("Sebastian Classen <sebastian.classen@freenet.ag>, Jan Enge=
lhardt <jengelh@computergmbh.de>");
MODULE_DESCRIPTION("netfilter TEE target module");
MODULE_LICENSE("GPL");
---699020219-1062895307-1188415992=:24730--
