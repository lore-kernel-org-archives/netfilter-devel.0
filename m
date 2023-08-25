Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AC9C3DA66
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbjHYNbP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245109AbjHYNan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 09:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19061FF0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 06:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692970194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9gm7bnO3TXq8PO3S0oYrOmTmAFx9i/qKNpwPGO6ZNk=;
        b=PE+rWSEmOTSNGtIhYoj/od4Qyec2IwUvEyNTlzGTNcI65zSZPcyVvaTh/6e20cYqLf5pVU
        FLdnJZoggNNaZ586jbIYAGiHTgODFbwmVTIbRAFMeZ0TW2qmgogRguUiwWOfye1l0cgset
        dpMIBYjQP13M0wThmRGGPpfRHig4MV4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-696-N6rakhzUNUqsikCDl60NRw-1; Fri, 25 Aug 2023 09:29:53 -0400
X-MC-Unique: N6rakhzUNUqsikCDl60NRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6403728040B3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 13:29:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D592D2166B26;
        Fri, 25 Aug 2023 13:29:52 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/4] evaluate: add and use parse_ctx_init() helper method
Date:   Fri, 25 Aug 2023 15:24:17 +0200
Message-ID: <20230825132942.2733840-2-thaller@redhat.com>
In-Reply-To: <20230825132942.2733840-1-thaller@redhat.com>
References: <20230825132942.2733840-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Another field to parse_ctx will be added, that should be initialized.
As initializing the parse_ctx struct gets more involved, move the
duplicated code to a separate function.

Having a dedicated function, also  makes it easier to grep of all the
places where a parse context gets set up.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/evaluate.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1ae2ef0de10c..fdd2433b4780 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -40,6 +40,20 @@
 #include <utils.h>
 #include <xt.h>
 
+static struct parse_ctx *parse_ctx_init(struct parse_ctx *parse_ctx, const struct eval_ctx *ctx)
+{
+	struct parse_ctx tmp = {
+		.tbl	= &ctx->nft->output.tbl,
+		.input	= &ctx->nft->input,
+	};
+
+	/* "tmp" only exists, so we can search for "/struct parse_ctx .*=/" and find the location
+	 * where the parse context gets initialized. */
+
+	*parse_ctx = tmp;
+	return parse_ctx;
+}
+
 struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx)
 {
 	uint8_t idx = ctx->inner_desc ? 1 : 0;
@@ -278,15 +292,14 @@ static int flowtable_not_found(struct eval_ctx *ctx, const struct location *loc,
  */
 static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct parse_ctx parse_ctx = {
-		.tbl	= &ctx->nft->output.tbl,
-		.input	= &ctx->nft->input,
-	};
+	struct parse_ctx parse_ctx;
 	struct error_record *erec;
 	struct table *table;
 	struct set *set;
 	struct expr *new;
 
+	parse_ctx_init(&parse_ctx, ctx);
+
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
 		datatype_set(*expr, ctx->ectx.dtype);
@@ -3454,13 +3467,12 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 
 static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct parse_ctx parse_ctx = {
-		.tbl	= &ctx->nft->output.tbl,
-		.input	= &ctx->nft->input,
-	};
+	struct parse_ctx parse_ctx;
 	struct error_record *erec;
 	struct expr *code;
 
+	parse_ctx_init(&parse_ctx, ctx);
+
 	erec = symbol_parse(&parse_ctx, stmt->reject.expr, &code);
 	if (erec != NULL) {
 		erec_queue(erec, ctx->msgs);
-- 
2.41.0

