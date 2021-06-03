Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629C5C47082
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4630D613F0
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFCMSA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:18:00 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:50753
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229747AbhFCMR7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 08:17:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS79lZV6eS5UnC+wj2nmomsIhpMQ/u322evrJuSz2kOEG9VR7vKH+FAQQPlX/DkIJrJ1hl8o4/SOekDwGo/cJp1la7ZbOstiUGWW+2LkFPAplNNWC98n/MO6YS3LR7AKfto7wPrGyUO5RedZafSS2JlfUyc0gr4GtCdpiSxH8t72qwYrCkvxexxCyYtM7s9aNtZsdA34uXANJ7d9zlV3P75+RTUcnzn0PL0bwsz96/NxlCpMwjC0U/3g7cUkL21S9owONFnRcR5qYlOlpn5Tf1IQW4gdImMQpr0rGWYx0sSLZ3fp991yt8Qc6M1XkR3krz9jEXRnW7EjneauVIj0yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwhfG9jVJNbS5eljcZdyIK78SbYW3YFza8DsYlExlAc=;
 b=a92Cuiq0zCWRDNX+48q9RqjN6L3BSmBEyqUT8TScDlTtlx7IgoE9StHFnhEkhhaz9l/ShPYk3IEJEcUI7gztWfim+RHden+ywnRbHE5YQGjp5y/AX8VaGiEUSyVREe5cbyDIKUgChQSuBICt5MHOL6QBmW31vaBP03OLi0mcHOpfsdKzQJxaASUvsBVCaDjzgjMJqTRUf5wLN95sY3dzCsExuER4tK1RpMFiuj8KNVIYt6vg7q5tqCMQI41w2lTmiMWZF3TW/KJxx7BNSEBMZqin/4xcAA/0cMAM+ue9t+MiQZrrpck2Ke2BMjUMJB8XJnSm6ItKmSJvXG95dqp8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwhfG9jVJNbS5eljcZdyIK78SbYW3YFza8DsYlExlAc=;
 b=FjuWEGRH0w4QXNZoI+TfC+85caBjxOA0efuFmx/7hLGfndienmJM9mlfSroGba1edaTAxf66w9S+cTdGEs80hEk3fHAN0aQf9g/MYOYKAHDfmWrggZb9yTC5HhnjFzZQiIZmniudFRCMGvrlYasHqk6uOwyQzsor75xKwZwbkw/28XVOV5plFZSUskpIpPlQVLKkNe62PzAU4PD/GL8sntEYUNiXTOJtxoPGLmR+3W4fiHtqFon6dGPbkV2EZuJoOzl4fTNUfTrI7sd3Fd8/0peA/7ahMu8tHPehZ92A8vKfi5cWJ5/RpFZfDc3FLrN0aiGC8U3XNoF8YKf3JYcxQg==
