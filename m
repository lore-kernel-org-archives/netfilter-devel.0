From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink & helper_locking_fix conflict
Date: Tue, 9 Nov 2004 18:11:06 +0100
Message-ID: <20041109171106.GF22257@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.61.0411090808200.30695@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bnBIwIKtMHAVL+3z"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0411090808200.30695@filer.marasystems.com>
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


--bnBIwIKtMHAVL+3z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 09, 2004 at 08:13:33AM +0100, Henrik Nordstrom wrote:
> Hi,
>=20
> there is a conflict between the above two patches. The helper_locking_fix=
=20
> removes the locks from the helpers, but ctnetlink adds code using these=
=20
> locks.
>=20
> >From reading the code I think the helper side locking should be removed=
=20
> from the ctnetlink additions as well, but just wanted to verify with you.

I think it is safe.  We're holding a write lock on ip_conntrack_lock and
thus it's safe to change the helper data.

If you have a fix for ctnetlink, that would be appreciated

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bnBIwIKtMHAVL+3z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBkPoqXaXGVTD0i/8RAkbwAKCY3PGkECyVYhSQez/6/DJ8sjmZswCfQ6iH
Heh/K12eRSt7mCeIrhRpRI4=
=9k6C
-----END PGP SIGNATURE-----

--bnBIwIKtMHAVL+3z--
