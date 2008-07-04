From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 04 Jul 2008 17:15:44 +0200
Message-ID: <1215184544.32053.61.camel@henriknordstrom.net>
References: <20080703003942.GA2012@linuxace.com>
	 <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DdGcrxFVBJi42BfTbtF3"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:57646 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYGDPPv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:15:51 -0400
In-Reply-To: <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-DdGcrxFVBJi42BfTbtF3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On tor, 2008-07-03 at 13:22 +0200, Jan Engelhardt wrote:

> You know what's been bugging me... why don't we replace the entire
> routing infrastructure by an xtables "route" table, with something like

It's been discussed off-list many times.=20

The problem with the routing table is that it's more to that table than
what's visible. It's heavily cached and annotated by the kernel beyond
just the plain routing table, and used in a number of different ways
such as when assigning the source address on outgoing connections, way
before there even is a packet.

Regards
Henrik

--=-DdGcrxFVBJi42BfTbtF3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASG4+nUNPQ5Kbx8daAQIxpwP/WJ+eB9fJesNlCRG9SZ7Ym0g0cpuGXpFM
HnneqLDgl/pdjP9/pSUY9x3r6fWamQZgTT826fj0gIvtvP/mYMMdIuR+gVw+514q
JaLxalrTadvjjpXBkQX+RBvXzYZV1GVNYHsPZly8Sq1CKNmKQstJeAPl9xGBTbyF
27lieWxBStU=
=JYbn
-----END PGP SIGNATURE-----

--=-DdGcrxFVBJi42BfTbtF3--

