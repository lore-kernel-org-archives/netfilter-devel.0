From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] destroy_conntrack optimization
Date: Thu, 2 Oct 2003 16:11:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002141145.GY5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C5aGuEsxcRHPKWPr"
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


--C5aGuEsxcRHPKWPr
Content-Type: multipart/mixed; boundary="FCrxImOsEPEtRSmI"
Content-Disposition: inline


--FCrxImOsEPEtRSmI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

sorry for the subject in my last email, I hit the send button too fast
:(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FCrxImOsEPEtRSmI
Content-Type: message/rfc822
Content-Disposition: inline

Date: Thu, 2 Oct 2003 16:10:20 +0200
From: Harald Welte <laforge@netfilter.org>
To: David Miller <davem@redhat.com>
Subject: [PATCH 2.4] asdf
Message-ID: <20031002141020.GX5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dim267wcQiuuzmQo"
Content-Disposition: inline
X-Operating-system: Linux sunbeam 2.6.0-test1-nftest
X-Date: Today is Boomtime, the 48th day of Bureaucracy in the YOLD 3169
User-Agent: Mutt/1.5.4i


--dim267wcQiuuzmQo
Content-Type: multipart/mixed; boundary="jzCe0ZdCKVpKQTM5"
Content-Disposition: inline


--jzCe0ZdCKVpKQTM5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.4 tree and push it to Marcelo.
Thanks.

Author: Patrick McHardy <kaber@trash.net>
Status: Submitted for kernel inclusion at 2.4.23-pre5 time

Don't call ip_conntrack_put with ip_conntrack_lock held

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jzCe0ZdCKVpKQTM5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="77_destroy-conntrack.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1136  -> 1.1137=20
#	net/ipv4/netfilter/ip_conntrack_core.c	1.26    -> 1.27  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1137
# [NETFILTER]: Don't call ip_conntrack_put with ip_conntrack_lock held
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 04:41:08 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 04:41:08 2003
@@ -308,7 +308,7 @@
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
-	struct ip_conntrack *ct =3D (struct ip_conntrack *)nfct;
+	struct ip_conntrack *ct =3D (struct ip_conntrack *)nfct, *master =3D NULL;
 	struct ip_conntrack_protocol *proto;
=20
 	DEBUGP("destroy_conntrack(%p)\n", ct);
@@ -335,11 +335,14 @@
 			/* can't call __unexpect_related here,
 			 * since it would screw up expect_list */
 			list_del(&ct->master->expected_list);
-			ip_conntrack_put(ct->master->expectant);
+			master =3D ct->master->expectant;
 		}
 		kfree(ct->master);
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	if (master)
+		ip_conntrack_put(master);
=20
 	DEBUGP("destroy_conntrack: returning ct=3D%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);

--jzCe0ZdCKVpKQTM5--

--dim267wcQiuuzmQo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDHMXaXGVTD0i/8RAoYCAJ9xLhVyTo5MSNSulz8SLrHwEbJwHQCeN3rZ
QzkLlEPG0VBhiN8Y2QY9KSs=
=SUnu
-----END PGP SIGNATURE-----

--dim267wcQiuuzmQo--

--FCrxImOsEPEtRSmI--

--C5aGuEsxcRHPKWPr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDIhXaXGVTD0i/8RAr3TAJ9COHXKrJLmv8jaWYNn2rBiHP5SrACdENwK
Qrc9K41fLesDi2PkCGw6g+I=
=stdj
-----END PGP SIGNATURE-----

--C5aGuEsxcRHPKWPr--
