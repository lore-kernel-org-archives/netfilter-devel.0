From: Harald Welte <laforge@gnumonks.org>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Mon, 31 Mar 2003 14:31:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331123134.GN7718@sunbeam.de.gnumonks.org>
References: <3E8832B4.8030901@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iIq+KTIB+xWY0FJy"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>
Content-Disposition: inline
In-Reply-To: <3E8832B4.8030901@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iIq+KTIB+xWY0FJy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 02:21:08PM +0200, Friedrich Lobenstock wrote:
> Hi!
>=20
> Regarding your patch
>   http://cvs.netfilter.org/~checkout~/netfilter/patch-o-matic//extra/pptp=
-conntrack-nat.patch
>=20
>=20
> May I suggest that you make this a configurable option, because
> I had this "bad csum" problem and therefor had to remove the '//'
> in front of the 'return NF_ACCEPT;'

actually, _with_ the '//' in front, it accepts packets with broken
checksums.  If you remove the '//' in front, it will not consider
packets with broken checksums.

So W2k should work with the shipped patch ! (IIRC, it works in both
cases)

> --=20
> MfG / Regards
> Friedrich Lobenstock

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--iIq+KTIB+xWY0FJy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iDUmXaXGVTD0i/8RAtCIAJ4xQj6PRZUYozKnsR6GUKRCugQzTgCeNvgE
gQbkBgPrS1ZuvLXHZcfRj8s=
=FHnI
-----END PGP SIGNATURE-----

--iIq+KTIB+xWY0FJy--
