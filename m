Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C6FC83F1B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjH2M7n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 08:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjH2M7M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA051B9
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzLYHsNnNL2gtqa4P3Qeikd2gTXy9fEHChiGyec1IHw=;
        b=f0U1iYgxLmI2COiCcYmdduwkcS0mhmiNuy2zsWPOAPzanKUozpRebN3pe0ppMs9/aMIQz6
        ccztW2FqyNeRDlevKyuJaRhKONa01TtApKwa0yB/kdgtl6tJmWFbyU5kIBylTYe06ikeav
        aq8WMCxrzYVkB8G2kmpjDtGY7/NoP9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-683-SfUEANZHPmefqVp6PBTHpg-1; Tue, 29 Aug 2023 08:58:23 -0400
X-MC-Unique: SfUEANZHPmefqVp6PBTHpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B7778022E4
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0FCD40C2063;
        Tue, 29 Aug 2023 12:58:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 4/8] evaluate: fix check for truncation in stmt_evaluate_log_prefix()
Date:   Tue, 29 Aug 2023 14:53:33 +0200
Message-ID: <20230829125809.232318-5-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: e76bb3794018 ('src: allow for variables in the log prefix string')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1ae2ef0de10c..77e3838e2692 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4153,7 +4153,7 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	if (len == NF_LOG_PREFIXLEN)
+	if (len == 0)
 		return stmt_error(ctx, stmt, "log prefix is too long");
 
 	expr = constant_expr_alloc(&stmt->log.prefix->location, &string_type,
-- 
2.41.0

