Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C93C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344868AbjKCQah (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344250AbjKCQag (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:30:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39170E3
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699028991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nG+ld1dyaWrlNFwkQaHYrw2B8lQM9CBwJEd+0Juk9Uc=;
        b=LkPtRDsZrzJbLwWWiUu1E2wV7aPhLLiKmLUd8VVJ61qKksDRsSBJWhsKLWAyBHWAmNGqI+
        VSz6RZPyPalOxebYIkvImdFNGktZ1LUc/oK0SCFwsc3abvIN6G7Az4XVmfHWfpbRAn5d/M
        j7GM0PIDW1Wd2MCpFFqOZ+JcK+/Wevc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-Ud2sr2T-NDqNGGcZKnFO1g-1; Fri,
 03 Nov 2023 12:29:49 -0400
X-MC-Unique: Ud2sr2T-NDqNGGcZKnFO1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35C5D1C0754C
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 16:29:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A932C2166B2C;
        Fri,  3 Nov 2023 16:29:48 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 1/2] json: drop handling missing json() hook in expr_print_json()
Date:   Fri,  3 Nov 2023 17:25:13 +0100
Message-ID: <20231103162937.3352069-2-thaller@redhat.com>
In-Reply-To: <20231103162937.3352069-1-thaller@redhat.com>
References: <20231103162937.3352069-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are only two "struct expr_ops" that don't have a json() hook set
("symbol_expr_ops", "variable_exrp_ops"). For those, we never expect to
call expr_print_json().

All other "struct expr_ops" must have a hook set. Soon a unit test shall
be added to also ensure that for all expr_ops (except EXPR_SYMBOL and
EXPR_VARIABLE).

It thus should not be possible to ever call expr_print_json() with a
NULL hook. Drop the code that tries to handle that.

The previous code was essentially a graceful assertion, which only
prints a message to stderr (instead of assert()/abort()) and implemented
a fallback solution. The fallback solution is not really useful, because
it's just the bison string which cannot be parsed back.

This seems too much effort trying to handle a potential bug, for
something that we most likely will not be wrong (once the unit test is
in place). Drop the fallback solution and just require the bug not to be
present. We now get a hard crash if the requirement is violated.

Also add code comments hinting to all of this.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/expression.c |  2 ++
 src/json.c       | 28 ++++++++--------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index a21dfec25722..53fa630e099c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -321,6 +321,7 @@ static const struct expr_ops symbol_expr_ops = {
 	.type		= EXPR_SYMBOL,
 	.name		= "symbol",
 	.print		= symbol_expr_print,
+	.json		= NULL, /* expr_print_json() must never be called. */
 	.clone		= symbol_expr_clone,
 	.destroy	= symbol_expr_destroy,
 };
@@ -362,6 +363,7 @@ static const struct expr_ops variable_expr_ops = {
 	.type		= EXPR_VARIABLE,
 	.name		= "variable",
 	.print		= variable_expr_print,
+	.json		= NULL, /* expr_print_json() must never be called. */
 	.clone		= variable_expr_clone,
 	.destroy	= variable_expr_destroy,
 };
diff --git a/src/json.c b/src/json.c
index 068c423addc7..25e349155394 100644
--- a/src/json.c
+++ b/src/json.c
@@ -44,26 +44,14 @@
 
 static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
 {
-	const struct expr_ops *ops;
-	char buf[1024];
-	FILE *fp;
-
-	ops = expr_ops(expr);
-	if (ops->json)
-		return ops->json(expr, octx);
-
-	fprintf(stderr, "warning: expr ops %s have no json callback\n",
-		expr_name(expr));
-
-	fp = octx->output_fp;
-	octx->output_fp = fmemopen(buf, 1024, "w");
-
-	ops->print(expr, octx);
-
-	fclose(octx->output_fp);
-	octx->output_fp = fp;
-
-	return json_pack("s", buf);
+	/* The json() hooks of "symbol_expr_ops" and "variable_expr_ops" are
+	 * known to be NULL, but for such expressions we never expect to call
+	 * expr_print_json().
+	 *
+	 * All other expr_ops must have a json() hook.
+	 *
+	 * Unconditionally access the hook (and segfault in case of a bug).  */
+	return expr_ops(expr)->json(expr, octx);
 }
 
 static json_t *set_dtype_json(const struct expr *key)
-- 
2.41.0

