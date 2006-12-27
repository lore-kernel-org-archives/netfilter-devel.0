From: Eric Leblond <eric@inl.fr>
Subject: [RFC] libnfnetlink and iface conversion to string
Date: Wed, 27 Dec 2006 23:17:34 +0100
Message-ID: <1167257854.31765.21.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5FTQqugizs30YiAffOKH"
Cc: Harald Welte <laforge@netfilter.org>, Vincent Deffontaines <vincent@inl.fr>,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-5FTQqugizs30YiAffOKH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm currently working on NuFW where I try to do iface conversion from
integer to string to be able to filter "naturally" on interfaces.

For now, it is impossible to do this conversion from either
libnetfilter_queue or libnfnetlink. But there is two files in
libnfnetlink (iftable.c and rntl.c) which have been put here by Harald
to provide this conversion (if I remember correctly an old mail from
Harald).

It was a long time ago and I don't know if it still planned to modify
libnfnetlink to include this feature. Or, would it be a better choice to
create a new library dedicated to this conversion.

Any comments are welcome.

I will start to work on it as soon as I know where to go.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-5FTQqugizs30YiAffOKH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFkvD+nxA7CdMWjzIRAngMAJsEmwxANxOGV4S/qVcIqzD+Ej8LwwCfVAUp
/zRVhHUhTUNqnxTdHOpRwVE=
=7iso
-----END PGP SIGNATURE-----

--=-5FTQqugizs30YiAffOKH--
