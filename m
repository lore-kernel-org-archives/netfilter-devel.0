Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6829C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiBVPLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiBVPLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:32 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17CB117CA8
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYCgu3I7uVL1GPBR4bcGW8VKRqf6uYa5dCDW24Crj9j9ejdS0g2OD9oxd3uAPRI3T0hf5W6OEBMPwsWXQX8smYjZfSyEHMC4tySSsb420KaJybO4utYbSXmygdhmu4BnWJZ7guOrkSDOimJHC1so5hv8pNLbUjUq8GSqrwn9kyMhDmHTfVRJ5pcn54ULJKP/aBeBl8+QNKNjhExWAjPU/5hdclFrWwLVT63WH2tANmnJDE+BIqbjAud+rcUAI+oahxSTUfAPWoTJUec/sGKG8Z55jeSAqSCBnPiwo34t/04Yy0PqUklhs8LkRz+eYc/Q9k30BN15z5us7IGuRq8nOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHErdA3lYezE3YeCWYllp3Qxa2aWt1F8qoVcxtbwV9s=;
 b=b+hlHkGZro3ROZZO7LJWi3h7W16pv9ZCETamU6udK/Wf1qIJWNXZwR9pn46Lq4wrPhtxfdNhokA8r6wINeYuBOkomnW/56tXOR16ldZNgnynO9Jlvjg97BGc+mmG/oaQNRG4V5RAB6KxvHFPWMIG5RbEmuNf9F3hLV3QKZPxBT8klsI2ucrMJuXTPLe64sSG2/hQFiGkVftEK4cxXcHX7h7AIvfzad5K8QkNuWhLbbqo/i2TZcBqPJYVsZhPrStekY3dEgG4mRIucArAtpebVaatQPN/ia7JJ0jgpe2O9S7I8WewrDssuYOL3Fy4kxyI+e5wTNDbDgMZjMKJTi1Kyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHErdA3lYezE3YeCWYllp3Qxa2aWt1F8qoVcxtbwV9s=;
 b=epmrkDYYSeLlmVLTxbX0K8VrXvWIggLKVOegFX29VNNgiPJyTc53/LliWLIC+CiBjCaSjB2gLXQDPrBVWeEdf9BwZQT9ODY2G61cCMDhxfSQ6uj/JWlLshLLZetpFfaVXdGmBaA4Yu6inxquVLBE5FPW0zK59jE5U9CeDF1lTZEhpQg4fPkYvHZQP9dJZdVjk/womAV/SQb+OEJE88N0jqOj79GZwU94lPJrwU3e4hD+HhoPlQg0H3qHz3+DyoC9Ov51BHqbK8yPQcG0nGlxDF4SqegCMUm8+KhQMeJ+7lHtvOWWgMFGdrmZXxeEet4Rzx12oL7D8YqPJ6d9KKKI4g==
Received: from DM6PR07CA0124.namprd07.prod.outlook.com (2603:10b6:5:330::34)
 by SN1PR12MB2526.namprd12.prod.outlook.com (2603:10b6:802:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Tue, 22 Feb
 2022 15:11:04 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::72) by DM6PR07CA0124.outlook.office365.com
 (2603:10b6:5:330::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 22 Feb 2022 15:11:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.20 via Frontend Transport; Tue, 22 Feb 2022 15:11:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:11:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:11:01 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:59 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 8/8] netfilter: flowtable: add hardware offload tracepoints
Date:   Tue, 22 Feb 2022 17:10:03 +0200
Message-ID: <20220222151003.2136934-9-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4100ae18-2786-4518-3f93-08d9f6158a9f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2526:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2526D7AB3262EF83E58EC064A03B9@SN1PR12MB2526.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LO0w0GvEFwH/LUfYYS5zyEcWXp7mHzPZ92Vsa5XTOOUmrJ6BDJM71eaMWKLrScKh59KZrx+cZyM44X8y8GRCj8xExT9ODP1p7dy8rbIIqvxHVGLhcYuC/aZYQLZrvL5afHuB9WNL0BfJjdnexM6qnhOaAD64iDNuPDfb/My+f9cfIy2aAAhj8s29npZNrtPqoFsmYk5NSfml07i0OK00ttupOfUJsEz3pKVBaQw6pP6FVGN+ZSfuOAJQpM9GOQfFUGWHbz3ZtkH3hmzQv+mKQMW8SB4l4IRWrpByger5jkPMeAKezr+XmP8Hq1Dw0h37YAKuNTjzFsvsgXHm6khl99KhQkLzy6nTEbgkl/VU93Dj5rWOGDVnfO52LhRV8p7WlnZO2CG+O7mo7W7IoQkvjj+wS3oQY4m1dmYDn+xgcORaVsgDTuaLp93a1fD9V5No79HR0N3RU7S+T9jYj11ZDTSVLIuJIY87pr+KThPslc4ofsqs6ufBCz9sxKtusUIE2UkrNltW/2S687cUJnFQXMKVi1x3AkvfIFyYHGDE+qqwB0vMf2feN5XT2E4lCSAEM17JQWDBBvVSaBEecNIZGYVeHwvcRGadvMBXa+cqWat9v6GJOIDcALAURnhdr5dYLUBOLDjYc7RmjKJux3peiSppalhYDvsd9p7CnENObY5L6Ii3g386icqb0ljCF/MBxr1fgDoYPRfGJklnda5jAg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36756003)(8936002)(2906002)(6666004)(107886003)(1076003)(426003)(26005)(86362001)(186003)(70586007)(4326008)(336012)(8676002)(7696005)(70206006)(81166007)(82310400004)(356005)(5660300002)(2616005)(508600001)(47076005)(83380400001)(36860700001)(316002)(40460700003)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:11:02.8355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4100ae18-2786-4518-3f93-08d9f6158a9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2526
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add tracepoints to trace creation and start of execution of flowtable
hardware offload 'add', 'del' and 'stats' tasks. Move struct
flow_offload_work from source into header file to allow access to structure
fields from tracepoint code.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h       |  9 ++++
 net/netfilter/nf_flow_table_offload.c       | 20 +++++----
 net/netfilter/nf_flow_table_offload_trace.h | 48 +++++++++++++++++++++
 3 files changed, 68 insertions(+), 9 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_offload_trace.h

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..5e2aef34acaa 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -174,6 +174,15 @@ struct flow_offload {
 	struct rcu_head				rcu_head;
 };
 
