Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B44C64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 06:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBZGou (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 01:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBZGot (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 01:44:49 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2112.outbound.protection.outlook.com [40.107.105.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F2AF770
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2023 22:44:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAY+3MdXSkxUQc4qnBYxGpvdhL99BjpTlaPb5F4UVr8h2Svqa+s9bAYzWDAoc+CZ6cQacuVcZmrExm3lUUjktRuKwgoCeFLP4B5N60oSKpjAHUXf/Ld8+joBFdzJw7Mc1RMr0JP31+4VxowWsM8V8twTVpdJQSIDFHSN/ptXWS+PMlRlFDF4MuAM+peo1vqD/jiQoHUnMcxTjfH42f9qCaRycmdzeoFMafKprw5wsqSLx2fjMv2q9IWfjqCBqjo0mGYE1kDKieWDaJyplXbKe77f7QjBV+HamZ0CMZmA7b1slJjRajAZ8QD+WyLr00t2vfW56foOB6Uu2S7cfz+o8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rz4WSVesmTf6xF+nY6/eftfFehiHR5/btHmjPNLb7fU=;
 b=mp+6EwPiEpknArNrHzdK+Wt0KrijFWKLtHNTZ8Vs6EsJECnYV8VtrmfnR0L4GlG+GB88L3xN+QIYanvZVuGCnmIADtShljFdd2cOaWAdWIj8SCyY6NwcUDBkiAigSnm95W9YEgGflkfb7bdYYcckNzE/uYPAKlw0+ZYbJzD9IS1WXQ5lC+Nif87obb1DaDh6W8Xq6Pcdj42vwSyxmVMjjnb3i0N6EuB1gqUVMpvhTLQfXji80X1oP/AH6DdXvOng062W1xftXxIITtZt+FdojAAbjXt/cX0Ewxz/bPp6HIj7zvk+WQDO+Uc6xvN7BAN/g6Dy40naVzT3twS3YdSGig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rz4WSVesmTf6xF+nY6/eftfFehiHR5/btHmjPNLb7fU=;
 b=lrq7+u4hqxx8XGW+PsK76E6mfH9Ml9/zMAaxIGlVuOq4MAyvq2bXryR82RD1tom0DIraChyzqaCjVT9gZ8s58aeD2nvokhhqiDV/YESZgWC9Us2y100lXycFfQzGQs34lRTGGdHojdxXWX+TivWBLw4et1Zi6XqopthlTcQT2iM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DU0PR05MB9454.eurprd05.prod.outlook.com (2603:10a6:10:32d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sun, 26 Feb
 2023 06:44:40 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::dc87:8462:5ffe:ebd6%8]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 06:44:40 +0000
Date:   Sun, 26 Feb 2023 07:44:36 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, abdelrahmanhesham94@gmail.com
Subject: [PATCH] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230226064436.hr4obihsi5o4hiqk@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::15) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DU0PR05MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e2d486-e399-4d52-ca1b-08db17c4ef8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NNB8Wki6lyndDTLnG5Nn/4StWYikFvoImVuHTnZbOqy54Qa6Yvtg3WcbLzj4uA++QoiDyvLpB0umnpIeJjMqjSsij/YrwemXld03Mtuy6ldB2O4IfxObxD4UNx7E54XGXTOqY0Tc3pG/j8dEl2OHqzvSC/HoJF0HE6b6ZdlOV2CMQIkQCfILh3VI6P1LrCu19+REoRaOcKabK5hnEFUiRA/aUnvSgnDJdf9kaFZD+QLjDSuion4+688JU2BX3AyM9LEBKGoCV8YF8W++eYDPb8JMmIfacuynAS6Ne+Cl2yBbolRg7x+Pk8ot4LArBnzUOMVnEs/v5F1CrKO9Dz/2y/nagshlIi5B4jzF48rYpAMPjrzQMvVhzCRY4xuC4Bv+iyVBdIWztNrWGMTSS1xPzJqt9OHBEpuhpvmNltR82itH2s1LHmno+rzMoiun6UOLjvK32ty4O6Rpt17QoWTgfKcEg/kGAmchw+oYhoV7KY5KVGCj89hvEKQq0DQyL9uEBXjY8pz7AoZVtMCDcMB8B6ylYaIeS+x/J02rOCJF2M00th2uNzyTtDb2+iHct9Y7VNPfX4mDHgVeLiFOr9mRdtUWy00Ak7J/L4Fe629yl8TKw4n+RgMtMMHJXF0h08F35J9OMQmGXEI5eeL3P1UOBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(346002)(376002)(366004)(451199018)(83380400001)(9686003)(2906002)(6666004)(1076003)(86362001)(6512007)(8936002)(478600001)(41300700001)(6486002)(6506007)(186003)(26005)(6916009)(4326008)(5660300002)(316002)(66476007)(8676002)(66946007)(66556008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KyM50PRHUYScNulc293GBvxPAQZKQgyq5764LK6r67SwErTu7uf6GohXW40N?=
 =?us-ascii?Q?QUr3BpjV2eT+FgLNcgM3kNCP1wS+PT4ykHLIMXYiV+BriLVSd4t7439QbdRh?=
 =?us-ascii?Q?WUK2TRO5rJITNH9SlBZxJ5j1mp7IhrRxktxY+thTb0E6bK3iH8/3+KqiysmD?=
 =?us-ascii?Q?Hm4ji9tYFI4mQYMvYaQ7GiHKwBntC9PDPVgTVS6cUBGP7gxz1S5GxRxXffTD?=
 =?us-ascii?Q?VdGUf5aucZzO6PC/Y7fu7ZrpAnq3vo2qBm3CUHgXlZk9+jCNioC4YhCf2paL?=
 =?us-ascii?Q?NPLvS8hyZJ/R8Ep6SoE2S51bGZVZUVSL5KgE9L/zYyvW0hWCzqhs5PuaXw4r?=
 =?us-ascii?Q?MiVGRRbVIDoeNxwGGwoCdbcVtZ0vPYNrv3GNCWJGndYE+3xBej/CHIdibvCm?=
 =?us-ascii?Q?rcvvjhEYIEf4/4Y4OAeXNVodPZgMxdUnwP1Xcj+5YGUvZ59AzOrldA5cst/5?=
 =?us-ascii?Q?uwF779axYWIVcX2y24q+DuitOs4Uma7+J0hCOXun7hSycytvQAADmrSg574Z?=
 =?us-ascii?Q?8Xse7oxwEYlCyKdiIaR4N3umUFYfMzcGvCR6IFNE53kOmJX7hc3qYVG0Ngkm?=
 =?us-ascii?Q?sGkLgn1dpzZKa7g9ULVdHJStkqeYIENWcHPEELAI+FUI0yrbpm6NGLHe5sf4?=
 =?us-ascii?Q?cLqNqrMTiZtuzt8Fym/jYP2z3u1hjZjN7BkuoUSu8P1JW9BvGulgY62+FfAC?=
 =?us-ascii?Q?cYWehsT/i4eOy7BDuRBrPrjp0arty7He90qzbSl1oExbiudyISG0h/0VADCB?=
 =?us-ascii?Q?IK4YgEr4gwdfuAmQkQOZ2HjxLzVCEuigLx3pXrBYDkd1vBqAzsYM/gUlIs7M?=
 =?us-ascii?Q?Au/Do/OBq7b8Tm4GP7DZqSspP0BB68Vmpci0rfo3obFRxHJPp1c1UJCtmf33?=
 =?us-ascii?Q?cbHw0+E55LhYVM+DRdwKImDsLOaz93q0hvpdiWIuW576XC/H0ZmpFEr2K4RV?=
 =?us-ascii?Q?5ZzQtBb6LmkF5uFM4K7xQa+HRS2vBctU/8HHsb/nQgZBIQrxaqxDNxa3qfe9?=
 =?us-ascii?Q?NYaO+lKB0Gsl4hxM6jU2fQbjeQMvJryCzqfBMEpFv/QaD2M6hqkNjgTjXSR3?=
 =?us-ascii?Q?YTjNfrmOzmjz/1EyqqIIoYH3cYxmMQRO4JiHnWBGCzJwn3rZgknfz63UWYO6?=
 =?us-ascii?Q?S1YvPs84giKuxIZb6D9yPB0gmJ4AwlQPZ+TKnvPYkpV7Qp+oiKz65gZJzSPo?=
 =?us-ascii?Q?iFAK9zQirDP3UX3mJDSXxxVsddEAe5ZYBPvREYtMvtITSRKCK9OWEANvqnmr?=
 =?us-ascii?Q?V/XwHUQDvI/QK9DQk9m4bgQxrozMGpw4j6NiMjMBgSJx9npLfCgTOVC3w6XY?=
 =?us-ascii?Q?X6iedohpuOB+O8E4ovKe1dQWI0lddh7wXD9EcJrbBkbw4BsgPEb9DDVuI36M?=
 =?us-ascii?Q?zb6Br1b+MlY99Rnp6fwWhZmn+Jq5VweZIBnKB1VExFV/pSKSJYU4YP5PB/2+?=
 =?us-ascii?Q?4QG1O7392f8+hd6xnbAyfAgKTjqxWLIKWa7qXeMr1rTjoeayFkhOM301AxAP?=
 =?us-ascii?Q?pxJEu6eE9E5+qPDtT/Gyu7uVK8cYhs5DD3s6z3J023Jaw0Hx15L11Fsfl9Kz?=
 =?us-ascii?Q?usU2DcuzT7jv36RJYQQR7flf0LXsLVqwSpbS4u4Eh2Y1cKgpTcQ3nXG7jL+c?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e2d486-e399-4d52-ca1b-08db17c4ef8b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 06:44:40.4243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9Ee3ezYfDhCWCYd8saVUdYzzgU1S4FM5t/AM3tMimKQ5F7AVtfdYkCFxaGTQaItTdfx+4ULwKZSsWigvAqFJvEMKfGWWPx4YKYgPtjnVAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR05MB9454
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a counter per namespace so we know the total offloaded
flows.

Signed-off-by: Abdelrahman Morsy <abdelrahman.morsy@voleatech.de>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
index 1c5fc657e267..235847a9b480 100644
--- a/include/net/netns/flow_table.h
+++ b/include/net/netns/flow_table.h
@@ -10,5 +10,6 @@ struct nf_flow_table_stat {
 
 struct netns_ft {
 	struct nf_flow_table_stat __percpu *stat;
+	atomic64_t count_flowoffload;
 };
 #endif
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..907307a44177 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -282,6 +282,7 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
+	struct net *net;
 	int err;
 
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
@@ -304,6 +305,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 
 	nf_ct_offload_timeout(flow->ct);
 
+	net = read_pnet(&flow_table->net);
+	atomic64_inc(&net->ft.count_flowoffload);
+
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
@@ -339,6 +343,8 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flow_table->net);
+
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 			       nf_flow_offload_rhash_params);
@@ -346,6 +352,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 	flow_offload_free(flow);
+
+	atomic64_dec(&net->ft.count_flowoffload);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
@@ -617,6 +625,7 @@ EXPORT_SYMBOL_GPL(nf_flow_table_free);
 static int nf_flow_table_init_net(struct net *net)
 {
 	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
+	atomic64_set(&net->ft.count_flowoffload, 0);
 	return net->ft.stat ? 0 : -ENOMEM;
 }
 
diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
index 159b033a43e6..cff9ad58c7c9 100644
--- a/net/netfilter/nf_flow_table_procfs.c
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -64,6 +64,16 @@ static const struct seq_operations nf_flow_table_cpu_seq_ops = {
 	.show	= nf_flow_table_cpu_seq_show,
 };
 
+static int nf_flow_table_counter_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_net(seq);
+
+	seq_printf(seq, "%lld\n",
+		   atomic64_read(&net->ft.count_flowoffload)
+		);
+	return 0;
+}
+
 int nf_flow_table_init_proc(struct net *net)
 {
 	struct proc_dir_entry *pde;
@@ -71,6 +81,9 @@ int nf_flow_table_init_proc(struct net *net)
 	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
 			      &nf_flow_table_cpu_seq_ops,
 			      sizeof(struct seq_net_private));
+	proc_create_net_single("nf_flowtable_counter", 0444,
+			net->proc_net, nf_flow_table_counter_show, NULL);
+
 	return pde ? 0 : -ENOMEM;
 }
 
-- 
2.33.1

