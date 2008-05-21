From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 10:48:43 +0200
Message-ID: <1211359723.20992.8.camel@henriknordstrom.net>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O/rEzsb2MbW0Wv5WDPFA"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:39874 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYEUIst (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 04:48:49 -0400
In-Reply-To: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-O/rEzsb2MbW0Wv5WDPFA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On ons, 2008-05-21 at 04:33 -0400, NICOLAS BOULIANE wrote:

> Since ppp0 always come up first, then these connections begin to flow
> via ppp0 and with the MASQ IP of ppp0...
>=20
> Later, when the mangle-rules kick-in, these connections are being
> router via ppp4 (which is what I want)...
> So far no problem..

Don't enable forwarding until you have the routing (including policies,
mangle etc) properly configured.

Regards
Henrik

--=-O/rEzsb2MbW0Wv5WDPFA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASDPh50NPQ5Kbx8daAQKXzwP9HEPIOmEauHhjdRSzjMzJkd6piFSR/5U1
PAtOEV7pS31XBkwWiqy42s1z/wh1HKuCBFrGu7HEyGMG+WWpqayfnHtAgc2YngTQ
Fcq0jfwNUMFoqUa6y06lnoOJkOP9jJpsySApTAmoIlC8UBdOwe24iz2QUw5Q8+wy
5dBm+FYqpXI=
=DJYT
-----END PGP SIGNATURE-----

--=-O/rEzsb2MbW0Wv5WDPFA--

