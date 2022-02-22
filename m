Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E935BC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiBVPL3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiBVPL0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F1119F15
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:10:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASvzLevzXkxtKn2bYk8Pnodk4WV4H1IKzj8xK28/SAkZc+xOOgG/pJqXLwO0qXqUU/WtrCV4/qyp11yxARTjwNxoheMNjZGbJubGSoNFQa2BCXJ1WytmzpxjZbQWpZkkYmbIC7K7O9dgA1JlnKxa/9Qfri2UqFVRt/iUU/DqF8BbqeuGjpU6UjjxtR2Kig6k+ZVSNXqk1lfWTJbkfzkLSRCibd/+wzG2uuXNhJ0eVEJy+zwDV2m8KBYUPOos85TqoHzeHDWIRVuv106l2X1pXmsm87kv1yHf/96WP8KF6gAHuppWb7z/41GECVsYQcSZx1RzSGum3XkSfs3o0EV0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V54e7MYtYO5pQobPWs0pHJTrQJ34UA+l1MkSrITtAVQ=;
 b=LE6WCYkl+godOH34fGY8JywO72HLy061utP9cKR87ywGMrGJmtoyt6efgUEJjTgyyuh74j4HqRCz12D32k8kxeD6WQZZ+rKmxeYjLYsyp+QdXjjBa7bti9UBA8/5Kia6ptPWMzBomI5kBKZ4IdgZ/JlSz09cwZZWsCS5c5IGncuetq/+sdOQEza6zUZdYgMkQkrOuxhT9oBDQRMacyGkhisGI5tpoLW0YKvmXjBgKMmDYC6arNwFuAXBTgVk4d5zWbP5ZVA41N6+et8VCkEHC+dlb1pILThIfGSegsZkh5CqkoUtLU+mXbu3qnwnIaHY1XxG45BqTg5ExZsZq0RZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V54e7MYtYO5pQobPWs0pHJTrQJ34UA+l1MkSrITtAVQ=;
 b=uMqgK6urQKjrE4tA6k77WsEjx9X5sOWwdsn+WqxUORxeDAuqxbpQpydQAgkALJ38k2CLcVdmWkzKfbkVq9TsuYW7L19qwI++dmiQKK+x7UoNUIVPgomCkdYNmFIthgObCukm2Nf6wX2BlxY3hn+v/tEV1lMeid+ifidJgKcjUH6wRCUebxeoYID6y7q8Ty7lxI+j8349fJluY8dQPmwR5pPAKcltluLb3kXRQNFAqPLanCndrFz0fdwDVIWiu7VvaLdCrHHKeJeQXowztm0+9zL80PSfQtdpLEYpOElWRonvN/x/C5NXTCchn7KJ44O5c/W3gUcZA4UUcSpPxleahQ==
Received: from DM3PR12CA0114.namprd12.prod.outlook.com (2603:10b6:0:55::34) by
 BN6PR12MB1634.namprd12.prod.outlook.com (2603:10b6:405:4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.21; Tue, 22 Feb 2022 15:10:52 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::c3) by DM3PR12CA0114.outlook.office365.com
 (2603:10b6:0:55::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 15:10:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:10:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:48 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:46 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 3/8] netfilter: introduce max count of hw offloaded flow table entries
