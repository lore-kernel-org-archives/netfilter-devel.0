From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 10/14]: Relax hook check in ipt_CLASSIFY
Date: Mon, 21 Jun 2004 21:44:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194428.GP24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvtG/WQWmfqkB9kQ"
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


--tvtG/WQWmfqkB9kQ
Content-Type: multipart/mixed; boundary="+qS3mlFlwl/01Z8q"
Content-Disposition: inline


--+qS3mlFlwl/01Z8q
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch for 2.6 removes the unneccessary restriction to POST_ROUTING
=66rom ipt_CLASSIFY. In 2.6, skb->priority is set before any of LOCAL_OUT,
FORWARD and POST_ROUTING are hit, so we can remove this restriction.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+qS3mlFlwl/01Z8q
Content-Type: text/plain; charset=us-ascii; name="10.diff"
Content-Disposition: inline; filename="10.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:46:05+02:00 kaber@trash.net=20
#   [NETFILTER]: Relax hook check in ipt_CLASSIFY
#=20
# net/ipv4/netfilter/ipt_CLASSIFY.c
#   2004/06/20 22:45:56+02:00 kaber@trash.net +7 -5
#   [NETFILTER]: Relax hook check in ipt_CLASSIFY
#=20
diff -Nru a/net/ipv4/netfilter/ipt_CLASSIFY.c b/net/ipv4/netfilter/ipt_CLAS=
SIFY.c
--- a/net/ipv4/netfilter/ipt_CLASSIFY.c	2004-06-20 23:00:52 +02:00
+++ b/net/ipv4/netfilter/ipt_CLASSIFY.c	2004-06-20 23:00:52 +02:00
@@ -54,15 +54,17 @@
 		return 0;
 	}
 =09
-	if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
-		printk(KERN_ERR "CLASSIFY: only valid in POST_ROUTING.\n");
+	if (hook_mask & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
+	                  (1 << NF_IP_POST_ROUTING))) {
+		printk(KERN_ERR "CLASSIFY: only valid in LOCAL_OUT, FORWARD "
+		                "and POST_ROUTING.\n");
 		return 0;
 	}
=20
 	if (strcmp(tablename, "mangle") !=3D 0) {
-		printk(KERN_WARNING "CLASSIFY: can only be called from "
-		                    "\"mangle\" table, not \"%s\".\n",
-		                    tablename);
+		printk(KERN_ERR "CLASSIFY: can only be called from "
+		                "\"mangle\" table, not \"%s\".\n",
+		                tablename);
 		return 0;
 	}
=20


--+qS3mlFlwl/01Z8q--

--tvtG/WQWmfqkB9kQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zqcXaXGVTD0i/8RAsXNAJ9XreTv8cCvIKkfp0eMqbm09r85zACgjgOb
SZDXEqh61kw4UELYNuVJl18=
=qMBo
-----END PGP SIGNATURE-----

--tvtG/WQWmfqkB9kQ--
