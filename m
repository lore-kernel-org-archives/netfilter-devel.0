From: Zan Lynx <zlynx@acm.org>
Subject: Re: Bug with Fedora's 2.6.23.9-85 kernel (at least) and
	ESTABLISHED and SACK
Date: Mon, 28 Jan 2008 10:07:48 -0700
Message-ID: <1201540068.6526.9.camel@localhost>
References: <479D64B0.10101@acm.org>
	 <Pine.LNX.4.64.0801281053100.1185@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B2X1GPKenzcjV8oeW+/F"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:33210 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762011AbYA1RHd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:07:33 -0500
In-Reply-To: <Pine.LNX.4.64.0801281053100.1185@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-B2X1GPKenzcjV8oeW+/F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-28 at 10:53 +0100, Jan Engelhardt wrote:
> On Jan 27 2008 22:14, Zan Lynx wrote:
> >
> > Please CC me on any replies as I am not subscribed.
> >
> > I was downloading a new Google Earth when I noticed a LOT of
> > max-size dropped packets in my firewall log.  I only allow
> > RELATED,ESTABLISHED sessions into my firewall.
> >
> > tcpdump showed that every time Google sent a packet to satisfy the
> > missing data identified by SACK, that packet was rejected.  So it
> > must have been missing the ESTABLISHED rule.
>=20
> You can check the connection state with `conntrack -L`, or in
> /proc/net/{ip,nf}_conntrack. What does it read?

I am sorry.  The download completed and I have not yet had time to
reproduce it.  Perhaps I can get something tonight.
--=20
Zan Lynx <zlynx@acm.org>

--=-B2X1GPKenzcjV8oeW+/F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHngvkG8fHaOLTWwgRAkBWAJ9pV9Gk/dtQd5j6t9gDbvSl9G3nRACcDJP6
0vN5bgck+4T6bKQPQUV4++Y=
=DN0Y
-----END PGP SIGNATURE-----

--=-B2X1GPKenzcjV8oeW+/F--

