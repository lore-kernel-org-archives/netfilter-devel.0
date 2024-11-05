Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840A1D31B5;
	Tue,  5 Nov 2024 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801240; cv=fail; b=YFOOX8L4u8KHm10loNI+Aeh1YiLYPhhyef7helPE+QYLSjiWdKXawPkNAW2O6VscGULoi6VKm8S2DmbRRrKN1vzcQU7JKrLy5FTRUf3dBdErJEZuE2vr4TQV1ySNXz0DMKAZ3XZZhCqv46xOBehZyLAX7aQKrn+Qw/9zYMNG8Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801240; c=relaxed/simple;
	bh=4j5SJ5HYuPel2Dv+IBBWRsO/17dTAoza3QBOY2Scc+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Li4jhTgdp8ywTQeqzehaT4SyX9+PTyp2/f7Ig987EtZnqaLe4YeMKi8Jx/EWDwQVJxp9V4+gDuuozNffbJrTD425qEhGcwXiJH2xJr87OTorNPNxyx7WVlCoZmSet5/mHakdm99pEBv9NQmu2ezPFQFriAcxU2jHWQwNiuMi3OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=JwXIL6BO; arc=fail smtp.client-ip=40.107.22.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="JwXIL6BO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXUGxUTObqkMjoNGF0bB5nD+5nBPHRnP+8+XumJtZu6PB492UlirAvKCA0KMSzidwZx05iHtnIlLFfVFqGmksqTIAMo7818L5j6ha0VC964EDi87kbvC2LEvn8PPBFCmDM2IvwY+yWWDS0Jc3fLsftQzsB2MHueNw+CQdkluz5LDl3Dg3S2b8qPtz7FeDpF3lr2F3w/8JuHWXcjzHfB4iZ+KwFETKXz8bF6N54gltnadwyG9v3DVwvz1CPAzjvxjjaEalKoev7NTbjOMz4JeY1cszU4DhcHnyP8Rt7VfVp7UtJOu67pLqsLxZyANOHXs3HH2/UnsR5OxzoOhMC1dHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSA7eqx5WtqjVvMOGIZmeD65xQRrVJgg0ZR6KM5OeDg=;
 b=hkHponZDvGPQMrdGO+eCjLPwPyjTL+AcOwZWpfkTwRHgtib3dG5061DV0yBqI07+FeEv2BZM4bgqJVMfv9c8lErr3RwSJHUoVJXuCQeuQ765a2P8oAsILyEflDGDCpdfkTxjvVsikkSE/T0IMxIhAuHNyKSQJBMobm84OA85WIbKqYzi5BSfBU75jiJHsQ4P0VrPte2q5IVnJYuJ1pxtHcaniGctQ7BwVQO18qztm7MFMr9dEJ2re2ZgdJ0ibjpqV9J3hDTRlmiNV4f6XEcYBetW5UUsh/CNcQajVbkGNc7fl0x/70YwhKtZ6OpCdV508DtoLtkXmnZF+zbgnUoLmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSA7eqx5WtqjVvMOGIZmeD65xQRrVJgg0ZR6KM5OeDg=;
 b=JwXIL6BODM0ePeXy/I8WbwzfVd1wbApIy5EyRzzCr8iENZzeyFUaCyf5D6mSgmI+SV+755Yu0lcSPY49BJ6x0j344tbOFZjlHOaNknmNMzWyxbD8hlukUB3dnJcehzI6UbD4fwwFExphoCqYQrdRXDN6poWNeJULGi5X3OkRFskba4c+uO4Cjf6cPLc1FoIETlqa78T5U+wJ9LRfJ38tKakJ9F7vlbqmsAeZ8axwffE0JWPKvPSD8R9aNuT3asmSC3s52SQDCRTXO6CzdjB5xqgUqF+h8aE4wwXrjFyXXQLL4AbuvcSik+Lk/SbV/Oo++ygEzrwNLMlM3dJ/NZYa5g==
