From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/4] conntrack ftp helper modification to use new
	infrastrure
Date: Tue, 1 Feb 2005 12:01:39 +0100
Message-ID: <20050201110139.GY6878@sunbeam.de.gnumonks.org>
References: <41E1AEEF.9050005@eurodev.net> <41E1BC3B.5070101@trash.net>
	<41E1BEBC.3030703@eurodev.net> <41E1C261.6050100@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xUyMHIOv46mebLva"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41E1C261.6050100@trash.net>
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


--xUyMHIOv46mebLva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2005 at 12:46:41AM +0100, Patrick McHardy wrote:

> >Actually, I started a version using lists of nf_string_match to look=20
> >for a set of patterns iteratively but I finally decided to simplify=20
> >the thing. If someone finds this feature interesting I could recover=20
> >it in future.
>=20
> Since the FTP helper is currently the only possible user of such a feature
> I think the current way is fine.

It's not as rare as you might think.  Even the IRC helper has to look
for a list of different patterns...

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xUyMHIOv46mebLva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/2GTXaXGVTD0i/8RAnWWAJ0bHyFda+adCqlvzY1cfo8SH7iJlgCZAeW6
xrRqx9GRAQC1AoymM9G+1Uw=
=tOTl
-----END PGP SIGNATURE-----

--xUyMHIOv46mebLva--
