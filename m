Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17371C4332E
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7232230FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbhASOhg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:37:36 -0500
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:47832 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389891AbhASN0I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 08:26:08 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 10JDNbjX049279;
        Tue, 19 Jan 2021 05:25:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=20180706;
 bh=yU7VMUmFiBGJYDdFc17kup+VaqjxMXcYkcdv35yCB8Q=;
 b=FT0qEKViJCjRLqssU3afoXwDDFvhHATl43Yjab7bgSFls+4+5ePtM8O6+FY/bwyXuR/1
 0lARzKFathcJ1mEXAMc9wn9+na7cJQ38kovhiuGAhaBSqpPnPHPnf+Gma9hX7iMKapSt
 3MOlLOAp2w0ZZvCrogiCgFRggQSt7qC+wrZ+WpnDwKuxiOg5r+QEHVBEGuRS6WyAZn3Q
 u1/JoWxVaRePmw+JgtQzwxj185NvGtgJGlO5cRlnB7IGdWi8O5iMTJ0ebSyDC/0rSiXg
 Y5IdKN3KQOn7lAk13wMgpN6PfqNp6drlCL+0pU6kXdHcuHz+s5MDDHKlVd4WsoPn02HI nQ== 
Received: from crk-mailsvcp-mta-lapp02.euro.apple.com (crk-mailsvcp-mta-lapp02.euro.apple.com [17.66.55.14])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 363wq0h7jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 19 Jan 2021 05:25:16 -0800
Received: from crk-mailsvcp-mmp-lapp02.euro.apple.com
 (crk-mailsvcp-mmp-lapp02.euro.apple.com [17.72.136.16])
 by crk-mailsvcp-mta-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QN600MN7NY2P600@crk-mailsvcp-mta-lapp02.euro.apple.com>; Tue,
 19 Jan 2021 13:25:14 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp02.euro.apple.com by
 crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QN600W00NTYR900@crk-mailsvcp-mmp-lapp02.euro.apple.com>; Tue,
 19 Jan 2021 13:25:14 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 785a83b2b63a5a352022c3616ae5f6e3
X-Va-R-CD: 1f2f1a1e678e5861357bfe6b87eec27b
X-Va-CD: 0
X-Va-ID: f9d0e5fe-f220-4a0b-97c7-4edb5846ddba
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 785a83b2b63a5a352022c3616ae5f6e3
X-V-R-CD: 1f2f1a1e678e5861357bfe6b87eec27b
X-V-CD: 0
X-V-ID: 8afa557e-9f59-49d6-b5f9-15b4cc9b2c68
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_04:2021-01-18,2021-01-19 signatures=0
Received: from [192.168.1.127] (unknown [17.235.218.21])
 by crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QN600HDVNY1IN00@crk-mailsvcp-mmp-lapp02.euro.apple.com>;
 Tue, 19 Jan 2021 13:25:14 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.45.21011103
Date:   Tue, 19 Jan 2021 14:25:13 +0100
Subject: [PATCH libnetfilter_queue] src: fix IPv6 header handling
From:   Etan Kissling <etan_kissling@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Message-id: <522C1546-5985-45B1-96CE-DF8B897EA13E@apple.com>
Thread-topic: [PATCH libnetfilter_queue] src: fix IPv6 header handling
References: <EA975B90-266F-4DED-A655-8DB522DDF586@apple.com>
In-reply-to: <EA975B90-266F-4DED-A655-8DB522DDF586@apple.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_04:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This corrects issues in IPv6 header handling that sometimes resulted
in an endless loop.

Signed-off-by: Etan Kissling <etan_kissling@apple.com>
---
 src/extra/ipv6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 42c5e25..c088240 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -72,7 +72,8 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 		uint32_t hdrlen;
 
 		/* No more extensions, we're done. */
-		if (nexthdr == IPPROTO_NONE) {
+		if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP || nexthdr == IPPROTO_ESP ||
+			nexthdr == IPPROTO_ICMPV6 || nexthdr == IPPROTO_NONE) {
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



