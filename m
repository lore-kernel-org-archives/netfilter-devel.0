From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: iptables not working on 2.6.16-rc1-mm2
Date: Wed, 25 Jan 2006 21:14:18 +0100
Message-ID: <20060125201416.GA4149@zion.homelinux.com>
References: <20060125193627.GA6967@zion.homelinux.com>
	<20060125195127.01C3B22AF07@anxur.fi.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jiri Slaby <xslaby@fi.muni.cz>
Content-Disposition: inline
In-Reply-To: <20060125195127.01C3B22AF07@anxur.fi.muni.cz>
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


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Jiri,

On Wed, Jan 25, 2006 at 08:51:28PM +0100, Jiri Slaby told us:
> Hi, is this the same problem?
> http://lkml.org/lkml/2006/1/20/158

at first look a it seems like the same problem, but looking at the patch
and checking the kernel source I see that it is already in
2.6.16-rc1-mm2...


Sven

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
 21:08:59 up 12 min,  2 users,  load average: 0.05, 0.30, 0.31

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD19wYo4FAdB2PneQRAja/AJ9CX9XHHjAOJs3ilhYFX9uxNKNXBACdHxpj
GDo4N5iaLqW63CV3btRDYUg=
=si6o
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
