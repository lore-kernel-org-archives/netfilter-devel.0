From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Sat, 11 Dec 2004 14:39:26 +0100
Message-ID: <1102772366.12078.42.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
	<1102772053.12078.40.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-54zDepUXWCJzOxvXsAmD"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <1102772053.12078.40.camel@tux.rsn.bth.se>
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


--=-54zDepUXWCJzOxvXsAmD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-12-11 at 14:34, Martin Josefsson wrote:

Argh

> -	if (!h)
> +	if (!ct)
>  		return dropped;
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> I think we are pretty much guranteed to have a valid ct here, otherwise
> we would oops above :)

Forget that :) Didn't think about the case where we don't have any
unassured connections.

--=20
/Martin

--=-54zDepUXWCJzOxvXsAmD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBuviOWm2vlfa207ERAjJdAJ40Jv4xLvhU58J1BLyQMrLfJY6yyACZASOO
W8XYe+WwPiK7HiOXXxAy76I=
=79ka
-----END PGP SIGNATURE-----

--=-54zDepUXWCJzOxvXsAmD--
