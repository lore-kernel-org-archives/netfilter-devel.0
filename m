From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] Fix locking in ip_conntrack_change_expect()
Date: Mon, 14 Oct 2002 13:40:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014134047.R13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0RrwLCq8kVvUIgaI"
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


--0RrwLCq8kVvUIgaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again, Dave!

Below is an important bugfix for netfilter (by Martin Josefsson).

In ip_conntrack_change_expect() we were at least need to grab a readlock
before comparing the tuple/mask of an ip_conntrack_expect.

Pleae note that the bug was introduced in early 2.4.20-pre time, as newnat
was merged.  So there's no need to worry about old (stable) kernel releases.

Please apply the following fix, Thanks.

- Harald

--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c.mjufs	2002-10=
-12 15:23:22.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-12 15=
:23:00.000000000 +0200
@@ -1060,7 +1060,10 @@
 int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 			       struct ip_conntrack_tuple *newtuple)
 {
+	int ret;
+
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
=20
 	DEBUGP("change_expect:\n");
 	DEBUGP("exp tuple: "); DUMP_TUPLE(&expect->tuple);
@@ -1073,26 +1076,25 @@
 		    && LIST_FIND(&ip_conntrack_expect_list, expect_clash,
 			         struct ip_conntrack_expect *, newtuple, &expect->mask)) {
 			/* Force NAT to find an unused tuple */
-			return -1;
+			ret =3D -1;
 		} else {
-			WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
 			memcpy(&expect->ct_tuple, &expect->tuple, sizeof(expect->tuple));
 			memcpy(&expect->tuple, newtuple, sizeof(expect->tuple));
-			WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
-			return 0;
+			ret =3D 0;
 		}
 	} else {
 		/* Resent packet */
 		DEBUGP("change expect: resent packet\n");
 		if (ip_ct_tuple_equal(&expect->tuple, newtuple)) {
-			return 0;
+			ret =3D 0;
 		} else {
 			/* Force NAT to choose again the same port */
-			return -1;
+			ret =3D -1;
 		}
 	}
+	WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
 =09
-	return -1;
+	return ret;
 }
=20
 /* Alter reply tuple (maybe alter helper).  If it's already taken,
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--0RrwLCq8kVvUIgaI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qq0+XaXGVTD0i/8RAg1cAJ9vkBDUlJCQyfopWHmmtA7ZuVrEJACbBOAw
XUT6N3FyHghHTGB0aorg5Rk=
=d6EW
-----END PGP SIGNATURE-----

--0RrwLCq8kVvUIgaI--
