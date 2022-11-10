Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B6EC43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKJVcF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiKJVb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:56 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BA11180E
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:55 -0800 (PST)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AAJJm5X009943;
        Thu, 10 Nov 2022 21:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=HhsHqRVl6X8+8XYF1kCJH+lcgwZcq66hZwQEKs2FZkg=;
 b=ReACHYrTCSpL1Ddbljf+B6dTVk8sdbjocJ6cLVl5NJrJoNkT7k47xtxLrjpJVXaKjdVU
 K6O8MSDOxJiqJilBsyRBRDLsKs/51huAgfdyOsAuKrYuL3twFc2wSPciViK1xH9B3vB5
 ihEDfDtZsnkmGAdXAgdsaC/0POqnzN5h+HELZmMmUPtjygJ5kn/VDeFTNnFzUIzYlh3B
 PwoqV3t9uE0P4Q6cK6zDyRK1v4t2Sc+YZ+E0QMPKhWEALqTT629jvaMn8kbeCBtfmHMu
 Rz9FHEzEhrUZyACbfB0R14gE4h16OJATSugBu7By3czRKl8SVmbQ2TYIOkS1SCgQHTtK zw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3ks2cmjqjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:50 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKwW8M031317;
        Thu, 10 Nov 2022 16:31:49 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.27])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3knk5xj74v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:49 -0500
Received: from usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:49 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:49 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id F1B0415FA7F; Thu, 10 Nov 2022 16:31:48 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 3/6] netfilter: ipset: Add bitmask support to hash:ipport
Date:   Thu, 10 Nov 2022 16:31:28 -0500
Message-ID: <20221110213131.2083331-4-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110213131.2083331-1-vpai@akamai.com>
References: <20221110213131.2083331-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100150
X-Proofpoint-GUID: -fzsRde8GdyHeui1VIwsyD2QMqMN45FM
X-Proofpoint-ORIG-GUID: -fzsRde8GdyHeui1VIwsyD2QMqMN45FM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
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
index 288be10..2fa8abd 100644
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

