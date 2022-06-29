Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C08C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiF2Vlf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiF2Vlf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:41:35 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C768037A17
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:41:33 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 25TJqCNf001135;
        Wed, 29 Jun 2022 22:20:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=xuVbBgCdw3JB8rUr+X3uMQHiPjyBXxpPnagZao9DXx8=;
 b=kg+K/c9gHwaVpKKwtDCWz+79sRpQ+YZTpxspKmgDr0ShBm4rDYkPJGFD1LGsJ9rRgoAO
 aprzTNsoFfQEPFwI+0eviZZXP3C4v6kQonx3GZvUgQsaGzvEXI/oyovJ9wH0HL4qPJO4
 ExyINSaOM0uIClWhdcdnAMH3YACTwnblTtZ1V1+s9Blv20iY25dR0qG6syDt4o3DmKEF
 xWLKyLiS5GQ7xl1QSA6bRf3DUSj8btxe+pyq9gu1vVeAZfvhaEsbaVgAhI6HuPlC24cj
 k8wBjMBSzsfxhPfsll28A0WzrMnyC1/2+E3+ny19ExSz7n0LQFNQ/f8ybtqR56YRG08m 5Q== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3gynjb6h24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:20:25 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TIGhQn019277;
        Wed, 29 Jun 2022 14:20:23 -0700
Received: from email.msg.corp.akamai.com ([172.27.123.57])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3gx0b9xvaa-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 14:20:23 -0700
Received: from usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:20:06 -0400
Received: from usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) by
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 29 Jun 2022 17:20:06 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:20:06 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 12DAF15F504; Wed, 29 Jun 2022 17:20:06 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH 1/6] netfilter: ipset: include linux/nf_inet_addr.h
Date:   Wed, 29 Jun 2022 17:18:57 -0400
Message-ID: <20220629211902.3045703-2-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629211902.3045703-1-vpai@akamai.com>
References: <20220629211902.3045703-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=844 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: eO-zjYj28GUrjL7UpgSia40JeW1Vk-fK
X-Proofpoint-GUID: eO-zjYj28GUrjL7UpgSia40JeW1Vk-fK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=838 spamscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We redefined a few things from nf_inet_addr.h, this will prevent others
from including nf_inet_addr.h and ipset headers in the same file.

Remove the duplicate definitions and include nf_inet_addr.h instead.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 include/libipset/nf_inet_addr.h |  9 +--------
 include/libipset/nfproto.h      | 15 +--------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/include/libipset/nf_inet_addr.h b/include/libipset/nf_inet_addr.h
index f3bdf01..e1e058c 100644
--- a/include/libipset/nf_inet_addr.h
+++ b/include/libipset/nf_inet_addr.h
@@ -10,13 +10,6 @@
 #include <stdint.h>				/* uint32_t */
 #include <netinet/in.h>				/* struct in[6]_addr */
 
-/* The structure to hold IP addresses, same as in linux/netfilter.h */
-union nf_inet_addr {
-	uint32_t	all[4];
-	uint32_t	ip;
-	uint32_t	ip6[4];
-	struct in_addr	in;
-	struct in6_addr in6;
-};
+#include <linux/netfilter.h>
 
 #endif /* LIBIPSET_NF_INET_ADDR_H */
diff --git a/include/libipset/nfproto.h b/include/libipset/nfproto.h
index 800da11..5265176 100644
--- a/include/libipset/nfproto.h
+++ b/include/libipset/nfproto.h
@@ -1,19 +1,6 @@
 #ifndef LIBIPSET_NFPROTO_H
 #define LIBIPSET_NFPROTO_H
 
-/*
- * The constants to select, same as in linux/netfilter.h.
- * Like nf_inet_addr.h, this is just here so that we need not to rely on
- * the presence of a recent-enough netfilter.h.
- */
-enum {
-	NFPROTO_UNSPEC =  0,
-	NFPROTO_IPV4   =  2,
-	NFPROTO_ARP    =  3,
-	NFPROTO_BRIDGE =  7,
-	NFPROTO_IPV6   = 10,
-	NFPROTO_DECNET = 12,
-	NFPROTO_NUMPROTO,
-};
+#include <linux/netfilter.h>
 
 #endif /* LIBIPSET_NFPROTO_H */
-- 
2.25.1

