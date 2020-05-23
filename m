Return-Path: <SRS0=NxHY=7F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CF6C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 10:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6EA92071C
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 10:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="BmvaFrAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgEWKqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 May 2020 06:46:10 -0400
Received: from mail-db8eur05on2130.outbound.protection.outlook.com ([40.107.20.130]:4448
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbgEWKqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 May 2020 06:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jE4uFAiNHXqQU3bsT9qG0bZUb2cNMtd1JrlBhbP4e9073SB6VFODDW2YGMeqh2YE3WdC20sfFzM4OohQJ82t0tlTVW1xnLH1FJuhza7PCY3zpxVT7+K5QJO5DqN6DBM0KsWOpMjleM7uobxO0xzmBKbGLNOzSkP7+Qlb67aMhj0K/nT2IAqXdQUVAri8gKPFpIchvBtpRKB2b4tmR9l8GOKREyy53Ap9R9mH5QrP/EDQtx8awKmKo7B1Ln+mghW40PjhkrsDejr9BlsIchCpBScJTAZZYugP9PkcRMQ5zoZo030h60k34Zz+/O2v75cOEcLqLxb1hf0/1102J+C+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxKis5Gm58KSByp9TmNRhb7hbIPSLTaxESnjFHx+yu0=;
 b=a9WZ2iTOmgslO1jZy6SJV78TH/phql3Ol1rkCaFPudOKr19PWCpi4Xy4+s9QBtaxSxy5aFvhVr15OphxxGq6kUMO7J1bMbwBMzAdOW2/G/tx6ceLctL9gaeu5kM6gRIIzyMdo07lHr2aKyNkk9wChayhkO+ifNqhBRXhqGH3tMpIzWsvMyUe750Qd9SZDoZMMN79QzvA71LLEGc1Vo9YLVdZAU0NDSbZY18B2S9wAWC3qN0QwLiIqOVPBeDLRr+RumeW6htGsZAhxHlWP+KORH3LoNEzZFTro2NL/77P09umiVkUbBgsnngB/4AjH1B4DdjA91w8WNaWKmmv5oeb9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxKis5Gm58KSByp9TmNRhb7hbIPSLTaxESnjFHx+yu0=;
 b=BmvaFrAgEfqkEvzcJutcBXo0bon6ycH9V6FKrH+hn0/l5eRR2UV9wVcvW2wZ2PE5CxwJ7bS5fgv3hOYQt7UcmBUqTpDZq5q/A0FmG6lLBVZIUnCCNSO1JeepV4s+nVu/85tCXTm71bR6poU2jKFnX1MU/vpEXutpY076hlPW1dU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (2603:10a6:208:f7::19)
 by AM0PR05MB5250.eurprd05.prod.outlook.com (2603:10a6:208:f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Sat, 23 May
 2020 10:46:05 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b%4]) with mapi id 15.20.3000.033; Sat, 23 May 2020
 10:46:05 +0000
