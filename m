From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Traffic accounting match, once again
Date: Wed, 17 Mar 2004 15:28:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317142856.GH21899@sunbeam.de.gnumonks.org>
References: <20040307174010.GA4193@pandora.barbara.eu.org> <20040308102437.GA11273@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Piotr Gasid?o <quaker@pandora.barbara.eu.org>
Content-Disposition: inline
In-Reply-To: <20040308102437.GA11273@pandora.barbara.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 08, 2004 at 11:24:37AM +0100, Piotr Gasid?o wrote:
> On Sun, 07/03, 06:40:10PM, Piotr Gasid?o wrote:
> > Hello,
> >=20
> > Nearly two months ago I've sent to netfilter-devel my ipt_account.patch.
> > It was at the beginning rejected because of polish language in comments.
> > I've translated it to english. I've also fixed some minor bug in
> > libipt_account.c/save function.
> > (...)
>=20
> I've attached wrong diffs. Sorry :)

thanks, I'm applying them right now:

btw: patch-o-matic is no longer used, we now use patch-o-matic-ng.
and: Please send diffs as uncompressed plaintext, this way any
emailreader would be able to display them without extra
saving/uncompressing/...

> These are right.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWGCoXaXGVTD0i/8RAlKOAJ9bqSLHJyPnfgHHJYCjs4LKplG6NACfY/Fn
/x9LcT6xu/pjpTr3aN7Xafs=
=9rq8
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
