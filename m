From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Strange thing with iptables
Date: Thu, 09 Sep 2004 14:18:15 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094732295.8900.7.camel@localhost.localdomain>
References: <opsd15s018le1n2s@mail.tlt.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-xOi2ecClLJpQVhWy6R1Q"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
In-Reply-To: <opsd15s018le1n2s@mail.tlt.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-xOi2ecClLJpQVhWy6R1Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-09-09 at 13:49, Szabolcs Gyurko wrote:
> Hi all,
>=20
>=20
> I found a strange issue with the iptables. One of my friend showed me a =20
> rule
> which looked like:
>=20
> iptables -A FORWARD -s $machine/255.255.0.255 -j ACCEPT
>=20
>=20
> What I was surprised on is the netmask. Is this a feature or a bug? I mea=
n
> this is quite strange netmask for me.

It's a feature :)
It doesn't make the current code any more complicated.
And ther are actually people using it to do weird stuff...

--=20
/Martin

--=-xOi2ecClLJpQVhWy6R1Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBQEoHWm2vlfa207ERAuTDAJ4zff/ZTtm2szEayXHNSKQzmNh2hgCfcZSr
IMweacJhF0NNYhn4/xL2zDY=
=MoSo
-----END PGP SIGNATURE-----

--=-xOi2ecClLJpQVhWy6R1Q--