Received: from BN0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:408:e5::34)
 by BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 12:16:14 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::6e) by BN0PR02CA0059.outlook.office365.com
 (2603:10b6:408:e5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 12:16:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 05:16:12 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 12:16:12 +0000
Received: from c-141-149-1-005.mtl.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:10 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH nf-next 2/3] netfilter: conntrack: Introduce udp offload timeout configuration
Date:   Thu, 3 Jun 2021 15:12:34 +0300
Message-ID: <20210603121235.13804-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210603121235.13804-1-ozsh@nvidia.com>
References: <20210603121235.13804-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eac8c1aa-1d82-43fa-72bc-08d926896180
X-MS-TrafficTypeDiagnostic: BY5PR12MB4904:
X-Microsoft-Antispam-PRVS: <BY5PR12MB490455C49E3FB8300EFD7918A63C9@BY5PR12MB4904.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nj/8Cp0/c6opNDMOGE/q2X/9ARnG/JMs4hMdK31J7xs34WxxsJ6Wf1lDhk4nAutX2Cuyhe0zWGvHmy9BVDIWe7fxVFOOkozTYVNs6ue9m3YN3ACeK7stFhRTjVAtQQdoGEOmfcOfqSWu1ys8q9YRIWou+6P/f9F20V0G9G8DEEEvloyQLONwKoAUQ+GLcpoYKQG2evYMcKx+qtQmHmTSpO/FzFjQhZ/AbgANVwO6/mE8NAkFF30fJyyYNVFR9ozH9+QeDsCdguQQ7npbpyyx91sTQ5IIQGTjsOt5/7HgluoblaYuvwup9L2jIrfStpuA4cbtuY6I0H5JemVR2XCtrXZ24R7c+ohhQCgmK3Og5im6/fZszseTo2CEycBIAymI6sxstW1/Ut26/6Curx41kWJRZrrvioho1IsIFl8U4qlTGWKKxDTIyJZSEjLFeWutNKZe9TeXM47VklSFPItlkE523LLCBfhl91i4U3IpplMFeC6OBNivFLNIxmZ9gUnrBpa4HOg01fu/2Q+VD77SeOECVtRJa8uZzks2+ZXVGQLECDVP4SK0s0h3PhGpR9OYOl1Rjis9ZmZjbXmpj+DqtQE0U3c2B0fi3STfk6nxrnl7mAeTJbaKbMhkTuC1qQTeAeKGIqveHr+gDP/pvRYq4l0izmrjHNz76OpzFJiftn0=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39830400003)(346002)(46966006)(36840700001)(6666004)(36860700001)(54906003)(83380400001)(4326008)(82310400003)(2906002)(107886003)(47076005)(508600001)(7636003)(8676002)(2616005)(186003)(1076003)(336012)(70206006)(36756003)(6916009)(356005)(5660300002)(70586007)(26005)(86362001)(8936002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:16:13.5969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eac8c1aa-1d82-43fa-72bc-08d926896180
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

UDP connections may be offloaded from nf conntrack to nf flow table.
Offloaded connections are aged after 30 seconds of inactivity.
Once aged, ownership is returned to conntrack with a hard coded pickup
time of 30 seconds, after which the connection may be deleted.
eted. The current aging intervals may be too aggressive for some users.

Provide users with the ability to control the nf flow table offload
aging and pickup time intervals via sysctl parameter as a pre-step for
configuring the nf flow table GC timeout intervals.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/conntrack.h           |  4 ++++
 net/netfilter/nf_conntrack_proto_udp.c  |  5 +++++
 net/netfilter/nf_conntrack_standalone.c | 22 ++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 3a391e27ec60..c3094b83a525 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -41,6 +41,10 @@ enum udp_conntrack {
 
 struct nf_udp_net {
 	unsigned int timeouts[UDP_CT_MAX];
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	unsigned int offload_timeout;
+	unsigned int offload_pickup;
+#endif
 };
 
 struct nf_icmp_net {
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index af402f458ee0..68911fcaa0f1 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -270,6 +270,11 @@ void nf_conntrack_udp_init_net(struct net *net)
 
 	for (i = 0; i < UDP_CT_MAX; i++)
 		un->timeouts[i] = udp_timeouts[i];
+
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	un->offload_timeout = 30 * HZ;
+	un->offload_pickup = 30 * HZ;
+#endif
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4d0c6c5e705a..7331d8316af1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -584,6 +584,10 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP,
+#endif
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
 #ifdef CONFIG_NF_CT_PROTO_SCTP
@@ -814,6 +818,20 @@ enum nf_ct_sysctl_index {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
+		.procname	= "nf_flowtable_udp_timeout",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP] = {
+		.procname	= "nf_flowtable_udp_pickup",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP] = {
 		.procname	= "nf_conntrack_icmp_timeout",
 		.maxlen		= sizeof(unsigned int),
@@ -1083,6 +1101,10 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6].data = &nf_icmpv6_pernet(net)->timeout;
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP].data = &un->timeouts[UDP_CT_UNREPLIED];
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
+	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP].data = &un->offload_pickup;
+#endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
 	nf_conntrack_standalone_init_sctp_sysctl(net, table);
-- 
1.8.3.1

