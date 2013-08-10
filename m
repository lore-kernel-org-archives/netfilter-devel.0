From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] test: compare content parsing with original
 file content.
Date: Sat, 10 Aug 2013 21:40:51 +0200
Message-ID: <20130810194051.18629.33864.stgit@Ph0enix>
References: <20130810194039.18629.89549.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62409 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3HJTlB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:41:01 -0400
Received: by mail-wg0-f42.google.com with SMTP id j13so622286wgh.1
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Aug 2013 12:41:00 -0700 (PDT)
In-Reply-To: <20130810194039.18629.89549.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Before, we have tested only if we have parsed some file but we hadn't t=
ested if the content is OK.
Now, we can test if we can parse some file and if the object's info is =
the same than the content
in the test files.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/nft-parsing-test.c |  186 ++++++++++++++++++++++++++++++++++++++=
++++----
 1 file changed, 170 insertions(+), 16 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index e111fd0..f9cfcdf 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -19,6 +19,138 @@
 #include <jansson.h>
 #endif
=20
+enum {
+	TEST_XML_TABLE =3D 0,
+	TEST_XML_CHAIN,
+	TEST_XML_RULE,
+	TEST_XML_SET,
+	TEST_JSON_TABLE,
+	TEST_JSON_CHAIN,
+	TEST_JSON_RULE,
+	TEST_JSON_SET,
+};
+
+#if defined(XML_PARSING) || defined(JSON_PARSING)
+static void print_detail_error(char *a, char *b)
+{
+	int i;
+	int from =3D -1;
+
+	for (i =3D 0; i < strlen(b); i++) {
+		if (from =3D=3D -1 && a[i] !=3D b[i]) {
+			from =3D i;
+			break;
+
+		}
+	}
+
+	if (from !=3D -1) {
+		int k =3D from - 10;
+
+		if (k < 0)
+			k =3D 0;
+
+		fprintf(stderr, "from file:     ");
+		for (i =3D k; i < from + 10; i++)
+			fprintf(stderr, "%c", a[i]);
+
+		fprintf(stderr, "\nfrom snprintf: ");
+		for (i =3D k; i < from + 10; i++)
+			fprintf(stderr, "%c", b[i]);
+
+		/* Don't look twice below this comment ;-) */
+		fprintf(stderr, "\n               ");
+		for (i =3D k; i < from + 10; i++) {
+			if (i =3D=3D from)
+				fprintf(stderr, "^");
+			else
+				fprintf(stderr, " ");
+		}
+		fprintf(stderr, "\n");
+	}
+}
+
+static int compare_test(uint32_t type, void *input, const char *filena=
me)
+{
+	struct nft_table *t =3D NULL;
+	struct nft_chain *c =3D NULL;
+	struct nft_rule *r =3D NULL;
+	struct nft_set *s =3D NULL;
+	char orig[4096];
+	char out[4096];
+	FILE *fp;
+
+	switch (type) {
+	case TEST_XML_TABLE:
+	case TEST_JSON_TABLE:
+		t =3D (struct nft_table *)input;
+		break;
+	case TEST_XML_CHAIN:
+	case TEST_JSON_CHAIN:
+		c =3D (struct nft_chain *)input;
+		break;
+	case TEST_XML_RULE:
+	case TEST_JSON_RULE:
+		r =3D (struct nft_rule *)input;
+		break;
+	case TEST_XML_SET:
+	case TEST_JSON_SET:
+		s =3D (struct nft_set *)input;
+		break;
+	default:
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	switch (type) {
+	case TEST_XML_TABLE:
+		nft_table_snprintf(out, sizeof(out), t, NFT_TABLE_O_XML, 0);
+		break;
+	case TEST_JSON_TABLE:
+		nft_table_snprintf(out, sizeof(out), t, NFT_TABLE_O_JSON, 0);
+		break;
+	case TEST_XML_CHAIN:
+		nft_chain_snprintf(out, sizeof(out), c, NFT_CHAIN_O_XML, 0);
+		break;
+	case TEST_JSON_CHAIN:
+		nft_chain_snprintf(out, sizeof(out), c, NFT_CHAIN_O_JSON, 0);
+		break;
+	case TEST_XML_RULE:
+		nft_rule_snprintf(out, sizeof(out), r, NFT_RULE_O_XML, 0);
+		break;
+	case TEST_JSON_RULE:
+		nft_rule_snprintf(out, sizeof(out), r, NFT_RULE_O_JSON, 0);
+		break;
+	case TEST_XML_SET:
+		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_XML, 0);
+		break;
+	case TEST_JSON_SET:
+		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_JSON, 0);
+		break;
+	default:
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	fp =3D fopen(filename, "r");
+	if (fp =3D=3D NULL) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	fgets(orig, sizeof(orig), fp);
+	fclose(fp);
+
+	if (strncmp(orig, out, strlen(out)) =3D=3D 0)
+		return 0;
+
+	printf("matching %s: ", filename);
+	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	print_detail_error(orig, out);
+	return -1;
+}
+#endif
+
 static int test_json(const char *filename)
 {
 #ifdef JSON_PARSING
@@ -44,7 +176,9 @@ static int test_json(const char *filename)
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
 			if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_JSON_TABLE, t, filename);
