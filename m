From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] ulogd fix for kernel 64bits/userspace 32bits system
Date: Thu, 12 Oct 2006 16:14:31 +0200
Message-ID: <1160662471.15687.11.camel@localhost.localdomain>
References: <1160654607.9238.5.camel@localhost.localdomain>
	<452E30AE.9030805@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-a08BxFHKwFqyIgNgQ5mn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <452E30AE.9030805@trash.net>
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


--=-a08BxFHKwFqyIgNgQ5mn
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le jeudi 12 octobre 2006 =E0 14:10 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > Hello,
> We're actually going to remove that and I am very reluctant to
> add this.
>=20
> - its a compile-time solution and therefor unusable for distributors
>=20
> - it might get accidentally enabled by a distributor should he
>   be crazy enough to compile packages in a mixed environment

Both points seem linked with autodetection of system. I agree that it is
potentially dangerous.

In fact, it may be better to use a configure flag approach ? What do you
think ?

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-a08BxFHKwFqyIgNgQ5mn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFLk3GnxA7CdMWjzIRAiVmAJ446gGIRepkEO00vwTJZWRB6dta2gCbBEOC
5nTKHrpEGONd2EQZAkUnnwo=
=L2v0
-----END PGP SIGNATURE-----

--=-a08BxFHKwFqyIgNgQ5mn--
