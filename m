Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57015C47096
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC59613E7
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFCMSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:18:02 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:36718
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229747AbhFCMSC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 08:18:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDzhLW4BMvxzEro3To+k5dmEPKlXaBi4aYyR8HRKEkMNjm4/6A/LByrRQWjVQB4uA3et273mlpA8Og5FUpmRAPXaJEnwaCUIJRP172GCM3axfdXuScbl1DpQGPrfJYOsm268FRy+CCCvzc2HNtEBUjUJJmgDR7vkp/Y0ZmIxWpjDMMKW0CkUEzrTWgVJknzq2hLX3JSjTOd3EsbDwLMirwffWDwh/Py0YjeJ3qjqLKOHdEXGExHBOCL82Ik8gz1j/BBou3K5Rs9T+YymFTWcebaadeKf9YySuumn9hxSrPT/3JItVspd4RQbLf22O0+p0o5QCoe++mG1jD/JbP7C6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktHpK3juQV5SS5cKHPUrKh26phTBsUa5ID1wP4XYiCY=;
 b=i9CgMGiIpc06at4EgVpoSWEXV+PF3E93EjVvU/V4tgs/p6tg+D6kp7EQwIvbH1YUvMfHPYqVt/4RN9bM0Av0yv40ybILO13gDwTPm9KW9wX56EYYt5tkjwR0OWIitAat+X2mzG6SLPIAkwwe/6nKg0S/I7jGMZNJmWDukphzo0IJrtzSxS7vnVSrq8rG8pTO8fudnrE3ulge4CTuC6CTRyQiOshoyqJdGG7ejvBh5ZUtcfXddOInkb+SPI1HtrqQkkJHtdwwusVJgBc02vJO9iNkyeiGswaVJ7FC/eYMFQDYwXUFoak+zP6nBYzkBZYr/R7iDpE5SzhFvOKiuwUFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktHpK3juQV5SS5cKHPUrKh26phTBsUa5ID1wP4XYiCY=;
 b=FtuS2WQWVzxE/KIKSvb2eaUxx5kMhvY6R24xEVFs9USt0rcdN2cgBe32VmLZXq/ik29uW/GNagKV2+6QoYve+EJm/ItxbJVwGUK0vj0bCLq1kRCGqbc7J//delas7uXJe2eNsnbd0wFlLRZLBxzLMFtQDPPb2UkhIHllE5IPpeQajMUWluPE+Cu7JdFkKEPgtIYJlvyfPpYlwgwKw2MF6/3AsfmBq0ki00zAOnCXbe4mHbfEpNBJ6HHuRMVOFzNbjYY9sPitR53ztsjV9FUad0lNVjXRB1waWJPPd5RRfKqsaNsvL2VjEK5d9XzllS5d1+RSEL3S91xnWmXRne3JdQ==
