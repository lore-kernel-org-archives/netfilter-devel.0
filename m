Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97B4C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 19:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343632AbiEPTLd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 15:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345305AbiEPTLb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 15:11:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC69DEEF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 12:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ld6KgHomNhLHV/wyj6Ka8whXASkCKajADxZSOWNu9odmjouGFpAzTXUp/6E871rtWeWpaG2RD1AtBk5QLZNc3bM8DtSgeLtxbQeUtIYwrywTX5AnSp0VPmPFMEMnZOxXwbrZW90OgdE6Is2Ie5Zy1JaNp2I2NWDHT+dzHBECib2iwjys/MEeCAua6ri1DQKFhxqVloRomCnjUIAdowPcftxjwWjk7iTtdvlFx6BPq2Y6s8FYcNLW/VSI4hG3SLnJ89L1ogZbUHbH5Y6QKH/iRzm5t3YTAmzIkc84KFGnabuKJj5C26C3b7ieXaf9navbriLvKjyk4/roJuWFvpGFnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6Vmomjd/DsFyijzU1Hid7UPVD8Chm9tPbnbO0wlS7w=;
 b=mwjbMXIqGkuhl+klsEj2W4fb1ocWxvbRWWxbysq8rIm8OP7F2I6okGSCPDcxH1Yd+/xX0K9wQPJ/plgyMEBbxF5Tp7HqoLV1Y89cyHfUD90O4ww/nmxQSJbjtLHF8EMQuxVlI/A0y80jcs8upzPaZA+IQ17mELqjX1QES8LTDpHVCoK00JhZEDS6T+FtklYgq1xMKFnrnDxDCsZnYY+gUFdMyQ4/8cAU3HfON4poiT2V9aF4g2vf/9ljHD+T/xZY6k2byYR6/UtMtnsOvX8fuK8Js6R1fHc+Z9fzIZSxxzJeFhZJ+YP0GzRMgn9i7ZCaQr8CH+lHqu66f3koyvhD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6Vmomjd/DsFyijzU1Hid7UPVD8Chm9tPbnbO0wlS7w=;
 b=Di0iITFCXkTAkQY1/21U+8kYxp1Nz82A5xZTe6vOy7RVnFtpnK0MfQEku2H6H/YQau0hqU2O09UrampbhD+ubQEI3BHmy/QX2E9q9phJYxTvx5OhgW6LSnkVyCwmNjrNGNk6X9XdT8BveUHXjs4bycntTVZuKa71e4fOtTrdmwtvjiQBd4svXHl22olrQdzzHEtuoX9PJwM1kny3Pr0Z1h8iZst7uywDsBE4pbdofB+5XMeIfyO7yfUWpWfd0kDtjJhCgSeE4E0rlXFvjeyPiUx0ca7FvJ26cah/KSLYUopNqc3k6tWeusuXQlIyoftVuvW+9J3Tp92LsWJBs9O+rg==
Received: from BN0PR07CA0026.namprd07.prod.outlook.com (2603:10b6:408:141::26)
 by DM5PR12MB1371.namprd12.prod.outlook.com (2603:10b6:3:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 19:11:28 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::e) by BN0PR07CA0026.outlook.office365.com
 (2603:10b6:408:141::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15 via Frontend
 Transport; Mon, 16 May 2022 19:11:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 19:11:27 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 16 May 2022 19:10:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 16 May 2022 12:10:55 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 16 May 2022 12:10:53 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 2/3] netfilter: nf_flow_table: count and limit hw offloaded entries
