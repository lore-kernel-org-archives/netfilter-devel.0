From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] meta: relax restriction on UID/GID parsing
Date: Fri, 29 Nov 2013 11:31:56 +0100
Message-ID: <1385721116-5910-2-git-send-email-pablo@netfilter.org>
References: <1385721116-5910-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Bj=C3=B8rnar=20Ness?= <bjornar.ness@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59317 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab3K2KcK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:32:10 -0500
In-Reply-To: <1385721116-5910-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft is currently rejecting unknown UID/GID if they don't exist in the
system, relax this as Bj=C3=B8rnar Ness considers this is a valid scena=
rio.
Now this only reports an error if you pass an unknown user (expressed a=
s
string or if the UID/GID goes above 32 bits).

Reported-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c |   54 ++++++++++++++++++++++++++++++++++------------------=
--
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 80c2638..32f3012 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -197,11 +197,14 @@ static void uid_type_print(const struct expr *exp=
r)
 	struct passwd *pw;
=20
 	if (numeric_output < NUMERIC_ALL) {
-		pw =3D getpwuid(mpz_get_uint32(expr->value));
-		if (pw !=3D NULL) {
+		uint32_t uid =3D mpz_get_uint32(expr->value);
+
+		pw =3D getpwuid(uid);
+		if (pw !=3D NULL)
 			printf("%s", pw->pw_name);
-			return;
-		}
+		else
+			printf("%d", uid);
+		return;
 	}
 	expr_basetype(expr)->print(expr);
 }
@@ -210,19 +213,23 @@ static struct error_record *uid_type_parse(const =
struct expr *sym,
 					   struct expr **res)
 {
 	struct passwd *pw;
+	uint64_t uid;
+	char *endptr =3D NULL;
=20
 	pw =3D getpwnam(sym->identifier);
-	if (pw =3D=3D NULL) {
-		/* Try harder, lookup based on UID */
-		pw =3D getpwuid(atol(sym->identifier));
-		if (pw =3D=3D NULL)
+	if (pw !=3D NULL)
+		uid =3D pw->pw_uid;
+	else {
+		uid =3D strtoull(sym->identifier, &endptr, 10);
+		if (uid > UINT32_MAX)
+			return error(&sym->location, "Value too large");
+		else if (*endptr)
 			return error(&sym->location, "User does not exist");
 	}
=20
 	*res =3D constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
-				   sizeof(pw->pw_uid) * BITS_PER_BYTE,
-				   &pw->pw_uid);
+				   sizeof(pw->pw_uid) * BITS_PER_BYTE, &uid);
 	return NULL;
 }
=20
@@ -242,11 +249,14 @@ static void gid_type_print(const struct expr *exp=
r)
 	struct group *gr;
=20
 	if (numeric_output < NUMERIC_ALL) {
-		gr =3D getgrgid(mpz_get_uint32(expr->value));
-		if (gr !=3D NULL) {
+		uint32_t gid =3D mpz_get_uint32(expr->value);
+
+		gr =3D getgrgid(gid);
+		if (gr !=3D NULL)
 			printf("%s", gr->gr_name);
-			return;
-		}
+		else
+			printf("%u", gid);
+		return;
 	}
 	expr_basetype(expr)->print(expr);
 }
@@ -255,19 +265,23 @@ static struct error_record *gid_type_parse(const =
struct expr *sym,
 					   struct expr **res)
 {
 	struct group *gr;
+	uint64_t gid;
+	char *endptr =3D NULL;
=20
 	gr =3D getgrnam(sym->identifier);
-	if (gr =3D=3D NULL) {
-		/* Try harder, lookup based on GID */
-		gr =3D getgrgid(atol(sym->identifier));
-		if (gr =3D=3D NULL)
+	if (gr !=3D NULL)
+		gid =3D gr->gr_gid;
+	else {
+		gid =3D strtoull(sym->identifier, &endptr, 0);
+		if (gid > UINT32_MAX)
+			return error(&sym->location, "Value too large");
+		else if (*endptr)
 			return error(&sym->location, "Group does not exist");
 	}
=20
 	*res =3D constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
-				   sizeof(gr->gr_gid) * BITS_PER_BYTE,
-				   &gr->gr_gid);
+				   sizeof(gr->gr_gid) * BITS_PER_BYTE, &gid);
 	return NULL;
 }
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
