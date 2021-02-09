Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA4DC433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 19:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029DD64EDD
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 19:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhBITkp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 14:40:45 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:56698 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233676AbhBIT0C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 14:26:02 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.43/8.16.0.42) with SMTP id 119JJOl6050470;
        Tue, 9 Feb 2021 11:24:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=K6KuLU8qJx6OWF6vf4hF+med+RPNeMJPnVZlH8JCSKY=;
 b=Bv0erVpFA2qp2AJLsEb4ckn7GB6aTd6ws6Mxd1oaWhp2VLhrybGgXltd26zD7Y/ebzQU
 T6DDEvQQ654oRkcPKd9QC1eoirXtOaOHEUqmKopYOWMjqOSfVQxGf6jeV+y3JoPUYZr4
 3/+vf2G/69hiFFeX69zCjB3JCTZE/0aSncCeM/4tONeii0BdWSh8FEbnXnXmLQ3zb0/o
 kZA4B+DR0rf1sWHx7IXx68GbHZCHX2xXb0yfnw/jikN/oSh8M8RQHe8ZCQAR8eXbKnlR
 g2qJ1GiCbpFpPpeI53ZuNtrWV8b3k+k3hjMYgWZ6pht9VLUXCwSXUgUhHNwG75LpQxe3 gA== 
Received: from crk-mailsvcp-mta-lapp03.euro.apple.com (crk-mailsvcp-mta-lapp03.euro.apple.com [17.66.55.16])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 36hrjms24a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 09 Feb 2021 11:24:23 -0800
Received: from crk-mailsvcp-mmp-lapp02.euro.apple.com
 (crk-mailsvcp-mmp-lapp02.euro.apple.com [17.72.136.16])
 by crk-mailsvcp-mta-lapp03.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QOA00VMO0KMQB00@crk-mailsvcp-mta-lapp03.euro.apple.com>; Tue,
 09 Feb 2021 19:24:22 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp02.euro.apple.com by
 crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QOA00Z000D41X00@crk-mailsvcp-mmp-lapp02.euro.apple.com>; Tue,
 09 Feb 2021 19:24:22 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: b733bd983304443b63a993f2477c8539
X-Va-E-CD: ae55c2cbabce46db1fee1813278865b3
X-Va-R-CD: ea8436ad7cdf8c0bb84499addee28544
X-Va-CD: 0
X-Va-ID: 106b11f0-328c-4b88-a508-beb2cfd401ed
X-V-A:  
X-V-T-CD: b733bd983304443b63a993f2477c8539
X-V-E-CD: ae55c2cbabce46db1fee1813278865b3
X-V-R-CD: ea8436ad7cdf8c0bb84499addee28544
X-V-CD: 0
X-V-ID: 8401b314-caa8-4f85-834f-47f64e235f8f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
Received: from [192.168.1.127] (unknown [17.235.208.127])
 by crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QOA00W7H0KKDR00@crk-mailsvcp-mmp-lapp02.euro.apple.com>;
 Tue, 09 Feb 2021 19:24:22 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.45.21011103
Date:   Tue, 09 Feb 2021 20:24:18 +0100
Subject: [PATCH libnetfilter_queue v2] src: fix IPv6 header handling
From:   Etan Kissling <etan_kissling@apple.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-id: <E541C42D-FD3B-4B5B-8806-8F96799BD6D6@apple.com>
Thread-topic: [PATCH libnetfilter_queue v2] src: fix IPv6 header handling
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This corrects issues in IPv6 header handling that sometimes resulted
in an endless loop.

Signed-off-by: Etan Kissling <etan_kissling@apple.com>
---
v2: Updated loop condition to be consistent with the implementation
    ipv6_skip_exthdr() in the Linux kernel.

 src/extra/ipv6.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 42c5e25..0ec8fbf 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -67,7 +67,12 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
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
 
@@ -107,11 +112,13 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
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



