From: Harald Welte <laforge@netfilter.org>
Subject: Re: netfilter (+/- kernel) crash with
Date: Sat, 14 Feb 2004 21:07:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214200729.GR7756@sunbeam.de.gnumonks.org>
References: <1075967547.4756.25.camel@vijay>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffBYM5qgR8HH9Mta"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Content-Disposition: inline
In-Reply-To: <1075967547.4756.25.camel@vijay>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ffBYM5qgR8HH9Mta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 05, 2004 at 01:22:28PM +0530, Vijaya Chandra Vupputuri wrote:
> Can someone please let me know if this is a known issue?
> Any pointers to the possible cause would make my day.

No, this is definitely not a known issue.

Could you please try without the quota patch and see if the problem
persists?  I would be really surprised if a stock kernel without any
modifications (apart from pom 'submitted') would cause such behaviour.

> Vijaya Chandra Vupputuri,
> Tachyon Technologies.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ffBYM5qgR8HH9Mta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALoABXaXGVTD0i/8RAm6TAJ4yPAYaR3e0XpFWL9Z6l84BoCnZ4gCgkiCg
eZVEBcNNiWxGbo+Ate59zz0=
=xgDI
-----END PGP SIGNATURE-----

--ffBYM5qgR8HH9Mta--
