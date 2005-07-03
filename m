From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: can't access svn repository
Date: Sun, 3 Jul 2005 18:53:34 +0200
Message-ID: <20050703165334.GA18798@zion.homelinux.com>
References: <20050701132843.GA20157@zion.homelinux.com>
	<20050703124244.GZ3186@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050703124244.GZ3186@sunbeam.de.gnumonks.org>
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


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Harald,

On Sun, Jul 03, 2005 at 02:42:44PM +0200, Harald Welte told us:
> On Fri, Jul 01, 2005 at 03:28:43PM +0200, Sven Schuster wrote:
> >=20
> > Hi everybody,
> >=20
> > does anybody else also have problems accessing the svn repository??
> >=20
> > When I run
> >=20
> > svn co https://svn.netfilter.org/netfilter/trunk/iptables
>=20
> mh, strange.  I just tried here (svn, version 1.2.0 (r14790) on the
> client) without any problems.

I just upgraded svn to 1.2.0, now it works. Seems to me like
backwards compatibility isn't one of svn's strengths...

Nevertheless, thanks for taking a look!!


Sven


--=20
Linux zion 2.6.12-mm2 #3 Thu Jun 30 21:35:27 CEST 2005 i686 athlon i386 GNU=
/Linux
 18:51:23 up 2 days, 20:34,  2 users,  load average: 0.45, 0.19, 0.08

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCyBgOo4FAdB2PneQRAv53AJ4unhHZ32BN9uFgSz353KBCAYeSPQCfUutf
R7N0GIe4tvRo8TEpvyQBzAA=
=7ynO
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
