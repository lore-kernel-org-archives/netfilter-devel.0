Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FB5C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 19:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345305AbiEPTLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 15:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiEPTLb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 15:11:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A612B242
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 12:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0skd+gyMDkYlWsMhoKQccgMR6G+wONmxUSWaT5E7XLtIsm1u6c7qBYPBH9xW75nqAISv5PfQUnZAcZbDELKOtaGLg2jlWDrheUg3K8oJPD6oQpWD7TyEg7iKTLGdJG6rq1k0JbNvlT8eIkKMdYCNhEE298lqSgiWNfhsxQKBdTjDS5xM4vZf2R0WYzOruQlCitdZ87Us67unueEw2UagOVnio8hMMc4KQEe/QGQhBlk7MvITCg1dyrl0cD8V9MJuq8BBCXa4GVoIicn47IjiJp3hd0OkBWYLEq+oxNEx3O6TNqBmoDfzwqTO+/Sy0fO9fTfnGhsA/lfZR39iJFG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giEjGIb2uxzH1akldeDlwLRazfMPcolUji4Okbul/iM=;
 b=AhwIPJZRHmCewArWEoaEnAOK7e5oV1tbSDTv8HNI/4p0vxc/emAU7ZK1e8xrZmEJj0GRrAFtvV2cn+rhHz55xePuslPqoroH+Ow82MeTjMjZTeUY8mQvOoz4mw/nOprsePHOiaUMRFp3+G5Xd0ta0VrYn4iDEKu1LglckiH+w64TVeoekhlindMBZld6mtnQZwYZmM9V8mWonfL7Nl8eLan/DL8+BROKQ5llgd9uYpsDxa14tVn76PkzLWWZTblQPD6PFPtp4zkbiQVHMQz6MZyWzv5XoKKSuL+mLGSfJjoPNahJvDQGqP5iSYhPRj7lBajV6kDXcPXj418khWLtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giEjGIb2uxzH1akldeDlwLRazfMPcolUji4Okbul/iM=;
 b=ubIYLoyAuK+SWz9ko5L56M5BsaEU+wRiOnfUyLIZuSp9x6OGsmi1uMIOnJpidrtLWaNoZP5HbdaTyGpt4xrIjOIJI2nZWC5b+T06RCcqQJpCmRJVH34QYbP5eIvGx7R1n5TiRw93hHaFayNMYwoKwoKDj03Gfjvvzz0aG8UazAT1nM8k1T+Egj4M6E+evE4ae5N9TgMQFVvukOkV1Vgc2wSTv84Nc2YkK/QHfQXuVCACNgJDrXLarVUjRqsepyydaMtHf2MNqsIIVL1UNAiWxl+10cc2Ei8aTZUtWkm3vrpJlWuNCWEcybZX/3e9X7UoLiVXzV8mPJeLH4gijTfbLQ==
Received: from BN0PR07CA0016.namprd07.prod.outlook.com (2603:10b6:408:141::21)
 by MN2PR12MB4534.namprd12.prod.outlook.com (2603:10b6:208:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 19:11:28 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::c3) by BN0PR07CA0016.outlook.office365.com
 (2603:10b6:408:141::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Mon, 16 May 2022 19:11:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 19:11:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 16 May 2022 19:10:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 16 May 2022 12:10:57 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 16 May 2022 12:10:56 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 3/3] netfilter: nf_flow_table: count pending offload workqueue tasks
