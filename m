Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2085.outbound.protection.outlook.com [40.107.21.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E01D1F46;
	Tue,  5 Nov 2024 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801234; cv=fail; b=efRRA8q0FdqZTO9WGVrpNRJevuOO/yWwL8rH59hAAXlf1kODj78euU9hNzJHm/zogVmi2Ha73/ivb0tkWxS/TsZa8RiygX80B69pw+HdUXysnzrxI/uitEEYK1ugHJphPyFVQfk0p+dNxH9MK0wnvQ7Y4rY1CtlNd5NVa8F755s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801234; c=relaxed/simple;
	bh=1hUO7+wovHcGqJC0Yp7DTQ8T2gJSqSAExU9lZet4204=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEimMGVyTbmUThUFD3kR0TzXDNmLBu5OYK3qcuf4i//KtaXJlY04ax+VeFTHBgc+zkHNeQ0eF7yWz9Se9r5oJyiJnFvZm+EALvwO/BeYu7RFwuavhkOMcRF56/ZMguHwv0rNI27oERUpve3Mup+GeqfgoRQ7ascEChOhuAOgovs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=H8M8JgCn; arc=fail smtp.client-ip=40.107.21.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="H8M8JgCn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3M2av2S4mer6h8z5oo3Qj/Aek+6enq1Rk7zkIInI0ybdkB2EEcP46I7cUea76W4yx5YxbcnLrev3Nmh5BO61bOJsR8rSaD7yXA6RxMAa6sJ+qUt7KX9uU4EymRGQ9KbpBobFEwrSXYJmax7sAvVOYydq5ELqlLolGgLldzY7twxeohGzeMWTv8i5l+dk9Y+mx3ZNxvLa7FEzaNHVwwQwKcNbJ8jv8OHliCi66ftzSnHCVhvVU7aSE3rI8vewKi4DoX4SLBmfF5neaY/0mjhEXUnA9QoRz8drEBXAIAktTxB5yadV5oeuuFkFBrYfSTsdhxjKMzyrxwJ2/9GLtzZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQPlh+hxNXZNwK0AAtvrUWy2uf9fT50P/b2uNXfazGA=;
 b=m1JCrzRB6wF6LgLaOL6IDCfsy2Rm0zCjgjrUfJnm6FDiskujk0OcOQ4uIa9YYYCVZ4RrQAF/AREnhKrC9G2HxnDM/pERkLr5iZ3vhXGNXJ+705dGtAdwJiIqMixnCNf6cUbIQhJUOhJ+1kPT/9F/CkaMmMN0rSte2k48qhdXAPQTtiy7H6XWcc0HUYbO0VMzRnki62Hw4V3W4hGhCGMTzDnTMi7R/Ito3CJZEPDwaAmzZUuAVREV1m4JA7DFNdPUu/pOfIE7NZ3FtrJnBfPsBOzAQJL94Tn3aAapVHLFeSJn1jyt4BKB+nyakCRT3k3aFcoa7SAjF1UEq6bgsuzVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQPlh+hxNXZNwK0AAtvrUWy2uf9fT50P/b2uNXfazGA=;
 b=H8M8JgCnPNrV+Slu/E7FXKOGOhLDSzo0sxBmlPD9w1/4+FRo6lE5pvF7j8KWu4jyLypQ7Z/rImXrkS3VQLAgAJ3f1uplPNn2XHqmZfa+oTxqHeCs/hfefD1CZLk4pSJBKXYzJso72INeXg/zB6uz3GyYwaEDIZWFLyf5KULZYICj4d6S04NI1Bti9qtHgbYKgzD4YzRAFNx1Wu2Ze9s2GWiQnkkE+0Nhd3RrqMAAcjc0kTaDxWH8Gwl99n3VrDavXDLzvcmsA9AYGLcoMGnK+D4ghw7ff6jltxqLOMoxtck1Vhn1Z4+fBDQr1m5ggDOf7e/AqYiwr4d2V3NPdFEckg==
Received: from AS9PR06CA0545.eurprd06.prod.outlook.com (2603:10a6:20b:485::15)
 by VI1PR07MB10090.eurprd07.prod.outlook.com (2603:10a6:800:1de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 10:07:06 +0000
Received: from AM2PEPF0001C710.eurprd05.prod.outlook.com
 (2603:10a6:20b:485:cafe::dd) by AS9PR06CA0545.outlook.office365.com
 (2603:10a6:20b:485::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:06 +0000
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
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:06 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2c024723;
	Tue, 5 Nov 2024 10:07:05 GMT
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
Subject: [PATCH v5 net-next 02/13] tcp: create FLAG_TS_PROGRESS
Date: Tue,  5 Nov 2024 11:06:36 +0100
Message-Id: <20241105100647.117346-3-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C710:EE_|VI1PR07MB10090:EE_
X-MS-Office365-Filtering-Correlation-Id: d024df15-2efe-48d1-d908-08dcfd819a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SE9UWnFKaVA1ZWVvbjBTZFlHcEJwTzIvVDBsa2RwV3d6d0V5aEllQjZtdkxn?=
 =?utf-8?B?cHJZemplQk1yaG5DR2FkNHZiQTVhTDlTU1NpMGpTMTE1YVV3MTVOWVgzbTh4?=
 =?utf-8?B?SjVqYkZQbUpNeWlJUDNoRmZ2ZVYwTjFxdTlWM214RXZMb1JrSW4rc29lUXZk?=
 =?utf-8?B?cUFQWGZiMFZxNEc0SjRPaU15YVo0YXVXZmJhRmtrVnRZZjQwQkNCZXlzNzht?=
 =?utf-8?B?c1VHYXN6NVE4K1pGeSsrYlYybWEraGwzYWJ2ak5XbnVQNUlSVXBPN0J0SXBk?=
 =?utf-8?B?Nlg1eE1KZnQrSHpTUkpPSmpSeEl1cXdFU2h3RmZnTHN3MjJPTGFFVHZiNmdG?=
 =?utf-8?B?a0ptQVlFY0dyTklhdEpHb1M0RDFLY3gzZExHNUZQS2gxRlBkU01LOFVVZUxv?=
 =?utf-8?B?c2RpQnZWQW5yVnl6YVlyVllVMzZYczZLRkJzeGltMVg0Y0kzQ01QNnlhYUFU?=
 =?utf-8?B?Zk1lMENjK2FWVExGMWNzMnVwRENHR1NwMVNyaVc5Z0Y2czFBaGxueFBxdEdz?=
 =?utf-8?B?VmoyTENrbUdaVnBHa1l5RGZYaW1kWDI4NnFsRTVNc3pTRWdMZmNFQ21CTm1T?=
 =?utf-8?B?cEVsUU8vSnFKK2NiKzF5VnI4dkVDbE9rb3c5eTl4cUdDdlUwVHhBdmlLdmNK?=
 =?utf-8?B?YWlpS2kwSnJVWEdQcXVtT2FMcVdjTlJsMkJ3amFSQ1VIV3lxOWtSS2xjV3pY?=
 =?utf-8?B?dzdqcmV4T2xBdGJleWNYaDRHeEU3cVU4NkovNTJQdjJTb1U5Q2VyTmw3VmpP?=
 =?utf-8?B?Q1dQOXMxbUs5c203anJwTitER1JoMEhVUXhOcjdOQmJkR2R0c3lxT2I1ZFE0?=
 =?utf-8?B?QW1xLzRLc3FhRUx1ZXBxQmJiZVFJb1V2NjFib3VUcnVsa0JObXBpd25lZ1Y3?=
 =?utf-8?B?NElxY1lPcWdPK1ZEa2JrU3IzMHFPVk5VUkJOd2NOVU1YMkxXbWt0THM4eUFx?=
 =?utf-8?B?Y1VnVWJNRVBwQVpRQkdydmRkcHFVTEdEYndGRWg1QXRybE9RUEIwZ2lzV1VO?=
 =?utf-8?B?WUVSSFFJNlc5cHdINTVsamZ1V1dORUFFbW1RcUxvNXhlemFPOTlJSi95K2x4?=
 =?utf-8?B?VUlBZ05DSjczVDdOUkxjM2NXQ1oySkw4NGt0emhoa1ZYTDZoYW5BSUZJQlFP?=
 =?utf-8?B?Rm1yYXA2WGZiZFdDYWlqT1RIV2hBY2gyajhGYUorZzdIWFRUTzBzekJ2eDlV?=
 =?utf-8?B?eTZveE9Xa0FaOGRJNU9WUjk1bWc0WlF4ckhqK0I1WStkNXd4bjRYTjF0Qks3?=
 =?utf-8?B?VVJWOU5wWGhSU1lOZnhaTEhEU3hLRXdsZEZhdC9aMHFmT2hUZmdla280OEdM?=
 =?utf-8?B?TVVSeWFHZnF3UkhvNTBxbENzVUZSMS81NUwzTlZLL2h1NGtka1p2U1dxZ21S?=
 =?utf-8?B?NGVVSWtWRWhNdUxZMS9RdkZ0bjFvS0NtU3cvdE1tRXpORytiTzArWm5ZZlUr?=
 =?utf-8?B?alBCaThWMW10L0N3SEJ4dGYrNGNwY3VOcXVWN3pQYmNxYkswcXgxdUdlT0xH?=
 =?utf-8?B?b1p3cmJ4L0ZBWVRzSGcvTVhSSlBkb2NWL2oxdVNXaXI4V1c1cURaTDlpZGUx?=
 =?utf-8?B?ZHhMYzlnYVRyaVNSS0dTRHhHenpyaXpXTjFqZVhuYXd4ZmE0TXMvUEhEM2w4?=
 =?utf-8?B?L28xczI0ZHY5cVg0UU10Z0ZkUUFYbXBVUzRURC9pZmRXT2hVN2ltZzdrVEcz?=
 =?utf-8?B?NzFaMlVNNGhsWGVzTXdnY0tXcGJseklDZ00wNXlDdm9vaGdnRXRUcUpndGNi?=
 =?utf-8?B?bGwyek1IeEZPYnlCaXlzYUc1RlI5enkyUXFETU5VbllKSHBoRk5Yc0NzT0lT?=
 =?utf-8?B?YTJ5Y2gyb1IrZmdSalFNdThCbjBuVWRmb0s0ZWg3SU5DV2xwL0FUMVZ3TCtn?=
 =?utf-8?B?TDY2UC9nZ1lZS3IzRTY1VlFlNUVBaW8rT1U5b0xGaVpoc3YrMzdCcy8wV3NY?=
 =?utf-8?Q?yaWUT2LFGBA=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:06.3982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d024df15-2efe-48d1-d908-08dcfd819a8b
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C710.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB10090

From: Ilpo Järvinen <ij@kernel.org>

Whenever timestamp advances, it declares progress which
can be used by the other parts of the stack to decide that
the ACK is the most recent one seen so far.

AccECN will use this flag when deciding whether to use the
ACK to update AccECN state or not.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_input.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index fc52eab4fcc9..ecb3de69c6de 100644
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

