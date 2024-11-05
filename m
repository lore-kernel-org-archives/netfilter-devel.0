Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAC91D2B13;
	Tue,  5 Nov 2024 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801237; cv=fail; b=Z7JCx7Oioo4VIWPz2UnZEZZH/XCpUu1C/FP8ptrytC5RH4teu08BA2djaa4y9nIjWLPpvbs0F+oV67qKWDAke7IlJHVUdUtTMQrHHy5gx9SJS5UI7T0xfD7FEH89ASfwztArImG+BDQRjpMHWMDeXSdCJpV/SR635X6g55bNAcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801237; c=relaxed/simple;
	bh=NJEYJJzMDWgLOVoaVgooljRv6P8APPeNFprYiTxY5p4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7vTtB9thf/2WSzmU1SWWPl/ygenwb2wMRN3UcnVVGZbdqWmyji9iqcp+dkjMa8ykxgbh0+Q9g0F6YU7sPR5+pBiY2SJo1QnQvtbXKgFxS2w+tWZiuGF+fsSfZEGPAqJ8SUtlUyXW4yMrgjMIAaeXECxhzjL/JjL2oF4A6Z19UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=IjL67B/Z; arc=fail smtp.client-ip=40.107.22.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="IjL67B/Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhqtEMLkX75MWnuHLWgUJbfcTfaTpR9HsY9Dcm9mhSOqyaOWCFAAbJ+oj7ICCA/hhd11tBoSj6u4QphEka2laLPMGSRtd97EpCvae+sBdnh54+2BGgbRVzNMq21gpiFE97d9/y8vWDI4fxRrxGtPJSpN6G2YiKdifdVjk1xR23aSkMcIoe/IVnWKX6DldEYLx/rc4cS1LkhHKSTfh9Dk0dfVL/knroFrBM5nQruCibZW2LF4yejtK2kBYJN8TTEDaWQKbwsweILT9ilsb0iMijphoQSXlRq2b2JvyQ6th8mvqN09ACyjAt8SY+kctXmASURf7LdLSEpBixX9mASnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtfKEv3eF/eyKLurF4fP6RLz28q+tGELwANdcngos3g=;
 b=MfC/EEKsgpSiJ3WZCp0RrKJHLGmGe8t+55dFqlahPDwTDNGouaFQtX/iSYd/3KUzxeOZAXG+aTeflEgLKGla4dh/MsETQJPXIWbzdFLOuvbaWyUYXR/CMOXpa7GRseOfGPwt35vl1iYhIUYoAUsbBvslwx665ekL1ovvnpngTNmgjEF40KtLjE+vtd5yT7GRWO6YtQG0NxCxmCrbFwI9cnzf0Ejo15ESeDJp1DJp3kn94P5Nyux/mz2r7QvihSFq3oD4pfon6KwVPJBxzA1r1r0vZb+S5cX6Og3zIgSEhlmOPp0Sqjh1XMuhR7fHqZJch9+ftgICC+L16C73Vg9KRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtfKEv3eF/eyKLurF4fP6RLz28q+tGELwANdcngos3g=;
 b=IjL67B/Z/iF0kq2IQ51ed0mnMEKQHEZIBjo/aXCMKlhWFGWWxgb0okIwhLbG0944XCuEOj4dBq2eNyjfnqBvv/FTArnZy4yrnU2T1yBh3VWu2u1GwceRIpOT2pXHw/5iRkxI1Ru/hjBfGASlgXjEF4VFbQk4B/Ll/pjJFOA0EN1kWa03CCii9lCGJr9UjD1K5cLLVpc62nsnTv0Mx12Gpq5yuN/jbGoDGqFScj0iykVp1uBnQ+MQcO/ThkH8UGUva33N9DuvFrfWaBIIOywZyq22PYsTFvnFl0YzU+6DtCgZRYewPXUj4ES+EFt8mhqHEbY29zkNMei0kLlqbDo62g==
