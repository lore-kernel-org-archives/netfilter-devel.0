Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBDAC04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 18:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiI1S1g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiI1S1f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 14:27:35 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E3F08AE
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 11:27:34 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 28SHKkou026625;
        Wed, 28 Sep 2022 19:27:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=LX31mZsFSlFwYFQRauyLkzUzmxZBb6pHiyXTRTkIt0w=;
 b=RDJa7+DDtdDq85Py7WTScKUedD6MAd7q+KUyUET1/l0GTUpP7HyJDAgqhtTLMcHLZh2a
 mnSCIWdGY4OdzUSrk7njMrIy0fm56pbqFrnX6JGgsDhVPXBJ0u+cjBj6/GGO33DYd3td
 qVoXP6oQxrZti7SByE/4T6Gb7LfS3FnuItFr7EpJZdtGkGVA+v28rmAmQCwPuZ0QjwNL
 56Rocw0qx7Wac5m2eCc+leGgeXv9gSTEakcUlotYqjVZho963d3wDUdcLQZXMchVV8H3
 NRK+jAMkJGYIt2efkj7043uGI2DQkD+BuEtq1TVI4F4GBrZuRYBFrmok+qkiRkUDl1eP OA== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3juxqfdey5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 19:27:29 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 28SE8wUB028717;
        Wed, 28 Sep 2022 11:27:28 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.22])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3jucjjqc6a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 11:27:28 -0700
Received: from usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 28 Sep 2022 14:26:55 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) with Microsoft SMTP Server
 id 15.2.1118.12 via Frontend Transport; Wed, 28 Sep 2022 14:26:55 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 7388D15FA1F; Wed, 28 Sep 2022 14:26:55 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2] netfilter: ipset: regression in ip_set_hash_ip.c
Date:   Wed, 28 Sep 2022 14:26:50 -0400
Message-ID: <20220928182651.602811-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=892 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280108
X-Proofpoint-GUID: tnWnP2RrWiBige1GQSSRjPNPnjxSvZZa
X-Proofpoint-ORIG-GUID: tnWnP2RrWiBige1GQSSRjPNPnjxSvZZa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=868
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280109
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

Notes:
    This is v2 of the patch, simplified based on feedback from Jozsef.

 net/netfilter/ipset/ip_set_hash_ip.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index dd30c03d5a23..75d556d71652 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -151,18 +151,16 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
 		return -ERANGE;
 
-	if (retried) {
+	if (retried)
 		ip = ntohl(h->next.ip);
-		e.ip = htonl(ip);
-	}
 	for (; ip <= ip_to;) {
+		e.ip = htonl(ip);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
 
 		ip += hosts;
-		e.ip = htonl(ip);
-		if (e.ip == 0)
+		if (ip == 0)
 			return 0;
 
 		ret = 0;
-- 
2.25.1

