From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
	services)
Date: Sat, 17 Apr 2004 22:33:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1082234028.13261.375.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
	 <408167F2.9060501@fl.priv.at> <408180C7.6080302@eurodev.net>
	 <40818C75.8010609@fl.priv.at>  <4081911D.1070307@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WlXyHGZgniRrJC+AjnLX"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>
In-Reply-To: <4081911D.1070307@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-WlXyHGZgniRrJC+AjnLX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-04-17 at 22:18, Friedrich Lobenstock wrote:

> As the hash algorithm needs the hash size to be prime, here a link to fin=
d=20
> a fitting one http://www.prime-numbers.org/ which should be linked right=20
> after the above mentioned link.

The new hashfunction (jenkins) doesn't need that (2.4 and 2.6 has it).
It's very happy with 2^n sizes, in fact it's happy with all sizes :)

--=20
/Martin

--=-WlXyHGZgniRrJC+AjnLX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAgZSsWm2vlfa207ERAvAnAJwOK1gf03IQ638c1Gd36wfFZ8cBCQCePdC+
GXZFaWxz6c4Ggmhxvb8U8a8=
=nWjY
-----END PGP SIGNATURE-----

--=-WlXyHGZgniRrJC+AjnLX--
