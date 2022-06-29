Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FD1C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiF2V6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiF2V6a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:58:30 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687D615A1C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:58:28 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TKM2d3007245;
        Wed, 29 Jun 2022 22:20:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=FlSY9Y8lRo8QUr2sVZdSrX3clF59c06K2kGQj7jxP2o=;
 b=pGfNJI0tArhqkrR5HAODXpZuvafn3YSkvcfsuZELJsBFoN6174VnJMqfg6Cic+LO8uzK
 O1CS7BOPucEo/rx2jHsq7oPmWIuCoHhx4YIxwI7LfB5dkUKxl0jHi4r60YdQDoleLWIs
 BF/JGpzHqJZMLxC2SapkKo48Xzerg+K8tEkMSyQP/jf290NetCYHppMMu7LmCGlQyJH5
 cJhlWF5FBh/q6T6IZyKlZ6WA2dTr0apfKlvz/L4UErvMjhQnlQCCCP/yToZdZ0b8Akiw
 ew74C8XBQk/9O3oAD93c3p5Q9BzXHiTNGa2JCk7JOzH4l2qZS9Wh1PYf3Meiit1Y+nH0 XA== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3h02sqfp6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:20:29 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TIRd30016408;
        Wed, 29 Jun 2022 14:20:23 -0700
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3gx0b9xvak-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 14:20:23 -0700
Received: from usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) by
 usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:20:17 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:20:17 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 44DA115F504; Wed, 29 Jun 2022 17:20:17 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH 4/6] netfilter: ipset: Add bitmask support to hash:ipport
Date:   Wed, 29 Jun 2022 17:19:00 -0400
Message-ID: <20220629211902.3045703-5-vpai@akamai.com>
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
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: XC3avCRQ-iN-Rskes2YWuPTRqbaxGZCX
X-Proofpoint-GUID: XC3avCRQ-iN-Rskes2YWuPTRqbaxGZCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
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
+	.description = "neetmask and bitmask support",
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

