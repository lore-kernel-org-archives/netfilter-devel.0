From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH]: invalid port number in libipt_MASQUERADE.c
Date: Thu, 30 Oct 2003 07:37:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1067495843.19734.0.camel@tux.rsn.bth.se>
References: <200310300536.OAA14264@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QQ9KdOHuQ5cykAz0cRUu"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200310300536.OAA14264@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-QQ9KdOHuQ5cykAz0cRUu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-10-30 at 06:36, Yasuyuki Kozakai wrote:
> Hi,
>=20
> This small patch fixes the bug that allows
> 	iptables -t nat -I POSTROUTING -p tcp -j MASQUERADE --to-port -1

Thanks, applied.

--=20
/Martin

--=-QQ9KdOHuQ5cykAz0cRUu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/oLGiWm2vlfa207ERArClAKCRBxOblwlR+Kw4og1PRt/mvG9JLgCfUnR6
C1+N4qrmQS0d9zI3ZFFM7g0=
=A9OC
-----END PGP SIGNATURE-----

--=-QQ9KdOHuQ5cykAz0cRUu--
