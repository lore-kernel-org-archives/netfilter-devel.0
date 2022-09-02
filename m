Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6993AECAAD5
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Sep 2022 14:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbiIBOHy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiIBOH0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2022 10:07:26 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705EB52805
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2022 06:35:30 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MJzSJ4njhz9sNk
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2022 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662125728; bh=An5DOZbqL1RBBB1+lGcvm/eH9AQaP1gNlBbh/az3ExI=;
        h=From:To:Cc:Subject:Date:From;
        b=KCSH67hnPW/y8eDyz2yccU9TGnLeWFEsm/61vPUtc0W0Sk24owrZ8ttWNzBFxvwiL
         RnSpJFLuFRLWLBPFYauz9fl/DclZcTjCBuVCuA7Rc2UthR/7UsoWVDgJ3bfbsi0+7c
         CKv04tcIF3b3T500s/2izzIg+DXFkzQblZBWfMbo=
X-Riseup-User-ID: E07CD83DC2943C4B09C77CFDB12D6CA86177872F694681147658C1FB72CC2719
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MJzSH5bK0z5w5d;
        Fri,  2 Sep 2022 13:35:27 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: fix json schema version verification
Date:   Fri,  2 Sep 2022 15:35:06 +0200
Message-Id: <20220902133506.126026-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft should ignore malformed or missing entries of `json_schema_version` but
check the value when it is integer.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1490
Fixes: 49e0f1dc6 ("JSON: Add metainfo object to all output")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/parser_json.c                                 | 15 ++++++++-------
 .../testcases/json/0003json_schema_version_0      |  9 +++++++++
 .../testcases/json/0004json_schema_version_1      | 11 +++++++++++
 .../json/dumps/0003json_schema_version_0.nft      |  0
 .../json/dumps/0004json_schema_version_1.nft      |  0
 5 files changed, 28 insertions(+), 7 deletions(-)
 create mode 100755 tests/shell/testcases/json/0003json_schema_version_0
 create mode 100755 tests/shell/testcases/json/0004json_schema_version_1
 create mode 100644 tests/shell/testcases/json/dumps/0003json_schema_version_0.nft
 create mode 100644 tests/shell/testcases/json/dumps/0004json_schema_version_1.nft

diff --git a/src/parser_json.c b/src/parser_json.c
index fc72c25f..b14f545f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3859,13 +3859,14 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 {
 	int schema_version;
 
-	if (!json_unpack(root, "{s:i}", "json_schema_version", &schema_version))
-			return 0;
-
-	if (schema_version > JSON_SCHEMA_VERSION) {
-		json_error(ctx, "Schema version %d not supported, maximum supported version is %d\n",
-			   schema_version, JSON_SCHEMA_VERSION);
-		return 1;
+	if (!json_unpack(root, "{s:i}", "json_schema_version", &schema_version)) {
+		if (schema_version > JSON_SCHEMA_VERSION) {
+			json_error(ctx,
+				   "Schema version %d not supported, maximum"
+			           " supported version is %d\n",
+				   schema_version, JSON_SCHEMA_VERSION);
+			return 1;
+		}
 	}
 
 	return 0;
diff --git a/tests/shell/testcases/json/0003json_schema_version_0 b/tests/shell/testcases/json/0003json_schema_version_0
new file mode 100755
index 00000000..0ccf94c8
--- /dev/null
+++ b/tests/shell/testcases/json/0003json_schema_version_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET='{"nftables": [{"metainfo": {"json_schema_version": 1}}]}'
+
+$NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/0004json_schema_version_1 b/tests/shell/testcases/json/0004json_schema_version_1
new file mode 100755
index 00000000..bc451ae7
--- /dev/null
+++ b/tests/shell/testcases/json/0004json_schema_version_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET='{"nftables": [{"metainfo": {"json_schema_version": 999}}]}'
+
+$NFT -j -f - <<< $RULESET && exit 1
+
+exit 0
diff --git a/tests/shell/testcases/json/dumps/0003json_schema_version_0.nft b/tests/shell/testcases/json/dumps/0003json_schema_version_0.nft
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/json/dumps/0004json_schema_version_1.nft b/tests/shell/testcases/json/dumps/0004json_schema_version_1.nft
new file mode 100644
index 00000000..e69de29b
-- 
2.30.2

