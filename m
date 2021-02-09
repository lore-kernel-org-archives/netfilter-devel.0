Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC01FC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8C064EDA
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhBJUyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 15:54:49 -0500
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:55088 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231596AbhBJUyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 15:54:46 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 119MnNwQ058620;
        Tue, 9 Feb 2021 14:52:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=aUw/dYIUSrk4IjErnMXSwSZf8c0ErZG3F2PS319zG8Q=;
 b=tkwFAIYtd6CcHwy0f04imFpGdD1cOS/r02sY4b+a2NhE/Jf+J3RVaJrQxWZloZ5yr5kO
 eJbY9yPufCPRv6RSa8t1BE7Ajd3eKad0G8jE7zkPE17HlA5s3gqI0EvhMKJ0OYNapyWO
 kCOieBy/ws5E4ER7TJPvcfa782HM51ytO7E1ZseZQObHevLwmFTJq6LchrLWHozlQuae
 sikNc5GcdxXXETwjDtXhvrcczvjMOfEPe662QOxXPPQtfuaSLAVEUgni1Ask4GcVJ7Vl
 4dDRR+CUB54LGk6XIwuOYve3CQ5wjA6WL5m8CQauY9DiUsvOn6ESfoRsmDMiFUyLPHjA Gw== 
Received: from crk-mailsvcp-mta-lapp04.euro.apple.com (crk-mailsvcp-mta-lapp04.euro.apple.com [17.66.55.17])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 36hu0030ru-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 09 Feb 2021 14:52:23 -0800
Received: from crk-mailsvcp-mmp-lapp02.euro.apple.com
 (crk-mailsvcp-mmp-lapp02.euro.apple.com [17.72.136.16])
 by crk-mailsvcp-mta-lapp04.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QOA00S0CA61P100@crk-mailsvcp-mta-lapp04.euro.apple.com>; Tue,
 09 Feb 2021 22:51:37 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp02.euro.apple.com by
 crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QOA007009W3N100@crk-mailsvcp-mmp-lapp02.euro.apple.com>; Tue,
 09 Feb 2021 22:51:37 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: b733bd983304443b63a993f2477c8539
X-Va-E-CD: 80cf090d0d9904fd62fbfa52444a0534
X-Va-R-CD: fb07a2cc9e7d28d22fffbdba5381aa6c
X-Va-CD: 0
X-Va-ID: 2f35428d-39f0-4c42-8ae3-49aebdb6f196
X-V-A:  
X-V-T-CD: b733bd983304443b63a993f2477c8539
X-V-E-CD: 80cf090d0d9904fd62fbfa52444a0534
X-V-R-CD: fb07a2cc9e7d28d22fffbdba5381aa6c
X-V-CD: 0
X-V-ID: 649725f4-5751-4252-a630-e897fb86089f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_08:2021-02-09,2021-02-09 signatures=0
Received: from [192.168.1.127] (unknown [17.235.208.127])
 by crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QOA00C2DA60IQ00@crk-mailsvcp-mmp-lapp02.euro.apple.com>;
 Tue, 09 Feb 2021 22:51:37 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.45.21011103
Date:   Tue, 09 Feb 2021 23:51:33 +0100
Subject: [PATCH libnetfilter_queue v3] src: fix IPv6 header handling
From:   Etan Kissling <etan_kissling@apple.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-id: <A355CB9D-9B07-4D62-A228-A37C2660C442@apple.com>
Thread-topic: [PATCH libnetfilter_queue v3] src: fix IPv6 header handling
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_08:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This corrects issues in IPv6 header handling that sometimes resulted
in an endless loop.

Signed-off-by: Etan Kissling <etan_kissling@apple.com>
---
v2: Updated loop condition to be consistent with the implementation
    ipv6_skip_exthdr() in the Linux kernel.
v3: Re-allow fetching extension headers using 'target' parameter.

 src/extra/ipv6.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 42c5e25..88cd77b 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -67,10 +67,19 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 	uint8_t nexthdr = ip6h->ip6_nxt;
 	uint8_t *cur = (uint8_t *)ip6h + sizeof(struct ip6_hdr);
 
-	while (nexthdr != target) {
+	while (nexthdr == IPPROTO_HOPOPTS ||
+			nexthdr == IPPROTO_ROUTING ||
+			nexthdr == IPPROTO_FRAGMENT ||
+			nexthdr == IPPROTO_AH ||
+			nexthdr == IPPROTO_NONE ||
+			nexthdr == IPPROTO_DSTOPTS) {
 		struct ip6_ext *ip6_ext;
 		uint32_t hdrlen;
 
+		/* Extension header was requested, we're done. */
+		if (nexthdr == target)
+			break;
+
 		/* No more extensions, we're done. */
 		if (nexthdr == IPPROTO_NONE) {
 			cur = NULL;
@@ -107,11 +116,13 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 		} else if (nexthdr == IPPROTO_AH)
 			hdrlen = (ip6_ext->ip6e_len + 2) << 2;
 		else
-			hdrlen = ip6_ext->ip6e_len;
+			hdrlen = (ip6_ext->ip6e_len + 1) << 3;
 
 		nexthdr = ip6_ext->ip6e_nxt;
 		cur += hdrlen;
 	}
+	if (nexthdr != target)
+		cur = NULL;
 	pktb->transport_header = cur;
 	return cur ? 1 : 0;
 }
-- 
2.21.1 (Apple Git-122.3)



