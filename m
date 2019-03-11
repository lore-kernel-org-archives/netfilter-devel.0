Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC3BC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC152084F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="EsHnDsaQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfCKPOb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:14:31 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50342 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbfCKPOb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:14:31 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 5BC201A64CB
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 08:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552317270; bh=5TxmpCSx/k4UMz1CbtVmzxUZkqAybr0R+a/40tu1V2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsHnDsaQPlvU2E02a8LYdaWD7WBy9B1DDWQmghB5c2PO9ZwP61U6NmDKrgf/+f30t
         xbUWT5rA6eCcOter5Ni4AKWBUnf45nv7TY/ZQiCh15BHUTX3n3EHtk9X0LS5LTJO3Z
         LDSFUrbfrxqnmo4d4IW364RHSl/S639kEvof7/cE=
X-Riseup-User-ID: D006D4537AF30C89D48D1308CE5A41045B21DD8578F002501EF7CE2E4790796E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 71260221C5D;
        Mon, 11 Mar 2019 08:14:29 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2 2/6] json: osf: add version json support
Date:   Mon, 11 Mar 2019 16:14:13 +0100
Message-Id: <20190311151417.17772-2-ffmancera@riseup.net>
In-Reply-To: <20190311151417.17772-1-ffmancera@riseup.net>
References: <20190311151417.17772-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: flags type is now u32
---
 doc/libnftables-json.adoc |  7 +++++-
 src/json.c                | 13 +++++++++++
 src/parser_json.c         | 48 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index dbe5ac3..6981c69 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1302,11 +1302,16 @@ Construct a reference to packet's socket.
 ____
 *{ "osf": {
 	"key":* 'OSF_KEY'*,
-	"ttl":* 'OSF_TTL'
+	"ttl":* 'OSF_TTL'*,
+	"flags":* 'OSF_FLAGS'
 *}}*
 
 'OSF_KEY' := *"name"*
 'OSF_TTL' := *"loose"* | *"skip"*
+
+'OSF_FLAGS' := 'OSF_FLAG' | *[* 'OSF_FLAG_LIST' *]*
+'OSF_FLAG_LIST' := 'OSF_FLAG' [*,* 'OSF_FLAG_LIST' ]
+'OSF_FLAG' := *"version"*
 ____
 
 Perform OS fingerprinting. This expression is typically used in the LHS of a *match*
diff --git a/src/json.c b/src/json.c
index 276a3c0..a46188d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -865,6 +865,7 @@ json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx)
 json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *root = json_pack("{s:s}", "key", "name");
+	const char *osf_flags[] = { "version" }
 
 	switch (expr->osf.ttl) {
 	case 1:
@@ -875,6 +876,18 @@ json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 		break;
 	}
 
+	if (expr->osf.flags) {
+		json_t *tmp = json_array();
+		unsigned int i;
+
+		for (i = 0; i < array_size(osf_flags); i++) {
+			if (osf.flags & (1 << i)) {
+				json_array_append_new(tmp, json_string(osf_flags[i]));
+			}
+		}
+		json_object_set_new(root, "flags", tmp);
+	}
+
 	return json_pack("{s:o}", "osf", root);
 }
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 7b190bc..ae197f0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -377,10 +377,26 @@ static struct expr *json_parse_meta_expr(struct json_ctx *ctx,
 	return meta_expr_alloc(int_loc, key);
 }
 
+static int osf_flag_parse(const char *name, int *flagval)
+{
+	const char *osf_flags[] = { "version" };
+	unsigned int i;
+
+	for (i = 0; i < array_size(osf_flags); i++) {
+		if (!strcmp(name, osf_flags[i])) {
+			*flagval |= (1 << i);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static struct expr *json_parse_osf_expr(struct json_ctx *ctx,
 					const char *type, json_t *root)
 {
+	json_t *flags, *value;
 	const char *key, *ttl;
+	uint8_t flagval = 0;
 	uint8_t ttlval = 0;
 
 	if (json_unpack_err(ctx, root, "{s:s}", "key", &key))
@@ -397,8 +413,38 @@ static struct expr *json_parse_osf_expr(struct json_ctx *ctx,
 		}
 	}
 
+	if (!json_unpack(root, "{s:o}", "flags", &flags)) {
+		const char *flag;
+
+		if (json_is_string(flags)) {
+			flag = json_string_value(flags);
+
+			if (osf_flag_parse(flag, &flagval)) {
+				json_error(ctx, "Invalidad osf flag '%s'.", flag);
+				return NULL;
+			}
+
+		} else if (!json_is_array) {
+			json_error(ctx, "Unexpected object type in osf flags tuple.");
+			return NULL;
+		}
+
+		json_array_foreach(flags, index, value) {
+			if (!json_is_string(value)) {
+				json_error(ctx, "Unexpected object type in osf flags array at index %zd.", index);
+				return NULL;
+			}
+			flag = json_string_value(value);
+
+			if (osf_flag_parse(flag, &flagval)) {
+				json_error(ctx, "Invalid osf flag '%s'.", flag);
+				return NULL;
+			}
+		}
+	}
+
 	if (!strcmp(key, "name"))
-		return osf_expr_alloc(int_loc, ttlval);
+		return osf_expr_alloc(int_loc, ttlval, flagval);
 
 	json_error(ctx, "Invalid osf key value.");
 	return NULL;
-- 
2.20.1

