Return-Path: <SRS0=n5XH=7O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E0AC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 11:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B2C206E2
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 11:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Ylxa3v4v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgFALMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 07:12:21 -0400
Received: from mail-am6eur05on2090.outbound.protection.outlook.com ([40.107.22.90]:38753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgFALMQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 07:12:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXTKOYVM4K59sF3IR1P9IYve4yDFLyayfEPJqVd+2wPJNwNtK2kXwRe280paBZTVUy+SBGdnr2nvU1NgwysaRl20b1+GDm1Iyu/42ARmZdHULUkJbbWbYz6CZdUiqJnORKwW8g5kKpPrXi6g+1Zt6GCat2vhcz4/RGdEplpwedOHwjXyulOtp7d8DtVIawfgfu3iaNoRCkHO+gUS8ivnVPhrwmO7jfkumjRcAeEHiKB/bOiw6jFAQVtSpwCeAyYCSJkTllMUTMCnbMMAL9DVMhAariqXMB6QM4mnLExSRQ+WXLZ/1k0bbW9CXyb/+ac4P5GrqQKLq9bOpKdhP6h9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+SDp9xducMXM5r6gS5ZW7rcm94aJhUfls8Q/VerI1E=;
 b=AsXwaKSFNti84qrQJUWjZkYwegHJ5T5PHc8TxiXqEdWjqVCBSKJDZzs5oQB+Ev9nwcbMcgN2DLXNHP9FbTQCaQM6mzfFYfB1UtudbnUr1DSzrB1dWqZeMOa8cjnfV0ki6M2guaGfrqyzeoa+2FKRWtt5jS9BL4z/UbI14CLIs/90edPBySkfrL0DwoucRZRqHGPceXYqZbjX5mI3ar7kAERFiacynuNv5Ekkkxytl6Ik7kd9PbEa2LKCcB/PjeJMv7SSoIbYRYmbZ/G7xaFI+cX9s9MgEbZoFV67xneZO8qPhyd/xi8tQbm9rMZgXyT+aHGA3I1D0ilCrsIiKTCayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+SDp9xducMXM5r6gS5ZW7rcm94aJhUfls8Q/VerI1E=;
 b=Ylxa3v4vuiQqBxcQvuD0btYDRPLLPr4RJDMSXNadE4HM8FY1rO13aaBW6CLq8RuLvOpXU78ilWa9ZN4tSNhzyprPnYVOO9779Dm4H+pCkAC9AYLjwKNe2fNi3cNC+17eAD5QVgELlbE1LCYUqGEM7bFcS02bE8Cen9xyBc4/C44=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2673.eurprd05.prod.outlook.com
 (2603:10a6:200:59::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Mon, 1 Jun
 2020 11:12:11 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::e1ef:8444:4d74:79f9]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::e1ef:8444:4d74:79f9%5]) with mapi id 15.20.3045.024; Mon, 1 Jun 2020
 11:12:11 +0000
Date:   Mon, 1 Jun 2020 13:12:09 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 1/1 v2] netfilter: Restore the CT mark in Flow Offload
Message-ID: <20200601111209.fluj44n5utfoicko@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM4PR0902CA0022.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::32) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM4PR0902CA0022.eurprd09.prod.outlook.com (2603:10a6:200:9b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Mon, 1 Jun 2020 11:12:10 +0000
X-Originating-IP: [78.43.2.70]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4045abaa-b62c-49bf-d35e-08d8061ca179
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2673:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB26736CCF84E065F1FEAA38E3EF8A0@AM4PR0501MB2673.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xWvjoc5YcdZGU6z8qOMhrtYy64QaLRRw8+fK6BrfFo6SDyZkFUNCGk1SP18/aVC1vFXwjYq07bm/rVwo/rSCPKCd+r87ASqxzP636Bg0gjL0atn4BcMKBl57Pq/KWJT2CtH5582Zh7F3exiN9O0n2zbCxRubrR3vK1rO9IH1p0PH1pzXE6xlIQYGgCjNBwbrt2iKcm3FbdHWoJfUXArHz+xSZLyg8dDbVjO/gDw2eo0qVM8VTSfz+h2m4ArA2Ymy98T7h/kuofjePyteDeaOUY6/eChQ6EyoBAAR0tJYEXx8JOYing3OKwzxXuk8znYXtK/5cE49VD8uZGeCN9kAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(376002)(39830400003)(396003)(66476007)(66946007)(508600001)(55016002)(66556008)(9686003)(8936002)(86362001)(83380400001)(316002)(44832011)(5660300002)(1076003)(6506007)(26005)(2906002)(6916009)(8676002)(956004)(7696005)(52116002)(186003)(16526019)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mYN6GeKB3fhd+HWOysKXXWJcv2OV/ND/W2VLmHokU2A2eQuJbE+hBStCqyNB9wVM9cxOJCEzsMrkJAHZmOkjaFzzUGF5X6tY+rCtARNr9QmJGyS+RO8fALu9JLcvvdDBWsmpPbHn3c9XsmsI7/lALb1RpcYOYczwkzLhw8JxyXmo9DhzBnHjIT2ykQJWWH3wLjWZKj6VT0GP9D0VFUywyoXGS6TgrwCG9KXeEM+rVh7PRlFKHxwHmPCYlUFm8KgRyhvmIPcL4O9hGGKmcSZtxG1bl/g3hdj5vu1fQDt6+5gR1uFjjIViGgZQIADfNQxOtXuatgIuAv8vc6ldRAqJDTBoyQSJ7wP2hS5hcnkh0o54MNZQsm4dnGfz8N/EThfIYhpNpteQevzg+CMnMmO1CPRrLlwUDCB6jzL/wqfl00SsUfT8DzUvOLqQcqaI1bq0xOHEyIHKJXfUf2Po8RpvoDFE6YVnDTAdVW0HBebh0UU=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4045abaa-b62c-49bf-d35e-08d8061ca179
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 11:12:11.2810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RYLM8YRLLHLc3g5q0mjo1MDhDVrTGPkaQ9lHjMnmd/0koosfC/Idd2ZoO4kDHeTT/8kx0KGW2bI3gNBCNhiFZuwuszoCj3hZAaq49Hs9H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2673
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The skb mark is often used in TC action at egress.
In order to have the skb mark set we can add it to the
skb when we do a flow offload lookup from the CT mark.

v2: Only restore if CONFIG_NF_CONNTRACK_MARK is
    enabled.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 include/net/netfilter/nf_flow_table.h | 3 ++-
 net/netfilter/nf_flow_table_core.c    | 9 ++++++++-
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 net/sched/act_ct.c                    | 2 +-
 4 files changed, 13 insertions(+), 5 deletions(-)

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
index 42da6e337276..b32da5b3a980 100644
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
@@ -319,6 +320,12 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	if (unlikely(nf_ct_is_dying(flow->ct)))
 		return NULL;
 
+#if defined(CONFIG_NF_CONNTRACK_MARK)
+	/* Restore Mark for TC */
+	if (skb)
+		skb->mark = flow->ct->mark;
+#endif
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

