Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED702CE79DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbjITObD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbjITObC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10FAB9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cah2JVI8LEH8SjEsNbCsf7t40Gy6p94z5RvSKfDzYjk=;
        b=CV4tHCjv/6AgUzViacxmGKmOY7L7FRsG9nbySrrfV+mMxwUvnEqAvaS4cd/CSYi52xuQCv
        +YABhqZ0zRTDOkcOyL0pYLoPnpMV5e/bfyBaCZwqFEduhGUSgGpabzeGJ23AnnmLaZ7mK0
        t47+H7m08L5gm4k/BIWwWAiuMOgugFA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-P6tnM-j7NSKN5gxJyHIxwg-1; Wed, 20 Sep 2023 10:30:11 -0400
X-MC-Unique: P6tnM-j7NSKN5gxJyHIxwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23180185A78E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 462C91006B72;
        Wed, 20 Sep 2023 14:30:10 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/9] src: fix indentation/whitespace
Date:   Wed, 20 Sep 2023 16:26:02 +0200
Message-ID: <20230920142958.566615-2-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/meta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index d8fc5f585e74..181e111cbbdc 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -968,8 +968,8 @@ struct stmt *meta_stmt_alloc(const struct location *loc, enum nft_meta_keys key,
 	stmt->meta.key	= key;
 	stmt->meta.expr	= expr;
 
-        if (key < array_size(meta_templates))
-                stmt->meta.tmpl = &meta_templates[key];
+	if (key < array_size(meta_templates))
+		stmt->meta.tmpl = &meta_templates[key];
 
 	return stmt;
 }
-- 
2.41.0

