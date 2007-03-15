From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: NF structural changes (was: dangerous?)
Date: Thu, 15 Mar 2007 10:09:15 +0100
Message-ID: <1173949755.9027.3.camel@henriknordstrom.net>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
	<Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
	<45F86D93.3030004@ufomechanic.net>
	<Pine.LNX.4.61.0703150227420.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-QzMojGDTV5wfe52Fj8Jg"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703150227420.1199@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-QzMojGDTV5wfe52Fj8Jg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tor 2007-03-15 klockan 03:24 +0100 skrev Jan Engelhardt:

> Wanna merge the 'raw' table too - or would that cause increased coding
> complexity in netfilter?

To do that connection tracking needs significant changes.

the main purpose of raw is to hit packets before connection tracking,
while everything else is after connection tracking.

But yes, it's possible by just adding a set of additional
hooks/entrychains to the "filter" table. But thats not a very big
difference from having them split..

Regards
Henrik

--=-QzMojGDTV5wfe52Fj8Jg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfkNOENPQ5Kbx8daAQJXpgP+MzDNvXHi4xWjLv6Gdt3ZzPmmDvv2EOmP
zqjr1JOL0zR31J7pM1ogAHb8tRh3wBVl9QjbX1qkIy8H6Ys1UlZVL6KTBt7AKqIV
WnibSs/WAsOFXYZZ5UmDi+L969kTblx9b94sVpYFvDW4ognRpyW22HVAZ8guUQdq
U3JKxwX4ufk=
=PTFX
-----END PGP SIGNATURE-----

--=-QzMojGDTV5wfe52Fj8Jg--
