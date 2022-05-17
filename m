Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C34C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 16:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351280AbiEQQ7h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351281AbiEQQ7f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 12:59:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F004FC69
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 09:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtjGGBEOq0U4TYCXslexJkgiiCRfcoDIzUWQZkKXPxcNMJFviZXSJJkOZZJqCv4QR7VfUYfKtbdzvpVPzVOg+KUhEu+5YPeUotBUR0kGTW0KlKBiPJSRu1ttevrqLJ4Mo3XbW7chAvsfgzau0TX/RNIjGTCY9xi+7rKOCuiUzGb+fP1TOeSKpL+1Di3ntV00vysRC1FqqnzHWprLsUNzlJ/r0eLP1GarP4yNNpJ0JLs/lWSxCAqjM7l5O8AOD3zzVNRIK9dCjMR3YXmiVw9Vv1D1QLBDeY4um4kFHYnFA0CZKf8emCLRRSa5q8CbywKJ7wcBTBZTSij3hnuSMUuVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZ3p+ha0TK8dMC9qoW+7YKbjfYW1eP3cnXPnZhvtOtw=;
 b=USlUdsySCbfC9JQ+WM0+yiQXmRd8aPMNku1BpW1qe1mN9+wGFZCHH9y7nxh7RUYpTU00bRHrbYvsgQeLFCSTMUWG9GFJcczL8pkZSGHgeEEQMwhY3MrvE8qJ+YnxdV6xkqE+X3xwKI7GNjO+8ncCxoeSo4amZ5MkHGZB7/sKZmkuCRTpGZsfbSQSoeaUA373DtSReovyJhN6FuV84HWUe2IUkhLouyYjz1t0BvpumPmx/ng4BQCb1REUN5pGxYmc+w4QBcwTm2sYV9xVaQPPWZQIPCut3MLCZkp8zJoMSicKm4w1nmBYjMS1Ss6WlaRjGHSMYsPzQA67kTNECeldmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZ3p+ha0TK8dMC9qoW+7YKbjfYW1eP3cnXPnZhvtOtw=;
 b=RxwqivbV4ia0ENDEN80EI/A7Nc4VDMO65R6M4G7KOBMUudG6mQLrkqLSw29PJfTrD3TqgnL/NKz7/8mEzoGmFEqLi6S+5PrAGrACOS4aRDpajBvpNis4NOKSK8cg6m6RJU3m2WFGaOfcns6/cZ+/LmMyyRG6uCL/h/qAMW64QbysfV1CW4PopOsuE0OAzKLmcL4H+WGKjS1eHAUlA+RpeaGVnTj+vOMg3xEUxD5+SdAVF5HNF0OaJzvSqy/7XA2XqWUPy33+hQt3yvLVTpNidkFUYXbAmpWkLuNLb9TQpwAHuPFoCT60HG8Paygjqy7/K34AG4Alm7/6cOQ+DiQkwQ==
Received: from BN0PR04CA0208.namprd04.prod.outlook.com (2603:10b6:408:e9::33)
 by BN8PR12MB4594.namprd12.prod.outlook.com (2603:10b6:408:a2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Tue, 17 May
 2022 16:59:33 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::95) by BN0PR04CA0208.outlook.office365.com
 (2603:10b6:408:e9::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Tue, 17 May 2022 16:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 16:59:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 16:59:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 09:59:30 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 17 May
 2022 09:59:28 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 1/3] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
Date:   Tue, 17 May 2022 19:59:07 +0300
Message-ID: <20220517165909.505010-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220517165909.505010-1-vladbu@nvidia.com>
References: <20220517165909.505010-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caa212f2-ec63-44ee-11be-08da38269d64
X-MS-TrafficTypeDiagnostic: BN8PR12MB4594:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB4594D555FBAA9CDFF0233CF5A0CE9@BN8PR12MB4594.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Di4d/DqR+d23oupTAJBouGsvZaQ5ekiJ75Dmw6I2kAM+8scKXY21reNdDEzLxkeXKkx85okn0Yb5hWJVNGe6tugRWAM8f3xIjR/9EdXRgoozjtt1JdpD+1+nDmGMfPLcZoAazaEh/p3cuo8DE8XoLgiiRvXcLZVWmEmXjovWE8XKrmTCJqmzWCn9l0cls+YYzkUO4wuQOpGqXR8kf5cVf6WmjxIitjRhaoLaKK3trxf69KlF0aIKHwpL99RIDe3233R7ee96QjWO3qrfiFvQfROh4R6E2GztwZcYmU0FiSXOwB9Rk0w2u9Jz0Zm+xoFGtIwrhyvW9aw2miEZa27yJ3fi8Lr0jQvKrJjboubbGqOkLY5NR3JXIh6f8HaHwDYJVufh+QgraDrPERmPScX4a0lTXk2dWA/vrjjwHQTUERvXUicijCW8LRGadQGRxB1szgdNl9DqR2iXQt8hZrKCJBOLOwPtgTNy3XYVb9u2m5ILGoe0lp69wHD30yJFJrSolnN5MnNKFpdAYPbLDvAmkEicJX7UX4vhbNs798e/3xkVdu4kR5kH+dR9xImQfEf7PQHlzVFjg1X+p+Y7TeqrYjYLzzpX6ELq1mAPcz0/pjwRpTSdQ5D/FBFzsU33TU56TWS6ZVAUyAZd8iXPvG3F1sz3QW7TXsvm0IziF9q0bMkkWKG7XAb/vbUZU7OL5wIx0aF1VupLlArDdV37jSKlA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400005)(316002)(83380400001)(107886003)(47076005)(6916009)(5660300002)(2906002)(36860700001)(2616005)(186003)(336012)(426003)(8676002)(70586007)(1076003)(4326008)(36756003)(40460700003)(26005)(356005)(7696005)(6666004)(70206006)(54906003)(86362001)(508600001)(81166007)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:59:32.4965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: caa212f2-ec63-44ee-11be-08da38269d64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4594
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