Date:   Tue, 22 Feb 2022 17:09:58 +0200
Message-ID: <20220222151003.2136934-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1e0c4d8-1c9f-42d8-74d8-08d9f61583a7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1634:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1634CDFB4446EA79299E73B3A03B9@BN6PR12MB1634.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGzHANyu1TSYBLyBPN92y5YP+ybOswECZssnybA0UOe9p3VAmcabb+l9JXekd50y1ULY1p8gvwckaUZCeaLn4+y6K/Nt9oGPE5oCZMD0WZjPkYxF4ZpwGl4+Bi74gMHWBFmoRvIlj0KGDSGU81M7jd+syK1TAfmegsuISQYwpork57ZayeIDtKmoOckLGeBWBi1jAnHpHNwgGHvS/oHf614uu7l2pgRwpB3d8kA6GSKsQZw5/Cpm2KuWHoIkdHWZb6SMt57z//pqYSh7cFhP5qLHDCro1QyYSzonIvdiF01mBVRbDKbQNsvK+E1ARetByiIqcwH6x5kvOdcSGwL9spLYiubm5g6/PdI3+Ctq2xOE4UW7KOkyB1ie1uoUwCwBOz9VMS3xR+eLklJXj8ssoKVG4I3OBouyer7EOBcsUjp8dtOfD3yXVfKv04WTxUbTentf2qvZ7vuEE9b8VoBwWbVVpniwZ8i0D91cexDTHjyaVvm0YMntYshpEV28gFV96beRfAqCBnO0XP+I6KiZVaa3rwe9JWRxqBqwu5XIUuo3xThVKAxrLoao3REXnKvsdeSH8wRWTsNJKsreJY87e5fxSEiDbbVrDylNcD0MUKB6A+Ln9Tp/RCiDvPX+WILGqhrKSf42F3BabDgeYiVMsDhYQaPmASB9ZnYyKQXd+QI5bIDVk3edJyoUkYGTV1ccxd1UWlfKMz/rWfckxRu10g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(186003)(107886003)(2906002)(1076003)(70586007)(6666004)(82310400004)(70206006)(5660300002)(2616005)(4326008)(7696005)(8936002)(8676002)(6916009)(36860700001)(356005)(47076005)(83380400001)(40460700003)(81166007)(86362001)(426003)(336012)(316002)(36756003)(54906003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:10:51.1765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e0c4d8-1c9f-42d8-74d8-08d9f61583a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1634
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability extend struct netns_nftables with
'max_hw' counter and expose it to userspace as 'nf_flowtable_max_hw' sysctl
entry. Verify that count_hw value is less than max_hw and don't offload new
flow table entry to hardware, if this is not the case. Flows that were not
offloaded due to count_hw being larger than set maximum can still be
offloaded via refresh function. Mark such flows with NF_FLOW_HW bit and
only count them once by checking that the bit was previously not set.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            |  1 +
 net/netfilter/nf_conntrack_standalone.c | 11 +++++++++++
 net/netfilter/nf_flow_table_core.c      | 25 +++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 262b8b3213cb..5677f21fdd4c 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -7,6 +7,7 @@
 struct netns_nftables {
 	u8			gencursor;
 	atomic_t		count_hw;
+	int			max_hw;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 8cd55d502ffd..af0dea471119 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -620,6 +620,7 @@ enum nf_ct_sysctl_index {
 #endif
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	NF_SYSCTL_CT_COUNT_HW,
+	NF_SYSCTL_CT_MAX_HW,
 #endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
@@ -984,6 +985,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_MAX_HW] = {
+		.procname	= "nf_flowtable_max_hw",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1123,6 +1130,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
 	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
+	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
@@ -1135,6 +1143,9 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
+#endif
 	}
 
 	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9f2b68bc6f80..2631bd0ae9ae 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -290,6 +290,20 @@ unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 	return timeout;
 }
 
+static bool flow_offload_inc_count_hw(struct nf_flowtable *flow_table)
+{
+	struct net *net = read_pnet(&flow_table->net);
+	int max_hw = net->nft.max_hw, count_hw;
+
+	count_hw = atomic_inc_return(&net->nft.count_hw);
+	if (max_hw && count_hw > max_hw) {
+		atomic_dec(&net->nft.count_hw);
+		return false;
+	}
+
+	return true;
+}
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
@@ -315,9 +329,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	nf_ct_offload_timeout(flow->ct);
 
 	if (nf_flowtable_hw_offload(flow_table)) {
-		struct net *net = read_pnet(&flow_table->net);
+		if (!flow_offload_inc_count_hw(flow_table))
+			return 0;
 
-		atomic_inc(&net->nft.count_hw);
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
 	}
@@ -329,6 +343,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flow_table->net);
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
@@ -338,6 +353,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
 
+	if (!flow_offload_inc_count_hw(flow_table))
+		return;
+	/* only count each flow once when setting NF_FLOW_HW bit */
+	if (test_and_set_bit(NF_FLOW_HW, &flow->flags))
+		atomic_dec(&net->nft.count_hw);
+
 	nf_flow_offload_add(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
-- 
2.31.1

