From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!) in
	ipt_limit
Date: Tue, 18 Oct 2005 11:19:10 +0200
Message-ID: <20051018091910.GB25908@zion.homelinux.com>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
	<4353BFFB.7070406@trash.net>
	<20051017213551.GA6043@zion.homelinux.com>
	<Pine.LNX.4.61.0510181031330.6259@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0510181031330.6259@filer.marasystems.com>
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


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Henrik,

On Tue, Oct 18, 2005 at 10:33:18AM +0200, Henrik Nordstrom told us:
> Mainly because the way iptables is designed makes it extremely hard to=20
> extend the core with new attributes without breaking compatibility with=
=20
> userspace (which is not allowed), while doing it in the matches is very=
=20
> simple even if it leads to duplicated code.

yes that's what I guessed that it can't be done now due to
userspace compatibility issues. But apart from that, it would have
been a better solution if it had been implemented in the core from "day
1" on, wouldn't it??


Thanks,

Sven

> Regards
> Henrik
>

--=20
Linux zion.homelinux.com 2.6.14-rc4-mm1_10 #10 Mon Oct 17 10:47:30 CEST 200=
5 i686 athlon i386 GNU/Linux
 11:16:33 up 14:47,  1 user,  load average: 4.79, 4.26, 2.56

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDVL4Oo4FAdB2PneQRAqkMAJ0eN6cDTb+TMESSnsXSrmEyzD2m9wCfSv1n
/tOdrf4Y6+3Z6/XNzzZnQ2E=
=TEWH
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
