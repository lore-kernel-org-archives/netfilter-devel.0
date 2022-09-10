Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA8DECAAD5
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Sep 2022 08:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIJIAF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Sep 2022 04:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIJIAF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2022 04:00:05 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B58A2E6B3
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2022 01:00:02 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MPldY4ZpczDqqr
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2022 08:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662796801; bh=ZEpJB/kX/S0X/B4I8fRK7sVmTqoXRKML9jW1af32zbY=;
        h=From:To:Cc:Subject:Date:From;
        b=GnVi8EO4FTOItoSUeblHdSbfrSXiBBTLlXV1AktXIQfElxI7GFQ5kSTBPKmeKiD2l
         WYmmpirJkMZ+9rdHyUkfVFFw60CluMi8RYriYsEkcsXTQCLJsEL76L022wRrUC5Yn2
         rVt5bKF3hnL9dIB53tl6F5yjpd60KxsQs7F3qZ2w=
X-Riseup-User-ID: 7022B0F0CFA31255798AB732A863832A2C7031E8184F1294A3761F2345A07FFD
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MPldX5jMbz5vcD;
        Sat, 10 Sep 2022 08:00:00 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: add secmark object reference support
Date:   Sat, 10 Sep 2022 09:59:48 +0200
Message-Id: <20220910075948.58810-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The secmark object reference requires a json parser function and it was
missing. In addition, extends the shell testcases.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1630
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/parser_json.c                              | 18 ++++++++++++++++++
 .../shell/testcases/json/0005secmark_objref_0  |  9 +++++++++
 .../json/dumps/0005secmark_objref_0.nft        | 18 ++++++++++++++++++
 3 files changed, 45 insertions(+)
 create mode 100755 tests/shell/testcases/json/0005secmark_objref_0
 create mode 100644 tests/shell/testcases/json/dumps/0005secmark_objref_0.n=
ft

diff --git a/src/parser_json.c b/src/parser_json.c
index 46dca9fd..1ffca2d1 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1966,6 +1966,23 @@ static struct stmt *json_parse_dup_stmt(struct json_=
ctx *ctx,
 	return stmt;
 }
=20
+static struct stmt *json_parse_secmark_stmt(struct json_ctx *ctx,
+					     const char *key, json_t *value)
+{
+	struct stmt *stmt;
+
+	stmt =3D objref_stmt_alloc(int_loc);
+	stmt->objref.type =3D NFT_OBJECT_SECMARK;
+	stmt->objref.expr =3D json_parse_stmt_expr(ctx, value);
+	if (!stmt->objref.expr) {
+		json_error(ctx, "Invalid secmark reference.");
+		stmt_free(stmt);
+		return NULL;
+	}
+
+	return stmt;
+}
+
 static int json_parse_nat_flag(struct json_ctx *ctx,
 			       json_t *root, int *flags)
 {
@@ -2727,6 +2744,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *=
ctx, json_t *root)
 		{ "tproxy", json_parse_tproxy_stmt },
 		{ "synproxy", json_parse_synproxy_stmt },
 		{ "reset", json_parse_optstrip_stmt },
+		{ "secmark", json_parse_secmark_stmt },
 	};
 	const char *type;
 	unsigned int i;
diff --git a/tests/shell/testcases/json/0005secmark_objref_0 b/tests/shell/=
testcases/json/0005secmark_objref_0
new file mode 100755
index 00000000..ae967435
--- /dev/null
+++ b/tests/shell/testcases/json/0005secmark_objref_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET=3D'{"nftables": [{"metainfo": {"version": "1.0.5", "release_name":=
 "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "inet"=
, "name": "x", "handle": 4}}, {"secmark": {"family": "inet", "name": "ssh_s=
erver", "table": "x", "handle": 1, "context": "system_u:object_r:ssh_server=
_packet_t:s0"}}, {"chain": {"family": "inet", "table": "x", "name": "y", "h=
andle": 2, "type": "filter", "hook": "input", "prio": -225, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "z", "handle": 3,=
 "type": "filter", "hook": "output", "prio": 225, "policy": "accept"}}, {"r=
ule": {"family": "inet", "table": "x", "chain": "y", "handle": 4, "expr": [=
{"match": {"op": "=3D=3D", "left": {"payload": {"protocol": "tcp", "field":=
 "dport"}}, "right": 2222}}, {"match": {"op": "in", "left": {"ct": {"key": =
"state"}}, "right": "new"}}, {"secmark": "ssh_server"}]}}, {"rule": {"famil=
y": "inet", "table": "x", "chain": "y", "handle": 5, "expr": [{"match": {"o=
p": "in", "left": {"ct": {"key": "state"}}, "right": "new"}}, {"mangle": {"=
key": {"ct": {"key": "secmark"}}, "value": {"meta": {"key": "secmark"}}}}]}=
}, {"rule": {"family": "inet", "table": "x", "chain": "y", "handle": 6, "ex=
pr": [{"match": {"op": "in", "left": {"ct": {"key": "state"}}, "right": ["e=
stablished", "related"]}}, {"mangle": {"key": {"meta": {"key": "secmark"}},=
 "value": {"ct": {"key": "secmark"}}}}]}}, {"rule": {"family": "inet", "tab=
le": "x", "chain": "z", "handle": 7, "expr": [{"match": {"op": "in", "left"=
: {"ct": {"key": "state"}}, "right": "new"}}, {"mangle": {"key": {"ct": {"k=
ey": "secmark"}}, "value": {"meta": {"key": "secmark"}}}}]}}, {"rule": {"fa=
mily": "inet", "table": "x", "chain": "z", "handle": 8, "expr": [{"match": =
{"op": "in", "left": {"ct": {"key": "state"}}, "right": ["established", "re=
lated"]}}, {"mangle": {"key": {"meta": {"key": "secmark"}}, "value": {"ct":=
 {"key": "secmark"}}}}]}}]}'
+
+$NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/dumps/0005secmark_objref_0.nft b/te=
sts/shell/testcases/json/dumps/0005secmark_objref_0.nft
new file mode 100644
index 00000000..4c218e93
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0005secmark_objref_0.nft
@@ -0,0 +1,18 @@
+table inet x {
+	secmark ssh_server {
+		"system_u:object_r:ssh_server_packet_t:s0"
+	}
+
+	chain y {
+		type filter hook input priority -225; policy accept;
+		tcp dport 2222 ct state new meta secmark set "ssh_server"
+		ct state new ct secmark set meta secmark
+		ct state established,related meta secmark set ct secmark
+	}
+
+	chain z {
+		type filter hook output priority 225; policy accept;
+		ct state new ct secmark set meta secmark
+		ct state established,related meta secmark set ct secmark
+	}
+}
--=20
2.30.2

