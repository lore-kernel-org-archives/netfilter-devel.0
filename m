From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 8/14]: Fix expectation eviction order
Date: Mon, 21 Jun 2004 21:43:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194351.GN24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oYHLzUxHEKq3fcvW"
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


--oYHLzUxHEKq3fcvW
Content-Type: multipart/mixed; boundary="fCjW77bNSYaih4x3"
Content-Disposition: inline


--fCjW77bNSYaih4x3
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 fixes the order in which expectations are evicted
when a helper specifies IP_CT_HELPER_F_REUSE_EXPECT. Without this patch
expectations are evicted in LIFO order, this patch changes it to FIFO.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fCjW77bNSYaih4x3
Content-Type: text/plain; charset=us-ascii; name="08.diff"
Content-Disposition: inline; filename="08.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:44:52+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix expectation eviction order
#=20
# net/ipv4/netfilter/ip_nat_core.c
#   2004/06/20 22:44:43+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Fix expectation eviction order
#=20
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/06/20 22:44:43+02:00 kaber@trash.net +7 -16
#   [NETFILTER]: Fix expectation eviction order
#=20
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 23:00:32 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 23:00:32 +02:00
@@ -946,9 +946,8 @@
 	atomic_set(&new->use, 1);
=20
 	/* add to expected list for this connection */
-	list_add(&new->expected_list, &related_to->sibling_list);
+	list_add_tail(&new->expected_list, &related_to->sibling_list);
 	/* add to global list of expectations */
-
 	list_prepend(&ip_conntrack_expect_list, &new->list);
 	/* add and start timer if required */
 	if (related_to->helper->timeout) {
@@ -1002,7 +1001,6 @@
=20
 	} else if (related_to->helper->max_expected &&=20
 		   related_to->expecting >=3D related_to->helper->max_expected) {
-		struct list_head *cur_item;
 		/* old =3D=3D NULL */
 		if (!(related_to->helper->flags &=20
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
@@ -1028,21 +1026,14 @@
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
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_co=
re.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 23:00:32 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 23:00:32 +02:00
@@ -817,7 +817,7 @@
=20
 		/* Have to grab read lock before sibling_list traversal */
 		READ_LOCK(&ip_conntrack_lock);
-		list_for_each(cur_item, &ct->sibling_list) {=20
+		list_for_each_prev(cur_item, &ct->sibling_list) {=20
 			exp =3D list_entry(cur_item, struct ip_conntrack_expect,=20
 					 expected_list);
 					=20


--fCjW77bNSYaih4x3--

--oYHLzUxHEKq3fcvW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zp3XaXGVTD0i/8RAiQVAJ4r41fav/mvTYUXYy6CjxXs42PedgCgoXv7
wxO0A0mLvRMzoFWPUmNe95U=
=Z6wH
-----END PGP SIGNATURE-----

--oYHLzUxHEKq3fcvW--
