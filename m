Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A855C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 19:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiEPTLS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 15:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345373AbiEPTLB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 15:11:01 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C366C25E83
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 12:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FX413iQBrlL9HHtFJ6wfgsMC1Hgs1vdr4Q3FXbBhQCHkdVPxYN5egJYvgXynomLoImQ/YfkLxmb/9/Uz7M6T8d/CyH2ebx/KevR/VcF4Lws0yiWfrfMsZ4TCA8hJJWKp+riRiA3ZndxbGd5QsKQRHakEeG9nSycJtigpEpVFHvmB5j03OlKJLVhx8NEqyTMpYWaWEgKjxws4aMPaYeXCvhgZQb453wae57kykNCoje2gloPrSYiD4Q3hanc5pJCa7MXAnUnxc2TJzF2qXeX3ERwdkqdZCy1WJP1X7mrgh2sjpqbll1/kMrIYpPn4vSVG1bfPbkfOkO3rOC4MT/mHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZ3p+ha0TK8dMC9qoW+7YKbjfYW1eP3cnXPnZhvtOtw=;
 b=ZEFb/tD2qIVK6KrPUSDlRuU0oGU0yt7PEF/4wg3TZaTTO2KtYDZdFuznplDd0MGJKPUWXdqTTIZEyMH0Zg0VTgi+2dkXTTJp4wj2A6GIACshbTaCSQnfAM6nkGpxQnn9Kw9UUXh+PTm+h1DBdhDmeeDUJ55bURRwypuxeOQo9a/UxXQ5UEILNNaWc8vpq8Nn5UyHIO39wcGsxH84NR21a6ZB5lUUD+ea/PuxkkT4KZFHnRu8DPKl2Bv2WUR3GAjRGOp+MQhS4Jntm6ookOo+8DHVsGV5lXQf8u8aTw4WTkbm20RSIwIVrz3FFSHVKkXuXrsIO/YgU+Ii+ehaRzsZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZ3p+ha0TK8dMC9qoW+7YKbjfYW1eP3cnXPnZhvtOtw=;
 b=cXZmQzC3X5QjyUGsFEany0zabaFHELN5HfQ9J0LunXIxfJtUpMQ7eJWgvJpDVFNnv15+kIpuWGZIqJF/imXo4XaCXKP63jv2caO87w3ooIOHXhbl+b3Jh6AERA6oQHvmLnVq348Oi369PcFalJHI9tIOOQACnzJZdVVKbVDXMEUBn8XaKD1vszr1Yu0My7hqE6OzB+PllpuAv1YA3Rnv7f8xN0TqHLRJ2oA/a/l7fblVizMJtk/PIBeJXh2vZNfR1JmJHZUpi+WFbVT04P+fnPzbxVbtZ8K0uITK7OYSRxyNOf398MXXxJxARR780NpZFvIm6MroNppLCyvu8bxQ3Q==
Received: from DM5PR07CA0107.namprd07.prod.outlook.com (2603:10b6:4:ae::36) by
 DM6PR12MB2697.namprd12.prod.outlook.com (2603:10b6:5:49::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Mon, 16 May 2022 19:10:59 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::6f) by DM5PR07CA0107.outlook.office365.com
 (2603:10b6:4:ae::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Mon, 16 May 2022 19:10:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 19:10:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 16 May 2022 19:10:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 16 May 2022 12:10:53 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 16 May 2022 12:10:51 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 1/3] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
Date:   Mon, 16 May 2022 22:10:30 +0300
Message-ID: <20220516191032.340243-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220516191032.340243-1-vladbu@nvidia.com>
References: <20220516191032.340243-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6099c70-2494-4512-fecd-08da376fcfa1
X-MS-TrafficTypeDiagnostic: DM6PR12MB2697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB26972F687CE1F91695CDDF80A0CF9@DM6PR12MB2697.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gL6GKnBiFxMozJzCrtkZZoH+O/aEqrZ4dUD06HgnTeZW/HHBMyjMV58lQS/0SOoeHCAhByvQgBn2t16LlyXCpCUQVcrIymj0APytrG59Gxnp7g4VWv2E0H/9LjNnSmVLxKT2v/0JeVyscDa+cn5/TKDhGLEyJLCMyUmf7zyt2mDU8/CID2VL1ojh1huiq5wmgvpuiovU0Hem6PCsMxAtBsCK0A1FTB7ffVcmw37hvCmg3bI8rA14qc/0k+RSrhnWZcY8IRUmwS65xzZMfpsF3cjycwMCvNIr9LGeo7ai5xZaqMnVAafQ/5IVvqqJbGfQIHUMkc0ybC9wMeWlDohyF2nVe7wF9gjp3P7dD//satalPVSW/FA6Fw05Pq7ZgKJs6GvFxCBaOoXLBlkgjaamO3um0eGtGEjWq/lzXv9ZyoERcIdYqF/N2sW8Bxd4crqa5d34my5BzXV29gLmeKTK9NwFVhEtUFIbTjQXpQTXZqoxxPuJbGRmRFdnx7GJEs4CDwImpmOzXPnzmPOhTgfvAAx6cZThmw9waB5qew/B3wjFww4xy3mXqF5e4wu2zAJAx1GGE+s+4/uX1zMiKncDZ6RPb33saW8SgiyPvretIFexPOIeIze7n14/PP2kUFhrvUHDtgiOgQYC0DND11ttPC5UfimxSRczmEJSpQJP54wNkJ0mtUQpWF/d9tFLEknwawYNQmrzkaq6OvUnS3GFiQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(81166007)(1076003)(5660300002)(2616005)(356005)(36756003)(47076005)(2906002)(54906003)(336012)(6916009)(40460700003)(36860700001)(82310400005)(6666004)(8936002)(70206006)(83380400001)(8676002)(70586007)(316002)(107886003)(86362001)(4326008)(26005)(508600001)(7696005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 19:10:58.9494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6099c70-2494-4512-fecd-08da376fcfa1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2697
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Following patches in series use the pointer to access flow table offload
debug variables.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 net/sched/act_ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 8af9d6e5ba61..58e0dfed22c6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -277,7 +277,7 @@ static struct nf_flowtable_type flowtable_ct = {
 	.owner		= THIS_MODULE,
 };
 
-static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
@@ -303,6 +303,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
+	write_pnet(&ct_ft->nf_ft.net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
@@ -1391,7 +1392,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(net, params);
 	if (err)
 		goto cleanup;
 
-- 
2.31.1

