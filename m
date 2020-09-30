Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC96C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 05:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7FC206A5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 05:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgI3FEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 01:04:30 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58973 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgI3FEa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 01:04:30 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 01:04:29 EDT
Received: from dimstar.local.net (n49-192-70-185.sun3.vic.optusnet.com.au [49.192.70.185])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id D09873AC060
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 15:04:26 +1000 (AEST)
Received: (qmail 12504 invoked by uid 501); 30 Sep 2020 05:04:26 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, dunc@dimstar.local.net
Subject: [PATCH libnetfilter_queue] src: doc: Fix doxygen warning
Date:   Wed, 30 Sep 2020 15:04:26 +1000
Message-Id: <20200930050426.12462-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.17.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=zRnOCfNoldqEzXEIOSrMkw==:117 a=zRnOCfNoldqEzXEIOSrMkw==:17
        a=reM5J-MqmosA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=lYee_BwEX8FsesqnFeAA:9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

src/extra/checksum.c had a stray group close sequnce at the end.

(Spotted after sending doxygen o/p to /dev/null)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/checksum.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/src/extra/checksum.c b/src/extra/checksum.c
index a650b64..ffc8c75 100644
--- a/src/extra/checksum.c
+++ b/src/extra/checksum.c
@@ -80,7 +80,3 @@ uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
 
 	return nfq_checksum(sum, (uint16_t *)payload, len);
 }
-
-/**
- * @}
- */
-- 
2.17.5

