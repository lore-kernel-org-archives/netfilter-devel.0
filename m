Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2FFC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 03:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AD6260F22
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 03:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbhIFDIA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Sep 2021 23:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbhIFDIA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Sep 2021 23:08:00 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF37C061575
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Sep 2021 20:06:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r2so5316323pgl.10
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2021 20:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ql6e+DZIpY5JprOB0mZute+zqfxFV19m9QFQJBQ4vTA=;
        b=C0dsxfsgaaizd87XDHybe15y7znmOXBhstHhk1C0RURV0yV6gIV/4vmMcDR4yWqiCg
         UTs0ydOKM7TvarvOaP08MR145PAN+ksc/KRvlWha4IxkgMYzClXI0JBV4KXyZGqFWuNd
         fC5h7nEpA5kuq4dsRvGD4mAwc8OGtcUfreRASk9de0r3rqF5Ru5GpvrZF32iTvlj3oU8
         saZjuTupDC+28Ye6oBbtfpM3V9dWlr7TdXZIolDBvgHbtGfCyMJ/tJsvC48Tx7oEWuK+
         NDPvh90dJdaM2nCrORJG3bP3LifHNmVrgv5cym9B89XMtaTa4TsJWfSV5PpcnvGEyM7Z
         c7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ql6e+DZIpY5JprOB0mZute+zqfxFV19m9QFQJBQ4vTA=;
        b=Xyx/2KBMvJUhXwzR8wm8xSuM2h/zhl7kwwqv+pPwyzdGnDer9ROaY9avEUSQsXrdZZ
         uD1thr+dsAsa9ZeUHFrxy6Je4KIsqqzoEjFZTma0Xyo7LdlzsamT1VCsmERmCzKTX89p
         MVF9NQgt0vta3WOK2dwPqpdqdRovajO5l8O08/TzuP90bSKcuw+r5fR034e9vf4Ty4MA
         lUfsA4sxxeeJ9NLnM8QjD3/iWZIJhJTpHyql7KokfbUtBtc5VA6i8PitE+Fof7DVs14z
         3Fpc/LqTQekx6AVIOnJqv0V60oZ8KABh8Fg9T9TamTXc7xpbf2VaiT89n9Tuhxj5ok5A
         O3WQ==
X-Gm-Message-State: AOAM5320Xp/+F5+hpdz1g9g7RLsk6aOOAOFuhyfOr/Nqq3FIHbxtTpC0
        bJQ4TVykwWZnFNtfRIcVmVSHbKfuePz/fA==
X-Google-Smtp-Source: ABdhPJyN9FvTu1wnTTN8QiBsGJ+fHNxhHJFJU6SSCYebYhjozvBQCXscPpyB5zTX5sz6V/7R7A44kg==
X-Received: by 2002:a63:f40b:: with SMTP id g11mr10169242pgi.401.1630897615838;
        Sun, 05 Sep 2021 20:06:55 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id n21sm5641090pfo.61.2021.09.05.20.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 20:06:55 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH nft] src: Check range bounds before converting to prefix
Date:   Mon,  6 Sep 2021 11:06:41 +0800
Message-Id: <20210906030641.10958-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The lower bound must be the first value of the prefix to be coverted.
For example, range "10.0.0.15-10.0.0.240" can not be converted to
"10.0.0.15/24". Validate it by checking if the lower bound value has
enough trailing zeros.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 src/netlink.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index cbf9d436..0fd0b664 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1079,12 +1079,15 @@ struct expr *range_expr_to_prefix(struct expr *range)
 
 	if (mpz_bitmask_is_prefix(bitmask, len)) {
 		prefix_len = mpz_bitmask_to_prefix(bitmask, len);
-		prefix = prefix_expr_alloc(&range->location, expr_get(left),
-					   prefix_len);
-		mpz_clear(bitmask);
-		expr_free(range);
-
-		return prefix;
+		if (mpz_scan1(left->value, 0) >= len - prefix_len) {
+			prefix = prefix_expr_alloc(&range->location,
+						   expr_get(left),
+						   prefix_len);
+			mpz_clear(bitmask);
+			expr_free(range);
+
+			return prefix;
+		}
 	}
 	mpz_clear(bitmask);
 
-- 
2.33.0

