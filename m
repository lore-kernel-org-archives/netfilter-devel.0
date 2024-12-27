Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2046.outbound.protection.outlook.com [40.107.241.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE11F8ADF;
	Fri, 27 Dec 2024 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326768; cv=fail; b=uvaGK+vcCUEMcnqCeP6FfFhvqOmUqrXkFTDBDKLZEcP/KmN1Nv9attRBo/qDHAeoVPpIAxfleVkQczM/7LFoRTrYeipGqe1xZfFj9w0/KrzhVZlDYCT/clpZlMKWFoi3otJvI6Nhfhk/ZhiG4eIxSJEEa4qbpZCbjAdVfBaolhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326768; c=relaxed/simple;
	bh=Oojgx23HQNPxXraR47CSiOn/RxhutAcAv3i6TmQT2Bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIpcvND8EBaV+COgvmtWl502abpe2ccI9q4BW2U8WsPTJg3hNjdTfgjhg4INyqsJ1cYY4dwB06HCLy7+1be/sAHIVzyny3RLx7OVCAjfEkcylWeXsfEch2EehhadHtyr/qMq63VqhM8lUma+koSvG4olkWify8RQ3qDb6JzSe8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=p/Ok/5ef; arc=fail smtp.client-ip=40.107.241.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="p/Ok/5ef"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FaeQMR7/GwM32RH5NkxLArmt+PrE0PR6sRPGyQJXN2qMZ0rac40gwxHobkkvwO+vlnmbO+fxJaOBKdxXqPWs5Wrv80DwuTrIihwtzPTED7RuI4l9a67m6PVddnq/aR8rh8nDKYUjXHNW8lJhqXyDzKMbE/3ddLdzVKwYdPJ1mO/R+XZKAfdPEbKehRFe7ZjSap2FQkdn9mdOoiUdYcb4NTcrKHjjqlyMXxlzgozVd2OdhFyXH93nUYTrmu4ZHW2g3EjvtyZWo05eLz4RCDhItX17ZrCsRcUaR36n2Ug0Bc4oUF/9aqAcHWq7bh4D4q1mhoXeHkVGhZCm7pGgtKvUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFCMQxwhqe4TweAabOVnMZ5cVYjk/vxMKmQJdV7ochQ=;
 b=FUUU1b5FqAxYpErg6lhVH7GtSLs4uCPXA8xI2vEh14bxtHN+x9dbddcwJLbn6om4IJzpjwptGRstwhbVPPxnY26UopQUW2+tY1whiun/1Wl9VIWLWb9AHiMDNllK/LPzwVOxzUDKnfdtLB/KoGfUgT4hVduIbWlxXE7t2nElqXHXAIuF8xnMtoyzx1XwWZbA3Tplhu1EToxq9Kb3Zive3nJBycr+knoqlb4YmNOKhl5npPJOtroYRVqBiRdnTCeFsghbMvH7XNKkUBrU0dfHK2pU6Gb2MAsO1ukPJRsgqC1khw4eS1oyDJuYglabP1agWM07pRAd16hdcWc/uVfswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=temperror action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFCMQxwhqe4TweAabOVnMZ5cVYjk/vxMKmQJdV7ochQ=;
 b=p/Ok/5efTPtp10R2sHcVTZMZaTbJrxviwshUIuiBpbm4Clhax7HUq/P6igLmSPHNLfsHqdPrLLcjkFUVGB93nltRcHyDkgaEHC8DZvq9N+DZ0bcwlXbpCotjBlqQGbicSgyah6FRPiRctvDUbVlH55hCh1XahQ7HRmu8xN1l3DTBpPCkZTuVBz3veKYsL49y1xLg3wQQhzUDYDFHnYiibxuMmJmmbld1ShKtxsVV5oZM0JA3jrbcQXa7ADKnvelaB0yg4qRhnl5hgg1Y8XuzoPVU9uSsPGmYGYDv7X6ueelXg7B0jKw3EAi5MmYmr83DLn7yyYt9OkgereWae6BYog==
Received: from AM0PR06CA0103.eurprd06.prod.outlook.com (2603:10a6:208:fa::44)
 by AM7PR07MB6231.eurprd07.prod.outlook.com (2603:10a6:20b:133::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 19:12:38 +0000
Received: from AM2PEPF0001C709.eurprd05.prod.outlook.com
 (2603:10a6:208:fa:cafe::60) by AM0PR06CA0103.outlook.office365.com
 (2603:10a6:208:fa::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:38 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 131.228.6.100) smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not
 signed) header.d=none;dmarc=temperror action=none
 header.from=nokia-bell-labs.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nokia-bell-labs.com: DNS Timeout)
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AM2PEPF0001C709.mail.protection.outlook.com (10.167.16.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:37 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2R011940;
	Fri, 27 Dec 2024 19:12:37 GMT
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
Subject: [PATCH v6 net-next 01/14] tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()
Date: Fri, 27 Dec 2024 20:11:58 +0100
Message-Id: <20241227191211.12485-2-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C709:EE_|AM7PR07MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b54cf9-51fb-4a04-fbed-08dd26aa6d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFY1OTBpeFd0bUlqL1pvU1NlWFo2aEUwRTFqNE5UVG9JeWtsbzV2MllPZXdt?=
 =?utf-8?B?QVcvRm5qZGFZcU8xWklKWmNsd0tWK2pVYUZ1Z2VyU1Z2dUh1dTBxMjRIaVMx?=
 =?utf-8?B?bHIvNDYrWTJmMTIrUy9qaFJiNzloYXNlM05kbm1zWW8xQlNZZG9HVkdpNGhR?=
 =?utf-8?B?Tzg0MnQyMWU2L0pnRHByY1BzMjQrNGFEdHRVR2dtcldwbTdqaVFvUFZjdlFD?=
 =?utf-8?B?b2ZZMDZWdUVwVCtLTWdJazRXd1NrRjQ4TG9ZcWVxeXo4Umh6dHVtRnlmSGhZ?=
 =?utf-8?B?Mkl5SFVWODZlaWZMakk4OHU3WlI3cHpEZ25QdEs0THo3eUdSQzNOVXFiV1Bq?=
 =?utf-8?B?aWdHdXc3KzhON0VyaHEwcEttMUFGUDdNMUxUbU5NZWFyclpndkU2U013czMv?=
 =?utf-8?B?eVFic1NIR1JnMGhydDZkS0ZmQlNPSHVkUjlXVjFTZm9rTVdXTDI1TlprVEp1?=
 =?utf-8?B?ZzNuY1FBaVo4QU9IM1JkajZqRVN0Q0F0bityMkRwOXJlWFJ4VjVyenA4VTBS?=
 =?utf-8?B?THlZUjA3RFJsVGxLeXBCR3p3a1gyeGxJcjhsU3Q4OXpFYzgzMkllNmNub0w2?=
 =?utf-8?B?SlBoOUY5M2NpSjlKSVlSb1BmMDBRZ200MDJxUzE4UEhiSEc4YndjODdoRFJq?=
 =?utf-8?B?WjFxZmQ5dlFHYkJtRFcvb3QwQnN3RWwwaFFoMitxQ0ZVaXB6cTBtRGFWNGVR?=
 =?utf-8?B?KzFKZDBXVmJadDdydmJWQ2VQejBDdTRyNnBmbld4Rk1vNVVTR0c5UE1PZU9X?=
 =?utf-8?B?anpJOEhXQndobjhNVE1ZTUF0Qkl6NWE5Y0VKOXB1Q2FTTTBieEx0bFZ2QXF5?=
 =?utf-8?B?by8wTU5RTTJSNXBnRVNnUkg0RUxtd1ZXdm4xbGlHNGs0dTJxTlJlMUZia0cw?=
 =?utf-8?B?TUtZZ0doT1ZCUXNHbG1mc0dSelFQblMzN1Y4cktXVnlpSUlVSW92RHRUNzVM?=
 =?utf-8?B?Sk54NEhnTVdOZzB1ZTVGaitRSmtWTVpucndlejNDWlIwdk1aTVViWmdPOFly?=
 =?utf-8?B?SVd0R1VQbTdZTFhNdy92QkoxaUI4MFNmakdOWDZMbVpLZnVvSTdaYWxYanBD?=
 =?utf-8?B?VlVzVWovZDROWmljK1I1aFNtcm1nU2xENng5cndyNnU1allhYWF3YXZRalZS?=
 =?utf-8?B?d2hJSk5NK2xDemxCdjB4MXVBTngwN25rWkRENXZ3NHIyVGNRaGl4dkx0NnBQ?=
 =?utf-8?B?OVJHSEE1RTcxTGtUS3g2OFpNeSt2cnBadTFEYXNZWWE2OUxpbnhNV0ZoSXR5?=
 =?utf-8?B?RzMzbWk5bDFmeHhENFdFVXpjSlQxVDJBOEdVbDVzR0N6enBwMW1nakVvbnl0?=
 =?utf-8?B?MVR3b1JwK21Ib3JmMDhkcXhhakVaOGkxVXZWc3V5QmlZaXp4OHhLNko4M3pw?=
 =?utf-8?B?YmdXTDBkVWEzMHhKenpYTXlVQ1NnWm1Eb0Q4SkJLelRvdSthVWo0eFNvMnVy?=
 =?utf-8?B?NVp6NUhweUt4aEN5MjZ3bDBnNHo4bVp3dlZ0TU5ibTRvb3pKaHVuTTRQT0xv?=
 =?utf-8?B?bnZvOVQ2QSsyZHFXeXJSbFhJMkk4bzI3SzcrZlBKZldVM1hyWlUyOUR0SHU1?=
 =?utf-8?B?NXcrNVRhQUM1ckR0SjNtdjFiM0lVWmxKZUtzTjJqb1NVMFd1OGs5ZWpwN08x?=
 =?utf-8?B?c3BmeEo2VDBudHFoM1V2QnBQUGEweDNsZFAvWXJ5Y0ZuVFB0QVdWL1pJZDJ4?=
 =?utf-8?B?Rnh3RWxYYkFybzdxV0tqSE92TU9RWklGQ1ZjZXdUMXpHbGtEZzhDbkVGaTd0?=
 =?utf-8?B?dGFmOGhFTzFwWUNmdnlvT1JlbElYVHJwb2NaK1YzbXVDeWdBc0JLYXJXY2dv?=
 =?utf-8?B?NlFkWHErR2J5ZHpHUmV0d0M3WXpsaE9XZzBGaXpBRDZPRUUrb2JWY1pQSFRB?=
 =?utf-8?B?OXZWbVpQd0JLZU5aeXB2WEdqdkxRNGpwY1dWYlB4dVFuSmE0ZlJ0UWdXQmI3?=
 =?utf-8?B?ZXg1aUQ3enJJaE56bWh1SmdXcGNaRVFma1c2NXpyZnlFRG00eWZGY0V1REph?=
 =?utf-8?B?eEM5RTN1c1lyV0NrOE04OEpIOGh0VHp5K0Z4Nks0NDZvbUZUc1BtdVF4M1Bt?=
 =?utf-8?Q?Sv7IxR?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:37.1641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b54cf9-51fb-4a04-fbed-08dd26aa6d12
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C709.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6231

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
index 5bdf13ac26ef..f3691c1cdc83 100644
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
+			ack_ev_flags |= CA_ACK_SLOWPATH;
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

