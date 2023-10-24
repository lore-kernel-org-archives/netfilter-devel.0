Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1AAC07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 17:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjJXRSL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbjJXRSK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 13:18:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D755E12C
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 10:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/ZqJIu50AGwIS1/tp+wiA4XYxGXu7/XwG9tUyovBEluQnshvHeGbrocGFwNn5cw8J1um3dj9weCc9DCqUMn572CGhZdCW/MezaNr+1TGv+FgvQe4zbA45KWHUPUs/Fd+/FW6JK5YxR40/BRYX1LM1qE1dkbC4EH3TD02O6LmXut4EAPlArE2fbxM4kOL5fqdKPdMhLxU9RRq6rvHPDgKuviHdNLNvsnnhLw2at8gghcbXHfSux7MqPjDmxOrcnPulgyGjAIHolRuET2gInewjYih8NynpZbr0XRoDYwFHhzi7xOQnixrzl9uPvgUFqPnHFGmG/KxXA0neNYTVj7uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQXb+kh738qmy52XTSGT3ZFuFKMkPEk4b8ZKmzPFKQc=;
 b=IUubG5I4BV/KDwIvwtiGMVdtgyG1hIQP5Kj69U5xaMtRzh2hdro6QnfM9VYMnlkozsXvsYtNoJMrp9zzFsRySVOkhKkCSi4taVCP84Oc5MzGv1xlPrwOifCVa6om7/3QdMRkylrz4jyEWsXdccv5JH6jl00ocBJDbMD3eAZPw4eu3XWbDtdc5EzdsLT6Zb3awrdQBcsLSKstARHw6J3G0eDayYSEvTXjin8tIlvv4pxSEs3UnZKHMNGpi7d+yA0lKJz08nOhUYAUtpgIaKSe79l5wcsn6f5y+Qan3DpBffQJStdevVTDWFfcg9ovZMaiL5LRbQz8R/D3uVBTU/J/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQXb+kh738qmy52XTSGT3ZFuFKMkPEk4b8ZKmzPFKQc=;
 b=s+dZ3qG8odYssnfXKPw0s0/CC/IQohZeB5AZqduElASL3q34OeyX+6tTbUwX982VN+HR3toOwyDRIpfcOALEv1ifW2Sq8SAKTvE8C24XVLazGuqZPUBY2lr4zroMvQ3cav/ySdlYqoDF2hPsFo9xg0Z5qzAhSZsTGOjzT5URtCrW0TsGERHnJquVV9mR0dPxcDK5VyYI2ixC+55gdMjLqvehnkxzbuWF6+Jg4yj0CXBX8RvEOp2PjG6dXjv51EBWLYPBI2Fev3WA4USwHlOpR12RUoetgkryQqyOgm2t2/CBPPiHG8FHGed3ToZKrGdSP1JUGm6MkdsdVlkJYLpn4Q==
Received: from DS7PR06CA0021.namprd06.prod.outlook.com (2603:10b6:8:2a::23) by
 DS0PR12MB9421.namprd12.prod.outlook.com (2603:10b6:8:1a1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.31; Tue, 24 Oct 2023 17:18:02 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:8:2a:cafe::c7) by DS7PR06CA0021.outlook.office365.com
 (2603:10b6:8:2a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.35 via Frontend
 Transport; Tue, 24 Oct 2023 17:18:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.18 via Frontend Transport; Tue, 24 Oct 2023 17:18:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 10:17:50 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 10:17:50 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 24 Oct
 2023 10:17:48 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        Vlad Buslov <vladbu@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH net] netfilter: flowtable: additional checks for outdated flows
Date:   Tue, 24 Oct 2023 19:17:18 +0200
Message-ID: <20231024171718.4080012-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|DS0PR12MB9421:EE_
X-MS-Office365-Filtering-Correlation-Id: 5668bac3-552a-468d-5cb1-08dbd4b52d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFOxMCLe2QzDQHlyoVfVZlpfJvV+jseGxHZqDvrk/f+rBMHOtZY8PXKeGo2jcmd8jr+X0t9UMokUKtuVBQhgqwvT5dIh/W8GRddS7KQ5H6DDMOdpKiR2j/JDr6lZ+4fUv7r05NdkMAji2cGAHmSaKN3VSmCnZdsbbhsy+P45C+Nf0aF7agqgwT9e5UaOaVnJAMGnUYaA25BVcGFQprDFMqfZec6rqyeuvxdIvCzkWSHxFoTINUELmbjqXEAO4oKrNtSF6L31RaZq5snKAV0zUHia5hmgG2Ypsy3Nhu7/7JEgsBbm6wIaKblkQeLUTMbLkNgGCzARg40mAhdXwLvOGSggj4vn9yHPcituvtGzkX9Q1flGcGtMSXCNvTJOlSPrGETx6555iFANzD2KRFGy56RWOGLi7w+3TIVC04ph/r9i8tf4DUMhCB2lwUSF4t+Mc+nYOlW8BY9c82uMWzlKgfPb/609KHKsByvOVl9il0yGiq37Zk/Nz/Ix3iyqmOSi8UqykLdvWzufvohZoRaw/AH0tZv8iSiDZ5t4aYsZ5cRjXg56ZzRRiDet3f9xfV9AfJ1OST1aCoJb/zNMRtKQIqU4tMpklra0dREQS0yGZjVbGQw5eyWdS9A3dpoAFzzvzAnHdNBA+1nv+o8ZSDQPBYyl7pYqFiHYOrADDi2C6takW+m8HLJ9cdoxMOQkrvOSJ2VAmWRu33LmMHN1CX4XFCUw7RJmvfo5u8R3Nt4RwJ4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(82310400011)(36840700001)(40470700004)(46966006)(36860700001)(107886003)(2906002)(70206006)(70586007)(54906003)(356005)(82740400003)(6916009)(316002)(1076003)(2616005)(6666004)(41300700001)(478600001)(7696005)(336012)(47076005)(426003)(83380400001)(40480700001)(86362001)(40460700003)(36756003)(5660300002)(7636003)(8676002)(8936002)(4326008)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 17:18:01.9771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5668bac3-552a-468d-5cb1-08dbd4b52d8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9421
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Current nf_flow_is_outdated() implementation considers any flow table flow
which state diverged from its underlying CT connection status for teardown
which can be problematic in the following cases:

- Flow has never been offloaded to hardware in the first place either
because flow table has hardware offload disabled (flag
NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
workqueue to be offloaded for the first time. The former is incorrect, the
later generates excessive deletions and additions of flows.

- Flow is already pending to be updated on the workqueue. Tearing down such
flows will also generate excessive removals from the flow table, especially
on highly loaded system where the latency to re-offload a flow via 'add'
workqueue can be quite high.

When considering a flow for teardown as outdated verify that it is both
offloaded to hardware and doesn't have any pending updates.

Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1d34d700bd09..db404f89d3d7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -319,6 +319,8 @@ EXPORT_SYMBOL_GPL(flow_offload_refresh);
 static bool nf_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
+		test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
+		!test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
 		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 
-- 
2.39.2

