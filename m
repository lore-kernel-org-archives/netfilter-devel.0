Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C47DC07E95
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 05:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E524261220
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 05:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhGDFtu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Jul 2021 01:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhGDFtu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jul 2021 01:49:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C47C061762
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Jul 2021 22:47:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso12391417pjb.3
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Jul 2021 22:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQMxFPPHsV22G/K3kmBGuA0DEx99PB82wrLfYaFC6aM=;
        b=QK38sedjOFaugJljmKGqOuPKldlIPayuJF4Cqfg9ZMbJgVHOh5b2G4OWQkAheBZ0+M
         JzvFH8SgctyG2zZoAhrxHGZ5EWxuCCbaSyxQfO3vIJVT9XEll7flR/CY/koEpB2cCKRs
         pZPeD/flBALAnWl01dAe/6btDfGRf3Mmbmp/1H2FY9Zw6BQYiAmGbpREPNSf6mjwBEbl
         a3lVHI0Ua1Pd9gWda5DUXyLv4csSgrnKw5O8MM6KAMJSw7LiBn0hgBKQ1iGywdqQF4C3
         x7bArsOBqFnT4umFwA4gvCi+FtPnE8xfvZweCMl8fLNwfUOYNOLOLqZR/WdxdrYUpIpq
         9vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=mQMxFPPHsV22G/K3kmBGuA0DEx99PB82wrLfYaFC6aM=;
        b=MZ0+1GeqtHGvTzD58GnHlq8uh7TO2j41zn0gMP+vGH5ggZETMrKlVrZBb0w18NxxQH
         G4Gc134m+MUB8S+It44Zkuh4Oc44HVH/9k7B+PsFDMkoDxxURbaT1DyyCEGYkKdjDos4
         UZSg1t8CkH38+PVuDeo8FIz8wwa4fv4v8dekTYSL5SlsZglN5J/479U7V71ey29Uc1aW
         qJ6CuGecgSQO+A9BFTX9/pKqgxax8p+F4fZL/i7NlOC3AbwqBc1HMiLT1F5R7SM8XRT3
         uFFwZj8mtekRsZ6Q+J/Opf5TQShGSlDMx+GvON15vnopbYNUp5x0V205zWkVZ39XEc/M
         aGxw==
X-Gm-Message-State: AOAM531hDkxMeuiur346uHwr/TsAPJwCSXP8Mvjs2HnfAG2msxu6orsq
        3v/oDTz7SnHqHHsJ7w5FpAnYD07bHYo=
X-Google-Smtp-Source: ABdhPJxrIpYh9fFkWH2/H/i+Si15G9y8TaqoQfsIQmoVdIeWGUuBSJzO644gnBG+BVc88pMrrFT7zw==
X-Received: by 2002:a17:902:864c:b029:10d:8c9e:5f56 with SMTP id y12-20020a170902864cb029010d8c9e5f56mr6871111plt.8.1625377633753;
        Sat, 03 Jul 2021 22:47:13 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n59sm16700190pji.46.2021.07.03.22.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 22:47:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: annotation: Correctly identify item for which header is needed
Date:   Sun,  4 Jul 2021 15:47:08 +1000
Message-Id: <20210704054708.8495-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..7d34081 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -15,7 +15,7 @@
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
-/* only for NFQA_CT, not needed otherwise: */
+/* only for CTA_MARK, not needed otherwise: */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static struct mnl_socket *nl;
-- 
2.17.5

