From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 14:14:22 +0100
Message-ID: <1173878062.26913.91.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-OhacpS7xyv/mWDwKkCeB"
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7F027.9050300@ufomechanic.net>
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


--=-OhacpS7xyv/mWDwKkCeB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 12:52 +0000 skrev Amin Azez:

> Henrick, are you interested in my per-flow patch for connmark, so that
> each side of the flow can have a seperate mark? Also dumped thus out of
> /proc/net/ip-conntrack and libnfnetlink

I am not objecting it, just not sure it will be used that much
warranting yet another 32-bit conntrack field.

I said earlier that it probably makes more sense to add shift to the
save/restore operations, allowing it to be split in multiple marks while
keeping sanity (possible today, but the marks in one direction will be a
bit odd, scaled up).. For most uses you described earlier 16 bit marks
should be sufficient.

Adding some kind of generic framework for conntrack extension values
would also make sense, allowing modules to associate new values with a
conntrack entry when needed without having to redefine the conntrack
entry for each such module.

Regards
Henrik

--=-OhacpS7xyv/mWDwKkCeB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARff1K0NPQ5Kbx8daAQKxgwP/csFFMe8m6ZwpnIllC9m6ZH2WtgZfXtoN
44AXH3x+9nwsC2+3qrl3kmeOyUIPkxeo9vYcrV2Fjk8YunHPJYHsIM9gfNZ+X+JT
V7x/I6qMErz/8GWIYyD6Y4Y+b8Y7IhhWluGYwyw1WKrrtOjoel5qMWM8Mg3DIHxd
IhC4NpSwKzM=
=zx52
-----END PGP SIGNATURE-----

--=-OhacpS7xyv/mWDwKkCeB--
