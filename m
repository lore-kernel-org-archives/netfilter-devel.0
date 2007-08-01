From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] ulogd mysql fix
Date: Wed, 01 Aug 2007 15:43:26 +0200
Message-ID: <1185975806.15499.3.camel@khasse.inl.fr>
References: <1185968915.30855.9.camel@khasse.inl.fr>
	<46B08559.7040001@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-4vGKZAXreAHjvODi7UfR"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B08559.7040001@netfilter.org>
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


--=-4vGKZAXreAHjvODi7UfR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 01 ao=C3=BBt 2007 =C3=A0 15:06 +0200, Pablo Neira Ayuso a =C3=
=A9crit :
> Hi Eric,
>=20
> Eric Leblond wrote:
> > MySQL 5.0 has changed the default for database reconnection after
> > timeout. It is now not enabled by default. The following patch restores
> > the reconnection functionnality for the ulogd-mysql plugin.
>=20
> Why don't we inconditionally enable it? I mean, we can just forget about
> the version checking. If I understood well, mysql <=3D 5.0 enables
> reconnection by default and >=3D 5.0 doesn't, so we can inconditionally
> enable it and forget about future default behaviours. What do you think?

In fact, MYSQL_OPT_RECONNECT option has been introduced in MySQL 5.0.13
to restore the capability to reconnect to server after inactivity.
Furthermore, the functionnality was partially broken before 5.0.19 and
this explains the two calls to mysql_option.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-4vGKZAXreAHjvODi7UfR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGsI3+nxA7CdMWjzIRAnV7AJ0dJeYa02BQlqF9aTADcZw+YLD08gCePq3K
SJv5aLv6yHXtk8hGHcP7gO8=
=hY+6
-----END PGP SIGNATURE-----

--=-4vGKZAXreAHjvODi7UfR--
