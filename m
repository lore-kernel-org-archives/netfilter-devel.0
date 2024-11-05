Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2088.outbound.protection.outlook.com [40.107.22.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BF1D362B;
	Tue,  5 Nov 2024 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801244; cv=fail; b=cni7yjpFj+yZLEBOZMJpcxVtPEGhPI1Sv619WYfvPkB6kaT0LlDFUrLjGrtyHElKE3sx2t4fazjRmEUV2/E1jFWcGFXUfule4IDs/BbaXIyQQZlSZ0835IATWga8Vqub6Dll+3mWePjm3cP6eTxVVfNG9f95LxuorYnyoz/PzhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801244; c=relaxed/simple;
	bh=1Q4qCl3ortfIb9oBRpDQvSipMXyiQaagf0Kz+XUOqDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvlybVj+CWVWw4pqSip7X4V7i43rTWUslaMzhFtU3GElDKDnO9lPfau60sNMA2AKDkI+YqzdfFMu/ZWvggldLggDgw71Sv8yXnM4c5VmIDEWBKfiUBjNmeZmW+XWr2zEsgMyfH/W24wgJt1GYWgGuiAhF3kbrBALMWCHGpKyajI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=lGziBknQ; arc=fail smtp.client-ip=40.107.22.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="lGziBknQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sliXE7nsH69gy8Sesu3E8VkuTaaWD5h5RX6EB3G/IRsfMaC2tgSAl6PuzcWzG4A5TgNmgXSjuUVthmlcin6FkWOUFaLVrxzEg9FsM17Mti2reK5O4q8I+GuHSTQUD7x72lgHJ/e9/hPmTfkCErngVzIzx2YuZTdGBkgYVOdBQRzMrwcheImoBMjEplbQoELDP5s62Fxv99ykOrKD40NJuY8VkPnE00wX1Y7LUIO2+Vi7fiuQB9vtokVAJVFeOlwnYkgm2WipftMtKsQEtOWNBBZzxce5dEz4vIkHAAYuljUinH8YYHZy2+RVRDOF9qayp//AnlKwXfYMU95LlKqgtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpfOO9LdFqlvGOZ0J7Ru6IQpZU0EvDw/bG1up8j5CX4=;
 b=sM3jIWxI7XiCYg6fzrdUB7RVW2ZtTugxRFNADVFu1C0soLc8lE5QicUsDCNkU5zMCPBdb2kr7LBf2uqfyV+YoNWm8exl4WwdVeORNFUxk1YFtDlOO5cxIf9Ot2CQMFVSAhn8Gy7rpl4E6pJbB39vP9lg94sp2TBvqhYau1jloaMAjej9Qp4ZTKn2ZkOTdy4YVLFuyJ94Jf3TqARE9Oce5M1UUQ0UJgplf0NpaCv8Pvr3AIsbr152b+7FzP6Ye9qMEfB0OdQ4xnNJ2Tb6BJEsS4DWhw6tYzE9SCZpPxwl3OXtlTOYrO8hT3/U0ZBT7yAest64bk/sd8yGi75wksiG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpfOO9LdFqlvGOZ0J7Ru6IQpZU0EvDw/bG1up8j5CX4=;
 b=lGziBknQbPKG/XGtYp96YR5kHJE2tm2CUeKD07KRzFxi6ywYhyE+WmbiRHWn18//cZ0lv+e6gRQthzLCLJxtxPO1FPXuvvVL8jqly1iZjSZ+CQFtrXlJPJGg1Y2tbkF4GCexkgTMCBPFDi0UDiDskPY3cZiRkMMStvMqPDZfFMCzMDd1HYZjGgdAXwA0123VFcxx7pI4Nz6ku6hcWO3J+a39+e1604MZiSKn/jrn7n8kKlZ5yRPpYEYZR10NtECWnrrEvnCPrX6G2/oshqt9UINVnYzGsFEbqBW/vTI1JuYjM12ndvIMdFgIjuw16s5avUVFWtLZDFjuWiXRc97+9w==
Received: from AS9PR06CA0554.eurprd06.prod.outlook.com (2603:10a6:20b:485::8)
 by PAXPR07MB8495.eurprd07.prod.outlook.com (2603:10a6:102:2b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Tue, 5 Nov
 2024 10:07:15 +0000
Received: from AM2PEPF0001C710.eurprd05.prod.outlook.com
 (2603:10a6:20b:485:cafe::a) by AS9PR06CA0554.outlook.office365.com
 (2603:10a6:20b:485::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM2PEPF0001C710.mail.protection.outlook.com (10.167.16.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:13 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2i024723;
	Tue, 5 Nov 2024 10:07:11 GMT
From: chia-yu.chang@nokia-bell-labs.com
To: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
        joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch,
        horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org, ij@kernel.org,
        ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com,
        g.white@CableLabs.com, ingemar.s.johansson@ericsson.com,
        mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at,
        Jason_Livingood@comcast.com, vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v5 net-next 08/13] gso: AccECN support
Date: Tue,  5 Nov 2024 11:06:42 +0100
Message-Id: <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C710:EE_|PAXPR07MB8495:EE_
X-MS-Office365-Filtering-Correlation-Id: e5a24a84-21c3-4875-be45-08dcfd819e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXhJQjk0eHhaSnAzY1J3U1RQcWNxdllYMlhTV0xMWmxuT0E3bDFBQ05Oc1FE?=
 =?utf-8?B?RTlza3dqdDNQcHlYcmJ4cjVsTzlQdHlKT3Q0RUEyUDMxd0VyUlFlelJCYWVZ?=
 =?utf-8?B?OHAvLzVhUGpTaXRoQWZ6czh1cXpqTldMY2ZoVXl2Wk9GbEtTaGxlVFpRVW5J?=
 =?utf-8?B?SXhLb0pBUzY1ekdKZFdURHJsZVk2MVY1cDJRb3ZpcVp4Vi9McGlEY09zajh2?=
 =?utf-8?B?c2pkc3QvS0liZmlKWlFVN3ZsTFRSRDRqSWJ4YnowcVd1VnJZdHhnR1B1bFYw?=
 =?utf-8?B?Vi9Vd0REdXIxT0UveFh0SDg5TlFJbWNlbFgvUmd6RlVwWmtzNTlKYlVDWGtG?=
 =?utf-8?B?Nm1HRG5Ob0JCWE8xYkFQUG9DbGorcVEyZkVYMVhQVkpaTm5VNmFuYUV5Z0N5?=
 =?utf-8?B?cVV3NkJDQlBuSkEvT2dPYUM0ZUJZZGt0NFp1djRJZ1VpcU5RbE1RRmpjSlFD?=
 =?utf-8?B?UnIySHRqY3VxZWg0ejRNVDEyMjllWktkUUhWU09LUWx3dmVJSTU4ZTFoV2ow?=
 =?utf-8?B?UHlXSGNzenkwbjVBajViT3ZITnllc1Uwd0FEeWwvdVhzaUU0dW9JOVMwc2ov?=
 =?utf-8?B?RVBxVExWTXo3RjM5RUd5UVhDNGF1eFNaay9WWHVjb0pxazE5Slh0OThuYWor?=
 =?utf-8?B?OU1UYWxKWkM5d0YrKzIrNjVQTUdsSXVpMklDK3h6Vm5mU1dCMmtlSTc3TGNY?=
 =?utf-8?B?c29Kc0YxS1lHZ3B6OUx6VnpkV0ZzMGxlZEJ0TUVZemRsa0haQU1TZDVRK0h2?=
 =?utf-8?B?bFJZYUNzR3gwM3lOR2VNckZidXVscnRlSjFjMEN2bVZveDdBYzZwbmJWTXky?=
 =?utf-8?B?aEpDb09rSUhaOW5FQTkxV1NVZlhiTkVqK0VKcmMwRWZiT3JBK2daL1RUbUNw?=
 =?utf-8?B?bGdrYnlvOGZ5UXJIWGtUNlVvc2JqeE9QRFdSLzZjSFdENC9FcnhOYU9QZlZo?=
 =?utf-8?B?SHNRZjlyNlpvUyt0WjM2RTNwNmd5V1pkM0EyZmFpckJBZ2RGdlk3MEdGNnlj?=
 =?utf-8?B?Z2F6dDVZdStGbk5zSkxXaTY0SFhSUEs0eGt0Y244SjNzQTVTb1dDWkQ5eFJ1?=
 =?utf-8?B?TlRjZ3RXR0FGamk2VkFSYjFWRjZDUmlsNzFGdHFWRFpyTFdRdlFSUk5zR2lx?=
 =?utf-8?B?MFFhcnBOby9CejdqbUpsSkd2VER2dllJT0RXVnhJdTAxczlHVkExZTB2cW0r?=
 =?utf-8?B?L2QxT0lOWjNPaHVVWlo5ZTdjdE5CVGtrdVVHUmE3TlBIcmt0SzVjVS80b2pj?=
 =?utf-8?B?WndFd3RxcVBCaHNQQmdQOTByNS9nRUYyNHlBbm9uNkVUYVIvbmhkWFVFNDdZ?=
 =?utf-8?B?N3JlOGlUL0habS9CZWkrbWEwZjJNVnMzeFJnb0dHcFh1c2ZTb3pyRFREY2Zs?=
 =?utf-8?B?RjdyZlhaTjBkbmRFTnE0ZVNVVHcrMms4NE1xa0Z6UnhhOURZb3JNRm05dHVq?=
 =?utf-8?B?WVZ6SXppK0prMEpzeUU2L3I3V2FFMUV6OEo1bndPb3NsL2hnUHphRUtUOTBX?=
 =?utf-8?B?MytxYWdGeTNqSU9PaVNaRlliTnczUEw3YndvRlpkbWJBMUNWcGJLZWtyUkV1?=
 =?utf-8?B?K2dZNGszT3N5NGt0d0g5MnQ4T0RkalVOVUFpcTJEakNyUkFXNUtyTnFKa3d0?=
 =?utf-8?B?aXRjRXNZb1NXbnZ5WVY3QnBac2ViTU42RE5Xbi9zM2FCTHBld0VyZWtqbW0z?=
 =?utf-8?B?LzMrYXBBbUhXb29kb1A2SDkzRDhEMmxMM3AxZWtoUjZqV1lrUVY5elJGbHJO?=
 =?utf-8?B?QlNsYWZadFVOWUZBbzhxc05hM0prTS8zMkY2Y1Rpb1pTbGN2c0hiUFBLQ1l6?=
 =?utf-8?B?VXNFbXFoOGszSjJqdW9iS0RKdHZwU3YzU09GSXFNV3hXbElZZENiaXc0WVZI?=
 =?utf-8?B?SElCNER2eGlITjc4blF1WXZWTVE0ZkZ5d2Fua0lOOVQ3em9JYThLMTc4RkI1?=
 =?utf-8?Q?slQ4D8Tlc1c=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:13.2264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a24a84-21c3-4875-be45-08dcfd819e9d
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C710.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB8495

From: Ilpo Järvinen <ij@kernel.org>

Handling the CWR flag differs between RFC 3168 ECN and AccECN.
With RFC 3168 ECN aware TSO (NETIF_F_TSO_ECN) CWR flag is cleared
starting from 2nd segment which is incompatible how AccECN handles
the CWR flag. Such super-segments are indicated by SKB_GSO_TCP_ECN.
With AccECN, CWR flag (or more accurately, the ACE field that also
includes ECE & AE flags) changes only when new packet(s) with CE
mark arrives so the flag should not be changed within a super-skb.
The new skb/feature flags are necessary to prevent such TSO engines
corrupting AccECN ACE counters by clearing the CWR flag (if the
CWR handling feature cannot be turned off).

If NIC is completely unaware of RFC3168 ECN (doesn't support
NETIF_F_TSO_ECN) or its TSO engine can be set to not touch CWR flag
despite supporting also NETIF_F_TSO_ECN, TSO could be safely used
with AccECN on such NIC. This should be evaluated per NIC basis
(not done in this patch series for any NICs).

For the cases, where TSO cannot keep its hands off the CWR flag,
a GSO fallback is provided by this patch.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/linux/netdev_features.h | 8 +++++---
 include/linux/netdevice.h       | 2 ++
 include/linux/skbuff.h          | 2 ++
 net/ethtool/common.c            | 1 +
 net/ipv4/tcp_offload.c          | 6 +++++-
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 66e7d26b70a4..c59db449bcf0 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -53,12 +53,12 @@ enum {
 	NETIF_F_GSO_UDP_BIT,		/* ... UFO, deprecated except tuntap */
 	NETIF_F_GSO_UDP_L4_BIT,		/* ... UDP payload GSO (not UFO) */
 	NETIF_F_GSO_FRAGLIST_BIT,		/* ... Fraglist GSO */
+	NETIF_F_GSO_ACCECN_BIT,         /* TCP AccECN w/ TSO (no clear CWR) */
 	/**/NETIF_F_GSO_LAST =		/* last bit, see GSO_MASK */
-		NETIF_F_GSO_FRAGLIST_BIT,
+		NETIF_F_GSO_ACCECN_BIT,
 
 	NETIF_F_FCOE_CRC_BIT,		/* FCoE CRC32 */
 	NETIF_F_SCTP_CRC_BIT,		/* SCTP checksum offload */
-	__UNUSED_NETIF_F_37,
 	NETIF_F_NTUPLE_BIT,		/* N-tuple filters supported */
 	NETIF_F_RXHASH_BIT,		/* Receive hashing offload */
 	NETIF_F_RXCSUM_BIT,		/* Receive checksumming offload */
@@ -128,6 +128,7 @@ enum {
 #define NETIF_F_SG		__NETIF_F(SG)
 #define NETIF_F_TSO6		__NETIF_F(TSO6)
 #define NETIF_F_TSO_ECN		__NETIF_F(TSO_ECN)
+#define NETIF_F_GSO_ACCECN	__NETIF_F(GSO_ACCECN)
 #define NETIF_F_TSO		__NETIF_F(TSO)
 #define NETIF_F_VLAN_CHALLENGED	__NETIF_F(VLAN_CHALLENGED)
 #define NETIF_F_RXFCS		__NETIF_F(RXFCS)
@@ -210,7 +211,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID)
 
 /* List of features with software fallbacks. */
-#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |	     \
+#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | \
+				 NETIF_F_GSO_ACCECN | NETIF_F_GSO_SCTP | \
 				 NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
 
 /*
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6e0f8e4aeb14..480d915b3bdb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5076,6 +5076,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_TCP_ACCECN !=
+		     (NETIF_F_GSO_ACCECN >> NETIF_F_GSO_SHIFT));
 
 	return (features & feature) == feature;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 48f1e0fa2a13..530cb325fb86 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -694,6 +694,8 @@ enum {
 	SKB_GSO_UDP_L4 = 1 << 17,
 
 	SKB_GSO_FRAGLIST = 1 << 18,
+
+	SKB_GSO_TCP_ACCECN = 1 << 19,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0d62363dbd9d..5c3ba2dfaa74 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -32,6 +32,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_TSO_BIT] =              "tx-tcp-segmentation",
 	[NETIF_F_GSO_ROBUST_BIT] =       "tx-gso-robust",
 	[NETIF_F_TSO_ECN_BIT] =          "tx-tcp-ecn-segmentation",
+	[NETIF_F_GSO_ACCECN_BIT] =	 "tx-tcp-accecn-segmentation",
 	[NETIF_F_TSO_MANGLEID_BIT] =	 "tx-tcp-mangleid-segmentation",
 	[NETIF_F_TSO6_BIT] =             "tx-tcp6-segmentation",
 	[NETIF_F_FSO_BIT] =              "tx-fcoe-segmentation",
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 2308665b51c5..0b05f30e9e5f 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -139,6 +139,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	bool ecn_cwr_mask;
 	__wsum delta;
 
 	th = tcp_hdr(skb);
@@ -198,6 +199,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 
 	newcheck = ~csum_fold(csum_add(csum_unfold(th->check), delta));
 
+	ecn_cwr_mask = !!(skb_shinfo(gso_skb)->gso_type & SKB_GSO_TCP_ACCECN);
+
 	while (skb->next) {
 		th->fin = th->psh = 0;
 		th->check = newcheck;
@@ -217,7 +220,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 		th = tcp_hdr(skb);
 
 		th->seq = htonl(seq);
-		th->cwr = 0;
+
+		th->cwr &= ecn_cwr_mask;
 	}
 
 	/* Following permits TCP Small Queues to work well with GSO :
-- 
2.34.1

