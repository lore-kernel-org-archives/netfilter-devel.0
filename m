From: Harald Welte <laforge@gnumonks.org>
Subject: Re: libipt_conntrack.c iptables-save bug [PATCH]
Date: Thu, 5 Dec 2002 21:15:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205201545.GF11068@naboo.club.berlin.ccc.de>
References: <20021126033032.45cb1c4b.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Schwendt <rh0209ms@arcor.de>
Content-Disposition: inline
In-Reply-To: <20021126033032.45cb1c4b.rh0209ms@arcor.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2002 at 03:30:32AM +0100, Michael Schwendt wrote:

> libipt_conntrack.c in several places also lacks a white-space
> character after the '!' prefix of an invertable argument.

thanks, patch applied.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977PxXaXGVTD0i/8RAnHuAJ9WjXxoLymmNT5Hw1hPBSykWab+nQCeO/LU
Ycdt2oxxDSD2VF7KhqfWsTQ=
=6ExO
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
