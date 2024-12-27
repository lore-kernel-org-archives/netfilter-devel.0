Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2061.outbound.protection.outlook.com [40.107.241.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9251F892C;
	Fri, 27 Dec 2024 19:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326769; cv=fail; b=B13lmAHzG9Es3ZKfRUg+3TyIkpSEBP2EgT1jBLupZ7q3Op+YGCrkKskD8zP3h6mdRDGP0eBHl6J092W0yD8Os/BbuZW7D8uJy5JWMiRkUpSnH/Y0S4CmE9iDk1vVNC1akmEIxrBBoYHYf/twh5HYTFmNy1NXVWXyQh9Tvge5IXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326769; c=relaxed/simple;
	bh=501Gi53SHarDIBvdO2AAchf7vQePAyB6TeoMAHZDqQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYSH5cZcNrcGCAQDAPIMTWR+1i0KacGACJO4tQp7KGXlFzZfdYxso49l7OMdIZol7XWk4nnJoKUQiqIz5cPeOh+Dta/mlbo9Rk8mUXaKTAERzUkxHT9bFN4LyMkzsuc+DF2a3KeTLFgvwq/wBgnVRLe150D+PGZU26RgVUA5PS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=RFZ26ji3; arc=fail smtp.client-ip=40.107.241.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="RFZ26ji3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yu3ueIIchj08I4PNGcykNuPppdPR+X4IXIs+i5w/qV/lVu+bFHiXYjhsQt6Ltflx3IbYD+J4MzORlgy7rnd/7MgR8hVYbtaj/l/ZN6+syCs5lWZk5c/llpxWpS72vH0Qnwu55/FRp2A2VLuLs66eOQDfVEtahlcXuCfs5TPuXYCqWakcvq3D2y2cUuJj424cKMLl8Qs6SYW3rS+VwqcL5/297oLCEbFyGH5vXVEpULHOpa1l++wmdaSpFwTWDaOEcA1pd+LpaAJmwmj3Ej+9XqDJgUuFM8uky5yL5R/ckFgnolQtNw33rgj5VP8rWSpur1aKIgDZHxPDXZHHv+D1Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4DQWYI/EIGBsQm2JGiVDXpW56OUTHA0ARk3VMbRgvM=;
 b=UGqzzaaZAH6knmCFwnaT+gEIoHHldwZgg9Wj46KMEBQtAMpnQPgvJAzat3QQ3I+g8fh0UeMxx7DL6lr4HAJia3ASb1Z1CV9XDX/yNey2MPl4hfk4RNxc6jf0jdMmcOMwEmllBYQkqUwR8hHPQEuTZvMxX/dqaLQt7hw1iL1TQ/K7f1/0SfTbr2dsUfgiNd5u6DEpVxGZiX1SCvzSvULBaAWNh1cr51Vqd+Bt/ImgZnpQNwqjUyfsN/NTAd73+IaU7vD+Nr5t2LiQF02oO5vcXfnA/RQmJJYDNqt9EswkO16evmeM5WXNXSrcC5JdD9HSBlJ2EmTwqgljc0jwu4cZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4DQWYI/EIGBsQm2JGiVDXpW56OUTHA0ARk3VMbRgvM=;
 b=RFZ26ji3VMa7ddtlPbW9LeBOCRL3LaPtmsT1XaxtBBLNvNxbus7bwTB+d5n/iN4hKwe/+5rNE0CVLYeVKG0vZCccDCW2dqmDB1TreBe1UYWtZ0zgg6aTPrZxK7u+Bkv3dWyjzr/Aee+XukIEAivl7Tr6Ee2rN82TQYdqXtrtE2DwvPtnkvt1JomDuYzLWcW/mF81eL3MKVHNLh9FuzZISnQWwLfyk+/EV7u2cFXCZhVXkIK5bMAH2NNcwWd5IBKFQ313hzBuFxEmKoj+5t3Bq033ar/0apeSOcHw0pq5LK2+uDTHkSZyB4CWzGpBvytPs0EiJiT59/pATAYH0HBQRA==
Received: from DB8P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::16)
 by PA4PR07MB7183.eurprd07.prod.outlook.com (2603:10a6:102:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 19:12:39 +0000
Received: from DU2PEPF00028CFD.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::60) by DB8P191CA0006.outlook.office365.com
 (2603:10a6:10:130::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DU2PEPF00028CFD.mail.protection.outlook.com (10.167.242.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:39 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2S011940;
	Fri, 27 Dec 2024 19:12:39 GMT
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
Subject: [PATCH v6 net-next 02/14] tcp: create FLAG_TS_PROGRESS
Date: Fri, 27 Dec 2024 20:11:59 +0100
Message-Id: <20241227191211.12485-3-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028CFD:EE_|PA4PR07MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: 3901b252-d92e-4ac3-c956-08dd26aa6e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmFXZE9tRFNNc3dZVk8rZTFlaVlHcWRiV0dBUXVoVzdRckdYSmhnb1QzamRV?=
 =?utf-8?B?eGVCaHIySzMxMkxjSHpodndJVDBicy9OU2RWR1RIV2tWVG5MOVdXNnVGZGV6?=
 =?utf-8?B?ZzRQOVpETWdDTlFyTFdOdjZtVDEzTHphU1FYdFBIMnNLSVhPZm9pZ3RybjFh?=
 =?utf-8?B?Q2lBOEgvNkRGaXF4MWZkT0Z1eGQ3RTRpR2VZK0xtT3l3QjhwVHFxSHRMU0RY?=
 =?utf-8?B?SjBKVm1yNHRXcGFHMTE2VVZES3Q2RFF3ME5tNEcxdEZJcTJ5ZnpuQm4zOFM3?=
 =?utf-8?B?N3I1allCS044cUNxUnNud2hQRlJ4T0MyY2xYdFg5ZmsycmJRZk1welRGb3Fz?=
 =?utf-8?B?a0t2TmRMSXMxZ1E4M09BbkpZbEpWUFhZcmtLejcraUYzSDlRRGxRcDdobmxi?=
 =?utf-8?B?aTE1UkVrQVkzWTg0Qmo3cmk2T25BT3pDdUViNng3L1BJMHcreG5ickI2NWJS?=
 =?utf-8?B?cTNWN1BBUTdpY3BZWmpsWTJxZWNGSi9aRUdNdDJVeWRHR2pTTFFGc2NYS1ZX?=
 =?utf-8?B?T3E4dW93TnVvaGd5RTRkTzdNVnVNcXFjaHhDSGlESW5uS3dwb2Rld3BMcnRn?=
 =?utf-8?B?ZUV1b3RhWlR5Y1B2OVlPMUdQK3BRQitsbHJweEdjWGpKVDJod3AzZUROMU9y?=
 =?utf-8?B?WjdKMk1CejZJalUzb0JwYWI1eXJ0YjY0OGJVTUU5MGxqZEQzUXgvL1VZcit6?=
 =?utf-8?B?TkM3aHB4RWhzZnA1Wi85K3M4ekpPYm9vSXN6SSt6QnBaZTRWem13SmFiM3cy?=
 =?utf-8?B?bzlwaHpMYzkrVlpMaVRtTHQrSTVZQjZJQ29QMTNvVVdLRzBSVHBXSWhFUklk?=
 =?utf-8?B?TXh3TndZMnlHZlZoM3dZL2s3UWRxM2VHbERuNzVpWXIybERucE9HNDAxZmVK?=
 =?utf-8?B?N0xvSU90dTF6L3ZkWU0yZHUxR3k4VHIyQnpZeFUzQVBuU3NjcDlxZ1QvUERR?=
 =?utf-8?B?bmdIV3ZRN0J5d2NuajRlZmxic1hCb0N1a1pVeStUR0NhR3dJWnV0bjNqSmtV?=
 =?utf-8?B?NU9scVh3ZGpNaDhsOUc3bDYzMDl5Sms2eE5nWHhtZ2tHelZGeGFWNCtIbWlm?=
 =?utf-8?B?TEkrNVdFNnRVbnZqajI0MDYxWUNMVlFueTNKdk5iYUo0VXpja05zZ3lmekVz?=
 =?utf-8?B?M3Qzemh5dDhLNTFPYUl4QkthUUZkWFpsbmYrWTVEUFdHaCtJY1J4MlJFYy9Y?=
 =?utf-8?B?VUJVNk9tcHBhYmFiY2dxWmpBZXo0cjdTbmJucUlMVWtsSTVKZUV4MHJVTjhh?=
 =?utf-8?B?eVZwb2xVZWZOZ3ZRakNQczFQWW1SaFNIU08xTlBrbTVxWGx2MnBheWh6RERP?=
 =?utf-8?B?VWo3aDlEWlNVTnZUWm9PajFPbU1OakxrWkFlZkNnUHpSVnNYWE15VkVRVmRz?=
 =?utf-8?B?QVB3aUJySS8wbzFEcEF4UTlPdnVkY1RFRkFreFVsVTV1TFZMUDhHdndWVFJK?=
 =?utf-8?B?NXlnb1VVdlRmUHQ3d3NnZmdSM2REOEtTaGo2QWtYdE1iQWkrT1lzUEp3NUo4?=
 =?utf-8?B?RldNaThscDhHZmIyWjhqbkpnRi9RWHdEeVUrU3BRVkpHTmdaYklRS1VhNDky?=
 =?utf-8?B?TVVKVk1yTDFBRGw0ZkNKT3VjdGdwK3pvQ2ZtMXFBMFhuaVY0OUFHNlMwQ1ZK?=
 =?utf-8?B?aTRrS3VGQUtXcEQwazJjY2I2cUdNUkNLL2FHeDhwSkpySTJNTFZTZUFsb0JC?=
 =?utf-8?B?dUJKTmtML29LbWc2QllSbEVjWlZOT1NPNTdVa2twL0VwUXJSZE42b0JLNytQ?=
 =?utf-8?B?bmRhSlBwakd0SzA3N3Q0NlBzbFRhZDNmL3grbHdrTnpjdkU0V2M5dXplUWZC?=
 =?utf-8?B?dFhlRGZ5WUdQQUQvZDQ5OEk0L25PUEp6WnBFaitXK291OU5RcGpIazZyT2R6?=
 =?utf-8?B?VFVFb0JMQTlTdDBXeXFMa1ZWcnNQWmZWc2xodEk2Z1ArcVdjQ3FVdmpLNFhT?=
 =?utf-8?B?MkVzTWhEbkF1NkJkWkxuYzRjRkJQQVBRSlRvNjBhcUJKSEwyTSs1TmRSNTNN?=
 =?utf-8?B?a1hSejlzUENMY0lBWlQzZ2VvT1BCNWl1WUlvS0lBWk1aWFg1ajlGaTZTVTUy?=
 =?utf-8?Q?BZshZz?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:39.0346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3901b252-d92e-4ac3-c956-08dd26aa6e32
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7183

From: Ilpo Järvinen <ij@kernel.org>

Whenever timestamp advances, it declares progress which
can be used by the other parts of the stack to decide that
the ACK is the most recent one seen so far.

AccECN will use this flag when deciding whether to use the
ACK to update AccECN state or not.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f3691c1cdc83..eebe3a99aa90 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -102,6 +102,7 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_send_challenge_ack()	*/
 #define FLAG_ACK_MAYBE_DELAYED	0x10000 /* Likely a delayed ACK */
 #define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
+#define FLAG_TS_PROGRESS	0x40000 /* Positive timestamp delta */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -3813,8 +3814,16 @@ static void tcp_store_ts_recent(struct tcp_sock *tp)
 	tp->rx_opt.ts_recent_stamp = ktime_get_seconds();
 }
 
-static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+static int __tcp_replace_ts_recent(struct tcp_sock *tp, s32 tstamp_delta)
 {
+	tcp_store_ts_recent(tp);
+	return tstamp_delta > 0 ? FLAG_TS_PROGRESS : 0;
+}
+
+static int tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+{
+	s32 delta;
+
 	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
 		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
 		 * extra check below makes sure this can only happen
@@ -3823,9 +3832,13 @@ static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
 		 * Not only, also it occurs for expired timestamps.
 		 */
 
-		if (tcp_paws_check(&tp->rx_opt, 0))
-			tcp_store_ts_recent(tp);
+		if (tcp_paws_check(&tp->rx_opt, 0)) {
+			delta = tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent;
+			return __tcp_replace_ts_recent(tp, delta);
+		}
 	}
+
+	return 0;
 }
 
 /* This routine deals with acks during a TLP episode and ends an episode by
@@ -3982,7 +3995,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	 * is in window.
 	 */
 	if (flag & FLAG_UPDATE_TS_RECENT)
