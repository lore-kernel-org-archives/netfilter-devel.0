Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEDBC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjKITBl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjKITBj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EF73C12
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699556446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xkxNkzX8gzJb5i2gTJaxU24hsbpH18lBcoVAZmfjAN4=;
        b=epNmlhIfpIxvyjSOXeo/KmT4yF3xCdzvQ3qTGbVu1OZhQ1t/H6FpTTjsLqvbdZ8fvFE6nf
        5Bb0eHqTRAPtRlrN/q27riqZ0eZBgGR6ZoGegZw265cXAeALp5tM1BSszLeXiqQsSiCy7x
        FmWpjJhIoSeEO5pZpCWhv9+EVhL3H9U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-pNZnp71wPDWflDF42R9_ew-1; Thu,
 09 Nov 2023 14:00:44 -0500
X-MC-Unique: pNZnp71wPDWflDF42R9_ew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46373380627C
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 19:00:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A2740C6EB9;
        Thu,  9 Nov 2023 19:00:43 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] parser: use size_t type for strlen() results
Date:   Thu,  9 Nov 2023 19:59:49 +0100
Message-ID: <20231109190032.669575-3-thaller@redhat.com>
In-Reply-To: <20231109190032.669575-1-thaller@redhat.com>
References: <20231109190032.669575-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

strlen() has a "size_t" as result. Use the correct type.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/parser_bison.y | 2 +-
 src/scanner.l      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca0851c915d2..12031c831353 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -150,7 +150,7 @@ static struct expr *ifname_expr_alloc(const struct location *location,
 				      struct list_head *queue,
 				      char *name)
 {
-	unsigned int length = strlen(name);
+	size_t length = strlen(name);
 	struct expr *expr;
 
 	if (length == 0) {
diff --git a/src/scanner.l b/src/scanner.l
index 31284d7358fa..aba8ef1c6b54 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1117,7 +1117,7 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 	ret = glob(pattern, flags, NULL, &glob_data);
 	if (ret == 0) {
 		char *path;
-		int len;
+		size_t len;
 
 		/* reverse alphabetical order due to stack */
 		for (i = glob_data.gl_pathc; i > 0; i--) {
-- 
2.41.0

