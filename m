Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B1CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 09:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiEIJxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 05:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238589AbiEIJgo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 05:36:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2108.outbound.protection.outlook.com [40.107.21.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100861E38B5
        for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2022 02:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTTnynY5ElYJKQI5vWaQfhyicPbdbYkDFQFgnIerGMzG2BhRMNZ7CWPZL28XOPiSRYFGkLEmFh3jGC1eOYp+m8WB/UVkfKDAALOtZBnEQek8x7YpTdrJIVzbz+qOvL4o8nN0jebUBi47tDA2KqNmX4O738cXsXHeCDYh/xA0eMevciRHTOqjWXjrsnhWws1bP8B5OrmjyCz6TqeU9g7bFaAgNkMTe7sCSZec1PkfjZ+mu0RilKmiH7nZmWHsGrpAREVsBa1KOk9Km/s4xUyeqDuOIB8u3e9WR8S1CHyIUNKAXjXohYMDENr4rtccHYyMh9zByScxboBGGQA59nz/SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqUrz677oxREeH0xCjtcJ4ywaK9W3w6+XtLApIKe7mw=;
 b=FY6+4Bx1ZrQP+g4+/dK7EXv8olkNOWIct2NMDFmUvY7IzI8PIC5pPfXbh30VD8htPqng5LSOKzPX9AuN3C4WhPQ6vB3ph7wBPoczBQ+Sob+beBTkWJbAFyya2H5BiaHVfGaJoiYfjwcA3VCZB/03QJl3JgOXVAhPLLn13meci/0VLShRM5n7us8+LvSvtZbjXZSLy1gLwUYFbuJxgeNdpxLM6nAmf9xguHRkz4OC6ofbctiB3SMhAiANxjGhhuVd+xwcWN97tL1MODSXG0uzUR6v66gRTds1mTsUNoKXDJPZlomjr2xbcAH+7yeg/NqJSnspEuvm6J24WWPoGqeSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqUrz677oxREeH0xCjtcJ4ywaK9W3w6+XtLApIKe7mw=;
 b=gQcLWta9q428kJsnyEsvKnNNXYfR0x0x4eTVWLqoviPudVHOkl/neYvMRrnzCZkpf2kCvdZKW20yfg6scIS60bb92QPFYniyyQ/vTz/9fudsByqBS4XS+fpW6rZo11YLXg88CEeqh/vToJ2+05kaGXDslnrE38UQJ+AJKGGEWZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by VI1PR0501MB2816.eurprd05.prod.outlook.com (2603:10a6:800:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 09:31:41 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 09:31:41 +0000
Date:   Mon, 9 May 2022 11:31:32 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, nbd@nbd.name, fw@strlen.de, paulb@nvidia.com,
        ozsh@nvidia.com
Subject: [PATCH] nf_flowtable: teardown fix race condition
Message-ID: <20220509093132.fmxxhhogq7jhhpks@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AS9PR07CA0034.eurprd07.prod.outlook.com
 (2603:10a6:20b:46b::24) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91d32af5-d059-45f3-3d9a-08da319eb96c
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2816:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2816F7B7283A109F87C4BFE4EFC69@VI1PR0501MB2816.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0qLdYxzTXt6gs6RaaqnS2IAYRacHeC68DPVFUHSs71Sa1G2iIa+5yvA+7rmNlCTaRSCBNkUGRS4m6eGCpbKDRPpP0bo26OXSLa+ACSVWsYYo1sMSdlPe34LxzZWNJF/Unh1Jn8BtBD/CbYBqpF0XLbReMTHMh5uVM2m6D4cIfBeI1BHtwn1jT31nyK77QSYOqdz0PyuZ/hq3UcMQDvVSTQ16bdvKSDLa/OXnRCge2SZE0pweJqGwLXnf94QliPzQtXR/ZqyJ94rdmlzmPu+Jmw0Wn4O8Wr7GD9VLg6BS1S1hSkbYpGE5VELQSIGZKaQkURGnQcV1OZHFWdXIzO1CmjBsjs6tMHlS+EJMLRgrBvGSo36oWO+BjXZOdGAwe6Kih0W2jMKs/juKMRRCjpeVghBCt0LEXCFP7mGUVkJGFLhzAaZtD/4waYHS5Aysh+11bNRaaBWSNadlHAqhYFmntJYg8XZ39+X704nySX0vsPBngJYHGbL7XCTHtaWvk6lKjj8k21+smEoZrLQh3jxfXG6C4o8xVRSN6j1COFqH65AG8FH4u8XRZTzm6GAkUUblJWuCY+i9d1Yg7KNK1E+ovCVIvy/3HAoLH/DRiHE93iAcix20fi1jBn7GFZxBDz+SZOjnIp9Fn0Dm97JTEQrjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(376002)(136003)(396003)(39830400003)(366004)(6486002)(2906002)(8676002)(66556008)(38100700002)(5660300002)(186003)(83380400001)(66476007)(508600001)(8936002)(316002)(4326008)(1076003)(6916009)(66946007)(86362001)(26005)(9686003)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QR2R8FaU1ICo2qERB15wizLT1n18mt8KM51na130RCQ4ezzV7VsILooNRmI8?=
 =?us-ascii?Q?fWrR8Ojm6ikVj6JZZNNw/nm3TJaxjUwFGX7dGed35RkstU+vjPyqb+BUFIjv?=
 =?us-ascii?Q?kx5eWEUnKfUh/9oRGp+d4pkw81wXcNlVxjIdub/PNKrjewrOvdpI135SF5Wu?=
 =?us-ascii?Q?EeMZiJyH1B5YD4VunNyBt/PnXLwOIp0nKw0uK3KX7UvMr4rV7aTWUt4cytAq?=
 =?us-ascii?Q?PNN6qpMMK7aOKmTARnMymJOs1xPeRKbNdjgZHISKjUmg4cVUBRr2g0Gy3Gfy?=
 =?us-ascii?Q?+xUvx9qQgu18QNxHJakQeqhLwaUSnyml3jLQNm75MVbRGuC75hxn++P9FXn0?=
 =?us-ascii?Q?ocKCHu++k6Fm2gvu8DLg0eN/F2pkt/qP8u2T2of+gC7pFYKauxlmqDFF2IEL?=
 =?us-ascii?Q?dtPuf2bYdSVTVI5F1KY3HQQ3sSZwep6BbgyCO5+dEHxaKhyrH4ckBjtj5uve?=
 =?us-ascii?Q?08AhMWr88m6kOqM/ZVbYLSsZVXONNor+HlHGwaooJGs2gsNEe62ZjJo15rd0?=
 =?us-ascii?Q?sHXhWikAu/phwBflRsqv/lj0BlM2xuNU4m/iApshPQgHBSs+jgmV+jdcRvjB?=
 =?us-ascii?Q?EveIS795kHWSmXIhJeKdcoUYfh+mVuI9KvlI1XNlINQyMMfCth8J6qBMH/Y6?=
 =?us-ascii?Q?lQJAqbDIq9Oa5MrjKYQ924387/qFSA94FhqwsgsIr3zxur2vucGKPXv4KAoU?=
 =?us-ascii?Q?0kt6N3LgVfsVXy5SijDERYilzq5H+hne2Eg8CovWzJDaVwNjN1a6UT0QyQtM?=
 =?us-ascii?Q?ByUBgAHwsAB56iVkJoWE41f3yMufhTSgPDJ22GboINYDKxmEcjNn5D/pnHE6?=
 =?us-ascii?Q?oNzxwuFb48ph7ks8RMS+GST3DuLw+OhKhS2poUHPz+WzXeqXMbimD88oKSJy?=
 =?us-ascii?Q?ohThtxMH/meu/BuW9Taqe4Ln7lO3UcyOMDntEugdwVqkOp8iR6ErAm9SVe8w?=
 =?us-ascii?Q?mJcVEcdrf+Oqm5uy5qjIUT4dGwEQ7KiqlDT/EQ8tbgKyz8b3ANRwl2vsq7jr?=
 =?us-ascii?Q?OWfK4NjlpX2U2TvMxppsLtvk53+dJleKcf5GOhTm0PtRj8Psj0fjXbZuX5Km?=
 =?us-ascii?Q?Yw3C/EsriWjB/ZCAsqEavwH+c27InKppHAtHEYCgpeVadDMBoH5AQkMyKKJX?=
 =?us-ascii?Q?o10UnyON55pmG2pYXl59tWiai9jAlVE3UlVmV4vwLtxsCw3cpFQrLkoLGBhe?=
 =?us-ascii?Q?H/d82A36rHdtITIKK2hvCIylFeyXP7lf422nh8eCThS9SyZEaBW3lLZIHtZ9?=
 =?us-ascii?Q?U4cc2vPGEddaoBmOk+rueqhcT4sT/r8nw5mAXeUH5UGemEZt5zAkqORkCGdX?=
 =?us-ascii?Q?Mdq2RRxj4Ve9Ea1Hd435j3Q/rOEmJwwnwopKIewdhOOpM27LXtHdt18z/PFV?=
 =?us-ascii?Q?fLGxzdzwoTjvvdja0Dcrdhl/aa1xCEQK0+RLsbWN22vmFVwzq5FTreB2B0gC?=
 =?us-ascii?Q?EsJJSGBRjjEzzc0ECfUwzDkP43QnBS87+rB/RaSCWwWjXRCGTQ7zSyuZxWk+?=
 =?us-ascii?Q?uqNC+utBVOxFgf+z7AvslwHowHY9PuwpoqHtQtV+vrlKjoX4LFQ8q08T1QUs?=
 =?us-ascii?Q?BqXxLkXknTkA0V5DjOAIg1vhPsCH66h9mGhRjImeq3aVREZ+TiIaP3nLaflG?=
 =?us-ascii?Q?Wzfx5SFwf/w7x61UPNvsFieIWMvFYspozUKWuuzCDcie1xpaVDcji1mJKmlE?=
 =?us-ascii?Q?9Q5l9w5CUo9gXp5+llhDer1u6qLLZpYKULcB6zLOjk+KiVy/uH3zscFT/68R?=
 =?us-ascii?Q?By9ECscL/ekiw5WfnHUfDFj4CY+RXzo=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d32af5-d059-45f3-3d9a-08da319eb96c
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 09:31:41.3705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmQ3stTnRDDso9LdshDrijJVHinDPQhcslSJ3oT/hcJHAnqu+dlX6GclwvRR6pfx3MSOtad/Wwe/qeg/mTjWcrDZspTbkK0PQ4PRmcVM944=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2816
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nf flowtable teardown forces a tcp state into established state
with the corresponding timeout and is in a race condition with
the conntrack code.
This might happen even though the state is already in a CLOSE or
FIN WAIT state and about to be closed.
In order to process the correct state, a TCP connection needs to be
set to established in the flowtable software and hardware case.
Also this is a bit optimistic as we actually do not check for the
3 way handshake ACK at this point, we do not really have a choice.

This is also fixing a race condition between the ct gc code
and the flowtable teardown where the ct might already be removed
when the flowtable teardown code runs.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 87a7388b6c89..898ea2fc833e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -5,6 +5,7 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/spinlock.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
@@ -171,30 +172,32 @@ int flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
-{
-	tcp->state = TCP_CONNTRACK_ESTABLISHED;
-	tcp->seen[0].td_maxwin = 0;
-	tcp->seen[1].td_maxwin = 0;
-}
 
-static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	s32 timeout;
 
+	spin_lock_bh(&ct->lock);
+
 	if (l4num == IPPROTO_TCP) {
-		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		ct->proto.tcp.seen[0].td_maxwin = 0;
+		ct->proto.tcp.seen[1].td_maxwin = 0;
 
-		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
-		timeout -= tn->offload_timeout;
+		if (nf_conntrack_tcp_established(ct)) {
+			struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+			timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+			timeout -= tn->offload_timeout;
+		}
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
 
 		timeout = tn->timeouts[UDP_CT_REPLIED];
 		timeout -= tn->offload_timeout;
 	} else {
+		spin_unlock_bh(&ct->lock);
 		return;
 	}
 
@@ -203,18 +206,8 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 
 	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
 		ct->timeout = nfct_time_stamp + timeout;
-}
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
-{
-	if (nf_ct_protonum(ct) == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-}
-
-static void flow_offload_fixup_ct(struct nf_conn *ct)
-{
-	flow_offload_fixup_ct_state(ct);
-	flow_offload_fixup_ct_timeout(ct);
+	spin_unlock_bh(&ct->lock);
 }
 
 static void flow_offload_route_release(struct flow_offload *flow)
@@ -354,12 +347,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
+	flow_offload_fixup_ct(flow->ct);
 
-	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(flow->ct);
-	else
-		flow_offload_fixup_ct_timeout(flow->ct);
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 
 	flow_offload_free(flow);
 }
@@ -367,8 +357,6 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-
-	flow_offload_fixup_ct_state(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88d3dba..990128cb7a61 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -10,6 +10,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_pppox.h>
 #include <linux/ppp_defs.h>
+#include <linux/spinlock.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
@@ -34,6 +35,13 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return -1;
 	}
 
+	if (unlikely(!test_bit(IPS_ASSURED_BIT, &flow->ct->status))) {
+		spin_lock_bh(&flow->ct->lock);
+		flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
+		spin_unlock_bh(&flow->ct->lock);
+		set_bit(IPS_ASSURED_BIT, &flow->ct->status);
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..63bf1579e75f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -5,6 +5,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
 #include <linux/tc_act/tc_csum.h>
+#include <linux/spinlock.h>
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables.h>
@@ -953,11 +954,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload;
+	struct flow_offload_tuple *tuple;
+	struct flow_offload *flow;
 
 	offload = container_of(work, struct flow_offload_work, work);
 	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
+			/* Set the TCP connection to established or teardown does not work */
+			flow = offload->flow;
+			tuple = &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
+			if (tuple->l4proto == IPPROTO_TCP && !test_bit(IPS_ASSURED_BIT, &flow->ct->status)) {
+				spin_lock_bh(&flow->ct->lock);
+				flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
+				spin_unlock_bh(&flow->ct->lock);
+				set_bit(IPS_ASSURED_BIT, &flow->ct->status);
+			}
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
-- 
2.33.1

