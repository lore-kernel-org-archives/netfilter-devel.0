From: Sebastian Classen <sebastian.classen@freenet.ag>
Subject: Re: new target: -j TEE
Date: Thu, 13 Sep 2007 09:37:07 +0200
Message-ID: <1189669027.22541.6.camel@basti79.freenet-ag.de>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
	<Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	<1188237343.4548.4.camel@calypso> <46D5C304.9040102@trash.net>
	<Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
	<20070830070004.GF8438@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ybe9UJ+Z0d6bTgiUmux3"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070830070004.GF8438@oknodo.bof.de>
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


--=-ybe9UJ+Z0d6bTgiUmux3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 30.08.2007, 09:00 +0200 schrieb Patrick Schaaf:
> >  * RETURN: -1 if an error occured
> >  *          1 if the packet was succesfully routed to the=20
> >  *            destination desired
> >  *          0 if the kernel routing table could not route the packet
> >  *            according to the keys specified
> >  */
> > static int route(struct sk_buff *skb,
> >                  const struct xt_TEE_info *info)
> ...
> > 	/* Trying to route the packet using the standard routing table. */
> > 	if ((err =3D ip_route_output_key(&rt, &fl)) !=3D 0) {
> > 		if (net_ratelimit())=20
> > 			pr_debug(KBUILD_MODNAME
> > 			         "could not route pkt (err: %d)", err);
> > 		return -1;
> > 	}
>=20
> Comment does not match behaviour. Suggest to change comment, and make
> function return 0/1 only.

OK, fixed.

> > static inline void route_gw(const struct xt_TEE_info *info, struct sk_b=
uff *skb)=20
> > {
> > 	if (route(skb, info) !=3D 1)
> > 		return;
> > 	ip_direct_send(skb);
> > }
>=20
> Too small, and only called once, to warrant being a function.

Function removed.

> > 	/*
> > 	 * If we are at PREROUTING or INPUT hook,
> > 	 * the TTL is not decreased by the IP stack
> > 	 */
> > 	if (hooknum =3D=3D NF_IP_PRE_ROUTING || hooknum =3D=3D NF_IP_LOCAL_IN)=
 {
> ...
> > 		if (iph->ttl <=3D 1) {
> ...
>=20
> I believe this case (the whole synthesizing an ICMP_TIME_EXCEEDED) is not
> neccessary for TEE.
>=20
> The code is working on the original skb. With ROUTE, the logic was that
> the skb would be dropped soon due to exceeding TTL, and if we reroute
> and send directly now, that wouldn't happen.
>=20
> With TEE (as well as the previous ROUTE --tee option), the original
> packet is not rerouted, and ICMP_TIME_EXCEEDED should be generated
> for it as usual. Right?
>=20
> That would leave two questions:
>=20
> Should we skb_copy+route for the above quoted conditions, i.e. hook
> PRE_ROUTING/LOCAL_IN and skb->ttl <=3D 1, although the tee'd packet will
> be dropped soon?
>=20
> And if we decide to tee the packet regardless of the ttl condition,
> should the ttl be decremented after skb_copy on the teed packet,
> or not?
>=20
> My gut feeling is to remove all ttl handling, and let the next hop of
> the teed packet handle ttl as if it were the original recipient,
> instead of our tee pot.
>=20

I would also suggest to remove TTL handling completly and already did
so. Find the new xt_TEE.c attached.

@Jan: Could you please add the new version to your SVN repository.
Thanks.

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
Vorstand: Eckhard Spoerr (Vors.), Axel Krieger, Stephan Esch, Eric Berger
Sitz: B=FCdelsdorf
Amtsgericht Kiel HRB 7306 KI

--=-ybe9UJ+Z0d6bTgiUmux3
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
 * RETURN:  false - if an error occured
 *          true  - if the packet was succesfully routed to the=20
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
       =20
        /* The destination address may be overloaded by the target */
        if (info->gw !=3D 0)
                fl.fl4_dst =3D info->gw;
       =20
        /* Trying to route the packet using the standard routing table. */
        err =3D ip_route_output_key(&rt, &fl);
        if (err !=3D 0) {
                if (net_ratelimit())=20
                        pr_debug(KBUILD_MODNAME
                                 "could not route pkt (err: %d)", err);
                return false;
        }
       =20
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
        if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header !=3D NU=
LL)) {
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
                        pr_debug(KBUILD_MODNAME "no hdr & no neighbour cach=
e!\n");
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
         * If we are at INPUT the checksum must be recalculated since
         * the length could change as the result of a defragmentation.
         */
        if (hooknum =3D=3D NF_IP_LOCAL_IN) {
                iph->check =3D 0;
                iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl)=
;
        }

        /*
         * Copy the *pskb, and route the copy. Will later return XT_CONTINU=
E
         * for the original skb, which should continue on its way as if not=
hing
         * has happened. The copy should be independantly delivered to the =
TEE
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
                if (route(info, skb))
			ip_direct_send(skb);
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
MODULE_AUTHOR("Sebastian Classen <sebastian.classen@freenet.ag>, Jan Engelh=
ardt <jengelh@computergmbh.de>");
MODULE_DESCRIPTION("netfilter TEE target module");
MODULE_LICENSE("GPL");


--=-ybe9UJ+Z0d6bTgiUmux3--
