Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2088.outbound.protection.outlook.com [40.107.22.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8241D3627;
	Tue,  5 Nov 2024 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801243; cv=fail; b=hv1PruNkGGvRM2RxqasLv+v40pcGoLxENTUKe+835jiRi2FzvyBYb9sRSV/M8/Md7OsBzyuT2IIBeaBFKxJjAykeLWqpxxCaqgErPgmThCQP2iIHgIfLrdQaMS4h493gW5DntBR56worvHghHzopK22Rls2aPQowZpiErOf1qSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801243; c=relaxed/simple;
	bh=ssjxVEMcvpaVcfyj3lHG+KGc+gIGqQWYDIRxqflhA54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dpv0dkAWPjcEYOKZ+qwjRSlyX6ttWTZhbKnOx0S/2uBHJWmzkZvpdhWB7WdxW+sShyGsHAjrJStTLQgtynzuqRy0fy0U9BF+aPhjLEgf1n6b2DQv0v2eocnlxGuVwYxJCiMUKsjpARVJDKbsFdr7PFLYZ1gPksq7E+EQ5W8qmO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=BOZ1OpKP; arc=fail smtp.client-ip=40.107.22.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="BOZ1OpKP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bCq+LTvXZxaM1cZG+6DkAcAgQDDYiCbdYAkfMbiKL8hDEFFeSzqDtQv6T4GaBfaDuNpWTRwHfEV9xmaun6tN90v5Z5DPOXd1d4SsWS+9l/ZmamNAM7e6X7uQQq2izItMmfMK1oUpgUiulNWekf1DUCI9g26cCczrV7lFUV42trO4kgkZq9orwdYjlH8+dTuzPRprETGwyZoUeiKxUiQ65gn2bDJ/zXdAyu3LlE5OD7IxeSjv7WAhVuLwbLJed4wrExyqa3erlQe9u3zzORmaYB1PdBpEobMx5OVID1eEoIrPQ+QNdQED3KcCPFxAjWnLmcuDpYq8pWfFt/8eB9bBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1pZXl5+kCUsPEVD9JDjJjXdEzcn3u/itThiBuxhFZI=;
 b=x5M2PbNB/Ol7ODn4SAqt41U7cqEbSin12KlYPq+enkTdAaQ5CkDLttscQfdUabuYoQ7FLtqEAT/MUsl5iC2ztegh+cfqG0lIcLj+QMOTaYbrS1kgfUZclkVHVAD8BVx2TWYNkQBNuB3LqgKCobbA8yVz+uhuOWA10RVg9DV+2JleFjOYTj/ekmCoIWqBVTdGwnjwio9AarnxkqDIh14acssXh76ZUf3LDcCbML1ghJWK29n5gIRHM5P4ZSZ4A4o5DSjsYMdpCgTHl9RERGehdaYku4PFnNF0cxTNbT7fb0JWvvoM7fwo+m1mDHutU5LfB0LQXY3uOn7QKJg4TkfvZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1pZXl5+kCUsPEVD9JDjJjXdEzcn3u/itThiBuxhFZI=;
 b=BOZ1OpKP0ThZLtBspZuCMaTaNQur+kP1rMr3Uudp5ZFj4yAiqcIDznLCV82LSBoUBo1VXglSYRLSxysLxXo0KEzYMi3QAEHjIsVlKAxslubzX7Jb7OgaarKBa5g693h9pTO35AScLso+7qaEemW9rfbtJ7kwdgkqG09mfqzNz98peIftJK4vnvNvfH2lG57BBpboV+4ABRvf6uwBdeLR2XFgpgvsBM+pITqRMkW1xNZu3G5XAL1CDJel3+6WbotQSp9WIgkBnd/ZK+lgQ9pgNPpjvGZYh88hl7leiuGwWmgQgshJ8mHuXzd/c2YhI6QkZDSgHjmMHaBOSUnrGEev5A==
Received: from AS4P191CA0054.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::12)
 by DBAPR07MB6999.eurprd07.prod.outlook.com (2603:10a6:10:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 10:07:18 +0000
Received: from AM2PEPF0001C714.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::41) by AS4P191CA0054.outlook.office365.com
 (2603:10a6:20b:657::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:18 +0000
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
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:18 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2m024723;
	Tue, 5 Nov 2024 10:07:17 GMT
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
Subject: [PATCH v5 net-next 12/13] tcp: Pass flags to __tcp_send_ack
Date: Tue,  5 Nov 2024 11:06:46 +0100
Message-Id: <20241105100647.117346-13-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C714:EE_|DBAPR07MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: a52d718c-889c-44f8-c4ea-08dcfd81a1aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnFWb2h6SmRDU3Q3dnlHbWxuNmlJRi9abDFFclFZM1kwYVhDdStENGxBNGFX?=
 =?utf-8?B?cjZJVWtUM2Vxd3dTOFZGRzFpTzhaQWE2ME5zK2xtdTB6T3pvV3FIRWFjWjdi?=
 =?utf-8?B?dXloNjl2LzAzbzNFVklIWk9CeXZ0amMzZGp0QTFOSTV2dDFuUGZPNFRKaHJt?=
 =?utf-8?B?SUlmR0x5a0lYV0hxS0lsRGRoT2Y5TlpHRWJ5T09sMG9xSXB0TEhmSUtBaFJF?=
 =?utf-8?B?Yk9uaHZtNmZaUXdoZng4NVVRRUxyMVlrRDNyK2c4bVEwU0tSem80U05abnky?=
 =?utf-8?B?eFp5Q1pUTjJ0RUI2UnlXcDFLSnNRV3hsUFZGamJkZzZqdG83c05veDhWMVZl?=
 =?utf-8?B?L1NJbllIYmYzb010RmIzUXBaREVPRFYxcmNHVTFINGJIcFJpeW5RcFpXRGVF?=
 =?utf-8?B?dUVaSzExUjhoMHMzRk9hbXVkRXlPVWlKNWtwVk1DZWd0REVmY0NRVmdXS21O?=
 =?utf-8?B?cERnM2xmbWoxdzZzOWNQTTFocGkxRjBJenVxVGYvdm1KMU5ZczdVN2I4Y3p6?=
 =?utf-8?B?U2FhS0J6bVV6VnczaG56RTN3NEtrVkQxamZmSUNCTVRSVXFSSWZDVE9Sd1R4?=
 =?utf-8?B?UGtZWDNrUXAzNTFKSkpnMEwvN2hiV2ZDMFNJL0VVdGdCWmduRzgwNmVTb3FJ?=
 =?utf-8?B?eDlLSFVzbWJTOTF2dUwvdndpUmdlVXA4WnhSQ0RocW9saWVYaCtuNXJLWHEz?=
 =?utf-8?B?eEpDaUJDY21ReG96V2xwRmZXYmVwMTZjaVpDd2ZTRG84RXN1MllmQVBEZXNt?=
 =?utf-8?B?Q0Y1ZURBcEYyUHlRZ2EyZHBHT1JPMEJYY2JIS0RKTkpOK2ZuWXNvQWN2SFhR?=
 =?utf-8?B?TUVxUHhRTTBXUW1NdTBXSFpGdjZTNXc4bzFIM2RPVzl2Rzl6UGd5OEpUT1RK?=
 =?utf-8?B?TC9xZmVLWUlKT09nU2I4c2Q5N2d0REJudEVQTC9qakNHSFRGZDBtdTlMYVNY?=
 =?utf-8?B?ZkVKZHFvWlIvUXRBSWpEQ0I3U2dyOFdwd0plejNxRlRpbHlVTThsRzZEd01l?=
 =?utf-8?B?Vnk2ZGFvYi80VERQQm1VdU1rWm1nZ1pKZEpNMFdscWtjbjRmS2M1ZmNMVmtJ?=
 =?utf-8?B?VUlQalljdC9OQ3c5TjVEMkg5VG5jUjFpVWh5WXA3aGxCdWVEUTlTMUE4bXcv?=
 =?utf-8?B?WjJyTWR0M1praUJFNHIwS20wU2lGK3RjTDlmRDA4eHNwQmZReTZtWlYyYisr?=
 =?utf-8?B?aDhuM2lrRmJlcm96RW5UQ2E5VkFKL1MwUUhOUFJYbFFNSzVKTGpxeWtoZ2xw?=
 =?utf-8?B?QUt4RUhjdjVDUEpaSE4rQ284Wkovc2NGMUFzb3R4amIvSHJrcGQreU5QdlQ3?=
 =?utf-8?B?T0Y4a0svVzU5N2lmQVV0L1dEbXJIcTR3Q08ycm92NFNIRVFPQlplWWN2d1pr?=
 =?utf-8?B?TS9CTFlUcGppTzJuaDdQMzJSQW5uMnhZVERVTGNHTjVxK0Frblp6WEVJSHpq?=
 =?utf-8?B?a3NBUzg2Rm1BTlRxdVd3VG5KcGRscDdZMFhxTUE4UFVleWxHYU9ldEJlN0Ra?=
 =?utf-8?B?OVVwVXg3emlLRkRicEliQVk4cS9Tdit3dGQzNTkvNWJHODc1V3I3TmY4Yjdw?=
 =?utf-8?B?ZE83WHdoUER2RGgzU3JvTFNZMSs3eGlCaWVqOWxhd0dHL2pGSTA3Skh1RGVh?=
 =?utf-8?B?Qm5LamtFWFFCMnNHK1RwNFJYMlc1UWhKbjV6aTBpbFNmNFROWUVQaGI5UWVC?=
 =?utf-8?B?NTdIaUF6ZmNkcUNUUkpWSGVLMHVaQ1ZscmZTTkdMd3ZWR25FVFNtcmowWFAz?=
 =?utf-8?B?R3Fnbmg5aDhGNVhoTkJucllVQzBjdTgwOVVSakdwRXFveFpjWGtxbi8yVW5n?=
 =?utf-8?B?aEpHaEZDbHd2WHU0eVBnZHZOQUlVUWRLQXh2TGFTMmlkQ2Y0cVc5Y0ljTGVl?=
 =?utf-8?B?c1EvVTBvb3pjcTVGOEtrSitNUkhvbzZJbE01em1zZVBaTEw5b1F6NGhJdW5B?=
 =?utf-8?Q?ESw5WPpn4mA=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:18.3449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a52d718c-889c-44f8-c4ea-08dcfd81a1aa
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6999

From: Ilpo Järvinen <ij@kernel.org>

Accurate ECN needs to send custom flags to handle IP-ECN
field reflection during handshake.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h     | 2 +-
 net/ipv4/bpf_tcp_ca.c | 2 +-
 net/ipv4/tcp_dctcp.h  | 2 +-
 net/ipv4/tcp_output.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3a8782874333..fc9d181e9362 100644
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
index f4ee86e2b1b5..fdb4af44c47e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4230,7 +4230,7 @@ void tcp_send_delayed_ack(struct sock *sk)
 }
 
 /* This routine sends an ack and also updates the window. */
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 {
 	struct sk_buff *buff;
 
@@ -4259,7 +4259,7 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
 
 	/* Reserve space for headers and prepare control bits. */
 	skb_reserve(buff, MAX_TCP_HEADER);
-	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK);
+	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK | flags);
 
 	/* We do not want pure acks influencing TCP Small Queues or fq/pacing
 	 * too much.
@@ -4274,7 +4274,7 @@ EXPORT_SYMBOL_GPL(__tcp_send_ack);
 
 void tcp_send_ack(struct sock *sk)
 {
-	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt);
+	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt, 0);
 }
 
 /* This routine sends a packet with an out of date sequence
-- 
2.34.1

