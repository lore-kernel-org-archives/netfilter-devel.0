From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
	services)
Date: Sat, 17 Apr 2004 22:58:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1082235494.13261.385.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
	 <408167F2.9060501@fl.priv.at> <408180C7.6080302@eurodev.net>
	 <40818C75.8010609@fl.priv.at>  <4081911D.1070307@fl.priv.at>
	 <1082234028.13261.375.camel@tux.rsn.bth.se>  <4081967F.8040005@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dxLkwBiNAxW9K0KV+9pr"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4081967F.8040005@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-dxLkwBiNAxW9K0KV+9pr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-04-17 at 22:41, Friedrich Lobenstock wrote:

> > The new hashfunction (jenkins) doesn't need that (2.4 and 2.6 has it).
> > It's very happy with 2^n sizes, in fact it's happy with all sizes :)
>=20
> Since which official kernel 2.4 release do we have the new hash? If it is=
=20
> just 2.4.24 or up then you should still need to mention this fact about t=
he=20
> prime number. See the one guy posting about kernel 2.4.20.

I don't remember since which kernel. Tell the person who wrote that
document to update it.
Please don't mention kernel 2.4.20, conntrack is horribly broken in
2.4.20 unless patched...

> PS: Please respect the "Reply-to". Thanks!

Only if you respect mine (or the lack of one) :)

--=20
/Martin

--=-dxLkwBiNAxW9K0KV+9pr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAgZpmWm2vlfa207ERAltJAJ0dMPUHGi/olmv7LTr5p+LC+ipUjACgpGzj
q63ew8kbbyE0YXRFgb5ba9c=
=kmbS
-----END PGP SIGNATURE-----

--=-dxLkwBiNAxW9K0KV+9pr--
