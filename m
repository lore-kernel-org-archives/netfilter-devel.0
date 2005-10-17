From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!)
	in	ipt_limit
Date: Mon, 17 Oct 2005 23:35:52 +0200
Message-ID: <20051017213551.GA6043@zion.homelinux.com>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
	<4353BFFB.7070406@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <4353BFFB.7070406@trash.net>
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


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Patrick,

On Mon, Oct 17, 2005 at 05:15:07PM +0200, Patrick McHardy told us:
> Probably, I've never liked these strange looking expressions.
=2E..
> This breaks userspace compatibility, you need to use a new revision
> if you want to change this structure. Look at ipt_MARK for an example.

I know it's been a while since netfilter/iptables has been developed,
but why wasn't isn't the inversion built into the netfilter/iptables
core?? Inversion can be useful for any kind of match, so why duplicate
it in every single match?? Why not instead do a general inversion??
If I haven't thought of something obvious please cat this post to
/dev/null :-) (but pleas enlighten me before doing so *g*)


have a nice day :-)

Sven

--=20
Linux zion.homelinux.com 2.6.14-rc4-mm1_10 #10 Mon Oct 17 10:47:30 CEST 200=
5 i686 athlon i386 GNU/Linux
 23:32:03 up  3:03,  2 users,  load average: 0.04, 0.05, 0.00

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDVBk3o4FAdB2PneQRArMkAJ9R6E3if/avtoszxLGfwra6LeKV+wCbB8c/
pweDL/QZ0UFOdqIYgOWFuMY=
=9TN4
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
