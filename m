From: Harald Welte <laforge@gnumonks.org>
Subject: Re: fix for ipt_TCPMSS
Date: Wed, 9 Oct 2002 16:54:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009165451.W13233@sunbeam.de.gnumonks.org>
References: <20021006115312.GA1936@whiskey.dummy.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oNVW4gaiVGQBzhrj"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Lennart Poettering <mz6e657466696c746572@itaparica.org>
Content-Disposition: inline
In-Reply-To: <20021006115312.GA1936@whiskey.dummy.lan>; from mz6e657466696c746572@itaparica.org on Sun, Oct 06, 2002 at 01:53:12PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oNVW4gaiVGQBzhrj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 06, 2002 at 01:53:12PM +0200, Lennart Poettering wrote:
> Hi!
>=20
> While looking at the source code of the TCPMSS target I noticed a
> simple error: the target makes an expanded copy of the skb if
> needed. However, this copy is no longer owned by the original "struct
> sock". The attached patch fixes this.
>=20
> If the skb is copied without this fix the kernel will oops short time
> after, when some code tries to access the attached "struct sock", which is
> NULL.
>=20
> The code of TCPMSS isn't perfect anyway since the skb is copied twice
> under certain circumstances. This is not needed.
>=20
> Nobody ever triggered this error, as it seems. Nonetheless, it is an
> error.

your patch seems fine to me.  I have asked Marc Boucher (as the original
author) to confirm this bug.
> lp

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--oNVW4gaiVGQBzhrj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pEM6XaXGVTD0i/8RAjS4AKCQJQBT00+sqp6cavEFh2bL/Ox93wCfbOfw
M1NQ9WkE7Z9JOSAGH1eTh94=
=6j/d
-----END PGP SIGNATURE-----

--oNVW4gaiVGQBzhrj--
