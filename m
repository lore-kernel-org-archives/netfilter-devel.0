From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [POM] h323-conntrack-nat: please delete ip_conntrack_h323.c
Date: Wed, 14 Sep 2005 21:13:56 +0200
Message-ID: <1126725236.4549.0.camel@localhost.localdomain>
References: <20050914182903.GA3247@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-HMRAo+2xRKedR1gCKWoD"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050914182903.GA3247@roonstrasse.net>
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


--=-HMRAo+2xRKedR1gCKWoD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-09-14 at 20:29 +0200, Max Kellermann wrote:
> Hi,

Hi

> while porting the h323-conntrack-nat module to Linux 2.6.13, I noticed
> that the old files ip_conntrack_h323.c were not deleted from the
> patch-o-matic subversion repository.  Please delete from trunk:
>=20
>  patchlets/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrac=
k_h323.c
>  patchlets/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrac=
k_h323.c
>=20
> .. these files were split up into ip_conntrack_h323_core.c,
> ip_conntrack_h323_h225.c, ip_conntrack_h323_h245.c.

Done, thanks.
(I assume you meant 2.6.11 and 2.6.12 above)

--=20
/Martin

--=-HMRAo+2xRKedR1gCKWoD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDKHZzWm2vlfa207ERAmNFAJ9xJtsT8JJfmKriLKwO77/02P7M3wCgtS1L
k2SXGp/I8GMFGxzhxXj/6oM=
=ZbfE
-----END PGP SIGNATURE-----

--=-HMRAo+2xRKedR1gCKWoD--
