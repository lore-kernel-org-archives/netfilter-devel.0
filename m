Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2059.outbound.protection.outlook.com [40.107.249.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0259C1F9AA4;
	Fri, 27 Dec 2024 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326781; cv=fail; b=NrKnFLMYtRgzepdZFKFavV9jf5R8kXcBCutwwnr+0maFUdu9eXeBthclxGtluE6ETb5BfmBlrGkcoMUPcjkPqsmTQbOpe9El4YmOYWglw8iPgu6H50RSz5e7jkMVFMx8HAAFC8i4yll4DEG2ueI3yz/2JndTsjhrJghYzsl3+p8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326781; c=relaxed/simple;
	bh=GP62ZfWUyy0KbnGWOga0bPjibK4UvOphB5r2d5YGoSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJ6f2MILq1TNHdajxGekyRKrkUdJHDucvlAI5bCzZRDUM6Cz/zaOFGtI9CtzJ16Hh0Yc1s7M03eOY1g58szbr1jwK6NyoL7Ubby5VB10AToUbA05DpY3VDLhL/dRLzEhf1rhYEmvNaFInPjOGkVi7QhZwY0+F5qpV8yJL9thmXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=r3jX2mH8; arc=fail smtp.client-ip=40.107.249.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="r3jX2mH8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMMupRA8Vt7fMCp7TVucXJqlyHHQehq9McxKkePBxgdTrc9layexo5VpbHhJ/weIHw9xYo0d89jm4Ave+gxPTv+8OzXKPvX1mQgaR1QMhABMwYrnKIZGhfdIY1bUyqVkO+DL6fuC1lqVaZ18EdpCZi7kOX+G39753CN1ApulfDsobS/FS8mNhoOPx+e6XjVCjYABXBqVZ8P8ZtUQfhO1h0FQaPvkEmj9MMcmZF02hvm1iXIFtWPDgcVzie0kHgaUsAJyigbjJI76qsMW+Z0BQSzj9G5Cx9SvHC/VuEl47L/i3iHBsliBtMWCFUbkG5Rrmn1mPpIDZUnTU1tiMqYE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VqEgAWYI3pftBss5XPYOgP4FcqnsRU8olVRBdFFM38=;
 b=kpnBGJRCIkpDxyHtjWAz99va07Ga+4FVAWOZldWZUvQpOpCfDR3BfrzmIuVdSPvvYHwWrOTuJXszgb+ETVj31EegDffuL60gnmdm+E3E01B2A7vEdj0dhrfLgwoa+aHYLe2GbxiVDMRvkjFkqFVYufqqnYOvqJO843ujZnb2lPE1HezubSR6BWD7waRg5CgVLbY0nLrPMM9TbRYQpt5gQsVPhthBQqFsCkIAkpb3cZ9/Xub1tGjULe3ECzEFtmOKsHsCFfmuwVaVQUlqXy53JZyn9LCQZtqYh6ftj7/v3orsZQNaTCMRZJRBHqbVdQKUxg0Q5w1aK22fHDEAlSCLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VqEgAWYI3pftBss5XPYOgP4FcqnsRU8olVRBdFFM38=;
 b=r3jX2mH8MIwLsW3RPWr5VNbpA3xPl1kFCPQyeYEB3T47DMJfE0s7XTv2umT47OBzeQe2ZUclzRPwoJwSr1QefOiPsuXasKgHICZ5n/dqEUtzhEYt+SxpqWBicJ7afVyPoxvPEQKX11mgaTzCBY5hG8MUeRTT76jkQelwREwdiWRsWMXIYT2KLMx4AnqQyB9572j0Z2SawHQ+apdvREPrFjFrZkljO/egxWJOyFe8PgXzttHpqQi28MBKzAYDEXXdG8KjSiyubXvVYjWs/7PtsEooPjl38CuP3tth+ighQTnvy/R+2GN5KOZkaVhw0ANes0DAjkTWArwUvoDhpqQ25w==
Received: from AM5PR0601CA0066.eurprd06.prod.outlook.com (2603:10a6:206::31)
 by AM7PR07MB6280.eurprd07.prod.outlook.com (2603:10a6:20b:142::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 19:12:52 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:206:0:cafe::df) by AM5PR0601CA0066.outlook.office365.com
 (2603:10a6:206::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:52 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2a011940;
	Fri, 27 Dec 2024 19:12:52 GMT
From: chia-yu.chang@nokia-bell-labs.com
To: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
        joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch,
        horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        shenjian15@huawei.com, salil.mehta@huawei.com, shaojijie@huawei.com,
        saeedm@nvidia.com, tariqt@nvidia.com, mst@redhat.com,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, ij@kernel.org, ncardwell@google.com,
        koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com,
        ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
        cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
        vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v6 net-next 10/14] net: hns3/mlx5e: avoid corrupting CWR flag when receiving GRO packet
Date: Fri, 27 Dec 2024 20:12:07 +0100
Message-Id: <20241227191211.12485-11-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF00009B9D:EE_|AM7PR07MB6280:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: bea8b68d-13e1-4a88-1119-08dd26aa7605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Hz3nyMsWcjLYzPz6RyIDke8dTROTQTnUU1r/RMWsLMi5RJ3UxBCg7Iin9Wg?=
 =?us-ascii?Q?NiOBxtfzSxrrg+f5FgEZWFxM5Uz047B0mqE2v/I7ESRJWCd5nepP69F2B3PF?=
 =?us-ascii?Q?s2PprwvRfm9zbGCnZ7sQfD+ck/QCalHwB6zSXnSjKqRkSU/MHhpvPrLXykkL?=
 =?us-ascii?Q?tigdjIiGil4fxvxIVUicM4gLR3U3zg+R8w8ftIasX8Dxw+tb5Pt4XQZ7lCYu?=
 =?us-ascii?Q?TFy41MheiVcZj/Ul/ngs3jS7qKJHWygl+Ub/4yC0Ag7pLMOd3HsZHKp76XzS?=
 =?us-ascii?Q?Jsu8xbqEH01HzKT/aj9MdoiWqzPMM75WL+3SiHCOhYywym4ZhIooohJk+4TI?=
 =?us-ascii?Q?TH3G1M4MO0j6Sw84u4vclIFLeTTpfxq3F3kFE3iXFReeS7zeWMo5HFoJg5Vb?=
 =?us-ascii?Q?+0wvlFeB5dxirNvxmlb83EY81roEECyIiYlIuiSfy/idNddbEf/kDujjIuV/?=
 =?us-ascii?Q?C1hR3zeXVx1z4pkdiPE3pt8ESIrSWh+8n8XDK8ALFNtEswI7KHutFljSRlF6?=
 =?us-ascii?Q?FIIwDQPb70V762ansZE+G8zZzX8MLkVDw4CTVa7W9cBSzbCFEOdCU+kRmul4?=
 =?us-ascii?Q?3BsuvhGmqMllW2xEkE2g5jJ7yI4cLkBuW4rvcRTFC5GTsAE2Q6B7RTjPOcXA?=
 =?us-ascii?Q?KUqzf39gLxg3I4uNp7DAXnjgKaExy2TQykMIqJuGUONh8Z+sxlvpx4uWJIeQ?=
 =?us-ascii?Q?AJeiULwJ1pzHhlJv//dEhB0N6Un9q9sYB/ONvs4neNN37W9spYsaVYewEbCL?=
 =?us-ascii?Q?/7bqP1WkXCBAxu9Yhgg5OF+CRxyzjv1vxpBqVN+3ClDtvB+8W2Nh0uRsVMuI?=
 =?us-ascii?Q?ty/X0fG0Yc4N7H+iaWcp9ZF3ZtFzIOGFqK/dH2WFXM3GnoCKM/6c6oxcRIGu?=
 =?us-ascii?Q?29xZtmZwo/QjPsjB6P62lGP2fC/yeYeWnoFZRgp0DysSlKSKiRlir3fEqCVF?=
 =?us-ascii?Q?WyTsRTP0Gg2q25df26WNm8JrIqJbzMFIGd1DgCwzOGH8OgV2jhU4Hx5BnSDA?=
 =?us-ascii?Q?Yw6m6Iy+u/e4FwlsrvvBOoY6oX2N1v8NvrlwA3ZdOj9iFZxEvY84rbTkYu77?=
 =?us-ascii?Q?iN6QlV2CPSCdZWwr6gn+QZkA6sbXw08rm2wLgwN1bOrDGcUjqHeEuZItvTzq?=
 =?us-ascii?Q?Cm2RrZzZTt+hLOVPvdCGFU19MRRl7FMXFwPIL57FRzBfSYc/P0BN9L0a/t3b?=
 =?us-ascii?Q?8UTe7fMQ+5zamrtxXSQ+NtnBS08r+zAToMDx5VfdQXywfdLUOIvEpV2QNX3j?=
 =?us-ascii?Q?VqP14bHE1LO1wuqgCKbVx7RN0KzZzZXqSlS5x6Xv2OYOhTgGCbP4n6xY+Hn1?=
 =?us-ascii?Q?D2exdz5DfklOjJGPv8DxBtKwHbJddnW/8FsrSL/foMiYfbcdWMULZAbBowbo?=
 =?us-ascii?Q?s00/MuyK7jf7++1NJvLxJ4AWlOwL3x46P4dGRaR2VhU70MrvlbQS+kQh0+SC?=
 =?us-ascii?Q?Zi87FoT1hHSWreXWXLikjJUCmNsAVVxg5GOxKbv8bjX2P1nPtOxX3n97e2cY?=
 =?us-ascii?Q?UtcJlQe70klCTjA=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:52.1880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bea8b68d-13e1-4a88-1119-08dd26aa7605
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6280

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

In Accurate ECN, ACE counter (AE, ECE, CWR flags) changes only when new
CE packets arrive, while setting SKB_GSO_TCP_ECN in case of not knowing
the ECN variant can result in header change that corrupts the ACE field.
The new flag SKB_GSO_TCP_ACCECN is to prevent SKB_GSO_TCP_ECN or
NETIF_F_TSO_ECN offloading to be used because they would corrupt CWR
flag somewhere.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 43377a7b2426..a6238a625d6f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3855,7 +3855,7 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 
 	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 	if (th->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 
 	if (l234info & BIT(HNS3_RXD_GRO_FIXID_B))
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1963bc5adb18..b9611cc223b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1286,7 +1286,7 @@ static void mlx5e_shampo_update_ipv4_tcp_hdr(struct mlx5e_rq *rq, struct iphdr *
 	skb->csum_offset = offsetof(struct tcphdr, check);
 
 	if (tcp->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 }
 
 static void mlx5e_shampo_update_ipv6_tcp_hdr(struct mlx5e_rq *rq, struct ipv6hdr *ipv6,
@@ -1307,7 +1307,7 @@ static void mlx5e_shampo_update_ipv6_tcp_hdr(struct mlx5e_rq *rq, struct ipv6hdr
 	skb->csum_offset = offsetof(struct tcphdr, check);
 
 	if (tcp->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 }
 
 static void mlx5e_shampo_update_hdr(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe, bool match)
-- 
2.34.1

