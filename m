Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A91C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 08:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4814C61163
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 08:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbhIHItv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348242AbhIHItu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 04:49:50 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3246C061575
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2021 01:48:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e7so1880938pgk.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Sep 2021 01:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XqlKPrrQn4BxACYE4FX26iAaheMiXX5QeODerAKfQds=;
        b=UqkGQrP0dM15fs9wdHTVNntQjlDh3U1Zc0KrfysiLgatwmnUhVp+qdDiXSe8HyBc3b
         ohwatf+mxzNMJHDTkmGz2+0ZW9UpRCIo2tiapD2yLaYHWMlocNci68Y61w+Ol4w9BHNt
         UfF/8O7UXF4t9P4ttYrV0YQRWmRXS7rfq1bmPncugVp4nfeTxhvAYspxtOshwQFPI9ta
         rH6IcvTsUtLMKckfoNcDk7SfRctmH8IbMUOu9Qqbn5WyNd1brjJcAy4jQKkq2evYYw+T
         o11rlGo+a83JXNOFCkv/wdfGTVZb1njbDqyvNmxEjFT7c5JzM4Z1NGJ08gmw0vn3Et1X
         v9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=XqlKPrrQn4BxACYE4FX26iAaheMiXX5QeODerAKfQds=;
        b=H4KGLI64GgmqJwQKDZw1qsMkiQZ+PHm0mSmO/FvLVNMwC0lcR05hVn7hMJYba9Q+Bp
         dRiR+G9N7tDT9pEGxTm6SJ27u3rMYfMlma7iNNJbtJiGS9D2Ju7tBJEcA9QAzDxFh81R
         W7hRiZJsXE2TkkUrpzTFJeEwHF5UFlhH059916iEeHD1nLw0X8lQB42tEiOzvFlsulHi
         JltNKscjA/5PgXBmeJF+/xgvodE98tjfDf0bUiASmUlI6fna+XSvmcsqegaTNt6m20sA
         jZ3c36WVDJSG6zegOE1cY54GS+fFadUPrk+wZjQ/Kn5YmKrNlfK3XVb3K1C3WZq+t30U
         I9Vw==
X-Gm-Message-State: AOAM532biT4h0fVUxfQA6wD9X4YuBwyPnAIie68ejnghhmpC1YlSSBsU
        jzjs1W5mVoSc19oPVfEI8B5ZZaOdP8I=
X-Google-Smtp-Source: ABdhPJy9N+XAy7LQqlz6d12/tBt7t5l9MN3bs/Zq2v20ZEvJPIwY5R2q5Ydkb6+cumJwuBGOsMU3nQ==
X-Received: by 2002:aa7:8482:0:b0:40b:9cdd:6414 with SMTP id u2-20020aa78482000000b0040b9cdd6414mr2672495pfn.81.1631090921290;
        Wed, 08 Sep 2021 01:48:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y11sm1577246pfl.198.2021.09.08.01.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 01:48:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] utils: nfulnl_test: Print meaningful error messages
Date:   Wed,  8 Sep 2021 18:48:35 +1000
Message-Id: <20210908084835.17448-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

e.g. "Operation not supported" when run as non-root

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 utils/nfulnl_test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index d888fc1..05ddc6c 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -58,38 +58,38 @@ int main(int argc, char **argv)
 
 	h = nflog_open();
 	if (!h) {
-		fprintf(stderr, "error during nflog_open()\n");
+		perror("nflog_open");
 		exit(1);
 	}
 
 	printf("unbinding existing nf_log handler for AF_INET (if any)\n");
 	if (nflog_unbind_pf(h, AF_INET) < 0) {
-		fprintf(stderr, "error nflog_unbind_pf()\n");
+		perror("nflog_unbind_pf");
 		exit(1);
 	}
 
 	printf("binding nfnetlink_log to AF_INET\n");
 	if (nflog_bind_pf(h, AF_INET) < 0) {
-		fprintf(stderr, "error during nflog_bind_pf()\n");
+		perror("nflog_bind_pf");
 		exit(1);
 	}
 	printf("binding this socket to group 0\n");
 	gh = nflog_bind_group(h, 0);
 	if (!gh) {
-		fprintf(stderr, "no handle for group 0\n");
+		perror("nflog_bind_group 0");
 		exit(1);
 	}
 
 	printf("binding this socket to group 100\n");
 	gh100 = nflog_bind_group(h, 100);
 	if (!gh100) {
-		fprintf(stderr, "no handle for group 100\n");
+		perror("nflog_bind_group 100");
 		exit(1);
 	}
 
 	printf("setting copy_packet mode\n");
 	if (nflog_set_mode(gh, NFULNL_COPY_PACKET, 0xffff) < 0) {
-		fprintf(stderr, "can't set packet copy mode\n");
+		perror("nflog_set_mode NFULNL_COPY_PACKET");
 		exit(1);
 	}
 
-- 
2.17.5

