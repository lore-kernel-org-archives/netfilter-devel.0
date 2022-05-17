Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4ECC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 16:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351281AbiEQQ7m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351284AbiEQQ7l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 12:59:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0D54FC69
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 09:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR2ibEZCVn8xOYX7J98QPt8QPJGu3uybqy1yRDrva+xEQp/p5CT9c6gSR2KloJLdope0qBKf/fw3acefxvwkW0sa9I6JbKONeMxvqenEI49jY4YJUkMjns/1Kq+WUhYcCsLg3qCt9cN3r4EMZlg/JiU/SDsj7rg9+a5dTd+HR/5FBbPXJLJPRubGWuskPwtuW7OYi37MwtbRqw3D3ZmK7yondiWJxJJO5sePHN84DiGaeTAEyLDZ/0lFB/r6hz2MTn8ne/V+TNLIeBIztILBQ+ggI3i2lpAYTlJpAx0hCbBZYoVSy4HZAvubUyZ8jLmGk97T2bwJ126It2AvsK/HRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6WIvAShkdWEVRjxyf0vz6ccFWKyE+goL+u4Ubm+v0s=;
 b=H73hOxyuRDExAki/6tN+cTQ2UUnfUdY4oL7prPZDNqImSSqbK8rZqKMH9VtXJK5ecqQPoYmlhF058D6hf8FGrJ1c68CyUVBjCdKMrnrLLmfdIrRfETfHqRJQGtxM08dwEVa9wu9nZj0pnj8TX3pDcytE27xdTOdHFnd2Mzt4w4vGR2W14ArBlziFMjfQs9tNsSbqCKm05GEJvv1HKJoupZN322jDU4CbhIyHvFtUgwuwMuh5QPFcGRvDXggvyHwiNuJiUW4c9936JiGRQX5MlurRAngSjO9nij21XnAS0eLQd3UanjBpYML7ReZdlKhjRw6343cA8zupebseGxkPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6WIvAShkdWEVRjxyf0vz6ccFWKyE+goL+u4Ubm+v0s=;
 b=jmhIkHKpbg07vBqRJz508S9vIP4Icb+cLWboKvrJLqdVjNO/MIHeDnvaWnkdSpyM1iVX9mCBpnQMKXM6dV3EM9L9HXk28d5XRCGs3KZON3mVcaRXfzjymsiPjJWC3whJ23VxNx4TE5gddj918fIXT/Xb7Bnh6pfKxEPuPcIS2cgtX5GhA69eEzPTo7lIi/+SYl/BeAC9zuEFjPcOH90X43f7QZJCwnX0N06JMkW3yKi0f6RXg5eUiYxymQTyyOjpKM9YaH8JhDYK05zLz0wCV8iZI+L6CzeC+4RZWYLqBDxjLJzgzWSKXdrSwEDRGjHHE2KXvqhJ2bfN7Ori7PBbsQ==
Received: from BN9PR03CA0170.namprd03.prod.outlook.com (2603:10b6:408:f4::25)
 by DM5PR12MB1914.namprd12.prod.outlook.com (2603:10b6:3:109::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 17 May
 2022 16:59:37 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::8b) by BN9PR03CA0170.outlook.office365.com
 (2603:10b6:408:f4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 16:59:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Tue, 17 May 2022 16:59:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 16:59:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 09:59:35 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 17 May
 2022 09:59:33 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 3/3] netfilter: nf_flow_table: count pending offload workqueue tasks
