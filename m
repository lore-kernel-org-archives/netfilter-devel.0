Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2829FC83F18
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjH2NAM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjH2NAB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:00:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5547EBF
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EbcaJr7nv6tGt5PHyQB5xkLt/62dNeuVdFNVNA7WZv8=;
        b=g7OAnmLbgHYJOTxzQ6QEscZC9mq/NWe7SjOrNGSp2dTgGnFwQt+p8rWXA1UPsxDXgo5ri3
        1SqmiwX1UNFfef4E9Gh9BunyFnFE/dgdEFY34WPBZNpeM2dD4gvr7u2fDxi61ESqEQ4ucR
        UaEX1j8qZwwLsnTypYxAv1ACBdsC3dI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-6_q9jgOBPAmixmAId-lF3A-1; Tue, 29 Aug 2023 08:58:25 -0400
X-MC-Unique: 6_q9jgOBPAmixmAId-lF3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D183D85CBE5
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5295D40C2063;
        Tue, 29 Aug 2023 12:58:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 6/8] evaluate: don't needlessly clear full string buffer in stmt_evaluate_log_prefix()
Date:   Tue, 29 Aug 2023 14:53:35 +0200
Message-ID: <20230829125809.232318-7-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/evaluate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 71e94a51cc2f..bfe3638bfe54 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4128,7 +4128,8 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	char prefix[NF_LOG_PREFIXLEN] = {}, tmp[NF_LOG_PREFIXLEN] = {};
+	char tmp[NF_LOG_PREFIXLEN] = {};
+	char prefix[NF_LOG_PREFIXLEN];
 	size_t len = sizeof(prefix);
 	size_t offset = 0;
 	struct expr *expr;
@@ -4136,6 +4137,8 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 	if (stmt->log.prefix->etype != EXPR_LIST)
 		return 0;
 
+	prefix[0] = '\0';
+
 	list_for_each_entry(expr, &stmt->log.prefix->expressions, list) {
 		int ret;
 
-- 
2.41.0

