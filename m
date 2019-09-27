Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7501BC4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DAD217D9
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfI0M5A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:57:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43526 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbfI0M5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 08:57:00 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 6DBFD43EEAB
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2019 22:56:45 +1000 (AEST)
Received: (qmail 7912 invoked by uid 501); 27 Sep 2019 12:56:45 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] BUG: src: Update UDP header length field after mangling
Date:   Fri, 27 Sep 2019 22:56:45 +1000
Message-Id: <20190927125645.7869-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=J70Eh1EUuV4A:10 a=6nuk8M2LySgND5QPvBgA:9 a=pLouTN30JE-JXwSG:21
        a=taJqi5g1KmyLCurM:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One would expect nfq_udp_mangle_ipv4() to take care of the length field in
the UDP header but it did not.
With this patch, it does.
This patch is very unlikely to adversely affect any existing userspace
software (that did its own length adjustment),
because UDP checksumming was broken
---
 src/extra/udp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index 8c44a66..6836230 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -140,6 +140,8 @@ nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
 	iph = (struct iphdr *)pkt->network_header;
 	udph = (struct udphdr *)(pkt->network_header + iph->ihl*4);
 
+	udph->len = htons(ntohs(udph->len) + rep_len - match_len);
+
 	if (!nfq_ip_mangle(pkt, iph->ihl*4 + sizeof(struct udphdr),
 				match_offset, match_len, rep_buffer, rep_len))
 		return 0;
-- 
2.14.5

