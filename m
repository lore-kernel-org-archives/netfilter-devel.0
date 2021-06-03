Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEC0C47082
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74440613F0
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFCMR4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:17:56 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:22689
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229747AbhFCMRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 08:17:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdAIrbPOEictWni9yIHg9mMZjGqh9Jfykpbh2OXeDb7X5d4E+RK0nMyFQn2lrXaDbuMKzbwyZa2HKcNqV4ClrJPQgfwKnLEt2HWm/54tMsRbTfUYWpeASv2BigGwoYgKnaeH3iqODntkcs5TQZE3yMgrGvMmSyShyXGrXQ+ddRJNXuBtIq0c+JqiWE0K6/jSz2BHdchpwkDdN3SiUbAe3yGrpV5eMXx+8SqSdlMNZUO1m+DyO2p04vhCUeWkgc0gDGWEc6hyDWBvBpUBk4tPVjScuJ8RIXPgRSZjkRNaUyqd0IlEyZY+uToDpQ3uH9PukbjF1SuiprC16Ai0nWISFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4h/FBjcm9/4+loS0l4iDd20crIoLnqpQR5Uct7nEH8=;
 b=K1xvhNvBkagN7Al30xE5rLTkaQ4b/S5VnC6lK/u2OPzmgPUtgWCXRKA0zLYCaAwbsOqE3vaa4Y1KTBD13MdV+XpYgHdr+cEzi3H+/OE17XlpwVkUdGQFj7hDI4kRjncWf7LT3CF2l61i2hJ3KTlouPnQb78b/K96CJNnTKbMzN2NzbSgEEf+QLbU8eXMSAB1ER2zAEUpM8G50mNn1LKwAxpVm6zFHF44/CqJxr8wi2jgUCDYGHEmebDf4gyCJb5Y51FDAaFtn3SlxKe8bziHQArakwUwALEUFBMEaIT3giXCrsGeDHahbVQTUthypoMYtswmoeDg9Zv+t+dlWDMe+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4h/FBjcm9/4+loS0l4iDd20crIoLnqpQR5Uct7nEH8=;
 b=jGv2tmV2OMrLZx6OPrm8mI7H4CcH2JFPhXyld3gvNjW8KyNQSKRU+RnVUCzG3WtHN2vBecjQTJGYbLO5dkLifJDDjmyB/U+RxuR7Qu6XuirqHibKRORlA6SwadnmEJhXmU21PEGUXR+mcyU0boI+6XxXEOUrVKQd1+B3zSXqZGCctLld0Gi/PXDeKjlIWJB/I+YQ9DYcBiNeo4NhCeOMaURtup+hn1PaYFXoohSq7CBIJhTiiKbSGfiLg7pMvKXQf+GcdVW2r84AzNJyVwaM2l4EdcPUpbWstLxREB1vOYTfyr4NuF6GGUXpAZtVn9SchcjAhqWtoXBi5FLR2O22iw==
