Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9868E82CCC
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjI0UCr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI0UCq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E52410E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4uoDgQZ9loIRgkRJbUYDfJ+YeZKQ9gYnUT7Y6BARMs=;
        b=QtsyJP8yC7DJrQF7UmKD80efdwHQYMRJDPNlCdt9EQlJtvMFuNZUBETpVbVkq/Ix8ZILsC
        AsQ5P07zbGarAgOUXTtmgDQKcAxn77JSY8umeGesU9mfnwxEvOFf05NAaBAaM+c3h/vTao
        qWMe/mAhnnWKHweMPeY24drohZvViW0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-AXaTIj3hMi6PZUjG0XOkjQ-1; Wed, 27 Sep 2023 16:01:57 -0400
X-MC-Unique: AXaTIj3hMi6PZUjG0XOkjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9C041C00BBC
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 690DF40C6EA8;
        Wed, 27 Sep 2023 20:01:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/5] datatype: don't clone static name/desc strings for datatype
Date:   Wed, 27 Sep 2023 21:57:25 +0200
Message-ID: <20230927200143.3798124-3-thaller@redhat.com>
In-Reply-To: <20230927200143.3798124-1-thaller@redhat.com>
References: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid cloning static strings for "struct datatype". With
concat_type_alloc(), the name/desc are generated dynamically and need to
be allocated. However, datatype_clone() only reuses the original
name/desc strings. If those strings are static already, we don't need to
clone them.

Note that there are no other places that also want to change or set the
name/desc. If there were, they would need to handle the new fact that
the strings may or may not be dynamically allocated.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h |  2 ++
 src/datatype.c     | 15 ++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index b53a739e1e6c..465ade290652 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -132,6 +132,7 @@ struct parse_ctx;
  * @f_prefix:	preferred representation for ranges is a prefix
  * @f_alloc:	whether the instance is dynamically allocated. If not, datatype_get() and
  *		datatype_free() are NOPs.
+ * @f_allocated_strings: whether @name and @desc are heap allocated or static.
  * @name:	type name
  * @desc:	type description
  * @basetype:	basetype for subtypes, determines type compatibility
@@ -153,6 +154,7 @@ struct datatype {
 	enum byteorder			byteorder;
 	bool				f_prefix:1;
 	bool				f_alloc:1;
+	bool				f_allocated_strings:1;
 
 	const char			*name;
 	const char			*desc;
diff --git a/src/datatype.c b/src/datatype.c
index 464eb49171c6..1c557a06c751 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1244,8 +1244,10 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 
 	dtype = xzalloc(sizeof(*dtype));
 	*dtype = *orig_dtype;
-	dtype->name = xstrdup(orig_dtype->name);
-	dtype->desc = xstrdup(orig_dtype->desc);
+	if (orig_dtype->f_allocated_strings) {
+		dtype->name = xstrdup(orig_dtype->name);
+		dtype->desc = xstrdup(orig_dtype->desc);
+	}
 	dtype->f_alloc = true;
 	dtype->refcnt = 1;
 
@@ -1265,8 +1267,10 @@ void datatype_free(const struct datatype *ptr)
 	if (--dtype->refcnt > 0)
 		return;
 
-	xfree(dtype->name);
-	xfree(dtype->desc);
+	if (dtype->f_allocated_strings) {
+		xfree(dtype->name);
+		xfree(dtype->desc);
+	}
 	xfree(dtype);
 }
 
@@ -1299,7 +1303,8 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	dtype		= datatype_alloc();
 	dtype->type	= type;
 	dtype->size	= size;
-	dtype->subtypes = subtypes;
+	dtype->subtypes	= subtypes;
+	dtype->f_allocated_strings = true;
 	dtype->name	= xstrdup(name);
 	dtype->desc	= xstrdup(desc);
 	dtype->parse	= concat_type_parse;
-- 
2.41.0

