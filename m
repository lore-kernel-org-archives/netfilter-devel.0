Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15A4C2BB40
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 08:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6558B2389B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 08:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLQIyb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 03:54:31 -0500
Received: from mail-eopbgr40111.outbound.protection.outlook.com ([40.107.4.111]:60063
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgLQIyb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 03:54:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DItp6nK8RkB0i0TxyYgNP2cNSZ9S0kQMFg2AdFIZEVlQ3iumHVl+pPdf3+uM/nv/trWXnBKTpfQVYDxADcdV4gShydAHeC3pHMwUecsm9Ije4felHOUBWjLfDh5+xlDaG6GOKU8G6uIq50jYn9GeURBUTYp7Cl3ZHIrbnz1G5ltKhjf3nDugCJTCgeg1zS16odNjbMxZh3MPMfuSeg2Shdsljaywg6mqZQ5ZkIorPntf5+9ajOWYMQIr2YnHBM/dvwoFFE1szd0lPqppZS25HYy0JpziSL01udRV0toF9A5kbS5VU8dq1wxF1yU3IgF+IjGw9/uVOSWTjkggEZBYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILuQw1EPxIWecCxAntD3IeNpCVOrl3sZ+wirG0OYbJI=;
 b=lria3FHWN0x8BzgCjTDXtlD+T51XxIZ6Igx0dVzHt6HnjVTqAnZVkZYOYriQ2xsv5b1qRJNmQM6oMWsz8LMtZCcv0H1OQ5iUiW8MiCW2rGijQkxo4a22hUvkqlt1/U3h7XJdWfJrQvIUbtXUAO0onJYpfD86JYX6bgEZBPdRaWtD4r1THppuC8GlQi4SaetLy+IM5HchqVVx7fcf9Y2CGky4gPMd/qEVQxhhdxgzVHSC61G+j7hGLY3DTYIfjyTd4Na3GwDJG1zXejmQH2LPHq3FGJrLtp2xmZ/gqF9uPGeEU80T7iByal6mWvKw9t0hWFZ5z9r0urcW2l5cog3mhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILuQw1EPxIWecCxAntD3IeNpCVOrl3sZ+wirG0OYbJI=;
 b=Pgknvy69/udpfYo+ieAjkGewx+oXFv2BcLrro3MXR7NEuQ4ek0i9tvwyNJ3qBfK9lmXNBUYW+QXi4xwi67zYhxMb5kcHWFMJeMaVIstzVqLsvDYkB/oW+TzdyCZohQuBnhnU/aW7LK1oLoBSBVm+wDjbpKoi3ILh/EnZRPGY/BE=
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB3279.eurprd08.prod.outlook.com
 (2603:10a6:803:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Thu, 17 Dec
 2020 08:53:42 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.024; Thu, 17 Dec 2020
 08:53:42 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] netfilter: ipset: fixes possible oops in mtype_resize
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Message-ID: <bfeee41d-65f0-40b2-1139-b888627e34ef@virtuozzo.com>
Date:   Thu, 17 Dec 2020 11:53:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:53:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efdb347c-eee0-41f7-83c3-08d8a2694136
X-MS-TrafficTypeDiagnostic: VI1PR08MB3279:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3279B5A14F19CAA1D4B910DAAAC40@VI1PR08MB3279.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dE3asIW9YPVUeN7nvMmnjRJbZnf5R4hehtucqdlf+agqmIMg3NQSMbDVs1+QUx3JrCW0uLKYfb02yLGUU0jUX+KN3yPi6kNREqfgO3xSP1HnHZMAjyDv6O/P+7vIE1pZD9XwP5WHg6NAiLI4mJYZF/kEs2iYbUCQXS6Nm/bEsbsbSUHScqOM/myIRrCjUguysDsI8B917j5vpWL6MYB4DC0iDS4g+h6CxrbHSfSo0+qCZaCHOAUAyKw74VmQ6ubTYidjW4bcdN8TbDgRmg1gqnrusUCOIzIdjCmL1uym+FgwnUCTPpu1MT8krddM+TuUCDzuAB5nZxNRoW9FTj0LlfibjX0NQIb5ZkthSU2TembRwhiO3UL5TM1y4+nPrV1L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39840400004)(136003)(366004)(346002)(8676002)(956004)(66556008)(2906002)(66946007)(52116002)(316002)(4326008)(5660300002)(54906003)(36756003)(31686004)(16576012)(6486002)(110136005)(186003)(86362001)(26005)(66476007)(16526019)(83380400001)(8936002)(478600001)(31696002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b1h4QnMyaTM3bm1sSVg5ZmVyYXJRZ2VWRFZOY0NScUpXNlZ5Y2xLWE1NY0lW?=
 =?utf-8?B?cTdhTjRtYnVQWU11bG52aVMrdHBFRkFSTjIwb0JUWC8wejI2V2RheTQyL0FX?=
 =?utf-8?B?Vi9DR2Jkbi92UUVOcEVTdjAwRXlKNFptWXhlYU9LamtmQUdkenBITW9IKzRq?=
 =?utf-8?B?bEpOMXp1R01FdVpFekUxZWNsVTUyVmFOZmN1Y05UVmdKdzJVdFJJOFgvS0xm?=
 =?utf-8?B?eG5BTkFyQ1diaEVHbDhmeUNGK2h4VlZiNDVKSWFrT1hjTWkxV3ZVVWs5aVdW?=
 =?utf-8?B?MitBalBGeXV1aDNldzcvQjNhbG13VWgwSVBMVC93SEo1OG5LNVI0WXl4VUxa?=
 =?utf-8?B?Mm1PdnVTS3V0QmJyVUtWMTlSTXQrcGs1UVNOTzBnMkhUdW1BNXV1YVNMclRi?=
 =?utf-8?B?TW9EeU1PcmkwZlQvR24rZW5lQVVERVJhbklQbDZWNmV3dzZodHJWczFpa2Vw?=
 =?utf-8?B?ZkdERERjc0w4dG1DSGYvczdDamNhVEJXWDJqM2pha24yZVpqZmQxd1E3eE9J?=
 =?utf-8?B?SzhDVlM3ckxpdWVDRjJrVmNwN3lNbWdxZmZ4M25oZE5VR245aVJIRHhzMGwz?=
 =?utf-8?B?eWxBQ3NLNnN3SGJrbzBCVndkb0pLckNaRkVXZXJoVFF1eGhnd1VNZFo3T1JM?=
 =?utf-8?B?cTViY0FlYzQrQXRZZDBTZm5CTUZMY1UxZU1vdFk3V2ExNS9YSmsvSjFHbnNX?=
 =?utf-8?B?M3hCNEN3Qk5xVVBqRk1Od1h2dHF2am9MaGpFY0VlMmRsMGxQQTA2RlhWYzli?=
 =?utf-8?B?SkVsQkI5V1h5eEtqUHJQY0xYVCt5Q1A3di9iUWY4cWt2VW9KcTJtVDhLaTc5?=
 =?utf-8?B?bzhPL01WQzRDWU5DZkFRY2hWaktQWisyNERCM0Rzc2ZHMk4yVVpmbWU4TlIw?=
 =?utf-8?B?RDRpeGYzM0Jud0d2MlRYZnJ3czh3WlVhZ2hpS1lySkxKT1JLY3FxRVhuR3ZQ?=
 =?utf-8?B?cFZPam1VR0YxVk13ZnNyKzA2TFlHWkpDai84WFVzM2l6SzlZVFpFZkhtMjIr?=
 =?utf-8?B?Wkw0ODFwWDVQMGIwL2x1K3dyLzdCQ3EzT3Q1aXIvbmxKelJjOWcrYXZVZmhw?=
 =?utf-8?B?MzlrYVcxR1R1OXpjeEYrUWhLazFmUUVOVENMRENkbVFubS91Y0xnWEpqcnNq?=
 =?utf-8?B?bFRLSysxQjN0eWVpWDJFRlhKTkYxMUdPWDFGYWNZcWVMYStLYzVJVDBEZ092?=
 =?utf-8?B?dUpRUWNkeFJYZHdPQ0lBOFMzYXhIL1RuMjJTRmgzcWlpWEJPUXJyS2pnelI3?=
 =?utf-8?B?by8yMHdJODRUS1Q0SXdWTmk4a3lmOThJeENYelU5Z3FwcDdWNmxrTURCQlVU?=
 =?utf-8?Q?4IbcwKvYsfkqPtYWpSTEy3vbmw0GowNnhN?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:53:42.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: efdb347c-eee0-41f7-83c3-08d8a2694136
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/y8cADi3pH19R0I9O0Fg1RuZfxNyLJgXlSrd8P7xswToauTTytBeAxYoithfIm8GdHgoX/pH6o2XGpJrA0eMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3279
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

currently mtype_resize() can cause oops

        t = ip_set_alloc(htable_size(htable_bits));
        if (!t) {
                ret = -ENOMEM;
                goto out;
        }
        t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));