Date:   Mon, 16 May 2022 22:10:32 +0300
Message-ID: <20220516191032.340243-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220516191032.340243-1-vladbu@nvidia.com>
References: <20220516191032.340243-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fd077bb-2a89-4fea-4760-08da376fe12e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4534:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB45347AF008B96A1E99AEC9AEA0CF9@MN2PR12MB4534.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pulsBVtf9CQBr9hig4ICl+KLYaTqZ6iQN6nDUoaQlxt4n7KcrY1QcYIW7/qYlBpTunTAu+8hznGCqGeNBtntSCfWTzS+h/bwJSHEFMqmlcpzh8k3E1IvUZgHlD64b2hl+wpsOqtAXb55KKoy71bfK/K4SNEOas5j+g5KfCmzw4ZkvCi/PHXVe2hL5UERrrjTnNzJMVA1Hnp7IOFqSHeQPAEQeE4sZB8IL3GYgfsgqpQtkvpxcnNh02X216Is1i1cVLa8e3quLx0xzMPR9+qorSERW8syuMAZ2yXguk4ZQdFN55qoL1kFBbMxKRK5vepj8mJtlczrjsxWXD2TdwrOpb69JAQ3hPBOIqNLP/czr6+yL190re7zeKZzqyezPXwRwd3R+I+WiWyv5/qZ2dRbo7/UNwhd04+AyeOWj4Eklb4gS4VBiwJji8rUmWzxgRO7CiJS/4ccHvCrMcAX56JhmgIKeE3CRVFtOspY6f2TUYHGmVz3DFfIXPODhnwvTFyYQB6OnrFtuVoftoi9n0LbHMV5tAcR/v6AD5j8plxMRubb8Y9I9ikedLGLPLc++hHuaJM1Dn1UC+kOKxKJxND8eXRHKgnJQIZIduL9F5bIJeCO8K08LYh2NQ61YCZKy783w0L9wbO8CWY9NMDdkGJGDOXGPVEIgfccXBVyYU5Y5tJqm6x9zLoOamqggDBGeHfbopuiVlJuE/T3n3PP8wHcvg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(26005)(4326008)(8676002)(70586007)(70206006)(86362001)(508600001)(8936002)(1076003)(7696005)(356005)(186003)(336012)(6916009)(5660300002)(36860700001)(2906002)(6666004)(2616005)(316002)(107886003)(83380400001)(36756003)(47076005)(426003)(82310400005)(40460700003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 19:11:28.3431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd077bb-2a89-4fea-4760-08da376fe12e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4534
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability count pending 'add', 'del' and
'stats' flow_table offload workqueue tasks. Counters are incremented before
scheduling new task and decremented when workqueue handler finishes
executing. These counters allow user to diagnose congestion on hardware
offload workqueues that can happen when either CPU is starved and workqueue
jobs are executed at lower rate than new ones are added or when
hardware/driver can't keep up with the rate.

Implement the described counters as percpu counters inside new struct
netns_ft which is stored inside struct net. Expose them via new procfs file
'/proc/net/stats/nf_flowtable' that is similar to existing 'nf_conntrack'
file.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---

Notes:
    Changes V1 -> V2:
    
    - Combine patches that expose add, del, stats tasks.
    
    - Use percpu stats to count pending workqueue tasks instead of atomics.
    
    - Expose the stats via /proc/net/stats/nf_flowtable file instead of
    sysctls.

 include/net/net_namespace.h           |  6 ++
 include/net/netfilter/nf_flow_table.h | 10 +++
 include/net/netns/flow_table.h        | 14 +++++
 net/netfilter/Kconfig                 |  8 +++
 net/netfilter/nf_flow_table_core.c    | 38 +++++++++++-
 net/netfilter/nf_flow_table_offload.c | 17 +++++-
 net/netfilter/nf_flow_table_sysctl.c  | 88 +++++++++++++++++++++++++++
 7 files changed, 176 insertions(+), 5 deletions(-)
 create mode 100644 include/net/netns/flow_table.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c4f5601f6e32..bf770c13e19b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -26,6 +26,9 @@
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #include <net/netns/conntrack.h>
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+#include <net/netns/flow_table.h>
+#endif
 #include <net/netns/nftables.h>
 #include <net/netns/xfrm.h>
 #include <net/netns/mpls.h>
@@ -140,6 +143,9 @@ struct net {
 #if defined(CONFIG_NF_TABLES) || defined(CONFIG_NF_TABLES_MODULE)
 	struct netns_nftables	nft;
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	struct netns_ft ft;
+#endif
 #endif
 #ifdef CONFIG_WEXT_CORE
 	struct sk_buff_head	wext_nlevents;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e09c29fa034e..94606c04b6fe 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -360,4 +360,14 @@ static inline struct nf_ft_net *nf_ft_pernet_get(struct nf_flowtable *flow_table
 int nf_flow_table_init_sysctl(struct net *net);
 void nf_flow_table_fini_sysctl(struct net *net);
 
+#define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
+	this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count)	\
+	this_cpu_dec((net)->ft.stat->count)
+
+int nf_flow_table_init_proc(struct net *net);
+void nf_flow_table_fini_proc(struct net *net);
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
new file mode 100644
index 000000000000..1c5fc657e267
--- /dev/null
+++ b/include/net/netns/flow_table.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NETNS_FLOW_TABLE_H
+#define __NETNS_FLOW_TABLE_H
+
+struct nf_flow_table_stat {
+	unsigned int count_wq_add;
+	unsigned int count_wq_del;
+	unsigned int count_wq_stats;
+};
+
+struct netns_ft {
+	struct nf_flow_table_stat __percpu *stat;
+};
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ddc54b6d18ee..c8fc5c7ef04a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -734,6 +734,14 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_PROCFS
+	bool "Supply flow table statistics in procfs"
+	default y
+	depends on PROC_FS
+	help
+	  This option enables for the flow table offload statistics
+	  to be shown in procfs under net/netfilter/nf_flowtable.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e2598f98017c..c86dd627ef42 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -662,17 +662,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+static int nf_flow_table_init_net(struct net *net)
+{
+	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
+	return net->ft.stat ? 0 : -ENOMEM;
+}
+
+static void nf_flow_table_fini_net(struct net *net)
+{
+	free_percpu(net->ft.stat);
+}
+
 static int nf_flow_table_pernet_init(struct net *net)
 {
-	return nf_flow_table_init_sysctl(net);
+	int ret;
+
+	ret = nf_flow_table_init_net(net);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_flow_table_init_sysctl(net);
+	if (ret < 0)
+		goto out_sysctl;
+
+	ret = nf_flow_table_init_proc(net);
+	if (ret < 0)
+		goto out_proc;
+
+	return 0;
+
+out_proc:
+	nf_flow_table_fini_sysctl(net);
+out_sysctl:
+	nf_flow_table_fini_net(net);
+	return ret;
 }
 
 static void nf_flow_table_pernet_exit(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	list_for_each_entry(net, net_exit_list, exit_list)
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		nf_flow_table_fini_proc(net);
 		nf_flow_table_fini_sysctl(net);
+		nf_flow_table_fini_net(net);
+	}
 }
 
 unsigned int nf_ft_net_id __read_mostly;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a6e763901eb9..381bd598a16f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -993,17 +993,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload;
+	struct net *net;
 
 	offload = container_of(work, struct flow_offload_work, work);
+	net = read_pnet(&offload->flowtable->net);
 	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_add);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_del);
 			break;
 		case FLOW_CLS_STATS:
 			flow_offload_work_stats(offload);
