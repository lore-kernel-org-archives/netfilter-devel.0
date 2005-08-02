From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2/6] Fix locking during ctnetlink_new_conntrack()
Date: Tue, 2 Aug 2005 12:56:07 +0200
Message-ID: <20050802105607.GI4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PWfwoUCx3AFJRUBq"
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


--PWfwoUCx3AFJRUBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] conntrack_netlink: Fix locking during conntrack_create

The current codepath allowed for ip_conntrack_lock to be unlock'ed twice.

Signed-off-by: Pablo Neira <pablo@eurodev.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 0432a984f1e502d036115b1f25da8675ee9cebc4
tree aeb9371bcc39ed9c0d005d7959680a7f92a8f8bd
parent c4e2485887523a16e9c37a21a1d95ac10633ef0a
author Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 09:38:31 +0200
committer Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 09:38:31 +02=
00

 net/ipv4/netfilter/ip_conntrack_netlink.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1052,13 +1052,14 @@ ctnetlink_new_conntrack(struct sock *ctn
 		err =3D -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err =3D ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+		return err;
+	}
+	/* implicit 'else' */
+
+	/* we only allow nat config for new conntracks */
+	if (cda[CTA_NAT-1]) {
+		err =3D -EINVAL;
 		goto out_unlock;
-	} else {
-		/* we only allow nat config for new conntracks */
-		if (cda[CTA_NAT-1]) {
-			err =3D -EINVAL;
-			goto out_unlock;
-		}
 	}
=20
 	/* We manipulate the conntrack inside the global conntrack table lock,
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PWfwoUCx3AFJRUBq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC71FHXaXGVTD0i/8RAq76AJ9UDBzbQKI4eAoJu02uN+GpX0sPRwCglAb3
DBYv1lUPWoG8Af+58vNm1/M=
=Mju/
-----END PGP SIGNATURE-----

--PWfwoUCx3AFJRUBq--
