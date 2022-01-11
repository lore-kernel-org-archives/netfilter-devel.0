Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 05:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbiAKFXI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 00:23:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3854 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234109AbiAKFXH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 00:23:07 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TGqX006811;
        Tue, 11 Jan 2022 05:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=mLh14ABo1pwewfVLfdtzLwgVd6RT3LAIHhQ0s1vyYgk=;
 b=IAXiJGngvs41WA/m5eJSEBXGVjloPwGQGxRFx6JuDF9EI6lZuNaEoQg/2OD0vBGHh49f
 EQrA3ATFV4uLbRlRAtqMCy4kxZrzL5nu52Juy6eEigUa64HeN0KCgM/b+uRj5KLcoaVc
 3meBclQpQ0TRjYKT/JaQfsSgkPxy/KnnIT2/91SiwW+1jRsLBjOWix+hossjGlf3Zerr
 gjzqGrgRWkc6LPDMEiLstYllYFGO/x+rrxEir16WO3o3sgHlSlUnPOc9WUgdLtuLTKKh
 +LvifLAC+J2pw8AUG1zDZSw0PHHSfE4v/sYCXyrJPFn0ZctQZd7CP4Ojnwapss0eJKPI wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtgacu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:22:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B5GQN9090745;
        Tue, 11 Jan 2022 05:22:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3df0ndjeg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:22:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8JCNcXqNsgP95fIOyc/7/2B+YBqoVh2cuWvImLjUCeXn3Lj47DGBubL/X2989qEIUQo4KCMLfQ8mNVJ7D7lHq4yXX2a8Ml/WMyUNOCCtZvYgwl/R86QVyvYQFlxsmLNWp4mwSj3omeTFtvIAHooAlJTRK7Bk6ekoOwDv4QHAd8UBU2SEVNSCfQDyks/mbiJL+VgjrAv35C0xzNtJNWVy+kPmaC3JCP2npY7iUGoC+IMrwDnULfrDpPdN61rZzx6zV9PObNXquJkXCSgHvfeKHy2fh3draLrEnLZigMCzYWvLHf2q3gUT8AaoRryt59GemiPTO1Ns6g3EDmFE9V+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLh14ABo1pwewfVLfdtzLwgVd6RT3LAIHhQ0s1vyYgk=;
 b=YFw7z28OIomAkY2xkQfkiwgVdDRKNLn+NxC7AsN9dQ9CYk1Uy+WECjDhmiTicgU9r59+Zlode24x1o8rzgn2Bi9HjQP5jgarTKE8C0GAbmOulATARrt2jlCfiuLc50KebE7cRVmrmNxy0yN9XNCTxj8lPqsMPvqEgYsbMqpmoCh79Kk132Is3XasM4YbKF/97WNPRvwnoPIz6NAH4MV7OoPazrgz4B9H9glnHFXiohZtSc5dISWdQlWiYmPSjGeYaPtvBf4m4TNaLrzzrR67irZQN5iJWwQjshQyo383bl4bsLB4KrtPCyRGO495bKYg0jN5YbICUk0/aHs5hZPgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLh14ABo1pwewfVLfdtzLwgVd6RT3LAIHhQ0s1vyYgk=;
 b=o03tjHOvi/RwYGjKcdCDFw0HBkrDeiG8MZwxs9mnu4ehpfUr2vMuGrKMpW/8cjmc/3aYMlQjHfq7Ks7cf6sy/i5CyHtEq277ZakKN9haFRRKb7cnRgLs8PT5dw0AVq19VBhFB4lJO5HaqtNqfT+1shsCZv6DeHA/eFukg1HtKwc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5808.namprd10.prod.outlook.com
 (2603:10b6:303:19b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Tue, 11 Jan
 2022 05:22:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 05:22:51 +0000
Date:   Tue, 11 Jan 2022 08:22:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] netfilter: nft_connlimit: fix nft_connlimit_clone()
Message-ID: <20220111052234.GA8186@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa678d9-f873-4c11-2624-08d9d4c26992
X-MS-TrafficTypeDiagnostic: MW5PR10MB5808:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58081CB3C661EA8056B9BF868E519@MW5PR10MB5808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:133;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8nrmNnIsrUf3+SUgXA+nZYuQBS6mmbzppDIPUPcAueq0B3qM7+6M95YzSnelsqVD67gkOP/jaAVyGea7VHCDX1xooCxAUHJM1ShZYqJWyxSA8+TW7NI1BCI9veTERVgLrmuTd448RZud1/aQZSlKaGtF6nXKYDuZn33TRQd5Wda4nj0Hp5X6Y+lErrhInj5ePbBeZtLfyaHiaZxYZHRE+1iXsTfW04QfwjFFmNTVBVOOLbHuEoRPUzNPQnkKttMtUX2sG9mjn80TpdcSld6Kum0SMVGuYzmjjU8QB1g0iL8fCtgpebmGdCP7OI8PBFGfCMU+qqLYqrXLQbeH0tYu9nsveHGKFnFbF4MrNYGNH8ZIbSyyQ9DSlDb9rGCpXQ4FWruTsHDPWkAoozw03Fh2I7nR6jZdJDQA0/dvQpgokBhYtTw20qdJHQ+FzuGPNdIjYQD/E8V6uQssHsjxiQt4cfwdhXOHjXBt0a/5+EpRERrA9BpcoTj+o3/nqxmelq/vR1rjoIzPx0gjJa90VYk/yXQ+DGVMSKUj0USdHoCwm3UrAwY2wFP7m7mp1y3OZkN8wwnku+zrcQCGNIyeY8ou7Xcq3+Mvm7nUR1KY3yH5gL0jHne1J3nQpKqAABRpl30AHr5XevjDbNE9Zl1A3dT1SMCTUSLsn1nD4oQ14+eyt29GqG0QrYZiCa5LsNmT66uCK8Mnx3rIJaCflfA/y8Cuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(4326008)(508600001)(6506007)(8936002)(52116002)(316002)(38350700002)(33656002)(2906002)(186003)(54906003)(5660300002)(44832011)(8676002)(6512007)(1076003)(66556008)(6666004)(9686003)(38100700002)(86362001)(66946007)(83380400001)(33716001)(6916009)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3gfNZiCkSDBj8uSNOkPgiNU7jXeX2ZZZFzDj7RKyQqypSuU7RC7ABNEQOXhr?=
 =?us-ascii?Q?BzZePAyKOGeZu2cxSEx5phJO6Ssm7DFxKFwRYBXImLluE1bcyt7zN0byavKG?=
 =?us-ascii?Q?AqDyf3fdSrmq1ias31X5wyeWGiwhElYXMdKnD9glq/KepQgvOV2sb5yvHScr?=
 =?us-ascii?Q?F5WK8UfJc1SbbI3Mw5+LLw+s6NGb99w8W4FE5CiWVY1aG7j47I4Xeh3ZNknK?=
 =?us-ascii?Q?OcSPVfe/BZz79jFs1C1N/6RtLF/O3xdHmX8oQpdS4eqAd+B+lWW5s70evvtX?=
 =?us-ascii?Q?CBZ8QuSgru2c3LSTKoEFgQ7nDBi9Ss8q0Kb4NU8Bs3hPcrGIp0bnwOWux16E?=
 =?us-ascii?Q?HZ/ePIWAr42wV0yZr0RTJOgkaaTgePVOlw4pg17RnyyNrGzj7LBB5fyr/14R?=
 =?us-ascii?Q?kLpO8q5CnFKqRTbrpbeIEOpXru9z15EPgb0+uAIXVTQo3dWCQ1mt3vZkFoZg?=
 =?us-ascii?Q?fcU8+Qenv3IsdEccdoVBfxD7XEuogRoW78VJSnOR+i984tLICyRMULNfUvCr?=
 =?us-ascii?Q?d2HwqFcmMZT203pvcv6FVUqd4ugmoFros8bR/kRfi0edJqqeAJfKR4tJJdEN?=
 =?us-ascii?Q?kX6KSnn2tBY6GW2cOwTWa97W6qSzkgY9pS7xjenHnEJ2hCce1ncJgFNZETwp?=
 =?us-ascii?Q?de8JnbfvwqGii2aMLqF6Vo1q8gbDQxPhiCjDaQXqorCwYFrUb8ffq/yoyHNQ?=
 =?us-ascii?Q?2bh8dhFQNeLcaFIzW1yGDwTonGVzJBoZcAu3pIW9M1SFEk/y00+RGlO7+ir3?=
 =?us-ascii?Q?8eVrzDUf/yoyQ6eflQXThHX/G/xKJLj3iBjbachfN91bJRFfDmJzCRj5Nyeo?=
 =?us-ascii?Q?L2GWgZqTX9v/WHN+z9UHpnU6R3H3gY4DmQ6ZbHQd7FuuAiztrUPJe9tu/T5Q?=
 =?us-ascii?Q?eeV2Q9XWLoR0w6vr081mqeB27bjak0Mpr1XZDPb6cCuUWvgkRhHOD0x371U0?=
 =?us-ascii?Q?k7H3qbaLApRfUo7665q54waG4rrS9BS1ZporIDPFP//jIm5nFR1jqWYzLmlZ?=
 =?us-ascii?Q?La9FERaoysN50ZoSDX78ubJmxmNe2FTPxR9X5Mj39BFRjNA7JQepCazW+gB1?=
 =?us-ascii?Q?akDGQqx7AUBJrRoLzuPdhYXzAJ9Q+D0ThwXDKGtkFGgwL9g6CCEYcXCdY8AQ?=
 =?us-ascii?Q?5cGwDCYMwWD66Y8u6m9vZYIM9w7bI4usqs3fwLuUA62N8vSzaGQTzo79/wi8?=
 =?us-ascii?Q?7lVOf0VhQXLkQ8RCAE+26RzkYQu1XOzAqWwa59EZnrXX1XruFilUOMuBlYH3?=
 =?us-ascii?Q?DLjylD2WC+KwOJRgPJcee1nqyBoxOs8EcGqoQB0f5VEsDE6/9lIPT8e26+tK?=
 =?us-ascii?Q?t0r10zEjUV+Sbym0wRo+lQIVY0aPwPk1IGpj7dWxPXXDyKwnb3apak72/kor?=
 =?us-ascii?Q?BE+ZrvrngtlzjApUPpnr4rOO3Jc8JIggERq94z9GmuuxVfSPalheVKrQv0xz?=
 =?us-ascii?Q?Zl2zikJHMWdWZrTK3eVKgp6dDvW9HYAMCb7/IrlLav8K05hDEegaWrHxngDg?=
 =?us-ascii?Q?/IdyWKcqwrnmWNu4vMfXMiMFBCQ1nC0Y7NZZPsbdWm99NHW7OIL863iSGwAs?=
 =?us-ascii?Q?CaUL0A1GgSRH3ktB/bE6sVOqTmXQuDfILPf99kr2GZoOGJqjlfr22r/7QNoz?=
 =?us-ascii?Q?QdyV5ZswzamOTwsNgvIWMQKKHpImj0mMGCiuyhKBo3EnyOrIYRgKdrg3l8Xg?=
 =?us-ascii?Q?hZT0m9H+zrGM09sQrt4qeDsFIDQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa678d9-f873-4c11-2624-08d9d4c26992
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 05:22:51.2221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnnrqGXbMVa5tmnTHoOKuzLnVwWrjFj/F74nAtWsyVqDNTutBCQpDWVTrOJrXiC5/3IKNmQxj8bhxTWI2vSh6IVilia/4BuJG+S1Xpuz34c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110025
X-Proofpoint-GUID: GDLPjyOM4XHgIHBe63T8KLX340LFgSg4
X-Proofpoint-ORIG-GUID: GDLPjyOM4XHgIHBe63T8KLX340LFgSg4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The NULL check is reversed so nft_connlimit_clone() can never succeed.

Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Haha haha.  A couple months back I accidentally reversed a NULL check
and invested several days in writing multiple Smatch checks to make sure
that never happened again.  Everyone made fun of me for wasting my time
but who's laughing now?  ha ha.  <- me

 net/netfilter/nft_connlimit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.20.1

