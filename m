Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDB1C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 19:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiEPTLR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345370AbiEPTLB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 15:11:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE5C1D320
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 12:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY/qlAMjbyDuXVscdC646zQPEXSfmL/owRpiVVD5c8sySYNWp66gJNRJZPmn+4beMnO4hNnxpWKPM4VCM20hNGURiLMFccPz0DeJjbqnRt08G1qFnxznoiglod/cLIfXgxO1a6LWC5y2Zt1PyE58ZdqSXggPUkRkzNusdt45VU2oTxeAXFo7BOYxw/dljrJq+o3PQunoD/Wj2ca59L3SjB4TxPll4umBkybgCJXvB6tIJSLULs9RHKXztr/KJ1pM0EyTr38WTN/FkDdqtxvfdSqkCJuA2UEi6wcVKmUBRUiZ0Gm9FPutq82EwIPLZn78zoLaOXP4RkM1jcx+HoSqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uH4U+P0DCox8SDUjSLDH68SlTn73ZahIwvhwEmJSZOM=;
 b=kx5wgsAvSgVodVIX0YoALR2hCM12JSADy+2GHYMkPd+Ja0uPQFUmzUayCZUDXvhmg6OziMLjLkXT36r3iG6JyQFX/KcZ2yU4snDKisUPCCSTcpizFlNM7A+qH5npng7CLdqKXCCiUoQ6al7j3zEfk3SuofB87Np/tB+StSbR1Ti6Np/7JmY9hjcBhlhPkSMfT0ctEByjs3g6CGUriKqkWHTV861++a9QeVt3fwyXO6lSC29lRtFe9gJEVEPH/uEA/XYRtFqUIMg/vIdCVOy4zTCafB9alnKuL7tEaXax3Dps2udWouUY0TuR/JSxAWq0xEf/m4KOID9zeINL0RrrZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uH4U+P0DCox8SDUjSLDH68SlTn73ZahIwvhwEmJSZOM=;
 b=Fw2/d8iwLXL9fENjzArFHuX9g7fffmHXNlTpC6q4sYbMtGMnPQrs+3ukm7Kn2YFBsFD6t7ADY7owGLx7Ggtyy2w42qH4/bHhv2IQH/muMEw+Txo/n6fyAf0v0AR51651JODlM+hpqFybwc64aFrEihYfVikNGPy5VCuR08F5561ZPFDrQ2pwpZpCoUYAV7Odo+kE0LIvP72JZWvv9q8enb+89kwg/m5nzS9hYrxnbcL4UDI3ueye0vm59rG/nZUh9mfSCabIIhlcweKnEfQ8WyfOcsWeQ71Leye/G6q6Wy+M//mcpa2C0tjwsVWzqK7OTRz/AEuvIgEL+bKoBZyulA==
Received: from DM5PR07CA0119.namprd07.prod.outlook.com (2603:10b6:4:ae::48) by
 IA1PR12MB6043.namprd12.prod.outlook.com (2603:10b6:208:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 19:10:58 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::25) by DM5PR07CA0119.outlook.office365.com
 (2603:10b6:4:ae::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15 via Frontend
 Transport; Mon, 16 May 2022 19:10:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 19:10:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 16 May 2022 19:10:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 16 May 2022 12:10:50 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 16 May 2022 12:10:49 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 0/3] Conntrack offload debuggability improvements
