From: Javier Kohen <jkohen@users.sourceforge.net>
Subject: Cannot apply h323-conntrack-nat
Date: Thu, 24 Mar 2005 15:22:33 -0500
Message-ID: <1111695753.32351.34.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-oMvVNtegn7CQl2av2eWS"
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
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


--=-oMvVNtegn7CQl2av2eWS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I'm trying to apply the h323-conntrack-nat patch to kernel 2.6.11-ck2
using pom-ng revision 3805, but it keeps saying: =C2=ABunable to find ladd
slot in src /tmp/pom-29949/include/linux/netfilter_ipv4/ip_conntrack.h.=C2=
=BB
Note that the -ck2 patchset does not modify file ip_conntrack.h.

The patch is trivial, so I'll add it manually for now, but it would be
nice to be able to apply/update it through this interface in the future.

Please add me to the cc, as I'm not subscribed to the list. Sorry for
the cross-post, but I wasn't sure about which list covers pom-ng/extra.

Thanks,
--=20
Javier Kohen <jkohen@users.sourceforge.net>
ICQ: blashyrkh #2361802
Jabber: jkohen@jabber.org

--=-oMvVNtegn7CQl2av2eWS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBCQyGJ823633cP2P8RAg23AJ9Q/Be6Ypzlxg5DmdHizgDU1jHLmQCeKb9F
FTrHaLXv0X7gh0iFH+YaoNE=
=/abR
-----END PGP SIGNATURE-----

--=-oMvVNtegn7CQl2av2eWS--