Date:   Tue, 17 May 2022 19:59:09 +0300
Message-ID: <20220517165909.505010-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220517165909.505010-1-vladbu@nvidia.com>
References: <20220517165909.505010-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 369a3a15-c116-4407-cbdc-08da3826a007
X-MS-TrafficTypeDiagnostic: DM5PR12MB1914:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB191451DF3AC470FDFEBE02ABA0CE9@DM5PR12MB1914.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w8Aj8tRPd5L0UdXQLDzg6Oo1Yw1pe/5fhxYKh+V0y1a46oiGTi4q1UFZJauVgLurbgUoQ7eNtXm+vM9U0Z/c8+P8oILaWbAKtMSEsV6AMLw+y1nOpwIDpUtId11XCUuYJcFm92W1noqVho6kAhHmx4MiDmDfPTLVkvszNZT2vDaD7Ns1TVtmQPFcADTkZvIUO9WEmSNaIbp2i2oqt6Tq8a8J0NU10Xd82zFQby1e5vDNVEOsXYtfEbW+0lHO1kABcrsL7HHomrOFinOC1vYTO+O5tC5NOUxyPB/+Ph8tq/ruD4zdwgU0mWZj0C+6yOjouJ4zidttj6Ykx+geSYZRqJd2RBILLW8CBzpQxonc+yOtaQXgy4cWlGYXbtUmXLjlYwmoRWBNCrzTTvrnamhLqvLp1uNds0cs/XeOTnGzZAr1lv9oSsKC6wLoaSxiEDvaKkLD5ZAi2N7I78vhJagRHzrYw996oNtFfWaK0Ykm1MupPX5Hg+rGjfe5lE5GoAXgZgMZd5VBjPUbx0IX5a+H4/OwX+gGRBMKoaywEkyLMyRAHOm1pjl49NGU7ctxA380kZHuDK8Y2Ki51Ls/OQkdAnUszPDjsxlr26c/lG9ggpJYGGMgBYjRD7seXJ7MQdGZyhKzPzWj+lQ1XHpKYXzhkgiXcfNKDFVeICjxKVUyC651g+karbSZNFJThc7cbtx6CDRIlSMUwf6jRQLSP8poyg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(508600001)(7696005)(70206006)(316002)(54906003)(6916009)(40460700003)(6666004)(81166007)(8676002)(86362001)(4326008)(356005)(26005)(5660300002)(186003)(36860700001)(336012)(426003)(47076005)(82310400005)(1076003)(8936002)(107886003)(2616005)(36756003)(70586007)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:59:36.8624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 369a3a15-c116-4407-cbdc-08da3826a007
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1914
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
    Changes V2 -> V3:
    
    - Add CONFIG_NF_FLOW_TABLE_PROCFS dependency on SYSCTL.
    
    - Move dummy definitions of nf_flow_table_{init|fini}_proc() from source to
    nf_flow_table.h file in order to not break compilation when CONFIG_SYSCTL
    is disabled.
    
    Changes V1 -> V2:
    
    - Combine patches that expose add, del, stats tasks.
    
    - Use percpu stats to count pending workqueue tasks instead of atomics.
    
    - Expose the stats via /proc/net/stats/nf_flowtable file instead of
    sysctls.

 include/net/net_namespace.h           |  6 ++
 include/net/netfilter/nf_flow_table.h | 21 +++++++
 include/net/netns/flow_table.h        | 14 +++++
 net/netfilter/Kconfig                 |  9 +++
 net/netfilter/nf_flow_table_core.c    | 38 ++++++++++++-
 net/netfilter/nf_flow_table_offload.c | 17 +++++-
 net/netfilter/nf_flow_table_sysctl.c  | 79 +++++++++++++++++++++++++++
 7 files changed, 179 insertions(+), 5 deletions(-)
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
index 9709f984fba2..e6d63228efd4 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -371,4 +371,25 @@ static inline void nf_flow_table_fini_sysctl(struct net *net)
 }
 #endif /* CONFIG_SYSCTL */
 
+#define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
+	this_cpu_inc((net)->ft.stat->count)
+#define NF_FLOW_TABLE_STAT_DEC_ATOMIC(net, count)	\
+	this_cpu_dec((net)->ft.stat->count)
+
+#ifdef CONFIG_NF_FLOW_TABLE_PROCFS
+int nf_flow_table_init_proc(struct net *net);
+void nf_flow_table_fini_proc(struct net *net);
+#else
+static inline int nf_flow_table_init_proc(struct net *net)
+{
+	return 0;
+}
+
+static inline void nf_flow_table_fini_proc(struct net *net)
+{
+}
+#endif /* CONFIG_NF_FLOW_TABLE_PROCFS */
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
index ddc54b6d18ee..df6abbfe0079 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -734,6 +734,15 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_PROCFS
+	bool "Supply flow table statistics in procfs"
+	default y
+	depends on PROC_FS
+	depends on SYSCTL
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
index 5c7146eb646a..074322c1176f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -995,17 +995,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
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
@@ -1017,12 +1022,18 @@ static void flow_offload_work_handler(struct work_struct *work)
 
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
index 2e7539be8f88..edbdcc8731d9 100644
--- a/net/netfilter/nf_flow_table_sysctl.c
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -1,7 +1,86 @@
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
+#endif /* CONFIG_NF_FLOW_TABLE_PROCFS */
+
 enum nf_ct_sysctl_index {
 	NF_SYSCTL_FLOW_TABLE_MAX_HW,
 	NF_SYSCTL_FLOW_TABLE_COUNT_HW,
-- 
2.31.1