Date:   Mon, 16 May 2022 22:10:29 +0300
Message-ID: <20220516191032.340243-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b637c34b-ffca-42e8-44a2-08da376fcf02
X-MS-TrafficTypeDiagnostic: IA1PR12MB6043:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB60433C9C94965B0E623F7A43A0CF9@IA1PR12MB6043.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H9rZH82tzAZt1WE/TSZOGhm9Z+fBgHzXwxlfjDeOvGPl6d6+/COQdHnNBe9VwnQ3UqGF3KdGgQ9EeetL1FNgo+Xo31DHm2CWdfM8Td7IeRLa4e11UYvMN5VQQ7hmW7ajku2Xnd4KnYAeO4MDw2tM0UeNwEkBHfvvg+dopdwTkvLCVqhOTdIfzDU6au3Le4FHoTMQzWiOVuxfbqZaRhyld6TyInEI6AM0MHGOQfNCOtEWuB/EvhfGwKSgBhD4RE889R43iVcZfrTjDg3O2JAdEO7DbkDGUu6SsI/cjzt+Ac/yCmPUgDeUWRcDzEbeTS4VtED54waTKuxhhadXida8ImiycipGniB5loscyPOJ1YpbDGqgYte+Ie4YzTEW6SfJVVLSgNd49MAAC++zt8kXq5/eZ1o20IetSG9yddPbuCqvGBnSPBYaNXWlP0JacYDYUjRwN+p0uFnmx0ikhoKHMqsO7KTjYS0fvc+jjNtjCt+Nqw5QRazgfUTsyYpXEcsZ64m9Lj0onI34O7BB3l6eeD64HPvjLuF1uSmjRzYtFE/HxnJFUCDILfB40hjeRKARF7BDMuQUgrhEGRGjYYkwTfy+SBjS0i/nWiy+8jjeo+kLvFzg4zmlWl96EYhH+B0z7+7dW33EW6OEcBfzvDTayVzbNGFl4Ex9ZRqnhVOVDorDbik1UE9Br1JTEeV3LAgEIv2oaSSzV1tBySDM9pNTgg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(70586007)(70206006)(36860700001)(8676002)(82310400005)(81166007)(1076003)(26005)(36756003)(6916009)(54906003)(40460700003)(316002)(2906002)(47076005)(2616005)(186003)(356005)(8936002)(7696005)(83380400001)(6666004)(86362001)(5660300002)(426003)(336012)(107886003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 19:10:57.9182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b637c34b-ffca-42e8-44a2-08da376fcf02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6043
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Current conntrack offload implementation doesn't provide much visibility
and control over offload code. The code just tries to offload new flows,
even if current amount of flows is beyond what can be reasonably
processed by target hardware. On top of that there is no way to
determine current load on workqueues that process the offload tasks
which makes it hard to debug the cases where offload is significantly
delayed due to rate of new connections being higher than driver or
hardware offload rate.

Improve the debuggability situation by implementing following new
functionality:

- Sysctls for current total count of offloaded flow and
  user-configurable maximum. Capping the amount of offloaded flows can
  be useful for the allocations of hardware resources. Note that the
  flow can still be offloaded afterwards via 'refresh' mechanism if
  total hardware count.

- Procfs for current total of workqueue tasks for nf_ft_offload_add,
  nf_ft_offload_del and nf_ft_offload_stats queues. This allows
  visibility for flow offload delay due to system scheduling offload
  tasks faster than driver/hardware can process them.

Vlad Buslov (3):
  net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
  netfilter: nf_flow_table: count and limit hw offloaded entries
  netfilter: nf_flow_table: count pending offload workqueue tasks

 .../networking/nf_flowtable-sysctl.rst        |  17 ++
 include/net/net_namespace.h                   |   6 +
 include/net/netfilter/nf_flow_table.h         |  35 ++++
 include/net/netns/flow_table.h                |  14 ++
 net/netfilter/Kconfig                         |   8 +
 net/netfilter/Makefile                        |   3 +-
 net/netfilter/nf_flow_table_core.c            |  89 ++++++++-
 net/netfilter/nf_flow_table_offload.c         |  53 +++++-
 net/netfilter/nf_flow_table_sysctl.c          | 171 ++++++++++++++++++
 net/sched/act_ct.c                            |   5 +-
 10 files changed, 387 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/networking/nf_flowtable-sysctl.rst
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c

-- 
2.31.1

