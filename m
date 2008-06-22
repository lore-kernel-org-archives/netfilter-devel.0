From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: ip6tables doesn't support --goto option
Date: Sun, 22 Jun 2008 20:59:49 +0200
Message-ID: <1214161189.14622.0.camel@henriknordstrom.net>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de>
	 <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr>
	 <1213988076.2466.2.camel@henriknordstrom.net> <485CBB76.4020206@trash.net>
	 <20080621144311.GA24248@internet24.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LDW5tKNaZyEvZjJGvgC5"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:56657 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYFVS74 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:59:56 -0400
In-Reply-To: <20080621144311.GA24248@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-LDW5tKNaZyEvZjJGvgC5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On l=C3=B6r, 2008-06-21 at 16:43 +0200, Thomas Jacob wrote:
> On Sat, Jun 21, 2008 at 10:27:34AM +0200, Patrick McHardy wrote:
> > I think it was me, I added the ip6_tables support, for seem to
> > have forgotten about userspace.
> >
> > Does anyone wants to send a patch for this?
>=20
> Here's what I got by copying the --goto changes from iptables.c,
> not sure if it's complete, but it seems to work for me.

Looks fine to me. Did the same but you beat me in sending the
submission..

Regards
Henrik

--=-LDW5tKNaZyEvZjJGvgC5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASF6hIkNPQ5Kbx8daAQKOyQP8DCQbZ0vfkDge4F3m4vcjcJoDnU3KxGeI
j6mvqXOGmPrXhz5wDdzKwM1iIOnBhda1OIPAabdOlB2CMes6eT63papBi9omADND
dAKZXJiO4JCUbG5q55AEUltFQrnjVfJDWAMKFe8WfTmNtK/6Jc1Ci2FLcxAsz+Zm
Km3DpZ5XMD8=
=FDA9
-----END PGP SIGNATURE-----

--=-LDW5tKNaZyEvZjJGvgC5--

