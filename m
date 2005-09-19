From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip{,6}t_random / fix build warnings.
Date: Mon, 19 Sep 2005 17:05:14 +0200
Message-ID: <20050919150514.GD12075@rama.de.gnumonks.org>
References: <200509171330.59410.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Content-Disposition: inline
In-Reply-To: <200509171330.59410.pluto@agmk.net>
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


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2005 at 01:30:59PM +0200, Pawe=C5=82 Sikora wrote:
> Hi,
>=20
> Attached patch fixes gcc warnings:

Applied with modifications (use %Zd).
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLtOqXaXGVTD0i/8RAs8BAJ0fo2+O4tIVvyxftwwP4aF1cEPu+QCgnrwv
3T7oSN62/aEvtbbBee6ewN0=
=kNTj
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
