Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5582C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 13:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8034923A58
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 13:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbhANN3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 08:29:02 -0500
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:33210 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728497AbhANN3B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 08:29:01 -0500
X-Greylist: delayed 99642 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2021 08:29:00 EST
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 10D9TG59011556;
        Wed, 13 Jan 2021 01:47:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : mime-version : content-type :
 content-transfer-encoding; s=20180706;
 bh=lCOlYmel5FvTrCWgxZQ4O3mmcNj9IvJj2Oqy/e1Ss2o=;
 b=sGdkBQEkSnqsU3RcB6e36v71WCF0NDsSIGzxhBs98ZdM5p0QNA/t6a/oKfcSO3yNI+xV
 WimmXAwvAu/Mw4Ta2rQ4UbHipQsyiRDt5TxdqZNVVKzlqVJJTkWgLvkL/SK1g1ZAN4md
 Ivt4AA8sbkna+ml8v3aSo/8YMBqZ6RTjYc8WbsoRYOvqxq1lu2SKraXnk0k0cKB+GJF5
 bEaOuXqIDh4ufxWBcPfoX7JsPpLyFzDd+cUaj2+qffS/e5r31XXvZcFbPgrX74ce97HN
 Cu5NQn8UBJtKIcIHF0YLAHvZzNaimu8WXyX9XaroGh7BkVl+PW42JN+97uFjhHnGYJs+ xw== 
Received: from crk-mailsvcp-mta-lapp02.euro.apple.com (crk-mailsvcp-mta-lapp02.euro.apple.com [17.66.55.14])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 35ya1x33w9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 13 Jan 2021 01:47:34 -0800
Received: from crk-mailsvcp-mmp-lapp03.euro.apple.com
 (crk-mailsvcp-mmp-lapp03.euro.apple.com [17.72.136.17])
 by crk-mailsvcp-mta-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QMV004DT9V97L00@crk-mailsvcp-mta-lapp02.euro.apple.com>; Wed,
 13 Jan 2021 09:47:33 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp03.euro.apple.com by
 crk-mailsvcp-mmp-lapp03.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QMV00C009N4WJ00@crk-mailsvcp-mmp-lapp03.euro.apple.com>; Wed,
 13 Jan 2021 09:47:33 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 785a83b2b63a5a352022c3616ae5f6e3
X-Va-R-CD: 1f2f1a1e678e5861357bfe6b87eec27b
X-Va-CD: 0
X-Va-ID: d249e9d9-413f-408a-bd6f-df10256698dc
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 785a83b2b63a5a352022c3616ae5f6e3
X-V-R-CD: 1f2f1a1e678e5861357bfe6b87eec27b
X-V-CD: 0
X-V-ID: 5c56899e-3e21-4aa2-a0b4-490606914006
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
Received: from [192.168.1.127] (unknown [17.235.214.236])
 by crk-mailsvcp-mmp-lapp03.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QMV00A9B9V8BA00@crk-mailsvcp-mmp-lapp03.euro.apple.com>;
 Wed, 13 Jan 2021 09:47:33 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.44.20121301
Date:   Wed, 13 Jan 2021 10:47:31 +0100
Subject: [PATCH libnetfilter_queue] src: fix IPv6 header handling
From:   Etan Kissling <etan_kissling@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     laforge@netfilter.org
Message-id: <EA975B90-266F-4DED-A655-8DB522DDF586@apple.com>
Thread-topic: [PATCH libnetfilter_queue] src: fix IPv6 header handling
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This corrects issues in IPv6 header handling that sometimes resulted in an endless loop.

Signed-off-by: Etan Kissling <etan_kissling@apple.com>
---
 src/extra/ipv6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 42c5e25..1eb822f 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -72,7 +72,8 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 		uint32_t hdrlen;
 
 		/* No more extensions, we're done. */
-		if (nexthdr == IPPROTO_NONE) {
+		if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP || nexthdr == IPPROTO_ESP ||
+		        nexthdr == IPPROTO_ICMPV6 || nexthdr == IPPROTO_NONE) {
 			cur = NULL;
 			break;
 		}
@@ -107,7 +108,7 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 		} else if (nexthdr == IPPROTO_AH)
 			hdrlen = (ip6_ext->ip6e_len + 2) << 2;
 		else
-			hdrlen = ip6_ext->ip6e_len;
+			hdrlen = (ip6_ext->ip6e_len + 1) << 3;
 
 		nexthdr = ip6_ext->ip6e_nxt;
 		cur += hdrlen;
-- 
2.21.1 (Apple Git-122.3)



