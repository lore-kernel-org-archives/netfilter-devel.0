Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA588C47420
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A11F21D91
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Rn2j/7Oz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgIYMto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbgIYMtn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:43 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8107AC0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id k14so2380016edo.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6xkaM1Q+vQK4k5nAwBVmSYiuGGzUlZKoXx1C104qRyQ=;
        b=Rn2j/7Ozn+bvkgMMBXYFcFNNe/i8Vdr99oMoXhPU7KMpGKgy7CxyM8XR+5sDbk6r2H
         xxvI/5OC41Vpi3GqZRGHNjyEYeIfvtaPi0uvxjHsrsu4377i0FR6D3X6xoiw6/e9UJqW
         uPYWZRHG/m/oGGwlt7Y8Kqftc33W+dL3JV/HFAa8HolNzlkiD9tRPtaEsaY0r8wAjh9m
         mqcS5MRLq7yRQJCrXb/75ERjMchMOVPZsp7YPEDtkcuxkbjuNT8paXNWJU1Cog73rk6D
         69TSjpMhA4eBGcKnL5NVMM8EGmSM2z0pWvr88r9kY6TTmCke7NMd0dArJATijAiNgrme
         CgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6xkaM1Q+vQK4k5nAwBVmSYiuGGzUlZKoXx1C104qRyQ=;
        b=qIA8kpCd6J1WhQiiFf5YekXsyowVJb9YdzZ6WE6CLIlzbv8H+hj/zG/GOFalCXQ1rc
         jcQ/jC0m77NJEYAWF3bjpG5LPkqJElOkQaVY3BY4ghvjBB1kyrUFidAdsdhCPn/zOUVP
         8F2sbFTdJt+rxs7kyeM6NnFRga8vzRVcSGMNyc9V0N4dUHWtjk4VRgKHnWSUWGMdoEKp
         2Xusmw2yhnk6WUwxWQdjnM4qSD76YuGMj0W2FtDV2N5YAg96WitdDJ60lQcjs09wkvYY
         ege/OJSWldbQzLBr00c8KiuXlvBV9tO0rKx8VYkou4Wb3gjzmfH1IAyHa9sLcuzh9S7A
         SYjQ==
X-Gm-Message-State: AOAM532Zy18Vl8t6FKdIqZfb2HQMeHfNSjn6myHiMpwCIw2hJKwTj0x5
        cHhvMKAYXVy5oTun1OBukwm9w4VKLSIAdA==
X-Google-Smtp-Source: ABdhPJw6UuO8r8kpL2pFHmiT8095Wbe1tL6TpUw8aazceRvJtu/l0HUAtrncdRhuJnFlvtFX2rqf3Q==
X-Received: by 2002:aa7:d417:: with SMTP id z23mr1115297edq.62.1601038181941;
        Fri, 25 Sep 2020 05:49:41 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:41 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 1/8] tests: icmp entry create/delete
Date:   Fri, 25 Sep 2020 14:49:12 +0200
Message-Id: <20200925124919.9389-2-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add test to cover icmp entry creation/deletion with conntrack

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/testsuite/00create | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/conntrack/testsuite/00create b/tests/conntrack/testsuite/00create
index 4e55a7b..911e711 100644
--- a/tests/conntrack/testsuite/00create
+++ b/tests/conntrack/testsuite/00create
@@ -30,3 +30,7 @@
 -D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
 # mismatched address family
 -I -s 2001:DB8::1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+# creae icmp ping request entry
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete icmp ping request entry
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
-- 
2.25.1

