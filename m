Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9BDC04AA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 06:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD922089E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 06:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20150623.gappssmtp.com header.i=@rajagiritech-edu-in.20150623.gappssmtp.com header.b="ZQsLpqrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfEOGoW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 02:44:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39637 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfEOGoV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 02:44:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so838496plm.6
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 23:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZdohzeVgbbKHEv1a2YghmfxHtlO8ojKInm2nc2fqSSY=;
        b=ZQsLpqrplJtjoMLOoc0l17JwFYvv6aqTNTRukNM+fypvmCZkF7YCRm+bsiagitQLHA
         CaWoiXAW6FE1bQMzrymKfJUMvD4zDDes6Dh8re/iQMFRFE8Tali/B56G6iDrZ2ys3EIY
         +PBIj46HwlRtQEZFEnjitSNPAWgwmpQ95i7mcpzxt1sNnKtlRdNBZoNWXAd0lmOhjezi
         1Hxu6myv4rMJePJRz/6TDuqZl7y0uJxunvxbaTYxWu+S/CxQhBvO5xnL7C60lSMom6SB
         hpZ2uwt5izTpha4XnTXlf11FA0ceAHldst6/3vsYQuvQxpFveDJRuFGrtQuPnvdF2Wwd
         z+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZdohzeVgbbKHEv1a2YghmfxHtlO8ojKInm2nc2fqSSY=;
        b=l8aoNUFfSLr4IVrhp4w84tDMuKptxl4xxn3e9rKOS5RjS/tkBOqJXDuFJ3kt7PTwD7
         u+qwO4ddpWxDTMOtDTxNj9hPyEPkJ0RnWSDa6C2+ovs6Kgi3akD8tuaEjuTxdE5aObJk
         0Bw6Nk/92qJZQG15Of0CJLqG4nxXswJ8wqrYx4UWSgQqjIuL88YmP98ibTK1YL78uQcG
         XKpWkqY7z9g+ysdr78sMsxCikkvbuePsM3wZ5nNrYFi+r3EbDo+HXNpIFE5p0e6CXVAa
         2tR4rOR1nNo3oQhe8fEplI60+kAd0D3HXA+L63SSlN20wzCaJNrqJTCF+7wkVpJWMW8x
         vQdQ==
X-Gm-Message-State: APjAAAUrUmCovBe0NdnHPphocCtYCIsWGS4gRibCCsV2WbFzq8QeXRsd
        hmdCiCu2EqOmixUb1xyWzE6UCR0IktY=
X-Google-Smtp-Source: APXvYqw4Iv9Upcf4ZVB3I6Bn93najHUPFoo6jO+ve/0QzP33b8Cawc+JcdY30jXV8D9WZAq1Z7AQIA==
X-Received: by 2002:a17:902:2884:: with SMTP id f4mr14396889plb.230.1557902661254;
        Tue, 14 May 2019 23:44:21 -0700 (PDT)
Received: from localhost.localdomain ([122.174.240.7])
        by smtp.gmail.com with ESMTPSA id e5sm2180868pgh.35.2019.05.14.23.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 23:44:20 -0700 (PDT)
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, shuah@kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Subject: [PATCH v2] selftests: netfilter: missing error check when setting up veth interface
Date:   Wed, 15 May 2019 12:14:04 +0530
Message-Id: <20190515064405.3981-1-jeffrin@rajagiritech.edu.in>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A test for  the basic NAT functionality uses ip command which
needs veth device.There is a condition where the kernel support
for veth is not compiled into the kernel and the test script
breaks.This patch contains code for reasonable error display
and correct code exit.

Signed-off-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605c..f25f72a75cf3 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -23,7 +23,11 @@ ip netns add ns0
 ip netns add ns1
 ip netns add ns2
 
-ip link add veth0 netns ns0 type veth peer name eth0 netns ns1
+ip link add veth0 netns ns0 type veth peer name eth0 netns ns1 > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
 ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
 
 ip -net ns0 link set lo up
-- 
2.20.1

