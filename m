From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables-save saves invalid negative --uid-owner expressions.
Date: Mon, 6 Jan 2003 13:34:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106123414.GD9467@sunbeam.de.gnumonks.org>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOzekVbrLdOLv44p"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20030106020219.GC423@comet.rv-int>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GOzekVbrLdOLv44p
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 03:02:19AM +0100, Herv=E9 Eychenne wrote:
> On Mon, Jan 06, 2003 at 03:31:07AM +0200, Costa Tsaousis wrote:
>=20
>  Hi,
>=20
> > I believe I have faced another, not-mentioned-in-2002, bug:
> > [...]
> > then iptables-save gives this:
> >=20
> > -A OUTPUT -d ! 127.0.0.1 -p tcp -m owner --uid-owner !squid -m tcp --dp=
ort
> > 80 -j DNAT --to-destination 127.0.0.1:3128
> >=20
> > which produces a "user '!squid' not found" error when restored.
>=20
> It seems to me that no single week passes without any post about this
> kind of error (no space before a negation) in some save output module.
> Sigh.

Your observation is true.

> I must admit it seems quite strange to me that noone in the coreteam
> didn't do that already. (hope I won't hurt anybody's feelings too
> much though) ;-)

The problem is that we are mostly talking about contributed extensions,
and nobody seems to test the save() and restore() functions of their
extensions properly.

> Would someone who's even more fed up than me with these recurrent
> messages have time to audit the whole bunch of existing modules in
> the CVS tree and fix this particular kind of problem _once and for all_?

It can even be automatized by a script...

> Thanks in advance,
>  Herve
=20

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--GOzekVbrLdOLv44p
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GXfGXaXGVTD0i/8RApWaAJwJrET/+mr33jmVK7MDhWUtwd3FugCfZqv7
AYHgOE/91MXkHPrOPnGKLZg=
=7ym5
-----END PGP SIGNATURE-----

--GOzekVbrLdOLv44p--
