From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 11:35:32 +0100
Message-ID: <1173868532.26913.39.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-6NUig7TQIwn9hfp1TX2O"
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
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


--=-6NUig7TQIwn9hfp1TX2O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tis 2007-03-13 klockan 17:18 +0100 skrev Jan Engelhardt:

> http://lkml.org/lkml/2006/8/22/26
>=20
> CONNMARK does in filter, MARK does not - I do not know what is
> supposed to be going on.

It's due to the relation of the per-packet nfmark being as a channel to
return routing information from netfilter to the kernel. The
per-connection conntrack mark used by CONNMARK does not have this
property and does not need to be restricted in where it's modified.

The restore operation of CONNMARK have the same restrictions as MARK as
it too modifies the packet nfmark, and can therefore only be used from
mangle just as MARK.

Regards
Henrik
Author of CONNMARK

--=-6NUig7TQIwn9hfp1TX2O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARffP8UNPQ5Kbx8daAQI+aQQAodEOfHoWg0M2it7E2/QQUS3czUP1gDi5
9IZyOluJGJCMgzZu18kHo22QTFru6MrbyYMRHWW5qhkNOBiDjGWugLKAKTqM1kw/
gjLwTplILAPbMYnhkp/xJ2wldmyShVtho07QUSDoeK8QewF7ikpBbYBg7gNMSNl+
AH3G27DEl6I=
=ENMY
-----END PGP SIGNATURE-----

--=-6NUig7TQIwn9hfp1TX2O--
