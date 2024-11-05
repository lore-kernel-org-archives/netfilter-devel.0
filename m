Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2043.outbound.protection.outlook.com [40.107.104.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39561D319C;
	Tue,  5 Nov 2024 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801244; cv=fail; b=r9fyMnLI98QtJakJm6D5ZA01C181P+uJxaCXND4dAXq/6uV+8TouPdT7/9rKhBLMLaG6i6pTr8T2mYyI3+vu+kZqGShJZ6O4fEpkPIfqfXwe8nLPiPYDDBO4LmHgHblA/nvOdaK1BLvpdhXWSz1r2DaDC1Cd1AUc7FyyEuYYHcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801244; c=relaxed/simple;
	bh=gU5bTWaRSJRRY+OABQjWb/EQSIBvto2A818+Uk91GYY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VOvz1funZ3YntEOi1S31IJUPkwg8W4TWuT0UiGFiJ4MI1/bFMLxm0XI1apa8t1qQSarMckZAmObC3aZi8nNbOXRuaMp2RmPl5YrZn2yNMU0G5YKo0JTEuYlo99KFjIEsgWypG02zjjjL4MAKFP8FTCxmxVcC+hcbHGQUOKFjeYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=RAx6cZs8; arc=fail smtp.client-ip=40.107.104.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="RAx6cZs8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZXpddY8NBVql4BMuvidAPFD7u/URVvFnLp4EH//YZ1iw0tGBmSlawqQ2oEEAg5YIjqUWgeyHhC0r9uNt3kfTRlVsK5fGkbZMCG5rBkuScO0OiYLOWbQd3AdGh470+3BA4LXIIA+dYWVi42GexZZ30fGtgB8juKT6+oVn/R4FAQHT/Iji9Nn50bKOrqBEB8CWHypeW3BlYTJ1qCY5zfApmLUrf4I7zV1uHXNaQpvA4ErOaNq6FjuFRq86FLnkTVrNKmTIpGRXUJeNpk8XQ4qgoykeh8bYpwNUrhu/NKEg6TE5yCl/Stw/g9VE7KSte+PRavir9mIhseDHzVVJsMerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrsVlUfq0qAe/cNgDzcbvtTrQ21P8Ir9GQPhTTcHhh0=;
 b=e4VlZHMTt+KHTYopIwY3WJnCql1Vlo8rfrOZYVmijHtfPZkGVaBB9MJ7N2Sgqj3kR1WZzCcjyipbLWA1IjmEzV5jEGIvOIZPagOerSPfA757nItPxRii9wZId+RkORYlNkVghpP70bm4tV/e7HQzkPrbE8DcAhQckVHYiTALYTLMgrRfXSrMPh9ymj6YvCiXVkElz/Zr7jDITLjnzLWfxTrHWNADJEHgLS2Bs1MRXExShPSYVAmL7R/G0Z+4Pts80eL2YfQbvsRUElmk+y3l5M4YDgZxvWHf4EiVtRJofvl0VWWVb2Y0lF/bMo0ogYu0ehijkmwdnKZRqWH0+jCCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrsVlUfq0qAe/cNgDzcbvtTrQ21P8Ir9GQPhTTcHhh0=;
 b=RAx6cZs8FgMkDJVavYILKc1+cQJLh8UPp/5VzZpY9/R9DzE4dfo7YJ16x8CEB+pXCnUi8rA6ahd/ivTo6s64LTGwJSZ02EVJUqfUseIpHjI+JpRxnqMLcLfA6PJ9jtrRrij1yqjM8JWCrolU6HLZlVDdbCDKzPCXoRy3bBnOpB+SYHM8c+JjdYQTYEMfiWn4beoO4xAJ+74YddRjDEXRyTsDebj0A11qG6R4cC1Wo9zSJJgqc600+dv6i4s1GAO/L+C/31wSVouwKgApw9ziqWq6SztwDZ6WZmKhtjT8jdqbZ4qvoJ3Q7ivwDkpfMAr0ZzMpLFOas7pORI8RWmObzg==
Received: from DU7P250CA0017.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::20)
 by AM7PR07MB6422.eurprd07.prod.outlook.com (2603:10a6:20b:13c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 10:07:19 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::fc) by DU7P250CA0017.outlook.office365.com
 (2603:10a6:10:54f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 DU2PEPF00028D02.mail.protection.outlook.com (10.167.242.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:19 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2n024723;
	Tue, 5 Nov 2024 10:07:18 GMT
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
Cc: Chai-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v5 net-next 13/13] tcp: fast path functions later
Date: Tue,  5 Nov 2024 11:06:47 +0100
Message-Id: <20241105100647.117346-14-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D02:EE_|AM7PR07MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fdb73c5-651e-4ea1-0a04-08dcfd81a260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDZvNlVCd3pVby9pSFZ4R1FWTG9COGVER1VpTzJHQThYa285UlhtOHloS2pj?=
 =?utf-8?B?LzdqbEYvOExSWGFRVkxXRHBCeEh5bUtmNW1YTjNZK0RkY2pkZDVXOHh2Sm1T?=
 =?utf-8?B?eG9NWTRtV2NKcDRzRkFnYkVEcWtTREhWYUxKQ05WYzFzeGVuRDRJOXdwbGNj?=
 =?utf-8?B?R053R1NpMDlDT3B2T1Z3bnZjNjV0OVd4N0lFM0l0MGNub3lrZlgrWnpZRVlx?=
 =?utf-8?B?Z1IyYk8yeDNEVlFod3VRd0tleCtMMDFwY3Z1eTl4WDhkMXFoa2NWSHl1dGV0?=
 =?utf-8?B?QWRmN2h6YVVVVVhadmZLckxJczhPUDQ5SndSY214cGpNcTM0clM4aVozQnBN?=
 =?utf-8?B?YjZWS1hOQUpoenNqeFRjcVE5RUk4clVMT2tDRkljVXVjaFVOUElFc3A5aFRt?=
 =?utf-8?B?U1E5cEFTVVZWUlBnRDg3UTlSZUlBVHdNOWhTVFdGUFJCVGhTYU42OS93M0hk?=
 =?utf-8?B?ekxpb1l1a0txakZGQzRvMU1NRm1nQmExc0c5YVRjclpJSGxZMlJweFhmdUZq?=
 =?utf-8?B?OG8ySkRRQzd1TUsrTmJaQXp5SmVsdnEvY1lHUHVkMUI1RDNESTlGYTBudXgv?=
 =?utf-8?B?NzhpN1o2ZnFudjE5cksvT2h6bGg4cHpFSVZGYS9aVTVtRGtPMSttM0U5dmFD?=
 =?utf-8?B?K0crSFRRd1hFejNEQ291Uk14MGFQSVFlNjQyU3V4aFRkV2k3VlBIOGtoRHp0?=
 =?utf-8?B?Q3NTOHUzMHBjTmN6WGhrMVg5TmdwbWRHdXVXeWMrRDBjNE8yVlhXVkVkTmw4?=
 =?utf-8?B?dWxDRVhab3h2U2h4TUFpVld2WnlHRWt5c3hKOGRnQlZIU2RjQVQvMjIvUzlq?=
 =?utf-8?B?dmlBcC9MeTEzeHhTUWJhNDErREdRTmk3d0t1UDFFWnl0UDBkcGM1K3V4b0p5?=
 =?utf-8?B?VE8vRDBFeHNnc3NObU91MWk0MkkxaFJJTWZqL3g4eHQ4S3VVemtrdk05MHpl?=
 =?utf-8?B?NG9La3hHa0JLYysxSjFYZTNacTlZUjQwOXhjWXpMNTA5ZVJ1WU1tL01HTDBE?=
 =?utf-8?B?ek1TcTVTWjYrem5tOXJkRjFNK3F4U3lpdHZFcFNjc1M3UmwxdG5IWVRRMnNy?=
 =?utf-8?B?ZENTLzE1NFhKRGoxaE54WFludXVXMjYveE9Hd2xjK0pneGlSL1Y5UUtSU1ZH?=
 =?utf-8?B?Vloyc0VPU0R6MWVIZjFFM3lDNjJnMHpsRFhQTEwvMVBZT2tEREs0RWRmWmUx?=
 =?utf-8?B?ZlhFYUx0OW1GUXFoZldGWFlRSzdDWFk2WmZDT2FFN2V0V08yS3BOVXk4b0Rn?=
 =?utf-8?B?VnlwVWxWU3MyNHhMeGlBRVh0T0tWU0VKZFhvTTkwTFJIZTkxU1kydFhmaytO?=
 =?utf-8?B?T2pQSFZRWjdDWFdDTVZxd0ZzTG1Wc1lva2F3cDZqV2Z5Mm4wQmhQUW81RkJ0?=
 =?utf-8?B?UHRvYWExbmpmekc0cjNSUjZ3SC9uUFFIOEUyWDFiSG1UVEZ3cXdoNGVROVpy?=
 =?utf-8?B?VXRaSVREakhHVEt6WTZRR2l6Rk54MmpNUnhVRXBJZm9XMjIzSGVGeHBlZHNP?=
 =?utf-8?B?L0VHVDJNMHJvYWFQT0ZVbVhxZ1orK3dHanJ4YXNRb1IyRTBSRkFicHVDRTdT?=
 =?utf-8?B?dVBrTUoxNkZGQllwL3FLTFNvbUNnTUliRGg0NGRXdmFEdWVrQjVBbEpTZnFo?=
 =?utf-8?B?VjBsclY0OEViaFpQOUFERWdLaWlNcXRiREUwU0tJM3U0czlSVnN4R0xaYlFv?=
 =?utf-8?B?d2NjV1hEaURtZEpBNlAvZVdTUzRab3FodkYrZVVhRDJ5YmZEL0FjMFJ0d1Ix?=
 =?utf-8?B?MmJCK09oUWVqWkQyMUptbmJrZmpHSlpnZ01ZRlFBbHZCZlg4K1hZN3R2TXl4?=
 =?utf-8?B?MXo3QVZmeXgwbUwrZ21teGlRNFRtM2doZEN6RGxpZjlpZnhDRUhCVE5QK1Z0?=
 =?utf-8?B?NVhEeUM5aXllZmg3Rm9qektxc3QyRW9CU1pUWTZibU9uUnhVc0FQRkpkR3lX?=
 =?utf-8?Q?/8PrJqEU3xc=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:19.5016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fdb73c5-651e-4ea1-0a04-08dcfd81a260
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6422

From: Ilpo Järvinen <ij@kernel.org>

The following patch will use tcp_ecn_mode_accecn(),
TCP_ACCECN_CEP_INIT_OFFSET, TCP_ACCECN_CEP_ACE_MASK in
__tcp_fast_path_on() to make new flag for AccECN.

No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chai-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h | 54 +++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index fc9d181e9362..6255977bd7f9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -788,33 +788,6 @@ static inline u32 __tcp_set_rto(const struct tcp_sock *tp)
 	return usecs_to_jiffies((tp->srtt_us >> 3) + tp->rttvar_us);
 }
 
