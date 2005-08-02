From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 3/6] Fix ctnetlink_create_expect() mask parsing
Date: Tue, 2 Aug 2005 12:57:02 +0200
Message-ID: <20050802105702.GJ4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Cc: Linux Netdev List <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] fix ctnetlink 'create_expect' parsing

There was a stupid copy+paste mistake where we parse the MASK nfattr into
the "tuple" variable instead of the "mask" variable.  This patch fixes it.
Thanks to Pablo Neira.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 5d03469be285d9bc2b82861d87c667cf5614132d
tree f5551e270c07504ca3f7e234504a3fa2ea6f6728
parent 1f7c0373f4ab32a46ffdee952238b2a596119cb0
author Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 11:51:56 +0200
committer Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 11:51:56 +02=
00

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1388,7 +1388,7 @@ ctnetlink_create_expect(struct nfattr *c
 	err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
 	if (err < 0)
 		return err;
-	err =3D ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASK);
+	err =3D ctnetlink_parse_tuple(cda, &mask, CTA_EXPECT_MASK);
 	if (err < 0)
 		return err;
=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC71F9XaXGVTD0i/8RAiy2AJ9byymA50FvP7YqN4YxtIL06GvArgCfanWw
EwzklQuovGW24faAqwU0h3Q=
=0eF4
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
