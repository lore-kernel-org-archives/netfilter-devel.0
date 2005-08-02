From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 5/6] cleanup nfnetlink_check_attributes()
Date: Tue, 2 Aug 2005 12:58:31 +0200
Message-ID: <20050802105831.GL4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
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


--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] cleanup nfnetlink_check_attributes()

1) memset return parameter 'cda' (nfattr pointer array) only on success
2) a message without attributes and just a 'struct nfgenmsg' is valid,
   don't return -EINVAL
3) use likely() and unlikely() where apropriate

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 2f6e0aaca19a462e324ed78f01dfa06e36d73054
tree a0a8b02e5bf16da87d816baad7650151c355126e
parent 9ae30513b70ed5325f66adc02788a7d6ef69cb1e
author Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:24:48 +0200
committer Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:24:48 +02=
00

 net/netfilter/nfnetlink.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -163,17 +163,16 @@ nfnetlink_check_attributes(struct nfnetl
 			cb_id, subsys->cb_count);
 		return -EINVAL;
 	}
-=09
-	attr_count =3D subsys->cb[cb_id].attr_count;
-
-	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
=20
-	/* check attribute lengths. */
 	min_len =3D NLMSG_ALIGN(sizeof(struct nfgenmsg));
-	if (nlh->nlmsg_len < min_len)
+	if (unlikely(nlh->nlmsg_len < min_len))
 		return -EINVAL;
=20
-	if (nlh->nlmsg_len > min_len) {
+	attr_count =3D subsys->cb[cb_id].attr_count;
+	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
+
+	/* check attribute lengths. */
+	if (likely(nlh->nlmsg_len > min_len)) {
 		struct nfattr *attr =3D NFM_NFA(NLMSG_DATA(nlh));
 		int attrlen =3D nlh->nlmsg_len - NLMSG_ALIGN(min_len);
=20
@@ -186,8 +185,10 @@ nfnetlink_check_attributes(struct nfnetl
 			}
 			attr =3D NFA_NEXT(attr, attrlen);
 		}
-	} else
-		return -EINVAL;
+	}
+
+	/* implicit: if nlmsg_len =3D=3D min_len, we return 0, and an empty
+	 * (zeroed) cda[] array. The message is valid, but empty. */
=20
         return 0;
 }
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFC71HXXaXGVTD0i/8RAm1zAJY00FcQAOKVEyfjnS3aYtgIJLsEAJ9s0izj
l51pu73lLcCZUxH5yPWRLQ==
=13J5
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