+			else
+				goto failparsing;
=20
 			nft_table_free(t);
 		}
@@ -52,13 +186,23 @@ static int test_json(const char *filename)
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
 			if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_JSON_CHAIN, c, filename);
+			else
+				goto failparsing;
=20
 			nft_chain_free(c);
 		}
 	}
=20
+	free(root);
 	return ret;
+
+failparsing:
+	printf("parsing %s: ", filename);
+	printf("\033[31mFAILED\e[0m (%s)\n",
+	strerror(errno));
+	free(root);
+	return -1;
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -93,7 +237,9 @@ static int test_xml(const char *filename)
 		t =3D nft_table_alloc();
 		if (t !=3D NULL) {
 			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_XML_TABLE, t, filename);
+			else
+				goto failparsing;
=20
 			nft_table_free(t);
 		}
@@ -101,7 +247,9 @@ static int test_xml(const char *filename)
 		c =3D nft_chain_alloc();
 		if (c !=3D NULL) {
 			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_XML_CHAIN, c, filename);
+			else
+				goto failparsing;
=20
 			nft_chain_free(c);
 		}
@@ -109,7 +257,9 @@ static int test_xml(const char *filename)
 		r =3D nft_rule_alloc();
 		if (r !=3D NULL) {
 			if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_XML_RULE, r, filename);
+			else
+				goto failparsing;
=20
 			nft_rule_free(r);
 		}
@@ -117,13 +267,21 @@ static int test_xml(const char *filename)
 		s =3D nft_set_alloc();
 		if (s !=3D NULL) {
 			if (nft_set_parse(s, NFT_SET_PARSE_XML, xml) =3D=3D 0)
-				ret =3D 0;
+				ret =3D compare_test(TEST_XML_SET, s, filename);
+			else
+				goto failparsing;
=20
 			nft_set_free(s);
 		}
 	}
=20
 	return ret;
+
+failparsing:
+	printf("parsing %s: ", filename);
+	printf("\033[31mFAILED\e[0m (%s)\n",
+	strerror(errno));
+	return -1;
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;
@@ -157,20 +315,16 @@ int main(int argc, char *argv[])
 		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
=20
 		if (strcmp(&dent->d_name[len-4], ".xml") =3D=3D 0) {
-			printf("parsing %s: ", path);
-			if (test_xml(path) < 0)
-				printf("\033[31mFAILED\e[0m (%s)\n",
-					strerror(errno));
-			else
+			if (test_xml(path) =3D=3D 0) {
+				printf("parsing and matching %s: ", path);
 				printf("\033[32mOK\e[0m\n");
+			}
 		}
 		if (strcmp(&dent->d_name[len-5], ".json") =3D=3D 0) {
-			printf("parsing %s: ", path);
-			if (test_json(path) < 0)
-				printf("\033[31mFAILED\e[0m (%s)\n",
-					strerror(errno));
-			else
+			if (test_json(path) =3D=3D 0) {
+				printf("parsing and matching %s: ", path);
 				printf("\033[32mOK\e[0m\n");
+			}
 		}
 	}
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
