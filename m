From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 6/7] test:chain:test json parsing support
Date: Wed, 31 Jul 2013 15:21:27 +0200
Message-ID: <20130731132127.29730.40714.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34062 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424Ab3GaNVb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:31 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so578355wgh.2
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:29 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Test the functions for parsing chains in JSON Support

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/jsonfiles/11-chain.json |    1 +
 tests/jsonfiles/12-chain.json |    1 +
 tests/jsonfiles/13-chain.json |    1 +
 tests/jsonfiles/14-chain.json |    1 +
 tests/nft-parsing-test.c      |    9 +++++++++
 5 files changed, 13 insertions(+)
 create mode 100644 tests/jsonfiles/11-chain.json
 create mode 100644 tests/jsonfiles/12-chain.json
 create mode 100644 tests/jsonfiles/13-chain.json
 create mode 100644 tests/jsonfiles/14-chain.json

diff --git a/tests/jsonfiles/11-chain.json b/tests/jsonfiles/11-chain.j=
son
new file mode 100644
index 0000000..0e71e8f
--- /dev/null
+++ b/tests/jsonfiles/11-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "input","handle": 1,"bytes": 1375696,"packets": 41=
36,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum"=
: "NF_INET_LOCAL_IN","prio": 0,"policy": "accept"}}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.j=
son
new file mode 100644
index 0000000..e841032
--- /dev/null
+++ b/tests/jsonfiles/12-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "forward","handle": 2,"bytes": 0,"packets": 0,"fam=
ily": "ip","table": "filter","use": 0,"type": "filter","hooknum": "NF_I=
NET_FORWARD","prio": 0,"policy": "accept"}}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.j=
son
new file mode 100644
index 0000000..9967233
--- /dev/null
+++ b/tests/jsonfiles/13-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "output","handle": 3,"bytes": 454786,"packets": 26=
81,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum"=
: "NF_INET_LOCAL_OUT","prio": 0,"policy": "accept"}}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.j=
son
new file mode 100644
index 0000000..716d022
--- /dev/null
+++ b/tests/jsonfiles/14-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "chain1","handle": 4,"bytes": 0,"packets": 0,"fami=
ly": "ip","table": "filter","use": 0}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 0734f07..e111fd0 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -24,6 +24,7 @@ static int test_json(const char *filename)
 #ifdef JSON_PARSING
 	int ret =3D -1;
 	struct nft_table *t =3D NULL;
+	struct nft_chain *c =3D NULL;
 	json_t *root;
 	json_error_t error;
 	char *json =3D NULL;
@@ -47,6 +48,14 @@ static int test_json(const char *filename)
=20
 			nft_table_free(t);
 		}
+	} else if (json_object_get(root, "chain") !=3D NULL) {
+		c =3D nft_chain_alloc();
+		if (c !=3D NULL) {
+			if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) =3D=3D 0)
+				ret =3D 0;
+
+			nft_chain_free(c);
+		}
 	}
=20
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
