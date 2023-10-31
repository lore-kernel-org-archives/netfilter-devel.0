Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF2EC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Oct 2023 18:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjJaSzu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjJaSzt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 14:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C6BE6
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 11:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698778502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKzoXHg56qV6QeFZ825rh26RkbdMoDPcQIi8fFaTiMs=;
        b=ghDCZmwb7HE6TiejczQvKGCH/nfgc46F0eXrT6XGp5G7xUPlDca7+KH1zkEfzCkVS+7RXb
        AzyHOYIa3eq5yT7S8IZaDEWY9Jhx6+RqdNLDhZyuuot6/newSxyBoErikOLc2sXAu1plqW
        C+/KU9miEaXFtxeg5m3clvT7hJaHjrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-Gvwwgav4NvuSZy7WOncV1Q-1; Tue, 31 Oct 2023 14:55:01 -0400
X-MC-Unique: Gvwwgav4NvuSZy7WOncV1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBE72185A784
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 18:55:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21AAB10F51;
        Tue, 31 Oct 2023 18:55:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/7] json: drop messages "warning: stmt ops chain have no json callback"
Date:   Tue, 31 Oct 2023 19:53:28 +0100
Message-ID: <20231031185449.1033380-3-thaller@redhat.com>
In-Reply-To: <20231031185449.1033380-1-thaller@redhat.com>
References: <20231031185449.1033380-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This message purely depends on the internal callbacks and at the program
code. This is not useful. What is the user going to do with this warning?

Maybe there is a bug here, but then we shouldn't print a warning but fix
the bug.

For example, calling `nft -j list ruleset` after test "tests/shell/testcases/chains/0041chain_binding_0"
will trigger messages like:

  warning: stmt ops chain have no json callback
  warning: stmt ops chain have no json callback

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/json.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/json.c b/src/json.c
index c0ccf06d85b4..c66b58f8c6d5 100644
--- a/src/json.c
+++ b/src/json.c
@@ -52,9 +52,6 @@ static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
 	if (ops->json)
 		return ops->json(expr, octx);
 
-	fprintf(stderr, "warning: expr ops %s have no json callback\n",
-		expr_name(expr));
-
 	fp = octx->output_fp;
 	octx->output_fp = fmemopen(buf, 1024, "w");
 
@@ -95,9 +92,6 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	if (stmt->ops->json)
 		return stmt->ops->json(stmt, octx);
 
-	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
-		stmt->ops->name);
-
 	fp = octx->output_fp;
 	octx->output_fp = fmemopen(buf, 1024, "w");
 
-- 
2.41.0

