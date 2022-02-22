Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80275C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiBVPL3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiBVPL0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:11:26 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4164D12342E
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foSGBQok+5hNtzT0ohruRgqakmFntpMrnQGLuZ5e+MS2c6MtC2DyVMGb4dx/DfbrhPA8VGAzYhMaoJeGUpabguRiwtUxpa0Nm3aD9UCD+UMqrXCNF4YbN96HLL5k1wb4S8vajK+0Bx2r00pM+lWH1F+fv86+iPuAAHpmUwc6HK8+Aeltux5QMjeXucgcvkc77GtMqj4cmSC5EiebNb4i8wl3LeDVrLnkyUNud4h4E8Lfk/VRDewG124YhNCHrnHNAzqxJlTKuAdjdVVnEdCLGXR8UoK4t5uW7/JW9N/6G8EIKrvAsAJE+4xOL6xTTTgk9tnYw5Hz/OfIL29CzpOR2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRdb7S04iOSSjmqgKCsIzAtpk8ZVhoyKv17f5gljlM8=;
 b=SmLtziQEead9hpma3rILv5kYuh4Alyyy0cmB0wpEgUQbBqS/jioTZeGFgnYGwavPVu/j5lR3hP35ATbPDT8BC2q9rwz2+Bv8q3p8qghJUClZWGnV9wCLnKD1WF0Z4xxLv95d4wyQFD6xEPPgg0I0lp0HmAV6e9lt2yz2f65EC9Cmz5lpFdM9uXWRtf0SGhIZhePIACISL2xJwv6fAAsNIqMVDzsStFgXAXT7tOoyOYgpAUkawgAF6sFlb/G5f/6PdMoO5QEh52FZdnjmc/DOGBPmP0YFaeGZTCycq+vzc47In2FcLhFsCRgSk1v2kOuDVUifGNrNqerED0iqhHo3Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRdb7S04iOSSjmqgKCsIzAtpk8ZVhoyKv17f5gljlM8=;
 b=qQvNUwTzSYkf9c9mFB0nMfYXPtRqVCmScPZ3VODiPRNk0CZvesxDAT9Ui9CSs5fMmoFY+GLhrWcLxxq5L1skqSo1ZiITLc06c/7+jYXxXSjMn4hou4C6bdykteBnjHXj4OMFOLa+T7HJW22Q6eSNVH2Z25yW93U0BRGNrj52wWmyJmB8fLO7tI78KJC865Ho114xkX9UC9WdtJQXzhgmjRlQejO6sDEcSpdd5IxFzAh0ixmJFCb8oMRXobPSQt9YrbAA5rPI/9yaBPaRSntmxLyjlv6vAcsfzRE0YWDM6b9R7ViqkShVkIYfHKBWL3BgdFvNpaBIBdZkAz2rX4/F9Q==
Received: from DM3PR14CA0150.namprd14.prod.outlook.com (2603:10b6:0:53::34) by
 DM5PR12MB1562.namprd12.prod.outlook.com (2603:10b6:4:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Tue, 22 Feb 2022 15:10:53 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::68) by DM3PR14CA0150.outlook.office365.com
 (2603:10b6:0:53::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Tue, 22 Feb 2022 15:10:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.20 via Frontend Transport; Tue, 22 Feb 2022 15:10:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:51 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:49 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 4/8] netfilter: introduce total count of hw offload 'add' workqueue tasks
