From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fix compliation of ipt_time under 2.6.14
Date: Thu, 3 Nov 2005 19:08:49 +0100
Message-ID: <20051103180849.GI905@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.62.0510311723350.2264@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ecMC0kzqsE2ddMN"
Cc: netfilter-devel@lists.netfilter.org, Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0510311723350.2264@bizon.gios.gov.pl>
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


--3ecMC0kzqsE2ddMN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2005 at 05:29:44PM +0100, Krzysztof Oledzki wrote:
> Hello,
>=20
> Attached (and inlined) patch fixes ipt_time compliation under 2.6.14.
> There are two version of this patch - one that fixes
> patchlets/time/linux and second that adds patchlets/time/linux-2.6.14.

we only need the former, since we're dropping support for older kernels
anywa.y

I'll apply your first patch.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3ecMC0kzqsE2ddMN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDalIxXaXGVTD0i/8RAo+3AJ0XLe9tbOcd7Q8F1c8STJtXjrHXjwCeM/zX
Oez6oyLaApembyZtDX35JVw=
=VAET
-----END PGP SIGNATURE-----

--3ecMC0kzqsE2ddMN--
