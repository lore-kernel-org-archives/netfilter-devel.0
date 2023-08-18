Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED9FC71156
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377808AbjHROfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377524AbjHROen (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2788E2D4A
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692369241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BSKNyio/qSxrI2nSMIw1KKZlbouGiZ9nJSbJt2GXWmI=;
        b=Oh0hqHHOFI9cK6I2EHwI0PRjgW1jhGpH9xe0fTqpaskDYXOZ8anmKQ7eKxMyK9pV+SJcgL
        imSPlb/lvD+X3XrBeg3Fxa3R3k9ewL3c5FD6e/wmRwMFR+AZCrtad/qBONfsKJXKayR4VW
        3st0+fL6gyH47pOqSR7l85sbVXLxsHA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-t0LTuJrjO269UU-AVUv9uA-1; Fri, 18 Aug 2023 10:33:59 -0400
X-MC-Unique: t0LTuJrjO269UU-AVUv9uA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21E49101A52E
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 14:33:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 946202026D68;
        Fri, 18 Aug 2023 14:33:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH] json: use strtok_r() instead of strtok()
Date:   Fri, 18 Aug 2023 16:33:21 +0200
Message-ID: <20230818143348.874561-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

strtok_r() is probably(?) everywhere available where we care.
Use it. It is thread-safe, and libnftables shouldn't make
assumptions about what other threads of the process are doing.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/json.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/json.c b/src/json.c
index a119dfc4f1eb..366c0edf485d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -69,8 +69,9 @@ static json_t *set_dtype_json(const struct expr *key)
 {
 	char *namedup = xstrdup(key->dtype->name), *tok;
 	json_t *root = NULL;
+	char *tok_safe;
 
-	tok = strtok(namedup, " .");
+	tok = strtok_r(namedup, " .", &tok_safe);
 	while (tok) {
 		json_t *jtok = json_string(tok);
 		if (!root)
@@ -79,7 +80,7 @@ static json_t *set_dtype_json(const struct expr *key)
 			root = json_pack("[o, o]", root, jtok);
 		else
 			json_array_append_new(root, jtok);
-		tok = strtok(NULL, " .");
+		tok = strtok_r(NULL, " .", &tok_safe);
 	}
 	xfree(namedup);
 	return root;
-- 
2.41.0

