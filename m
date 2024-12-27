Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC611F9AAB;
	Fri, 27 Dec 2024 19:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326783; cv=fail; b=kjagSiUh1FNuMvr9HDJ6hYh9GLj+I1YeVIjX85HdgGgkTU4XTIsKtNqrnZPLkKV+Yoa3hOKIzYzeka7RAulubyJ33qCxmlXPQG7xHfjFkIT8Dia6f/Z3Bpo/crqfqQhAMy4aLVEQiSR9J8ZzRHphWkdKSt+e55dgGxtAh/YhlUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326783; c=relaxed/simple;
	bh=umHpARJWnkKOJ0bJpCO+IC2lpIieyXxdWWWOs007rtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cM6xVXFQSSnzNlXH9rJ5qBTCCFNPqO8tdK54wuGe8Cbojo4qZq/h3L+F5AnSXzinfjSyQet0X4IrwIhr3+Pm3BY5l6nTZOxwzK832L+zj6wVsHZ2U3ag98JHcZxcAxMtDaQmvaygeHME6wioAOeEPL8RaxuTufuNQNutaBxJtXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=kycMgfOw; arc=fail smtp.client-ip=40.107.22.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="kycMgfOw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfjjscPKJMiaOzFtnKnEJh5uVz3GKQANGmjcMdKxh6je2W6yj+c9RHDD3HCUwj2pbbyOY+Jq/udR4c0D4kT6oHb4hcNRrRZW29cMyWBMyXgWbXLk7SiTRu8s2qUUZgIGBe0R7gCiBulZxsf/Hpu1xQyRbLH7bUW+87vCkjb7YYz7RmLaiSHN6iIcgkDBK4bg9BxfL/xTGu5BZh7RyzfszSQMfqxhJkjQ+1C+z32EXa6cFxgvNcUKskofOUHBNA34zSmIAcoFi93CBlppk7VSVptock12Fn7d2/syMxouNOmHXssNA+h8vDqhNlpTLmwjkBVt2cuqBBktG0quWDka/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Y96pwwXluKBiDGedF/m9r1dWu57GoaAE8NL0KEOm3k=;
 b=AJ16DYJbCYZQC92Zbs9Ialzql+91tERwKRhr8dvtniiXBBGH3Wa1EqfRWs7phV46CNl6qKT4AVfBLmxHfqarRMVp1ii5i5HpYHsEkw3Y4FsUOEx7/yBnusVg8pIYe8LbWKY/Ko1219Dsnj/XWcJqLdulaA4d/YaetncHudW1AiUqWhdNfHYR4QmbTcBgYsyr8Ye8KaFheFiV0Y27FMaHIbMoWZfDjnR9owtcIsDBTqX+mkNvAMrgzlOnS+y7zymgnh6ehm4U/7iLM/qLsRQJ1/Y77QWk96uwLNzzCv/1UgT4nE1kSre+FF9XJc3JfcIvwloqBYLoBr7RxAEFsGfoMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Y96pwwXluKBiDGedF/m9r1dWu57GoaAE8NL0KEOm3k=;
 b=kycMgfOwaulAaD4mSTZay9aWTuKAsPVXg5Eau37b0ILPFp2fPlooMDt7vWPDElENMYEUT+q13t9zAMhXuhtTXTYEHGgG6+Up5VwoqmT4aX1ziOXwq8qqrDcv2T3qN9LE3R4wuTpMpEVV2vIF/nEl9IL5YKp1gv0nRfcvlUQlXr4cw6d4X/whQ/Q1jXbwj8F3Zusl9RdixHX5lwtAVf9W51sDjZhaLizc52Kw2VvSkLcFUoOBeq+l2bNtw8acl4OlxDTCTpCSgZ+FJKzFOMFsNneD58IZ3RSU38eM9rCuBHcCGRd7caxCm2ON8LdWpPm54aat7ZGTjssSbMEgNQxk2g==
