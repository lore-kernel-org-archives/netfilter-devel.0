From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 1/4] tests: conntrack: run testfiles in the correct order
Date: Mon, 25 Jan 2016 10:40:27 +0000
Message-ID: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:56851 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbcAYKlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 05:41:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use scandir(3) instead of opendir(3), so that the tests are
run in the expected order, otherwise it doesn't make
sense to prefix the testfiles with a two digit number,
giving the impression that they are run in order.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 tests/conntrack/test-conntrack.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-co=
nntrack.c
index c9097b6..8f1cea0 100644
--- a/tests/conntrack/test-conntrack.c
+++ b/tests/conntrack/test-conntrack.c
@@ -23,14 +23,16 @@ int main()
 {
 	int ret, ok =3D 0, bad =3D 0, line;
 	FILE *fp;
-	DIR *d;
 	char buf[1024];
+	struct dirent **dents;
 	struct dirent *dent;
 	char file[1024];
+	int i,n;
=20
-	d =3D opendir("testsuite");
+	n =3D scandir("testsuite", &dents, NULL, alphasort);
=20
-	while ((dent =3D readdir(d)) !=3D NULL) {
+	for (i=3D0;i<n;i++) {
+		dent =3D dents[i];
=20
 		sprintf(file, "testsuite/%s", dent->d_name);
=20
@@ -88,7 +90,11 @@ int main()
 		}
 		fclose(fp);
 	}
-	closedir(d);
+
+	for (i=3D0;i<n;i++) {
+		free(dents[i]);
+	}
+	free(dents);
=20
 	fprintf(stdout, "OK: %d BAD: %d\n", ok, bad);
 }
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
