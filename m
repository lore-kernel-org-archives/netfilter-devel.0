From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Thu, 22 Jan 2009 00:41:27 +0100
Message-ID: <1232581287.16003.47.camel@ice-age>
References: <20081030145218.5395c3fe@hiperon.ws.hirg>
	 <491056FF.8030801@trash.net> <200811050444.mA54i7XU020102@toshiba.co.jp>
	 <20081105133508.67b25090@hiperon.ws.hirg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s71OLpViz+CcAvh3/11r"
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>, kaber@trash.net,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Marek Szuba <Marek.Szuba@if.pw.edu.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55801 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZAUXls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:41:48 -0500
In-Reply-To: <20081105133508.67b25090@hiperon.ws.hirg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-s71OLpViz+CcAvh3/11r
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 05 novembre 2008 =E0 13:35 +0100, Marek Szuba a =E9crit :
> On Wed, 05 Nov 2008 13:44:05 +0900 (JST)
> Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
>=20
> > In short: nf_conntrack_proto_icmpv6.c does not help for protocols
> > using their messages. conntrack helper is better.
> So what you are suggesting is, someone needs to write such a helper
> module. Correct?

I'm reopening this thread because Victor Stinner (in CC) has opened a
similar bug in bugzilla:
http://bugzilla.netfilter.org/show_bug.cgi?id=3D567
Pablo has then pointed out this discussion.

I don't think that we have to handle these part of ICMPv6 protocol with
a connection tracking helper. For example, here's the trace of the
exchange which are needed to obtain a "public" IPv6 address on my setup:

15:14:42.377744 IP6 fe80::a00:27ff:feb3:e26c > ff02::2: ICMP6, router solic=
itation, length 16
15:14:42.405725 IP6 fe80::207:cbff:fe90:f8d1 > ff02::1: ICMP6, router adver=
tisement, length 104
15:14:43.401395 IP6 :: > ff02::1:ffb3:e26c: ICMP6, neighbor solicitation, w=
ho has 2a01:e35:1394:5bd0:a00:27ff:feb3:e26c, length 24
15:14:46.628300 IP6 fe80::a00:27ff:feb3:e26c > ff02::16: HBH ICMP6, multica=
st listener report v2, 1 group record(s), length 28

If we only analyse the first two, we see we can't easily invert the
tuple of the connection: we don't know which address will answer and the
destination address of the packet are changing. But as pointed by
Yasuyuki the main point is not here, we need to accept the router
advertisement to be able to detect changes in the routing. In fact,
theses protocols are stateless and should be considered as such.

IMHO, the main issue here is to tag the packets as INVALID. They are
valid even we can't track them. I thus propose a patchset which adds the
capability to avoid connection tracking the packets of these protocols.
A sysctl flag can be set to activate this feature.

With this patchset, the concerned packet don't get blocked by the
INVALID rule and are not seen by the conntrack. They can be cleanly
filtered in the ruleset.

Patchset statistics:
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   35 ++++++++++++++++++++=
+++-
 1 files changed, 34 insertions(+), 1 deletions(-)

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-s71OLpViz+CcAvh3/11r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJd7KjnxA7CdMWjzIRAmaTAJwNmtk5vpXRfvb7pyUUh5Wjxvd07wCfeAaw
f0ytrxtuPJQDhv8Y2grkCOg=
=pDFN
-----END PGP SIGNATURE-----

--=-s71OLpViz+CcAvh3/11r--

