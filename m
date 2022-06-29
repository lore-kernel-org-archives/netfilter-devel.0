Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21A6C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiF2VV7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiF2VV6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:21:58 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2223019C11
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:21:57 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 25TIXmV8004627;
        Wed, 29 Jun 2022 22:21:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=XCXJx0kaCZcqm0kLK/1WEh8MESO9F0mQDevfd/itph8=;
 b=KFMMInLJGMqPpLUjD9dcrKfR8TEKDYfxjz11rVUjc9CTENMB3/QBJBAYFI031pMTZYOI
 N9TF2q4sJbofI7g1Jwu2OMfkmqta9Y3A1J5nTHvEd1s3nq4hP29tfG249Tjp8Q1rEe6e
 HULWUdWAweYayh1xzuFWMrtKNRMcYOVMBsRZQiXdok2fAGdgYdfK6ouOwDP6IyrJe8tU
 g7+jN93Bt4nhRKx7GnTqtnSN2nzsOw15N6HSOuO6I258aekZfFyw98eFjsc8WlU4jTRb
 bgwTUOPdZoluNoA+KUZha7Rl/jX8TIobTyCvSLpEghYvbpHGOW4Rny2o7cpD0bJJs48x 3w== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3h0q6bu1dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:21:53 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25THFPGg014877;
        Wed, 29 Jun 2022 17:21:52 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.23])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3gwwpwy5r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 17:21:52 -0400
Received: from usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) by
 usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:21:51 -0400
Received: from usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) by
 usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 29 Jun 2022 17:21:51 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:21:51 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 65D8115F504; Wed, 29 Jun 2022 17:21:51 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] netfilter: ipset: regression in ip_set_hash_ip.c
Date:   Wed, 29 Jun 2022 17:21:08 -0400
Message-ID: <20220629212109.3045794-2-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629212109.3045794-1-vpai@akamai.com>
References: <20220629212109.3045794-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=990 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: vBwOtm9Fjycxzlvwq2BZweseB9x9bGtV
X-Proofpoint-GUID: vBwOtm9Fjycxzlvwq2BZweseB9x9bGtV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 mlxlogscore=973 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
ipset: Fix adding an IPv4 range containing more than 2^31 addresses")

The variable e.ip is passed to adtfn() function which finally adds the
ip address to the set. The patch above refactored the for loop and moved
e.ip = htonl(ip) to the end of the for loop.

What this means is that if the value of "ip" changes between the first
assignement of e.ip and the forloop, then e.ip is pointing to a
different ip address than "ip".

Test case:
$ ipset create jdtest_tmp hash:ip family inet hashsize 2048 maxelem 100000
$ ipset add jdtest_tmp 10.0.1.1/31
ipset v6.21.1: Element cannot be added to the set: it's already added

The value of ip gets updated inside the  "else if (tb[IPSET_ATTR_CIDR])"
block but e.ip is still pointing to the old value.

Reviewed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Vishwanath Pai <vpai@akamai.com>
---
 net/netfilter/ipset/ip_set_hash_ip.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index dd30c03d5a23..258aeb324483 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -120,12 +120,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	ip &= ip_set_hostmask(h->netmask);
-	e.ip = htonl(ip);
-	if (e.ip == 0)
+
+	if (ip == 0)
 		return -IPSET_ERR_HASH_ELEM;
 
-	if (adt == IPSET_TEST)
+	if (adt == IPSET_TEST) {
+		e.ip = htonl(ip);
 		return adtfn(set, &e, &ext, &ext, flags);
+	}
 
 	ip_to = ip;
 	if (tb[IPSET_ATTR_IP_TO]) {
@@ -145,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
+	e.ip = htonl(ip);
+	if (e.ip == 0)
+		return -IPSET_ERR_HASH_ELEM;
+
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
 	/* 64bit division is not allowed on 32bit */
-- 
2.25.1

