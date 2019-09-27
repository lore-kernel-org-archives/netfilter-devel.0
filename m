Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75696C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D9F217D9
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfI0MSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:18:53 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55102 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbfI0MSx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 08:18:53 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 811E7362D7B
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2019 22:18:39 +1000 (AEST)
Received: (qmail 7723 invoked by uid 501); 27 Sep 2019 12:18:38 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] BUG: src: Fix UDP checksum calculation
Date:   Fri, 27 Sep 2019 22:18:38 +1000
Message-Id: <20190927121838.7680-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=J70Eh1EUuV4A:10 a=0GIpw7lWKbjowl4VC-IA:9 a=7NI42sUECUibXt7w:21
        a=j5YOoUql8mDrf8M_:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The level 4 protocol is part of the UDP and TCP calculations.
nfq_checksum_tcpudp_ipv4() was using IPPROTO_TCP in this calculation,
which gave the wrong answer for UDP.
---
 src/extra/checksum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/checksum.c b/src/extra/checksum.c
index f367f75..3ef288f 100644
--- a/src/extra/checksum.c
+++ b/src/extra/checksum.c
@@ -46,7 +46,7 @@ uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph)
 	sum += (iph->saddr) & 0xFFFF;
 	sum += (iph->daddr >> 16) & 0xFFFF;
 	sum += (iph->daddr) & 0xFFFF;
-	sum += htons(IPPROTO_TCP);
+	sum += htons(iph->protocol);
 	sum += htons(len);
 
 	return nfq_checksum(sum, (uint16_t *)payload, len);
-- 
2.14.5

