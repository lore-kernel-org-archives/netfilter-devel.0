Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531BFC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjKBLWZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjKBLWZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4720111
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698924097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PeJL0u9LK14akXw7c+O+i5LrMsZIy6bX3b07YECVfw0=;
        b=PJahNtTOSLqoORi3qHiUJ+aV8b2oKu15ygAieUOhieVUGDiVUsNiivYM8Zu3bT9+u6diDy
        3XeqAHVMpsOlR5en2/fWem7tCHfr0POHXYLBJrtgI1TG44AFjAcv0pyUfqavZzvHuXa6gC
        VZbnrE9ZrwbvYDe7gTOIvbO91MWjsb8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-IFsTzR6RPj6AF3kPJIT4xg-1; Thu, 02 Nov 2023 07:21:33 -0400
X-MC-Unique: IFsTzR6RPj6AF3kPJIT4xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AA9382BA80
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 11:21:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDEE225C0;
        Thu,  2 Nov 2023 11:21:32 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] json: implement json() hook for "symbol_expr_ops"/"variabl_expr_ops"
Date:   Thu,  2 Nov 2023 12:20:28 +0100
Message-ID: <20231102112122.383527-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ultimate goal is that all "struct expr_ops" have a "json()" hook
set.

It's also faster, to just create the JSON node, instead of creating a
memory stream, write there using print only to get the sting.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
The patches 1/2 and 2/2 replaces

  Subject:	[PATCH nft 2/7] json: drop messages "warning: stmt ops chain have no json callback"
  Date:	Tue, 31 Oct 2023 19:53:28 +0100

 include/json.h   |  4 ++++
 src/expression.c |  2 ++
 src/json.c       | 10 ++++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/json.h b/include/json.h
index 39be8928e8ee..134e503afe54 100644
--- a/include/json.h
+++ b/include/json.h
@@ -49,7 +49,9 @@ json_t *rt_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *numgen_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *hash_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx);
+json_t *symbol_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *constant_expr_json(const struct expr *expr, struct output_ctx *octx);
+json_t *variable_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *osf_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *xfrm_expr_json(const struct expr *expr, struct output_ctx *octx);
@@ -156,7 +158,9 @@ EXPR_PRINT_STUB(set_elem_catchall_expr)
 EXPR_PRINT_STUB(numgen_expr)
 EXPR_PRINT_STUB(hash_expr)
 EXPR_PRINT_STUB(fib_expr)
+EXPR_PRINT_STUB(symbol_expr)
 EXPR_PRINT_STUB(constant_expr)
+EXPR_PRINT_STUB(variable_expr)
 EXPR_PRINT_STUB(socket_expr)
 EXPR_PRINT_STUB(osf_expr)
 EXPR_PRINT_STUB(xfrm_expr)
diff --git a/src/expression.c b/src/expression.c
index a21dfec25722..d6a2e69db572 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -321,6 +321,7 @@ static const struct expr_ops symbol_expr_ops = {
 	.type		= EXPR_SYMBOL,
 	.name		= "symbol",
 	.print		= symbol_expr_print,
+	.json           = symbol_expr_json,
 	.clone		= symbol_expr_clone,
 	.destroy	= symbol_expr_destroy,
 };
@@ -362,6 +363,7 @@ static const struct expr_ops variable_expr_ops = {
 	.type		= EXPR_VARIABLE,
 	.name		= "variable",
 	.print		= variable_expr_print,
+	.json		= variable_expr_json,
 	.clone		= variable_expr_clone,
 	.destroy	= variable_expr_destroy,
 };
diff --git a/src/json.c b/src/json.c
index 068c423addc7..0fd78b763af7 100644
--- a/src/json.c
+++ b/src/json.c
@@ -982,11 +982,21 @@ static json_t *datatype_json(const struct expr *expr, struct output_ctx *octx)
 	    expr->dtype->name);
 }
 
+json_t *symbol_expr_json(const struct expr *expr, struct output_ctx *octx)
+{
+	return json_string(expr->identifier);
+}
+
 json_t *constant_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	return datatype_json(expr, octx);
 }
 
+json_t *variable_expr_json(const struct expr *expr, struct output_ctx *octx)
+{
+	return json_string(expr->sym->identifier);
+}
+
 json_t *socket_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	return json_pack("{s:{s:s}}", "socket", "key",
-- 
2.41.0

