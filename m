Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A49DC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiFOKoV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 06:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348484AbiFOKoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 06:44:18 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A07F5004D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 03:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkYLPOlDKl/OqsqgdxgAZ8qrwdZLmIe6vN93DhHEEe9zL3x+qnNHf1oqVyGCFMwJZ0+vR3j5pxkSQxoQ91LvO4jVu1e/bMrU2NnfEP48kEoBuQvdGOBNeE6t8KALi+qR760k0K840oOZRFlqtaRT8PJNvH2Iv3kAIttiE43HVhfL7Wh9Gdw1D0GY8zGrD5syoC0dNalSuTEu5hbT0wjQcAxr6eGaVOAgHyMDBRsvvFOdiLG91BjWW30LcNQeS8P8PtArBGxAGbDcIZ8nsm9WdHrl8eWLH9phTsGYEAav++rmpCOPPxHvS3uSvpgjueiSqggZN0D2OAjbAK0xc0ksMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZuylEaqrP9Ndd5Kg4zs+jN/FIkVeQ28jXb6porfLZ4=;
 b=hOjQZtge8Tap4mFWnMTxkODX/GaHLYzpq2ddEK3VIKexDZjv8/t/7BRqcEx+2okXF3j5c/flRq6wPypFU/3vY/rLdvhWMzAgfwGl5dkrDRQS16iV0XWOSqibWQ8L7bc/XiWgaAhbJA6tDvf6OjDYUdPNyViqeLaqd7E11my3B0dzHxLFLjOX3Gc1em6RrUHsIYjBdfaBv0vWwWYrQ6iJU0oCT9AJbd8RWZHvMAXL31IdRHg4nDchaDxP74S44PVRHqTYIogP6JW8ykBiFwRoNQq3L3NvImqGLmseMcyq1kJoXxSLyAL+OvyBbknFGbeeTRTJdHQF9u/AqbpYp8qWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZuylEaqrP9Ndd5Kg4zs+jN/FIkVeQ28jXb6porfLZ4=;
 b=ljyCdqeGw6Q7DnaAuhfDE0DixgYEjlxSdVkppjqr1XtTK02873g3paaDqVK2CMojXJLbsAaDg7k9SldtilVnfx8EGLMszgKHUlPwkHkiK/zHoVdrO1utMdoyDKBhDtKBwPQFHlEnaX3bS3s/uH+PP0Tl+NdFS7QsOjLy1BNhOC8bF2x4frZtJmMbmebM0hZzcu6GZNqPJIX4BYf09jBL9Q4u9eMeCpn3pTUisqhFG+iXpmLbAVqqLsPi4H8+8i/z+oFkQV1ZUilyWlgyNc27JCEt7m2n4Ora7wBcbMAO3kyhMo1nJDOdh8KVc4GL5C/hgmWGrdMwR/H4teU3YRyPdg==
Received: from BN6PR1701CA0011.namprd17.prod.outlook.com
 (2603:10b6:405:15::21) by MWHPR12MB1869.namprd12.prod.outlook.com
 (2603:10b6:300:111::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 10:44:14 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::f2) by BN6PR1701CA0011.outlook.office365.com
 (2603:10b6:405:15::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20 via Frontend
 Transport; Wed, 15 Jun 2022 10:44:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 10:44:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 10:44:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 03:44:11 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 15 Jun
 2022 03:44:09 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 0/2] Conntrack offload debuggability improvements
Date:   Wed, 15 Jun 2022 12:43:53 +0200
Message-ID: <20220615104355.391249-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12908b07-c80e-453e-b7b8-08da4ebbfca5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1869:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1869603B738774A377CBC40DA0AD9@MWHPR12MB1869.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EPxqMnLIqLIXqJwTw+azPHRHBfRnoiNYBBPl4UJ+K0hKrWQZzxFqKGU8O3Zi7+Yd1YPjKc7/4lWyDENDHSHlxi/1r/28/Iid6BJT/Q8W2O+vTM4Cb+vUjlJnOwBE3n7oECY54tLbFilMQSdwe8q/Ukcukl/xldlXXI7dPFqB0D0H+zNEcvqd1sSc9PCxYReG0Lr+qTY/9docg0b3sMTb7xiF9EbM+KcVhQITTgiA9qB7sLy70VNQAVvip6NadyQkzZIqT5aqJuylgJ8dFBIXM+qlp5VWThgIsc3gnCfOHtO+OFFepeqkBFfbMA/oSj6yeF2vUvVtH0wlVDBnmIJyeMyJ/n2Q1XWMGjqaXREu6nKxgAkCz3evd1y3zrKf0mIRPHOV5kRC+xhaer22ls4xOEydhS9cxNR1x7gOYDIc+O0+JJ/sGkiXerkQz1VyM16gRPhSj5+f4Y9Ix8QvoJrpQrmMmNHhDHKLFEK5MV/XJhmxqoxC7ruHSNlIPX+rqluj/Vvz5zLtGlueowMjs8GZeREq5mQFLT4gAMsd9l4l+GJ/stmlrZbqRo7Z97SFK/HEEsvVtwwnIzjfzBNZmEnhjNz2l1DMbmi/70nPWQQwIE8yIRXGbO3cA044c81WYHynaIoiw5BTMLKJ/lEAXlxj+psiAs7bEGVDsryjz7kRQPf2LUOpVXKNXFNz4fUK5/BsyV9lFpTSwfLoELLatD8LTw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(186003)(508600001)(2616005)(2906002)(7696005)(6666004)(26005)(107886003)(5660300002)(1076003)(86362001)(8936002)(70206006)(36860700001)(356005)(6916009)(81166007)(82310400005)(426003)(83380400001)(40460700003)(47076005)(336012)(54906003)(316002)(70586007)(8676002)(36756003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 10:44:12.9197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12908b07-c80e-453e-b7b8-08da4ebbfca5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1869
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Current conntrack offload implementation doesn't provide much visibility
and control over offload code. There is no way to determine current load
on workqueues that process the offload tasks which makes it hard to
debug the cases where offload is significantly delayed due to rate of
new connections being higher than driver or hardware offload rate.

Improve the debuggability by introducing procfs for current total of
workqueue tasks for nf_ft_offload_add, nf_ft_offload_del and
nf_ft_offload_stats queues. This allows visibility for flow offload
delay due to system scheduling offload tasks faster than driver/hardware
can process them.

Vlad Buslov (2):
  net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
  netfilter: nf_flow_table: count pending offload workqueue tasks

 include/net/net_namespace.h           |  6 ++
 include/net/netfilter/nf_flow_table.h | 21 +++++++
 include/net/netns/flow_table.h        | 14 +++++
 net/netfilter/Kconfig                 |  9 +++
 net/netfilter/Makefile                |  1 +
 net/netfilter/nf_flow_table_core.c    | 62 ++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c | 17 +++++-
 net/netfilter/nf_flow_table_procfs.c  | 80 +++++++++++++++++++++++++++
 net/sched/act_ct.c                    |  5 +-
 9 files changed, 209 insertions(+), 6 deletions(-)
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_procfs.c

-- 
2.36.1