Date:   Mon, 16 May 2022 22:10:31 +0300
Message-ID: <20220516191032.340243-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220516191032.340243-1-vladbu@nvidia.com>
References: <20220516191032.340243-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1aafa6c-589e-4858-8ca6-08da376fe08e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1371:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1371BB518FEA6C8F2CAAC4A7A0CF9@DM5PR12MB1371.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8Nx5SswOk/0uJ99lZPelN1cAdX4Ku+PGAnsGQzlyzIcOonxVZeMUZseMUex4J6bsZopPX4nLiZYkQBHPauOYDVo794Wqu0bVUyqSw5a+XMB4xdTxZRTkGnAJu/YNs9jjryJxUIO/F5Wl9g3UwBkksgyjqYn0EF9Ju+iJEUjUbLoLrB0fpzx6eB4RLt4jrwvM/LYaRnyo69SuxGb3VFydLE6NK6mvwb6oIDz+vTm9f5xcUYadzC7LTz/XifUIdALXd1rduXiL5VhGViZBOPLL1r/kTI/o4l4gyXYnUPEXQ89MzJrtjwDzP/U02YpSCzJHuLvRHy4YcCf7Em/LMD8dB7v0gytn6j6NcRu+svT/IxfG12EZS53HI4XPw2fcn740SDQzkoBXBLvYZmfhpDbKlIkQr4c3+2UZ5gQB3h+D5WBfkHHctr1gAm9CtXN+RMITtp2vzIjeFv1YClZdEufd8vei2el6F5V1YXg4A2RPEOrr1od+fs4VjuGw1PV8nM8wj+dv4hEr0h01EmDPkXdvbutfa6tFqtz+RL4RuZUiyeERgAyc+ELX+r9c+vvQK+EmXd4S/qRSbPG/Z2+alPRCbV90wf07gWxfTg0WOjTvguvbGI/Sg+lBYCd2DCl4ijFah1RbqOFXzTq4xMDVGrPUnyt5ARYB8Tya2rdnsW2xYzRD1LP6r3s235BtdzoenfUzyNFsqReKdWKd4FgePXmLA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(70586007)(70206006)(4326008)(8676002)(30864003)(86362001)(6916009)(356005)(426003)(107886003)(336012)(1076003)(2906002)(40460700003)(81166007)(26005)(36756003)(6666004)(186003)(508600001)(82310400005)(7696005)(36860700001)(47076005)(2616005)(54906003)(316002)(8936002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 19:11:27.2963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aafa6c-589e-4858-8ca6-08da376fe08e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1371
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
    Changes V1 -> V2:
    
    - Combine patches that expose offloaded flow count and limit total
    offloaded flows.
    
    - Rework the counting logic to count in workqueue context.
    
    - Create dedicated namespace for flow table sysctls.

 .../networking/nf_flowtable-sysctl.rst        | 17 ++++
 include/net/netfilter/nf_flow_table.h         | 25 ++++++
 net/netfilter/Makefile                        |  3 +-
 net/netfilter/nf_flow_table_core.c            | 55 +++++++++++-
 net/netfilter/nf_flow_table_offload.c         | 36 ++++++--
 net/netfilter/nf_flow_table_sysctl.c          | 83 +++++++++++++++++++
 6 files changed, 210 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/networking/nf_flowtable-sysctl.rst
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c

diff --git a/Documentation/networking/nf_flowtable-sysctl.rst b/Documentation/networking/nf_flowtable-sysctl.rst
new file mode 100644
index 000000000000..932b4abeca6c
--- /dev/null
+++ b/Documentation/networking/nf_flowtable-sysctl.rst
@@ -0,0 +1,17 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Netfilter Flowtable Sysfs variables
+===================================
+
+/proc/sys/net/netfilter/ft/nf_flowtable_* Variables:
+=================================================
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
index 64daafd1fc41..e09c29fa034e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -335,4 +335,29 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
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
+int nf_flow_table_init_sysctl(struct net *net);
+void nf_flow_table_fini_sysctl(struct net *net);
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 238b6a620e88..67e281842b61 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -127,7 +127,8 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
 nf_flow_table-objs		:= nf_flow_table_core.o nf_flow_table_ip.o \
-				   nf_flow_table_offload.o
+				   nf_flow_table_offload.o \
+				   nf_flow_table_sysctl.o
 
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
index 11b6e1942092..a6e763901eb9 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -903,30 +903,56 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
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
index 000000000000..ce8c0a2c4bdb
--- /dev/null
+++ b/net/netfilter/nf_flow_table_sysctl.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <net/netfilter/nf_flow_table.h>
+
+unsigned int nf_ft_hw_max __read_mostly;
+
+#ifdef CONFIG_SYSCTL
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
+
+#else
+int nf_flow_table_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+void nf_flow_table_fini_sysctl(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
-- 
2.31.1