Increased htable_bits can force htable_size() to return 0.
In own turn ip_set_alloc(0) returns not 0 but ZERO_SIZE_PTR,
so follwoing access to t->hregion should trigger an OOPS.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 7d01086..7cd1d31 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -630,7 +630,7 @@ struct mtype_resize_ad {
 	struct htype *h = set->data;
 	struct htable *t, *orig;
 	u8 htable_bits;
-	size_t dsize = set->dsize;
+	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -654,14 +654,12 @@ struct mtype_resize_ad {
 retry:
 	ret = 0;
 	htable_bits++;
-	if (!htable_bits) {
-		/* In case we have plenty of memory :-) */
-		pr_warn("Cannot increase the hashsize of set %s further\n",
-			set->name);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out;
-	}
-	t = ip_set_alloc(htable_size(htable_bits));
+	if (!htable_bits)
+		goto hbwarn;
+	hsize = htable_size(htable_bits);
+	if (!hsize)
+		goto hbwarn;
+	t = ip_set_alloc(hsize);
 	if (!t) {
 		ret = -ENOMEM;
 		goto out;
@@ -803,6 +801,12 @@ struct mtype_resize_ad {
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
+
+hbwarn:
+	/* In case we have plenty of memory :-) */
+	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
+	ret = -IPSET_ERR_HASH_FULL;
+	goto out;
 }
 
 /* Get the current number of elements and ext_size in the set  */
-- 
1.8.3.1

