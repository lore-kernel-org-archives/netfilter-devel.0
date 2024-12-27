Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2082.outbound.protection.outlook.com [40.107.22.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197A61F9F61;
	Fri, 27 Dec 2024 19:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326788; cv=fail; b=K8Ha1WxP+NPPetJpC5ABGzlQ/NRcytwvIT5mgOH7NfRiX6w68t0PkD9ADEKxc7pFH0zyWZf7W2eb9lK0xqCt+Ij/PMYZyehDtJr1KeogmjOq1lTPP/7e8N067npjcn9IhX/V2kDNRH51BdTB6zjnovZJlo3GtLtB59ZDxdO+e60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326788; c=relaxed/simple;
	bh=B63K06fPZIJMBBkJnXuewYLDXar3vfB7ly9mpRijW4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=df0fW+PybttAuTaHvuW/hdk7bUVBEYOF4qZcL6s6bRHKXPGSpT/jb5tHYFRKubV/NLiBMqmf5aTzmFg7NVnJfu0ldQH0aoBV4dyJM+E1BMjHed0gFnUxrRo0itq62voLZQPQayGBNN9dPKfqGh0tpxHoEzYgvRjDHlEvlSLPQwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=oX1UznHD; arc=fail smtp.client-ip=40.107.22.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="oX1UznHD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfwcRpNj+tlsn/dtk+3Bazq3kBC4xRUCvF12sSdBFFpFX8yuBSzmcs2DVP+AORnqpq6j/UDhX0gVOTYn/WbrFrCtYtaqh192NVcWYqqRoJdR3iS/ABAS3BHvdBFi6ECK4HjdYzXDsUAlbN/FDPEAxFKPAAriEVBDkQQLJdrVltubXeCKERkpDle+wm5whrCr3/qbLjEgW7NNHqAvmSCEXNcyC2MviK/TLSuKF+YCkgkbGbskxwW9X+bVukr+D7fEJXPl61mE6FXmfuwkkHooLyos+sLcXU9ciLPOpAm2iyF4Gu+F3SONrw7VOOXlHFl5l7ZNEhPH+9nnOvuKN8j9lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAGbLNm+95eLXZ6Y52xMfP03JQ+w6fTE3HCUYf1s4rM=;
 b=uyNzZDBa2lDv3p0qpyjgUWnI6GEV5NpvBGTWp87ah9PyvoBAtQYPHfJ1A4WWQunZhbRA7fuTtI1Q+lWiQJZikuYkUrRhejfOCO6HXJJUuib0AJbbCi9pa/uMMfKHcr6D07FhQFfC9qLjBPVoPbQEnCs8YdoSN76Egnh8ggY0cIaJSZyKshx/dSxs2v0yOphGp0niXZltXZE0mXkodqXF3EHqJE9HpmFEU0tavNkt4iVZgV4S4UaX7INURK4RRX/aQJq3xlXSpB49t2LBUSAucojR7zeJL44TM+Tio9oXmRL6pN8X1M2ZZV7xRzHfUIj/b9iSMfe6+k5h+8pVpBOR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAGbLNm+95eLXZ6Y52xMfP03JQ+w6fTE3HCUYf1s4rM=;
 b=oX1UznHDjkUISb8UyRugGliHbpesObfiNLtXCS49Y/iXtfc6fzxYeIWvnbMgZ7s1h3WQtOumT05PTuC1kDVOfYVI2wVxd+bq54J43R0lOo3zCNlVPhSKE6eFz8Os+fRuS3Y7l99NP/kOpteBsYAdNAh5U6PF7MMSP9m9+BrKUzOf1yddqxK3W0xPXgPnsr/9ObJ6iiWrs7HWjvWYryyEFbuJGY8SeVISA+wRWXstBBBBnZpG77WsyZc0w6LoAAfKrJyDkuOlVOsVvzKmi0kOpkIXb/VyQReed+95A9ZMcQBWxdYNXQewN/t5xr1V8Yc26Jq3pHqvkAitc76eMeeu/g==
Received: from DUZPR01CA0334.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::25) by AS8PR07MB9019.eurprd07.prod.outlook.com
 (2603:10a6:20b:56e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 19:12:59 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::ff) by DUZPR01CA0334.outlook.office365.com
 (2603:10a6:10:4b8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:58 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2e011940;
	Fri, 27 Dec 2024 19:12:59 GMT
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
Subject: [PATCH v6 net-next 14/14] tcp: Pass flags to __tcp_send_ack
Date: Fri, 27 Dec 2024 20:12:11 +0100
Message-Id: <20241227191211.12485-15-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DB1PEPF000509EB:EE_|AS8PR07MB9019:EE_
X-MS-Office365-Filtering-Correlation-Id: 380a70c8-8d4a-43b9-9165-08dd26aa79ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlFzWXFvcE1tZCthWVB4SFRrNDV4R29hL0RScHZNR0NjTUZ4bVplbVZ6Z3pR?=
 =?utf-8?B?R1NpaXJPVU5oRnJ1VE40SE0zMHZwUzhhSkdDKzBZMzUwb1MvQVRkaHFLbHd1?=
 =?utf-8?B?TnY4Um5kWWZ5RDRUbjdVSXVOWUJnZEd5aVpxZGY5WHF4M3dMY1F3WGtsbWNk?=
 =?utf-8?B?UnhtUmEzeGdNaU9kV0RTYS85ejFUWGRHNGkvQnFVd3k0NzVjQWhmYW9ScURC?=
 =?utf-8?B?YXB2WEc1aGJqZzBaZ1c5SmlkMmF6b0llV05jU1k5djBpdmVDcTRpYk9FVmxl?=
 =?utf-8?B?R2w0L3pzRnhJaGo0a2MwVTIyN3dkWmk0M2M0UHJzZTNGdWxobnRFVWZLZnVn?=
 =?utf-8?B?eGdrd29NbTZ3ZFd5b3ozY1VPRVErVTEwcmVSYjM1SmNtRG52Nk4xMFZpbkJB?=
 =?utf-8?B?RjlRMnA3Y3k1UGFYUkF4YU5ZM3J0Z3dpdXg1VnJXczF2UnhSdTlnNXorS01R?=
 =?utf-8?B?bTFuek10dVk1SlNzN3hBQVd5dlJHYU5kWlNmeVVDQmJUMlErd0N3ck5oaGFp?=
 =?utf-8?B?STQxSHNPS1d3UnBFTVNaTVh6SCtRcjNEYkVBcnB0S1pYUk1WMEZXazZubjFt?=
 =?utf-8?B?ODBhL3VMQ09PSmhtckhNdERydERvckxQN21zbUF6UERyZnZTaGI2cSt1eW1Z?=
 =?utf-8?B?ZmpWR1N3bS9rQ1p1L2JUeFZQakVHQmRSaW04MXA4R2VyTGt3NHBqbkZmYk1h?=
 =?utf-8?B?SjJYbitFalVtRzJxSGdPSzdocWNmQ3BsTzR5amZpRlFxRGpBMDdxU1RVTUpC?=
 =?utf-8?B?L2FVNys3TGdjZDBOQ084VUtNNHBUNmg2YTZlMnE5VnBhVko3dkc4MWQxUzQ0?=
 =?utf-8?B?YjhuVUdKajBwT3JaQmg0SHFFTVdod0hKRjhZNTVsbkpJZE1YcnNKRXdsb3hs?=
 =?utf-8?B?QllKZlFESGg2NDMwSVh4OGc1VWZKRXFUTko5L21Tb28yTks2SFhEWkU4dVdS?=
 =?utf-8?B?SU1yNlJBcUV2eThnc0JPSkpsMUMvM2lBdnFKOE1kZDhpQXREYktVK0ZkNUd4?=
 =?utf-8?B?TktZL2FFQ3F3L0dSU2Y5V2hYZyszOGtnbXc0djRtYm9tVHpFRk80a0VnK3Jt?=
 =?utf-8?B?alJKQ2pnbENNR2NuS1dMdkkvN0RJeE9KemZEamNjeUtISjltUkVsRlZ3ayta?=
 =?utf-8?B?bVAyQmZ5ZWVDWE9pVXZkeUhNdUJQWEVBaWZ0YUQrZmEzUVhRcVpzSHFVZzNr?=
 =?utf-8?B?ZS9LNFJTSFZSK1lpNTVwTmVlalhXTFo1Y0RqZ21OVUdaNHdNQlZjZnJWUzFG?=
 =?utf-8?B?ZFViVmFPcGhtN1B5UmRTRFptd0g2SDZ5WTlhMml5eFYxNGlSKzhwVGR3blVw?=
 =?utf-8?B?OXRNbFdZR1hjcEpkREhoTFp2WDlLOWkwWUtrQ2FrVE44bXRIVTRHRXp3a1Nq?=
 =?utf-8?B?QXE2VldrY1JXNWloSkVVMFIxaEZ4RGtKam9La2FzaEFoWHBnZ1djM0xYZ1oy?=
 =?utf-8?B?L0JvQnJZVUhVWER0SEMvTmVGY2dVMmVWM0EzOWovN0kvdjZha3ZENmFhQ2Fi?=
 =?utf-8?B?Y1JaYS91ank5NVBqbENuS2JoWFlRRGtFa05WWXZmWWZzNzROK3lQTVdON1hh?=
 =?utf-8?B?YzdRS2p3WThncUFoVjgxUjl5a0FXT0lpRDNkMm1vK1h2ejhzTU9BcDVBaTdW?=
 =?utf-8?B?THNDR25BVWE5Y3dzWHV0c3Z1Q3RJNVZldStvQWRzMU90Q3Uyd0RTZ3pNS0Mr?=
 =?utf-8?B?Z3ROZ05yc09reUxJdS9VMjNMdGpEKzUva3pCVXNGdmNzSDROaUlBQWFwS29V?=
 =?utf-8?B?clZPYkpUVzBGU0w4MG9HekcrZ1lMektTQ2x5aHRhb21DZS9VUU9KWU5oOXpo?=
 =?utf-8?B?OGJlQS9rR0txSDd4WU91bDBWWmw3Y2VQTFJMcSsrdnZib3VMai9rUmFxM3dG?=
 =?utf-8?B?SkY4Ukp5Z2kzVFg1MjQxZTNOUStPTStwdm1jQncrTGFIQWZwbWk0RXJyT09n?=
 =?utf-8?B?S2x2Z1c0NHJaR3ZGYkIxdWdmNVU1MkZEUWtWUUhqVWowS1VFRWRVMlpuY05x?=
 =?utf-8?B?RjFlQ2paVGh1YjM2bVZhOVBkVDhIaWRlUklodGE0YzNVMzFWWlJPNkdmVHFu?=
 =?utf-8?Q?/gxJHh?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:58.8159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 380a70c8-8d4a-43b9-9165-08dd26aa79ff
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB9019

From: Ilpo Järvinen <ij@kernel.org>

Accurate ECN needs to send custom flags to handle IP-ECN
field reflection during handshake.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h     | 2 +-
 net/ipv4/bpf_tcp_ca.c | 2 +-
 net/ipv4/tcp_dctcp.h  | 2 +-
 net/ipv4/tcp_output.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a68c414b9407..5fde3e3583a1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -704,7 +704,7 @@ void tcp_send_active_reset(struct sock *sk, gfp_t priority,
 			   enum sk_rst_reason reason);
 int tcp_send_synack(struct sock *);
 void tcp_push_one(struct sock *, unsigned int mss_now);
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt);
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags);
 void tcp_send_ack(struct sock *sk);
 void tcp_send_delayed_ack(struct sock *sk);
 void tcp_send_loss_probe(struct sock *sk);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 554804774628..e01492234b0b 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -121,7 +121,7 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 BPF_CALL_2(bpf_tcp_send_ack, struct tcp_sock *, tp, u32, rcv_nxt)
 {
 	/* bpf_tcp_ca prog cannot have NULL tp */
-	__tcp_send_ack((struct sock *)tp, rcv_nxt);
+	__tcp_send_ack((struct sock *)tp, rcv_nxt, 0);
 	return 0;
 }
 