Received: from DU2P250CA0017.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::22)
 by DB9PR07MB7692.eurprd07.prod.outlook.com (2603:10a6:10:21f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 10:07:12 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:231:cafe::db) by DU2P250CA0017.outlook.office365.com
 (2603:10a6:10:231::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:11 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2h024723;
	Tue, 5 Nov 2024 10:07:10 GMT
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
Subject: [PATCH v5 net-next 07/13] tcp: helpers for ECN mode handling
Date: Tue,  5 Nov 2024 11:06:41 +0100
Message-Id: <20241105100647.117346-8-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D01:EE_|DB9PR07MB7692:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a7a667-6a7c-4532-81de-08dcfd819dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VU5NN1lBWXRxeHNucmpBY2NOTjZyWDFOYXYyMUl4aTkveXJibVZOVHptWGc2?=
 =?utf-8?B?eVUrQkx5K25kRUh6ZXF5RUI5NDUwc1lTMnFXVkRESWNtZ09teGNsU24zTHYr?=
 =?utf-8?B?VzFTM2NZK3dtRmFKY3dlNzd4U05JM0s4NnFMWDJmRFFqbUF6czdmRUxuWWFu?=
 =?utf-8?B?YTJVQ3M3a3pJVUxNZWtuTlRiZjZmTnJ3ZWEzWjNDSWx0VU1TWFZGOWxoNnkw?=
 =?utf-8?B?K2FUSDFueStRMU5vK3RBeFBvZHgwNkJ1dUtvMWs4cW9DNHBvNmpnK1lSL05R?=
 =?utf-8?B?SkxCclVRODhBUUFaajV6S2VTRWxNN3RxWVBUd0E2a0JnalUxS2JESVE4Qno4?=
 =?utf-8?B?Rml0dUsyUUZwOHdhN2pIWEdRL1ErWUVMb0gyZGZtSmI5OXA0bHJyK2hZSGpv?=
 =?utf-8?B?USs5TW9jclVialFYb0EySjYraFBLY3lSNlpNR0xuTDZSVCs2bkhYSy85akZx?=
 =?utf-8?B?Rk5SdndrNzY4YjVqTTBseHIvc1U5N3ZXWkd6bnZOa1kyNk1yNTIzS3ZQekhO?=
 =?utf-8?B?bFF4eU0xQ1hqa2lzNTBTU1Q0Z1lpanMzQXJ4anUvRkZSN1dEQmZ4dnBNNndG?=
 =?utf-8?B?ZFF2QXhHNGNFZEVMdjZkcjF6WXR2b25aYmJjQXl6R1V1WVp3ZnN3NzN0azRq?=
 =?utf-8?B?VzNpQlFvR3c2d2s4TVJPSkliMGZzR1NET2YzTnJFS1dpUkJtMXpJVVNGYmh2?=
 =?utf-8?B?UE16NE1TUjFaMkIxd3dCQnJNcGl1Zm84OUdDbnZHUjhFZUNEY1dtMGt6UE1X?=
 =?utf-8?B?RDFwam91YytOMWF6dDBFZmZHL2x5bUxYdDBOMGdqZDNtSkh3aG5DaGQzblhC?=
 =?utf-8?B?cjU1dnlDUzgxUDN6RU9yU3hWWTNDRDVUSTVGc3ZQNlFsVzBKK04xaFg0azJH?=
 =?utf-8?B?bTNmRSs5S2JGTEY4RHgvZlJYbFBLYkN2bHowcUgwTnVSOWlzbnBUUVhGczF2?=
 =?utf-8?B?OG5uU2lRN3R2ZmsyRG94S2ZFS3YrSi81WWNmWUora0wycDV4cWw3MXoxMnBD?=
 =?utf-8?B?S1pnSEVQa3dScEVOdXV2WERwaTdBbnZXaUpJZU9EcUlDWlYzYytFdmJCVHYz?=
 =?utf-8?B?MEVPc2VkbHM4eXQ3U2RwQXJMZmpsbTFVUDNNYkl2ZWJqaUtuczg1ZllaRDFq?=
 =?utf-8?B?cGNwYU53WWU4SUFOc3JlRG5kalFWbm94SVgzV096NjNnVnJjVjNvZ3lWb1NK?=
 =?utf-8?B?UldUOSsxSW1yQ2lSQktKQzI3MkhubDlEQUwrZUVGeFpLeWxGUFFvbHNnR1RT?=
 =?utf-8?B?MUVzN0g0WGFRelJod1dLbmZVc2lOdFBHelJNaXFMZ3dvdUtIeXFCcG55MDBv?=
 =?utf-8?B?VFd3RlBrQVp1Z0ZPU1QvZU12Sy96c3VYaE51Z2ErRitLcEJMck9weXZSR0Qv?=
 =?utf-8?B?Z2o5NlRYNzN2K1JyNXVLVlVwa0dObDF6NGJ4WnNsMzQySklkZlRWREJLMy9o?=
 =?utf-8?B?SWdIck1OdEdWV3JEcGlCK2VJcFYwOTJ4amllOHZscUV4TS9KSDVkeklLUmpR?=
 =?utf-8?B?ZlNtMXh4MlZHUTVJQmRvYzA1MWQzeUl6SGx2Nkp3ckxJQTllcU9QK1pxSm1o?=
 =?utf-8?B?d2lScFFjTmJGSWd1TkxTNEEvVjgxNDUxbTdCOVJ2WC83ZFJSQ1VOOVlwcDMy?=
 =?utf-8?B?MWI5U29tVXlqNWo5ejBWVW1KUWZKU3g4cHNqalMvM1crc2xHeVo2T2NaSGdW?=
 =?utf-8?B?VTAxRC8wUHpWNkZsUjhrczBYaHV4YlB4ZEoxc3dPRHhEUTdudVFha1JQanN2?=
 =?utf-8?B?TzU4SlNGZ2FiWDRXZDdWSWJTL1h1YnBQdlNQOWxIMXBhcFNNTFRUeHR0S1pz?=
 =?utf-8?B?Vm9rcUdKb3k3UWFIOFVqdkUyOG9nSGhGU2paY25RSXdPa0ZVTGVQN3ZUUmMz?=
 =?utf-8?B?blk1aFNRY3hzRzc1S2h6ZmRlSDlCTUoyVUp4RlpNRWF5OFFZcXE1ZVJyekpn?=
 =?utf-8?Q?lvblR5JRMR0=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:11.7689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a7a667-6a7c-4532-81de-08dcfd819dc6
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR07MB7692

From: Ilpo Järvinen <ij@kernel.org>

Create helpers for TCP ECN modes. No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h        | 44 ++++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp.c           |  2 +-
 net/ipv4/tcp_dctcp.c     |  2 +-
 net/ipv4/tcp_input.c     | 14 ++++++-------
 net/ipv4/tcp_minisocks.c |  4 +++-
 net/ipv4/tcp_output.c    |  6 +++---
 6 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a9948fe3537a..215b7ba105be 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -372,10 +372,46 @@ static inline void tcp_dec_quickack_mode(struct sock *sk)
 	}
 }
 