Received: from BN0PR04CA0135.namprd04.prod.outlook.com (2603:10b6:408:ed::20)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 12:16:16 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::24) by BN0PR04CA0135.outlook.office365.com
 (2603:10b6:408:ed::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 12:16:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 12:16:15 +0000
Received: from c-141-149-1-005.mtl.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 12:16:13 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH nf-next 3/3] netfilter: flowtable: Set offload timeouts according to proto values
Date:   Thu, 3 Jun 2021 15:12:35 +0300
Message-ID: <20210603121235.13804-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210603121235.13804-1-ozsh@nvidia.com>
References: <20210603121235.13804-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c31dcaee-6bb6-4100-eaf5-08d92689634c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5224:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52242B40DB0E0922CC5691F7A63C9@BL1PR12MB5224.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rF/FdRyUUxpxufYp6n0JaZqoYHqUyaiJl0ZrAmgKCK1ZZTJRScpQl+sTJAg0CmgMWeWGcmRa0icqRFoSkoanPzqOvfsAXJwB9hRb0S2JghtKZbJQtCLwPcoPvVsM4h71IzoC55OWhgAp5NPy2yNJsHdjv7HRGWoBbKuLoBlI0eC7ZQjw/oASO5gf5ek1K8uj9kDL0n/qz9CR19etsDSKpWq4GkUKmu8z8a8QNgBguUVUmZ2/vrrp8PDXMFB2+SSHIuSyV2e52jJXtgzdjG6RJ8d/dqQM/PPp3PKUhrNB5dqZIONdZWvodMVoOhSVAuZkYR3Rs9LU67nIPE7qUxT7Q8qfw/9YHQky7QsJb0Bu3MNBtx4aLm5Trb6/nV4NS82XJoYpeksXfp0YmJq9KLaHbGo5RokOIpWKvHBgTCPvjkLCWt6TowEiU3wb6YwpPmdtZWUueSzV4fgb/uRd04zUHosMAqnyHwkAJo+jVRcXi2gQ3DFDNDOXsBY7CU+t2aG/i/eLO8a8ahbb565Zd5sYB8ApvpNjjDnX370JYwCORJwegCj6hRKn9B0gIQyaXjknSNakFFaKuGmWZFUNrxrOHuZPc5c1Tla37y8Q/tVy7nQ/vIZRMz7iodMUr+gecN+CrONBrTA3Dalb3yHqicNlCw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39830400003)(346002)(376002)(396003)(36840700001)(46966006)(5660300002)(70586007)(4326008)(47076005)(86362001)(336012)(1076003)(7636003)(70206006)(54906003)(8936002)(356005)(36906005)(36860700001)(83380400001)(82310400003)(508600001)(8676002)(186003)(26005)(2616005)(2906002)(6666004)(6916009)(107886003)(36756003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:16:16.6217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c31dcaee-6bb6-4100-eaf5-08d92689634c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently the aging period for tcp/udp connections is hard coded to
30 seconds. Aged tcp/udp connections configure a hard coded 120/30
seconds pickup timeout for conntrack.
This configuration may be too aggressive or permissive for some users.

Dynamically configure the nf flow table GC timeout intervals according
to the user defined values.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    | 47 +++++++++++++++++++++++++++--------
 net/netfilter/nf_flow_table_offload.c |  4 +--
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 48ef7460ff30..a3647fadf1cc 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -177,6 +177,8 @@ struct flow_offload {
 #define NF_FLOW_TIMEOUT (30 * HZ)
 #define nf_flowtable_time_stamp	(u32)jiffies
 
+unsigned long flow_offload_get_timeout(struct flow_offload *flow);
+
 static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 {
 	return (__s32)(timeout - nf_flowtable_time_stamp);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1d02650dd715..1e50908b1b7e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -178,12 +178,10 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 	tcp->seen[1].td_maxwin = 0;
 }
 
-#define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
-#define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
-
 static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
 
@@ -191,12 +189,17 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (!l4proto)
 		return;
 
-	if (l4num == IPPROTO_TCP)
-		timeout = NF_FLOWTABLE_TCP_PICKUP_TIMEOUT;
-	else if (l4num == IPPROTO_UDP)
-		timeout = NF_FLOWTABLE_UDP_PICKUP_TIMEOUT;
-	else
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		timeout = tn->offload_pickup;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+
+		timeout = tn->offload_pickup;
+	} else {
 		return;
+	}
 
 	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
 		ct->timeout = nfct_time_stamp + timeout;
@@ -268,11 +271,35 @@ static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
 	.automatic_shrinking	= true,
 };
 
+unsigned long flow_offload_get_timeout(struct flow_offload *flow)
+{
+	const struct nf_conntrack_l4proto *l4proto;
+	unsigned long timeout = NF_FLOW_TIMEOUT;
+	struct net *net = nf_ct_net(flow->ct);
+	int l4num = nf_ct_protonum(flow->ct);
+
+	l4proto = nf_ct_l4proto_find(l4num);
+	if (!l4proto)
+		return timeout;
+
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		timeout = tn->offload_timeout;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+
+		timeout = tn->offload_timeout;
+	}
+
+	return timeout;
+}
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
@@ -304,7 +331,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 528b2f172684..f92006cec94c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -937,7 +937,7 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-				       lastused + NF_FLOW_TIMEOUT);
+				       lastused + flow_offload_get_timeout(offload->flow));
 
 	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
 		if (stats[0].pkts)
@@ -1041,7 +1041,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	__s32 delta;
 
 	delta = nf_flow_timeout_delta(flow->timeout);
-	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10))
+	if ((delta >= (9 * flow_offload_get_timeout(flow)) / 10))
 		return;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_STATS);
-- 
1.8.3.1