diff --git a/net/ipv4/tcp_dctcp.h b/net/ipv4/tcp_dctcp.h
index d69a77cbd0c7..4b0259111d81 100644
--- a/net/ipv4/tcp_dctcp.h
+++ b/net/ipv4/tcp_dctcp.h
@@ -28,7 +28,7 @@ static inline void dctcp_ece_ack_update(struct sock *sk, enum tcp_ca_event evt,
 		 */
 		if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_TIMER) {
 			dctcp_ece_ack_cwr(sk, *ce_state);
-			__tcp_send_ack(sk, *prior_rcv_nxt);
+			__tcp_send_ack(sk, *prior_rcv_nxt, 0);
 		}
 		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c2763c3361ad..9fa58ab46aa6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4232,7 +4232,7 @@ void tcp_send_delayed_ack(struct sock *sk)
 }
 
 /* This routine sends an ack and also updates the window. */
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 {
 	struct sk_buff *buff;
 
@@ -4261,7 +4261,7 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
 
 	/* Reserve space for headers and prepare control bits. */
 	skb_reserve(buff, MAX_TCP_HEADER);
-	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK);
+	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK | flags);
 
 	/* We do not want pure acks influencing TCP Small Queues or fq/pacing
 	 * too much.
@@ -4276,7 +4276,7 @@ EXPORT_SYMBOL_GPL(__tcp_send_ack);
 
 void tcp_send_ack(struct sock *sk)
 {
-	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt);
+	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt, 0);
 }
 
 /* This routine sends a packet with an out of date sequence
-- 
2.34.1

