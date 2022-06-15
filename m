Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1B2C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347327AbiFOKoZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 06:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiFOKoX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 06:44:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175E84F9D7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 03:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfFDBfZrXklknCCKvzDmYIaeR3mAj3D0/pLwhWNSs0cMwXMOBiWmXWtS+WwYN/78offNsC4DYAGwogp6FPUHCa9mwyS7a9b5QnMxdb7E8AcC5SLkeF8NvxwAwMV+A13VDCvqEoXUV8sPB0x7bSF+HZFRmXkgxV31GQfAmEAN1r/P6Iw1eoyZfSqHJpKJ/hsXJ/b8SVJmGFCtFtJgC8IlqQeHzLcm4WndBNa2PdrDUbkCaaxuZM4pFgpo7rJsyhFFe8UHmXzJ3W3fwHtDP15l9mowoM+3ZUS30QMkweIDEYeig2Yqm8A+EJtCSRk6c9DdJ5xGBDBsKS9Dd+kmERuWAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pj+EyTb+KV2yT48hyKheX6s/8F5GRNZ7yzcb8zLwWcU=;
 b=lFmxADLVZgw5ZoGkcP8AwjQ4ayLPLSHJU9htTd9V9QxCbZ3T6ZxdumF1YTITpmCUC0w7JKUh3brxjt7s4xSekZNmMzqVE0X+HbAAl2NDnom9ydFT/GghIJq/jqvcJg7GWYfWNZtGpvGG+JAWSadZuf0zcSPqOiGqE55hXZDymPzaXucHRKEyijcgd0INBXasbK6EFWG9h8u2cLfrVs5dFqOUS2PueM00UZJQT6Nc7pAAT7BGdVWuXFKGYKp2uxlqSdm4g7Bi6b4uDEW1WhKtctjHXgHSAVOibLLB1bnivWh1k0CQZ1SWvDoKhadi4Nt1L3Hc87KNnS0OWlmhhFTNdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pj+EyTb+KV2yT48hyKheX6s/8F5GRNZ7yzcb8zLwWcU=;
 b=ek36O35tTG5DPnimF8+vPMfkYnk+GwDmsRrwOAQVrmMdRs3uzJB2qv3+bTiXResmjuMPbMW1wTnBSLTAseccx8ZxkFAPzF1WHKineAGo2qrSYx63hsZsjuDUc9HvnsSW9DM5vLjLgasu2Kt8Evr3qUfs7cPA2FFzkX3SP1+ZusEpfACYKY2OqLehABu/kqIZZdG7Rp4YGyzWgs6BOoIu6E0Xa5IFIA8SoRuyP9ETWm5ZoDoQQ/LvQ0i2XgrsNHLOnvvX19ROwtjOEJAoW4Wlu3RA/TuE/+tZB3VFE/robXTm3xq0tnGyOn8+ZY5r8mKRk5huyutXup4E04QSmtj3+A==
Received: from DM6PR06CA0058.namprd06.prod.outlook.com (2603:10b6:5:54::35) by
 DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Wed, 15 Jun 2022 10:44:18 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::9b) by DM6PR06CA0058.outlook.office365.com
 (2603:10b6:5:54::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20 via Frontend
 Transport; Wed, 15 Jun 2022 10:44:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 10:44:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 10:44:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 15 Jun
 2022 03:44:16 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 15 Jun
 2022 03:44:14 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 2/2] netfilter: nf_flow_table: count pending offload workqueue tasks
