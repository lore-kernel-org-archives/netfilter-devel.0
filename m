Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A530AC433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7612520738
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ociu3lPT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgH2HEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 03:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgH2HES (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 03:04:18 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB28C061239
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e16so1130614wrm.2
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UVtPmfcsFmi1Bupeb7QP3jH/UEJFN4CL8ntjTbK7+Lo=;
        b=Ociu3lPTLzXKJM9K41xlAQAhDYAprlAKIs8m+OoziSOK5Dwx0wn4QlUjMK8nMsjMFN
         FCmXKKq4KmWtlpQWXnTA3Nw99wDg8kH2E6/LHm/emBlTo1AEtIMy/HsdekdBScZvPQAL
         /dEGUEeYJW2KgaqgiAgTOYdw95M1wAWSbZQbcCqwzI2jxwVlEwMvM8QmWigpDhvphdYT
         /v5fl0kqcI07+JuFhLFxcpC6UtN8r1vFXIfvKVju4RuTTBa1RzDTM0j5QPI79+7aBV3H
         +bG0jFljdIM3MAiqsWi/A+JEdgTK4Hl77Yq8glgy58MXosPTddsxzlQyOQI0zxKoCn3u
         N7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UVtPmfcsFmi1Bupeb7QP3jH/UEJFN4CL8ntjTbK7+Lo=;
        b=RX5G0qN+SUiC/udtcfHpFd01ZAW+lNG/jbs+8Immv1Leeithl+h1M5mi4t3TmnYVos
         r2E1y76bZYvppG/9TCo9q8XWK98gVMQjX8zhmK3MU8CIqwzfdadKWZ8BWglC4zfTMYyF
         oYz9dAeCuMrBvOQMxVlC41Lpe/ROunVHAzZ+vZ9qggT9WUkxeQIJABj62tblU8RIzJiG
         pT0MbBwiTJREg2zX5MGVguE91puYWdn5LVM2KInusrqK6yBF0P6U2Gagmu/sToVKNYB1
         aEnXQvrxziPT7YBRLmPLoVfYNMdQmWX5Bm8dnpR7aaoEKZWS+WUWZHC8lnzgqBFQCExW
         YqYA==
X-Gm-Message-State: AOAM5324qIWU5RW2s0BGtXal6D6IM8Z36tGizW5TOtkQWFq3ZG9K5fFl
        WrO5v34illZFiGyd9qjwaIXJR1gK62qlig==
X-Google-Smtp-Source: ABdhPJzQQfBW8dajliwU/ZcHVBM7FVbr1M0sE6CE4PCVVUbqmwuUFycm/Tl6tsJGGfkdOBa+Uqmzqg==
X-Received: by 2002:a5d:6685:: with SMTP id l5mr2337759wru.264.1598684656448;
        Sat, 29 Aug 2020 00:04:16 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id f2sm2489756wrj.54.2020.08.29.00.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 00:04:15 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables v2 2/5] src/scanner.l: fix whitespace issue for the TRANSPARENT keyword
Date:   Sat, 29 Aug 2020 09:04:02 +0200
Message-Id: <20200829070405.23636-3-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829070405.23636-1-bazsi77@gmail.com>
References: <20200829070405.23636-1-bazsi77@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 9e6464f9..7afd9bfb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -267,7 +267,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "trace"			{ return TRACE; }
 
 "socket"		{ return SOCKET; }
-"transparent"		{ return TRANSPARENT;}
+"transparent"		{ return TRANSPARENT; }
 "wildcard"		{ return WILDCARD; }
 
 "tproxy"		{ return TPROXY; }
-- 
2.17.1

