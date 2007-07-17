From: Eric Leblond <e.leblond@inl.fr>
Subject: Re: ENOBUFS in nfq under heavy load
Date: Tue, 17 Jul 2007 17:56:08 +0200
Message-ID: <1184687768.16798.18.camel@khasse.inl.fr>
References: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-LBGsghdBI/rG2QMNArJi"
Cc: netfilter-devel@lists.netfilter.org
To: =?UTF-8?Q?Stanis=C5=82aw?= Pitucha <viraptor@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
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


--=-LBGsghdBI/rG2QMNArJi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 17 juillet 2007 =C3=A0 16:46 +0100, Stanis=C5=82aw Pitucha a =C3=
=A9crit :
> Hi
> After running nf_queue app under heavy load I get ENOBUFS error. Ok -
> maybe not that heavy - around 100 concurrent voip calls - lots of
> small udp packets. Nfq socket suddenly hangs. recv() from nfnl_fd()
> socket returns -1, errno=3DENOBUFS and when I try to destroy the queue
> it stops:
> stacktrace with gdb breaking...
>=20
> Any idea how to avoid / fix it?=20

You could simply use the limit match to avoid "heavy" load.

> Is the problem on my side?

No, it's an implementation problem.

> My bufsize is 65535 for reading from nfq socket.
>=20
> Thanks
> Stan

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-LBGsghdBI/rG2QMNArJi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGnOaYnxA7CdMWjzIRAiJNAJwOwOcXtPD67MbXJTovftWcsWi6ZQCfSyZO
ELiIYts6XLZzz/J2NVXM2sg=
=Yjjw
-----END PGP SIGNATURE-----

--=-LBGsghdBI/rG2QMNArJi--
