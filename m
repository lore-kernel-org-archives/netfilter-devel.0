From: Harald Welte <laforge@netfilter.org>
Subject: Re: TARPIT problem
Date: Thu, 1 Apr 2004 15:12:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040401131201.GB7462@sunbeam.de.gnumonks.org>
References: <1080781832.15450.35.camel@pretender>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tiago Ramos <tramos@dalera.com>
Content-Disposition: inline
In-Reply-To: <1080781832.15450.35.camel@pretender>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 01, 2004 at 02:10:33AM +0100, Tiago Ramos wrote:
> hi,
>=20
> I trying to patch a kernel 2.4.24 from debian and i get errors,=20
> The first is in the  Never happens "section"
> net/ipv4/netfilter/ipt_TARPIT.c:192: structure has no member named
> `pmtu'

Please contact the author of ipt_TARPIT (Aaron Hopkins <lists@die.net>)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAbBUhXaXGVTD0i/8RAijpAJwKkj06e9kk8B7c1y3QraTyYuDH4ACdEbOS
TbI7VYkRcCDqqQYsPKXBJFQ=
=RbeA
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
