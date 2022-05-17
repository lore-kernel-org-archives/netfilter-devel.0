Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DB4C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 16:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351267AbiEQQ7k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351281AbiEQQ7j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 12:59:39 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2066.outbound.protection.outlook.com [40.107.100.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D1D4FC69
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 09:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSLIY+A0a6czEwl2PZ4Gmc8mon8hbxIE+pahph6nP0tuiylGmQv26hU9gS5zdBDkNRrIyS3luRwk8Ea0UzCWMwFKc8F+tzchXK4zi8MnDgLe8TIyrY6G5+QAxLLJbrotZF1RsGdtXEk4j62b9hmAQORB1VfTA227T8CI7PoVma+4isYGXRUl/GQwD0MmBiDHExEmlg1+k5Xy8flN9EcyeZ/8TqPtD4SW2Z3mXCBMRGEj+rj1zUkUh7SaXJ2HLFAHP8DS6N1+7s7umFp4h6K4/qlEZXxy5uX/uWLJ9M1/scRR1K/oOVr1vHSim8ZCU1qbYRKIHy9WIYeReXS6Pyhchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzFvJKk6MkqyHQ+Iz7wZ/JZ69F99qeYL7o6AnUTErvo=;
 b=LZaY3jGP4OuW2O/jRHXrN9KrvQ8MSE8ET10T3FxQDeaTsalrdKK5jRBolu5EM15ddHiK48Bw7CeJ5QXglTV9APkBSHCQvma676HZP+RdN+fVHbr8gwFChzHi9TTvdZSctd8xusiybWpYIQ3MqFege3cj2xsNcNXf8hHK0Mc+AEKPMCZY72u/NhZOsS1kmtpeSs/ckBT5fsrsiZZPcTnmhO7qOg0+lobax6yQvaNHzCnqSmNWsPw5UVn1GKhn7XkS1ZtbrIcySCDHwZ0jAy8KoS7Ouw1bKCCFcAsCo48fLNCh4LN7LGI+vFj1/2BH25KmQ9f2KEqjPU9r229La4WGrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzFvJKk6MkqyHQ+Iz7wZ/JZ69F99qeYL7o6AnUTErvo=;
 b=LU1JrqBupW6DiPF1azwExDEJ8BquntuZbbmYj65MgFWF0yeHdRRFWmwBI2Ve+3hGTVcVYXo5Fqsh4nHW+4B8Tu9uG1Lw1MheE2a4Bdk7UigKysUynhGf5Kv2K+RdMPDDw7BpfOcQQZbWlL/LQgNRQsUHPurDdpWhrhB0IOcMc03/SNqWXw4l+pSPB+BWnvh9oegbVKYieclNwtbbJYulyH5s7E2gHpmKk2m60Rtxgu3/D73ZTy6w/mzAOPczxWOJnaVXVnrO06knAqO9NQDxLHhFi9keD9ZU10bP0cMYhmt/vOZRjgZcI8Jr7YLIymkUH7bgqeXRMwxGF/tOuNf4yQ==
Received: from MW4PR03CA0183.namprd03.prod.outlook.com (2603:10b6:303:b8::8)
 by MN2PR12MB3246.namprd12.prod.outlook.com (2603:10b6:208:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Tue, 17 May
 2022 16:59:35 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::44) by MW4PR03CA0183.outlook.office365.com
 (2603:10b6:303:b8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15 via Frontend
 Transport; Tue, 17 May 2022 16:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 16:59:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 16:59:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 09:59:33 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 17 May
 2022 09:59:31 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 2/3] netfilter: nf_flow_table: count and limit hw offloaded entries
Date:   Tue, 17 May 2022 19:59:08 +0300
Message-ID: <20220517165909.505010-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220517165909.505010-1-vladbu@nvidia.com>
References: <20220517165909.505010-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a99b6ee-734d-4380-10bc-08da38269e56
X-MS-TrafficTypeDiagnostic: MN2PR12MB3246:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB324657E550F2A7E7262BB8E5A0CE9@MN2PR12MB3246.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gv5YKCWG1AeWB0CEoatch+wFwqO1n9aPzBml1GVPxBqo4tCePUu87p6Garq30AR62vqqpk7tFa+Rs3DrGG+FkyPDNRHoHJCSwt3wzH5V1Tu5QWHyWkEUibOWB+2y/bml7+OeEThdDbvyJY71YrZWahRWcBD3IiAqLWVlbKVbbrnsppmqyjdiCl4HqMaGWcvRq+Vyqrj/qQBFFvu+RCQAG2eeaNAdhkD9dx/+kUNxYwQSj6n1jRGMsQxtfwYmTxgjce+9xL8MTBHfv2iUMkDrqT6s0ppDa7xHWMfisc80BywUswAAia0Rnz4Yzt+YWEDbGlkNhfLdR/NoeoZeE655DSY+nqIiMmv07owT1BPok/UVitqNG7hiTUyOCADk3t5W2515RtLq/TTlpyxsBHVXUuMlQU+L4KMZ5n2kyuAjg+Y88vjnK/LNg6zUMEI42RSWgtL2FccYoVWiRVCgZ/lCRbAqvulbjUVDq4s37ADMLw4CBW9VNZneQ/TWehlfSdTa8fVCdEKC8HCaZ+zUGu9jHdylsnVB9cLOSKPChUnZgOIxN71JdmT0lxRjXnf3/tY+Ex1d7sgLlh2jf8664kU23YWxkqwErLqvXXByrx6JoBWOinNYu+JeGaZS8c56XRzUF3PwFoqzObwpr9hIJQHURal4GEaVurkDk3z70avrrLLEis1QPtH8i8e1rUS4JpAwVwVh0h1DjkO2YgMU9HTPg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(8676002)(4326008)(70206006)(36860700001)(2616005)(7696005)(6666004)(316002)(47076005)(426003)(30864003)(86362001)(83380400001)(8936002)(5660300002)(40460700003)(107886003)(186003)(36756003)(82310400005)(26005)(81166007)(2906002)(336012)(1076003)(508600001)(6916009)(356005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:59:34.1293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a99b6ee-734d-4380-10bc-08da38269e56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3246
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability and scalability introduce
'nf_flowtable_count_hw' and 'nf_flowtable_max_hw' sysctl entries in new
dedicated 'net/netfilter/ft' namespace. Add new pernet struct nf_ft_net in
order to store the counter and sysctl header of new sysctl table.

Count the offloaded flows in workqueue add task handler. Verify that
offloaded flow total is lower than allowed maximum before calling the
driver callbacks. To prevent spamming the 'add' workqueue with tasks when
flows can't be offloaded anymore also check that count is below limit
before queuing offload work. This doesn't prevent all redundant workqueue
task since counter can be taken by concurrent work handler after the check
had been performed but before the offload job is executed but it still
greatly reduces such occurrences. Note that flows that were not offloaded
due to counter being larger than the cap can still be offloaded via refresh
function.

Ensure that flows are accounted correctly by verifying IPS_HW_OFFLOAD_BIT
value before counting them. This ensures that add/refresh code path
increments the counter exactly once per flow when setting the bit and
decrements it only for accounted flows when deleting the flow with the bit
set.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---

Notes:
    Changes V2 -> V3:
    
    - Move sysctl documentation to existing conntrack rst file.
    
    - Change Makefile to conditionally include nf_flow_table_sysctl.c file and
    remove corresponding ifdefs from the file.
    
    Changes V1 -> V2:
    
    - Combine patches that expose offloaded flow count and limit total
    offloaded flows.
    
    - Rework the counting logic to count in workqueue context.
    
    - Create dedicated namespace for flow table sysctls.

 .../networking/nf_conntrack-sysctl.rst        |  9 +++
 include/net/netfilter/nf_flow_table.h         | 36 ++++++++++
 net/netfilter/Makefile                        |  1 +
 net/netfilter/nf_flow_table_core.c            | 55 ++++++++++++++-
 net/netfilter/nf_flow_table_offload.c         | 38 ++++++++--
 net/netfilter/nf_flow_table_sysctl.c          | 69 +++++++++++++++++++
 6 files changed, 200 insertions(+), 8 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 311128abb768..a60394e1d3a5 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -207,3 +207,12 @@ nf_flowtable_udp_timeout - INTEGER (seconds)
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_flowtable_count_hw - INTEGER (read-only)
+	Number of flowtable entries that are currently offloaded to hardware.
+
+nf_flowtable_max_hw - INTEGER
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	Cap on maximum total amount of flowtable entries offloaded to hardware.
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 64daafd1fc41..9709f984fba2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -335,4 +335,40 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 	return 0;
 }
 
+struct nf_ft_net {
+	atomic_t count_hw;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+#endif
+};
+
+extern unsigned int nf_ft_hw_max;
+extern unsigned int nf_ft_net_id;
+
+#include <net/netns/generic.h>
+
+static inline struct nf_ft_net *nf_ft_pernet(const struct net *net)
+{
+	return net_generic(net, nf_ft_net_id);
+}
+
+static inline struct nf_ft_net *nf_ft_pernet_get(struct nf_flowtable *flow_table)
+{
+	return nf_ft_pernet(read_pnet(&flow_table->net));
+}
+
+#ifdef CONFIG_SYSCTL
+int nf_flow_table_init_sysctl(struct net *net);
+void nf_flow_table_fini_sysctl(struct net *net);
+#else
+static inline int nf_flow_table_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static inline void nf_flow_table_fini_sysctl(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 238b6a620e88..9e3c1f9c6d07 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
 				   nf_flow_table_offload.o
+nf_flow_table-$(CONFIG_SYSCTL)	+= nf_flow_table_sysctl.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..e2598f98017c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -277,6 +277,13 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
+static bool flow_max_hw_entries(struct nf_flowtable *flow_table)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet_get(flow_table);
+
+	return nf_ft_hw_max && atomic_read(&fnet->count_hw) >= nf_ft_hw_max;
+}
+
 unsigned long flow_offload_get_timeout(struct flow_offload *flow)
 {
 	unsigned long timeout = NF_FLOW_TIMEOUT;
@@ -320,7 +327,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 
 	nf_ct_offload_timeout(flow->ct);
 
-	if (nf_flowtable_hw_offload(flow_table)) {
+	if (nf_flowtable_hw_offload(flow_table) &&
+	    !flow_max_hw_entries(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
 		nf_flow_offload_add(flow_table, flow);
 	}
@@ -338,9 +346,11 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (READ_ONCE(flow->timeout) != timeout)
 		WRITE_ONCE(flow->timeout, timeout);
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
+	if (likely(!nf_flowtable_hw_offload(flow_table) ||
+		   flow_max_hw_entries(flow_table)))
 		return;
 
+	set_bit(NF_FLOW_HW, &flow->flags);
 	nf_flow_offload_add(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
@@ -652,14 +662,53 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+static int nf_flow_table_pernet_init(struct net *net)
+{
+	return nf_flow_table_init_sysctl(net);
+}
+
+static void nf_flow_table_pernet_exit(struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list)
+		nf_flow_table_fini_sysctl(net);
+}
+
+unsigned int nf_ft_net_id __read_mostly;
+
+static struct pernet_operations nf_flow_table_net_ops = {
+	.init = nf_flow_table_pernet_init,
+	.exit_batch = nf_flow_table_pernet_exit,
+	.id = &nf_ft_net_id,
+	.size = sizeof(struct nf_ft_net),
+};
+
 static int __init nf_flow_table_module_init(void)
 {
-	return nf_flow_table_offload_init();
+	int ret;
+
+	nf_ft_hw_max = 0;
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
index 11b6e1942092..5c7146eb646a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -13,6 +13,8 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+unsigned int nf_ft_hw_max __read_mostly;
+
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
@@ -903,30 +905,56 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 	return 0;
 }
 
+static bool flow_get_max_hw_entries(struct nf_flowtable *flow_table)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet_get(flow_table);
+	int count_hw = atomic_inc_return(&fnet->count_hw);
+
+	if (nf_ft_hw_max && count_hw > nf_ft_hw_max) {
+		atomic_dec(&fnet->count_hw);
+		return false;
+	}
+	return true;
+}
+
 static void flow_offload_work_add(struct flow_offload_work *offload)
 {
+	struct nf_ft_net *fnet = nf_ft_pernet_get(offload->flowtable);
 	struct nf_flow_rule *flow_rule[FLOW_OFFLOAD_DIR_MAX];
 	int err;
 
+	if (!flow_get_max_hw_entries(offload->flowtable))
+		return;
+
 	err = nf_flow_offload_alloc(offload, flow_rule);
 	if (err < 0)
-		return;
+		goto out_alloc;
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		goto out;
+		goto out_add;
 
-	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status))
+		atomic_dec(&fnet->count_hw);
+	nf_flow_offload_destroy(flow_rule);
+	return;
 
-out:
+out_add:
 	nf_flow_offload_destroy(flow_rule);
+out_alloc:
+	atomic_dec(&fnet->count_hw);
 }
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
-	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	bool offloaded = test_and_clear_bit(IPS_HW_OFFLOAD_BIT,
+					    &offload->flow->ct->status);
+	struct nf_ft_net *fnet = nf_ft_pernet_get(offload->flowtable);
+
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (offloaded)
+		atomic_dec(&fnet->count_hw);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
diff --git a/net/netfilter/nf_flow_table_sysctl.c b/net/netfilter/nf_flow_table_sysctl.c
new file mode 100644
index 000000000000..2e7539be8f88
--- /dev/null
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <net/netfilter/nf_flow_table.h>
+
+enum nf_ct_sysctl_index {
+	NF_SYSCTL_FLOW_TABLE_MAX_HW,
+	NF_SYSCTL_FLOW_TABLE_COUNT_HW,
+
+	__NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL,
+};
+
+#define NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL                                       \
+	(__NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL + 1)
+
+static struct ctl_table nf_flow_table_sysctl_table[] = {
+	[NF_SYSCTL_FLOW_TABLE_MAX_HW] = {
+		.procname	= "nf_flowtable_max_hw",
+		.data		= &nf_ft_hw_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	[NF_SYSCTL_FLOW_TABLE_COUNT_HW] = {
+		.procname	= "nf_flowtable_count_hw",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+int nf_flow_table_init_sysctl(struct net *net)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet(net);
+	struct ctl_table *table;
+
+	BUILD_BUG_ON(ARRAY_SIZE(nf_flow_table_sysctl_table) != NF_SYSCTL_FLOW_TABLE_LAST_SYSCTL);
+
+	table = kmemdup(nf_flow_table_sysctl_table, sizeof(nf_flow_table_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	table[NF_SYSCTL_FLOW_TABLE_COUNT_HW].data = &fnet->count_hw;
+
+	/* Don't allow non-init_net ns to alter global sysctls */
+	if (!net_eq(&init_net, net))
+		table[NF_SYSCTL_FLOW_TABLE_MAX_HW].mode = 0444;
+
+	fnet->sysctl_header = register_net_sysctl(net, "net/netfilter/ft", table);
+	if (!fnet->sysctl_header)
+		goto out_unregister_netfilter;
+
+	return 0;
+
+out_unregister_netfilter:
+	kfree(table);
+	return -ENOMEM;
+}
+
+void nf_flow_table_fini_sysctl(struct net *net)
+{
+	struct nf_ft_net *fnet = nf_ft_pernet(net);
+	struct ctl_table *table;
+
+	table = fnet->sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(fnet->sysctl_header);
+	kfree(table);
+}
-- 
2.31.1

