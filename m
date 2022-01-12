Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F31C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352802AbiALLQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:16:33 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63212 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352801AbiALLQ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 06:16:29 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CADuYM009456;
        Wed, 12 Jan 2022 11:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=9NgrOseOluRzVfL3+0+GutEXtdUMK6h4/OGJk09N7lY=;
 b=ZO7axINdla0Bu+llXQscH3+QfLfOukHsEE8hdIkKVJVg8v1+jaCSLIR1epKBMutNzH+G
 Jy5hjZiiChHMKy3tn9eEYibtXzv0xhep1aqpWm3rMMi8gNfSblF/reBA733A8B6QiAKb
 Tpx6wbMBcb70ez14Q8LbYwJaMQWntUjKdnvb/oxcu+o1Vz6/HlbGV811Td47oB9fel7q
 T4e48ccJPi4ijeGKYscekl15i7ziBbU1VK1Yb13ke8M9HkMW1QaeUZ0SsHfWqPprW6kS
 InbxxZrcHWrwexeZQW4DxB8PxWeh9FLmzWLM/V9Ltpgnypbe0n8E39ZqgnvPptaJajFk Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgn74dsv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 11:16:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CBG2ll023834;
        Wed, 12 Jan 2022 11:16:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3df2e64g95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 11:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+vVqj+Qdwu3ddoxb5mofcixB9eJrDLkp6l7Ql219s0NuXdqTeH0JpMWcDCQHQBqqCi15F0Kp4VNXYfT0Pzgd1WQoVMotbJ9jfgtrpBAm7ZRQ3wloQ8zSQM9JVU/Tyad5RBzXhfcQwTSHQC0BBgyczQES05x1v0yNQDAHOEccsrFRsYuBvyHAwDcG9WPXGfLwrbKstlR+WZzw/xRBDofdGkDTZLD6IThMd8PTAxM4jW9FFIIXV1l2kv6kDybr+l1EireIa/GKirKcmXEK8/0WEfhX1zRuSS61ZKHbsRO9F3CEMGKorNNcYkIo4t4uus48esepSiUSO9rM6RGlurnCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NgrOseOluRzVfL3+0+GutEXtdUMK6h4/OGJk09N7lY=;
 b=f9wiN3zBD+rZE/mXsCuHxZZPz31OZdlP7hJYHhq3Xh5UjGCbuwCi6Uw619rlou19ccRbD01E95Kw/ouoSIm0bzf0nLAZD5XXlE/RR/5BtQs+ltx7kXHEUWyEYm6SDYZTIU6tJjI4P7FX4rb+GpS4WdYD7cl3dSSYVFLxruDqCWPnbICI6saI4UeAnW5wGuWRtMLactLewu/Xofp0Nd9ZToifh5+sKOE42/wsYbjHABRHDjyQ6GzaNKtXbEJMh7c2xjzxqWRG+6wxHDYt+oJrcdrF7tAxNtOxuqNh3VU2bx3QKw1VTdTBNzEJppIemf3+ZvPSxx8f/IJimgEEOIgzsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NgrOseOluRzVfL3+0+GutEXtdUMK6h4/OGJk09N7lY=;
 b=U5viLPNsPsDl5Qd7Yy32YQJMQZhM+dYZHvUC1mFu5w25j4k/PLP8nnNlidtt1IJ7PJgupC4JyWxM+4f0Y/WUGkTe/SsLmJXymzd6lL+Zo2rYGq5Z6fOAkD8YJf4j59eUhBKPNUxrTA94vuDbSLyMTq1UTuN3VKvF5LhcGOsZBE0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1550.namprd10.prod.outlook.com
 (2603:10b6:300:25::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 11:16:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 11:16:19 +0000
Date:   Wed, 12 Jan 2022 14:16:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nf_tables: add register tracking
 infrastructure
Message-ID: <20220112111608.GA3019@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b987036-9fd8-4d8a-3a85-08d9d5bcf509
X-MS-TrafficTypeDiagnostic: MWHPR10MB1550:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1550AA2D69A696F406EE08A48E529@MWHPR10MB1550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0kFgUbwnNjuz8KFvKxVTtdtx1AjmBq6a4yLLuD+5hohjiMUqQpQ+hlhwzah1XeMeJzAX2zyj08MWLXCbvnssw/7Df9ooNca8e07wEr7mvuL+6uK4wwKQmHdzQkruhxa3z7SOR75+S43hTzs7CixkvXQlSKFfbg5S3W9gouDyzlIRpY43B11TjZ32DaSlOCAxylELeTN9Ok81SvzZ+BD56emTe6Soid289Zu4aKQveKPp73YkVYS8stQf2q1P5o2phBywi/iXOlm+bvcJPgGHvvUJvnLJk1xwJ9O8xmcO0yMguCCD/YCnLKZ4v3aNSZmjktnY6hjW/nWwblh8hFn9soiKPX2TZEztg/2yQbVyYz0UNWiyVjRn1xLyd6kcjrL9qEwa8utRjKOA5aTqBRLSHuM9Vs1BOZIy4CBanS0X3V4sChiXoX7HFRVOhA103digaNdRgxGP6n1jUnr1eM/RSzDaUnCWuVmTtUi7aPMh2cVSNhPHhTWefVKhoW/L6koVfo/jdNE7ul+aDQeMdkT1QadwmSp9+n7iZS/os9XczD+nDAGo2AGvtl8YsasLKbzUrMfiWPyc8VXgeGjo144JT8DapcXBCyNwym37IQP1Jj65SjiDzAk1M5vxxmnYw/i3gQJ16vV3LDvI4//24QgRt9I1WlGAB35KAaCI53h86ic4vrVn1LiZLx0TpZQL8QydhopUUHIoHiAR5LEOI439A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(6506007)(6486002)(66556008)(66476007)(38100700002)(186003)(8936002)(8676002)(6916009)(508600001)(52116002)(38350700002)(5660300002)(316002)(4326008)(2906002)(44832011)(6512007)(9686003)(66946007)(83380400001)(1076003)(33656002)(86362001)(6666004)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gzj5/9IhjEoRyBx0ald4NZeDqVx9+jkREWFWVoNYaK5hKP1JVJmHGt9xEwcf?=
 =?us-ascii?Q?JFk3WNW+N32HNH3zDYZgmkri4Hz9gc/tqpCbPLwNLiw08RY339OsVdutnBf/?=
 =?us-ascii?Q?TUpzP14Mee1bjDP1e+jwjNBm2bAb9RP+PhPRiiI0uBWbVqMSPTgUQCr2rW8k?=
 =?us-ascii?Q?ttEw5bFmgcmlRQwNi9MoajVbhxfkc6chLI/8O0+kwUf5fm8o4oNWaLI3atMn?=
 =?us-ascii?Q?wcUtu9gMTK1ZPTkuO8UDnMZLEKCA6wXq8L0aSacrRadPIxPbwI8Zglb13VYD?=
 =?us-ascii?Q?rDw0vNQ6rO7Sv4coCuIT/+Zs7vEoQa/I/Fgs5CHavYmqVo41HBqfT0YCSfcX?=
 =?us-ascii?Q?lLBfS6wIAfqjRUhKQQIceWBmbZ3ygBYmbFYvWGQ+mkS1X3v5fZhWmDLfjy61?=
 =?us-ascii?Q?kypYx6So8eSEp9FBpsCGWv/esF//XgP/tN1LMuXZJ8OI/Dn5hBd0jYt9Q1AO?=
 =?us-ascii?Q?apYWxoC+3q+sir4eJl4HW+XPSHTI3Vc5YeynpivpdD7nzlDl7QB+1YmvmqU2?=
 =?us-ascii?Q?jaN+18xeRVlG0l9ayOPdt7AHIp/jKhksRHB/da82Y837mMsO/nD0K61cLM5B?=
 =?us-ascii?Q?KcyAdsMJfNjA5sxEY0ELW2VJjnWshIE3WxDpavc0mc1Ng3KmObFaH3DKBLtx?=
 =?us-ascii?Q?Wc5k//Pcp7nCrovBNw4FlHI6eElGYDN6eduYp2edViNLtwBJVAaurAXMjoge?=
 =?us-ascii?Q?J78zTuH7Fs3PI59iru7sZRdlgjvQkzrpjuERAPoRcUc45rmS/408tcpWE4zC?=
 =?us-ascii?Q?szU3Y1h/p3S+pJd9chWYT0IJ5uZGzqQDwQnBZJU2ZGK3BAgbOGdc6C6Z9GnT?=
 =?us-ascii?Q?O83kFJPS28xU649JRvaW0wat0f9oLCo20rS19RIfBLyyt7gysp+vlB2qlXLH?=
 =?us-ascii?Q?DiDdkw7igtb9l7TladD1QHB+H4y3vxUhmog9dSILfUGevBS1F/cNbkKflnw7?=
 =?us-ascii?Q?ssBClQ/3HFQUFm3drrtLsPUiMH+bZQEB5FrCbntVSxOKOwEP0c8Vz6G9Qzpc?=
 =?us-ascii?Q?IQOzCkU189xAxAPwT19zp0aqgLiwC+qz2wxj2bbm0Ct/jmlfEXdIVV+zcDCb?=
 =?us-ascii?Q?RjLPK329TuMM6kLUwLuR0V2NEVSeiPwJYOlQlzsZxRHcoZ0jhxN8gIfMeQJR?=
 =?us-ascii?Q?CH5n/4eZpruWYXzkMuPX8QU5Mo587Aw/TKKx7UcDtoEGDywNYBKp9zN9H/XA?=
 =?us-ascii?Q?shBVSVnWymTtABWsAPbfXT1r9yKBHXP9/tKhwP26IcTljiEOB5SxXzj8WEIl?=
 =?us-ascii?Q?dHKSJ/HTYk4RiHKDXvfJNogXTKAbM9clGJ+eiaYEkoi5JsOhiqZN5qvPHeFZ?=
 =?us-ascii?Q?y9w8dlKycn3nXV8/+PJTt0F6nbKf3hkUtSXQWKOU5nXixK3cxJTL+8CInvN7?=
 =?us-ascii?Q?PbSeOKkRRJDt2bKB8QEJcEKr30NP5uK9aR4mwqbRV3ZOzYpsvVZJY0Iq26ya?=
 =?us-ascii?Q?ss9fuVeZ2SwnAXkbgb3m0k9pk7ebcxPeNhnqoG9JizCssrx+SlpkT/HgwBQH?=
 =?us-ascii?Q?kO02kd26XQY7sVTaQvBeR8KCdXfH6ynClWJsXvKlPoZWVB3rz6b+CGJljudm?=
 =?us-ascii?Q?CEsLaLVFUIrb/jOwiKyl80+pCFh7buRkCPJkR85QWFisuA8AC+vtjUxWXWqW?=
 =?us-ascii?Q?VClDbQG39+prxBwQZZXHjvhYFf4yDANIvJzuRDQtIW5VY0BEWuYvHoo0uJmG?=
 =?us-ascii?Q?gJHjl2evpyC4BC2uhk3v7RwbdOc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b987036-9fd8-4d8a-3a85-08d9d5bcf509
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 11:16:19.3257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDt4Al3wae0pV6b4umV+cvmUi5dcCw9MKWUlQS+E1AKcogdfxbNh4gggeNi1SHyHZp9XWgC3dlDjDXEYfQBer4pVdzJXSb6uCD0CKsoYPDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1550
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120074
X-Proofpoint-ORIG-GUID: 3_PjpNraEHNFANoNdRzkRyHhn_u6bDBi
X-Proofpoint-GUID: 3_PjpNraEHNFANoNdRzkRyHhn_u6bDBi
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo Neira Ayuso,

The patch 12e4ecfa244b: "netfilter: nf_tables: add register tracking
infrastructure" from Jan 9, 2022, leads to the following Smatch
static checker warning:

	net/netfilter/nf_tables_api.c:8303 nf_tables_commit_chain_prepare()
	error: uninitialized symbol 'last'.

net/netfilter/nf_tables_api.c
    8259 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
    8260 {
    8261         const struct nft_expr *expr, *last;
                                               ^^^^

    8262         struct nft_regs_track track = {};
    8263         unsigned int size, data_size;
    8264         void *data, *data_boundary;
    8265         struct nft_rule_dp *prule;
    8266         struct nft_rule *rule;
    8267         int i;
    8268 
    8269         /* already handled or inactive chain? */
    8270         if (chain->blob_next || !nft_is_active_next(net, chain))
    8271                 return 0;
    8272 
    8273         rule = list_entry(&chain->rules, struct nft_rule, list);
    8274         i = 0;
    8275 
    8276         list_for_each_entry_continue(rule, &chain->rules, list) {
    8277                 if (nft_is_active_next(net, rule)) {
    8278                         data_size += sizeof(*prule) + rule->dlen;
    8279                         if (data_size > INT_MAX)
    8280                                 return -ENOMEM;
    8281                 }
    8282         }
    8283         data_size += offsetof(struct nft_rule_dp, data);        /* last rule */
    8284 
    8285         chain->blob_next = nf_tables_chain_alloc_rules(data_size);
    8286         if (!chain->blob_next)
    8287                 return -ENOMEM;
    8288 
    8289         data = (void *)chain->blob_next->data;
    8290         data_boundary = data + data_size;
    8291         size = 0;
    8292 
    8293         list_for_each_entry_continue(rule, &chain->rules, list) {
    8294                 if (!nft_is_active_next(net, rule))
    8295                         continue;
    8296 
    8297                 prule = (struct nft_rule_dp *)data;
    8298                 data += offsetof(struct nft_rule_dp, data);
    8299                 if (WARN_ON_ONCE(data > data_boundary))
    8300                         return -ENOMEM;
    8301 
    8302                 size = 0;
--> 8303                 track.last = last;
                                      ^^^^
"last" is initialized on the next line

    8304                 nft_rule_for_each_expr(expr, last, rule) {
                                                      ^^^^
here

    8305                         track.cur = expr;
    8306 
    8307                         if (expr->ops->reduce &&
    8308                             expr->ops->reduce(&track, expr)) {
    8309                                 expr = track.cur;
    8310                                 continue;
    8311                         }
    8312 
    8313                         if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
    8314                                 return -ENOMEM;
    8315 
    8316                         memcpy(data + size, expr, expr->ops->size);
    8317                         size += expr->ops->size;
    8318                 }
    8319                 if (WARN_ON_ONCE(size >= 1 << 12))
    8320                         return -ENOMEM;
    8321 
    8322                 prule->handle = rule->handle;
    8323                 prule->dlen = size;
    8324                 prule->is_last = 0;
    8325 
    8326                 data += size;
    8327                 size = 0;
    8328                 chain->blob_next->size += (unsigned long)(data - (void *)prule);
    8329         }
    8330 
    8331         prule = (struct nft_rule_dp *)data;
    8332         data += offsetof(struct nft_rule_dp, data);
    8333         if (WARN_ON_ONCE(data > data_boundary))
    8334                 return -ENOMEM;
    8335 
    8336         nft_last_rule(chain->blob_next, prule);
    8337 
    8338         return 0;
    8339 }

regards,
dan carpenter
