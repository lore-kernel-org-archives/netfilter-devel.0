From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Developing a user space library for filtering
Date: Wed, 23 May 2007 10:19:50 +0200
Message-ID: <1179908390.18674.36.camel@henriknordstrom.net>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
	<20070522064613.GA27619@oknodo.bof.de> <4653578C.3070407@Sun.COM>
	<20070522211404.GC24990@ipom.com>
	<1179874698.18674.22.camel@henriknordstrom.net>
	<465382DB.3080106@Sun.COM>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-fkWjx+3+8my43AGDU9Fe"
Cc: netfilter-devel@lists.netfilter.org
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465382DB.3080106@Sun.COM>
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


--=-fkWjx+3+8my43AGDU9Fe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tis 2007-05-22 klockan 16:55 -0700 skrev Darren.Reed@Sun.COM:

> Which means that coming up with a design that works won't
> necessarily be a slam-dunk.

More that you are aiming this API at the wrong level. This API needs to
be to the firewall (Smoothwall, Astaro, MARA, Cisco, Netgear,
Checkpoint, etc etc), not the firewall packet engine.

plain iptables might be one target, but only as a reference
implementation under well defined conditions.

To get going you need to first define a couple of target applications.
Trying to make this discussion without some well defined targets will
not gain good results.

Regards
Henrik

--=-fkWjx+3+8my43AGDU9Fe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlP5I0NPQ5Kbx8daAQKkYgP/XJ2UCPSiEd8MzymhSCdhGACfFYnRbxkc
UQQdk0sFORLuxhkSETsP9bX0RSp5aWRzGqPTm/itWm1t8p2Q/d3GbrN9vuZLjJVV
d4/udk81RT5rVPA2MSencAO6iltb1S1gaVRBGXXdTz3ShhGFMAVv1VL84V7m2rFs
swgs83mu348=
=AwzF
-----END PGP SIGNATURE-----

--=-fkWjx+3+8my43AGDU9Fe--
