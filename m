Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0BFC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiBVPMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiBVPMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:12:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C805114745
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:11:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0hkAIkU72QCeAeCCx1yi33TEAN/NKyO5c280ie30v21Zbu99hBaFKWaKo5g11HsFH4BROpIu9RwqrYoxMHQOJTDTHoYDPByFJi8DL/wNWNAMJnDni1SrYy9HaWMe/qMlomVYu9PO5JZ8lX9QPBri3E9bbygVMtsYITRxJuM1+16UK0giCVpnXqBQoYut6nrT0OP2eoH7uRMFDMzdAJU4fmVMd39Xn6vmyRnJ0X+N0RbgG+KiLqxHmFRlv1cLdb1qazWViUXUzT+InWSWXuHuUki3rY5j+YX/UUa7qzIC05MfnU50gQgVyz2bhD6HNm600zBS/LEGGG+HsLNzIV6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u87P1xaUD6HJcs0HL7Dxmd2a9c6Z+rUVT5tLuiHam0E=;
 b=X0NtJn6lLNHiuQ4NMSa6jsXs6IP1k5zcBKHDMXW6jxRTQaJdDgXOR/dSQ5fjVC4O30iNHoD1D6Xq8NfOCodO18dIwyBlZJ9NClsxfORTC8H7IurJPSoVn3ic8zAIwl0LhTeu0O+EJZo3ZoXy38eZOhkXjbqWUdkjewkEMWUT2mQjJezqBLV9jX0O98VTlpHl4vB6pP1CM6BnmukVAWWZS6VA62zIYcqnbql3TUDCVoFRKtighOLc61whJGriwxHpCCsHPfEMjh1R8Hf5zK5SaMenxajDAEmp3VPq2RYb6PIP4p6tiDde71ML6Nb9MFkT33OcNS7qHj+I+CV1HkF6sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u87P1xaUD6HJcs0HL7Dxmd2a9c6Z+rUVT5tLuiHam0E=;
 b=lY+JLiuEFRUAM9NW9nV5cWd7dmIrnsRi1E+BG3I0XKU2e4QPe6o5LH6HMghrDRQ/YTrfYHljogLjU8k8x29OBZLylUDpM+j8Ny5Uq+ZKfiQ400aH3xBUimeJ8Y9qAIc0CaYr10rsRrJD3JuEwdx2e46+fyPQiQSxiKuryL2HZjXUCmi7ohIPTSkzpMmE6ttmh6uRGmr1JfCTvaXsbXKogwAs/sIBlr7oevB8PhOK8VNxgN0kjMwsa+sDaHUkvT5Sl7pzEPLlmjHURZnT+05+A0k6tPo8Y40RnSvVCriuBbu27+oOI6Wuv7hDPHiV+PRz8M2T6tRWd30DAR9XbUaYhw==
Received: from DM6PR11CA0066.namprd11.prod.outlook.com (2603:10b6:5:14c::43)
 by SJ0PR12MB5664.namprd12.prod.outlook.com (2603:10b6:a03:42b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Tue, 22 Feb
 2022 15:11:49 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::4f) by DM6PR11CA0066.outlook.office365.com
 (2603:10b6:5:14c::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Tue, 22 Feb 2022 15:11:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 15:11:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 15:10:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 07:10:58 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 07:10:56 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 7/8] netfilter: introduce total count of hw offload 'stats' wq tasks
