Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2074.outbound.protection.outlook.com [40.107.249.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A31D2B39;
	Tue,  5 Nov 2024 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801237; cv=fail; b=BxocjfUjciqn7MSGjwEBmI12Nwc/eC0R0R/PMG6leF1tXI5Az5vE4wMnQNNS3FyOZ0+Cf3QuD5pEhJAXO3YH5VRNOpxambHdIdGJxLAqSDy+p9qDAqHQZvO6uVB010OqaAsqckg/peyjw5M4TRjDn8cLJe4r70d+cBLs70UL6hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801237; c=relaxed/simple;
	bh=E6/oU7XTbYUxrlKFEG4RUbEO6W4yeZQKW32oUlApFc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ov/zT6EHq7LPP0vB0q9yrjIwmzJgEwBGOyF5KF6q+tctQeqtLp8PS9+SpQj4CzLjRwEHCtaAlQwRDgvzEI5Xuv9tr4gCwDCJv2NFfnTX1OavERoxVbyfoEnPAKsLvqm9FG6sLvkRBqvay+RP3VX5eOfiIQk4lTBoFLdBHVxOzwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=uJ8uQjxQ; arc=fail smtp.client-ip=40.107.249.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="uJ8uQjxQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om0K1dznY9plFQ96dr8Z/3XxRaaFJpeWzNFBDr1lU/cuG/k7k/DfirV57Ptq3rmUdYfwtLTNJqc1Dl/p8aj4T9vgLyVX8GisMVCsIxR/Il/4Gr66/h80q/HEqMJWqbJkrKKWzo97UdzQl4WGlK929CItTy8p5We4p4Bkr4F/ZhdVcJ4/i8MalPb5pZeAA26bXNZamyh2mutzVtvCsBCgA/XbksbvalWW2TSPGM5HVjYNwste+vcaCQPA0CgRqwYhuwQSn5ZdELunpRfb/rk5HAx6ZS8MMcRwYZu2gBx5cHgzGoSsOO6baw9K219yUmn8b5F7n5LJxOnH8LJqUy64Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evfypev1jjY7AlGOflVED1L6E85KGTDkvWDuJDL/N7s=;
 b=VacJU4Y6Pvl027ZHpe74DyTgGRvoXDHY5YZ7/ejeJgmDw24R+dibiNc/gyDKtRUL/65e39CoOipPHuBbdZ+wm0YkNcqRuS3unSxo/7N3lEA3xsqOJEMfIxkM0Nxg7LQIub1dFo7SBYQH48m/WFrwEqTMX/sc+rPboWJiAc8HzRYlJrAYke4RNupJA/aV1bWbYLtOagkSa2wvQZaLxmgXrf6JrmNtKYJdnxEpPaSmP2ak2oqGJSUvxSHiBcyrd6ArZRUq64L7jObyze7c2P6L3lsZ9hEwYCZAqXlw//O5/wnIrEV7hgforX3IqeyA1gK7Wa5gAOR14AZ3oXqbjKGRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evfypev1jjY7AlGOflVED1L6E85KGTDkvWDuJDL/N7s=;
 b=uJ8uQjxQDRTotQPwHAubI+6C+3PIdo+bonGm4dBpjy4mAFsBImu80hc1za4vx5IqRKVtqlo/A8mxPpORkzPWg4/lii8hvZdKHfTf8ZIiisuq/fM+BBtYdBBidIsRa8Y8k3Nl6oBgz4fJ/GUlD1cAhlDU1dhKYO4JNOB+RU3Q0kz+unV8rjoFBbhl4rMkHrfrqXDthPzsfLHdhdRD8f+IqvfZ0Z8J/iEn/KSpB9co50tOxPebIIoJtPIJQBhSlULxBR2X9zBmi4YwmWZ3Nf8PMX4bmRNmlphhst7MCOjZpB1He0vfFtqcSM8bLyFCmoh19AaiVWtdoK81s9NtzE9RAw==
Received: from AS4P191CA0048.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::17)
 by DU0PR07MB9194.eurprd07.prod.outlook.com (2603:10a6:10:42e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.28; Tue, 5 Nov
 2024 10:07:12 +0000
Received: from AM2PEPF0001C714.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::4d) by AS4P191CA0048.outlook.office365.com
 (2603:10a6:20b:657::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM2PEPF0001C714.mail.protection.outlook.com (10.167.16.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:10 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2g024723;
	Tue, 5 Nov 2024 10:07:09 GMT
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
Subject: [PATCH v5 net-next 06/13] tcp: rework {__,}tcp_ecn_check_ce() -> tcp_data_ecn_check()
Date: Tue,  5 Nov 2024 11:06:40 +0100
Message-Id: <20241105100647.117346-7-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C714:EE_|DU0PR07MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 21774a1f-110e-4794-99ef-08dcfd819d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVhQS0JsYkVrNjYzNnJ1S21EOVpnTGxBMHgzUFQzMzdSWXlmMXQxN0tUVWpE?=
 =?utf-8?B?aXNmQmtMKzFoM2VDWE9EL3lBUERxVm9xaWRvbGVpaVlhK3QvQ0xvelZFV2xm?=
 =?utf-8?B?WVJjM01JUzJXUTcvM0E4VHBOcEFYWlY4NHFKb1lHL0MxZXJxcWhTOUwyajFh?=
 =?utf-8?B?RUg4eUkvZkZROHIwOU9YOENPYnYxWWljY3NBblhnVmQ0UTJjdU93K2ptODFX?=
 =?utf-8?B?N0g2WDRJUm1lT0NNOW1iWGQ3Tm1pWE54STlaZEIrSWU4SVdkMVV1Nk1vaTJY?=
 =?utf-8?B?dkwzVmFIOW92ckJTSC9jWDZkUHg3WktrUDNTcFFVWFg2cVJhUVNZVGZLdVhj?=
 =?utf-8?B?OXlWdzRqM1ZuOGNLMEcydXQveVRUemg1bkUwMHVBaHVVK0toOERMakZ4Z2ZE?=
 =?utf-8?B?bTd6WHpkYnZCZHFzZWUyTlcvUlJDN3FqOTRLY1pjaHM0OEhYZFExYU94OGtN?=
 =?utf-8?B?elg2NkoyOUpnM2Zva3QvaC9SU1hOM2k5ZVJEUWRJR0pXVUMzTHVQaG9FQ3g4?=
 =?utf-8?B?UisyYnlWUzdyYmRva2w4dXQ4dVVMNTlDNUgwM1lZYktpRXNpaE00QVE2VUdz?=
 =?utf-8?B?bHp6NlVCdWtIREZOb3VQcnhkek1iWTJhM29tK29WRXlFOFJBTjRUblJDVkZ6?=
 =?utf-8?B?Z3RqVStvZVdLYUxFZkZSbzAzL0R6YnF5cFhqaVZZaE5TMVhSN2ZqTWZRaUhp?=
 =?utf-8?B?c1ZqaEU1TU5kZmVhMUZVSnVzaFdSbjFNa3p4WW9OTDIyOERUcUc1ejV6VmxI?=
 =?utf-8?B?Y09FQWd6UUl4aW1XYm5Md2xYWDJBSmxIa0FGQjZxbjZuRUdTQml4aSttcTh0?=
 =?utf-8?B?cS9GSCtyWGZibk9SSnFuUkhpd2RDOWU5ZzBod0xOSTZoaEhLOGF1Rk9mNjdp?=
 =?utf-8?B?TlV1UXUraHJyNGN2RmxvMzAvcEVrcDVLd2hJY3NyYmtYaEs2WVI1ZjhmN2NH?=
 =?utf-8?B?KzdlWVhxUW1ZUWlvR25RYzNSVmg5enJXQjUzMnNKeHFIeTRtdVVyWVJwVk5U?=
 =?utf-8?B?RUlTRmh1SWhXcE5ENklxRFJVUk41U1BUcWE2K1d5ZktYZm9JQmhnTlQrYUNY?=
 =?utf-8?B?UENudG0zOGNpVzVaWHJtRUs3MURZc1R1REdFa1A5WHFoYUxuYVBnanBlZnRO?=
 =?utf-8?B?RTlub0lGLzdXREpjdE1CZDd2MzNlTVhuSkQxUU1zSWRldzBRL3Vlejg2eXM1?=
 =?utf-8?B?eC9OWFRUd0k5YXRxNzhnNE54MFpaeHI5dncyTk5kRTRGOHNTa1d1dDA0OFcw?=
 =?utf-8?B?RkZKWXJEZENmakNGMjlrM3BpcTFYNEJ3NUFiWnhraG1wekU3V3A2RDd5bjcv?=
 =?utf-8?B?VHcrdVoyRzRqL2hMYW9peEZ3RkhoeUlKL3JPR0pqWXN6b0FrS2UvNzViV1RD?=
 =?utf-8?B?RHJWTUt3dTYrK21OdDhIU1RTKzBVb1JFV2ZyOFdMN0xPUzZ6NXYwMU5JUmxp?=
 =?utf-8?B?ZVNjS3VkWXpnOUloODFPVUpRYnVUOWw4c01vdStsZkFxVytGOUMvWmdLWDZ2?=
 =?utf-8?B?VWd2Y0hZNWlQT2Yvb1BTeE9yQitmaENFc1BJTjQ2dkp3bzhkYmJjbHZKNDZZ?=
 =?utf-8?B?NDIwRjJqVytUMWdvbnh3a3ZFQmJwUHFYUWFvT3drT3BTK2dJVUxDM2ErQW5j?=
 =?utf-8?B?OHRaUWtWendKeFhwUnNwR0huWUZzOElHM2NVNi9qMUw1QlJMN3FVVVFNZXEw?=
 =?utf-8?B?WURza2lJR3M2ZjBjZ1huQThFS3NQaENjNm9GNTRwNnRXdGF0d0N1MTdGczVF?=
 =?utf-8?B?YWdpNy9IQnBxRDNCR3lHYlB2cldsVXdsQTFuVjYrR3FuWEtSL29PT0NVUGpP?=
 =?utf-8?B?dlh4cUZGUnJQTS9WSnF6NXN1V0cydytMeSsyTDdSd2g1WFpLRnNHZWxvQ0s1?=
 =?utf-8?B?a0FDK0xaQWZJdXZVbXVVOXRhc0ZvSi9ZYk1lNjAwVUEzejNQU2dMQzlTbVdJ?=
 =?utf-8?Q?g1Pkn1ST/RM=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:10.6262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21774a1f-110e-4794-99ef-08dcfd819d0e
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR07MB9194

From: Ilpo Järvinen <ij@kernel.org>

Rename tcp_ecn_check_ce to tcp_data_ecn_check as it is
called only for data segments, not for ACKs (with AccECN,
also ACKs may get ECN bits).

The extra "layer" in tcp_ecn_check_ce() function just
checks for ECN being enabled, that can be moved into
tcp_ecn_field_check rather than having the __ variant.

No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_input.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ecb3de69c6de..b5654f94453e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -357,10 +357,13 @@ static void tcp_ecn_withdraw_cwr(struct tcp_sock *tp)
 	tp->ecn_flags &= ~TCP_ECN_QUEUE_CWR;
 }
 
-static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
+static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	if (!(tcp_sk(sk)->ecn_flags & TCP_ECN_OK))
+		return;
+
 	switch (TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK) {
 	case INET_ECN_NOT_ECT:
 		/* Funny extension: if ECT is not set on a segment,
@@ -389,12 +392,6 @@ static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
-static void tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
-{
-	if (tcp_sk(sk)->ecn_flags & TCP_ECN_OK)
-		__tcp_ecn_check_ce(sk, skb);
-}
-
 static void tcp_ecn_rcv_synack(struct tcp_sock *tp, const struct tcphdr *th)
 {
 	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || th->cwr))
@@ -866,7 +863,7 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 	icsk->icsk_ack.lrcvtime = now;
 	tcp_save_lrcv_flowlabel(sk, skb);
 
-	tcp_ecn_check_ce(sk, skb);
+	tcp_data_ecn_check(sk, skb);
 
 	if (skb->len >= 128)
 		tcp_grow_window(sk, skb, true);
@@ -5028,7 +5025,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	bool fragstolen;
 
 	tcp_save_lrcv_flowlabel(sk, skb);
-	tcp_ecn_check_ce(sk, skb);
+	tcp_data_ecn_check(sk, skb);
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
-- 
2.34.1

