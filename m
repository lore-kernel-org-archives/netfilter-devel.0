Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872D6C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKJVcE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKJVbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:53 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8EE1180E
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:52 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AAKUD59032487;
        Thu, 10 Nov 2022 21:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=c5Hee5QBD7qr/vJjxCHDdX4NHvGdb1sCJ7uO9YTJ2FQ=;
 b=OkuqUC/8f4TbWCFf8l/+CTGX2ivJ6BOgvPOk+nAjP67mmJIPNK4Mm6BAPZ87IImVN95L
 /Co7bi14hAmZLYpESl+lrvI38Bc4c3cPcwk8aJqWucU9So+MfsQpV+p6L+9U45FINnxx
 dl130OJuOC4PFapqzN34RA0oKDMXmInaN9qVVFLXLT5HoOHgilYPjo5Y/5DEIx+8CftA
 PlOkDgi3BiJaVHBHib9JF0PrHQlMsErZhtrtm90XG7AoUTg1LsCp3GM04+UwGkQYhh17
 LQJN5brI8eWKLU5jFDLj2pm+S08VT04YYleJOmY2ImEZi/lJvdnkAbb88rbAK8oJ9J0g mw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3ks24p2vcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:48 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAH0bOU014906;
        Thu, 10 Nov 2022 16:31:48 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.25])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3knk5xj6u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:48 -0500
Received: from usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:47 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb2.msg.corp.akamai.com (172.27.91.21) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:47 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 92A2915FA7F; Thu, 10 Nov 2022 16:31:47 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 2/6] netfilter: ipset: Add bitmask support to hash:ip
Date:   Thu, 10 Nov 2022 16:31:27 -0500
Message-ID: <20221110213131.2083331-3-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110213131.2083331-1-vpai@akamai.com>
References: <20221110213131.2083331-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
X-Proofpoint-ORIG-GUID: OqDKhUL-N_HkuiDWO8Hz6u0Uht14go37
X-Proofpoint-GUID: OqDKhUL-N_HkuiDWO8Hz6u0Uht14go37
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100151
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create a new revision of hash:ip and add support for bitmask parameter.
The set already had support for netmask so only add bitmask here.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 lib/ipset_hash_ip.c | 86 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
index ea85700..4f96ebb 100644
--- a/lib/ipset_hash_ip.c
+++ b/lib/ipset_hash_ip.c
@@ -477,6 +477,91 @@ static struct ipset_type ipset_hash_ip5 = {
 	.description = "bucketsize, initval support",
 };
 
+/* bitmask support */
+static struct ipset_type ipset_hash_ip6 = {
+	.name = "hash:ip",
+	.alias = { "iphash", NULL },
+	.revision = 6,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
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
+				IPSET_ARG_NETMASK,
+				IPSET_ARG_BITMASK,
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_COUNTERS,
+				IPSET_ARG_COMMENT,
+				IPSET_ARG_FORCEADD,
+				IPSET_ARG_SKBINFO,
+				IPSET_ARG_BUCKETSIZE,
+				IPSET_ARG_INITVAL,
+				/* Ignored options: backward compatibilty */
+				IPSET_ARG_PROBES,
+				IPSET_ARG_RESIZE,
+				IPSET_ARG_GC,
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
+			.need = IPSET_FLAG(IPSET_OPT_IP),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP_TO),
+			.help = "IP",
+		},
+		[IPSET_DEL] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP_TO),
+			.help = "IP",
+		},
+		[IPSET_TEST] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IP_TO),
+			.help = "IP",
+		},
+	},
+	.usage = "where depending on the INET family\n"
+		 "      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+		 "      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+		 "      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+		 "      is supported for IPv4.",
+	.description = "bitmask support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -486,4 +571,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_ip3);
 	ipset_type_add(&ipset_hash_ip4);
 	ipset_type_add(&ipset_hash_ip5);
+	ipset_type_add(&ipset_hash_ip6);
 }
-- 
2.25.1

