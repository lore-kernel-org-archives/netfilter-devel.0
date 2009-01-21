From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 2/2] netfilter: don't track ICMPv6 negotiation message.
Date: Thu, 22 Jan 2009 00:49:51 +0100
Message-ID: <1232581791.16003.49.camel@ice-age>
References: <1232581287.16003.47.camel@ice-age>
	 <1232581431-15130-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XpbHLJGnxM7qzzZZQYLz"
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:36975 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZAUXt7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:49:59 -0500
In-Reply-To: <1232581431-15130-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-XpbHLJGnxM7qzzZZQYLz
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Oups, sorry, this patch is not clean (indentation change and spacing). I
send an other one in reply to this mail.

Le jeudi 22 janvier 2009 =E0 00:43 +0100, Eric Leblond a =E9crit :
> This patch removes connection tracking handling for ICMPv6 messages
> related to autoconfiguration. They can be tracked because they are
> massively using multicast (on pre-defined address). But they are not
> invalid.
>=20
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   27 ++++++++++++++++++=
+++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/ne=
tfilter/nf_conntrack_proto_icmpv6.c
> index 4aa80ba..34548c3 100644
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -54,12 +54,25 @@ static const u_int8_t invmap[] =3D {
>  	[ICMPV6_NI_REPLY - 128]		=3D ICMPV6_NI_QUERY +1
>  };
> =20
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
> +
>  static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
>  				const struct nf_conntrack_tuple *orig)
>  {
>  	int type =3D orig->dst.u.icmp.type - 128;
> -	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type])
> +
> +	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type]) {
>  		return false;
> +	}
> =20
>  	tuple->src.u.icmp.id   =3D orig->src.u.icmp.id;
>  	tuple->dst.u.icmp.type =3D invmap[type] - 1;
> @@ -109,6 +122,7 @@ static bool icmpv6_new(struct nf_conn *ct, const stru=
ct sk_buff *skb,
>  		[ICMPV6_ECHO_REQUEST - 128] =3D 1,
>  		[ICMPV6_NI_QUERY - 128] =3D 1
>  	};
> +
>  	int type =3D ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
> =20
>  	if (type < 0 || type >=3D sizeof(valid_new) || !valid_new[type]) {
> @@ -198,6 +212,17 @@ icmpv6_error(struct net *net, struct sk_buff *skb, u=
nsigned int dataoff,
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
>  	/* is not error message ? */
>  	if (icmp6h->icmp6_type >=3D 128)
>  		return NF_ACCEPT;
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-XpbHLJGnxM7qzzZZQYLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJd7ScnxA7CdMWjzIRAvjdAJ9lppyFG7C7ESEojP0zvtvPkIhvDACdEEl7
+vfRT0k/weIlTd49zvtE+HU=
=mWcg
-----END PGP SIGNATURE-----

--=-XpbHLJGnxM7qzzZZQYLz--

