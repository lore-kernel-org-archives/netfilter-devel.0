From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 3/4] tests: set: add json parsing support
Date: Tue, 27 Aug 2013 20:10:55 +0200
Message-ID: <20130827181055.9399.10176.stgit@Ph0enix>
References: <20130827181037.9399.30579.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48623 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3H0SLR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:11:17 -0400
Received: by mail-wi0-f169.google.com with SMTP id l12so5773662wiv.4
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 11:11:16 -0700 (PDT)
In-Reply-To: <20130827181037.9399.30579.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Test the functions for parsing set in JSON.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/jsonfiles/62-set.json |    1 +
 tests/jsonfiles/63-set.json |    1 +
 tests/nft-parsing-test.c    |   11 +++++++++++
 3 files changed, 13 insertions(+)
 create mode 100644 tests/jsonfiles/62-set.json
 create mode 100644 tests/jsonfiles/63-set.json

diff --git a/tests/jsonfiles/62-set.json b/tests/jsonfiles/62-set.json
new file mode 100644
index 0000000..c5200eb
--- /dev/null
+++ b/tests/jsonfiles/62-set.json
@@ -0,0 +1 @@
+{ "set": { "name": "set0","table": "filter","flags": 3,"family": "ip",=
"key_type": 12,"key_len": 2,"set_elem": [{"flags": 0,"key": {"data_reg"=
: { "type" : "value", "len" : 2, "data0" : "0x00001700"}}}, {"flags": 0=
,"key": {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x000016=
00"}}}]}}
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
new file mode 100644
index 0000000..be3e564
--- /dev/null
+++ b/tests/jsonfiles/63-set.json
@@ -0,0 +1 @@
+{ "set": { "name": "map0","table": "filter","flags": 11,"family": "ip"=
,"key_type": 12,"key_len": 2,"data_type": 4294967040,"data_len": 16,"se=
t_elem": [{"flags": 0,"key": {"data_reg": { "type" : "value", "len" : 2=
, "data0" : "0x00001700"}},"data": {"data_reg": { "type" : "chain", "ch=
ain" : "forward"}}}, {"flags": 0,"key": {"data_reg": { "type" : "value"=
, "len" : 2, "data0" : "0x00001600"}},"data": {"data_reg": { "type" : "=
chain", "chain" : "chain1"}}}]}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 648ed36..ecde0e2 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -158,6 +158,7 @@ static int test_json(const char *filename)
 	struct nft_table *t;
 	struct nft_chain *c;
 	struct nft_rule *r;
+	struct nft_set *s;
 	json_t *root;
 	json_error_t error;
 	char *json;
@@ -200,6 +201,16 @@ static int test_json(const char *filename)
=20
 			nft_rule_free(r);
 		}
+	} else if (json_object_get(root, "set") !=3D NULL) {
+		s =3D nft_set_alloc();
+		if (s !=3D NULL) {
+			if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) =3D=3D 0)
+				ret =3D compare_test(TEST_JSON_SET, s, filename);
+			else
+				goto failparsing;
+
+			nft_set_free(s);
+			}
 	}
=20
 	free(json);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