-		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+		flag |= tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
 
 	if ((flag & (FLAG_SLOWPATH | FLAG_SND_UNA_ADVANCED)) ==
 	    FLAG_SND_UNA_ADVANCED) {
@@ -6140,6 +6153,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	    TCP_SKB_CB(skb)->seq == tp->rcv_nxt &&
 	    !after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
 		int tcp_header_len = tp->tcp_header_len;
+		s32 delta = 0;
+		int flag = 0;
 
 		/* Timestamp header prediction: tcp_header_len
 		 * is automatically equal to th->doff*4 due to pred_flags
@@ -6152,8 +6167,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			if (!tcp_parse_aligned_timestamp(tp, th))
 				goto slow_path;
 
+			delta = tp->rx_opt.rcv_tsval -
+				tp->rx_opt.ts_recent;
 			/* If PAWS failed, check it more carefully in slow path */
-			if ((s32)(tp->rx_opt.rcv_tsval - tp->rx_opt.ts_recent) < 0)
+			if (delta < 0)
 				goto slow_path;
 
 			/* DO NOT update ts_recent here, if checksum fails
@@ -6173,12 +6190,13 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				if (tcp_header_len ==
 				    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
 				    tp->rcv_nxt == tp->rcv_wup)
-					tcp_store_ts_recent(tp);
+					flag |= __tcp_replace_ts_recent(tp,
+									delta);
 
 				/* We know that such packets are checksummed
 				 * on entry.
 				 */
-				tcp_ack(sk, skb, 0);
+				tcp_ack(sk, skb, flag);
 				__kfree_skb(skb);
 				tcp_data_snd_check(sk);
 				/* When receiving pure ack in fast path, update
@@ -6209,7 +6227,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			if (tcp_header_len ==
 			    (sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED) &&
 			    tp->rcv_nxt == tp->rcv_wup)
-				tcp_store_ts_recent(tp);
+				flag |= __tcp_replace_ts_recent(tp,
+								delta);
 
 			tcp_rcv_rtt_measure_ts(sk, skb);
 
@@ -6224,7 +6243,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 			if (TCP_SKB_CB(skb)->ack_seq != tp->snd_una) {
 				/* Well, only one small jumplet in fast path... */
-				tcp_ack(sk, skb, FLAG_DATA);
+				tcp_ack(sk, skb, flag | FLAG_DATA);
 				tcp_data_snd_check(sk);
 				if (!inet_csk_ack_scheduled(sk))
 					goto no_ack;
-- 
2.34.1

