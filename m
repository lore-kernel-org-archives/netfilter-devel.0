Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62FEC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiBVPLb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiBVPL2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F00215DB15
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1mM8B29WPZOB4Lgg4k9KRCm6kX3+nUH3KcLuFgpkB5te73vEdaUXrNUgakkLn8JdQVWgVx4z14MR+qUqnXggYxCed9kzUSgM/8cYR1UHYfrwJbYtPdR2w5DSOaJ6TBoR4KGqR+DERogugQSGNztCJdT9OCQB167Ud7MayH22Nc/72q0BkBdb6p0XI5isSRSfE2UePiderifZGm23BgLx161FYBi9YJq76qeawZOc/AKqYEGjWKnXwlDttMbV4mcfQd7vW2Najx8gMTA2yEX/Nc1aUslgYeYRAT7I8zWYFhmPqqDBTumjtYeZd+rdTrcNeSJi05P84D6lPZ7XQbpKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5u4/RX7OAyulg7f+6tk8nQznxFIsLKyVnqFbVnzsNcM=;
 b=SciV1UYX+azKa0GzrcNUnstulbDizYy/k3Y6WnAtE2BOO57uQ5bY4BNJwdqWuax5daf2lf1ZcAM5j78H19Th/8lCDvXomSzX5kBAxo8xEPQLZ8X47cNSvVT6hhwTVLszN58MTFqKB9HJ9112BWKUQMmlzYCy5EmET+oBnjg9st42M/xyQVtsgoSC37YkD80J8wDXNqWDD1Jml+KsZoP/3CWPoaybp8lYMuJVPs8GZdk6YrGc4xZ+IygfHCKnOhea4RoXJJ61aaIQfnFoVR+am9tolM4XolvrDiBRJQgkSWz4GQtAtMpJ/Cav6Hei8ZbEnad4H1hEpIWlbWj6lDF9VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5u4/RX7OAyulg7f+6tk8nQznxFIsLKyVnqFbVnzsNcM=;
 b=stbjquZBAogprlfh+KNUbGk9bL/FKvOotEVyazrPR2N0F3LGl3dvPi2I2iUGQrOzQ0E4VoaiiOAbIMx49mOkRT1cXRQ/AFBeeZHgKEAa8ROlEkGIut/bV1c95ZNrIfi+z3oD7XNRo2lj9bpedwugtBpozYMYXCLA2txEpIYjzlcukwQcIUDQox5G1kC+sIXTGB8gaiWnLLg+UNRTbIhr4iIcBgq89vgZ9b+HHz4+cFPMbrxr/ncX3ME1W0CiYflJwoqIZ18+vUJHy2HqcF7pLoGbD+OSBgy7pIKAxm+3F4OEq6SRsi5ecoLRipW9x4EbzOLyTsH0R3R0WuUyWUg9fQ==
Received: from DM5PR17CA0058.namprd17.prod.outlook.com (2603:10b6:3:13f::20)
 by BN6PR12MB1924.namprd12.prod.outlook.com (2603:10b6:404:108::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 15:10:56 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::b4) by DM5PR17CA0058.outlook.office365.com
 (2603:10b6:3:13f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13 via Frontend
 Transport; Tue, 22 Feb 2022 15:10:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:10:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:53 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:51 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 5/8] netfilter: introduce max count of hw offload 'add' workqueue tasks
