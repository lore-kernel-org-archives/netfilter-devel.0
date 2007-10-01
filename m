From: Sebastian Classen <sebastian.classen@freenet.ag>
Subject: Re: new target: -j TEE
Date: Mon, 01 Oct 2007 14:44:07 +0200
Message-ID: <1191242647.6469.9.camel@basti79.freenet-ag.de>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
	 <Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	 <1188237343.4548.4.camel@calypso> <46D5C304.9040102@trash.net>
	 <Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
	 <20070830070004.GF8438@oknodo.bof.de>
	 <1189669027.22541.6.camel@basti79.freenet-ag.de>
	 <1189677553.22541.11.camel@basti79.freenet-ag.de>
	 <Pine.LNX.4.64.0709142354170.10168@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-y0dhyNnL9I76DLzQkWh4"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:43581 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXJAMoK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:44:10 -0400
In-Reply-To: <Pine.LNX.4.64.0709142354170.10168@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--=-y0dhyNnL9I76DLzQkWh4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

i was in holiday, so i couldn't work on the patch for a while. But here
is the current version which seems to work with current 2.6.22.9.

For the Changelog:
 - fixed comment to route()
 - removed route_gw()
 - removed TTL handling
 - make compile without CONFIG_NF_CONNTRACK (no loop-prevention in this
case!)

Greets
  Sebastian.


--=20
Mit freundlichen Gr=FC=DFen / Yours sincerely

Sebastian Cla=DFen
Postmaster
----------------------------------------------------------------------
Telefon: + 49 (0) 211 53087 522
Telefax: + 49 (0) 211 5381573
E-Mail:  sebastian.classen@freenet.ag
Website: www.freenet.de; www.mobilcom.de
----------------------------------------------------------------------
freenet AG
Willst=E4tterstr. 13
40549 D=FCsseldorf
----------------------------------------------------------------------
Vorsitzender des Aufsichtsrates: Prof. Dr. Helmut Thoma
Vorstand: Eckhard Spoerr (Vors.), Axel Krieger, Stephan Esch, Eric
Berger
Sitz: B=FCdelsdorf
Amtsgericht Kiel HRB 7306 KI

--=-y0dhyNnL9I76DLzQkWh4
Content-Disposition: attachment; filename=xt_TEE.c
Content-Type: text/x-csrc; name=xt_TEE.c; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/*
 * This implements the TEE target.
 *
 * Copyright (C) 2007 Sebastian.Classen <sebastian.classen@freenet.de>
 * Jan Engelhardt <jengelh@computergmbh.de>, 2007
 * based on ipt_ROUTE.c from C=C3=A9dric de Launois <delaunois@info.ucl.ac.=
be>
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
#include <net/route.h>
#include <linux/netfilter/xt_TEE.h>

#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
#include <net/netfilter/nf_conntrack.h>
static struct nf_conn tee_track;
#endif

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
 * RETURN: false - if an error occured
 *         true  -  if the packet was succesfully routed to the=20
 *                  destination desired
 */
static bool route(struct sk_buff *skb,
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
	err =3D ip_route_output_key(&rt, &fl);
	if (err !=3D 0) {
		if (net_ratelimit())=20
			pr_debug(KBUILD_MODNAME
			         "could not route pkt (err: %d)", err);
		return false;
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
	return true;
}

/* Stolen from ip_finish_output2
 * PRE : skb->dev is set to the device we are leaving by
 *       skb->dst is not NULL
 * POST: the packet is sent with the link layer header pushed
 *       the packet is destroyed
 */
static void ip_direct_send(struct sk_buff *skb)
{
	const struct dst_entry *dst  =3D skb->dst;
	const struct net_device *dev =3D dst->dev;
	unsigned int hh_len =3D LL_RESERVED_SPACE(dev);

	/* Be paranoid, rather than too clever. */
	if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header !=3D NULL)) {
		struct sk_buff *skb2;

		skb2 =3D skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
		if (skb2 =3D=3D NULL) {
			kfree_skb(skb);
			return;
		}
		if (skb->sk !=3D NULL)
			skb_set_owner_w(skb2, skb->sk);
		kfree_skb(skb);
		skb =3D skb2;
	}

	if (dst->hh !=3D NULL) {
		neigh_hh_output(dst->hh, skb);
	} else if (dst->neighbour !=3D NULL) {
		dst->neighbour->output(skb);
	} else {
		if (net_ratelimit())
			pr_debug(KBUILD_MODNAME "no hdr & no neighbour cache!\n");
		kfree_skb(skb);
	}
}

/*
 * To detect and deter routed packet loopback when using the --tee option, =
we
 * take a page out of the raw.patch book: on the copied skb, we set up a fa=
ke
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

#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
	if (skb->nfct =3D=3D &tee_track.ct_general) {
		/*
		 * Loopback - a packet we already routed, is to be
		 * routed another time. Avoid that, now.
		 */
		if (net_ratelimit())=20
			pr_debug(KBUILD_MODNAME "loopback - DROP!\n");
		return NF_DROP;
	}
#endif

	/*
	 * If we are in INPUT, the checksum must be recalculated since
	 * the length could have changed as a result of defragmentation.
	 */
	if (hooknum =3D=3D NF_IP_LOCAL_IN) {
		struct iphdr *iph =3D ip_hdr(skb);
		iph->check =3D 0;
		iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
	}

	/*
	 * Copy the *pskb, and route the copy. Will later return %XT_CONTINUE
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

#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
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
#endif

	if (info->gw !=3D 0) {
		if (route(skb, info))
			ip_direct_send(skb);
	} else {
		if (net_ratelimit())
			pr_debug(KBUILD_MODNAME "no parameter!\n");
	}

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
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
	/*
	 * Set up fake conntrack (stolen from raw.patch):
	 * - to never be deleted, not in any hashes
	 */
	atomic_set(&tee_track.ct_general.use, 1);

	/* - and look it like as a confirmed connection */
	set_bit(IPS_CONFIRMED_BIT, &tee_track.status);

	/* Initialize fake conntrack so that NAT will skip it */
	tee_track.status |=3D IPS_NAT_DONE_MASK;
#endif

	return xt_register_target(&xt_TEE_reg);
}

static void __exit xt_TEE_exit(void)
{
	xt_unregister_target(&xt_TEE_reg);
	/* SC: shoud not we cleanup tee_track here? */
}

module_init(xt_TEE_init);
module_exit(xt_TEE_exit);
MODULE_AUTHOR("Sebastian Classen <sebastian.classen@freenet.ag>, Jan Engelh=
ardt <jengelh@computergmbh.de>");
MODULE_DESCRIPTION("netfilter TEE target module");
MODULE_LICENSE("GPL");

--=-y0dhyNnL9I76DLzQkWh4--

