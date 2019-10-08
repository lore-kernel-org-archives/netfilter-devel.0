Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F09C47404
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984CC2054F
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfJHAuC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:50:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38532 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729671AbfJHAuC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 20:50:02 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 9411C363024
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 11:49:49 +1100 (AEDT)
Received: (qmail 25688 invoked by uid 501); 8 Oct 2019 00:49:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 4/5] src: Fix invalid conversion specifier
Date:   Tue,  8 Oct 2019 11:49:47 +1100
Message-Id: <20191008004948.25632-5-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
References: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=PO7r1zJSAAAA:8
        a=nC70NE3ak5VaznKRK4gA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clang (but not gcc) warned about this. Gcc (but not clang) used to warn that
nfq_set_verdict_mark is deprecated, but this has stopped since re-defining
EXPORT_SYMBOL.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 531e84a..beb7d57 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -134,7 +134,7 @@ nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h)
 	inet_ntop(AF_INET6, &ip6h->ip6_src, src, INET6_ADDRSTRLEN);
 	inet_ntop(AF_INET6, &ip6h->ip6_dst, dst, INET6_ADDRSTRLEN);
 
-	ret = snprintf(buf, size, "SRC=%s DST=%s LEN=%Zu TC=0x%X "
+	ret = snprintf(buf, size, "SRC=%s DST=%s LEN=%zu TC=0x%X "
 				  "HOPLIMIT=%u FLOWLBL=%u ",
 			src, dst,
 			ntohs(ip6h->ip6_plen) + sizeof(struct ip6_hdr),
-- 
2.14.5