+struct flow_offload_work {
+	struct list_head list;
+	enum flow_cls_command cmd;
+	int priority;
+	struct nf_flowtable *flowtable;
+	struct flow_offload *flow;
+	struct work_struct work;
+};
+
 #define NF_FLOW_TIMEOUT (30 * HZ)
 #define nf_flowtable_time_stamp	(u32)jiffies
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ff52d903aad9..bf94050d5b54 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -12,20 +12,13 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#define CREATE_TRACE_POINTS
+#include "nf_flow_table_offload_trace.h"
 
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
 
-struct flow_offload_work {
-	struct list_head	list;
-	enum flow_cls_command	cmd;
-	int			priority;
-	struct nf_flowtable	*flowtable;
-	struct flow_offload	*flow;
-	struct work_struct	work;
-};
-
 #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
 	(__match)->dissector.offset[__type] =		\
 		offsetof(struct nf_flow_key, __field)
@@ -895,6 +888,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
 	int err;
 
+	trace_flow_offload_work_add(offload);
+
 	err = nf_flow_offload_alloc(offload, flow_rule);
 	if (err < 0)
 		return;
@@ -911,6 +906,8 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
+	trace_flow_offload_work_del(offload);
+
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
@@ -931,6 +928,8 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
 	u64 lastused;
 
+	trace_flow_offload_work_stats(offload);
+
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
 
@@ -1034,6 +1033,7 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 		return;
 	}
 
+	trace_flow_offload_add(offload);
 	flow_offload_queue_work(offload);
 }
 
@@ -1048,6 +1048,7 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
 		return;
 
 	atomic_inc(&net->nft.count_wq_del);
+	trace_flow_offload_del(offload);
 	set_bit(NF_FLOW_HW_DYING, &flow->flags);
 	flow_offload_queue_work(offload);
 }
@@ -1068,6 +1069,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 		return;
 
 	atomic_inc(&net->nft.count_wq_stats);
+	trace_flow_offload_stats(offload);
 	flow_offload_queue_work(offload);
 }
 
diff --git a/net/netfilter/nf_flow_table_offload_trace.h b/net/netfilter/nf_flow_table_offload_trace.h
new file mode 100644
index 000000000000..49cfbc2ec35d
--- /dev/null
+++ b/net/netfilter/nf_flow_table_offload_trace.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nf
+
+#if !defined(_NF_FLOW_TABLE_OFFLOAD_TRACE_) || defined(TRACE_HEADER_MULTI_READ)
+#define _NF_FLOW_TABLE_OFFLOAD_TRACE_
+
+#include <linux/tracepoint.h>
+#include <net/netfilter/nf_tables.h>
+
+DECLARE_EVENT_CLASS(
+	nf_flow_offload_work_template,
+	TP_PROTO(struct flow_offload_work *w),
+	TP_ARGS(w),
+	TP_STRUCT__entry(
+		__field(void *, work)
+		__field(void *, flowtable)
+		__field(void *, flow)
+	),
+	TP_fast_assign(
+		__entry->work = w;
+		__entry->flowtable = w->flowtable;
+		__entry->flow = w->flow;
+	),
+	TP_printk("work=%p flowtable=%p flow=%p",
+		  __entry->work, __entry->flowtable, __entry->flow)
+);
+
+#define DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(name)				\
+	DEFINE_EVENT(nf_flow_offload_work_template, name,		\
+		     TP_PROTO(struct flow_offload_work *w), TP_ARGS(w))
+
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_add);
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_add);
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_del);
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_del);
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_stats);
+DEFINE_NF_FLOW_OFFLOAD_WORK_EVENT(flow_offload_work_stats);
+
+#endif
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../net/netfilter
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE nf_flow_table_offload_trace
+#include <trace/define_trace.h>
-- 
2.31.1

