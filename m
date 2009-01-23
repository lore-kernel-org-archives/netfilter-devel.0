From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 11:51:30 +0100
Message-ID: <1232707890.32071.41.camel@khasse.inl.fr>
References: <1232581287.16003.47.camel@ice-age>
	 <200901230741.n0N7f0bx012043@toshiba.co.jp>
	 <1232701347.32071.13.camel@khasse.inl.fr>
	 <200901231021.n0NALINO007201@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S2GCk6UtO2cmMGN44gEn"
Cc: Marek.Szuba@if.pw.edu.pl, kaber@trash.net,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:54859 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZAWKvn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:51:43 -0500
In-Reply-To: <200901231021.n0NALINO007201@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-S2GCk6UtO2cmMGN44gEn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le vendredi 23 janvier 2009 =C3=A0 19:21 +0900, Yasuyuki KOZAKAI a =C3=A9cr=
it :
> Hi,
>=20
> From: Eric Leblond <eric@inl.fr>
> Date: Fri, 23 Jan 2009 10:02:27 +0100
>=20
> > Hi,
> >=20
> > Le vendredi 23 janvier 2009 =C3=A0 16:40 +0900, Yasuyuki KOZAKAI a =C3=
=A9crit :
> > > Hi, Eric,
> > >=20
> > > How about just using NOTRACK target ?
> >=20
> > This is a possible solution but you will then have to be a Netfilter
> > Jedi to build a correct IPv6 filtering ruleset. I think even Padawan
> > have no clue about the existence of the NOTRACK target.
> >=20
> > Seriously speaking, the NOTRACK target is tagged "NETFILTER_ADVANCED"
> > and IPv6 is becoming more and more frequent. I don't think we should us=
e
> > such a complicated solution for simply obtaining an IPv6 address. We
> > will loose quit a bunch of users on this.
>=20
> It's reasonable. One solution is to change it and to make distributer add
> NOTRACK rule to their configuration, but changing nf_conntrack would be
> faster ;)
>=20
>=20
> From: Eric Leblond <eric@inl.fr>
> Date: Thu, 22 Jan 2009 00:43:50 +0100
>=20
> > This patches adds a sysctl flag to decide wheither or not detect icmpv6
> > autoconfiguration packet as INVALID.
> >=20
> > Signed-off-by: Eric Leblond <eric@inl.fr>
> > ---
> >  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/=
netfilter/nf_conntrack_proto_icmpv6.c
> > index 0dbac72..4aa80ba 100644
> > --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> > +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> > @@ -27,6 +27,7 @@
> >  #include <net/netfilter/nf_log.h>
> > =20
> >  static unsigned long nf_ct_icmpv6_timeout __read_mostly =3D 30*HZ;
> > +static unsigned long nf_ct_icmpv6_autoconf __read_mostly =3D 0;
> > =20
> >  static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
> >  				unsigned int dataoff,
> > @@ -259,6 +260,13 @@ static struct ctl_table icmpv6_sysctl_table[] =3D =
{
> >  		.proc_handler	=3D proc_dointvec_jiffies,
> >  	},
> >  	{
> > +		.procname	=3D "nf_conntrack_icmpv6_autoconf",
> > +		.data		=3D &nf_ct_icmpv6_autoconf,
> > +		.maxlen		=3D sizeof(unsigned int),
> > +		.mode		=3D 0644,
> > +		.proc_handler	=3D proc_dointvec_jiffies,
> > +	},
> > +	{
> >  		.ctl_name	=3D 0
> >  	}
> >  };
> > --=20
> > 1.5.6.3
>=20
> I think this is not needed. User would not be aware of this configuration=
.

Ok, I'm really fine with it.

> From: Eric Leblond <eric@inl.fr>
> Date: Thu, 22 Jan 2009 00:43:51 +0100
>=20
> > This patch removes connection tracking handling for ICMPv6 messages
> > related to autoconfiguration. They can be tracked because they are
> > massively using multicast (on pre-defined address). But they are not
> > invalid.
> >
> > Signed-off-by: Eric Leblond <eric@inl.fr>
>=20
> <snip>
>=20
> > +static const u_int8_t noct_valid_new[] =3D {
> > +	[ICMPV6_MGM_QUERY - 130] =3D 1,
> > +	[ICMPV6_MGM_REPORT -130] =3D 1,
> > +	[ICMPV6_MGM_REDUCTION - 130] =3D 1,
> > +	[NDISC_ROUTER_SOLICITATION - 130] =3D 1,
> > +	[NDISC_ROUTER_ADVERTISEMENT - 130] =3D 1,
> > +	[NDISC_NEIGHBOUR_SOLICITATION - 130] =3D 1,
> > +	[NDISC_NEIGHBOUR_ADVERTISEMENT - 130] =3D 1,
> > +	[ICMPV6_MLD2_REPORT - 130] =3D 1
> > +};
>=20
> MLD is not part of auto configuration. But I agree to handle it.

Ok.

>=20
>=20
> >  static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
> >  				const struct nf_conntrack_tuple *orig)
> >  {
> >  	int type =3D orig->dst.u.icmp.type - 128;
> > -	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type])
> > +
> > +	if (type < 0 || type >=3D sizeof(invmap) || !invmap[type]) {
> >  		return false;
> > +	}
>=20
> Really is this change necessary ?

I've resend the patch without this change. It was forgotten during a
merge of previous work. Sorry for that.

> > @@ -198,6 +212,17 @@ icmpv6_error(struct net *net, struct sk_buff *skb,=
 unsigned int dataoff,
> >  		return -NF_ACCEPT;
> >  	}
> > =20
> > +	/* autoconf message handling */
> > +	if (nf_ct_icmpv6_autoconf) {
> > +		int type =3D icmp6h->icmp6_type - 130;
> > +		if (type >=3D 0 && type < sizeof(noct_valid_new)
> > +		    && noct_valid_new[type]) {
> > +			skb->nfct =3D &nf_conntrack_untracked.ct_general;
> > +			skb->nfctinfo =3D IP_CT_NEW;
> > +			nf_conntrack_get(skb->nfct);
> > +			return -NF_ACCEPT;
> > +		}
> > +	}
>=20
> I prefer 'NEW' rather than 'UNTRACKED' as other protocols which
> validation is unclear. So another solution is to let the connection
> tracking subsystem to create a new conntrack and to make
> nf_contrack_proto_icmpv6 assign 0 as timeout. How do you think ?

If we do that, we can have nfnetlink messages (NEW, DESTROY) send to
userspace. Personnaly, I don't think they are necessary. But there is an
other issue: as we can't invert the tuple, the information provided to
userspace will be false.

Once we agree on this last point, I will send a reworked patchset (with
at least the removal of sysctl stuff).

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-S2GCk6UtO2cmMGN44gEn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl5oS8ACgkQnxA7CdMWjzIqEACdHQ01+hSIM5xRDC6ef+Z8tVzd
qdgAnRcQeRHZfPWMjxMMJ4oqprZmP+6A
=Gv8S
-----END PGP SIGNATURE-----

--=-S2GCk6UtO2cmMGN44gEn--

