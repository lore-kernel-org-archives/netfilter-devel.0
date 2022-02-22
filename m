Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C60C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiBVPMN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiBVPMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:12:13 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2074.outbound.protection.outlook.com [40.107.102.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E63F114745
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL1UDzg7wpnthbxWfFxGhHJTzHSeTCRaG135z+4ePAn/4b0KNMBUGYs4HcIyRtxlew9PXt+pGjQZ3ku1tUZRgZeIMBeAFCgeUXlJIjz5cGpULf0KW0YCUSa/32yLpCNbnC9ueUNpovwoB0qDjmI1SI0QvKSt+aZ9O2OOdcgVpGhk2KzENCGVKf3xY78P4jswDzcD44Qmr3KQeoRukalrxG9Fo08GNMihQGQpXDcF4elB08uUERk4SsZPeZF8QZrFCGyvoXqvW29mt0dncHAPjocdKZQmA3+uHO9mR2s5pVzOsuY6Rtyr11h7GBGWu2KKHn8pb95iO4wuWMvxWbtLbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+tMp7FFuiT89nUWNnZaZgDATVkThnAtN171mf2rods=;
 b=nAPnyCD9dg1LQc56indEvffHEP6fIdD0aYMOzrFH/U0YmpcF/YpnVUafJWZWHTcQB2W6YtFp7P35ejoXmfauj5Aaeijg6b3WCN73W2L8PWvMdWa+wiROlgUpHcKidmLooFb8f4MaHXYf40EGXHUvehXMb2VY6+C8Z/JMMPuv6FiP081voPzFl0SAMsp4taEgZbLRfW77qsrppjEIKtnz8CJJtC9tU2e4Rl1oBY9ogmP/Ze/UD7Ty07o3xdHBGAg7KJLRtoarB7FXgXoXV4c1SarHzL26z3AUhDcf6s3ueQY9shJL7gyVNdDcJg9sA0VZAljzudQd4z71Jb1da1IBpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+tMp7FFuiT89nUWNnZaZgDATVkThnAtN171mf2rods=;
 b=rQ04DYIEJqLhCpFbENcSzCe5kR+Uol/yj9ds+p6Xo8A0dNvMhKhlHpbqCILyyPq6YJWWfRt24g8M9zD5pCiUKL5qF6StQ0Wecb4mizIMw/Y3XPbEdTzb2HvAjYGfq6stfB7OCCaxFTrlSQMMTVL0KXoDTSwYJZt8YgwtqQzBtugk/LgoDObKVrif13B0p8RYD3aNyQobwDTSRTwnPztrfPfTeBKtyh97l1+6HdGifMC5X4Nif/hLjKGocn7ncIn5mz4LQE0ysMiR+XAFZS8MYRNZmEQEeCAMvdRLDFFFGZ11Y/JSeknufa8Ue65cXFvJgK/9QSuyiEGT3jkD0C4Aqw==
Received: from DM6PR11CA0067.namprd11.prod.outlook.com (2603:10b6:5:14c::44)
 by LV2PR12MB5824.namprd12.prod.outlook.com (2603:10b6:408:176::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 22 Feb
 2022 15:11:45 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::8c) by DM6PR11CA0067.outlook.office365.com
 (2603:10b6:5:14c::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Tue, 22 Feb 2022 15:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:11:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:41 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:39 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 0/8] Conntrack offload debuggability improvements
Date:   Tue, 22 Feb 2022 17:09:55 +0200
Message-ID: <20220222151003.2136934-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00248f24-ebc8-4bf5-9935-08d9f615a392
X-MS-TrafficTypeDiagnostic: LV2PR12MB5824:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB582459C0098B8BDD6398331BA03B9@LV2PR12MB5824.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLHQpS2sz13uaYMxQ9gVwflEqWQ8LZ/XE8Ur34iNk2k06piW7Ytl7MUM527kWMCvIrILFcscNsSrteTE4yDOgOUUHSqvtkZPgGqrdIJEZLaVCi+PW9cJ7FEWgMotgB298Gd81oZmosdOQmi2MXZR0jwWbyoxnJ4N/3Cqj3qAvrYiaB6YN+IfeMjq2qkSuqk9/epr+x9mZzyt3FJuwKKRZqZNNS4GyA6xZ8QhVffKcONdPM3tqFcU9wVo2XFnpgwVZgI9sjA4PO77bidonwho15pL0Pi22tBqm6otZuYoKshgKBfQXKhQEKwgbnXjJdKYqeQ+qduxar/bqO7ir0kzO8Jn2LPfYtCTL/mhRiHKiwqj3HHHLviWLw/Ysm6/yMc0o5ava8Uw4VdGPHqG/cGGrdBeNmhwlA2XIoWUTs2DjNfyRjPP6wFihej38rwf+fW5fhLvpoecLs0u2U+rZ3bafMTSZWSQzTg0aiNfiO4dozMMevwoXPQlqyjyZygXHS52fgmdIBNbKwhK0LzUWNq1P+pUnGwgpIuwHcuXcObaGwQnRz6fG/ooCGnzmLdhKeG2qvvUn+39gc46YIGozxyExZ0ZE8qvSFTcf6wNew5E4j+nyTtjxuFlu7WVnbQHvYDB4XKS4HgpKwzbur3r839ZqF0X8qDIdSbMsTwdVmIzO4KTwU7G1kGVxtzofLvUV15XqtBcTd0/qBEr3jOW4WaJww==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8936002)(47076005)(356005)(5660300002)(36756003)(81166007)(6666004)(40460700003)(2906002)(7696005)(36860700001)(82310400004)(8676002)(86362001)(316002)(70206006)(70586007)(83380400001)(26005)(2616005)(336012)(426003)(186003)(508600001)(1076003)(6916009)(107886003)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:11:44.7113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00248f24-ebc8-4bf5-9935-08d9f615a392
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5824
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Current conntrack offload implementation doesn't provide much visibility
and control over offload code. The code just schedules asynchronous
offload tasks on dedicated workqueues without regard of current queue
size even when scheduled task will only be processed after significant
delay and might be no longer needed.

