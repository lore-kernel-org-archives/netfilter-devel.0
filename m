Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B14C07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 04:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95E66613D1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 04:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGFE35 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 00:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhGFE35 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 00:29:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0FC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 21:27:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso954646pjx.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 21:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLo9FJF60IA8lQnwvtPB/mAGPjNP9O4ahYoIlFHkzng=;
        b=IVRLTq7YwO7U1AykVx6GxLZzmgHTCDmd+D4wZItpr+SGge8FLLaGax88Pf4nyv0VWM
         eFVnPoHDZHA+WFq9qd5PxiVNT0rZQ8WLpQrtQ96aVaMnHRJsHh22Yv4LwI8iFE/iukMT
         vNtUPg2Jyy51dhR+X8Bbc0JxYlKpkwd9tkVF/T7wfV3NS28xQJGBoZoTaELA1GrIqHvO
         33n2QtSJJ2g0CX/IV8Y0olKxmSutns8wobKPVf+8nvIrdJ4WERhkh2R468mjcQYs93jq
         IWgFlDlNW71FkeXcf8Nb4oo+rPlTzCoxsIvpLQT6jXuEDZuTsDJ3GGhwbGt3d1lVA8CU
         xlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JLo9FJF60IA8lQnwvtPB/mAGPjNP9O4ahYoIlFHkzng=;
        b=nh8WIFgP6PXv1zupNoKozWOx/G6+q2kirbcRprALowI2Hekv/mXJllgINR5Hf3DBdX
         6ioLWU7Ejpwt7EUg/gK+Bko/9XP90fVH07n1faGPPSbAQwNxlbhI1fRE6lh9z8Uc1W4s
         EcDTb01cD7XcTMfE6AWZS3PoDXeFU2UsuyhpH0VIhNGxbmoH1ZmkxkFEZ1TXnz3gz5Go
         wMHBUhd9Oosr+VH9zOR3Radcne+isHz20BHxQo2HyUJWJLcWtP24we2F+pdTkkcDKhzL
         BQTzhCpei2H4cUy5v1tRAq3WN/k7qzlYr+2pKWLz+Q8MRCoIkftZ43q/lmrYmmfy68ns
         BtPg==
X-Gm-Message-State: AOAM531oBt5lJ9bJ2qbNpF+sUnvKIc+9WmYjKEWnkb4YDjaQwEGhOOoJ
        aZlt7SgEU1hvL/2QXbHoGeB7oZwuMIo=
X-Google-Smtp-Source: ABdhPJyQ8D0USa5Knmek8oRHJdI3CjW5jmKmOAa++J/Kmmi+383yYwkJVbcfa8hMv93+RVCGsAJqkA==
X-Received: by 2002:a17:90a:d988:: with SMTP id d8mr2389999pjv.111.1625545637995;
        Mon, 05 Jul 2021 21:27:17 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id k8sm14623624pfa.142.2021.07.05.21.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 21:27:17 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: examples: Use libnetfilter_queue cached linux headers throughout
Date:   Tue,  6 Jul 2021 14:27:13 +1000
Message-Id: <20210706042713.11002-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210705144229.GB29924@salvia>
References: <20210705144229.GB29924@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A user will typically copy nf-queue.c, make changes and compile: picking up
/usr/include/linux/nfnetlink_queue.h rather than
/usr/include/libnetfilter_queue/linux_nfnetlink_queue.h as is recommended.

(Running `make nf-queue` from within libnetfilter_queue/examples will get
the private cached version of nfnetlink_queue.h which is not distributed).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 5b86e69..7ad631d 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -11,9 +11,9 @@
 #include <linux/netfilter/nfnetlink.h>
 
 #include <linux/types.h>
-#include <linux/netfilter/nfnetlink_queue.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
 /* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
 #include <linux/netfilter/nfnetlink_conntrack.h>
-- 
2.17.5

