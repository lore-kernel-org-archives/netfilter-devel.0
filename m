From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 13:43:31 +0100
Message-ID: <1173876211.26913.73.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-g0IuDxKcCZ1h6Q4bX4oO"
Cc: Amin Azez <azez@ufomechanic.net>, Jan Engelhardt <jengelh@linux01.gwdg.de>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7D657.8070907@trash.net>
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


--=-g0IuDxKcCZ1h6Q4bX4oO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 12:02 +0100 skrev Patrick McHardy:

> Thats true, routing by nfmark in the OUTPUT chain needs the rerouting
> done by the mangle table, but nowadays there are other uses for nfmark,
> so if someone feels motivated to send a patch to get rid of this pretty
> arbitary restriction I think I would take it.

If you do, please remove the same restriction from CONNMARK restore

Regards
Henrik

--=-g0IuDxKcCZ1h6Q4bX4oO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfft8ENPQ5Kbx8daAQIxFQP/fZjtivcA2NTeePagCp0d4lcfsdtVOlHj
XzY2egb1tkV8fRbrgU/3JT/7SEeDpD3LFCjaigBrVkjmz0WT7AcsGx9wdUNEO1Il
KNc6zH4XK6109OEoo/bT3K6dV/OjFOT/IU3iQY1lz5ZqumCidkQy5VzApn970KM7
qtYYRPu45Ik=
=m7dt
-----END PGP SIGNATURE-----

--=-g0IuDxKcCZ1h6Q4bX4oO--
