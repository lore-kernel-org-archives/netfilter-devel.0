Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73050C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbjH2S4s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbjH2S4T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A7CC2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xbEMYP/QUKi9kXT1lmDwknMchtq+7r+473ybEs90Qk=;
        b=BJn+68GtSewWXZ0RFIL3gWhXmvPdy4hG8QpqtJ/ri4JDGHx3LsYHn7bpIw97yoiPNGmC05
        klP3q01gmZFv+XGWCExLlIDJpm8ejV1pCkkKEkEp+smTu9j/+vEbp+cecrJtXP96MFhadH
        QQQngzpfkyJc8slohI9YhQDn3mMcMfI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-6mAVTq7JNh2PtGVIBvIcvw-1; Tue, 29 Aug 2023 14:55:29 -0400
X-MC-Unique: 6mAVTq7JNh2PtGVIBvIcvw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF3E180027F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FE65401051;
        Tue, 29 Aug 2023 18:55:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/5] datatype: check against negative "type" argument in datatype_lookup()
Date:   Tue, 29 Aug 2023 20:54:11 +0200
Message-ID: <20230829185509.374614-6-thaller@redhat.com>
In-Reply-To: <20230829185509.374614-1-thaller@redhat.com>
References: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An enum can be either signed or unsigned (implementation defined).

datatype_lookup() checks for invalid type arguments. Also check, whether
the argument is not negative (which, depending on the compiler it may
never be).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index ba1192c83595..91735ff8b360 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -87,7 +87,7 @@ const struct datatype *datatype_lookup(enum datatypes type)
 {
 	BUILD_BUG_ON(TYPE_MAX & ~TYPE_MASK);
 
-	if (type > TYPE_MAX)
+	if ((uintmax_t) type > TYPE_MAX)
 		return NULL;
 	return datatypes[type];
 }
-- 
2.41.0

