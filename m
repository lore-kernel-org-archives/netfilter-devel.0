From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 21:45:34 +0100
Message-ID: <1173905134.1760.59.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>
	<45F85C89.7070107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-aiyIQ+DmlSUiGr3UzYPj"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F85C89.7070107@trash.net>
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


--=-aiyIQ+DmlSUiGr3UzYPj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 21:35 +0100 skrev Patrick McHardy:

> Well, my opinion is that the mangle table is misnamed. The only
> functional difference to filter is rerouting in LOCAL_OUT if any
> of the routing keys changes, so it would be better called route
> table.

And frankly speaking, that rerouting could just as well be done by a
target.

Regards
Henrik

--=-aiyIQ+DmlSUiGr3UzYPj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfhe6UNPQ5Kbx8daAQLi1wQAkMu0Hts+8OV+q8oiEAVSZiXwShnZ77AJ
NRV9x9xLuCZmYZZTkLxPVstoNiIpvvzC/IgvRg6PI3B8PF1qt3bdfYgwwIVX8843
bdT8uWUJneQ9YvrsqbkSBEoL2+BRtro9HmThzHzV6CdUsHt+kMVlq94Yku/tjQjA
K7Csg8FiKgM=
=BMSc
-----END PGP SIGNATURE-----

--=-aiyIQ+DmlSUiGr3UzYPj--