Date:   Tue, 22 Feb 2022 17:10:02 +0200
Message-ID: <20220222151003.2136934-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220222151003.2136934-1-vladbu@nvidia.com>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d23024a0-bffb-46d7-5cad-08d9f615a60a
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5664:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB566446D310C170EED6D0AE48A03B9@SJ0PR12MB5664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o37Ctkt/8KDahe6VTwyHuSueiiJaM3dfkUrarRxJjqPGIu+v5h/JuWuOHyqYKN63htI5fgobKon9xdAn5AvKP1enQ7hHk9g3kDR3S0pxcWoqHpYlC6NpivcPRokHSSWW8F2QjWap3wx169CYVyZTJ2/yB0m7c043yJK56NNOKcbW25RUSbRIwQSIUwh2VgTZFCRfvWsQ/4oC48xljoUUWt5EaNQfg2qyIDIuivUVaTqDhJ8Eyxenon+2Svv1dYmOpWMPBr0hryDKMG6vreaDm0JZMQp8pkviani4+3w2RRCdzGkiccnUHjwATiopJevDAd+G/Zf85cFdA0y3+zZAvuM5psFrU3Ssc1lZx4Q/6KJEq7etjj+kwnIJfpxDtYvzhe7VH341v5Sa1cLfJS662GDORTuW90aFzwgMmY+triUfRxRfZWrI7IBuOcSKajcN20cf/L3+uBfZs+UhuUB/nE/ABYgM/B7B6R6WzF/nG3DncVQnU9L+PMHHuliZqncnU2BneH1vqFD3oj/fEXZ4Qt3hPl7zYa/SBuV5l9d/h9EWPprB2H+0p1LIGfnb3zsHN+1xO2tldtZqCtLzAzXp5hWE7IcxKwrNgIVinNvvEOAbXQodwAT7GvIGi/mRvCq9dKITJRMkItJOk+iZdeoM5vxfbMYH0GxIFu6eiwNWV2Oiy/3ZV7MHSyDxg2IslJi17wG2kNxf+Rics19qTMDrvw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(6916009)(356005)(54906003)(5660300002)(8676002)(2906002)(36860700001)(40460700003)(86362001)(81166007)(26005)(336012)(4326008)(316002)(8936002)(426003)(107886003)(6666004)(70586007)(2616005)(70206006)(36756003)(7696005)(186003)(47076005)(82310400004)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:11:48.8672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d23024a0-bffb-46d7-5cad-08d9f615a60a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5664
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To improve hardware offload debuggability extend struct netns_nftables with
'count_wq_stats' counter and expose it to userspace as
'nf_flowtable_count_wq_stats' sysctl entry. Increment the counter when
allocating new workqueue task and decrement it after
flow_offload_work_stats() is finished.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netns/nftables.h            | 1 +
 net/netfilter/nf_conntrack_standalone.c | 8 ++++++++
 net/netfilter/nf_flow_table_offload.c   | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index ad6058d2b5f9..60b3905c0ae9 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -11,6 +11,7 @@ struct netns_nftables {
 	atomic_t		count_wq_add;
 	int			max_wq_add;
 	atomic_t		count_wq_del;
+	atomic_t		count_wq_stats;
 };
 
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index cebdf389f7eb..4ec49ff6593c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -624,6 +624,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_COUNT_WQ_ADD,
 	NF_SYSCTL_CT_MAX_WQ_ADD,
 	NF_SYSCTL_CT_COUNT_WQ_DEL,
+	NF_SYSCTL_CT_COUNT_WQ_STATS,
 #endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
@@ -1012,6 +1013,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_COUNT_WQ_STATS] = {
+		.procname	= "nf_flowtable_count_wq_stats",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 	{}
 };
@@ -1155,6 +1162,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_COUNT_WQ_ADD].data = &net->nft.count_wq_add;
 	table[NF_SYSCTL_CT_MAX_WQ_ADD].data = &net->nft.max_wq_add;
 	table[NF_SYSCTL_CT_COUNT_WQ_DEL].data = &net->nft.count_wq_del;
+	table[NF_SYSCTL_CT_COUNT_WQ_STATS].data = &net->nft.count_wq_stats;
 #endif
 
 	nf_conntrack_standalone_init_tcp_sysctl(net, table);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 82cd78c8eb25..ff52d903aad9 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -969,6 +969,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			break;
 		case FLOW_CLS_STATS:
 			flow_offload_work_stats(offload);
+			atomic_dec(&net->nft.count_wq_stats);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1054,6 +1055,7 @@ void nf_flow_offload_del(struct nf_flowtable *flowtable,
 void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow)
 {
+	struct net *net = read_pnet(&flowtable->net);
 	struct flow_offload_work *offload;
 	__s32 delta;
 
@@ -1065,6 +1067,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
+	atomic_inc(&net->nft.count_wq_stats);
 	flow_offload_queue_work(offload);
 }
 
-- 
2.31.1

