Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC51C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjKBLW3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjKBLW3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:22:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D70130
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698924095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J6dwHh9/0EppcTOooWiIJ6RVAAqW9tgG0KgQXSE7Gs=;
        b=d3sxuDVzdKKc5tOYpEsHbS/5LeVJeTGwdPTOAaXdrBLkvpEXaUQm6gf924MPwGIhjynCTz
        C7YPM4NlNbMo4oJubA2W9wpk0cWWKsTgrIb4Yad3A0iuj93fA5ZEloYrYshVw0U3yNewAK
        BqAgPKyMJJcjE3Z+4aQ05P3sQUC2s2g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-68C8aRNXOre-HtoRPRhD4w-1; Thu,
 02 Nov 2023 07:21:34 -0400
X-MC-Unique: 68C8aRNXOre-HtoRPRhD4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3327D280BC48
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 11:21:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A66DE25C0;
        Thu,  2 Nov 2023 11:21:33 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] json: drop handling missing json() hook for "struct expr_ops"
Date:   Thu,  2 Nov 2023 12:20:29 +0100
Message-ID: <20231102112122.383527-2-thaller@redhat.com>
In-Reply-To: <20231102112122.383527-1-thaller@redhat.com>
References: <20231102112122.383527-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By now, all "struct expr_ops" have a json() hook set. Thus, drop
handling the possibility that they might not. From now on, it's a bug
to create a ops without the hook.

It's not clear what the code tried to do. It bothered to implement a
fallback via fmemopen(), but apparently that fallback is no considered a
good solution as it also printed a "warning". Either the fallback is
good and does not warrant a warning. Or the condition is to be avoided
to begin with, which we should do by testing the expr_ops structures.

As the fallback path has an overhead to create the memory stream, the
fallback path is indeed not great. That is the reason to outlaw a
missing json() hook, to require that all hooks are present, and to drop
the fallback path.

A missing hook is very easy to cover with unit tests. Such a test shall
be added soon.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/json.c | 40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/src/json.c b/src/json.c
index 0fd78b763af7..cbd2abbc8b52 100644
--- a/src/json.c
+++ b/src/json.c
@@ -44,26 +44,7 @@
 
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
+	return expr_ops(expr)->json(expr, octx);
 }
 
 static json_t *set_dtype_json(const struct expr *key)
@@ -89,24 +70,7 @@ static json_t *set_dtype_json(const struct expr *key)
 
 static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	char buf[1024];
-	FILE *fp;
-
-	if (stmt->ops->json)
-		return stmt->ops->json(stmt, octx);
-
-	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
-		stmt->ops->name);
-
-	fp = octx->output_fp;
-	octx->output_fp = fmemopen(buf, 1024, "w");
-
-	stmt->ops->print(stmt, octx);
-
-	fclose(octx->output_fp);
-	octx->output_fp = fp;
-
-	return json_pack("s", buf);
+	return stmt->ops->json(stmt, octx);
 }
 
 static json_t *set_stmt_list_json(const struct list_head *stmt_list,
-- 
2.41.0

