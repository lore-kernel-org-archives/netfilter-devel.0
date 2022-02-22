Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3DAC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiBVPLb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiBVPL2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E94E15DB1C
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1BPaRCiNh4zSMGdCZoJ1tt4E3mvdxntN9RBdcT/5Fn+ex0zES5ozEBJ7jELZMK+nCSIfYrNQkLIMVFmt/nCulfqkAYcyFUiOi46ITYOnv9RK9QKhRlZAOBBC6B5I6Ln0pYbtvk+9nxNjEX4TUqNoK/2VNq3NlWPG6TDoUedGVMXtiAEUmKVUTmZAAzqBA+bjA4bcIpBV7mOJH4kxLeXQzcdBc+/NDT4RRvDmsIT9iYCZcHH+2JgZAa3k6CfZBWD/O7jZXAGNP7FSeDRc2/M8J0l/p4HBB1/hDsFiGrADVZqJqRMOl5dqXbTt9uWW597o8hxB5LTbV9GK2hd4MFmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hb9IW468WcjJghcL6wfzV3bDCjhPwDSjryT6ba13IgE=;
 b=nLyman59SkgOArVZ+aS26AHz4Zt8YslindjMLVCCBm7HLJdZ6GW1vmACKx99sYifw+2HnCsWzT6DWlcSi2jO+nDTe0SRofbBe9oi8ClnkSfgvEKipJz6xnEr9ITBUWpMiV1dK/MSaBZbIFWO8VxbcCZkgQjUYv3GlvnogTNSSFSh8zCaNpHjiF3E6PeTwxdsjxD1D7rabw0/od1W9rTJ3AUMcpR3oA6pgbC+ifZIoVmcgf8ZAlYWcNiD2AbQHzXZwa1fKPDkFlJ6RJ8tkXWl+KB9TkvLCLXi8Je82HpUxZbo9yQY0ZYnbMH0qhqoJb9xFWgCzRwFc/pOnUQ4ijb1NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hb9IW468WcjJghcL6wfzV3bDCjhPwDSjryT6ba13IgE=;
 b=F37g2HBQR5SYFXXTeUim3x/s91E4sK7XwPBUmNd1AmJ01o3B6Ln0MX6jBCwKGimroYaXnUTe9GAo305xqwHQ+FQIFU/iTxvTFXoHg9nk10BEmmrWaNzVfYe4XFR3E/hndUQWQZFYDLwxR/S8X2SoknHP1M049OXnvc8vikL6XElGbhnEojzaDVoZJ38WuRIT6AOGoMM/UlWbLuWEY+kb1CICJr+7MIGNR3jOVAOtGkDwPt06iTSU0hFF9WLQ5aWb5kb0axNSmFT0Ibunk2EJ+3x1oSnRr2c/Xo8YA25dQA5wLnzrbaQ9qPAfndOCuvG2Vm/NM3ZzPx4Bjhxr6zNedA==
Received: from DS7PR05CA0086.namprd05.prod.outlook.com (2603:10b6:8:56::7) by
 DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.26; Tue, 22 Feb 2022 15:10:59 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::d9) by DS7PR05CA0086.outlook.office365.com
 (2603:10b6:8:56::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9 via Frontend
 Transport; Tue, 22 Feb 2022 15:10:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:10:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:56 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:54 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 6/8] netfilter: introduce total count of hw offload 'del' workqueue tasks
