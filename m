Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6C5C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 07:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348451AbiAKHVl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 02:21:41 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46710 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233066AbiAKHVk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 02:21:40 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TbtD003756;
        Tue, 11 Jan 2022 07:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=gIi4LdYd+GBvkAStWBDqKBf4xYqccoKr6lUPOMk4Wto=;
 b=tuIYH4ohv5xXw2FGW0NdpQxKVKTn1xXdux1t9D+sVN4lc80WaF+rVig7yTu7z/JHMvv2
 9g6zJR1QBENPmXbUrG3BKZlaLJmkoMnSZ0e+GVfd4yJSaCxvl50BLRP9oxnJyCCyw2p2
 BRf0VxOSgr95f2R+Q6XlXwtlQtYvyH8lrCVshQzE1JohIm1y3dZHklaPDRwA9LvWsfXr
 xeJ+LCCiJuX5e8XrUXR2vUSG1bM5aoioBVfeAMSFr4TKrrAqs44237AEfbpRDOKBie9m
 ALhbIi/dtj5rxdfOcaXG+1LNTBJlamY4Qt6ANmqV0Trfcp3m3jybBBCXOOB5KqqirLVa SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk9aave-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:21:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B7Fv4s027958;
        Tue, 11 Jan 2022 07:21:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3df2e4ddws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV6eqoD7Cb/BZlPEaJodcGzP/Co+AWWw/Ce0CBqILHVeQ67P7H/zJS6t+kJ4OKisYUmOnJ8ymrYfCiNxzK97/u0QDayYjfXl/yW8j+/fsMmfkBuYiZdP5AoK/J422EBUSnLvmAgfoIlmAgDJ9OLjyJnRC92G28f3NX8fZMSnUBZ6PqU+R+EqLHzRkAhb0vOCnTHY+gKSUp6OmxphuV6nko4vjexmq10Jzrub+0C1yBlRYwwsFS/XTfvdngkrJTsxDXcAJJvPjxaTWpViTOsx/7qI9Er6+7zKoDnd4n1ir1bvekZCbA5UAS3Qg/2y/o9S7GbwFvmcHR6UeWcPQL08OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIi4LdYd+GBvkAStWBDqKBf4xYqccoKr6lUPOMk4Wto=;
 b=gPiAbfPe3xBRsKVQ3ItP0tcHzG9Y3qqTkHuJWQdxw89wScogclmkdknxAhe43w3/ZSb3Wm+9N1YH6L/ctOZOnu2q9xAmjxolcECsdO2xEUVKGoX0CfPXEm+dd5w30Z11NYKfM4BoAhOt5PQju1mZt1Q1nmKZygYkYrXMxL6PaLYx5WId2n7jVdOaQxM5Aobn9o1hoMvTI5yXMHkQnZCWn/d7Au5j8nVJyvkEZela8NAAf6hvrTv0aWuDpHRYDCT8pbmVm+AXKwN503jw41wvsStAOmGrsI3zXoU6LgWO3aLl/hy2BYKAiVXL3SOpSFVV5W68L1KqPizAId3ffM17YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIi4LdYd+GBvkAStWBDqKBf4xYqccoKr6lUPOMk4Wto=;
 b=vee+1IwFLrnDOSmY3FnEE8ie+dpN295puubOE6hjB4LLclmY5BThpJNzWFscw+jGhMbel7VDW2aSRCDTyXj5iOWHROYwpaERb29YipiGtJB/7hNmkDCS0e4q9/QkVOnAr1DI/ntIrpJjQfujfpxYvMX4I/gokm81hmF/alP9c4o=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1421.namprd10.prod.outlook.com
 (2603:10b6:300:24::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 07:21:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 07:21:26 +0000
Date:   Tue, 11 Jan 2022 10:21:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] netfilter: nft_connlimit: fix nft clone() functions
Message-ID: <20220111072115.GF11243@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0102.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3638d41f-ceaa-42a5-e0aa-08d9d4d2fa8e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1421:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB14210A0141E1BE89FAC78BC38E519@MWHPR10MB1421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEgSKXP3iP97RfTMD+hLNQX/rlA6EZY92vz4alyNsku1l3V8Tni6zJE3oNVThdLyw8qOEwzdCkREaV881ljDD02cnbmS24vy2U+Tl5kHL36weHs/Hlhn+vTNTGWNbPNXuHN+jakOsENGqtfo59gbO1kpHyMgbomonQ+8+HEkFeO3jvQhsyHyl9Ne8JnEYjZqobcoAGFpWcPdzdcbe1CjEXllWe7l1R+vSQ6bREV6G5DJe14+AwIkh0hKA802nqJXuSwf9P/BUaEQj05R+n7agrapCbouswaYS2WVKKKD5E8bjclTSYBr4LHw4D6qD/s9b80HqDmd6Ibz31zYXJVGkl8X4+7AKyioPq4qpMS7yGPV+cf58LztyaVyz/eASMnSZP6Rp07+d7su0BpJNpkj0HVVkB1MXwaKVRhipc60EfbEVXT0fHGbQTwD6waNSKsvInSgVdwVQzbCzpjpwOfGyhbJw8hK1N0TEDq/SbXxGd03H4SbjN/Ywlk5Pfk3mqCmUj1updRmdYOmtDbIxls2WbrIXdouIq8b6xJ+Yxd3wgiMJZQ/4PB1BHq+TaDrWYOoqM1L7WhCNrgWLaJ+Kl1rjsqal7JhxAI2AcZpivyGBgj+PYrcc2W8+rTgHyTVe6B1riaMATq/eAKZYXIY1/ab6zgf2nJ96EDo1vcSFJ2y1ZMVjqm+vZBw+9U6rMa1S+TmjwL+yK2d4/n04nRek6/ZYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6666004)(66476007)(1076003)(6512007)(9686003)(26005)(6916009)(8676002)(6506007)(54906003)(186003)(8936002)(66946007)(6486002)(66556008)(316002)(83380400001)(38100700002)(38350700002)(5660300002)(33656002)(44832011)(4326008)(33716001)(508600001)(2906002)(86362001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t9KHKnq5+u2SnMdwnjxZq/Pi33jW84qnvZsM5lq51xIf5ocCIt3X3x/WxiVE?=
 =?us-ascii?Q?+DvkDjkf/5CVsYss1CVoTSnpv7Ycv5q1SNDOFRTrpKk2EI11Ys4AaagJ/oc9?=
 =?us-ascii?Q?jUigGWG1uvis7bLGe3G3kZ0zsN3a8kCTx9WTxWiEha2TDkS5EY6gHGMSpqBW?=
 =?us-ascii?Q?jZE8FBbgWcNNDXQQ7tWEMPLsYdJ068bDQXjEgzhE2fDJPWI2kCQIC7Kk55WA?=
 =?us-ascii?Q?EewGaQizek/0/yQMQkgiodI+iHrTdzOocNPAr3+Avia2rOaCJf5vVZhMhYVI?=
 =?us-ascii?Q?vVmgSOAz0NEKEu7so1tF89NL8h0luSTEs5DLQKFGwMNl9xlJ9wmfGLhVUYdr?=
 =?us-ascii?Q?aLJWY/WWdV+nnu9RBPEyFQzzeVyMP39mDL4YuusvpqXV1PMoTHT12niKvoqv?=
 =?us-ascii?Q?QAtcsn4iAJw+WMqC/xY9HzJToqN/PENf1Rqgl8C4x21F7pkvowCjT6/tj9Eu?=
 =?us-ascii?Q?StDSIEOjJVUorM0GaHAX1YViAEsDUthC7T10nkRC0PlbRGvfjl/vFOt2jHD9?=
 =?us-ascii?Q?s/baHpsEjFIrtWxo4INR4fyTLZ1G70zQEvDc07P+RzX0p82lhoFpFd0YlW2s?=
 =?us-ascii?Q?SHlmjdr0BiTLxOD5nYCP030lYCw815Ly/+A0S5wzI3hQ/rxuPxne0qT9m0EK?=
 =?us-ascii?Q?w6UgKoGCOJefVFuQrsZ5aPkzO9tY8rLDVIySWokpCQQFekC5nndGgE77ETNf?=
 =?us-ascii?Q?IFi2efkgTXHrVcxvJQQKvlWFzoKZKLPWwsisK/SpagU+vzeyQhaRoAS5GzFg?=
 =?us-ascii?Q?GgYGPSEvfYTB+odjnYAtJcLC+uqe415hYIlCviNIr34Uu1GWgq18lCz+AVb3?=
 =?us-ascii?Q?ylDUrwcZXi9H2iqGW4BdgIrWjk3YA7wyxf0OdFYEz2tYyZwIsN4aF2H1zdou?=
 =?us-ascii?Q?I/Yzy2LBpmhrv4QnQI83awOMBZsR60OMsQgNAlsC7HhrzB7Ujp2ZTG1vQAqA?=
 =?us-ascii?Q?LxVU5G+xQjCkzLcUYSQsy9ZUfSzPBiZ1ALIa/gV8e2oJEJPf9NYtZ2cRfYAA?=
 =?us-ascii?Q?teA3P6DGSOUV/L6VKubzEDxWmVPCVc34+JKh8x5ALg5AH8NKc4A90ICoXrbh?=
 =?us-ascii?Q?ngQNDpXxJqVpbrCyPSa6+JEH1jgG8b0gMgQPtLz3qJSU1nvV4B67V48OIuEy?=
 =?us-ascii?Q?LZGezWhbJdSzPGae0kUxzfP3c1B+/r7EHDd9YAHkpYFohfNAQTY+KJ6eFpxB?=
 =?us-ascii?Q?qs7td8wMZZgJXZ6JBBkpDlv0G7ygJxXmQPCuKbL6/ufPuhfvyRRPDRZA4YDe?=
 =?us-ascii?Q?i39qIW0tBBKtUgF3gmIJkzHNg0TUSUZP7vk7sSBjGEoh5DASQut19NOszN/R?=
 =?us-ascii?Q?0Mu8wo/n4NrIw8KygNs5BPiXTtRZMAFoBDFDU4iUtnYpBPXtnPTiz8pi4ir4?=
 =?us-ascii?Q?s1CDWrmjHli3XKXGFB5tqrhQ0TedYGrdC5/2TTTazmDDJo947RmZJ0DIEkM6?=
 =?us-ascii?Q?AKTgBIzq35C8gVTL1GcpqLCE87OhJswaeY2VroFxowRqleOemRFE6D3WBPXy?=
 =?us-ascii?Q?kFsj7rEyvsCi/4FOMwP5NNrKX7fif+98EJGboSiHhdQhj9ffhc8D6mmWf+dB?=
 =?us-ascii?Q?UMgzk6l6s471H7y+mWygLOcr+Fxyq2uU947ag8/y7YPe8uTzWpnUsgTqfTji?=
 =?us-ascii?Q?3K9ELszCXSMcf5dkI1ERWEv7TpGblf4P6ToG6qfDau0NW6atDNqjuWsRGSnY?=
 =?us-ascii?Q?1sa+KAh+lIdQRpg5dP68ZC2IEtk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3638d41f-ceaa-42a5-e0aa-08d9d4d2fa8e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 07:21:26.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5A9oJNREljzX8EOqx5HR6IhW8xghgCieNtcUE3amhGK7ShLgaNVe8jd/NW8VGDNFzqiBY64Z1gI0kBQ7kuiuSeZdxZKvwbgFwyvSmYU1Uyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1421
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110039
X-Proofpoint-GUID: E6WU5dlp2z9tikWd_0kOSimZCfjnJ08u
X-Proofpoint-ORIG-GUID: E6WU5dlp2z9tikWd_0kOSimZCfjnJ08u
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These NULL checks are reversed so the clone() can never succeed.

Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix a couple similar bugs

 net/netfilter/nft_connlimit.c | 2 +-
 net/netfilter/nft_last.c      | 2 +-
 net/netfilter/nft_quota.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 58dcafe8bf79..7d00a1452b1d 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -206,7 +206,7 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
 	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
-	if (priv_dst->list)
+	if (!priv_dst->list)
 		return -ENOMEM;
 
 	nf_conncount_list_init(priv_dst->list);
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 5ee33d0ccd4e..4f745a409d34 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -106,7 +106,7 @@ static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
-	if (priv_dst->last)
+	if (!priv_dst->last)
 		return -ENOMEM;
 
 	return 0;
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0484aef74273..f394a0b562f6 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -237,7 +237,7 @@ static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
-	if (priv_dst->consumed)
+	if (!priv_dst->consumed)
 		return -ENOMEM;
 
 	atomic64_set(priv_dst->consumed, 0);
-- 
2.20.1

