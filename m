Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F757CE79D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjITObA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbjITOa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0892DCE
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v1WFp6fDfHducrutMAkxH4TQ/YcOMS0wSwZD/kyQHmU=;
        b=h93o7SpfwHq72mO413VJGJhIx9pvOMTMgnPPJxfozC/wVrPR5HtYm5fiwDdzrTFd2DLITt
        Gj+YmuhbS8tw06Jx76dYYPYhSlI/1ekzyqUvVVpGBonAM/3jY/uE03JGCPtOGIJVXTvUZQ
        hnCFK4Ok1uE5FBcPan1U8iIlQ9uahc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-b_r_hsOHNQO251NfwT839Q-1; Wed, 20 Sep 2023 10:30:14 -0400
X-MC-Unique: b_r_hsOHNQO251NfwT839Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 537AD811E8F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C683610EE859;
        Wed, 20 Sep 2023 14:30:13 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/9] payload: use enum icmp_hdr_field_type in payload_may_dependency_kill_icmp()
Date:   Wed, 20 Sep 2023 16:26:06 +0200
Message-ID: <20230920142958.566615-6-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't mix icmp_dep (enum icmp_hdr_field_type) and the uint8_t icmp_type.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/payload.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index a02942b3382a..cb8edfac0338 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -802,18 +802,16 @@ static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
 static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct expr *expr)
 {
 	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
-	uint8_t icmp_type;
+	enum icmp_hdr_field_type icmp_dep;
 
-	icmp_type = expr->payload.tmpl->icmp_dep;
-	if (icmp_type == PROTO_ICMP_ANY)
+	icmp_dep = expr->payload.tmpl->icmp_dep;
+	if (icmp_dep == PROTO_ICMP_ANY)
 		return false;
 
 	if (dep->left->payload.desc != expr->payload.desc)
 		return false;
 
-	icmp_type = icmp_dep_to_type(expr->payload.tmpl->icmp_dep);
-
-	return ctx->icmp_type == icmp_type;
+	return ctx->icmp_type == icmp_dep_to_type(icmp_dep);
 }
 
 static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct expr *expr)
-- 
2.41.0