Date:   Tue, 22 Feb 2022 17:09:59 +0200
Message-ID: <20220222151003.2136934-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b928f3c-1272-4c78-813c-08d9f61584b1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1562:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1562C05F44D849647FFAFA5CA03B9@DM5PR12MB1562.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTatAZsb9pDIRRfkW/2XbW1ppvRkpZ07r456oVA+TghmgTxycpSmjGjPZZKQcwBNQt1lf+02+rwPqwJoaJpz0+8mR9N632v3eDbZcF3hL/z3s5aJsCUM9TRUpi7q6N0byCk60Z/8zIKwr449RqqClnrBgagn1kCstmLF8LoUbf7Tk9IGum1Fc6Pb34kfS8WEoPB/lcYChanMfRzNgfWKgjE2fo1VRHYAViRWayCkfKv46EMEyTRkM7fVgHVs1j9vkWNgIE47Jnl0mC38YSmxy2AZCT7vQSnkFcnrhi2YioMdJVtI2c4TmNPQsTn0zk0wKC96uoGAgQeZIx3ayAlz6ZKIGnczyPgZrxqeS104S5txdgmttJEH9E3PaEGveioJ6tHDEnsvSb6Alva+JLg/dNl+PlexQK4PLTHAu1Rjs2NwlHUZZNA13Pd7IitHOgZEd3SiyE4Kt1qleJKeQ8+CFufnsWI+aG27D0tVq00KrQ2b2AyqbX4Tks4dVVLyxfsIzeJUJ3VLhnUERRmxWbDrFdj3JoxtCV24Jq3KNlHF3AIO3vk3cxF6+tA21Qh1F7ZezVjONVFRWFUWyThOUH3LhFSt/nd955bdsW2LAx8Vl+OUJcBkPjYP7xb8MgT8kqzzW3Lb3kP47ZsXP0yOt31dExCO6z3wKBBCDM6gexbWIsJLTMT//A68WRCtfvpsg/1lY+volZVLB3HaFGzioZCaIg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(54906003)(40460700003)(6916009)(47076005)(316002)(36860700001)(107886003)(336012)(2616005)(5660300002)(2906002)(1076003)(8676002)(36756003)(426003)(7696005)(508600001)(70206006)(356005)(8936002)(81166007)(70586007)(86362001)(26005)(4326008)(82310400004)(6666004)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:10:52.9357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b928f3c-1272-4c78-813c-08d9f61584b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1562
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability and allow capping total amount of
offload 'add' in-flight entries on workqueue in following patch extend
struct netns_nftables with 'count_wq_add' counter and expose it to
userspace as 'nf_flowtable_count_wq_add' sysctl entry. Increment the
counter when allocating new workqueue task and decrement it after
flow_offload_work_add() is finished.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            |  1 +
 net/netfilter/nf_conntrack_standalone.c |  8 ++++++++
 net/netfilter/nf_flow_table_offload.c   | 10 +++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 5677f21fdd4c..a971d986a75b 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -8,6 +8,7 @@ struct netns_nftables {
 	u8			gencursor;
 	atomic_t		count_hw;
 	int			max_hw;
+	atomic_t		count_wq_add;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index af0dea471119..fe2327823f7a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -621,6 +621,7 @@ enum nf_ct_sysctl_index {
 #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	NF_SYSCTL_CT_COUNT_HW,
 	NF_SYSCTL_CT_MAX_HW,
+	NF_SYSCTL_CT_COUNT_WQ_ADD,
 #endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
@@ -991,6 +992,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_COUNT_WQ_ADD] = {
+		.procname	= "nf_flowtable_count_wq_add",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1131,6 +1138,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
 	table[NF_SYSCTL_CT_COUNT_HW].data = &net->nft.count_hw;
 	table[NF_SYSCTL_CT_MAX_HW].data = &net->nft.max_hw;
+	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..ffbcf0cfefeb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -953,11 +953,15 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload;
+	struct net *net;
 
 	offload = container_of(work, struct flow_offload_work, work);
+	net = read_pnet(&offload->flowtable->net);
+
 	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
+			atomic_dec(&net->nft.count_wq_add);
 			break;
 		case FLOW_CLS_DESTROY:
 			flow_offload_work_del(offload);
@@ -1011,11 +1015,15 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flowtable->net);
 	struct flow_offload_work *offload;
 
+	atomic_inc(&net->nft.count_wq_add);
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
-	if (!offload)
+	if (!offload) {
+		atomic_dec(&net->nft.count_wq_add);
 		return;
+	}
 
 	flow_offload_queue_work(offload);
 }
-- 
2.31.1