Received: from CO2PR06CA0053.namprd06.prod.outlook.com (2603:10b6:104:3::11)
 by DM5PR12MB1914.namprd12.prod.outlook.com (2603:10b6:3:109::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 12:16:10 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::3b) by CO2PR06CA0053.outlook.office365.com
 (2603:10b6:104:3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 12:16:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 12:16:09 +0000
Received: from c-141-149-1-005.mtl.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:07 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH nf-next 1/3] netfilter: conntrack: Introduce tcp offload timeout configuration
Date:   Thu, 3 Jun 2021 15:12:33 +0300
Message-ID: <20210603121235.13804-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210603121235.13804-1-ozsh@nvidia.com>
References: <20210603121235.13804-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6608342-353e-46e1-cfa8-08d926895f71
X-MS-TrafficTypeDiagnostic: DM5PR12MB1914:
X-Microsoft-Antispam-PRVS: <DM5PR12MB19146A867678D6BA40146827A63C9@DM5PR12MB1914.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DZpNAXs4ca+7S5eVjSEb8Q9nQ1XbqGVGkUky05B9gSAzol+Rt9Z8p0JsGU5P3vm0S2C9nSthN5jFAuZH+cfc3eVOMkhIaR3/ZykBIGLLFNTjGbiOHkJtrZWkmPoWwnMeDh4TEyyVCINQ41X/BYaCsrkRq3G04IHOYrmf14Esy35HsDojzo9LtRTj+BJOOw9fyzuV30RVkNLmAThBLPsflHZoUhvP0H7ErXBZk7RI5dpY16zmackubTDVCMCXJdwWmwh8GKnjpkTBf8+cC47Mx+Cz+NNx+sNebOR7Q2k/S89NzIQUZsuB9n1XeZ06s+JaKyPw3+z/IwnYbEcvbbimitBcMMg+T7TSteSusqrbRVlS7frcuAmX5IMJQh7M9yf4G7mJiSUJ6Ys4OqgWnHjVi9FsXBSW9L8HADmzGUwQeRy38krGmS/LBH9fSKlPhAG9Z140TacTpLZP1ziveyaMCt9sufwIxV+2CUUq2HkwPbAF7tqhbSdm//mUnq9XW0dDtw44T2M+3l3Jl1sHJvU3lFMyOiP6e9PLFDbucBCTbtP/SQBdRS1pcdkT5BkNmfsYSEtr7eYmIaovJJY6juMTx+gVSk85/7GWBowBkuPnOuFXKhrFkc1s2KdtV8MkFNcCgR6YyQ+iqmJ6ChRWJ/2ul7KAAyRR8cnuNU5OtsvA5w=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(82310400003)(478600001)(186003)(8676002)(6666004)(26005)(36906005)(83380400001)(36860700001)(107886003)(316002)(426003)(47076005)(36756003)(6916009)(2616005)(2906002)(86362001)(1076003)(336012)(70586007)(5660300002)(82740400003)(4326008)(7636003)(70206006)(54906003)(8936002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:16:10.2225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6608342-353e-46e1-cfa8-08d926895f71
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1914
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TCP connections may be offloaded from nf conntrack to nf flow table.
Offloaded connections are aged after 30 seconds of inactivity.
Once aged, ownership is returned to conntrack with a hard coded pickup
time of 120 seconds, after which the connection may be deleted.
eted. The current aging intervals may be too aggressive for some users.

Provide users with the ability to control the nf flow table offload
aging and pickup time intervals via sysctl parameter as a pre-step for
configuring the nf flow table GC timeout intervals.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/conntrack.h           |  4 ++++
 net/netfilter/nf_conntrack_proto_tcp.c  |  5 +++++
 net/netfilter/nf_conntrack_standalone.c | 24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index ad0a95c2335e..3a391e27ec60 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -27,6 +27,10 @@ struct nf_tcp_net {
 	u8 tcp_loose;
 	u8 tcp_be_liberal;
 	u8 tcp_max_retrans;
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	unsigned int offload_timeout;
+	unsigned int offload_pickup;
+#endif
 };
 
 enum udp_conntrack {
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 34e22416a721..de840fc41a2e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1441,6 +1441,11 @@ void nf_conntrack_tcp_init_net(struct net *net)
 	 * will be started.
 	 */
 	tn->tcp_max_retrans = 3;
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	tn->offload_timeout = 30 * HZ;
+	tn->offload_pickup = 120 * HZ;
+#endif
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index aaa55246d0ca..4d0c6c5e705a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -575,6 +575,10 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_CLOSE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP,
+#endif
 	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
 	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
@@ -762,6 +766,20 @@ enum nf_ct_sysctl_index {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD] = {
+		.procname	= "nf_flowtable_tcp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP] = {
+		.procname	= "nf_flowtable_tcp_pickup",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
 		.procname	= "nf_conntrack_tcp_loose",
 		.maxlen		= sizeof(u8),
@@ -971,6 +989,12 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
 	XASSIGN(LIBERAL, &tn->tcp_be_liberal);
 	XASSIGN(MAX_RETRANS, &tn->tcp_max_retrans);
 #undef XASSIGN
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD].data = &tn->offload_timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP].data = &tn->offload_pickup;
+#endif
+
 }
 
 static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
-- 
1.8.3.1

