Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CE3C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 17:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE2864E40
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 17:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbhBBRKP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:10:15 -0500
Received: from mail-eopbgr50090.outbound.protection.outlook.com ([40.107.5.90]:40843
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237067AbhBBRCM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 12:02:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJbvoN35ujeoXtdgHSdWGSBR4lzjTSEZtl0w+7JaEGBzTdCwJl/zdR3zUihb7/oweBxAftH7Em3RcU4wWJ5omYJWOOHC83glstp68+SJeOe1rhqRle9+17bpMv0Nzcf2hquJ5r3xUaVRsYqnSEeptHpGUVW2oYiK5WywYyjwdayOWs99Gdqhn27n+mpR4vrh59TmeYdYNXKTTjOpAobAEdEoS+ESaS+B/czWBefMnkEIHRXLtj70n4y2gN2+S+K0stallUwDaBLWVlFJ5SCdFK5cbsaYt7OnNRYLYTerolCSPOAjkrXzT8ygCyQunIrQu/p7MrjjUlYwhDCNCkhXzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q67O71x3ZPjZN43l1HqEYMDNDj3yfUYEam2S4TXXlZo=;
 b=l0Jn12b4LHMVIxDSGzsexS6ZVcfxIF9oMYbJZVhlbtiAKWfo1Gd3vBfvgDq/Agso8Q5a0bbGShVjvKahoBQBazgaGQ9bF7Bbg+bQWo8d02BS8jqrMsT18aP697onNzMZzihKV8+QIWOkKsYRMFfhjkEjCr7VZORY+ijVLR6tY0kj+Piq0aiN9CO8+xxq/XPvFnOKFEErMJkAegZezsJBDBpBAnLXGvz5c03oVHx2FN88G+SICueDkTj09r96MN3qpEoSvWlZjDKICkJkTdfiQOvFEJM7BzGV//sMf5J/VhInzHrCA+b860N0sNR7dDEILKUP0zX8nd/it5NuRtQaFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q67O71x3ZPjZN43l1HqEYMDNDj3yfUYEam2S4TXXlZo=;
 b=Xgb5EC6dfuRTGMTSWImI2s1DJJCbBGr/ooyuyf4xXgRwO52ym7vW5N/0HrzYGk74KOl8zsgseaWKr6WDwUpKPL9wTqFBaAG3sLuY3tZHsctzYUXlRU4i2nYJhHn9XuJPI2ptGHEZz1ZdHLN+qtFhIk+/a9Kxv6X/tXuRN3p23zI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4851.eurprd05.prod.outlook.com (2603:10a6:208:c1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.25; Tue, 2 Feb
 2021 17:01:23 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 17:01:23 +0000
From:   sven.auhagen@voleatech.de
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH] netfilter: flowtable: fix tcp and udp header checksum update
Date:   Tue,  2 Feb 2021 18:01:16 +0100
Message-Id: <20210202170116.8763-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [91.40.82.121]
X-ClientProxiedBy: AM8P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::31) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (91.40.82.121) by AM8P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Tue, 2 Feb 2021 17:01:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e69a14cd-9c68-48b0-c32b-08d8c79c2bb2
X-MS-TrafficTypeDiagnostic: AM0PR05MB4851:
X-Microsoft-Antispam-PRVS: <AM0PR05MB485119E3926CC807D3C35889EFB59@AM0PR05MB4851.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rnj9OsdBRMYnk9+5DsZILhnUn+RnzfyzTkbDrkOGdN8g7KV8y8Ef2QEjq1lcjGMJkn1NmxCBL5LtrJnOXSe6W8fgpX14rDbhn0uB0v2eG+lZK6QZ8TcuzrcLNRtyBIEYeiM9IMdv2Dbip5v2lrhHDX85zpqOfG1UEGQmtBvbrfkBcHbJsfvC6eF5Bc+vaoRipMSUg4nK74OYKKeJRenYgphL+BG4pBjG0hBOhnxOypAkqKbAsBES8x+As9XCKsR82/6JVuPzJzBaqgs5iWKZ/jWRtPcE9rVRlpiFSMqCouczwj2l0dyAZznjlbW9eGv7L4ODKBTUHR8ZOiKBb/LM3rwm/+g6xHv3hsnL/RfuSUfdza7/SpV3M/A7uuz8G4kAeN40gHTnQnjTSG5vJ3q9DMxbASs0ElRxaasrSrOk4pGQ5rRxncyRXdrX2uSQNTg4pms5SvT623kHsZpstkE65oK1ad4khWkhjh1jFgBX+S3tUjzAwQYZ5MvkdrTrjFORdXlkUoQHO4xwo0fdPXMPtDXORVhLCnJaHuITUNLfNQZxppJFduxFBcCWOdCbpBDZFsUbOUZAWdypRaCtaqbpew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(366004)(136003)(376002)(346002)(396003)(86362001)(66946007)(66556008)(2906002)(69590400011)(66476007)(1076003)(186003)(16526019)(6486002)(8936002)(478600001)(6666004)(5660300002)(36756003)(2616005)(6916009)(9686003)(956004)(6512007)(52116002)(6506007)(8676002)(26005)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?thKHkIlngsvKdgtvikZGsHlCSFu00p8bPEKd5RKN+jKVw8AhYawQSm8CJ7Mv?=
 =?us-ascii?Q?x5lDSFxB5mByLkninVL4gY9Z6AI8v8kduyZFrBi1qjxbagTxxIW63ArF4sXS?=
 =?us-ascii?Q?BYokuLGZEeIEjMsJ7HjAEmVNuJvsV4GEBa9gfHfsiDE6AxKXKgiZ71x5gnd0?=
 =?us-ascii?Q?XxlxGZ82pnzYg7HMRsNGQJLcWHzRGTVDGJ7YNAwmM+2j9ZRBy4XZxSsZ46hd?=
 =?us-ascii?Q?gJcAIpi3cQOcKcQsHLZkOyNNnj8s9reuMzPl71zRNWvNGju/AiH+Z+g0Kq1d?=
 =?us-ascii?Q?Aljv23V9p23Sx3ZQVf01qb18mpUthhuEpXuaWs1OUolWqeA1jvf9iMJjFBCC?=
 =?us-ascii?Q?BpE9/gwgPZFnHSYEjzi75pr+fO6BWkzjk180BdpRAizheB7I3aIgMLSVFAiL?=
 =?us-ascii?Q?F8s/Y+pZHVeBdSj1k3++J0rILYFSVJwp7itFvoxYY14LOv0phZtOH5VM0DUQ?=
 =?us-ascii?Q?M08NvWAdP0GcNm8bcMhw2l3LZz5w+eLKDET5k8i0NvgOnTPWBbX+HtUSiZNI?=
 =?us-ascii?Q?JeK073sX3EHMvsoS10P+EuqZIeUNMDCiBM5Ff5ChOG4CsC/BXjiO0nBmrpec?=
 =?us-ascii?Q?zBGrgHTm0hiNmhgjk7dz57Gfl4lezd4tC0lknOJl0rprdVzkSFTzddxQhBl0?=
 =?us-ascii?Q?8LV4XvaXZAC2CNzO346IEM+YlywFE40i+i4kWVs4bwZVwDv+ed9G6kPlhh2L?=
 =?us-ascii?Q?zuxfc1ZXbSclMzRISQkQZeAXZdLyr5ddztRNYZWA1Shcly6ySQ5RAeNFd55n?=
 =?us-ascii?Q?ZJ5oC2TIcxv8lu/oUZnB3POfk2UCZAwYzCRU3rjF+gM9aJncZbcP04YjO/h1?=
 =?us-ascii?Q?qZpAqIQpFZGW7uMyWRubt8k7Q2OWrhu6ice4JXeaXBq+9MpeWRAsAF4gl1ij?=
 =?us-ascii?Q?GUYlBevPIQNsf77ZP6BYtMEyTKRh4603xluF64E2pIXnB1FrhWwWY3oIC/wQ?=
 =?us-ascii?Q?1sQnB3eUyKDb9ZerT/7a6/0Lako319Zvo3WbrNFITc/JSfd6tkIntPg/DtOa?=
 =?us-ascii?Q?/Hj5fioYAcekejzz7HnjFamdvaCRyD+w+qtKMpZJ9MrZ0gepcC/WwqaRSxhb?=
 =?us-ascii?Q?+J9QZtVD?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e69a14cd-9c68-48b0-c32b-08d8c79c2bb2
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 17:01:23.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9XkgPIDaPTs3C4/TVAScBS8zf1nd9Y3e7PdSmJUpwa8IoGf5SagvsG31DOqwEUwwQPPB65DizJleM2HbrowPMyL0O7TRsw7pqsw3uI19AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4851
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

When updating the tcp or udp header checksum on port nat
the function inet_proto_csum_replace2 with the last parameter
pseudohdr as true.
This leads to an error in the case that GRO is used and packets
are split up in GSO.
The tcp or udp checksum of all packets is incorrect.

The error is probably masked due to the fact the most network driver
implement tcp/udp checksum offloading.
It also only happens when GRO is applied and not on single packets.

The error is most visible when using a pppoe connection which is not
triggering the tcp/udp checksum offload.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 513f78db3cb2..4a4acbba78ff 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -399,7 +399,7 @@ static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, true);
+	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, false);
 
 	return 0;
 }
@@ -415,7 +415,7 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 	udph = (void *)(skb_network_header(skb) + thoff);
 	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
 		inet_proto_csum_replace2(&udph->check, skb, port,
-					 new_port, true);
+					 new_port, false);
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-- 
2.20.1

