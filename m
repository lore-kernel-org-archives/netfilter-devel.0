Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0B6C47096
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE710613F0
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhFCMRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:17:48 -0400
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:59552
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229747AbhFCMRs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 08:17:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXhZAS0a9DZC6a9NBfoQhPEV5Vi/ttMZMQ9rpObRMM9Ro5UKdhON5vfr44/7iv/wu4fsCWWb9odMgcvJ8+Lmy5aXrepgTFFkAcVwZvh4O6aykImr1VdgMmZtKLCItDAJ8F8xlweW0ZOR0ZhusibcWxrxBJbpYoCsxJ6H0ec90Whtvr7AsJcqI77P98Ve5BSoxLNkraese4AmUOlRnAZHjMa0dWeetZs48aHaGVyqCpVgEUrLSWEsIto0D0broiRA6DA4JJupU70McAqcWnrZb6QlJZ514ct4ZxcIN8aWEBE/IG6HoX9xKhVxs2pFuYpvzAmPOCR2sWYrWka2V+e+OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVLRxWxMDgqrDBQVPYHx0K9bM+v8mM2saYiLb2w0hCA=;
 b=FCAGCiPphorQd7Fil/EXNMdv63PY6QkDJ8DlosQs9wB7zfYtchxMAChg0I1i+FYMMXCqf3yls2XBSLAWhxT3KXhD749HljI1P3ZOPGkJtsY86+nRROIuoYWGXT+j/pZig7dam2/v6vYuqBmDAhXsMSsVlLZ8lCDEOc/KY3aH3LSzHpRdgbrpPF7IHQS2iobCJ2HIskm/r7MOYJ5n/dYMKzUHNlWZwVe+sHf2lzD+B9v3SYoIUpcnWut5Bv0beNLWgo0ELljtAiPX0U20qmimIuTZq+VxjeDUPfZOtZZwuSXHxNrR95F/eGc9koJ33Ktu49sXtlSSQI57Sf44RNWVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVLRxWxMDgqrDBQVPYHx0K9bM+v8mM2saYiLb2w0hCA=;
 b=e07XpojZUbgdbGssE8Y5iNCIg0qG+tJSJmdyUBOGq0eFuxShgFS2to9HgcCOgkHGwVBQ1+vfGm3xiyCWFUG1qaD3CHyD/ACJXlfvLu39cyHVu9pZi44KdNMnf9uDbX3AiioiJ9S1kGBQp6LAUhAwAhWJwirbnEKvegK51R3PxUXvfSb097+BqVzydRkkD5prWdvTycy/knTLIl47m48bL42tFPGBz56T5mx3+0ZLkzsJcJL/lx32PQlumhI87aSRFIEJUGvxIBWQSL0V6HpQ/2Fbu9hN1Cyoth3UPanFOpmigWbZQlhzX1TNvqNjOiSjOBkavO/TMOQnByMJWgPIQQ==
Received: from BN8PR04CA0034.namprd04.prod.outlook.com (2603:10b6:408:70::47)
 by DM5PR12MB1242.namprd12.prod.outlook.com (2603:10b6:3:6d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Thu, 3 Jun
 2021 12:16:02 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::9d) by BN8PR04CA0034.outlook.office365.com
 (2603:10b6:408:70::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 12:16:02 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 12:16:01 +0000
Received: from c-141-149-1-005.mtl.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 12:15:59 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH nf-next 0/3] Control nf flow table timeouts
Date:   Thu, 3 Jun 2021 15:12:32 +0300
Message-ID: <20210603121235.13804-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ee83810-1509-4168-ed11-08d926895ad9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1242:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1242F91BD3A6715178728A3CA63C9@DM5PR12MB1242.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhoilVt7uNwvJ83m72B0tK32nAoCliFg4FJGuztTOaMavhymLFz4L+wfLjGEZ2zDEjLIDmtygAEP1soVAFooLu2QWVljNzjo5vWan4FKINRl2uOFlYZ4q4ZmDe875xz8h+QTogm36rViRXEVXY6qoefoP2p2O8Yf4TWkq7OsJKlHqQ66A6pms1x0GTWTsFku0xWYRAGFVGJVr4ClUZ/u3anhLLYu5cy/O13AfjkiN3Ga5hMsBqWvbH4t5MhvlbYk3pznctv5CajQGpoKlm/OBw4XfIY1a4AVYpWK3srXL5E18ejYWOCI4KpugNHjwc/4tIaVHD+KrOOhue4mkABIc39Vcg4UDVo47s3ueHFJUQdAGrjkLctDSUFuJ7niNgb9Gk2SwIYyy71CHcaSAsh/mvvuWKLRMMm6yw42oZ8Gt/CJLk/Q/u+lHXNyFUi6mYFT9WfNJss9Sw4YIrW0/wDAWiWJP8e+ZZ/67Z7PpoTL65+qHSZB7bEURSNBGE/gndc0DS+HB/A3XXUHejxJlqfDyUQ75wVWVa4uBpf2PSpRmFz5v+5yewq0WxSrQrU4cmoeE/Ydjht4qMaEiGwV15ZRBlGMXHqTtdZpsICJ9IGS+LdihsncAP6Ragsm8fNXKA3QX6QqHhX9WLGBQ5E3WPg675/MPIgECieyTFV+X9wMmFA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(82740400003)(83380400001)(316002)(8676002)(4326008)(70586007)(7636003)(478600001)(2616005)(5660300002)(47076005)(6916009)(107886003)(2906002)(336012)(36860700001)(70206006)(426003)(186003)(36756003)(1076003)(6666004)(82310400003)(54906003)(36906005)(86362001)(26005)(8936002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:16:02.4573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee83810-1509-4168-ed11-08d926895ad9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1242
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TCP and UDP connections may be offloaded from nf conntrack to nf flow table.
Offloaded connections are aged after 30 seconds of inactivity. 
Once aged, ownership is returned to conntrack with a hard coded tcp/udp
pickup time of 120/30 seconds, after which the connection may be deleted. 

The current hard-coded pickup intervals may introduce a very aggressive
aging policy. For example, offloaded tcp connections in established state
will timeout from nf conntrack after just 150 seconds of inactivity, 
instead of 5 days. In addition, the hard-coded 30 second offload timeout
period can significantly increase the hardware insertion rate requirements
in some use cases.

This patchset provides the user with the ability to configure protocol
specific offload timeout and pickup intervals via sysctl.
The first and second patches introduce the sysctl configuration for
tcp and udp protocols. The last patch modifies nf flow table aging
mechanisms to use the configured time intervals.

Oz Shlomo (3):
  netfilter: conntrack: Introduce tcp offload timeout configuration
  netfilter: conntrack: Introduce udp offload timeout configuration
  netfilter: flowtable: Set offload timeouts according to proto values

 include/net/netfilter/nf_flow_table.h   |  2 ++
 include/net/netns/conntrack.h           |  8 ++++++
 net/netfilter/nf_conntrack_proto_tcp.c  |  5 ++++
 net/netfilter/nf_conntrack_proto_udp.c  |  5 ++++
 net/netfilter/nf_conntrack_standalone.c | 46 ++++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_core.c      | 47 ++++++++++++++++++++++++++-------
 net/netfilter/nf_flow_table_offload.c   |  4 +--
 7 files changed, 105 insertions(+), 12 deletions(-)

-- 
1.8.3.1

