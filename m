From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Dump mark even if event is a DESTROY event
Date: Wed, 21 Feb 2007 14:13:04 +0100
Message-ID: <1172063584.5413.18.camel@localhost.localdomain>
References: <1171964721.26768.4.camel@localhost.localdomain>
	<45DC4052.2010305@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-MZdaZvOCKfywdDGqZax9"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45DC4052.2010305@netfilter.org>
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


--=-MZdaZvOCKfywdDGqZax9
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 21 f=E9vrier 2007 =E0 13:51 +0100, Pablo Neira Ayuso a =E9crit =
:
> Hi Eric,
>=20
> I don't see why you may need the mark in the destroy message. You can=20
> keep a cache in userspace with the connections that belong to a certain=20
> subset and their marks, then if the mark changes, move such connection=20
> the a different subset. It doesn't make sense to me the idea of=20
> including the mark in the destroy message since such mark didn't change=20
> with regards to the previous event delivered.

I do not agree with the idea of having a cache in userspace. It has been
coded in kernel and for this kind of stuff, once is enough. I really
want to avoid all synchronisation problems we could have to do this in
userspace.

Furthermore, mark exists to be able to create subset for other tools
like tc or ip.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-MZdaZvOCKfywdDGqZax9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBF3EVfnxA7CdMWjzIRApLvAJ9RNcdpXr2g2Mv6ztrFTH5cDxTASwCgiy5f
q0LfkgcsN0u3iXvobrTzAvA=
=C3ZV
-----END PGP SIGNATURE-----

--=-MZdaZvOCKfywdDGqZax9--
