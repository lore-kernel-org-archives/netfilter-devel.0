From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Missing free on error in iptables 1.3.4
Date: Sat, 12 Nov 2005 11:28:47 +0100
Message-ID: <20051112102847.GD10584@sunbeam.de.gnumonks.org>
References: <4372127A.7040307@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/0ZNML3L+nUf91nU"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <4372127A.7040307@ingate.com>
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


--/0ZNML3L+nUf91nU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 09, 2005 at 04:15:06PM +0100, Marcus Sundberg wrote:
> Hi,
>=20
> the patch below fixes a missing free() statement in TC_COMMIT(),
> and moves the setting of errno to come right before the return.

thanks, I'm fixing this in a more general cleanup of the function error
path (see patch below)


Index: libiptc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- libiptc.c	(revision 4510)
+++ libiptc.c	(working copy)
@@ -2034,13 +2034,13 @@
 	new_number =3D iptcc_compile_table_prep(*handle, &new_size);
 	if (new_number < 0) {
 		errno =3D ENOMEM;
-		return 0;
+		goto out_zero;
 	}
=20
 	repl =3D malloc(sizeof(*repl) + new_size);
 	if (!repl) {
 		errno =3D ENOMEM;
-		return 0;
+		goto out_zero;
 	}
 	memset(repl, 0, sizeof(*repl) + new_size);
=20
@@ -2055,17 +2055,14 @@
 	repl->counters =3D malloc(sizeof(STRUCT_COUNTERS)
 				* (*handle)->info.num_entries);
 	if (!repl->counters) {
-		free(repl);
 		errno =3D ENOMEM;
-		return 0;
+		goto out_free_repl;
 	}
 	/* These are the counters we're going to put back, later. */
 	newcounters =3D malloc(counterlen);
 	if (!newcounters) {
-		free(repl->counters);
-		free(repl);
 		errno =3D ENOMEM;
-		return 0;
+		goto out_free_repl_counters;
 	}
 	memset(newcounters, 0, counterlen);
=20
@@ -2082,9 +2079,7 @@
 	ret =3D iptcc_compile_table(*handle, repl);
 	if (ret < 0) {
 		errno =3D ret;
-		free(repl->counters);
-		free(repl);
-		return 0;
+		goto out_free_newcounters;
 	}
=20
=20
@@ -2099,12 +2094,11 @@
 	}
 #endif
=20
-	if (setsockopt(sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
-		       sizeof(*repl) + repl->size) < 0) {
-		free(repl->counters);
-		free(repl);
-		free(newcounters);
-		return 0;
+	ret =3D setsockopt(sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
+			 sizeof(*repl) + repl->size);
+	if (ret < 0) {
+		errno =3D ret;
+		goto out_free_newcounters;
 	}
=20
 	/* Put counters back. */
@@ -2194,21 +2188,29 @@
 	}
 #endif
=20
-	if (setsockopt(sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
-		       newcounters, counterlen) < 0) {
-		free(repl->counters);
-		free(repl);
-		free(newcounters);
-		return 0;
+	ret =3D setsockopt(sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
+			 newcounters, counterlen);
+	if (ret < 0) {
+		errno =3D ret;
+		goto out_free_newcounters;
 	}
=20
 	free(repl->counters);
 	free(repl);
 	free(newcounters);
=20
- finished:
+finished:
 	TC_FREE(handle);
 	return 1;
+
+out_free_newcounters:
+	free(newcounters);
+out_free_repl_counters:
+	free(repl->counters);
+out_free_repl:
+	free(repl);
+out_zero:
+	return 0;
 }
=20
 /* Get raw socket. */
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/0ZNML3L+nUf91nU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdcPeXaXGVTD0i/8RAoodAKCFTff3r3w9CxMIrM/e7su4eFE1nQCfYa6v
klwJZ5yCAbd/08MhK7q2imI=
=/Us1
-----END PGP SIGNATURE-----

--/0ZNML3L+nUf91nU--
