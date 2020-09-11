Return-Path: <SRS0=5Db6=CU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CCBC433E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Sep 2020 17:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDAE221E7
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Sep 2020 17:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AycPE1Dn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIKRfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgIKRfJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Sep 2020 13:35:09 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E3AC061573
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2020 10:35:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r9so11929914ioa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2020 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YvYePp0vEfOogFa/3fd3NYeppmWbW5tk/Wiz9lMtMqw=;
        b=AycPE1Dn98zjEg6BmmEzIOjKjFGAmyQAVWJ8fUoTmdDzb9K7qcvo8xEMtxbbNXEGJg
         i63KAD3P5P0LoQ2Z6pBryR2w0/WtLCFm0TYKpAUfHC9oqWJVtRTFLw2gQ+11yB7apkk1
         VnRjxJVSKk3BrvZ5elk980dHn8Sp3Jizv4kWAVxCH0ZNEvmAqdRbjhApYeH0mjEqWqZf
         +aSRlWXUOqLSJbaDMSxubujqAvRcGiBLu+mac2fjXXHWaKiL4QCYTV9grO+w5cf+1G5c
         3R8Kj8t5pdK8JfgGcCphaW0yqckTUY3uNwsYmVAsv7DVFRm5K1oNl7jtgygaZXMYINx8
         s+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YvYePp0vEfOogFa/3fd3NYeppmWbW5tk/Wiz9lMtMqw=;
        b=SK2Bs2Z11f13F4NeDgGGx8G+YB0vFsOuurrtXAGNIgSwEAHKTsUBswLhw4iu8XkjJj
         Jpo2tNq5xrdskVa4gUdwpYMqKEb0aiepozp4LkhtI8jC8LrlwfVzutzKiVoUtMH60nln
         4falNZMbPh4sDPt1I6BGSpIRwuX7N1uHwVGRc73sy5c+SaVCzV3rxO6RufphqXJTpUXs
         0ttV6I2OkEZm5P2GssxdK5fs76kpEUDWdarqeit4/4Y9kG5hkstQZp00nZ3TiZ2CFi6n
         S9Tzo22JDzuH1xZLa2f4fJgBcrsNVHVR7SSUCxLcybA6ebNvgAvujluPpMF1QlzN8Lz7
         jRaw==
X-Gm-Message-State: AOAM530Yl0tOqWR0gSXQZSUgsPkjxRG2HYoRuuHWsP7qhC/w/X15J40y
        LALS3iDAq7lRcZ1Z900Hfl8lcCJPw7gCvG0QMRmTqCL5TJM=
X-Google-Smtp-Source: ABdhPJxhoHps0nOTreY7UiWhPv/78UxOn8cvA1ylBJkR2vQ3/lEmjhaSpP0YyIWHI5bT6VqwPoM9nsJs/URcNyS69BQ=
X-Received: by 2002:a02:9086:: with SMTP id x6mr3040766jaf.126.1599845707884;
 Fri, 11 Sep 2020 10:35:07 -0700 (PDT)
MIME-Version: 1.0
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Fri, 11 Sep 2020 23:04:57 +0530
Message-ID: <CAAUOv8iVoKLZxx1xGVLj-=k4pSNyES5SWaaScx=17WV789Kw3Q@mail.gmail.com>
Subject: [PATCH] Solves Bug 1388 - Combining --terse with --json has no effect
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Solves Bug 1388 - Combining --terse with --json has no effect

Signed-off-by: Gopal Yadav <gopunop@gmail.com>
---
 src/json.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index a9f5000f..702cf6eb 100644
--- a/src/json.c
+++ b/src/json.c
@@ -147,7 +147,8 @@ static json_t *set_print_json(struct output_ctx
*octx, const struct set *set)
         list_for_each_entry(i, &set->init->expressions, list)
             json_array_append_new(array, expr_print_json(i, octx));

-        json_object_set_new(root, "elem", array);
+        if (!(octx->flags & NFT_CTX_OUTPUT_TERSE))
+            json_object_set_new(root, "elem", array);
     }

     return json_pack("{s:o}", type, root);
-- 
2.20.1
