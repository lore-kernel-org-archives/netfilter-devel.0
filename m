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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E25BC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 15:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BF660FC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 15:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhHDPvh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 11:51:37 -0400
Received: from mail-eopbgr50102.outbound.protection.outlook.com ([40.107.5.102]:22382
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233011AbhHDPvg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 11:51:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dD+/gmirJTGbBkyTc73zcM1Ujip3cbeejymrNDmMggsMuBJKEuMSFK/caskW2w7qJ7l/NmMkOy41ZjfgVWrdxIF+GbIUTa/aO2R8zvMppcepZWJSTM7dVAY+mNhT5eIbQJ196h2Bu2IePb7IZ1JJqT9BbjmYHPt2HCxjmTiWeil8e5tp45PBrGSIGz8Kn8wPCFmCSqsBuFvzPLUVm8lc87a7GDIf3I/1BplTxp9WsLc9qsnImdHhv0uBOJzFEMpDyeknwS5X8muEYJiJfUs1N+JJPzJKAyq5g8yh58iQIam2+Op6JPtHs0utexKOIcIC+teMsf+OahBb8u7NnOSjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Ks0vUycNu7AauybybyCmv+aHhwX9FacJIo+I9RsPY=;
 b=XycvIr2iUC535+Vpjp4uyaeBihCkjJim78BDMqCKwaTSlkFaXaaRGevw7gUHUUTB6zPfWSQdL6ah6pZ/6Dd4EuPm2WX/i5yie9de52HpoKMR5DpJpq8zro+c/Vu5PfniQj2JXINVAeOQluZCY4QZUi4Ri91zEUKOymg9YC/xgvPgWuzkwl1NcpZ+Z/g2PDcntDTrj0RhInq1Ccpdx9vPjuStODcL6TgXx7eqHP8pi4S6cr7OGlMuEge3ce4yQPTcAmrELDfpUou8Kkx1j3JREqyf/SnF79LGpNX2DFwviL7m8KBfviZSRklsNmfRlzHSkL/3CdxSpCHiFTWcNf5HGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Ks0vUycNu7AauybybyCmv+aHhwX9FacJIo+I9RsPY=;
 b=NG6l50vOC717/DT8bBdWDBpLmV8Tmq2RkczF3S2zNlW7PfvSUnlZCu7fIFRv9QlTaTJz1AXLQiCqRr8A8g9HZQMBcli4BUWhWZWdE92WnPwE6bWbXSvWPrjVEtjinO5qdWAKeYFxZiFGeleo01YMIRkdNKQmVLkAxFG4knMy0ps=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VE1PR08MB5823.eurprd08.prod.outlook.com (2603:10a6:800:1a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.24; Wed, 4 Aug
 2021 15:51:21 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4394.016; Wed, 4 Aug 2021
 15:51:21 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Shivani Bhardwaj <shivanib134@gmail.com>,
        Max Laverse <max@laverse.net>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, kernel@openvz.org
Subject: [PATCH iptables] ip6tables: masquerade: use fully-random so that nft can understand the rule
Date:   Wed,  4 Aug 2021 18:50:57 +0300
Message-Id: <20210804155057.16829-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::23) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora.sw.ru (46.39.230.13) by FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Wed, 4 Aug 2021 15:51:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b0a1b2-36d4-41df-ddc1-08d9575fb474
X-MS-TrafficTypeDiagnostic: VE1PR08MB5823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB582308DA6AFA1EFB8EE00173B7F19@VE1PR08MB5823.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eTYfe3ihTrdc4Vk5H1Z6tdPUTC6WFslpBawLuyXD2IxbHVQpLjaKn+HfsX+JWhQMNwcyhT9h4BBPJfFMcPHqI8N2hIdxbe3tpXXoByy0gSmO3FbqavbN3eMTkfPTG8uhTb32Dd+TyuveE4hPHWNpPHCqdgN2pNWhdUVROhAFA2nZCyCeOc5dI83DdmgxffUhlbvsPNRRmHJg4bXSgryHYBG0vLP70TyVMwqfLX51tKbtR/as8KAdTWLyTS5FERGwcfXoVunuDQVGbhzCAekQ2iNORS3+5nkJjkj0QXAIoTZixt2WVPIrOLMu9AqpxXLgi8hnMttJgsVcKM+7DBn7wZComItR/P1eL3HR8GJKSIvaXqOUFVzMS/cMAzflZ82NITssNtwooBubIMU3KFEHvz9miAHPDVM5BA49AhI7EIeGvA0V/D4Q0PHgSZHskrxLkeCBfPGVhPiiLK5cqWUwEprdU6C1dGZB7uuhzQCN+a4reqcBdHzjhesJeouQXsgveqpPXRg4IGgjbTlddrBG+8a1RMofdBVHKImJbVl3WSLRQpK9fRMU1ijwbgR/2DuBVAioEktJn20S286NlTpP5tAwGfexM5JdNq1vodCXtpq+3qSMli7xH4xqI4eLRLbEab0QNWXWJEigiTvf/LDjgRqQzFF6qxalLiJ8hI1eR1NifGWqUq6biISSDWi+4/zLRHN5c5Z+y9d4FzRxNi56K8NzRGHIABcflEntly0iL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(136003)(396003)(376002)(366004)(186003)(8676002)(8936002)(6666004)(6506007)(2906002)(36756003)(107886003)(83380400001)(5660300002)(1076003)(6486002)(4326008)(26005)(6512007)(38350700002)(38100700002)(52116002)(6916009)(478600001)(54906003)(2616005)(956004)(66556008)(316002)(86362001)(66476007)(66946007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m7Erhx65hZij3L6yDrDCu49S+qQipb7wFRlMq+8mXsNDEVUVFHe+rT6VGeQs?=
 =?us-ascii?Q?uDDBvbWx95i1GI602MACn1VDEMn4xu7ywzU7kKI379N8tHO6oTuHns54Kubb?=
 =?us-ascii?Q?2oq7SVBuuj+OzlaS7+RJNEQEYNybClMSbZC3nBShQnA0Cbx2T9lsz28C5OxF?=
 =?us-ascii?Q?e7N9huqmsu4r9D45xwdYGoEVhAwR7vaP98swfgalZDxlURF09wwj78PH+rZ2?=
 =?us-ascii?Q?ETR84IK47npmvGfxUYjXUR3VABMB9PfEEv38Nv6fosjXm1JpksGsjSHFr+Nv?=
 =?us-ascii?Q?gD4us4o3cHuIvr6cwa+HrpRLwy08SYCzEH4meF3Nk8wQ0BhnumQ/1mIK8Nxa?=
 =?us-ascii?Q?YX9zYCkzQGAuEMQ+K+xJD+6IezMuQ0dfaCW8oPAMm0H2QYnsST0yDJplABsv?=
 =?us-ascii?Q?k0l8OBmCBTvRPbj7l+VkoVI4z2wJybKTEK4QkOdwlImir4Ut5H3LDE+mDVtH?=
 =?us-ascii?Q?g/IzpxKcTElGQe3viGNQ5wg501wU/6ixMPmD/OzKtrwCut40gsI1oNSHwr27?=
 =?us-ascii?Q?zsmQBBGp4tNWAGAW0TZTjBaQPCDaf9DcbVD5zYtWqHG4wvZNj9YFPs6RpO50?=
 =?us-ascii?Q?R67IuVMd+4ftQUrctWflSSL+WMBRRJD3kNw/GP2yX7vYtTwJ0fbQnP/cUCGO?=
 =?us-ascii?Q?sPrWZ0jR4NpuROvggRRKPZqFlhWIIKN+0V87K7u1F3VKUu6djHv0kHT3DSF0?=
 =?us-ascii?Q?/VqSsuBd71BWf4o1WZiR6tIwbVqnqVRqlwPokiFeDAgMQ3GMoChJS0YvM6yP?=
 =?us-ascii?Q?EEWntqugu46tLSlmAq5Ql3lYBHX1+1bgNmBdgBdaUbmBVcVUG5EyHmOv5A01?=
 =?us-ascii?Q?w34N0SIBLhUU+4N9Kh27eT914+J3lMNQOPM650nvCYSWw2gRhne3bIyR4zuf?=
 =?us-ascii?Q?YKXHMb1EASEVxY9MNl0aC4423m1n0zVCNwGUk1pWwfraEzobOriHwyNTpSVt?=
 =?us-ascii?Q?BZz7lvR54VCv5YJDJfzl3UbC0q3CtiUeJ+jUaYmYLD9xLCNghZMt0TT9ULdE?=
 =?us-ascii?Q?oCgUIsgJSinM9Rm+zE/HFUSWAiEuka2hcbGu7ZlTcPK/I0IyupAiX9sKz4lc?=
 =?us-ascii?Q?vyme+aHnwM++/oOWQ3D4ZvhU5r6xKD5pmIllykJC8eA78fOLDWPg+j8HzpwC?=
 =?us-ascii?Q?I/y2nCQShP8FXGRoLqYK5T83Dz6JVvr/YCZa674u8VSUmhNYOJMsOyTWigW5?=
 =?us-ascii?Q?48M3g/vuR0Mgg6tz2durMPY8kQgr+rckXyRQSIX0uYpd0nxINDcc7uNKcyq1?=
 =?us-ascii?Q?UGn0ixWH4i0ADJPKItzFxW0ozN+r1+iyxEniYSl3mAuVy12RIKfzNrE9ZOQK?=
 =?us-ascii?Q?ecBd77/qiSlre5s7oBL5gdK9?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b0a1b2-36d4-41df-ddc1-08d9575fb474
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 15:51:21.2272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OE+yhFLFZOmcFIGMRO++A/gGbtvexlLWug8HdNOp6wBj4wOhAosCqyWHZJ+jVY0YtMbgCBaypd13MRn4Wrj6glGKQgcnLyUmoSpYe29qXY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5823
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here is the problem:

[]# nft -v
nftables v0.9.8 (E.D.S.)
[]# iptables-nft -v
iptables v1.8.7 (nf_tables): no command specified
Try `iptables -h' or 'iptables --help' for more information.
[]# nft flush ruleset
[]# ip6tables-nft -t nat -A POSTROUTING  -j MASQUERADE --random-full
[]# nft list ruleset
table ip6 nat {
	chain POSTROUTING {
		type nat hook postrouting priority srcnat; policy accept;
		counter packets 0 bytes 0 masquerade  random-fully
	}
}
[]# nft list ruleset > /tmp/ruleset
[]# nft flush ruleset
[]# nft -f /tmp/ruleset
/tmp/ruleset:4:54-54: Error: syntax error, unexpected newline
		counter packets 0 bytes 0 masquerade  random-fully

That's because nft list ruleset saves "random-fully" which is wrong
format for nft -f, right should be "fully-random".

We face this problem because we run k8s in Virtuozzo container, and k8s
creates those "random-fully" rules by iptables(nft) and then CRIU can't
restore those rules using nft.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 extensions/libip6t_MASQUERADE.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index f92760fa..f28f071b 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -163,7 +163,7 @@ static int MASQUERADE_xlate(struct xt_xlate *xl,
 
 	xt_xlate_add(xl, " ");
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		xt_xlate_add(xl, "random-fully ");
+		xt_xlate_add(xl, "fully-random ");
 
 	return 1;
 }
-- 
2.31.1