Received: from DB8PR03CA0014.eurprd03.prod.outlook.com (2603:10a6:10:be::27)
 by AS8PR07MB7830.eurprd07.prod.outlook.com (2603:10a6:20b:38f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 10:07:14 +0000
Received: from DU2PEPF00028D03.eurprd03.prod.outlook.com
 (2603:10a6:10:be:cafe::c2) by DB8PR03CA0014.outlook.office365.com
 (2603:10a6:10:be::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 DU2PEPF00028D03.mail.protection.outlook.com (10.167.242.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:14 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2j024723;
	Tue, 5 Nov 2024 10:07:12 GMT
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
Subject: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption & better AccECN handling
Date: Tue,  5 Nov 2024 11:06:43 +0100
Message-Id: <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D03:EE_|AS8PR07MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: b3823e4e-3e52-47c0-36b1-08dcfd819f52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHBla0o4T0F5OWttbXViTitGYU56MkREaFZOdUc3QnB0bWlaMlkrSjRsWHVV?=
 =?utf-8?B?TWNyOGw3TG5sVHBtbytQczZQclZsa0xieDBPeiszNG9LNDBrVzYzcmtWZ0Nm?=
 =?utf-8?B?QVBwWXlVN1VWUEZ0bEZSSkNmcnl1eUhGU3Z1NytITnh6dkNQWk5GS0xhN21F?=
 =?utf-8?B?ZS9hKzVtK1ZqekhJSUNNZllPOTMwdHBhSFgrRVV4SUlHMU85K2VKUXBFSlJS?=
 =?utf-8?B?V052aDNXKzdXblAyT1kyc1hkMlJ2M0NIYjR2THZQbmxnekJQbGcyekV3UDZn?=
 =?utf-8?B?RjViTEdkR2x0cUtrZGIrZk8xUVYvMk8yeVU3U3pUdFBQRlQ0YkVVZE41aGha?=
 =?utf-8?B?dmhVeFNwa2d3SGt2dTRrSUhCUHd1RkF6TjdQVzU5VEVWbzg4UEUrNmk5ek12?=
 =?utf-8?B?TWNiUFZsU2hlOVlMT1NVZUxlODJ1NFQ1a3ZBYStZTjZEdnluRURIQlVWNFBU?=
 =?utf-8?B?VnhMRHJxcG9ucTIyV0JWeXNrNEtkYTBTL1BXUUMyanE2RWFZY3ROK3FKRTEr?=
 =?utf-8?B?SStqK2cxK3hjdkpualpBb2xUcWlyV2gvNFNLZThuUkVabWJraTVPU1UyeGxx?=
 =?utf-8?B?SXdIREhYVnR0THhNcmJDNVVPazBhNWZHZlRlaWZJc251UU1XcXdWK0sxeGd3?=
 =?utf-8?B?MVBuVzEvSVRPck9lcVBnSEwrL3J2RHFFVmJNck1qbXhRbUdRUGpqU1N4bFl5?=
 =?utf-8?B?ZDVhQ29jU1B3RXNNNEFoVjZJekZCcHdZM05kMnpzcXpQVkJWSk5JTThRN0lh?=
 =?utf-8?B?TWdNTDU5UUlNSnNkMXNnVmp3UXAyMGZHY1lKV1hXM09BY2c5MkpLcFZHU2l5?=
 =?utf-8?B?OWpYbWRoV2pwbVNrM0lkYjVUQVROZlZiQjVkMlRMSkVOVndPckxYUjl2Y25m?=
 =?utf-8?B?ditTc3ZoclRtZy90U2dRVW82SjVMSkNsQUo0NmZLckM3eU03VTQvOW5KbVFh?=
 =?utf-8?B?MGNsVHNmckQ3eGxxbTJTSnJCRW5CdFJsQWxvVmtONzltL3NyTlphOFYyZkpw?=
 =?utf-8?B?eE83NG1jTUU5T1hWemVsSkF6bCs0c1g0emE2KzZMSG9tT1h1VEpLTWJ6MG9l?=
 =?utf-8?B?b1hKbjhtVDFUWGtEa2tnSFI4Tll0MlNXREMvM2NLamVDY243THpSUXdELy8v?=
 =?utf-8?B?NTNXQlVaTmJ3d3h0UHkxUG5DZFp6aXJJM0tpVzFHajlhRk1PWXFDYzd1ME9I?=
 =?utf-8?B?d21ybjVDeDNZYkx6ZmZzVVZ5TnF1UnlSUkNrejdXajJKbUprZFh5K0JWaTFD?=
 =?utf-8?B?RERpeGhKa0ZIdlJYc2JvUzdRaTJlVnN2OTh2SHNuV3A4cmJRU3c2VTlGdnk3?=
 =?utf-8?B?bmNkbEFHSXo5bzAwYU5JdC8vb3FpOGp3TmQ2bFZEQVFCMmNIekFlYis5aG1K?=
 =?utf-8?B?UTYwNlhDLzcyN1ZiZjdXeVI3ZjV4N3YxVDBEV0ZXRElXNVY5Z0VxSHV2L2t2?=
 =?utf-8?B?RHgzYWg2MlNTQkhEd1N6cFhoSTB0RWI4NHVXakdhUHYwN2g0dHBvTkwwNlYv?=
 =?utf-8?B?dExoTWNYTThpYkgvdTM1TFovbDRqMDgxQ1VLS1VISzBhS0JVVlc1eDJEcWhN?=
 =?utf-8?B?NWE1UHVyUitMVlBBTEl5R3B1ZEk4elV1Mlh5ck5yUFBpRnMySFNhR2tlQWk4?=
 =?utf-8?B?RjlFNExVL25NcCttY21tREtCeVpYVlUxQXptS2JlRDEzNkxxWlZubHZZZ005?=
 =?utf-8?B?c1AvRy9SRVFHSzhzTzdLUzVxOENBOEw5ZXlZSi9NUnFhbFNsQmpoalJlV3Bm?=
 =?utf-8?B?RndzdWNOSlJFdzFtVTNNM3Y3UTRtMUpJTTdORjlNVzdZMmUxVjBZenVuckdz?=
 =?utf-8?B?TzMveEx4aGdkK0p3azZsVjJvMkpBY3VQRnBYc0NVTVdJei84MDc2Wk95MllC?=
 =?utf-8?B?SWpOOHhpZFZNekZ3UmF6ZCt2NjhoQ0VwOFlDWHE5M2Vub2pCdlp6NzlEMUVZ?=
 =?utf-8?Q?Iw5hNN9l0yI=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:14.3622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3823e4e-3e52-47c0-36b1-08dcfd819f52
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB7830

From: Ilpo Järvinen <ij@kernel.org>

There are important differences in how the CWR field behaves
in RFC3168 and AccECN. With AccECN, CWR flag is part of the
ACE counter and its changes are important so adjust the flags
changed mask accordingly.

Also, if CWR is there, set the Accurate ECN GSO flag to avoid
corrupting CWR flag somewhere.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 0b05f30e9e5f..f59762d88c38 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	th2 = tcp_hdr(p);
 	flush = (__force int)(flags & TCP_FLAG_CWR);
 	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
-		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
+		  ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
 	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
 	for (i = sizeof(*th); i < thlen; i += 4)
 		flush |= *(u32 *)((u8 *)th + i) ^
@@ -405,7 +405,7 @@ void tcp_gro_complete(struct sk_buff *skb)
 	shinfo->gso_segs = NAPI_GRO_CB(skb)->count;
 
 	if (th->cwr)
-		shinfo->gso_type |= SKB_GSO_TCP_ECN;
+		shinfo->gso_type |= SKB_GSO_TCP_ACCECN;
 }
 EXPORT_SYMBOL(tcp_gro_complete);
 
-- 
2.34.1

