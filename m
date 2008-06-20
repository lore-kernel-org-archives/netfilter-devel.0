From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: ip6tables doesn't support --goto option
Date: Fri, 20 Jun 2008 20:54:36 +0200
Message-ID: <1213988076.2466.2.camel@henriknordstrom.net>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de>
	 <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fm03sgnUg1apjSz3AKdA"
Cc: Thomas Jacob <jacob@internet24.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:50218 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYFTSyo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:54:44 -0400
In-Reply-To: <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-fm03sgnUg1apjSz3AKdA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On fre, 2008-06-20 at 20:10 +0200, Jan Engelhardt wrote:

> I suppose it was just forgotten, as the original commit (17fc163b) only
> touched iptables.c, not ip6tables.c.

Quite likely my fault as I only use iptables, not yet ip6tables..

Here is a really good project lurking for someone looking for a starter
iptables project: eleminate all the duplicated code between iptables and
ip6tables..

Regards
Henrik

--=-fm03sgnUg1apjSz3AKdA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASFv86UNPQ5Kbx8daAQJ4uQP9EIZoYYsC4uLBgJJSq0ld/oOCZ7ay1HsV
OW0oF4Ovst94EDDe6L3lkb5OPdU0//5PrdtIhZGR+N1VPTGJhuzI7RihqBx1hTM2
EP4cufgQ+DtqPyYY8XH2ufkwTHc4D8H4dCn4lxVwNngGc7MNiQcw70T2y1VtV3ZF
n84Rj7YGlZE=
=2ped
-----END PGP SIGNATURE-----

--=-fm03sgnUg1apjSz3AKdA--

