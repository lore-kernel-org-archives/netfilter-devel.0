From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/6] table : tests: test the table json parser
 support
Date: Thu, 25 Jul 2013 22:52:24 +0200
Message-ID: <20130725205224.26223.16740.stgit@Ph0enix>
References: <20130725205215.26223.77001.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:53938 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYUw2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:52:28 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so1098870wev.8
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 13:52:27 -0700 (PDT)
In-Reply-To: <20130725205215.26223.77001.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Test the functions for parsing tables in JSON Support

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/Makefile.am             |    2 +-
 tests/jsonfiles/01-table.json |    1 +
 tests/jsonfiles/02-table.json |    1 +
 tests/nft-parsing-test.c      |   49 +++++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 tests/jsonfiles/01-table.json
 create mode 100644 tests/jsonfiles/02-table.json

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 6941c3c..cfa4e8e 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -3,4 +3,4 @@ include $(top_srcdir)/Make_global.am
 check_PROGRAMS =3D nft-parsing-test
=20
 nft_parsing_test_SOURCES =3D nft-parsing-test.c
-nft_parsing_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS} ${LIBX=
ML_LIBS}
+nft_parsing_test_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS} ${LIBX=
ML_LIBS} ${LIBJSON_LIBS}
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.j=
son
new file mode 100644
index 0000000..ec496b9
--- /dev/null
+++ b/tests/jsonfiles/01-table.json
@@ -0,0 +1 @@
+{"table" : {"name" : "filter","version" : 0,"properties" : {"family" :=
 "ip","table_flags" : 0}}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.j=
son
new file mode 100644
index 0000000..03f4d5a
--- /dev/null
+++ b/tests/jsonfiles/02-table.json
@@ -0,0 +1 @@
+{"table" : {"name" : "filter2","version" : 0,"properties" : {"family" =
: "ip6","table_flags" : 0}}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 4fe60c3..83a627c 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -14,6 +14,47 @@
 #include <mxml.h>
 #endif
=20
+#ifdef JSON_PARSING
+#include <jansson.h>
+#endif
+
+static int test_json(const char *filename)
+{
+#ifdef JSON_PARSING
+	int ret =3D -1;
+	struct nft_table *t =3D NULL;
+	json_t *root;
+	json_error_t error;
+	char *json =3D NULL;
+
+	root =3D json_load_file(filename, 0, &error);
+	if (!root) {
+		printf("Error on the line %d : %s", error.line, error.text);
+		return -1;
+	}
+
+	if (root =3D=3D NULL)
+		return -1;
+
+	json =3D json_dumps(root, JSON_INDENT(0));
+
+	if (json_object_get(root, "table") !=3D NULL) {
+		t =3D nft_table_alloc();
+		if (t !=3D NULL) {
+			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) =3D=3D 0)
+				ret =3D 0;
+
+			nft_table_free(t);
+		}
+	}
+
+	return ret;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int test_xml(const char *filename)
 {
 #ifdef XML_PARSING
@@ -104,6 +145,14 @@ int main(int argc, char *argv[])
 			else
 				printf("\033[32mOK\e[0m\n");
 		}
+		if (strcmp(&dent->d_name[len-5], ".json") =3D=3D 0) {
+			printf("parsing %s: ", path);
+			if (test_json(path) < 0)
+				printf("\033[31mFAILED\e[0m (%s)\n",
+					strerror(errno));
+			else
+				printf("\033[32mOK\e[0m\n");
+		}
 	}
=20
 	closedir(d);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
