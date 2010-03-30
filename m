From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of
 the connection tracking tuple for bridged traffic
Date: Tue, 30 Mar 2010 17:27:35 +0200
Message-ID: <1269962855.10116.15.camel@edumazet-laptop>
References: <4BB207B5.2020001@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64956 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0C3P1n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:27:43 -0400
Received: by bwz1 with SMTP id 1so4471053bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Mar 2010 08:27:41 -0700 (PDT)
In-Reply-To: <4BB207B5.2020001@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 30 mars 2010 =C3=A0 16:16 +0200, Bart De Schuymer a =C3=A9crit=
 :
> bridge-netfilter: use the vlan id as part of the connection tracking =
tuple for bridged traffic
>=20
> Currently connection tracking isn't aware of the vlan id that bridged
> encapsulated IP packets belong to. Since it's possible to enable
> filtering of bridged IP traffic encapsulated in a vlan header, we
> have a security risk if an overlapping IP network range is used on
> different vlan networks. By making the connection tracking code use
> the vlan id as part of the tuple, we eliminate this security risk.
> Something similar could be done for IP traffic encapsulated in PPPoE,
> but I'm not sure it's worth the effort.
>=20
> Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
>=20
> --- linux-2.6.33/net/netfilter/nf_conntrack_core.c	2010-02-24 19:52:1=
7.000000000 +0100
> +++ linux-2.6.33-uml/net/netfilter/nf_conntrack_core.c	2010-03-30 12:=
33:00.000000000 +0200
> @@ -32,6 +32,7 @@
>  #include <linux/mm.h>
>  #include <linux/nsproxy.h>
>  #include <linux/rculist_nulls.h>
> +#include <linux/netfilter_bridge.h>
> =20
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_l3proto.h>
> @@ -110,6 +111,11 @@ nf_ct_get_tuple(const struct sk_buff *sk
> =20
>  	tuple->dst.protonum =3D protonum;
>  	tuple->dst.dir =3D IP_CT_DIR_ORIGINAL;
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	/* +1 because 0 identifies no vlan encapsulation */
> +	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_8021Q))
> +		tuple->dst.vlan_id =3D (ntohs(*(u_int16_t *)(skb->data - VLAN_HLEN=
)) & VLAN_VID_MASK) + 1;
> +#endif
> =20
>  	return l4proto->pkt_to_tuple(skb, dataoff, tuple);
>  }
> @@ -158,6 +164,9 @@ nf_ct_invert_tuple(struct nf_conntrack_t
>  	inverse->dst.dir =3D !orig->dst.dir;
> =20
>  	inverse->dst.protonum =3D orig->dst.protonum;
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	inverse->dst.vlan_id =3D orig->dst.vlan_id;
> +#endif
>  	return l4proto->invert_tuple(inverse, orig);
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
> --- linux-2.6.33/include/net/netfilter/nf_conntrack_tuple.h	2010-02-2=
4 19:52:17.000000000 +0100
> +++ linux-2.6.33-uml/include/net/netfilter/nf_conntrack_tuple.h	2010-=
03-30 12:34:13.000000000 +0200
> @@ -94,6 +94,9 @@ struct nf_conntrack_tuple {
> =20
>  		/* The direction (for tuplehash) */
>  		u_int8_t dir;
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +		u_int16_t vlan_id;
> +#endif
>  	} dst;
>  };
> =20
> @@ -163,7 +166,11 @@ static inline bool __nf_ct_tuple_dst_equ
>  {
>  	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
>  		t1->dst.u.all =3D=3D t2->dst.u.all &&
> -		t1->dst.protonum =3D=3D t2->dst.protonum);
> +		t1->dst.protonum =3D=3D t2->dst.protonum
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +		&& likely(t1->dst.vlan_id =3D=3D t2->dst.vlan_id)
> +#endif
> +		);
>  }
> =20
>  static inline bool nf_ct_tuple_equal(const struct nf_conntrack_tuple=
 *t1,
>=20

This really sounds very strange, layering violation or something.

You mix conntracking, bridge and vlan here.

Why setups without bridge should not care of vlan + conntracking side
effects ?

This whole idea was discussed last November :=20

http://www.spinics.net/lists/netfilter-devel/msg10692.html

Patrick spoke of 'conntrack zone', and we added this concept.



commit 5d0aa2ccd4699a01cfdf14886191c249d7b45a01
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Feb 15 18:13:33 2010 +0100

    netfilter: nf_conntrack: add support for "conntrack zones"

    Normally, each connection needs a unique identity. Conntrack zones =
allow
    to specify a numerical zone using the CT target, connections in dif=
ferent
    zones can use the same identity.

    Example:

    iptables -t raw -A PREROUTING -i veth0 -j CT --zone 1
    iptables -t raw -A OUTPUT -o veth1 -j CT --zone 1

    Signed-off-by: Patrick McHardy <kaber@trash.net>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
