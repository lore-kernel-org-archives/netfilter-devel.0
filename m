From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: fix expectation evict order
Date: Sun, 30 Nov 2003 21:01:52 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130153152.GE26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the fourth netfilter patch, please apply.

Author: Patrick McHardy <kaber@trash.net>

This patch fixes the order in whcih expectations are evicted when a helper
specifies IP_CT_HELPER_F_REUSE_EXPECT.  Prior to that patch, each new
expectation is added at the beginning of the masters sibling list.  When
max_expected is reached, the first non-established one on the list is reused
(which gave LIFO behaviour).

The patch
- adds new expectations at the end of the masters sibling list
- uses list_for_each_entry for finding the oldes one
- changes nat core to walk backwards throuth the sibling list when calling
  nat helpers

diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:01:46 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:01:46 2003
@@ -972,7 +972,6 @@
 		}
 	} else if (related_to->helper->max_expected &&=20
 		   related_to->expecting >=3D related_to->helper->max_expected) {
-		struct list_head *cur_item;
 		/* old =3D=3D NULL */
 		if (!(related_to->helper->flags &=20
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
@@ -997,21 +996,14 @@
 		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
 =20
 		/* choose the the oldest expectation to evict */
-		list_for_each(cur_item, &related_to->sibling_list) {=20
-			struct ip_conntrack_expect *cur;
-
-			cur =3D list_entry(cur_item,=20
-					 struct ip_conntrack_expect,
-					 expected_list);
-			if (cur->sibling =3D=3D NULL) {
-				old =3D cur;
+		list_for_each_entry(old, &related_to->sibling_list,=20
+		                                      expected_list)
+			if (old->sibling =3D=3D NULL)
 				break;
-			}
-		}
=20
-		/* (!old) cannot happen, since related_to->expecting is the
-		 * number of unconfirmed expects */
-		IP_NF_ASSERT(old);
+		/* We cannot fail since related_to->expecting is the number
+		 * of unconfirmed expectations */
+		IP_NF_ASSERT(old && old->sibling =3D=3D NULL);
=20
 		/* newnat14 does not reuse the real allocated memory
 		 * structures but rather unexpects the old and
@@ -1043,7 +1035,7 @@
 	atomic_set(&new->use, 1);
 =09
 	/* add to expected list for this connection */=09
-	list_add(&new->expected_list, &related_to->sibling_list);
+	list_add_tail(&new->expected_list, &related_to->sibling_list);
 	/* add to global list of expectations */
 	list_prepend(&ip_conntrack_expect_list, &new->list);
 	/* add and start timer if required */
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_co=
re.c
--- a/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:01:46 2003
+++ b/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:01:46 2003
@@ -810,7 +810,7 @@
=20
 		/* Have to grab read lock before sibling_list traversal */
 		READ_LOCK(&ip_conntrack_lock);
-		list_for_each(cur_item, &ct->sibling_list) {=20
+		list_for_each_prev(cur_item, &ct->sibling_list) {=20
 			exp =3D list_entry(cur_item, struct ip_conntrack_expect,=20
 					 expected_list);
 					=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yg1+XaXGVTD0i/8RAkp7AKCjPFsAXOBCh1RgswO2Ng/x3/2klACcCzBq
bFjlu0qpLPvpc9zfSQFzznM=
=R1P+
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
