Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21930C4321E
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiKJVcF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiKJVb5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:57 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D3C1D6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:57 -0800 (PST)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AAKxhxT004632;
        Thu, 10 Nov 2022 21:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=6SY+pj9uL8XWI1R1zeMSUyHwVM5BwGdY/HlUa3pZveI=;
 b=dqBlpfX6cyRlvD2dRS/u+fvCUE1CL+IdLbMpFfiMqqVxvLrWb6AXqocjq0kP7IVNMSko
 W2heaNibg+AV8fhCbk6AClg8xYmDCIHgs6mk+ydXMXwt65WEyGWG9gl7/RYCuMF2FFa+
 Yy0H3y0soljCcaj1LzB8H3HonQntKdX4u8PyoNr1JfzIffppqFWXx2cNN8kGdW9uUfDj
 bjboiGJL+WlJ4OT6AnAjTJOrzdYIDz4twyW14Nc/TNxqPRHbMRgyoCrUKw48nC/4ACsb
 3iPBUyHSpUQ+Z1vW4rq9Vxz2gIdoEw7kxwzhIQR+UvszWcFtBF+jGGOsHWkUU3LrBb8i hQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3ks29mtn33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:52 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHTP0H015249;
        Thu, 10 Nov 2022 16:31:51 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3knk5xj6u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:51 -0500
Received: from usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:50 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:50 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id EC5F415FA7F; Thu, 10 Nov 2022 16:31:50 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 4/6] netfilter: ipset: Add bitmask support to hash:netnet
Date:   Thu, 10 Nov 2022 16:31:29 -0500
Message-ID: <20221110213131.2083331-5-vpai@akamai.com>
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
X-Proofpoint-GUID: eMnrgvsRqAdg3dnveaWAlkFO8BSHJLCT
X-Proofpoint-ORIG-GUID: eMnrgvsRqAdg3dnveaWAlkFO8BSHJLCT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100150
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create a new revision of hash:netnet and add support for bitmask
parameter. The set did not support netmask so we'll add both netmask and
bitmask.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 lib/ipset_hash_netnet.c | 101 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
index df993b8..0e176e3 100644
--- a/lib/ipset_hash_netnet.c
+++ b/lib/ipset_hash_netnet.c
@@ -387,6 +387,106 @@ static struct ipset_type ipset_hash_netnet3 = {
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
+				IPSET_ARG_NETMASK,
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
+	.description = "netmask and bitmask support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -394,4 +494,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netnet1);
 	ipset_type_add(&ipset_hash_netnet2);
 	ipset_type_add(&ipset_hash_netnet3);
+	ipset_type_add(&ipset_hash_netnet4);
 }
-- 
2.25.1

