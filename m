From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ipt_TARPIT
Date: Thu, 5 Dec 2002 21:45:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205204519.GP11068@naboo.club.berlin.ccc.de>
References: <Pine.LNX.4.44.0211301639220.14832-100000@asherah.die.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Aaron Hopkins <lists@die.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211301639220.14832-100000@asherah.die.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 30, 2002 at 04:44:44PM -0800, Aaron Hopkins wrote:
> [ This is a resend.  The list appears to have eaten my post from last=20
>   night, so I'm retrying as a subscriber. ]
>=20
> On April 2, I submitted a patch to add --reject-with tcp-synack to the
> REJECT target.  It was suggested that this functionality was "antisocial",
> but that it would be accepted into patch-o-matic as a separate module.  I
> wrote such a module, put in production, then promptly forgot about it.

thanks, applied to CVS.

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

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977rfXaXGVTD0i/8RAgjvAJ9fX/2ssG8nx97TUkcGPSruK0waDgCfUED6
hsxSSt/toSXHzQ4yVtODNHE=
=JmCd
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
