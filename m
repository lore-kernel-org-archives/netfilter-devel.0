From: Zan Lynx <zlynx@acm.org>
Subject: Re: Bug with Fedora's 2.6.23.9-85 kernel (at least) and
	ESTABLISHED and SACK
Date: Mon, 28 Jan 2008 10:06:18 -0700
Message-ID: <1201539978.6526.7.camel@localhost>
References: <479D64B0.10101@acm.org>
	 <Pine.LNX.4.64.0801281434100.10533@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a7DXG/gvom0p4l8yo0bt"
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:33208 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755467AbYA1RGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:06:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801281434100.10533@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-a7DXG/gvom0p4l8yo0bt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-28 at 14:38 +0100, Krzysztof Oledzki wrote:
>=20
> On Sun, 27 Jan 2008, Zan Lynx wrote:
>=20
> > Please CC me on any replies as I am not subscribed.
> >
> > I was downloading a new Google Earth when I noticed a LOT of max-size d=
ropped=20
> > packets in my firewall log.  I only allow RELATED,ESTABLISHED sessions =
into=20
> > my firewall.
> >
> > tcpdump showed that every time Google sent a packet to satisfy the miss=
ing=20
> > data identified by SACK, that packet was rejected.  So it must have bee=
n=20
> > missing the ESTABLISHED rule.
> >
> > I fixed the problem by adding an ALLOW source port 80 rule for the Goog=
le=20
> > download site IP.
> >
> > This makes me wonder how often this has happened and I haven't noticed =
it.=20
> > Is this a known bug or something new?
>=20
> Which kernel version?

As in the Subject, Fedora's 2.6.23.9-85.

>=20
> Most likely there is a broken box along the path that mangles seq numbers=
=20
> but forgets about sacks. Could you please provide a dump:
> "tcpdump -v -S host (...)"?

I have not yet been able to reproduce it so I cannot provide a dump.

I doubt that the sequence numbers were being mangled.  I doubt this
because as soon as I added the rule to accept all port 80 packets from
the server IP, the TCP session accepted the packet with the missing data
and the hole described by the SACK options disappeared.  The session was
sourced from the machine itself via a Squid proxy.

>=20
> As a short-term workaround you may disable net.ipv4.tcp_sack or use=20
> TCPOPTSTRIP to strip SackOK advertisement to the host.

Yes, I could do this if it seems to happen again.  I will keep an eye on
it.

>=20
> Best regards,
>=20
>  				Krzysztof Oledzki
--=20
Zan Lynx <zlynx@acm.org>

--=-a7DXG/gvom0p4l8yo0bt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnguKG8fHaOLTWwgRApMsAJ4tdHa7pwtdsPO1N6ieLVZHJcreHgCgo2+U
ZVhXGxILfYgucKHsbY5S6Qk=
=lARL
-----END PGP SIGNATURE-----

--=-a7DXG/gvom0p4l8yo0bt--

