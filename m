From: Eric Leblond <eric@inl.fr>
Subject: [Patch 0/2] Re: libnfnetlink.h include generates problems...
Date: Tue, 12 Jun 2007 00:07:38 +0200
Message-ID: <1181599658.14536.3.camel@localhost>
References: <466DC10A.50805@packetdropped.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-I2waVtghqZUNF6Luz/ap"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: aton <aton@packetdropped.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466DC10A.50805@packetdropped.org>
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


--=-I2waVtghqZUNF6Luz/ap
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 11 juin 2007 =E0 23:39 +0200, aton a =E9crit :
> in one of my programs, i include the following two files:
>=20
> #include <linux/netfilter.h>
> #include <libnetfilter_queue/libnetfilter_queue.h>
>=20
> while a few of my header files include each other i get errors from
> these nfqueue header:
>=20
> In file included from /usr/include/sys/uio.h:24,
> /usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
> /usr/include/linux/types.h:27: error: previous declaration of 'dev_t'
> was here
>=20
> i talked to some guys from ##c on freenode, and they said, probably
> libnfnetlink.h should not directly include linux/types.h

This seems to be the case as we discus on #netfilter. I'm sending two
patches which fix this issue.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-I2waVtghqZUNF6Luz/ap
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbceqnxA7CdMWjzIRAi/rAJ0cfmBxMJM2nuX9yF0IYF2GwU9zbACfaBg7
2n8B9vax0YBOMGen6FVGaG4=
=zSEK
-----END PGP SIGNATURE-----

--=-I2waVtghqZUNF6Luz/ap--
