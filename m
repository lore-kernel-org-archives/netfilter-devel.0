Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6596C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9189864FF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCJMhd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 07:37:33 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:41960 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhCJMhM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 07:37:12 -0500
Received: by mail-wm1-f43.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso10599122wmi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Mar 2021 04:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1qDF5KUTarv2NXAP0Zn2THXreYHEwEjE36vB+/71HQs=;
        b=IPk2K1iMcQ+4tuI4hmtEWJBs4vxgqqjYVsc2fcAhW3ntUPYvRgsOTQVo+Cv5vCS2cj
         1rOQ2HwU5Zi4hUD6KbHba0+p1XuIQuFPSSW2NdEoDoKGaLj2TSPCF+0QXANwft9sTjM6
         9EQU6vnLvBD5WR0QF0znOzstarYwXptAXVhleHk99J/huC79WxIEgJI3dkCST2h3o44d
         8RhGKP0DUMAFRJHcybHHCK/g+CEC2IvNqFlvU8bQDgcvbXWtszgY/A48/OFOO+4dUa0j
         Ee0fjUC7e2kQNFzD2IdOpemFfRvK8Q5UnWwncw355aUY09xoLyLxBWclVemkUW+5ila9
         ihYg==
X-Gm-Message-State: AOAM531ne/TJg/RRJelHOBUqQz47BFW5gNC9MtmKsh4C4dM2GUa9M2hJ
        AdSShqT3sUBdznUqBboDxVr11mRc+l/xMA==
X-Google-Smtp-Source: ABdhPJwip2QIIxhDZTOEiY6szGVjtvG21gt6qHw6hqx1iddEdY6xMC5xRGFsuf94lDVYs1e8WsZ9Zg==
X-Received: by 2002:a1c:9a48:: with SMTP id c69mr3095280wme.157.1615379831382;
        Wed, 10 Mar 2021 04:37:11 -0800 (PST)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id s83sm9129747wmf.26.2021.03.10.04.37.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:37:10 -0800 (PST)
Subject: [conntrack-tools PATCH 2/2] tests: conntrackd: silence sysctl
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 10 Mar 2021 13:37:10 +0100
Message-ID: <161537982997.41950.2854340685406654847.stgit@endurance>
In-Reply-To: <161537982333.41950.4295612522904541534.stgit@endurance>
References: <161537982333.41950.4295612522904541534.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are not interested in sysctl echoing the value it just set.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 tests/conntrackd/scenarios/basic/network-setup.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/conntrackd/scenarios/basic/network-setup.sh b/tests/conntrackd/scenarios/basic/network-setup.sh
index ff8df26..7f2f78a 100755
--- a/tests/conntrackd/scenarios/basic/network-setup.sh
+++ b/tests/conntrackd/scenarios/basic/network-setup.sh
@@ -25,7 +25,7 @@ start () {
 	ip -net nsr1 link set up dev veth0
 	ip -net nsr1 link set up dev veth1
 	ip -net nsr1 route add default via 192.168.10.2
-	ip netns exec nsr1 sysctl net.ipv4.ip_forward=1
+	ip netns exec nsr1 sysctl -q net.ipv4.ip_forward=1
 
 	ip -net nsr1 addr add 192.168.100.2/24 dev veth2
 	ip -net nsr1 link set up dev veth2

