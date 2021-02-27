Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFF2C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 08:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F208564EBC
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Feb 2021 08:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhB0I2l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Feb 2021 03:28:41 -0500
Received: from mail-eopbgr60115.outbound.protection.outlook.com ([40.107.6.115]:56544
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229991AbhB0I2k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Feb 2021 03:28:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcWOlm83fL/S7VwB7xw6JQT99I9ViTpvzwJI4eH0qAVhbrPDCmH+2Q2SEQ5VqG/p7PAWbORum6K99BV3gNDwu3TQU3GFW1Ic/et6tC3m8nXq7HRglavc0LT6Jlm1HFC//SvhCRWz1KyJ2EVkjgGEXCqPjBcA4vLXyIpEC4m7y7hgnGlLEesvO3RuDtrPAHUY2Vixh/lLIKf3feJRqsFpbrdG7SEXCCBnlpKrLU+14gCO7A9JF71iqVpsYijgF2gam8iB0sKF2p3JwcZciC86Z4b+N5BcsSV7t3yJNzHMKYGWUYSZIrDff1q7S2X045Nz6mnxkJ2jI2r51Pu5MZCRdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx6nKSA0CMQVsRsV5fC3M/tRoxr+hdIHcVHO9eGz1Jc=;
 b=GnOOtFqtj40pB2Tv2R0dyQOmZLzNHh92YnEeaJiif+I25kA0vO+cchdGyHXgmMrMHzn96mGyUO+fgLt3kRheX6JVqyb04JhpRzUBn7x0aYzsJ/B+4yTbL5inhEbolJUCST6fjATjorrcxS6PQGOhrjBo6+iPbg+gVHRg58QDwUaG4YCp6ehV2eH0B/R3w/l04yPmlPlPEk0MfCFlxT4ezyWkc+PpnOiqXWxcXKqpZ3PxhoYvr46wTCMKUEIT73luWVkRG5wBIX/esuytyY89TNvMZrjdgsI6XaK9qcNlAGo9Bg8D6KBioaFMBxo4A9h8PJLR2Eo2IlZl6D3rBRIoig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx6nKSA0CMQVsRsV5fC3M/tRoxr+hdIHcVHO9eGz1Jc=;
 b=wA6wRA+5c2vvDdEVnA+DlfLhKJ5lF+xQRbAKaKwY3xj5mjJPQxv2+ocj6s2OdcchJt1mWYCA2CXfkdN22fpN27z9/HPaW4ETGlTPKq6jUd96Saa0jflKOlzD6ASpeHQccfS/vf5xqZ9K4wBn1Vh5ueJCh99Aq1+zW0Bb9brfU4Q=
Authentication-Results: trash.net; dkim=none (message not signed)
 header.d=none;trash.net; dmarc=none action=none header.from=virtuozzo.com;
Received: from VI1PR0802MB2254.eurprd08.prod.outlook.com
 (2603:10a6:800:9c::22) by VI1PR0802MB2608.eurprd08.prod.outlook.com
 (2603:10a6:800:ae::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Sat, 27 Feb
 2021 08:27:50 +0000
Received: from VI1PR0802MB2254.eurprd08.prod.outlook.com
 ([fe80::e4c3:b366:458c:c613]) by VI1PR0802MB2254.eurprd08.prod.outlook.com
 ([fe80::e4c3:b366:458c:c613%11]) with mapi id 15.20.3890.023; Sat, 27 Feb
 2021 08:27:49 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] netfilter: gpf inside xt_find_revision()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Patrick McHardy <kaber@trash.net>
Message-ID: <75817029-1d99-0e41-1d5b-76fa4a45aafa@virtuozzo.com>
Date:   Sat, 27 Feb 2021 11:27:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: HE1PR0401CA0105.eurprd04.prod.outlook.com
 (2603:10a6:7:54::34) To VI1PR0802MB2254.eurprd08.prod.outlook.com
 (2603:10a6:800:9c::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by HE1PR0401CA0105.eurprd04.prod.outlook.com (2603:10a6:7:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Sat, 27 Feb 2021 08:27:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f34ac6c4-65ac-4b7b-a855-08d8daf9912b
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2608:
X-Microsoft-Antispam-PRVS: <VI1PR0802MB26088CDFB7851D8F76B74BE9AA9C9@VI1PR0802MB2608.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnmqDayWCOX8d+CBpNWCFTHukZK4dLrphmOl5THw/395T73Nuu3iMAAUN+WdT3NIl6pqMAbcekqx4fJDVI3BTdV8voGE82/F1R5fxyfJOO9YNLhUsqA3MGe785peY5ZkeFQrb/eNeVocklAm14h3MdZqMI8xrLWKo8SK/NgB1dFduo4LvjKRL9DJgV8M8/T/YMZKkIKty5WKSDBcCybfipRuI9uKPAJ2js4Pb+dOmoq+oC6GU5q7ImqUxunxSIqdhV5okGrZKn/jhSXddZ2WSHmAYJg6ohS6bGnYwVsQyH4cU1dWFdkb8MCiQDae03f9qH4QcBJvLLoOdBsX40VyAiWHPTJeqm6o6NHZoGTw6nPWR7AGLxuvOJFHcng0lFHVnGgXCpZyxmdJ4y4hxvxJK7VcA+7oWqzpbKmbNcwm28W4kHmb57Q4h6sp82iDpa/HdKrc+ZfhpD5+g5hKNqsw9K0CLqOMoSNRyLrPXEONDBDr3bR058GndarNO0ueit+ivGkf+tJhN1QFJpqwcO5fjoT5Vp3kdKZKXmqxVI8he8eOLz7z6YMVXMUN0pSQax7Fgyxpq76fkW1rqroBT2KzknaPxfaivu9YKkUh6Kzv4vU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0802MB2254.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(110136005)(26005)(52116002)(186003)(16526019)(86362001)(316002)(31686004)(16576012)(31696002)(36756003)(2616005)(6486002)(478600001)(4326008)(8676002)(66476007)(6666004)(66946007)(66556008)(45080400002)(5660300002)(8936002)(956004)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGNlWXFlM2tDYmJURThpV3B4Mmd6Zk5kTlREMUxCQVRaNzI4QTFUSzdrSXhE?=
 =?utf-8?B?cEd0WFhDODBTVjBFT3M1UHBXTU8vSzhGUVcycHJMcmhULzFBSE53cXFaZ0dL?=
 =?utf-8?B?TlhwTGhQMDN2UlM3aE1KU1NhNjdvZEhSNS9qR1lOWFVDcE9wRUw0NFFMbitz?=
 =?utf-8?B?RGUwUXdWY0ZJZXRKTEpXZEZIQ1FKNkxlN3MybERTQVlnTGJJYkl3eFBnNk1W?=
 =?utf-8?B?clZFVFpKOTJZZjkvWGR4WWRLSDU4bkxwTDMxalFWOE55RmlDTkZJaE5PcmIv?=
 =?utf-8?B?c0dGS3F2bklNcjJoMEZRRFpodzZLWDAzY2ZGdnZYSm5UVCtuRFBObXh1UzhD?=
 =?utf-8?B?UXNXbjk1cHZKeFMwQ3V2WUg3UUY1RG9Xd3BDT2tpTStmQ245eUFvcUpJRTI4?=
 =?utf-8?B?RzgrcjRpb1NnQXpkb3YyY3U2THd1dVdoQWhSVjB4bG96YTcwZUNIRXBxZ1pM?=
 =?utf-8?B?WENvT3NpUWMzeHVkK1R4dXRwNER4VVhFWkdFdXIvOHBOSW5abzVUbCtsVDZB?=
 =?utf-8?B?U1p4RWw4a1UwdWk4NXZsMW9uTXFsL2NBZ0ZnSi9PVzQ3LzVNRkJmQUVCdDBi?=
 =?utf-8?B?U2V6akVUV2JYclJkamZyUXpZTGpzYnN3UGNHY05HUWZpTGdYTTZtMjBzKzJO?=
 =?utf-8?B?dSs5RkFyc2VEMnNTVGxPRkZoamVCUVdQNFZiSUtYNFduZWJ1amtpUGRUZkJp?=
 =?utf-8?B?N3hlTWFWZW0yU01YZzNsWnkxbEJlZVlrcGV3WkMxdnhvT01GcElZRVMvR3kx?=
 =?utf-8?B?a3NiOFM3ZHVDT0N4aTB2ZXArQWlkKzRNWHRRazBQVUJuV0FOTjRkYmcwQjdY?=
 =?utf-8?B?OFhJU0FNSXRjcnFVc2hNRkxZYnFPUEFycTc1eVBRWUpqclgzcWt2WDc3WW1G?=
 =?utf-8?B?ZzkvZ2RrcDBNa3BqRU9oSnBvNUE0MGZpRjlWTENQWGRnNndFZTRYMUxsRFlj?=
 =?utf-8?B?WHVnbUxKOVR4b0todEZVakU4S1BQMUtjZ0wwb3U3dkY4L214eFBaK1AxeUdR?=
 =?utf-8?B?NzNiQnJSbjBCS2IxcnVtbU9mQWRxbWNuZUZWVXJNUVJtMTl3OGNVbjVQSUkr?=
 =?utf-8?B?eGJzTTM1dGdZUkk1TTNpaG9HcWVnZUNTZnFwZWVvTUNXZjY4cEdYYndSQkRs?=
 =?utf-8?B?MzJPbnVpK29wemhZOFZ4WnFDQ0FENWgxbXN3ZDZNNmNBdllXdXdxcmVmT2Ju?=
 =?utf-8?B?UWxuQkVVeEVOb2NkVVlpdE16WFhyWFlmVkJwdW9KeHN0VGozTC9ZSDllNmV5?=
 =?utf-8?B?OFpBRkR1c3c1ei9NSTl1UXhDa2JqZGs3ZzVjaXdGNWhaYWtRODhqUnR6bGlJ?=
 =?utf-8?B?aVNDdWFQdTlhQTlZT0UrVnhzZjRHbVdiTkZETStwTXduNk81VW9acTZrM3gz?=
 =?utf-8?B?YlI5VW9rNlNoSVFDbVVURjI4VGF0dXNsMEZmTkhvT2MrM21tc0c0MXFnVmQx?=
 =?utf-8?B?VnorVlZPL2txODQ0OTFaTVUzYWlwWVdXT2d3Ui9xOTVtTmNoaW1jRW9EQm5l?=
 =?utf-8?B?WWkvTisxcURBVDkvNXp1VGF2N0pWbzk5ZXdyZkpqaUFxemFBa2NmV2oxcGhP?=
 =?utf-8?B?cEkwYjF0QWlXclpib2I1eXBOWkJSUXdPMFRkRW42U3BvYjVKaUl0WFY4ZVBU?=
 =?utf-8?B?eURZeXR2QXptaktYanVBRFZXZ1R6S0dpdkNJVHF4am9kQ3NQb1A3Zm9wT2xV?=
 =?utf-8?B?RGY4WkpjYjZUeVVFU2JJMTVaZDgrWHo5d1dOT1RCRkNDWEVyWkVmWVZoM3k3?=
 =?utf-8?Q?A9EGNR179mwyKevaxp9LHxxXYpGSET62rc78Y0d?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34ac6c4-65ac-4b7b-a855-08d8daf9912b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0802MB2254.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 08:27:49.8190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNdPWItA2/ijY8YC1ak2MQmj2RNOXmpWJ36TyM8rrxttFZPorUpantygdvIQx3WafcFXGVwNc/2juGHvWcGAcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2608
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nested target/match_revfn() calls work with xt[NFPROTO_UNSPEC] lists
without taking xt[NFPROTO_UNSPEC].mutex. This can race with module unload
and cause host to crash:

general protection fault: 0000 [#1]
Modules linked in: ... [last unloaded: xt_cluster]
CPU: 0 PID: 542455 Comm: iptables
RIP: 0010:[<ffffffff8ffbd518>]  [<ffffffff8ffbd518>] strcmp+0x18/0x40
RDX: 0000000000000003 RSI: ffff9a5a5d9abe10 RDI: dead000000000111
R13: ffff9a5a5d9abe10 R14: ffff9a5a5d9abd8c R15: dead000000000100
(VvS: %R15 -- &xt_match,  %RDI -- &xt_match.name,
xt_cluster unregister match in xt[NFPROTO_UNSPEC].match list)
Call Trace:
 [<ffffffff902ccf44>] match_revfn+0x54/0xc0
 [<ffffffff902ccf9f>] match_revfn+0xaf/0xc0
 [<ffffffff902cd01e>] xt_find_revision+0x6e/0xf0
 [<ffffffffc05a5be0>] do_ipt_get_ctl+0x100/0x420 [ip_tables]
 [<ffffffff902cc6bf>] nf_getsockopt+0x4f/0x70
 [<ffffffff902dd99e>] ip_getsockopt+0xde/0x100
 [<ffffffff903039b5>] raw_getsockopt+0x25/0x50
 [<ffffffff9026c5da>] sock_common_getsockopt+0x1a/0x20
 [<ffffffff9026b89d>] SyS_getsockopt+0x7d/0xf0
 [<ffffffff903cbf92>] system_call_fastpath+0x25/0x2a

Fixes: 656caff20e1 ("netfilter 04/09: x_tables: fix match/target revision lookup")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/x_tables.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index acce622582e3..bce6ca203d46 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -330,6 +330,7 @@ static int match_revfn(u8 af, const char *name, u8 revision, int *bestp)
 	const struct xt_match *m;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(m, &xt[af].match, list) {
 		if (strcmp(m->name, name) == 0) {
 			if (m->revision > *bestp)
@@ -338,6 +339,7 @@ static int match_revfn(u8 af, const char *name, u8 revision, int *bestp)
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return match_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -350,6 +352,7 @@ static int target_revfn(u8 af, const char *name, u8 revision, int *bestp)
 	const struct xt_target *t;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt[af].target, list) {
 		if (strcmp(t->name, name) == 0) {
 			if (t->revision > *bestp)
@@ -358,6 +361,7 @@ static int target_revfn(u8 af, const char *name, u8 revision, int *bestp)
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -371,12 +375,10 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 {
 	int have_rev, best = -1;
 
-	mutex_lock(&xt[af].mutex);
 	if (target == 1)
 		have_rev = target_revfn(af, name, revision, &best);
 	else
 		have_rev = match_revfn(af, name, revision, &best);
-	mutex_unlock(&xt[af].mutex);
 
 	/* Nothing at all?  Return 0 to try loading module. */
 	if (best == -1) {
-- 
2.17.1

