Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E6FC04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 19:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiI1TAd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiI1TA3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 15:00:29 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A2E6715B
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 12:00:25 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SIBVjr024062;
        Wed, 28 Sep 2022 19:27:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=MTt5pYvEHFTQqE/jgCxo2yvPN+2pVb3ARSelkiOi+J0=;
 b=H8mQiHUboMoh+lXUDMx92U9KpaP3pgc7nAfjd8RYRfmpVLoNqLdX/l6p6Rwrqc8Bw86/
 9V/CREcmbkeS5Ji6uzylplPhmtEV7QiDiC5ffTra8mqT0czq7gmv1Tg4185vX2cVfg0e
 VFPTZ1hFs/FNDRXt1DjcgCFqPoPr7ipqfsN5UuTiQG8oNSo/+5Q1JX+N8muKNZVy25wJ
 ze59V1pvJND9nG5x1lDFuLmOQVkxcdAfP613uj1TOG3qohesVjED8uOLvCEQqOJ1Im1t
 Hw/AK9TxpUrp/Lc6/j5cq/rNT6IGAsaDh+oByPGZkzfr20tM+1qhpJbmb1m1obx1OysI 5A== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3juvscwsk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 19:27:32 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 28SEfDEV006761;
        Wed, 28 Sep 2022 14:27:31 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.27])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3jucpt7jy4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 14:27:31 -0400
Received: from usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 28 Sep 2022 14:26:17 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) with Microsoft SMTP Server
 id 15.2.1118.12 via Frontend Transport; Wed, 28 Sep 2022 14:26:17 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id E15C315FA1F; Wed, 28 Sep 2022 14:26:17 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2 3/6] netfilter: ipset: Add bitmask support to hash:ipport
Date:   Wed, 28 Sep 2022 14:25:33 -0400
Message-ID: <20220928182536.602688-4-vpai@akamai.com>
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
X-Proofpoint-GUID: sYf5-ecSrcBSvaSsbHXpwfX0FGZEkDwn
X-Proofpoint-ORIG-GUID: sYf5-ecSrcBSvaSsbHXpwfX0FGZEkDwn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280109
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create a new revision of hash:ipport and add support for bitmask
parameter. The set did not support netmask so we'll add both netmask and
bitmask.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 lib/ipset_hash_ipport.c | 108 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/lib/ipset_hash_ipport.c b/lib/ipset_hash_ipport.c
index 288be10..1d20bbe 100644
--- a/lib/ipset_hash_ipport.c
+++ b/lib/ipset_hash_ipport.c
@@ -604,6 +604,113 @@ static struct ipset_type ipset_hash_ipport6 = {
 	.description = "bucketsize, initval support",
 };
 
+/* bitmask support */
+static struct ipset_type ipset_hash_ipport7 = {
+	.name = "hash:ip,port",
+	.alias = { "ipporthash", NULL },
+	.revision = 7,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
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
+				IPSET_ARG_NETMASK,
+				IPSET_ARG_BITMASK,
+				/* Ignored options: backward compatibilty */
+				IPSET_ARG_PROBES,
+				IPSET_ARG_RESIZE,
+				IPSET_ARG_IGNORED_FROM,
+				IPSET_ARG_IGNORED_TO,
+				IPSET_ARG_IGNORED_NETWORK,
+				IPSET_ARG_NONE,
+			},
+			.need = 0,
+			.full = 0,
+			.help = "",
+		},
+		[IPSET_ADD] = {
+			.args = {
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_PACKETS,
+				IPSET_ARG_BYTES,
+				IPSET_ARG_ADT_COMMENT,
+				IPSET_ARG_SKBMARK,
+				IPSET_ARG_SKBPRIO,
+				IPSET_ARG_SKBQUEUE,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.help = "IP,[PROTO:]PORT",
+		},
+		[IPSET_DEL] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.help = "IP,[PROTO:]PORT",
+		},
+		[IPSET_TEST] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_PROTO)
+				| IPSET_FLAG(IPSET_OPT_PORT),
+			.help = "IP,[PROTO:]PORT",
+		},
+	},
+	.usage = "where depending on the INET family\n"
+		 "      IP is a valid IPv4 or IPv6 address (or hostname).\n"
+		 "      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+		 "      is supported for IPv4.\n"
+		 "      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+		 "      port range is supported both for IPv4 and IPv6.",
+	.usagefn = ipset_port_usage,
+	.description = "netmask and bitmask support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -613,4 +720,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_ipport4);
 	ipset_type_add(&ipset_hash_ipport5);
 	ipset_type_add(&ipset_hash_ipport6);
+	ipset_type_add(&ipset_hash_ipport7);
 }
-- 
2.25.1

