From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [resend] p-o-m runme --exclude update
Date: Thu, 13 Nov 2003 17:21:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1068740471.774.5.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0311131619330.20382-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nnHm76eWmFzs3wpL8tMV"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311131619330.20382-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-nnHm76eWmFzs3wpL8tMV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-11-13 at 16:22, Henrik Nordstrom wrote:
> This patch extends the --exlude option to runme to accept pathes named by=
=20
> their full name (including .patch). Previously the --exclude option only=20
> matched patches by their internal base name (dir/patchname without=20
> .patch).
>=20
> This makes --exclude more consistent with the other patch naming in
> patch-o-matic use.

Applied, thanks

--=20
/Martin

--=-nnHm76eWmFzs3wpL8tMV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/s693Wm2vlfa207ERAngIAKCBfr96/tAiw2iLfZWNTOyPwB1X1ACghFbX
XEkzVrV15IVR/QGo1HiLniU=
=xPay
-----END PGP SIGNATURE-----

--=-nnHm76eWmFzs3wpL8tMV--
