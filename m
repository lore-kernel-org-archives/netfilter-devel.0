From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 10:02:27 +0100
Message-ID: <1232701347.32071.13.camel@khasse.inl.fr>
References: <200811050444.mA54i7XU020102@toshiba.co.jp>
	 <20081105133508.67b25090@hiperon.ws.hirg>
	 <1232581287.16003.47.camel@ice-age>
	 <200901230741.n0N7f0bx012043@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z5vmYPCZuD0EfhGwJ4lG"
Cc: Marek.Szuba@if.pw.edu.pl, kaber@trash.net,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:35660 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZAWJCo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:02:44 -0500
In-Reply-To: <200901230741.n0N7f0bx012043@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-z5vmYPCZuD0EfhGwJ4lG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 23 janvier 2009 =C3=A0 16:40 +0900, Yasuyuki KOZAKAI a =C3=A9cr=
it :
> Hi, Eric,
>=20
> How about just using NOTRACK target ?

This is a possible solution but you will then have to be a Netfilter
Jedi to build a correct IPv6 filtering ruleset. I think even Padawan
have no clue about the existence of the NOTRACK target.

Seriously speaking, the NOTRACK target is tagged "NETFILTER_ADVANCED"
and IPv6 is becoming more and more frequent. I don't think we should use
such a complicated solution for simply obtaining an IPv6 address. We
will loose quit a bunch of users on this.

BR,
--
Eric

>=20
> -- Yasuyuki Kozakai
>=20
> From: Eric Leblond <eric@inl.fr>
> Date: Thu, 22 Jan 2009 00:41:27 +0100
>=20
> > Hi,
> >=20
> > Le mercredi 05 novembre 2008 =C3=A0 13:35 +0100, Marek Szuba a =C3=A9cr=
it :
> > > On Wed, 05 Nov 2008 13:44:05 +0900 (JST)
> > > Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
> > >=20
> > > > In short: nf_conntrack_proto_icmpv6.c does not help for protocols
> > > > using their messages. conntrack helper is better.
> > > So what you are suggesting is, someone needs to write such a helper
> > > module. Correct?
> >=20
> > I'm reopening this thread because Victor Stinner (in CC) has opened a
> > similar bug in bugzilla:
> > http://bugzilla.netfilter.org/show_bug.cgi?id=3D567
> > Pablo has then pointed out this discussion.
> >=20
> > I don't think that we have to handle these part of ICMPv6 protocol with
> > a connection tracking helper. For example, here's the trace of the
> > exchange which are needed to obtain a "public" IPv6 address on my setup=
:
> >=20
> > 15:14:42.377744 IP6 fe80::a00:27ff:feb3:e26c > ff02::2: ICMP6, router s=
olicitation, length 16
> > 15:14:42.405725 IP6 fe80::207:cbff:fe90:f8d1 > ff02::1: ICMP6, router a=
dvertisement, length 104
> > 15:14:43.401395 IP6 :: > ff02::1:ffb3:e26c: ICMP6, neighbor solicitatio=
n, who has 2a01:e35:1394:5bd0:a00:27ff:feb3:e26c, length 24
> > 15:14:46.628300 IP6 fe80::a00:27ff:feb3:e26c > ff02::16: HBH ICMP6, mul=
ticast listener report v2, 1 group record(s), length 28
> >=20
> > If we only analyse the first two, we see we can't easily invert the
> > tuple of the connection: we don't know which address will answer and th=
e
> > destination address of the packet are changing. But as pointed by
> > Yasuyuki the main point is not here, we need to accept the router
> > advertisement to be able to detect changes in the routing. In fact,
> > theses protocols are stateless and should be considered as such.
> >=20
> > IMHO, the main issue here is to tag the packets as INVALID. They are
> > valid even we can't track them. I thus propose a patchset which adds th=
e
> > capability to avoid connection tracking the packets of these protocols.
> > A sysctl flag can be set to activate this feature.
> >=20
> > With this patchset, the concerned packet don't get blocked by the
> > INVALID rule and are not seen by the conntrack. They can be cleanly
> > filtered in the ruleset.
> >=20
> > Patchset statistics:
> >  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   35 ++++++++++++++++=
+++++++-
> >  1 files changed, 34 insertions(+), 1 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-z5vmYPCZuD0EfhGwJ4lG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl5h6AACgkQnxA7CdMWjzK1aQCfev5mSuuoGSC+RKjPgsTn6uNV
sfcAnR8LyGRTe8iD4xCDgU59u9hCVXkY
=qc2D
-----END PGP SIGNATURE-----

--=-z5vmYPCZuD0EfhGwJ4lG--

