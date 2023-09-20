Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218F5C04FF7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjITUK1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjITUK0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:10:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3EDA9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695240574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XPksKzKd8fUHiNeb/PQtP6pgsKXOHP1pr59DfLalTD8=;
        b=iaKeEAqbnYv4K2FpXObViIo7IwTQljk3HNrSE3Yy232M2vsb5+8fGfvcBzZaX6SoBCIJgA
        DZlAEQPVlze4r4fRS/Yf/Da18R4LxVYY6lN1zAGSAnw8kyhjN6rl+D9zxjUxZeQB2IRkbz
        jMAhXyZpPkVeZlz+IuXGE3I10kNAv7c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-682-37uC8hMNO0-nE0S31Hk3Ew-1; Wed, 20 Sep 2023 16:09:33 -0400
X-MC-Unique: 37uC8hMNO0-nE0S31Hk3Ew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6794B38041DB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 20:09:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9875140E950;
        Wed, 20 Sep 2023 20:09:32 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] datatype: return const pointer from datatype_get()
Date:   Wed, 20 Sep 2023 22:09:19 +0200
Message-ID: <20230920200922.867334-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"struct datatype" is for the most part immutable, and most callers deal
with const pointers. That's why datatype_get() accepts a const pointer
to increase the reference count (mutating the refcnt field).

It should also return a const pointer. In fact, all callers are fine
with that already.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h | 2 +-
 src/datatype.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 4e838a38b34f..09a7894567e4 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -174,7 +174,7 @@ struct datatype {
 
 extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
-extern struct datatype *datatype_get(const struct datatype *dtype);
+extern const struct datatype *datatype_get(const struct datatype *dtype);
 extern void datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void __datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
diff --git a/src/datatype.c b/src/datatype.c
index 8d65ab8bcd7f..f5d700bd8d21 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1211,7 +1211,7 @@ static struct datatype *datatype_alloc(void)
 	return dtype;
 }
 
-struct datatype *datatype_get(const struct datatype *ptr)
+const struct datatype *datatype_get(const struct datatype *ptr)
 {
 	struct datatype *dtype = (struct datatype *)ptr;
 
-- 
2.41.0

