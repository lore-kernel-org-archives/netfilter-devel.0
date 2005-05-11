From: Anatoly Pugachev <mator@rootshell.ru>
Subject: quake3 pom module minor warning
Date: Wed, 11 May 2005 15:51:52 +0400
Message-ID: <20050511115152.GA1942@helminth.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

If you're selected to use "quake3 connection tracking and NAT helper" POM
"extra repository" module with recent 2.6.x kernel, then in stage of compil=
ing
2.6.x kernel, you'll get following warning (i'm tryed with kernel version
2.6.11.8) :

  CC      net/ipv4/syncookies.o
scripts/Makefile.build:48: kbuild: net/ipv4/netfilter/Makefile - Usage of
export-objs is obsolete in 2.6. Please fix!

last time i was tryed to compile it with patch-o-matic-ng-20050414.
anyone cares to fix this simple warning? :)

--=20
Anatoly Pugachev

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFCgfHVoubiDytudlARAufJAJ9pvmyP/c/kEoq8oQrlBPvA1O3wNgCdH36g
X4h/LjHNa2d9bEZmh31zjRc=
=u7sT
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
