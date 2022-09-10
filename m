Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A998FC6FA82
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Sep 2022 22:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiIJWLj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Sep 2022 18:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIJWLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2022 18:11:39 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0B0B5C
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2022 15:11:38 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MQ6X85HG2z9rxG
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Sep 2022 22:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662847898; bh=mTomSQ2ICbCcgG7/IxkkrVLpO/jBurHkrLzR6yLu0Z0=;
        h=From:To:Cc:Subject:Date:From;
        b=Df3/zEIXOAz2LmBEx0Ys6RkNuYxLIuZSJWKxQAsoWPG6EYy/2Fz6st/o2MDAF/JEU
         cMn66k1O5rsYCukry2p8Y2HZ8rVM6EAYmGR+EEqJNwfKC8pB2PDPpkiAr9ShdhTgSx
         uKAUduR/bFVcMVk7ijzELaw8VvuJm4/y4+wcvcF0=
X-Riseup-User-ID: 96A30159D689D15CEAFD99B7AC9ECF6AC8F3D40F52EE8CDFD37D230ADBB1A2AA
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MQ6X76DRKz1xx8;
        Sat, 10 Sep 2022 22:11:35 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: add stateful object comment support
Date:   Sun, 11 Sep 2022 00:11:14 +0200
Message-Id: <20220910221114.74863-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When listing a stateful object with JSON support, the comment was ignored.

Output example:

{
  "counter": {
    "family": "inet",
    "name": "mycounter",
    "table": "t",
    "handle": 1,
    "comment": "my comment in counter",
    "packets": 0,
    "bytes": 0
  }
}

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1611
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/json.c                                             | 6 ++++++
 src/parser_json.c                                      | 3 +++
 tests/shell/testcases/json/0006obj_comment_0           | 9 +++++++++
 tests/shell/testcases/json/dumps/0006obj_comment_0.nft | 6 ++++++
 4 files changed, 24 insertions(+)
 create mode 100755 tests/shell/testcases/json/0006obj_comment_0
 create mode 100644 tests/shell/testcases/json/dumps/0006obj_comment_0.nft

diff --git a/src/json.c b/src/json.c
index 6598863e..6662f808 100644
--- a/src/json.c
+++ b/src/json.c
@@ -329,6 +329,12 @@ static json_t *obj_print_json(const struct obj *obj)
 			"table", obj->handle.table.name,
 			"handle", obj->handle.handle.id);
 
+	if (obj->comment) {
+		tmp = json_pack("{s:s}", "comment", obj->comment);
+		json_object_update(root, tmp);
+		json_decref(tmp);
+	}
+
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
 		tmp = json_pack("{s:I, s:I}",
diff --git a/src/parser_json.c b/src/parser_json.c
index 46dca9fd..b8c30b75 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3339,6 +3339,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 
 	obj = obj_alloc(int_loc);
 
+	if (!json_unpack(root, "{s:s}", "comment", &obj->comment))
+		obj->comment = xstrdup(obj->comment);
+
 	switch (cmd_obj) {
 	case CMD_OBJ_COUNTER:
 		obj->type = NFT_OBJECT_COUNTER;
diff --git a/tests/shell/testcases/json/0006obj_comment_0 b/tests/shell/testcases/json/0006obj_comment_0
new file mode 100755
index 00000000..76d8fe16
--- /dev/null
+++ b/tests/shell/testcases/json/0006obj_comment_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "t", "handle": 9}}, {"counter": {"family": "inet", "name": "mycounter", "table": "t", "handle": 1, "comment": "my comment in counter", "packets": 0, "bytes": 0}}]}'
+
+$NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/dumps/0006obj_comment_0.nft b/tests/shell/testcases/json/dumps/0006obj_comment_0.nft
new file mode 100644
index 00000000..e52b21b4
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0006obj_comment_0.nft
@@ -0,0 +1,6 @@
+table inet t {
+	counter mycounter {
+		comment "my comment in counter"
+		packets 0 bytes 0
+	}
+}
-- 
2.30.2