-#define	TCP_ECN_OK		1
-#define	TCP_ECN_QUEUE_CWR	2
-#define	TCP_ECN_DEMAND_CWR	4
-#define	TCP_ECN_SEEN		8
+#define	TCP_ECN_MODE_RFC3168	BIT(0)
+#define	TCP_ECN_QUEUE_CWR	BIT(1)
+#define	TCP_ECN_DEMAND_CWR	BIT(2)
+#define	TCP_ECN_SEEN		BIT(3)
+#define	TCP_ECN_MODE_ACCECN	BIT(4)
+
+#define	TCP_ECN_DISABLED	0
+#define	TCP_ECN_MODE_PENDING	(TCP_ECN_MODE_RFC3168 | TCP_ECN_MODE_ACCECN)
+#define	TCP_ECN_MODE_ANY	(TCP_ECN_MODE_RFC3168 | TCP_ECN_MODE_ACCECN)
+
+static inline bool tcp_ecn_mode_any(const struct tcp_sock *tp)
+{
+	return tp->ecn_flags & TCP_ECN_MODE_ANY;
+}
+
+static inline bool tcp_ecn_mode_rfc3168(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_ANY) == TCP_ECN_MODE_RFC3168;
+}
+
+static inline bool tcp_ecn_mode_accecn(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_ANY) == TCP_ECN_MODE_ACCECN;
+}
+
+static inline bool tcp_ecn_disabled(const struct tcp_sock *tp)
+{
+	return !tcp_ecn_mode_any(tp);
+}
+
+static inline bool tcp_ecn_mode_pending(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_PENDING) == TCP_ECN_MODE_PENDING;
+}
+
+static inline void tcp_ecn_mode_set(struct tcp_sock *tp, u8 mode)
+{
+	tp->ecn_flags &= ~TCP_ECN_MODE_ANY;
+	tp->ecn_flags |= mode;
+}
 
 enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0d704bda6c41..e30204394175 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4107,7 +4107,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		info->tcpi_rcv_wscale = tp->rx_opt.rcv_wscale;
 	}
 
