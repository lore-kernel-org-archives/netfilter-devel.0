Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597771D1E71;
	Tue,  5 Nov 2024 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801232; cv=fail; b=t36ulDSLKI03aiqGei6LXdoXfoFMs0yQ/HzCu6vs163MHlHe/hGxX9Mgkh8WBdMYsmtji8CuO35JqsF3RlWr8PziswmFHv1VfWyahyN1aDwR23gzlvdFBmmRXfLelADKWtP42YOzSnVsbaQ8AERFzRD2Z0eUDwEYWhjUI4HjmWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801232; c=relaxed/simple;
	bh=undR/3AUMa7xPhBuHpEtaAz+WVt05ZZ72lfV2xzbLWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3NlH791vr8FXebwJ4ZshcDtGPzbMVUgj65I19eP4kh8NebsT6s8mhpYtP1tjQxhusIlVt4BlnG88RNj53LOqqVWPneZVrYRKp0/v6k8LJRzBqSAu4BXVIxBi9HaSbgo8+dS7cX45iQqN1lJwEGAiGuisAvJbY9RdEQOAjw6Vcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=rQud75Cj; arc=fail smtp.client-ip=40.107.249.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="rQud75Cj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBE1+qNlLNMPcfmojgrgkCbd1lpv2oEGjSPrsnP0cO/Oc69t8QVuRjgTNBiGW5HP2n8jMNMY/LLM+uqAboBj/93tGO7ECMhzsydb2PHnWPFPZrVaA/vcroePurg5go5JeCYQPCpgWaHmG9DyCdsDxXw8c4rHmMGPH5c8LtB2QkxLGNSRxy1fJXi0SHJSr9aoZHTLwRmjinFbcr4VVPc4QsTKb9/RZH3oyf6rSA5L3zYT3FBZhYTDEjiwOYjZmZfz0uO7NDUUJb0JrV2A20/5Q14Y9CCJnQpXN0Lo6X/X2C0QxG+BwfzQ71n2GJkQNCEumbU3DkImpQXedWo1W21KFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpn3nQqAQ82hXg4RIYB+P6Y5GVodjhYMsmufaB7g9ng=;
 b=lZh1yWJVjpRKrYv832mmuCvDgpyp/MVNDKaZ3AWbK50SZLCCF8alGXnAtqcrxhG7bdgYpLcz9TdlQKdvhwwMOetgv+2h/7ZWDnOi3riepkMKTO5Ecb/3/L0Itkv83MpXqUfsNDJAZXhOCgRPvlBPkK59Cee/8GBOnNmjroJZxoMEEn+SyfVXjx6i9rsmc/vEG9/aThdStqT9OGOoPh50qO0wj+406Nt9fA4a2ObiFsR+6EX5qxg95aH9JZYrHjmOv4KvnoBgpKYSxPDgZ/xcwBRUDfVemubzdcE91HYeYfscDeWnrRwiLZB2M0DqikTZ2keaNlI84MFsHC4VZp+huQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpn3nQqAQ82hXg4RIYB+P6Y5GVodjhYMsmufaB7g9ng=;
 b=rQud75CjjZ6YjnlOtzlpQs/HzmW4rdUNRckkAhBABrCniq75uoOgIkNsVt9ZDKd/86ifFQXsiUbcGg9hlI5O+PnQGdePHvhwCmj9xDWOC6fTByGcc/IvPAP69vTInazdjfy92cE2whocECfxV47uJSQQJXoAdjzQUp/hD2QT4L7lHA4tJ7F4OUfgzj8dzpNM/fdwxawvCEmTJZRPGPAtY/YWA9R2mcr+5Cyx//QDVBuyzHq4baPxKmRigSVhmHO+U2T4nBr5VGZvKWgMMB5YA1URkfduF4PD54RJZMpxwwzFWtu33QMjEOpi6FA8L6VcGNO7xk7sQR0lWuZ2AiU8Mw==