-static inline void __tcp_fast_path_on(struct tcp_sock *tp, u32 snd_wnd)
-{
-	/* mptcp hooks are only on the slow path */
-	if (sk_is_mptcp((struct sock *)tp))
-		return;
-
-	tp->pred_flags = htonl((tp->tcp_header_len << 26) |
-			       ntohl(TCP_FLAG_ACK) |
-			       snd_wnd);
-}
-
-static inline void tcp_fast_path_on(struct tcp_sock *tp)
-{
-	__tcp_fast_path_on(tp, tp->snd_wnd >> tp->rx_opt.snd_wscale);
-}
-
-static inline void tcp_fast_path_check(struct sock *sk)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	if (RB_EMPTY_ROOT(&tp->out_of_order_queue) &&
-	    tp->rcv_wnd &&
-	    atomic_read(&sk->sk_rmem_alloc) < sk->sk_rcvbuf &&
-	    !tp->urg_data)
-		tcp_fast_path_on(tp);
-}
-
 u32 tcp_delack_max(const struct sock *sk);
 
 /* Compute the actual rto_min value */
@@ -1770,6 +1743,33 @@ static inline bool tcp_paws_reject(const struct tcp_options_received *rx_opt,
 	return true;
 }
 
+static inline void __tcp_fast_path_on(struct tcp_sock *tp, u32 snd_wnd)
+{
+	/* mptcp hooks are only on the slow path */
+	if (sk_is_mptcp((struct sock *)tp))
+		return;
+
+	tp->pred_flags = htonl((tp->tcp_header_len << 26) |
+			       ntohl(TCP_FLAG_ACK) |
+			       snd_wnd);
+}
+
+static inline void tcp_fast_path_on(struct tcp_sock *tp)
+{
+	__tcp_fast_path_on(tp, tp->snd_wnd >> tp->rx_opt.snd_wscale);
+}
+
+static inline void tcp_fast_path_check(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (RB_EMPTY_ROOT(&tp->out_of_order_queue) &&
+	    tp->rcv_wnd &&
+	    atomic_read(&sk->sk_rmem_alloc) < sk->sk_rcvbuf &&
+	    !tp->urg_data)
+		tcp_fast_path_on(tp);
+}
+
 bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 			  int mib_idx, u32 *last_oow_ack_time);
 
-- 
2.34.1