-	if (tp->ecn_flags & TCP_ECN_OK)
+	if (tcp_ecn_mode_any(tp))
 		info->tcpi_options |= TCPI_OPT_ECN;
 	if (tp->ecn_flags & TCP_ECN_SEEN)
 		info->tcpi_options |= TCPI_OPT_ECN_SEEN;
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 8a45a4aea933..03abe0848420 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -90,7 +90,7 @@ __bpf_kfunc static void dctcp_init(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	if ((tp->ecn_flags & TCP_ECN_OK) ||
+	if (tcp_ecn_mode_any(tp) ||
 	    (sk->sk_state == TCP_LISTEN ||
 	     sk->sk_state == TCP_CLOSE)) {
 		struct dctcp *ca = inet_csk_ca(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b5654f94453e..bafd09ff9a70 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -334,7 +334,7 @@ static bool tcp_in_quickack_mode(struct sock *sk)
 
 static void tcp_ecn_queue_cwr(struct tcp_sock *tp)
 {
-	if (tp->ecn_flags & TCP_ECN_OK)
+	if (tcp_ecn_mode_rfc3168(tp))
 		tp->ecn_flags |= TCP_ECN_QUEUE_CWR;
 }
 
@@ -361,7 +361,7 @@ static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (!(tcp_sk(sk)->ecn_flags & TCP_ECN_OK))
+	if (tcp_ecn_disabled(tp))
 		return;
 
 	switch (TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK) {
@@ -394,19 +394,19 @@ static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 
 static void tcp_ecn_rcv_synack(struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || th->cwr))
-		tp->ecn_flags &= ~TCP_ECN_OK;
+	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || th->cwr))
+		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
 
 static void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || !th->cwr))
-		tp->ecn_flags &= ~TCP_ECN_OK;
+	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || !th->cwr))
+		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
 
 static bool tcp_ecn_rcv_ecn_echo(const struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if (th->ece && !th->syn && (tp->ecn_flags & TCP_ECN_OK))
+	if (th->ece && !th->syn && tcp_ecn_mode_rfc3168(tp))
 		return true;
 	return false;
 }
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index bb1fe1ba867a..bd6515ab660f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -453,7 +453,9 @@ EXPORT_SYMBOL(tcp_openreq_init_rwin);
 static void tcp_ecn_openreq_child(struct tcp_sock *tp,
 				  const struct request_sock *req)
 {
-	tp->ecn_flags = inet_rsk(req)->ecn_ok ? TCP_ECN_OK : 0;
+	tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
+			     TCP_ECN_MODE_RFC3168 :
+			     TCP_ECN_DISABLED);
 }
 
 void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9c47b46aa14d..f4ee86e2b1b5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -322,7 +322,7 @@ static void tcp_ecn_send_synack(struct sock *sk, struct sk_buff *skb)
 	const struct tcp_sock *tp = tcp_sk(sk);
 
 	TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_CWR;
-	if (!(tp->ecn_flags & TCP_ECN_OK))
+	if (tcp_ecn_disabled(tp))
 		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_ECE;
 	else if (tcp_ca_needs_ecn(sk) ||
 		 tcp_bpf_ca_needs_ecn(sk))
@@ -351,7 +351,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 			INET_ECN_xmit(sk);
 
 		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_ECE | TCPHDR_CWR;
-		tp->ecn_flags = TCP_ECN_OK;
+		tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
 	}
 }
 
@@ -379,7 +379,7 @@ static void tcp_ecn_send(struct sock *sk, struct sk_buff *skb,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tp->ecn_flags & TCP_ECN_OK) {
+	if (tcp_ecn_mode_rfc3168(tp)) {
 		/* Not-retransmitted data segment: set ECT and inject CWR. */
 		if (skb->len != tcp_header_len &&
 		    !before(TCP_SKB_CB(skb)->seq, tp->snd_nxt)) {
-- 
2.34.1

