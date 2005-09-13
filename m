From: Harald Welte <laforge@netfilter.org>
Subject: Re: more nf_conntrack/ip_conntrack questions
Date: Tue, 13 Sep 2005 15:15:23 +0200
Message-ID: <20050913131523.GU29695@sunbeam.de.gnumonks.org>
References: <200509121129.j8CBT83a022872@toshiba.co.jp>
	<200509121141.j8CBfHp1003079@toshiba.co.jp>
	<43256ED8.2090500@ufomechanic.net>
	<200509121256.j8CCuHwd028705@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y5yQnZmVlpWlTeDv"
Cc: netfilter-devel@lists.netfilter.org, azez@ufomechanic.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200509121256.j8CCuHwd028705@toshiba.co.jp>
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


--y5yQnZmVlpWlTeDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 12, 2005 at 09:56:16PM +0900, Yasuyuki KOZAKAI wrote:
> From: Amin Azez <azez@ufomechanic.net>
> Date: Mon, 12 Sep 2005 13:04:40 +0100
>=20
> > Sure, I don't have any fault with the structures, just the way the
> > sizeof is measured for initial zero-ing.
>=20
> Oh, it's reasonable. Thank you for notice.
>=20
> Harald, please apply this patch.

thanks, applied to netfilter-2.6.14#nf_conntrack

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--y5yQnZmVlpWlTeDv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDJtDrXaXGVTD0i/8RAhb9AJ0bA4TT0NYpNK1P4/YsghnS++d8RACeNLDx
FkPcPRXfWadKIJYGU/yjWec=
=ULhA
-----END PGP SIGNATURE-----

--y5yQnZmVlpWlTeDv--
