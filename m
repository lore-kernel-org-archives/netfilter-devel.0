From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 5/6] chain: test: test the chain parser support
Date: Thu, 25 Jul 2013 22:52:47 +0200
Message-ID: <20130725205247.26223.37905.stgit@Ph0enix>
References: <20130725205215.26223.77001.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58018 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3GYUwv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:52:51 -0400
Received: by mail-wi0-f171.google.com with SMTP id hj3so81163wib.10
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 13:52:50 -0700 (PDT)
In-Reply-To: <20130725205215.26223.77001.stgit@Ph0enix>
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
index 0000000..9b716f2
--- /dev/null
+++ b/tests/jsonfiles/11-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "input","handle": 1,"bytes": 2238649,"packets": 14=
177,"version": 0,"properties": {"family": "ip","table": "filter","use":=
 0,"type": "filter","hooknum": "NF_INET_LOCAL_IN","prio": 0,"policy": "=
accept"}}}
diff --git a/tests/jsonfiles/12-chain.json b/tests/jsonfiles/12-chain.j=
son
new file mode 100644
index 0000000..0af8588
--- /dev/null
+++ b/tests/jsonfiles/12-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "forward","handle": 2,"bytes": 0,"packets": 0,"ver=
sion": 0,"properties": {"family": "ip","table": "filter","use": 0,"type=
": "filter","hooknum": "NF_INET_FORWARD","prio": 0,"policy": "accept"}}=
}
diff --git a/tests/jsonfiles/13-chain.json b/tests/jsonfiles/13-chain.j=
son
new file mode 100644
index 0000000..835fc2b
--- /dev/null
+++ b/tests/jsonfiles/13-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "output","handle": 3,"bytes": 781933,"packets": 65=
06,"version": 0,"properties": {"family": "ip","table": "filter","use": =
0,"type": "filter","hooknum": "NF_INET_LOCAL_OUT","prio": 0,"policy": "=
accept"}}}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.j=
son
new file mode 100644
index 0000000..de3bc35
--- /dev/null
+++ b/tests/jsonfiles/14-chain.json
@@ -0,0 +1 @@
+{ "chain": {"name": "chain1","handle": 4,"bytes": 0,"packets": 0,"vers=
ion": 0,"properties": {"family": "ip","table": "filter","use": 0}}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 83a627c..777e2e0 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -23,6 +23,7 @@ static int test_json(const char *filename)
 #ifdef JSON_PARSING
 	int ret =3D -1;
 	struct nft_table *t =3D NULL;
+	struct nft_chain *c =3D NULL;
 	json_t *root;
 	json_error_t error;
 	char *json =3D NULL;
@@ -46,6 +47,14 @@ static int test_json(const char *filename)
=20
 			nft_table_free(t);
 		}
+	}else if (json_object_get(root, "chain") !=3D NULL) {
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
