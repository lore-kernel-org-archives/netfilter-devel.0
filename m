From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Fix LIST_INSERT breakage
Date: Sun, 28 Mar 2004 20:40:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328184053.GY7039@sunbeam.de.gnumonks.org>
References: <20040324010230.GA4144@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ECAkxgSy0pGoHfdA"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20040324010230.GA4144@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ECAkxgSy0pGoHfdA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2004 at 05:02:30PM -0800, Phil Oester wrote:
> In 2.4.25, this patch was included:
>=20
> http://linux.bkbits.net:8080/linux-2.4/cset@3fcc5cc99cChx6Q0shnhIlekWT1-5=
Q?nav=3Dindex.html|ChangeSet@-4M
>=20
> which has a questionable change in LIST_INSERT due to the disappearing
> cmpfn. =20

Could you be more specific about your objections against that changeset?

> But it appears this macro is unused anywhere in the tree, so perhaps
> removing it is better than fixing it?

mh, we also don't use it in patch-o-matic-ng.  So we could remove it,
true.

> Phil Oester

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ECAkxgSy0pGoHfdA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZxw1XaXGVTD0i/8RAhEWAJ9IJvBJDthAmSMVFHP12CJ5hMfT3wCfQVZp
LGw8WAaLCoZKZ+gKcfMIYh0=
=hPvL
-----END PGP SIGNATURE-----

--ECAkxgSy0pGoHfdA--
