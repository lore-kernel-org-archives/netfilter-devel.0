From: Eric Leblond <eric@regit.org>
Subject: Re: RBAC Integration
Date: 27 Jun 2003 22:44:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056746685.19776.5.camel@porky>
References: <1056734756.7156.2.camel@skinny.gideonolam.com>
	 <20030627174010.GB10045@oknodo.bof.de>
	 <1056741347.7156.10.camel@skinny.gideonolam.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rytnp6rLGwQiTITWKhhC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1056741347.7156.10.camel@skinny.gideonolam.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Rytnp6rLGwQiTITWKhhC
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le ven 27/06/2003 =E0 21:15, gideon olam a =E9crit :
> On Fri, 2003-06-27 at 11:40, Patrick Schaaf wrote:
>   Userspace could use roles to determine who has what access rights to a =
table.
>    Matches like owner might be able to benefit.  I would think there=20
> would be a large variety
> of implications for integration.

I think you don't go far enough. A framework doing external autorisation
thanks to the QUEUE target could be very useful.
In fact, I'm coding an auth request system (based on UDP) which permits
to any protocol compliant auth server to take decision over packet.

BR,
--=20
Eric Leblond <eric@regit.org>

--=-Rytnp6rLGwQiTITWKhhC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+/Ky9nxA7CdMWjzIRAuQDAJ0boTUCrQz2z5l9txPgRhiJEHCUDgCfQFUs
LPWLJI3y5LjLJxnJOgnLcBU=
=F6Wd
-----END PGP SIGNATURE-----

--=-Rytnp6rLGwQiTITWKhhC--