Date:   Tue, 22 Feb 2022 17:10:00 +0200
Message-ID: <20220222151003.2136934-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1ef15b-2e4a-4e78-6d9a-08d9f6158675
X-MS-TrafficTypeDiagnostic: BN6PR12MB1924:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1924B5FF2172F136C0133791A03B9@BN6PR12MB1924.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DWVYxYu8r933tYV0AgjJwy8g3JAj9vyvXHttqbvDVZKSEyYwSOlbqgn1eu1xmdIVpc7H2bWUCTlwXswDA4ZbLscI14CvLfCOydh4CZR9J38vp6HBOR7l9UhOBl2NQfGObAgFRJIM9athX579O4nbN+O+HKCfV1KfX6gyevQ3MLNH3XM7I2E3Nlgo05rEjPJa87SJrfr7/0wTUtfzoYkMCyg8ciqXfMUE7zChX7zlLOKwEWyxsF4XTTx8A+1rUXenA7TruH9zs3V24A2r1tDiT5mv1VCJuPYS3mUDfUgqOxYxe+xg3hAAF47mSiD4SeU1pfAKNcXLjSariAdUJByCz0KopSZdv1hA19UzI23VDlfKe7FQcXDZhl7oCvup3kMAeLHPdA2w6veH09IAUrA+Vtt6VWjz9ClVpfJ7r4DWQ1Ly2VYDqok5kbMjcy02y3L/IM6tPhYixRAhSXPevcGo7wjz+6fhKh7u+mbCJCLlxoUykxICPls3Drbc1g6aJ0pXWOXPvrbXVAwBTfCQIEujkN5vfZluz5wMUksarYOYF5TASNk5ZO/6g+ATGK5Rq6dRh/VJdYfCIrnYWadzl7RDZfP8ccO7LVsw9eDw2+PeVx4tc4QCR29kW9z0sgwg1O8nRH+S44nAhzFBUArDxhSNTGc8bNeP9OMIKsjihw7KYH2WE6bbNOMk1CDxSSyqxnPIwPqW3fuGtul2/pgSM20vnw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(83380400001)(4326008)(81166007)(36756003)(82310400004)(26005)(54906003)(186003)(70206006)(6916009)(7696005)(70586007)(2906002)(5660300002)(316002)(47076005)(1076003)(508600001)(40460700003)(426003)(2616005)(336012)(356005)(86362001)(36860700001)(6666004)(107886003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:10:55.8974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1ef15b-2e4a-4e78-6d9a-08d9f6158675
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1924
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability extend struct netns_nftables with
'max_wq_add' counter and expose it to userspace as
'nf_flowtable_max_wq_add' sysctl entry. Verify that count_wq_add value is
less than max_wq_add and don't schedule new flow table entry 'add' task to
workqueue, if this is not the case.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            | 1 +
 net/netfilter/nf_conntrack_standalone.c | 9 +++++++++
 net/netfilter/nf_flow_table_offload.c   | 9 ++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index a971d986a75b..ce270803ef27 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -9,6 +9,7 @@ struct netns_nftables {
 	atomic_t		count_hw;
 	int			max_hw;
 	atomic_t		count_wq_add;
+	int			max_wq_add;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fe2327823f7a..26e2b86eb060 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -622,6 +622,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_COUNT_HW,
 	NF_SYSCTL_CT_MAX_HW,
 	NF_SYSCTL_CT_COUNT_WQ_ADD,
+	NF_SYSCTL_CT_MAX_WQ_ADD,
 #endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
@@ -998,6 +999,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_MAX_WQ_ADD] = {
+		.procname	= "nf_flowtable_max_wq_add",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1139,6 +1146,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
 	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
 	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
+	table[NF_SYSCTL_CT_MAX_WQ_ADD].data = &net->nft.max_wq_add;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
@@ -1153,6 +1161,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 		table[NF_SYSCTL_CT_MAX_HW].mode = 0444;
+		table[NF_SYSCTL_CT_MAX_WQ_ADD].mode = 0444;
 #endif
 	}
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ffbcf0cfefeb..e29aa51696f5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1016,9 +1016,16 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
 	struct net *net = read_pnet(&flowtable->net);
+	int max_wq_add = net->nft.max_wq_add;
 	struct flow_offload_work *offload;
+	int count_wq_add;
+
+	count_wq_add = atomic_inc_return(&net->nft.count_wq_add);
+	if (max_wq_add && count_wq_add > max_wq_add) {
+		atomic_dec(&net->nft.count_wq_add);
+		return;
+	}
 
-	atomic_inc(&net->nft.count_wq_add);
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
 	if (!offload) {
 		atomic_dec(&net->nft.count_wq_add);
-- 
2.31.1

