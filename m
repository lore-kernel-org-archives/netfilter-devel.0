Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3CFE82CCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjI0UCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjI0UCs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:02:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E76611D
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pAQyOebgcJoENGEftU+qtV6q4yx2qCBobs/aJO3PDNo=;
        b=JF2z4gvnExsI3eQ3aEDl8yG9UYoo+wIUNlhmHwhlN23t5lAWZPl5TCPyNZvLO90LwSni8f
        fEw/7b8O7nioDyAQGR0780IgHg302lomVYLrw0JTBZLYnSgF3ywIXTgxkkTd87EdIl0Jgx
        G4hd6fxBkcWN4H6nGE81Sw6QHZD0NNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-TRZ8XNY-MyCaWelBKMylWA-1; Wed, 27 Sep 2023 16:01:58 -0400
X-MC-Unique: TRZ8XNY-MyCaWelBKMylWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B206E1019C88
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 20:01:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30F3A40C6EA8;
        Wed, 27 Sep 2023 20:01:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/5] datatype: don't clone datatype in set_datatype_alloc() if byteorder already matches
Date:   Wed, 27 Sep 2023 21:57:26 +0200
Message-ID: <20230927200143.3798124-4-thaller@redhat.com>
In-Reply-To: <20230927200143.3798124-1-thaller@redhat.com>
References: <20230927200143.3798124-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"struct datatype" instances are treated immutable and not changed after
creation.  set_datatype_alloc() returns a const pointer, indicating that
the caller must not modify the instance anymore. In particular it must
not, because for non-integer types we just return a reference to the
(already immutable) orig_dtype.

If the byteorder that we are about to set is already as-requested, there
is no need to clone the instance either. Just return a reference to
orig_dtype() too.

Also drop the same optimization from key_fix_dtype_byteorder().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c |  6 +++++-
 src/evaluate.c | 19 +++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 1c557a06c751..6a35c6a76028 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1321,9 +1321,13 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 	if (orig_dtype != &integer_type)
 		return datatype_get(orig_dtype);
 
+	if (orig_dtype->byteorder == byteorder) {
+		/* The (immutable) type instance is already as requested. */
+		return datatype_get(orig_dtype);
+	}
+
 	dtype = datatype_clone(orig_dtype);
 	dtype->byteorder = byteorder;
-
 	return dtype;
 }
 
diff --git a/src/evaluate.c b/src/evaluate.c
index c699a9bc7b86..e84895bf1610 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -74,17 +74,8 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 	return -1;
 }
 
-static void key_fix_dtype_byteorder(struct expr *key)
-{
-	const struct datatype *dtype = key->dtype;
-
-	if (dtype->byteorder == key->byteorder)
-		return;
-
-	__datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
-}
-
 static int set_evaluate(struct eval_ctx *ctx, struct set *set);
+
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     struct expr *key,
@@ -95,8 +86,12 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct set *set;
 	struct handle h;
 
-	if (set_is_datamap(expr->set_flags))
-		key_fix_dtype_byteorder(key);
+	if (set_is_datamap(expr->set_flags)) {
+		const struct datatype *dtype;
+
+		dtype = set_datatype_alloc(key->dtype, key->byteorder);
+		__datatype_set(key, dtype);
+	}
 
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
-- 
2.41.0

