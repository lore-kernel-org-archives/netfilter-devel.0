Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B3EC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 08:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E7560F02
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 08:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhHDIeD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 04:34:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41284 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236596AbhHDIeC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 04:34:02 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17487GC5013527;
        Wed, 4 Aug 2021 08:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Ha+5uoVQbsL8+fHsn7bi5t0oC+DTX7hYD0AI4/WYQEY=;
 b=AohPDiAUM9TvLf9DoAgOhPvGXfOsTSil3GC67J+RHGRB9Z2leRmMyLFxilhDZeQ/Zgf9
 fdLUuOauT1yO060+UwTofoR7WKfdCMjIvWXnA2RSllwvPgCTO1di/cMUjXFfHWRqAT9a
 ToVxXrMw/o2iw1SQ3m+ok4XRJt02neBRJ/Eyx7DEPGyiOYKa3iRAnyTkVB8AiW+Z+FFC
 ssvNBTkxR2CSKe/QBTlzAKgAUyhB3j9Kt4fpdVcIj0PpRdqSEBaCacgCHVxT5GxAWEYa
 0Wo5OdND0APjvKM1otGWAgZl/55XV6ngwRSUY0zH9ah1SFGeQvCf6WpjH8dENY4K+hmv pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=Ha+5uoVQbsL8+fHsn7bi5t0oC+DTX7hYD0AI4/WYQEY=;
 b=RhCur5YiMZDLhnghsor77UDjvOo8/j9XRc4VzJXhE1xQzR7aSiJCqlF9esQZa3M2lvhk
 ZLsQCs7jRGp5Xf7dHEO+5FzNsa+9LwiAlJYgWEMvM23oQeClzPS4Q5NPJnSV5tV9Pus7
 Q5ooGQ5erQhR7mShnIdJwB9R3kA/aUSYU/q+x3PipOFqYwHETBKuHRL9rP2wbvodPwMX
 6zng0RGcOWIOoNItGzimMjGuVy03ZPoGG2WVEvlNGCzmGTX8Vx3mkbHpWaRJMsPBjPXW
 I3dLiJDduYJVXOW8XPh0Y3ZxroRgzhvO5vmlpYVgI35rOYG24E3KvhHZSdEEyW0K0vAN 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6fxhda1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 08:33:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17485XdZ005854;
        Wed, 4 Aug 2021 08:33:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 3a4un19afw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 08:33:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClYvhWXAWhFPDhwqPnP1p/K+7Xurtw0IcXFEWJaaqQjuommP0pIhTcvTpe44+M4w9FteVFz0SaOxDqgtoSwVf3s9fFezGKGcKutJCXiHPH2rs9iAR4xZ243BIVCvJmmJTwaiZ/o5RBFdBECfFdsSgBpXc+hni+13to9iJfDjjwDKkgcpOke1ulDkjNXuvAs4dPrFsiaNC0n9KTuANR96pszcUmKbBcKSOrv2dqhIv49IslndL+b9czuaxdz/sbGVVSl+RvrbafjMDA2VfypgwpitSlFAG0alfoG6d9pB7zxC/aDAEl3iN5w7Q6hcBNTs4H9k0N4PCut9IzyMbI/SOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha+5uoVQbsL8+fHsn7bi5t0oC+DTX7hYD0AI4/WYQEY=;
 b=EgNaauWgzCEVPLmAcUcJS7BVxJhx5FoazwdkOLQh6qRTY1XzcIHZYqXXfl+FDag4dNlbEvpGlOynx4jqi1YV1tKRo2szzXFJ6R1gUcBWLklY+nU2ETLhNyWN54dYEGrJ+ewCgdpZuelyfaUi8Xd1kAla3O8Rf56NzC3MbseIKXWpyPoOwOwHbteEEls9H4m2u8DcZGMUuctjKp46G+Wsss+3Xmb7w4Bc9Mbtp3RdykevbVCB/KqZoLzuHt3R6DZLeWBx5x60OeTefGuQMisoXWAfqNlmwmpaEVAWRyYJeflncVBkbAg2SzjKSszY5g9KTptclUb/KVphyUfIpiChNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha+5uoVQbsL8+fHsn7bi5t0oC+DTX7hYD0AI4/WYQEY=;
 b=sXQ66kt0m1BYVDPsgCzOi2FOrVX2eMnOydtJaMy6VAvrCVMW1cXug5Q8ldRxPnqmnZjiVApfTeWu7KhcZEibmq6ndOOyEmfT6a9L3yFII8myRcFp2YJrn1ZQ+UD8UoXdF/GURzp6MN1WDvrydFu3ZuvmRqFSNobfkC28wkb4M60=
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1424.namprd10.prod.outlook.com
 (2603:10b6:300:21::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 08:33:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 08:33:34 +0000
Date:   Wed, 4 Aug 2021 11:33:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: ipset: fix uninitialized variable bug
Message-ID: <20210804083322.GB32730@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 08:33:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 963d644d-1ddb-488b-7a35-08d957228c5c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1424E86D31CFEF882FC1BCD28EF19@MWHPR10MB1424.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KjvEyhhZCmqUPTpDPYwwrMyk8q4SEWfypGoHXsRW/GsGFoK3vzfGVylpuydTWAmLB0otyMIDbbzlMPzrXzvUVQosrqFfBbXK9KsE/a+DVw4wFXzy6QGl+Ox3TexX8bi7xjXGtF7keM1OLaVCCacYAdOMEZBmVj/dQvRcl1+EdPDMvPSjjSU/YOLor+N/fAuq+RBKAWO2T1mwpUVUuhoDaeE44XISKs7a52FwOv1IAX1sLszinYaXyBzKR1C77nNCkX2qHGmdWQXTJeljRO/vsNkzPewu9k/e1QOeJGLBrzsvhgf5lDGAyfKOl8Q3uvkh8Evb6XJytcd0Kdn0Pd7hhJKZtBZyFay8bfNWhHd4tzp4vpbc0fQQIJFtWt6vNjZP0Au38sFYinia2E4UN2NduwP9vDF2lIT7eA+R9HqNUagrSXnMW8dcyncJqaWCOovbkLN3VaW/fI/vCRB/bi5Gwvg0NY7Lvro4TVjTAtDPngGdXC1St31teSu7I3wyDYEzoKL3YQgKUrbE+c5u8UP4+kbu2qxrbRmJ97dsH++Xp4PHLPuW7RicNx2H49HTNrGKA0Hpabch+t3il4CbaaG8mhWwk0lRL5RT/vOSw0Sf2Pk7gp7Tx6FunnrR/kWs9IQRw4+/7fJ7nCCbUbWHZugD1NSojVQ9ocAEOBq1QKznsskBpKzre47XjJW4GZfTTftjNkIr/bHzaxf6aPfB4KVDFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(66556008)(6666004)(55016002)(66476007)(26005)(186003)(316002)(478600001)(8936002)(8676002)(66946007)(33656002)(33716001)(2906002)(6496006)(1076003)(86362001)(83380400001)(44832011)(956004)(9576002)(5660300002)(52116002)(38100700002)(4326008)(9686003)(54906003)(110136005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GsKZjVmtlZoKLb0q3zk7ecdPsFrXj8MMuyAo6xNX5FSanURpZz+X5g5cMXc?=
 =?us-ascii?Q?hclHbmmVOdJd0eqc3Waq/FhAM8li0cD+fiIRpzH3UJAIY7xSYk7Mcg+Uv7/5?=
 =?us-ascii?Q?CBHtkrrzrpNkbahSXTzqnJlzJRfug2xchG18YMejTooZIhTXpM1PdCgjvr1g?=
 =?us-ascii?Q?3OW13hFGMvytsLfgiKHyMFif46KBwnQHsxcfRkE/yjKUkfKKHJpnQI6OX6ZP?=
 =?us-ascii?Q?L6vKRc76HNfqGuxq9mluHmiLkS7inwW9ULt07x6agiSC4UujKfyQ40leLZLL?=
 =?us-ascii?Q?Oz1/2z9L1SXdw1Cpatedwb1XDVq8RK31QAB3GxwaQkmIYMEBjb9Nh8pkj2J+?=
 =?us-ascii?Q?s5nwN2LPxufhWMkte2xzsnqbe8B7TGdSzpTYbzoh8Ry6Q/2SF9FoLS/0NwHC?=
 =?us-ascii?Q?rAytT9jggBBVS+9PIucMb60F1t/a8cLbgDXDf/La7NGV+TzRiwAqkkwAZ7DD?=
 =?us-ascii?Q?8yv6lYgwmvHyCViGqXQHGELZZknpQMGxtAU+E7iIqQxhalJFeAor/OW1aYhc?=
 =?us-ascii?Q?C2/pJuIYQD7OsSZkdNfwfRrCHA20Jz+AiSF/oCi1Hfk1Y8eN6kYlm/OsT4wW?=
 =?us-ascii?Q?/RLuOfpNA5RZW1nzEZ22BIaW33hIiInPsjyLT0Uw3cYssP6WnHR2lsy/2dI8?=
 =?us-ascii?Q?dwb+P9NCHRYWrmiB/kq9a5SEZ/ajeEU70kM3JkQFNtNEylTsl1MovOAvT2Ha?=
 =?us-ascii?Q?8aAjMiusNkGAFd4Morzw9K0TGAEclwxrw41xun9BA2qne9rICD9YazvdhBSk?=
 =?us-ascii?Q?BfWeWj1RZHLaJKNvvsp3upEWcUtVjPyTv2+Ls7CCrdDgZ0aFZNJKOt2HpPbN?=
 =?us-ascii?Q?p+WYYhM3NvSRtt4lSVCqiDAyW6kI+jfYKWRCbCsDOHCMbQmpGztTsxLtOwOV?=
 =?us-ascii?Q?12zZQqbRha7tC5RzAT5ILi1Ue433cMbXsxPwXcNNhamd80DfzEgFWIiPNiyk?=
 =?us-ascii?Q?VvMF760if+y8AthroeP6LrpbYOTwwUTQCqjUHPwCC1vMFDauyFFuug8aFtzZ?=
 =?us-ascii?Q?GLYAon19ZeH0Dv/qlLwjLqE3l2q6SeAQKdP8Oell1kvw1PdfS2E1gi4xCr+q?=
 =?us-ascii?Q?1MjTrAwHPNtJ0UrW9FNJtvKw6TlOuTH/zCjs1GjVKcoJWabolKo1U/OYI2aY?=
 =?us-ascii?Q?yK+Cucm3urf2IRvzWElfk1GqaCAaSkDF/DJd8qGbvMoA34n0faE0A0pig0/J?=
 =?us-ascii?Q?R7rEwlbGy5ed+irc5/Vuu6rX9hh3B51/YOqPJWx/fx11rpsy2njL/GUn6AYv?=
 =?us-ascii?Q?B2sfj+YIJWIfERp4LFW0SRrTMpjcQVcnTdhpmyMCDfvz9I2WR0TE8jX+V+EN?=
 =?us-ascii?Q?Rs3PlGmu78pUuToCYqOYMYIS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963d644d-1ddb-488b-7a35-08d957228c5c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 08:33:34.7639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBXPKiHxddpi3oRyO8C/zFvLMUdw1RqdH3tTHj5yP+PgcvLzqRd4G1KqUnDwhj/WdKH1M29cEDuzi+9I2RPXNW48cO/SKjTZXX4SCZrohBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1424
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040041
X-Proofpoint-GUID: GXbvJ09TDImssxe-TrAhAqTQbO-jP3Xw
X-Proofpoint-ORIG-GUID: GXbvJ09TDImssxe-TrAhAqTQbO-jP3Xw
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This condition doesn't work because "port_to" is not initialized until
the next line.  Move the condition down.

Fixes: 7fb6c63025ff ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index b293aa1ff258..7df94f437f60 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -246,9 +246,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	port_to = port = ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
@@ -256,6 +253,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
-- 
2.20.1

