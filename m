From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 19:21:17 +0900 (JST)
Message-ID: <200901231021.n0NALIWn020555@toshiba.co.jp>
References: <1232581287.16003.47.camel@ice-age>
	<200901230741.n0N7f0bx012043@toshiba.co.jp>
	<1232701347.32071.13.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: yasuyuki.kozakai@toshiba.co.jp, Marek.Szuba@if.pw.edu.pl,
	kaber@trash.net, netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:61411 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZAWKVV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:21:21 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id n0NALJkS026921
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 19:21:19 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id n0NALJ5r021605
	for netfilter-devel@vger.kernel.org; Fri, 23 Jan 2009 19:21:19 +0900 (JST)
Received: from mx11.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id n0NALJcQ025692
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 19:21:19 +0900 (JST)
In-Reply-To: <1232701347.32071.13.camel@khasse.inl.fr>
	<1232581431-15130-1-git-send-email-eric@inl.fr>
	<1232581431-15130-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

=46rom: Eric Leblond <eric@inl.fr>
Date: Fri, 23 Jan 2009 10:02:27 +0100

> Hi,
>=20
> Le vendredi 23 janvier 2009 =E0 16:40 +0900, Yasuyuki KOZAKAI a =E9cr=
it :
> > Hi, Eric,
> >=20
> > How about just using NOTRACK target ?
>=20
> This is a possible solution but you will then have to be a Netfilter
> Jedi to build a correct IPv6 filtering ruleset. I think even Padawan
> have no clue about the existence of the NOTRACK target.
>=20
> Seriously speaking, the NOTRACK target is tagged "NETFILTER_ADVANCED"
> and IPv6 is becoming more and more frequent. I don't think we should =
use
> such a complicated solution for simply obtaining an IPv6 address. We
> will loose quit a bunch of users on this.

It's reasonable. One solution is to change it and to make distributer a=
dd
NOTRACK rule to their configuration, but changing nf_conntrack would be
faster ;)


=46rom: Eric Leblond <eric@inl.fr>
Date: Thu, 22 Jan 2009 00:43:50 +0100

> This patches adds a sysctl flag to decide wheither or not detect icmp=
v6
> autoconfiguration packet as INVALID.
>=20
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv=
6/netfilter/nf_conntrack_proto_icmpv6.c
> index 0dbac72..4aa80ba 100644
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -27,6 +27,7 @@
>  #include <net/netfilter/nf_log.h>
> =20
>  static unsigned long nf_ct_icmpv6_timeout __read_mostly =3D 30*HZ;
> +static unsigned long nf_ct_icmpv6_autoconf __read_mostly =3D 0;
> =20
>  static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
>  				unsigned int dataoff,
> @@ -259,6 +260,13 @@ static struct ctl_table icmpv6_sysctl_table[] =3D=
 {
>  		.proc_handler	=3D proc_dointvec_jiffies,
>  	},
>  	{
> +		.procname	=3D "nf_conntrack_icmpv6_autoconf",
> +		.data		=3D &nf_ct_icmpv6_autoconf,
> +		.maxlen		=3D sizeof(unsigned int),
> +		.mode		=3D 0644,
> +		.proc_handler	=3D proc_dointvec_jiffies,
> +	},
> +	{
>  		.ctl_name	=3D 0
>  	}
>  };
> --=20
> 1.5.6.3

I think this is not needed. User would not be aware of this configurati=
on.


=46rom: Eric Leblond <eric@inl.fr>
Date: Thu, 22 Jan 2009 00:43:51 +0100

> This patch removes connection tracking handling for ICMPv6 messages
> related to autoconfiguration. They can be tracked because they are
> massively using multicast (on pre-defined address). But they are not
> invalid.
>
> Signed-off-by: Eric Leblond <eric@inl.fr>

<snip>

> +static const u_int8_t noct_valid_new[] =3D {
> +	[ICMPV6_MGM_QUERY - 130] =3D 1,
> +	[ICMPV6_MGM_REPORT -130] =3D 1,
> +	[ICMPV6_MGM_REDUCTION - 130] =3D 1,
> +	[NDISC_ROUTER_SOLICITATION - 130] =3D 1,
> +	[NDISC_ROUTER_ADVERTISEMENT - 130] =3D 1,
> +	[NDISC_NEIGHBOUR_SOLICITATION - 130] =3D 1,
> +	[NDISC_NEIGHBOUR_ADVERTISEMENT - 130] =3D 1,
> +	[ICMPV6_MLD2_REPORT - 130] =3D 1
> +};

MLD is not part of auto configuration. But I agree to handle it.


>  static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
>  				const struct nf_conntrack_tuple *orig)
>  {
>  	int type =3D orig->dst.u.icmp.type - 128;
> -	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type])
> +
> +	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type]) {
>  		return false;
> +	}

Really is this change necessary ?


> @@ -198,6 +212,17 @@ icmpv6_error(struct net *net, struct sk_buff *sk=
b, unsigned int dataoff,
>  		return -NF_ACCEPT;
>  	}
> =20
> +	/* autoconf message handling */
> +	if (nf_ct_icmpv6_autoconf) {
> +		int type =3D icmp6h->icmp6_type - 130;
> +		if (type >=3D 0 && type < sizeof(noct_valid_new)
> +		    && noct_valid_new[type]) {
> +			skb->nfct =3D &nf_conntrack_untracked.ct_general;
> +			skb->nfctinfo =3D IP_CT_NEW;
> +			nf_conntrack_get(skb->nfct);
> +			return -NF_ACCEPT;
> +		}
> +	}

I prefer 'NEW' rather than 'UNTRACKED' as other protocols which
validation is unclear. So another solution is to let the connection
tracking subsystem to create a new conntrack and to make
nf_contrack_proto_icmpv6 assign 0 as timeout. How do you think ?

-- Yasuyuki Kozakai
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
