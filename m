Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339B0C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiBVPL0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiBVPLZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CABC113D98
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:10:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGPKcCQwSwRJjhj//csEvO3qV3exSv0kWVOaw+1b2RTL4+uOEhtCY2WuWpdlJYxB4e+NBvEA3GooCooYulMYl0+PMRnPCv2ZGVDU3QwQ2WjXgFlBgqEoNrPcLfbDF862q8Hmiln/ylg7H8zthA2QkxdVE8n64dQaivVrrIzbf/aEyrBCR6PIFcNjkA8AlArmyKjUEg2Yxxq/CC2Csic2avJU8gxzR7pJoVEFnZB0OAB3pnVOzvUUEhA4HG0S823Deu/pl5H7Woz+zSBjNPwsDE6zryNg1RHOmPcAWOKUb3OV3+uEQ5AOgNVZks7U4v32XwVzOVYwfi4doxRvYb9d7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clPi0/qhB504WnPR1omypuv9hrbnslv9yfiUwcHYyuo=;
 b=DqYlWJ6nud8+IaU2IG3AUDGVEAzWyAJ93tEIDoOmL6LS14aOefIg7epPVY4b6+8uTxXSfboHFFkna6gsSmI2yeR5N+e+bUUX1d7jxitfMk6dzucDOfzOfZ+8DBdx4+zjztv+GaL1OwHhA0R3QEPHGh3Gm6iEx/zGMXHbNUCCzyLdat7SAOo5LPlJpn2zsnLuetPA4fg3aLB3b/oV8dBDiqO3dYlrVbEJ3Qc2/HdnVdOz5hctv5Mt8cFwA+VmfJSvqGd0PGAsCtXC68qYx1ZeATwTh4yBxM8Pzs2MDuazpjoEb3cVlHTT67ePkbQNPK0VpbGN2kslf4Djjp5u+OhJmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clPi0/qhB504WnPR1omypuv9hrbnslv9yfiUwcHYyuo=;
 b=jhRRhALDGhEWzscGwF/zcpP68MsDiaAzbJzGQUwJHIQm/1Nno7hLtC00+3S9Qm3iJHUF6bfzOsmC5Q/1AnZbdxtT8ljbLenxyDIak44+KjxlnU/6hRPaeJKCmosPFQaijwgz+b2iPViDKBXfvt6GEgC2bQo8fjMbQ4P+MPKQ+5h4C6ATVXhlbHYgfFfLof7GmVcpdAjH+xeVBOzfkSs+j63Yi0C0I+0ijhfWHRSMwpvBPOs+dOHh/hFLfs3ctgOAxtvIKgVC6vC0sSxSYHFtXHo19qp60rNZu1NLzwUHiQqFte1ojtixadLyV0hx+aBxT2XRi+erXM5gAi5XC1h+pw==
Received: from MW4PR03CA0270.namprd03.prod.outlook.com (2603:10b6:303:b4::35)
 by BY5PR12MB4179.namprd12.prod.outlook.com (2603:10b6:a03:211::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 22 Feb
 2022 15:10:49 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::59) by MW4PR03CA0270.outlook.office365.com
 (2603:10b6:303:b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 15:10:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:10:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:46 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:44 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 2/8] netfilter: introduce total count of hw offloaded flow table entries
Date:   Tue, 22 Feb 2022 17:09:57 +0200
Message-ID: <20220222151003.2136934-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e18c9185-4367-4392-9941-08d9f6158217
X-MS-TrafficTypeDiagnostic: BY5PR12MB4179:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41796C4D07871F6C83E125C8A03B9@BY5PR12MB4179.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9piKVEMtDJUR7YXh28IGRr8ni4OUPUOhd+Grja9VWg5A+nsB3cFmvNQkDwAeby0JmpCxhW+H0GSxLuW/sKt5GBCLWTUdAPBvpXeTsem9HhOxGn9lw23Y9EQrQJpUtyadn2efzYYIjNh60qx02YyncpltrD05N4mbd//OFTtQGoixhAn2M5B7v+5ApA+Sa2Vp8ssAHwjYBeLHykxzUdvjI8iWGMfFrIwAm/AKv7kyhCBZprp34vHPqRSgD1hsaY/PpZerg37UonrYgAiIJjPqHK39ZhkyNgf4t0v1GDHnlACe/h/iOjIJl6kwS7uFI8Jx3mcpu9AGkXC9boXIZOWJVOrJ80O5lMtzbnfl4p905f/G/8a1cC1q6O2TWsmBzcR4IzMjCjxoAsdLb79RfwY5sRNjNDeZQaQcdlrk7wnHB3MjXkhLIh+MREwxBG5OPi2DbHNuDM8WG+A2DP6onIiz9riJdIhPGOdnfZsqIA3WT62ib/Z0Z2O1ynPLgEaW85+LW6k0PVlb8BmMqPCrWl+5p3FZwknqPEaPuPOzWyfWvfjm1ZgBOjMrLt4/9MwoXU3alALQ9pvmVw3Tqp+vkxaVZMgXFDDvIPmS+KMzyLx24ERDJz0p90oD/I8wa/wdXdXAmrMDbcGgk8rxPn0C9lwpyJ3UcUNUJl919w8gt5bilyRwusx3xcak6wL+tSMyTMDokELcwgOSY7LNeLFNTRZfw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(70206006)(70586007)(6916009)(40460700003)(54906003)(83380400001)(508600001)(4326008)(36756003)(426003)(8676002)(336012)(7696005)(6666004)(5660300002)(186003)(107886003)(81166007)(26005)(356005)(1076003)(86362001)(316002)(36860700001)(8936002)(2616005)(82310400004)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:10:48.5560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e18c9185-4367-4392-9941-08d9f6158217
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4179
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability and allow capping total amount of
offloaded entries in following patch extend struct netns_nftables with
'count_hw' counter and expose it to userspace as 'nf_flowtable_count_hw'
sysctl entry. Increment the counter together with setting NF_FLOW_HW flag
when scheduling offload add task on workqueue and decrement it after
successfully scheduling offload del task.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            |  1 +
 net/netfilter/nf_conntrack_standalone.c | 12 ++++++++++++
 net/netfilter/nf_flow_table_core.c      | 12 ++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 8c77832d0240..262b8b3213cb 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -6,6 +6,7 @@
 
 struct netns_nftables {
 	u8			gencursor;
+	atomic_t		count_hw;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..8cd55d502ffd 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -618,6 +618,9 @@ enum nf_ct_sysctl_index {
 #ifdef CONFIG_LWTUNNEL
 	NF_SYSCTL_CT_LWTUNNEL,
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_COUNT_HW,
+#endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -973,6 +976,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
 	},
+#endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	[NF_SYSCTL_CT_COUNT_HW] = {
+		.procname	= "nf_flowtable_count_hw",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1111,6 +1122,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
+	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..9f2b68bc6f80 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -315,6 +315,9 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	nf_ct_offload_timeout(flow->ct);
 
 	if (nf_flowtable_hw_offload(flow_table)) {
+		struct net *net = read_pnet(&flow_table->net);
+
+		atomic_inc(&net->nft.count_hw);
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
 	}
@@ -462,10 +465,15 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
+			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
+				struct net *net = read_pnet(&flow_table->net);
+
 				nf_flow_offload_del(flow_table, flow);
-			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
+				if (test_bit(NF_FLOW_HW_DYING, &flow->flags))
+					atomic_dec(&net->nft.count_hw);
+			} else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags)) {
 				flow_offload_del(flow_table, flow);
+			}
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
-- 
2.31.1

