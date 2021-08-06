Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9DDC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E4A61184
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbhHFCPg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 22:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbhHFCPf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 22:15:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E1CC061798
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Aug 2021 19:15:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so14353170pjb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Aug 2021 19:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yBGYXL7YmoxxBREdkDx5zOe2/71yrnTjQFist4rsdB0=;
        b=CoAvCJlgF2atsP1dlCdOtZKvo+1f93ZiTEWFI4e5v0Wm7+cPxn9jXAtcuwWnExqk22
         NFgTtCb5RsQejOv9ajJ/5XuL6frQr17LOeclOvLuh3106FDsuq6iXrNiWOIIdhDDYk5M
         p3Lu/vYeCxMOUcCftY3/velC2LuUfLzp08xC+PWD8SZHjxfJY4irLYx2IkbKcdNqIE5p
         IlpjcxAFsB7uwL7rfbhnR43fLJm1GbvaeBvHUwzTdH5MURPMw7d7VNYXXe2V9QkUAIYw
         Q4pe9SAP6pVHPkB9zadhNc0P0hL/gBdjtioH09kik1Dwn0qG4YSNV97NeHXKYOMKDd2f
         JSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=yBGYXL7YmoxxBREdkDx5zOe2/71yrnTjQFist4rsdB0=;
        b=q94I8ZmPAOpMLDa3y3ooSYLOykSI2ojluqCH12jCE0lVcT+RaZg9QkrmPEuzBAmZvf
         kyp9Xhnt6AcFwfhYEAzfo3FsEpE6AxGAMIXcWYa3BCdmzinKW2/VcIoimCtuiVY1kUdr
         F5yDQkhauXBbxazCoXbwawE4PzvaRcIO+4JBCyJVJ1nXWEZjAhQipBi0gpQe3lN0eeOT
         CWUbS6yZFaMaQZctXLN+SQc6wHo8YfcBw5GZBrJq8z3qg8PvYRULCOP1Y+6LRuPDYo/Q
         vPNW2Yym61T4GNZ1lho0/hRC/wEeIMqVOHi6u77HVjo7SwmzTcDJXFi4UEOVEMc+Y9mO
         v/KQ==
X-Gm-Message-State: AOAM533OE7cKv9lov5dmyBYL1wwCH3RRcgniBM7iy8e8JiJeKv1MzdeP
        pCvFBUjiaVzpD/Q/s3ciV6VkTVWtqagBTg==
X-Google-Smtp-Source: ABdhPJwrFsYaibbJ2fM0s0QiTtqoFvy3oANINrw1hiSfpmXlaDSptO8TX4jJHWvgL9V84aD7s+S/dA==
X-Received: by 2002:a62:3896:0:b029:33a:f41a:11a4 with SMTP id f144-20020a6238960000b029033af41a11a4mr8213625pfa.9.1628216119275;
        Thu, 05 Aug 2021 19:15:19 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id k5sm8067739pfi.55.2021.08.05.19.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 19:15:18 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: Stop users from accidentally using legacy linux_nfnetlink_queue.h
Date:   Fri,  6 Aug 2021 12:15:13 +1000
Message-Id: <20210806021513.32560-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a user coded
  #include <libnetfilter_queue/libnetfilter_queue.h>
  #include <linux/netfilter/nfnetlink_queue.h>
then instead of nfnetlink_queue.h they would get linux_nfnetlink_queue.h.
In the library, this only affects libnetfilter_queue.c

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/libnetfilter_queue.h | 2 --
 src/libnetfilter_queue.c                        | 1 +
 utils/nfqnl_test.c                              | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index a19122f..42a3a45 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -16,8 +16,6 @@
 #include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
 
-#include <libnetfilter_queue/linux_nfnetlink_queue.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ef3b211..899c765 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -32,6 +32,7 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/linux_nfnetlink_queue.h>
 #include "internal.h"
 
 /**
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 5e76ffe..682f3d7 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -5,6 +5,7 @@
 #include <netinet/in.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>		/* for NF_ACCEPT */
+#include <linux/netfilter/nfnetlink_queue.h>
 #include <errno.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
-- 
2.17.5

