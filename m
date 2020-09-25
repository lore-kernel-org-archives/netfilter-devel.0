Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23034C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 05:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8391020838
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 05:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="KA/f0deX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYFzH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 01:55:07 -0400
Received: from mail-eopbgr60124.outbound.protection.outlook.com ([40.107.6.124]:18068
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgIYFzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 01:55:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpeckaOMlw6HAQ6VO+M38MZNx7WtwyUNfFis1Lc6zh3sgahoAbfXqiL/Q+l0N51mdl+5izUsjvpdwceppJbRddxEx8UlwSlIOYryuk9X9vME99tHtj5P62VR3S0ae9CaAJ4BEDXOZqCUDFNFp5YiS5nGN+vDgwPngWCvuYakcSE/yYjp6mPQADAA3N1CJ5fTMx4uuC32qpu/xcSv+FXpxkeuZ1+npzmPTOugP+1tkCztJUFmUpZ5wo/56qy2hXcxBtgKbEyDp7ATvpBOkINgz9R7l1WvunpCdFARqvU78yK2tN1SLafrcnX4nfbLfE+p2+/p9JN0I6EaCH8GqSWYoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrN8rtgqe7798qSGiaLIvBjy69Ac8gBme7ES9oyptvY=;
 b=jXkpttfcO2sav37Qa8klzpg6mjPjg2ZYdg+DvJE7EfbhwMdsSEvDKW0mEYoExNNhPdmvge57F+kulv6wUW2UGcHISR6vrWhfEnQkR0o8ItLZ0X/5ybEvfXIJoz+bpxGEtjLqYWztwvHB6w0289HCpq3NuTb05E3tJQoMwvEIsn3+VWvx9jTwqFER5msfa/vFVASCzSdv1JONZesWaziPoCMwGYu8raFgdMFf27IU9tmLG+WbsyFn35D3bclu06vAYXHzGINQtFl0pLig2IwTRHNGWDMotGFxO6DeyYFWxJC1JLgjohVUGamUN+U1eSQZX6o65IdrWaFG5FO8OYUZtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrN8rtgqe7798qSGiaLIvBjy69Ac8gBme7ES9oyptvY=;
 b=KA/f0deXnp1tNdPn9rrfToPwW7K+RANr6AMSKwV+7aEzPa4InqeqpYx+cbr2eXDap/nl+h/VT9dKcha9ANOkNggE3C5/0pPPLfArExjMVYlv0t+2qLLASvMPMk/CqKB+MfCz0lgoxWWvmli+5j/56VPUxL5yTNWj1dw/RSBV154=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM8PR08MB5681.eurprd08.prod.outlook.com (2603:10a6:20b:1dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 05:55:03 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::f408:22ea:674e:e34]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::f408:22ea:674e:e34%4]) with mapi id 15.20.3412.020; Fri, 25 Sep 2020
 05:55:03 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] ipset: enable memory accounting for ipset allocations
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <f3cb80cc-523f-afa7-6ee2-7f06b68f4976@virtuozzo.com>
Date:   Fri, 25 Sep 2020 08:55:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0302CA0005.eurprd03.prod.outlook.com
 (2603:10a6:205:2::18) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR0302CA0005.eurprd03.prod.outlook.com (2603:10a6:205:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 05:55:03 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b48eb2-8a4a-4041-6d32-08d861178c0f
X-MS-TrafficTypeDiagnostic: AM8PR08MB5681:
X-Microsoft-Antispam-PRVS: <AM8PR08MB568139BE106E014C49ADA282AA360@AM8PR08MB5681.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mo5SdDR3uqOLNVdR+3JOPEkc6B1g7ouSZVW299pTsQm4bZlRRy+JmG+LfZIfmbyNXxEOIa3U1ZtiK35nkZSYntD9Blr8wfvMVua5EmJwrdIs/ROe1ovaMFznlnAf8dWRLW05E90RaTQF1pdyp/JWTEYPZe7NlgyGHbpfF/6y0StMt+izVw0H/g08C9CbCcGSn9ztunWOsZzkp1jVbdLknHqMC1LBD7oZXxB8zktcTm20r/o0UJ4IuovbV57d53psjqirbERRT4jj3FFPJMkge5Xcg+S2pQJ4BhW8FggbFtT+NJYq1YwvxkHkVR2nb5f11bRlMY7u8I5bCBdDEIxsTIMDv/4MgwXdXR/r/vII0PEVxJLC+XrINjZhSKc0Ybh9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39840400004)(376002)(346002)(136003)(366004)(8676002)(316002)(83380400001)(6486002)(16576012)(54906003)(8936002)(2906002)(66476007)(66556008)(86362001)(6916009)(31696002)(66946007)(5660300002)(478600001)(52116002)(26005)(36756003)(4326008)(31686004)(16526019)(186003)(956004)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4KFKxyIkPWgZuEU+NvJVlke/fcXpAd4Q7dbOXnlfCIQRwjXhdrRGIOpNYAGrq/9aaGtDkz68lq01z8fVn9ihNKoqnZabCTz7ljBynH/1PoGF3cjq1G8O7M2vawpvj8eaZ1ozU5dqyhniwUvlS11qUwuvle2WltctUUYJsodH69+kmpZbYi9CV6SM2QweQXNAh07uG+haCDGEKM/OggPAJrnFT9ZTT7EmrC+EoyhHC9ndJYESovRlYJ6+Wg0uYAgQIJBbEO5TKv7DRuA1rqJc0Eyjo8hV4c5+08fZcwpzX9HFik51LBo1koeJrDOaaccFwp45TUkkd+5PoHbDW2yUhom3rnA8551SSHXEjLxFKu/GjSPSsnhQVyNaeAGIkDEgiQaE5FOSk8fQLS6dxO8q3RjuKfvr3iPpwrpyHJTSo2FrQ5fFMjH+clGL28T/P8chqt0Pwtivi5SIR3WeEqen2SEXENjGeXq71EnHniQ7Q7V1kBmqlGM2sz/tU6SZbhu7BoGQu3uHHkz4NT3+91CHafO+ilHkpw8a5No0nxenWvl5RttkbfSNYrn/38g4dCCr4zcgTdtKOd4ZoIYfN3GUcAA4SySY4iPD6cBa36Qn0IaJOOIPWSK38hSYgkEiw9dGf6wRpno0XJWL1Vm1PwXAsw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b48eb2-8a4a-4041-6d32-08d861178c0f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB5140.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 05:55:03.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gB8hGBZ5msTlfHMQhYYgmBKJmroDmIWFT+anx7WM3TPaaSlrKu+b7uTqU8C2FGKYK2EJsc/M4RvqI/BgKtWTgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5681
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently netadmin inside non-trusted container can quickly allocate
whole node's memory via request of huge ipset hashtable.
Other ipset-related memory allocations should be restricted too.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/ipset/ip_set_core.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 920b7c4..e9fe34a 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -250,22 +250,7 @@ static struct ip_set_net *ip_set_pernet(struct net *net)
 void *
 ip_set_alloc(size_t size)
 {
-	void *members = NULL;
-
-	if (size < KMALLOC_MAX_SIZE)
-		members = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-
-	if (members) {
-		pr_debug("%p: allocated with kmalloc\n", members);
-		return members;
-	}
-
-	members = vzalloc(size);
-	if (!members)
-		return NULL;
-	pr_debug("%p: allocated with vmalloc\n", members);
-
-	return members;
+	return kvzalloc(size, GFP_KERNEL_ALLOC);
 }
 EXPORT_SYMBOL_GPL(ip_set_alloc);
 
-- 
1.8.3.1