Date:   Sat, 23 May 2020 12:46:04 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 1/1] Restore the CT mark in Flow Offload
Message-ID: <20200523104604.k3rl4cfzr35zr2y6@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR03CA0060.eurprd03.prod.outlook.com
 (2603:10a6:207:5::18) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM3PR03CA0060.eurprd03.prod.outlook.com (2603:10a6:207:5::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Sat, 23 May 2020 10:46:05 +0000
X-Originating-IP: [78.43.2.70]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4614b315-46f7-44cc-63fe-08d7ff067e77
X-MS-TrafficTypeDiagnostic: AM0PR05MB5250:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5250A96F8CB8712E3FA5E293EFB50@AM0PR05MB5250.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvG3fPaEC8p1TXXs6NwsP1kwEsB/rfrw7ZZuBXP6DVXQYt1tEs/1wPEkmKNb8WwHB2U89VdMSuMc+K2WY93BBr/PRxBvac+52f68tUW/s2pIQfPENj371H2ClY1aVcWiclFgdmvRuQcTjbp8CeyS2saF95abpEA/VW25zxDLilMao63bX5FWGisBJ4ep648l6vijXA0CbZ0xcLYTK0wSo8zm+G03X0/3ek7kwJBNss2H9kak7+1km+MNFnz8fPj+uC3SLiVvvOTqrmbtG4Ip5riBIyJmnC4Ao2UOjFvhSqrIjCRK6vggHQQ8iThmSl/HZppGQRHFXkvAWx+1lPRFsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39830400003)(366004)(136003)(376002)(86362001)(4326008)(16526019)(186003)(7696005)(52116002)(8936002)(9686003)(8676002)(26005)(6506007)(2906002)(6916009)(508600001)(55016002)(316002)(1076003)(956004)(44832011)(66476007)(66556008)(5660300002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cqFBJdMfE+wosW8q9nrX3at1Ow6S1kkLSaFHgPROXEzQIbfNnpX2fSX82rsdClldEChTqh8/0ZLlE19FF2+t9myALh3Jc4cCKtqteV6numW7YWYq3BV00LziXqcmUUT0KamJSy+yEhcBrCvyeXEWx3I7zVLWqP7m8sXkxgPIbiM2wycYJltBgYfS+oKMUJEwPqkUW7omUxHFEtvpPhcZhQa0rOnXLo/oH1WmNeUG/AqP1NgiIZ/DNUlVqvy91NKbG82JZfEwI9sa3y91fBiPE5Qpvd1XCk1RYS1iXWyyqRXlHvADMks9CjLJ1zis+q20GX2lFjEuOnj6PfhusP71+SHgJ2c/7jlNtiUc3MQY7iBLox0UHJxwdU1We2hYy5ymTfJA1yoSCCDSq+9MgaAOq8Frf0zURs9YSaDJanHblVXfeFGIsIP5GbYMD1guYiMRXoOPSodRstp3FJpl6WYhwaGeBykiN1Mlg9AnpiAgDSg=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4614b315-46f7-44cc-63fe-08d7ff067e77
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 10:46:05.4413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZqcoJmz2YOEzoPBxrsfsArMzXAYCd9gA3DvzYuqfVKSEmsqYvolq+phS42/2M1PBY1d6RiQC5lRvmIZsM4jPUPbporwnedpMzZuGkffpOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5250
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The skb mark is often used in TC action at egress.
In order to have the skb mark set we can add it to the
skb when we do a flow offload lookup from the CT mark.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 include/net/netfilter/nf_flow_table.h | 3 ++-
 net/netfilter/nf_flow_table_core.c    | 7 ++++++-
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 net/sched/act_ct.c                    | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c54a7f707e50..61ad0c1d86f4 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -174,7 +174,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow);
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
-						     struct flow_offload_tuple *tuple);
+						     struct flow_offload_tuple *tuple,
+						     struct sk_buff *skb);
 void nf_flow_table_cleanup(struct net_device *dev);
 
 int nf_flow_table_init(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 42da6e337276..50a0b2fd7527 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -300,7 +300,8 @@ EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
 struct flow_offload_tuple_rhash *
 flow_offload_lookup(struct nf_flowtable *flow_table,
-		    struct flow_offload_tuple *tuple)
+		    struct flow_offload_tuple *tuple,
+		    struct sk_buff *skb)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload *flow;
@@ -319,6 +320,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	if (unlikely(nf_ct_is_dying(flow->ct)))
 		return NULL;
 
+	/* Restore Mark for TC */
+	if (skb)
+		skb->mark = flow->ct->mark;
+
 	return tuplehash;
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a3bca758b849..4b38923234e3 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -257,7 +257,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
 		return NF_ACCEPT;
 
-	tuplehash = flow_offload_lookup(flow_table, &tuple);
+	tuplehash = flow_offload_lookup(flow_table, &tuple, skb);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
@@ -493,7 +493,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_tuple_ipv6(skb, state->in, &tuple) < 0)
 		return NF_ACCEPT;
 
-	tuplehash = flow_offload_lookup(flow_table, &tuple);
+	tuplehash = flow_offload_lookup(flow_table, &tuple, skb);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1a766393be62..e2195ef67024 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -517,7 +517,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 		return false;
 	}
 
-	tuplehash = flow_offload_lookup(nf_ft, &tuple);
+	tuplehash = flow_offload_lookup(nf_ft, &tuple, skb);
 	if (!tuplehash)
 		return false;
 
-- 
2.20.1