+			NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count_wq_stats);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1015,12 +1020,18 @@ static void flow_offload_work_handler(struct work_struct *work)
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	if (offload->cmd == FLOW_CLS_REPLACE)
+	struct net *net = read_pnet(&offload->flowtable->net);
+
+	if (offload->cmd == FLOW_CLS_REPLACE) {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
-	else if (offload->cmd == FLOW_CLS_DESTROY)
+	} else if (offload->cmd == FLOW_CLS_DESTROY) {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
-	else
+	} else {
+		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
+	}
 }
 
 static struct flow_offload_work *
diff --git a/net/netfilter/nf_flow_table_sysctl.c b/net/netfilter/nf_flow_table_sysctl.c
index ce8c0a2c4bdb..2aefd7542527 100644
--- a/net/netfilter/nf_flow_table_sysctl.c
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -1,7 +1,95 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
+#include <linux/proc_fs.h>
 #include <net/netfilter/nf_flow_table.h>
 
+#ifdef CONFIG_NF_FLOW_TABLE_PROCFS
+static void *nf_flow_table_cpu_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+	int cpu;
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	for (cpu = *pos - 1; cpu < nr_cpu_ids; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu + 1;
+		return per_cpu_ptr(net->ft.stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void *nf_flow_table_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+	int cpu;
+
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu + 1;
+		return per_cpu_ptr(net->ft.stat, cpu);
+	}
+	(*pos)++;
+	return NULL;
+}
+
+static void nf_flow_table_cpu_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int nf_flow_table_cpu_seq_show(struct seq_file *seq, void *v)
+{
+	const struct nf_flow_table_stat *st = v;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "wq_add   wq_del   wq_stats\n");
+		return 0;
+	}
+
+	seq_printf(seq, "%8d %8d %8d\n",
+		   st->count_wq_add,
+		   st->count_wq_del,
+		   st->count_wq_stats
+		);
+	return 0;
+}
+
+static const struct seq_operations nf_flow_table_cpu_seq_ops = {
+	.start	= nf_flow_table_cpu_seq_start,
+	.next	= nf_flow_table_cpu_seq_next,
+	.stop	= nf_flow_table_cpu_seq_stop,
+	.show	= nf_flow_table_cpu_seq_show,
+};
+
+int nf_flow_table_init_proc(struct net *net)
+{
+	struct proc_dir_entry *pde;
+
+	pde = proc_create_net("nf_flowtable", 0444, net->proc_net_stat,
+			      &nf_flow_table_cpu_seq_ops,
+			      sizeof(struct seq_net_private));
+	return pde ? 0 : -ENOMEM;
+}
+
+void nf_flow_table_fini_proc(struct net *net)
+{
+	remove_proc_entry("nf_flowtable", net->proc_net_stat);
+}
+#else
+int nf_flow_table_init_proc(struct net *net)
+{
+	return 0;
+}
+
+void nf_flow_table_fini_proc(struct net *net)
+{
+}
+#endif /* CONFIG_NF_FLOW_TABLE_PROCFS */
+
 unsigned int nf_ft_hw_max __read_mostly;
 
 #ifdef CONFIG_SYSCTL
-- 
2.31.1

