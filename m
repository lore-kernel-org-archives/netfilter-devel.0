Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F7FC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D5264E00
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhA2V0F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhA2VZ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:25:56 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9880CC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b21so12207871edy.6
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RGh4mz8ZXFBKwd43+b+GHgUwisbvAkJPCYSh5f3W4SM=;
        b=hJFTbcny79Q9yYw4c1yH2NUc9+bNuJZwnDW9FJy/su8L+o1bNc9FUKYkr/iJAISOuh
         zouGLpR1whPyoOHamPBmO+bmeWn4eFMIYQ00fpNpSpCyHpGm2oUmWYYuCt2uXrpVomzk
         8xQIq2yn2Ek0z0DAuMULH59RpR+RyEhnLSDK0wtC42bJzQWyYZNLpgbKqZDBGC+uXxrt
         btZSIHZWAcNZRstAr75MC9uoMluJrR2RSraLMdYalgeZBB7hpMWrByHGoHp1CayOOE+q
         0hkWrAs5FgiSnHLrBzT6PeBBypf6iVVmWcJH0nIHuekD7ZX6V1kwpcZuBK3kQrml40HU
         g0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RGh4mz8ZXFBKwd43+b+GHgUwisbvAkJPCYSh5f3W4SM=;
        b=KzbRvtdyfqtO/v+Iw4G02JGMhQYyLfB5E2EhUNRolVFyEb8zDoWfMhFb4veCnQTRRb
         cSMAGrXuMiNHPHAItCwU4yG9AIEzIQRXH4aa4YQXs/hQFLSh3IBLS2sCgvW8Mft60Qhx
         lGAn19oLMC+2u/m5Vi4S9oCqEPssvZE23k8SlyQmXHX3/EuBl9dJxl3RnTylJTtKj4Q2
         avouFr4S07RlH90PsLLSTmb7Ah2Ke3G2lIatlTYnI15eW2rHXeX0LBKfOCu4dAmmn6eJ
         aFO4W8mXxFmyGdR9jHGeDuJVJwBOWto7h5L5KfyZ5VHMQcixCp0qNbu1S2tMpSUJhm8r
         kFkA==
X-Gm-Message-State: AOAM532yoTJc2PtEf7E5lReZ2I7ik7nBcAtRGKmydeJ9WpOUH0qfsB8r
        /323y4EVK4eG3/wbgbShdmEEcWmPNKqfaA==
X-Google-Smtp-Source: ABdhPJwU4XCuoK/YFU5rvZhCdNwFcTuazx8g34P6/pk8Uf7Y6OeqMf/dSqXpTBEyYRCGV239xZ3d6Q==
X-Received: by 2002:aa7:de10:: with SMTP id h16mr7417125edv.385.1611955515219;
        Fri, 29 Jan 2021 13:25:15 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:14 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 1/8] conntrack: reset optind in do_parse
Date:   Fri, 29 Jan 2021 22:24:45 +0100
Message-Id: <20210129212452.45352-2-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a multicommand support preparation reset optind
for the case do_parse is called multiple times

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index 987d936..c582d86 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2798,6 +2798,8 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
+	/* reset optind, for the case do_parse is called multiple times */
+	optind = 0;
 
 	while ((c = getopt_long(argc, argv, getopt_str, opts, NULL)) != -1) {
 	switch(c) {
-- 
2.25.1

