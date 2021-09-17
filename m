Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DD3C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 08:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B69611C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 08:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhIQIqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 04:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbhIQIqq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 04:46:46 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C418C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:45:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q23so6472152pfs.9
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euEV1OrYiCFOluSiSgoFcr2MzIHw4+jUGTYXjRBnOfo=;
        b=o4lI8VTRlOno09FVljTubjsIc3zGAN+CONdvH9LQ9d4g0m9kLsaYfzlNPeocLom11x
         Aq3OKgpd8hYBRRXlRGbb4mgoPhbwK13WCUjmSoIRYik+l6pSYIQVaSANQJAX5rHSAZt5
         1JPcFki6y24yQ4WwmFvJZpqxaYX/E339yKwZRjP97wjuZlZesJ4YoadeOjemRAQQZxwI
         AW0sVLFNVSEu2gghIczcrifq2fC7/vfht7R4V60LPSKGT3xX6liFheX+VCZY5jEC+mlx
         Hy7kCQ+YFt+MBxRXsCAQvdKBL1ROZkXy00kLq9fsWTeyDhoGHPA/Ebt/J8Zmf7yBeCok
         Dvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=euEV1OrYiCFOluSiSgoFcr2MzIHw4+jUGTYXjRBnOfo=;
        b=KJDVP0uOzF7CfJE09Zbb/oSfB1ycpvUepgyN5DUGT0aEcjln1nBti4fCaZoRTzcAFm
         4KWPl7S84khtX0hEao7L3KhgYgTkmGCY4IpyD9Yhl5kFDVwGnrg8hTgNQvQI6Nne4+Xp
         S9/xl7zMWKjCNSNtMDCijG3UkEbLinHBvxlnebSpwa4THcCMFyJpRFEoBWl2+XkMahkR
         O8BjiMFGKGVfCHoe72qixigA78Bj3KZERW7eCFH5vHAMf77GxZVhfUewNgrqkhPClzIP
         tTAb5pjq+BiV8YnQ4EV6xKy7crICUPoyDGmzYYk/gZheI9e/KuSdWP9cAV0HvZ7qCeUm
         04xQ==
X-Gm-Message-State: AOAM5308nOi4pD8p7l7/fudcGhaX6DR2OpbwQALOZIzL0REisJw51l+P
        L8Q5F9e4Zy5XTsEJAVK0uNg=
X-Google-Smtp-Source: ABdhPJw2qMFwGNUgFOsecahLEvRKuQWJuxMnJvOzXupmZtuzzjeUOdJIUIXRSvsa2z3QyhZXlS2tiA==
X-Received: by 2002:a63:4606:: with SMTP id t6mr8748252pga.388.1631868324832;
        Fri, 17 Sep 2021 01:45:24 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id mi18sm5270686pjb.15.2021.09.17.01.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 01:45:24 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: build: Stop build_man.sh from deleting short Detailed Descriptions
Date:   Fri, 17 Sep 2021 18:45:19 +1000
Message-Id: <20210917084519.15811-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An empty Detailed Description is 3 lines long but a short (1-para) DD is also 3
lines. Check that the 3rd line really is empty.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 63e02dc..852c7b8 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -116,7 +116,11 @@ del_empty_det_desc(){
   mygrep "^\\.SH \"Detailed Description" $target
   [ $linnum -ne 0  ] || return 0
   [ $(($i - $linnum)) -eq 3 ] || return 0
-  delete_lines $linnum $(($i -1))
+  # A 1-line Detailed Description is also 3 lines long,
+  # but the 3rd line is not empty
+  i=$(($i -1))
+  [ $(tail -n+$i $target | head -n1 | wc -c) -le 2 ] || return 0
+  delete_lines $linnum $i
 }
 
 move_synopsis(){
-- 
2.17.5

