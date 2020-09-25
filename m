Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D4FC4363D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 08:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C12520BED
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 08:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="ByQetHkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgIYI4I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:56:08 -0400
Received: from mail-eopbgr50105.outbound.protection.outlook.com ([40.107.5.105]:12416
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYI4H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 04:56:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHmydJzlCb9sfeYYp5s8oztHK/taolgo13imfm0968BPUFlgaP7EjrDb/t3VuP1+DBGVaU83tbS7Pugkie0aQko1pEfIBd7G51EVQHvsCMOTOe3CjBYEKiXV7Pjgv7voM0FE9Dk4evMF/FHr1EpQ1nk75GixanLHAzwkG6RRJxjJvv9dlA23A8YvvhjwI4OhB1JFwHb/ESDo29xvVvF/Z7twY5STh6UaIPC7SIRem874RaqTVL4VO1p0M0jL/b1HXrsFNoZEyHpeqUnyDhUl9NWKqpvI6Ub0k7zAuQZPRvKOL63flE66ao58im7tZi2IUKX4KcMSyfnSbMHw5ZbsDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gIKHOOgzQpSCiSp5pJfCO3fwn2yZC3N+lwiUQbEr+I=;
 b=mffhQl+RuCxxkZDf50Av8BY7goAOD0JaFrJwsy/OprHf+gG0gz2lsX2U83dwkzjj7rHrducuIPXOZW70zBJK+h/wafqpMRjy057mVAeki59xt/YSUmiKptgILRx/rjDccnCFn2qeJfgX8O82F+SmP58T8wdgN2ShZIsMyntf0lLUCmMMDsie7Ldr956n/ImtTonP3u2miYRvrW0e3swW9icdXOGNmDVY+bDJmY7+FH1ZY07qSUJ7eRdjKwfZA44LrkIP1msQ3oAZXjnv31Ykjrb4eSOMH5+3WwfCfWyCpB7Nh14zd7wrZd7qbly7UJwDHBmSWcy37ZfhNZ1Uj9gIGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gIKHOOgzQpSCiSp5pJfCO3fwn2yZC3N+lwiUQbEr+I=;
 b=ByQetHkwSjYY2BLWf6Xpo78cua9it0GjcWWkWzi4VBYZYsaJ3VBQnjTgirhKkTf1z+pKq3sHC2Q3je/yCrUh5an9wFhMBLVUOWZNAlWhQWeUdZmUCH7aBh9Jxh5x7P/tZwItmKxR7LKROaesa7XIcAEeapWOqtUnpZBHNfyK9iA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM0PR08MB3764.eurprd08.prod.outlook.com (2603:10a6:208:ff::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 25 Sep
 2020 08:56:03 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::f408:22ea:674e:e34]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::f408:22ea:674e:e34%4]) with mapi id 15.20.3412.020; Fri, 25 Sep 2020
 08:56:03 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] ipset: enable memory accounting for ipset allocations
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
References: <202009251545.3tm8FvXD%lkp@intel.com>
Message-ID: <343416af-f22f-3834-7ee9-14b6dd7558ff@virtuozzo.com>
Date:   Fri, 25 Sep 2020 11:56:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <202009251545.3tm8FvXD%lkp@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::51) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR0101CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::51) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Fri, 25 Sep 2020 08:56:03 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 901a4d28-9e4c-41bf-0bb7-08d86130d522
X-MS-TrafficTypeDiagnostic: AM0PR08MB3764:
X-Microsoft-Antispam-PRVS: <AM0PR08MB3764189B1923F2BCFE45E9C2AA360@AM0PR08MB3764.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7EMH+RN9UQcF3QGj923B7M74Bdrix+9rSuzx5sYZ3vWzdGOb90JxckZb2pbUZhpe3BSdnL8UlSP6VWZy8/WNbkxJsZciBbjcubudI+TyL+kSlqpebtNcMAzb0jHLWMMqu/bNNzC1wte/XlUq6ElB6qJFTbRPbRNeOH6JCppC2gdHMKHLffDdsWS2eMX0+THNRBaH52c4UvOsWILER8xtj5rjUJTOe59VsW05ujCsVhvNpTTLij8zTe1qzezCh4tlfphriASn0I+9IcJ7981ub1M1KbCBGzQxbReKwETNnUlh4wXXfn8lcZq2eShxGM4mTPf1iaUssPzZL/+SYZrbLi5AydeRX/Vvw0gtY2qkXGm4PoER4TFqAx3qdc9ZAs9O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(316002)(6916009)(2906002)(8936002)(4326008)(83380400001)(8676002)(36756003)(16576012)(478600001)(956004)(15650500001)(66946007)(31696002)(16526019)(66556008)(186003)(31686004)(26005)(66476007)(54906003)(6486002)(2616005)(5660300002)(52116002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: m1iqiCHlnHd9G4eut6ZhFrcIxiJ3nXCMX461nybW9i8/rfEqhGnKvS7I639zBWHb40syHOBPZ07WOY9olqA2A2/rWoOao1ZSYRRpQMEYghxuPjdhSUmadfmCSsDFCIEaGL8FvuqpUl0mUbf3vkXcmvFIGefag6+II58KeoXA+0rdpFBh8rWc/nSxXbMyrxQBiQolcwBW2w1ymuyGoT6s2dhHfA4xPpSJUsMd3Jypp04aP6++yQI5aOekWs2PpmKKRp6OacCWp+KDMBt314pOTuWPAshnNhKuF0fc0T7W7jcY0JvdPDGN25+oWyBKpEs/yfB5ULn4OU60NqlpTcCd6zlWlB1YXonE/xwpzEPoBtB0Hj0c7mChc5ymjOsuCqDEV7a3HKRLsVfYYDekHPqmkUEwuR7rzj6xsedFelAbP2HMZnz9Z9s7xHuNlLB+n1P6gaml6xZ/LStzFL3YORBQi5qNncqxWZOWIRKz8xSx36TPCAOuqGF7nIkitYbOBtIwQ5XMIuDpn7DNGEMO++D4ahKc9LLgLrPSnxZ87jng9gIbaWeXSytdci0vV4wT8scEojusi+LHhExxbDfyIGn0z46Lbg7JSkpactH+ldJ8eeY8sKUted0NIxFWpcJaUsmByip7SRo2BF04izy+ELgtLw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 901a4d28-9e4c-41bf-0bb7-08d86130d522
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB5140.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 08:56:03.7336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1ipDHn15XVlsCmXA3OjfkDexjFap1FiD52M6VZ4GV318GPzZn7M+aHmr2tiWWjtfT9exHfahcJUsnUTpoAqyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3764
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently netadmin inside non-trusted container can quickly allocate
whole node's memory via request of huge ipset hashtable.
Other ipset-related memory allocations should be restricted too.

v2: fixed typo ALLOC -> ACCOUNT

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/ipset/ip_set_core.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 920b7c4..6f35832 100644
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
+	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
 }
 EXPORT_SYMBOL_GPL(ip_set_alloc);
 
-- 
1.8.3.1

