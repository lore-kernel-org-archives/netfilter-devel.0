From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: iptables not working on 2.6.16-rc1-mm2
Date: Wed, 25 Jan 2006 21:55:33 +0100
Message-ID: <20060125205533.GA4658@zion.homelinux.com>
References: <20060125193627.GA6967@zion.homelinux.com>
	<20060125195127.01C3B22AF07@anxur.fi.muni.cz>
	<20060125204900.6D0BF22AEFB@anxur.fi.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jiri Slaby <xslaby@fi.muni.cz>
Content-Disposition: inline
In-Reply-To: <20060125204900.6D0BF22AEFB@anxur.fi.muni.cz>
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


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Jiri,

On Wed, Jan 25, 2006 at 09:49:02PM +0100, Jiri Slaby told us:
> Sven Schuster wrote:
> >On Wed, Jan 25, 2006 at 08:51:28PM +0100, Jiri Slaby told us:
> >> Hi, is this the same problem?
> >> http://lkml.org/lkml/2006/1/20/158
> >
> >at first look a it seems like the same problem, but looking at the patch
> >and checking the kernel source I see that it is already in
> >2.6.16-rc1-mm2...
> That's it, try to revert it -- it is in -mm since .16-rc1-mm2.

aaah :-) will do so, I'm currently recompiling the kernel and report
back later!

thanks


Sven

>=20
> regards,
> --=20
> Jiri Slaby         www.fi.muni.cz/~xslaby
> \_.-^-._   jirislaby@gmail.com   _.-^-._/
> B67499670407CE62ACC8 22A032CC55C339D47A7E
>=20
>=20

--=20
Linux zion.homelinux.com 2.6.15-mm2_23 #23 Sun Jan 8 19:59:38 CET 2006 i686=
 athlon i386 GNU/Linux
 21:54:33 up 57 min,  2 users,  load average: 0.03, 0.04, 0.01

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD1+XFo4FAdB2PneQRAkFfAJ9FyJFdaZ04Sk+8FI85TeUoHCtu9ACfQiYy
szLjWOutj/rXt5EsmISw5FY=
=2Y3k
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