Received: from AM6P192CA0040.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::17)
 by PA4PR07MB7615.eurprd07.prod.outlook.com (2603:10a6:102:cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 10:07:05 +0000
Received: from AMS1EPF0000004D.eurprd04.prod.outlook.com
 (2603:10a6:209:82:cafe::24) by AM6P192CA0040.outlook.office365.com
 (2603:10a6:209:82::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AMS1EPF0000004D.mail.protection.outlook.com (10.167.16.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:05 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2b024723;
	Tue, 5 Nov 2024 10:07:03 GMT
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
Subject: [PATCH v5 net-next 01/13] tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()
Date: Tue,  5 Nov 2024 11:06:35 +0100
Message-Id: <20241105100647.117346-2-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AMS1EPF0000004D:EE_|PA4PR07MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a619d2-9b80-4199-34db-08dcfd8199e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzRFOVZlbUtiVlNzVWRub2ovY3B0Vy9BaFZHZFMxOTFWVTI3WlRhMUV6Z1Ez?=
 =?utf-8?B?KzA3eEh0anI3OXM4YW9aMi9HRE8veTB5Q0I2ZG8rNWpsMXBzK1VyaHdkYmY2?=
 =?utf-8?B?a1haZWMwMG5jMHdlbmMrSE5rck1TZksrR0lMeWNXOVJ5Y0t1OUtMTkdCL281?=
 =?utf-8?B?Vmg4SUJ2eDk1V29jK2U1SUJod0hQRmU4czM5OGhUdG9aeVQ2Q3ZFNHBYaUZl?=
 =?utf-8?B?bXZndVpncGpGaWVSL0tiRmE0c0tZVHd4OXlINTIrdnBXZXQrd0N0ZDg3T1ht?=
 =?utf-8?B?S0tJVm8rQmxyWUVWREcwMzEyd2RDM0lvV2RseXFNQjJoa0ZwUERrMHlCM0dR?=
 =?utf-8?B?cTVxYzFWeFMvcFZYelk1RFdTR2wwWGcxVGljWUVOcEVnSkhINmZFOXljbEFi?=
 =?utf-8?B?T2ZMWUhhbGtEbU1XTXZxZ3lGTEVPR2NaTklnV2pISFowUFVEaXVubTU1U2wv?=
 =?utf-8?B?UDVWODY5b1NCVVNqa2pHb29CbEQrbnN4ZnVLbytFWDBNWjlyb0VaeTEwa3BU?=
 =?utf-8?B?blRKK0YzUVh2NzcyTzFTSVM5VGxhRlErK3U0UHEvMFFYYjhVbWVycnh3eDYy?=
 =?utf-8?B?NVMrbHUwZ1MrOG54WUo3M1FJeW9YZGJ4VUxoN3FGSXVWclhJTVNreHJMQ2VB?=
 =?utf-8?B?ZWxNVmgwbXI1RHpZNjdQb2JzZyt6QkQ4dEVFZEQ4bUxPd2gvYVEzNnROenFM?=
 =?utf-8?B?ckQ0aGhwNVJUYnNPcmU4dFNqZ1R5NUNZOE5rT2VNSW5TYUMzOGxVREFUYmZR?=
 =?utf-8?B?Y1RJVkd3N0hSR0NmV0NmU2JBSWFXTnFsOGltQnBaa21nWHVXQjZjRDh6OXcy?=
 =?utf-8?B?TVFhSEJrS0pmV3Yvd3EzU1NSZDZSRDB6bFVwN3QwVFRjS2E4ZnRRUmhsTno1?=
 =?utf-8?B?Ky9uVVJnRC9iNkpPOHR0ZzhRYVZNSnZpUk9XaVFCcmRINzJtelgxdm5heG4v?=
 =?utf-8?B?TjBodURrRkExQVVsd1VXWVlZTmx6U1FpYVk0M2pVc3F0bXpIOC9vQTJheEZL?=
 =?utf-8?B?aGQyaWU0RmZtQXB3eEdIbzlmVXpzS2JuQldHQ3U4ZTlxU09YVXNzdG42R3Yy?=
 =?utf-8?B?djBPWjdRNzFPblVFVXlnbEhjV0RoVmJwM0lCRERVWUJDemdzS3JNWm9HbFV1?=
 =?utf-8?B?V3pTMkwyVzNBbEhuV0ZKdU0yUTR2M1RLVDdDUzUwNm9acVZMMW82RWxQSU1t?=
 =?utf-8?B?QkdGRUczT3p1VTcyMFlOZzVuOFpuRGlTc0wvS1UvZHN5QmxjVFc4TndGYTB0?=
 =?utf-8?B?dmlhSEJOM0Z6M3lxRmVhMmpGTzVmL3EraDZTdG1oZjhHMDVYUzlDRjRNVUda?=
 =?utf-8?B?UkhZWWc5V2V2ckMwY3hJVStiR0RSRFBTUE96NnhFb3NSMnovVW5pT0tTMjFy?=
 =?utf-8?B?YjgwMnRlZXl6aU1UMy9LYVMxYVhWdnNXK3NEQjNNcllSMGtVaFBrKzBKZE1i?=
 =?utf-8?B?cU9VR0xYb2I3aEJqZkorbjM1NXg0dWxGOGxpN2U3eEpNUXA2a3hqNXRGcE9j?=
 =?utf-8?B?WGtySDh6VUwvK3ZRVEpvMTM2M1JuRUlFMG1POE4yWUJPSzVLdXloSVBqOTFV?=
 =?utf-8?B?NnNBdGtrajFDKy9Zai92cE5hMGNvSHZUamZVMzJsczhYblMxbEFraWtPajlL?=
 =?utf-8?B?UXhhNHVyS28zbWZMY2hPQzcraWU0NENCQXJlVEZVNTF4dlhEZEk1ZXFoV2tt?=
 =?utf-8?B?emN3RzR4UytZS2pmNmh4V3BIQWJkQkk0TFlJZGU1c3U5am5QamI0YU1HY0Nn?=
 =?utf-8?B?bVdKN3VVaUtZNjdXWEFkWCs5RWxLS1REdW51OHdPWWUyQXFxek01dEhXcnNt?=
 =?utf-8?B?WDY1UFgyQk5tc2FsSGpWbDQ2Rk11dVVESm9EclJCaWEvUXBoZDdIS0lxV0dF?=
 =?utf-8?B?Mmtzc3p1MkpzVG1DZVJ6MzltNGZwQXJQa2hqRWNON1d3QVFkbGhHQk91NXdC?=
 =?utf-8?Q?9yD/hmV+UYg=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:05.3414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a619d2-9b80-4199-34db-08dcfd8199e8
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7615

From: Ilpo Järvinen <ij@kernel.org>

- Move tcp_count_delivered() earlier and split tcp_count_delivered_ce()
  out of it
- Move tcp_in_ack_event() later
- While at it, remove the inline from tcp_in_ack_event() and let
  the compiler to decide

Accurate ECN's heuristics does not know if there is going
to be ACE field based CE counter increase or not until after
rtx queue has been processed. Only then the number of ACKed
bytes/pkts is available. As CE or not affects presence of
FLAG_ECE, that information for tcp_in_ack_event is not yet
available in the old location of the call to tcp_in_ack_event().

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_input.c | 56 +++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5bdf13ac26ef..fc52eab4fcc9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -413,6 +413,20 @@ static bool tcp_ecn_rcv_ecn_echo(const struct tcp_sock *tp, const struct tcphdr
 	return false;
 }
 
+static void tcp_count_delivered_ce(struct tcp_sock *tp, u32 ecn_count)
+{
+	tp->delivered_ce += ecn_count;
+}
+
+/* Updates the delivered and delivered_ce counts */
+static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
+				bool ece_ack)
+{
+	tp->delivered += delivered;
+	if (ece_ack)
+		tcp_count_delivered_ce(tp, delivered);
+}
+
 /* Buffer size and advertised window tuning.
  *
  * 1. Tuning sk->sk_sndbuf, when connection enters established state.
@@ -1148,15 +1162,6 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
-/* Updates the delivered and delivered_ce counts */
-static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
-				bool ece_ack)
-{
-	tp->delivered += delivered;
-	if (ece_ack)
-		tp->delivered_ce += delivered;
-}
-
 /* This procedure tags the retransmission queue when SACKs arrive.
  *
  * We have three tag bits: SACKED(S), RETRANS(R) and LOST(L).
@@ -3856,12 +3861,23 @@ static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 	}
 }
 
-static inline void tcp_in_ack_event(struct sock *sk, u32 flags)
+static void tcp_in_ack_event(struct sock *sk, int flag)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 
-	if (icsk->icsk_ca_ops->in_ack_event)
-		icsk->icsk_ca_ops->in_ack_event(sk, flags);
+	if (icsk->icsk_ca_ops->in_ack_event) {
+		u32 ack_ev_flags = 0;
+
+		if (flag & FLAG_WIN_UPDATE)
+			ack_ev_flags |= CA_ACK_WIN_UPDATE;
+		if (flag & FLAG_SLOWPATH) {
+			ack_ev_flags = CA_ACK_SLOWPATH;
+			if (flag & FLAG_ECE)
+				ack_ev_flags |= CA_ACK_ECE;
+		}
+
+		icsk->icsk_ca_ops->in_ack_event(sk, ack_ev_flags);
+	}
 }
 
 /* Congestion control has updated the cwnd already. So if we're in
@@ -3978,12 +3994,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_snd_una_update(tp, ack);
 		flag |= FLAG_WIN_UPDATE;
 
-		tcp_in_ack_event(sk, CA_ACK_WIN_UPDATE);
-
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPACKS);
 	} else {
-		u32 ack_ev_flags = CA_ACK_SLOWPATH;
-
 		if (ack_seq != TCP_SKB_CB(skb)->end_seq)
 			flag |= FLAG_DATA;
 		else
@@ -3995,19 +4007,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una,
 							&sack_state);
 
-		if (tcp_ecn_rcv_ecn_echo(tp, tcp_hdr(skb))) {
+		if (tcp_ecn_rcv_ecn_echo(tp, tcp_hdr(skb)))
 			flag |= FLAG_ECE;
-			ack_ev_flags |= CA_ACK_ECE;
-		}
 
 		if (sack_state.sack_delivered)
 			tcp_count_delivered(tp, sack_state.sack_delivered,
 					    flag & FLAG_ECE);
-
-		if (flag & FLAG_WIN_UPDATE)
-			ack_ev_flags |= CA_ACK_WIN_UPDATE;
-
-		tcp_in_ack_event(sk, ack_ev_flags);
 	}
 
 	/* This is a deviation from RFC3168 since it states that:
@@ -4034,6 +4039,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 
 	tcp_rack_update_reo_wnd(sk, &rs);
 
+	tcp_in_ack_event(sk, flag);
+
 	if (tp->tlp_high_seq)
 		tcp_process_tlp_ack(sk, ack, flag);
 
@@ -4065,6 +4072,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	return 1;
 
 no_queue:
+	tcp_in_ack_event(sk, flag);
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK) {
 		tcp_fastretrans_alert(sk, prior_snd_una, num_dupack, &flag,
-- 
2.34.1

