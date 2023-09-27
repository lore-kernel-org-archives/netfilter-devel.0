Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB03E82CCC
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjI0UCo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjI0UCn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B46114
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q73ylzHrw8q8wYBZ7ABaz6/wz5xUZOgQ2psHtD+omfg=;
        b=iCFzVkE3nF47oaamEglslJWV5o/RzIhckeTk1zqRYPkBCTn9MhLWMWLWkDMpmTReL0Vcw6
        AxftX+Lflawh1JHYrn45uij8iS4vrfY3R3arjG3rgKJ5lxFyqOxfu/Hrfq1RVaIKQc+T0m
        we61o6FbblIVb6BHMsq+y+/2thdUctk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-UqAHs7CEPvmKeno-brolzg-1; Wed, 27 Sep 2023 16:02:00 -0400
X-MC-Unique: UqAHs7CEPvmKeno-brolzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4292E8002B2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B557940C6EA8;
        Wed, 27 Sep 2023 20:01:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/5] datatype: use xmalloc() for allocating datatype in datatype_clone()
Date:   Wed, 27 Sep 2023 21:57:28 +0200
Message-ID: <20230927200143.3798124-6-thaller@redhat.com>
In-Reply-To: <20230927200143.3798124-1-thaller@redhat.com>
References: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The returned memory will be initialized. No need to zero it first. Use
xmalloc() instead of xzalloc().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index f9570603467a..eae7f4c71fbe 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1242,7 +1242,7 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 {
 	struct datatype *dtype;
 
-	dtype = xzalloc(sizeof(*dtype));
+	dtype = xmalloc(sizeof(*dtype));
 	*dtype = *orig_dtype;
 	if (orig_dtype->f_allocated_strings) {
 		dtype->name = xstrdup(orig_dtype->name);
-- 
2.41.0