Date:   Tue, 22 Feb 2022 17:10:01 +0200
Message-ID: <20220222151003.2136934-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc84efa2-6353-4b32-b8df-08d9f6158825
X-MS-TrafficTypeDiagnostic: DS7PR12MB5981:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB59819E2FE380D00111AE8F91A03B9@DS7PR12MB5981.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlw6p2JmiocfQmWoiSqFmQlNQX3Du9lB2Fu3tJheZeF+0s6Ey1T6Asqgjo7+M6FHjtVODQ1MVK011oGHE0PZUJjcsUAAapbO9rtKGo70cm0/uRuIuc6NiFl/vL0CRCLBK6r3oPL0NlXwL2sQHUTu+vZone9kyP3Po2012mpLfQjGZqtydn+LsZLgE70NwzBeG2mEvRIZEa9oyeyUDqdy0seCv4WMSpp8Qr0G5OILF6b0outRgucwSrqIJuPeJTU1pDLpsj+RzxPkloJHvNlRPCbWoocoUH2ZMxHJtBLg4JFG/PSBf7zhGLFip/UZCG4asdnX5Rh06dCNbt7pOKnzj/ciEjxKYhAPaVF9TJ6SL6OBnPFjkDqj5rvLI4tav03DkvKGn7/8zQWr/XYpT++5pDSYW+RINaz5r4iYC0qjJoL5/b7Y+WMiQ/5nWmv5WE3QS4NUrf0SIRIclke2KGv5sy4xPafiFPfHvwpANDHiLcJYbgIaLTk9jXewtXXiraLvAOyyQEWzmV6VBsAdNpNDg7VaJgqelbViZvxx/RfFbChZaIkrNZrB4bBK/pPc5WDjnCI/BySi2nGHGc7YvNKX1fHdrdcvWycShthgfiwrcMXu36rzSsJOFQ1f1idQb+VISlxytbYh8xta0YZ9k2g5UlgGrdcQ0J5Vaw30oqlQvvb+7xHrgfx/1MEfOqbEMdOj8DYD9m3ZNou49cpGn7ZVng==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(26005)(40460700003)(70586007)(70206006)(8676002)(82310400004)(186003)(107886003)(47076005)(316002)(4326008)(8936002)(1076003)(54906003)(86362001)(6916009)(5660300002)(2616005)(508600001)(7696005)(426003)(81166007)(336012)(36860700001)(6666004)(356005)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:10:58.7305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc84efa2-6353-4b32-b8df-08d9f6158825
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability extend struct netns_nftables with
'count_wq_del' counter and expose it to userspace as
'nf_flowtable_count_wq_del' sysctl entry. Increment the counter when
allocating new workqueue task and decrement it after
flow_offload_work_del() is finished.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            | 1 +
 net/netfilter/nf_conntrack_standalone.c | 8 ++++++++
 net/netfilter/nf_flow_table_offload.c   | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index ce270803ef27..ad6058d2b5f9 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -10,6 +10,7 @@ struct netns_nftables {
 	int			max_hw;
 	atomic_t		count_wq_add;
 	int			max_wq_add;
+	atomic_t		count_wq_del;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 26e2b86eb060..cebdf389f7eb 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -623,6 +623,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_MAX_HW,
 	NF_SYSCTL_CT_COUNT_WQ_ADD,
 	NF_SYSCTL_CT_MAX_WQ_ADD,
+	NF_SYSCTL_CT_COUNT_WQ_DEL,
 #endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
@@ -1005,6 +1006,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_COUNT_WQ_DEL] = {
+		.procname	= "nf_flowtable_count_wq_del",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1147,6 +1154,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
 	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
 	table[NF_SYSCTL_CT_MAX_WQ_ADD].data = &net->nft.max_wq_add;
+	table[NF_SYSCTL_CT_COUNT_WQ_DEL].data = &net->nft.count_wq_del;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e29aa51696f5..82cd78c8eb25 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -965,6 +965,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
+			atomic_dec(&net->nft.count_wq_del);
 			break;
 		case FLOW_CLS_STATS:
 			flow_offload_work_stats(offload);
@@ -1038,12 +1039,14 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flowtable->net);
 	struct flow_offload_work *offload;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
 	if (!offload)
 		return;
 
+	atomic_inc(&net->nft.count_wq_del);
 	set_bit(NF_FLOW_HW_DYING, &flow->flags);
 	flow_offload_queue_work(offload);
 }
-- 
2.31.1