Improve the debuggability situation by implementing following new
functionality:

- Sysctls for current total count of offloaded flow and
  user-configurable maximum. Capping the amount of offloaded flows can
  be useful for the allocations of hardware resources.

- Sysctls for current total of workqueue tasks for nf_ft_offload_add,
  nf_ft_offload_del and nf_ft_offload_stats queues. Also, allow setting
  maximum of total allowed concurrent 'add' tasks. This allows
  visibility for flow offload delay due to system scheduling offload
  tasks faster than driver/hardware can process them and allows setting
  some bound on the delay (for example, in case of short-lived
  connections user might prefer to skip offloading of flow that will be
  only be offloaded in 10 seconds). Note that the flow can still be
  offloaded afterwards via 'refresh' mechanism if both total hardware
  count and workqueue count are reduced below limits.

- Tracepoints in offload code. These are primary targeted to facilitate
  writing BPF helpers for some common debug scenarios (creating
  histogram of latency between scheduling flow offload and processing
  the task, dynamic difference between new offloads and deletions,
  etc.).

Vlad Buslov (8):
  net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
  netfilter: introduce total count of hw offloaded flow table entries
  netfilter: introduce max count of hw offloaded flow table entries
  netfilter: introduce total count of hw offload 'add' workqueue tasks
  netfilter: introduce max count of hw offload 'add' workqueue tasks
  netfilter: introduce total count of hw offload 'del' workqueue tasks
  netfilter: introduce total count of hw offload 'stats' wq tasks
  netfilter: flowtable: add hardware offload tracepoints

 include/net/netfilter/nf_flow_table.h       |  9 ++++
 include/net/netns/nftables.h                |  6 +++
 net/netfilter/nf_conntrack_standalone.c     | 56 +++++++++++++++++++++
 net/netfilter/nf_flow_table_core.c          | 33 +++++++++++-
 net/netfilter/nf_flow_table_offload.c       | 43 ++++++++++++----
 net/netfilter/nf_flow_table_offload_trace.h | 48 ++++++++++++++++++
 net/sched/act_ct.c                          |  5 +-
 7 files changed, 186 insertions(+), 14 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_offload_trace.h

-- 
2.31.1

