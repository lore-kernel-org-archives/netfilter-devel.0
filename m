Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F57CC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 16:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbiEQQ7e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 12:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351281AbiEQQ7d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 12:59:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C04FC69
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 09:59:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2HlniY2aty9yi3/Aq3ywBbjB+8TLA3WMfw7ZZMMQErZd8WFzgTofwjyQQvD3wJu+6EqI4Z5HIYxsw87Ahi/bVkwy4s+33QGhdD9nmrZu++rqUWZbIoqbt3P96Qv544o9Rv+6ajPYmcYkJ9obavtJw9BttNbWYXP/ZigJbj28GvvqrKikYCkvD06R2Qsoc1ThYYzu+n2KuOb2/syKjd9usbuqnG7t2zsLYZVs12NlGeM8hoNbq6rpCubDGj+qtFw6owkIaRbhfdVC2bijbJMMaS38jWaye92rELdpKB2sb+EXHXFyQxCZ4+q+1L7TDZQTiNYf7vSKxWYokwUd4k3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fd7eVJbc2kFhaEybdc1HMH1wrLZyQw8t8OSHPAzNUGU=;
 b=e7eaMzyoO2poEyvR0jtrcMimN7MEZuicXXhzM/6fX062Lp3za06SvK4OmzCaqhqMtsUS4uPisU/eqrMlPZD5kXnaG5ODLqUNGXDuXv1UXyne61Y0N1pokcKWMrgMK2W+EtlBvuEp+J+r+vDXuGCrd+AM0NDp+2nq7VXi4JyNqBGNeG5fLdrWYaDhvAJBtGcdHShWnnMxqSdAwgoZDfU5+EO95Ag9oS2qi3FkusdRtzZ2XNZv2Y/VHtr0Hd7mts7rM4pb879wTk44XandTibXiwaliCPvY1lipeT6w/DGaMK9+Fojy1qpYerSKVTetcW+1J/UU3aGApKkmyvp3G+vaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fd7eVJbc2kFhaEybdc1HMH1wrLZyQw8t8OSHPAzNUGU=;
 b=JA79HSqU4SH+hCjzaDBzXvCoK0lwDNUQoeClliN4uD9QtCAdWTWfenrjQd7FIFY6kdIXMkHrIOU5ZeO2BYNiNgnqknV8ZLX4ewQgo1A+fzNj7GJhBUsrj8RNWt/RsjAJBYW7nPQGoY+x8LXrhZwvgqtX1WpFbzQoHIUN4FkY2dZOWZVNJklKSNxFhvcrCV0ToyRjTHfJPreDE7pt+lwwFPYY5CTG5hylyD4tY1FVvXtVDzqxndjgiDwYQPSEHC75GnqoExSZQdKSlP6ryWdtuVes7FX1QKlQZewShS0cS2bob1wQCn+sP+DV8N8AiEvj5j0QKPZKc/qg7UivJ0M7nQ==
Received: from DM5PR08CA0058.namprd08.prod.outlook.com (2603:10b6:4:60::47) by
 MW2PR12MB2347.namprd12.prod.outlook.com (2603:10b6:907:7::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Tue, 17 May 2022 16:59:30 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::7f) by DM5PR08CA0058.outlook.office365.com
 (2603:10b6:4:60::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Tue, 17 May 2022 16:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Tue, 17 May 2022 16:59:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 16:59:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 09:59:27 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 17 May
 2022 09:59:26 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 0/3] Conntrack offload debuggability improvements
Date:   Tue, 17 May 2022 19:59:06 +0300
Message-ID: <20220517165909.505010-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19759a0c-0260-4697-5f9d-08da38269b72
X-MS-TrafficTypeDiagnostic: MW2PR12MB2347:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB23479659BFFA94C238D06759A0CE9@MW2PR12MB2347.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3y47KppeuKBKi+R88b9olQkZi/sN+NSBV07WPvhNDT022oimidJqFH21ZVmNFmDYKr7wgjSeFmNQDfHfJ6y4rS7irri5lUjoYU/BWJE6jJtMm0DDm+5Xe67oW6G9Ec1XC/QmjD8Vc4Z1eUXnezq86y+Zu645HT7REFz/jzVr6AWn4OOFsVXp7Kf0L6xq25SHG55zLcgWl/Xm1RNrmNohOQfCdjhNr+36gnaJnLhcaHu/Zo3hv3KhO0ruStq4Fcor5jwLBVhygwVihQDkmnfYMHbyiGYQ9Y6r4RwPLzPLIW1WzEKP39zzEhqd2hg8WHX7LyB2Oef8tl64BDN1QdIdA80TbQSv90TjqMT5IPfPpQuQXtrrT2PGHbFUnB9hWGaZ+dnsRXsknzyoZiP9/IqSC5QtEtqUlEqASuqOgrRafEYZTkceElttq5y20jdPKcRo2MMLE5AjQNT9yf96q0fDz+Ix8dIOjJ/kitALdMW1oudYqSn1MFE1l+dKd0fZFgnGINeFlE/tsjciu3aF/3YqfCGSocJKYIOEM6xJpto9psG7gLz8LQtlYJkK7TG5qLTIDUNrlGnFSlX50jhSbNdKmw/2BjN2uImAbYVsat2cp7zHNL7hm0B4R6DuX0oczrnevRVgTIKerQIugb01zRshl7gEr0Nb6yx3R8jnDl1Xv60tcHSWHCw7fFnXBihwhNgMAAWfNg9tgqDmJbSVvn8GKg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(4326008)(2906002)(186003)(6666004)(83380400001)(1076003)(36860700001)(40460700003)(356005)(8936002)(107886003)(70586007)(86362001)(508600001)(81166007)(26005)(336012)(426003)(316002)(47076005)(7696005)(70206006)(82310400005)(5660300002)(6916009)(54906003)(2616005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:59:29.2973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19759a0c-0260-4697-5f9d-08da38269b72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2347
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

 .../networking/nf_conntrack-sysctl.rst        |   9 ++
 include/net/net_namespace.h                   |   6 +
 include/net/netfilter/nf_flow_table.h         |  57 +++++++
 include/net/netns/flow_table.h                |  14 ++
 net/netfilter/Kconfig                         |   9 ++
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nf_flow_table_core.c            |  89 ++++++++++-
 net/netfilter/nf_flow_table_offload.c         |  55 ++++++-
 net/netfilter/nf_flow_table_sysctl.c          | 148 ++++++++++++++++++
 net/sched/act_ct.c                            |   5 +-
 10 files changed, 380 insertions(+), 13 deletions(-)
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c

-- 
2.31.1

