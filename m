Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830D7C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BDF60F3A
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbhHaIDN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 04:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbhHaIDI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 04:03:08 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB875C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s29so9476961pfw.5
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eg5HeDfStd42EIsCcXwMiHLGLJNQ61qzk/pogiDnUAo=;
        b=Eve95jJIVI/0wknfXq2KVygTiFBwQ7q5ct8BFW5Mt0eW0Ke79rmOjNTFOR1eGCIwm1
         pmxYmRD5gm5cYo522XekUlgox/ryJdhr/XC6AY5U+Bbtacf14vNyMGzwiOlCJ4c0+S1w
         MhIqquuM2fwhPN+ObzHpvgHgzwTG+SUo8MbNzgtUJ3oeb+bI7PGNUj2/kFbnpA6KRD+V
         CrlN7K95fnigZPa+3BHgbGC7EqTdmVm04RwBzALpxJJXWks6FN0k0eZFPEa5PMHqTJ/J
         fyaBfNI/pS18jOJAApTixBy7K98CExUBvg9qt8+wp+e/I7zlLvkPkBPIA17tCoLi0BMD
         eubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Eg5HeDfStd42EIsCcXwMiHLGLJNQ61qzk/pogiDnUAo=;
        b=OWyrI2Xmcl4JYPiboz2DdnT91m3T9/44Hwywc7/Hvr152cYlU37HC6iN6op/tcXnY/
         wDVTlDPvysrkIxalPRZb/JQmRfLYl+tRJJmQWtz3jbgG9NSg6flHf8EUU6an86N/9CdP
         aeYY1O0d2q1X5bY/aIaho4p17eHx7tCKIUEIxpDRLtqiJPwdh6AuY7B5+ZaTCGZbhRg6
         ex0t7h3Gm+ws6hG+mbLB5u5CWNRDeNVsQIAQJM/QPLW9Afm30YAZdDZbKIK+P1/5Iwq0
         NePp5V6wtIW52x3KDYmmmdaqWtCcCJlnK3NSWMnfIjJV2YDLgBJc1M51Y21B2wryPAR4
         5DyA==
X-Gm-Message-State: AOAM531y+Son/AJM0N3ryCZRm1ZgT1l1LCrIcOZ/QOJzljm77ZIW3L9c
        IW/T38zzMYWuaTOhMoXmTJH/LnrB3oQ=
X-Google-Smtp-Source: ABdhPJx0gFMmkIsQAO84T0RZuyPVVaVWVIt1944gYYqB4K4LhKEo6uC6dxdb4+piTHE1shJhValcWg==
X-Received: by 2002:a63:e214:: with SMTP id q20mr25761187pgh.134.1630396932531;
        Tue, 31 Aug 2021 01:02:12 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r2sm1459047pgn.8.2021.08.31.01.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 01:02:12 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 3/3] build: doc: remove trailing whitespace from doxygen.cfg.in
Date:   Tue, 31 Aug 2021 18:02:00 +1000
Message-Id: <20210831080200.19566-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
References: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index b4bd3a7..dc2fddb 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -2,7 +2,7 @@
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
 OUTPUT_DIRECTORY       = doxygen
-ABBREVIATE_BRIEF       = 
+ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
@@ -13,7 +13,7 @@ EXCLUDE_SYMBOLS        = nflog_g_handle \
 			 nflog_handle \
 			 ipulog_errmap_t \
 			 ipulog_handle
-EXAMPLE_PATTERNS       = 
+EXAMPLE_PATTERNS       =
 SOURCE_BROWSER         = YES
 ALPHABETICAL_INDEX     = NO
 GENERATE_LATEX         = NO
-- 
2.17.5