Date:   Wed, 15 Jun 2022 12:43:55 +0200
Message-ID: <20220615104355.391249-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615104355.391249-1-vladbu@nvidia.com>
References: <20220615104355.391249-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ca1f083-f53d-4607-4dcd-08da4ebbff9c
X-MS-TrafficTypeDiagnostic: DS7PR12MB5933:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5933D3EFBC24BAE060E8BFCDA0AD9@DS7PR12MB5933.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ZtbiWcE4QR20Ous8UvM57NZ68oL9TvlWKsXgW5U6t9+v9fFfX5Gy53IkFj324wDs8CD+eC+IqmcVxJ3tPFBsu3aRkK+T8SykVBmuiQcF/bijOVSbT55s+acmyURnUERfRbOa7hsLqtYQjTWv7R+FQ/pX+9ZE6/F7MkciH5Fk07dH7y+ZJI6thAPLpA5nzBuGzlosA44pGD0br8zRfuEAo5C2Zv9CGyTUmvoC7mV+ZGIfawK2G8o029QafSDl5ZgAY+3hd9nUvxNxbGl9mb99VBdwGUKzkRqvQ3fuNQoLP3VaHdV7kdz5+Hi8FaOSMlbEpLuNQjlFDlpyJVtPRhf+LyvU5/yZpG5RFNrHPx/tNYl9EMtIFpXpUJBKnNr7UgQTGqFU8WgSyTzCO8ZzJRJg/fBoI/dWuXfaH4ONWpiyqqC4CAxvm6RTkJ7dXHci4TjbzTL9XngwGdPWUc9eEKUpwHNPwuONbVx2tnIVtVDBUIfb2T9BEmCzALnVoBu0Bah0basNhgg5YbI0SPto35VaI6V7fy2QJBdL+Qso0SPD0QpXsvCvDK1lQiZuJdCmp75YL+/s7tDWEDiArBZiCEsRenq77yM3e7nS+/HAJoPVOfdz/Qm2saUeF9W1evb37apqcPIdrersnn9tsFJpeI5I5jLYnIRZE3l5G/N1MAt8mHJcT1pJ7eI6XbHUM/i/hJGPEvo6k5RhR2mssgtsSd06Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(186003)(6916009)(2906002)(6666004)(508600001)(1076003)(426003)(47076005)(30864003)(107886003)(336012)(26005)(82310400005)(2616005)(36860700001)(4326008)(8676002)(316002)(36756003)(70586007)(70206006)(8936002)(40460700003)(81166007)(356005)(83380400001)(5660300002)(7696005)(54906003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 10:44:17.9224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca1f083-f53d-4607-4dcd-08da4ebbff9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933
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
    Changes V3 -> V4:
    
    - Move basic infrastructure code that registers pernet ops for flow table
    from previous patch in series that got nacked to this one.
    
    - Since sysctl functionality from previous patch got removed from the
    series and the new file is now only used for procfs-related code, rename it
    from nf_flow_table_sysctl.c to nf_flow_table_procfs.c.
    
    - Make nf_flow_table_procfs.c compiled conditionally depending on
    CONFIG_NF_FLOW_TABLE_PROCFS and remove ifdefs from the source file.
    
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
 net/netfilter/Makefile                |  1 +
 net/netfilter/nf_flow_table_core.c    | 62 ++++++++++++++++++++-
 net/netfilter/nf_flow_table_offload.c | 17 +++++-
 net/netfilter/nf_flow_table_procfs.c  | 80 +++++++++++++++++++++++++++
 8 files changed, 206 insertions(+), 4 deletions(-)
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_procfs.c

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
index 64daafd1fc41..d5326c44b453 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -335,4 +335,25 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 	return 0;
 }
 
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
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 238b6a620e88..06df49ea6329 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
 				   nf_flow_table_offload.o
+nf_flow_table-$(CONFIG_NF_FLOW_TABLE_PROCFS) += nf_flow_table_procfs.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f2def06d1070..51c2b1570838 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -614,14 +614,74 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
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
+static int nf_flow_table_pernet_init(struct net *net)
+{
+	int ret;
+
+	ret = nf_flow_table_init_net(net);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_flow_table_init_proc(net);
+	if (ret < 0)
+		goto out_proc;
+
+	return 0;
+
+out_proc:
+	nf_flow_table_fini_net(net);
+	return ret;
+}
+
+static void nf_flow_table_pernet_exit(struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		nf_flow_table_fini_proc(net);
+		nf_flow_table_fini_net(net);
+	}
+}
+
+static struct pernet_operations nf_flow_table_net_ops = {
+	.init = nf_flow_table_pernet_init,
+	.exit_batch = nf_flow_table_pernet_exit,
+};
+
 static int __init nf_flow_table_module_init(void)
 {
-	return nf_flow_table_offload_init();
+	int ret;
+
+	ret = register_pernet_subsys(&nf_flow_table_net_ops);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_flow_table_offload_init();
+	if (ret)
+		goto out_offload;
+
+	return 0;
+
+out_offload:
+	unregister_pernet_subsys(&nf_flow_table_net_ops);
+	return ret;
 }
 
 static void __exit nf_flow_table_module_exit(void)
 {
 	nf_flow_table_offload_exit();
+	unregister_pernet_subsys(&nf_flow_table_net_ops);
 }
 
 module_init(nf_flow_table_module_init);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 11b6e1942092..103b6cbf257f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -967,17 +967,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
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
@@ -989,12 +994,18 @@ static void flow_offload_work_handler(struct work_struct *work)
 
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
diff --git a/net/netfilter/nf_flow_table_procfs.c b/net/netfilter/nf_flow_table_procfs.c
new file mode 100644
index 000000000000..159b033a43e6
--- /dev/null
+++ b/net/netfilter/nf_flow_table_procfs.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <net/netfilter/nf_flow_table.h>
+
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
-- 
2.36.1