Received: from AM5PR0601CA0078.eurprd06.prod.outlook.com (2603:10a6:206::43)
 by VI1PR0701MB7007.eurprd07.prod.outlook.com (2603:10a6:800:197::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 19:12:49 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:206:0:cafe::2b) by AM5PR0601CA0078.outlook.office365.com
 (2603:10a6:206::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:49 +0000
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
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:48 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2Y011940;
	Fri, 27 Dec 2024 19:12:49 GMT
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
Subject: [PATCH v6 net-next 08/14] gso: AccECN support
Date: Fri, 27 Dec 2024 20:12:05 +0100
Message-Id: <20241227191211.12485-9-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM3PEPF00009B9D:EE_|VI1PR0701MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc0f401-7eae-48d9-62cf-08dd26aa7410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUQ1RUsrejBmRGtiQXZyWVRQQTZTeDhIQmlHTjNDdm1BZWxTdHBRcDNodGl0?=
 =?utf-8?B?WTZsTFIzOHU0djI4cHRnd0FuSWZkdmZZbGNZYlQ2bkdoVFQ5c2xVVDdmMjhY?=
 =?utf-8?B?clF2Ly93ZUw4UkpIcWVzUmcvdjV4YklYOHMzSUp1eGhMRmk1VldEQVhERElQ?=
 =?utf-8?B?ZVRDeVZZZUhZOXp6ZEFQaVdDQWR0OGNHWjA1UlN4N0s5ZnJxNjhySGJveExp?=
 =?utf-8?B?TGRDK3hTSjRwV2l3RGRIeklEeGVnQWJwWW9yWTRnYzRDTWJycUpFUVN6VU93?=
 =?utf-8?B?L2M2ZUY1TW5ZWGI3ZXRpMkZMNVA5bWNHRitoQUc5ZXVLOERWa0RzTm00c2wz?=
 =?utf-8?B?S3BVS2dCZytRMElRc2xNYVpYOFp1QStxZmxQdjBlaERLcko1emt4V0pMVXo4?=
 =?utf-8?B?aDJqT2ZCRWN6NktHU25xVTNDMm82cWtNRk1kajRWRE5DbHFobTlVMkpoN3BW?=
 =?utf-8?B?YU5vTDljSTI1MGVGNnNNNUgwMHhlSUsvM2Faby9oZGR5MEdOMU9vdEVncjZz?=
 =?utf-8?B?eElwODBkK1U4eVJ4YWQxelBTYWxGMmNBYVZqc2dCTzFqVjAwK09lVS9laGxq?=
 =?utf-8?B?UitJY0xBbjFpeWlNVzdOOURsdGE4RGlxUHhJU08wSmRNYmNoSWM4V3FsK2I4?=
 =?utf-8?B?Ulhwa1AvcnRiM0NCNFVMODNPUTFJN3k1b0lrellxOTNEZTVHdGplRXBFU1ZV?=
 =?utf-8?B?d0tXc0NjRHlQMTREcm5LNENlcFBJS2lKSjlKOWk0Qmh0NzJWRVdTdkhPUlAz?=
 =?utf-8?B?dDBLNjBURzY3WGQ1ekJGbXZ0eXZnZ3RvY01Jc2JhWlY2ZnZCTTQrNDhPY2xs?=
 =?utf-8?B?a0UzQjVEc1MxMDhQcjJhNlI5Ykx6Wi9pZmpYU0pKRCs5bGJob0JmNjZ0N3Fx?=
 =?utf-8?B?UFg5WTNtTFA4SHNzNUVRYUNrVHljWis3STFjVHBxaElYSjNQRWlOUEVQZURE?=
 =?utf-8?B?eFVaK1FlUEN0V3RaWjgrd3FTN1VoRGVDRnBxRUNvVFhST2tTYjhHaFV2VVJu?=
 =?utf-8?B?dk5yandNNnJSbU84UUJqMEtqQTc4aXcyVCtraUJ6VzFPNFB5RDFpMnF6MFhj?=
 =?utf-8?B?dTdiMkVtMXkyR2g2aE01TW5LMGd1Wlo0VU1nL0pSYkVGM0pWK2xnNWpuZWJn?=
 =?utf-8?B?SWErRXF6bnVmK2pZQXJOSEJac3ZSLzVpb3d2UXlDYStnOEpxZjVTR2dnTmFP?=
 =?utf-8?B?T2lkQTgyOUowSFhGMlBWeGV3WmVDWlZrVEsrc1YyRWZzZTJUdU1UUkttUGll?=
 =?utf-8?B?a0c3WEpZS2JsMEdpRGtOTkVjK1pXUDU1S0wyS3BNb242TzlEMkFQM1RneGtS?=
 =?utf-8?B?TWVWaE1BRFFDcTZsQXRnVG96b0pVN24vZHB1RDMvc0hJelpvcGd0anVNVUVQ?=
 =?utf-8?B?SWpZaS9uUXc2bHV0QmNZN1FYd2g5cFNNVFZxQ01xZktJVk4xUlVmQThYbThm?=
 =?utf-8?B?eTJoT0xqMWZvdW91ZTdLUDBjaGVjOEpsL09tWTJNNHJxVHl1c0ZTYk1aRmN6?=
 =?utf-8?B?eW1vRk9xQzVFY29hODVuT0Zoc09qV1VXcThyWUVuTnpEUzkvWjY5VVp1ME1q?=
 =?utf-8?B?UGpIbzlWL3A0WTJTZVRlVTZ6NjVYVFRDdlphT2ZGYWQ3d3FxNVRSaE5FNXdl?=
 =?utf-8?B?cVlxc05RZ25XR0owRzRNaVQybmZFSE1ZS3BOOVhhMTVWSHhmOUJVRmhkd29l?=
 =?utf-8?B?TW5yNkZINkcvUHBFeEY3RlIrLytGY2w5UE5vMUZDR2JlRHUzYnl0YzRNWEN3?=
 =?utf-8?B?OU5oR2tJZGRxd0tpcE0zK2Q1U29rcUQvMVVVOUtmYnVpSkI1NnNmNEsvd3Rn?=
 =?utf-8?B?WGZISDZXOVB6NzNZa1RkSXpIVUxhclVlaDYrZEdQOGh0RmYxNEczUzZxNzVP?=
 =?utf-8?B?UmNFVXUwY1lqTEJrMTdHSjkrZ0NNVm93Z1RJL21YaEljOWM0QW1OV3Ezemdj?=
 =?utf-8?B?ckFrRXJMZjh0M2drV1pvKzJKa2J4YUwxWEhzY0pSZHFUeFF3YWdXRURhK3FZ?=
 =?utf-8?Q?sgFWGGG2PefpIJDSHnNq71ZlLQJIbU=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:48.9067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc0f401-7eae-48d9-62cf-08dd26aa7410
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB7007

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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdev_features.h | 8 +++++---
 include/linux/netdevice.h       | 2 ++
 include/linux/skbuff.h          | 2 ++
 net/ethtool/common.c            | 1 +
 net/ipv4/tcp_offload.c          | 6 +++++-
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 11be70a7929f..7a01c518e573 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -53,12 +53,12 @@ enum {
 	NETIF_F_GSO_UDP_BIT,		/* ... UFO, deprecated except tuntap */
 	NETIF_F_GSO_UDP_L4_BIT,		/* ... UDP payload GSO (not UFO) */
 	NETIF_F_GSO_FRAGLIST_BIT,		/* ... Fraglist GSO */
+	NETIF_F_GSO_ACCECN_BIT,		/* TCP AccECN w/ TSO (no clear CWR) */
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
index deffb9a0284f..e3742dfefad0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5140,6 +5140,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_TCP_ACCECN !=
+		     (NETIF_F_GSO_ACCECN >> NETIF_F_GSO_SHIFT));
 
 	return (features & feature) == feature;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bb2b751d274a..1367c2883478 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -703,6 +703,8 @@ enum {
 	SKB_GSO_UDP_L4 = 1 << 17,
 
 	SKB_GSO_FRAGLIST = 1 << 18,
+
+	SKB_GSO_TCP_ACCECN = 1 << 19,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 2607aea1fbfb..d6569fa35f36 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -35,6 +35,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
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

