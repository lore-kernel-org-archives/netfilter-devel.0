Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF76C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C251921473
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="JB+qT4R7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbfC0KiD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:38:03 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55518 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfC0KiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 06:38:03 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 81E121B906E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1553683082; bh=wKCS/lURutCwYWRRUSi7ZvzxBPPgEaf3yM423tnPmVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JB+qT4R736RnvTf2atx+UGCn7gU9RtTSHKiMES2ZLSXG15fxOSEqGoFZQ5mdvbUVh
         5nKYE1LBf+UGIwun6RBkd5M1891J9ET77xNO3FXtjBUjQaNicFFsmgdaXLTtwTGfyx
         pec0D6EQBOADO92zIaQK16vn4tE0bLWeeN3VyQlE=
X-Riseup-User-ID: AAE12482500ED62C1E3E9073549C55610E9C2E199E31F371BE4EEB8AC448A12A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 420CA1205E8;
        Wed, 27 Mar 2019 03:38:01 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/6 nft v3] json: osf: add version json support
Date:   Wed, 27 Mar 2019 11:37:57 +0100
Message-Id: <20190327103801.2049-2-ffmancera@riseup.net>
In-Reply-To: <20190327103801.2049-1-ffmancera@riseup.net>
References: <20190327103801.2049-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/json.c        | 7 ++++++-
 src/parser_json.c | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/src/json.c b/src/json.c
index 276a3c0..4900c02 100644
--- a/src/json.c
+++ b/src/json.c
@@ -864,7 +864,12 @@ json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx)
 
 json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
-	json_t *root = json_pack("{s:s}", "key", "name");
+	json_t *root;
+
+	if (expr->osf.flags & NFT_OSF_F_VERSION)
+		root = json_pack("{s:s}", "key", "version");
+	else
+		root = json_pack("{s:s}", "key", "name");
 
 	switch (expr->osf.ttl) {
 	case 1:
diff --git a/src/parser_json.c b/src/parser_json.c
index 7b190bc..07defc0 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -381,6 +381,7 @@ static struct expr *json_parse_osf_expr(struct json_ctx *ctx,
 					const char *type, json_t *root)
 {
 	const char *key, *ttl;
+	uint32_t flagval = 0;
 	uint8_t ttlval = 0;
 
 	if (json_unpack_err(ctx, root, "{s:s}", "key", &key))
@@ -397,8 +398,12 @@ static struct expr *json_parse_osf_expr(struct json_ctx *ctx,
 		}
 	}
 
-	if (!strcmp(key, "name"))
-		return osf_expr_alloc(int_loc, ttlval);
+	if (!strcmp(key, "name")) {
+		return osf_expr_alloc(int_loc, ttlval, flagval);
+	} else if (!strcmp(key, "version")) {
+		flagval |= NFT_OSF_F_VERSION;
+		return osf_expr_alloc(int_loc, ttlval, flagval);
+	}
 
 	json_error(ctx, "Invalid osf key value.");
 	return NULL;
-- 
2.20.1

