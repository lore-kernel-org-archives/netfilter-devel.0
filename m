From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH] fix bug in convert2pomng.sh
Date: Wed, 18 Feb 2004 20:26:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218192658.GA19573@zion.homelinux.com>
References: <20040218101816.GA13588@zion.homelinux.com> <20040218172324.GW9464@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040218172324.GW9464@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Harald,

On Wed, Feb 18, 2004 at 06:23:24PM +0100, Harald Welte told us:
>=20
> > If it is, wouldn't most patches from pom need to be converted to
> > pom-ng again??
>=20
> Unfortunately yes.  Would you (or anybody else) be willing to do this in
> a local tree, make a diff, review it and finally submit it to me?  I'd
> rather not spend more time with this stuff at the moment, pom-ng has
> already taken too much time in the past.

I can and will happily do that when I have some more free time which
will be at the latest next week when I have a few days of vacation.

>=20
> > BTW, I'm currently about to port the nfnetlink-ctnetlink patch to 2.6
> > (which actually brought my attention to this bug), is anyone else=20
> > working on this??
>=20
> No.  I'm now working on finalizing the specification for the pkttnetlink
> message format (which has implications on nfnetlink).  Once this is
> done, we can consider the nfnetlink message format stable and submit for
> kernel inclusion (2.6.x).  Your port would be very welcome.
>=20


Ok. I'll submit a patch when I've finished it and it works!


Regards

Sven


--=20
Linux zion 2.6.3-rc2 #2 Fri Feb 13 00:07:44 CET 2004 i686 athlon i386 GNU/L=
inux
 20:19:33  up 1 day, 19:52,  3 users,  load average: 0.00, 0.01, 0.00

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAM7x/o4FAdB2PneQRAgWVAJ0UNrTivdoNaTvdmkZ8wnYyQUhXEwCfdK6m
KrgQ46qscz/fAb5dV+GVijE=
=Wamm
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
