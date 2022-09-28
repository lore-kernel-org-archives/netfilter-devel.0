Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36B9C04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 18:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiI1S1D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiI1S1B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 14:27:01 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740F6F1910
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 11:26:56 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SFf0n1024819;
        Wed, 28 Sep 2022 19:26:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=l+2DRkNbi899b7HMhnWub8gqWspMi++MOCGo7pvvHKE=;
 b=hNZ+yjHQnYx3PdRSoxVPpGawd3cPFirGvVyU2NvWU2RNGSO97rQyrwh3An52H6zhe3VV
 h3H66AZkTqphgSjXc07u/Ve1RsbFrjhRczVBf0MEBYbHQcOn8a/klvGgIRPs36oKRB9e
 46PuXEQZnmlga2FtOW2eMd/EaEjiQJw2tZfrXDrADL4NbRyiQsWkOs3r1/dgaPhEY4DO
 ythK3Lls13EzsY0BaRXhX6QkvfC5jHaSb6YhkwaNgFz95Z6a5RSZJwFPPsm1D/no+Hx/
 DaXjVaRSjIe2vqbMzbRs+oENlMIkwhSeWwkkrW2qSVNceHdxeJUKDhm5dkDxJWSzs8ZX Bw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3jvpb219y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 19:26:51 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 28SF5Cq7002075;
        Wed, 28 Sep 2022 14:26:50 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.23])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3jucpt7jw5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 14:26:50 -0400
Received: from usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) by
 usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 28 Sep 2022 14:26:22 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) with Microsoft SMTP Server
 id 15.2.1118.12 via Frontend Transport; Wed, 28 Sep 2022 14:26:22 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 9713015FA1F; Wed, 28 Sep 2022 14:26:22 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2 4/6] netfilter: ipset: Add bitmask support to hash:netnet
Date:   Wed, 28 Sep 2022 14:25:34 -0400
Message-ID: <20220928182536.602688-5-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928182536.602688-1-vpai@akamai.com>
References: <20220928182536.602688-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280108
X-Proofpoint-ORIG-GUID: DUwSwenGTIdgStNP3N7uCyrfA03s9ErI
X-Proofpoint-GUID: DUwSwenGTIdgStNP3N7uCyrfA03s9ErI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 spamscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280109
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create a new revision of hash:netnet and add support for bitmask
parameter. The set did not support netmask so we'll add both netmask and
bitmask.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 lib/ipset_hash_netnet.c | 100 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
index df993b8..3898b8f 100644
--- a/lib/ipset_hash_netnet.c
+++ b/lib/ipset_hash_netnet.c
@@ -387,6 +387,105 @@ static struct ipset_type ipset_hash_netnet3 = {
 	.description = "bucketsize, initval support",
 };
 
+/* bitmask support */
+static struct ipset_type ipset_hash_netnet4 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 4,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.cmd = {
+		[IPSET_CREATE] = {
+			.args = {
+				IPSET_ARG_FAMILY,
+				/* Aliases */
+				IPSET_ARG_INET,
+				IPSET_ARG_INET6,
+				IPSET_ARG_HASHSIZE,
+				IPSET_ARG_MAXELEM,
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_COUNTERS,
+				IPSET_ARG_COMMENT,
+				IPSET_ARG_FORCEADD,
+				IPSET_ARG_SKBINFO,
+				IPSET_ARG_BUCKETSIZE,
+				IPSET_ARG_INITVAL,
+				IPSET_ARG_BITMASK,
+				IPSET_ARG_NONE,
+			},
+			.need = 0,
+			.full = 0,
+			.help = "",
+		},
+		[IPSET_ADD] = {
+			.args = {
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_NOMATCH,
+				IPSET_ARG_PACKETS,
+				IPSET_ARG_BYTES,
+				IPSET_ARG_ADT_COMMENT,
+				IPSET_ARG_SKBMARK,
+				IPSET_ARG_SKBPRIO,
+				IPSET_ARG_SKBQUEUE,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP2),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_IP2)
+				| IPSET_FLAG(IPSET_OPT_CIDR2)
+				| IPSET_FLAG(IPSET_OPT_IP2_TO),
+			.help = "IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO",
+		},
+		[IPSET_DEL] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP2),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_IP2)
+				| IPSET_FLAG(IPSET_OPT_CIDR2)
+				| IPSET_FLAG(IPSET_OPT_IP2_TO),
+			.help = "IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO",
+		},
+		[IPSET_TEST] = {
+			.args = {
+				IPSET_ARG_NOMATCH,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP2),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IP2)
+				| IPSET_FLAG(IPSET_OPT_CIDR2),
+			.help = "IP[/CIDR],IP[/CIDR]",
+		},
+	},
+	.usage = "where depending on the INET family\n"
+		 "      IP is an IPv4 or IPv6 address (or hostname),\n"
+		 "      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+		 "      IP range is not supported with IPv6.",
+	.description = "bitmask support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -394,4 +493,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netnet1);
 	ipset_type_add(&ipset_hash_netnet2);
 	ipset_type_add(&ipset_hash_netnet3);
+	ipset_type_add(&ipset_hash_netnet4);
 }
-- 
2.25.1

