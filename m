Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B9A1D1F70;
	Tue,  5 Nov 2024 10:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801234; cv=fail; b=MIg1neovMey6vvPrn1oQ7bfrQJlmJTScsxYi+eMT7RAC+U6KfcYUey2ys8fl+cgXX7TaD8aUOrxiFC7N/rs92GAYfQjPXAzIZyai1BLPZDyy4LF1D1i7B+cHnWk1Y0sse595461SEbfQLpghi/yRxzO7GXm2MUXeKJ0emtd3/ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801234; c=relaxed/simple;
	bh=ZUpqmapcQZlw3AG5m4SAohieBwkRCQPgcReyVEFDsqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RhuuN1mFNJAMWC+qfUBmjLdGSJppw++c/PyM8495szYDVsy1p6K7xD8D0hYZS7iPkdhrEdZlBajaQsszBeMhzQyMHXTx5c+NU5ZhUkMtn07Rr+I3D3Xpguql2oVQsTeDePIeJL6+VHYjCjGMFZiMPnARzTzXVnyKezVIavbZKgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=lo7lfmoC; arc=fail smtp.client-ip=40.107.21.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="lo7lfmoC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHJ9vEwF0UXgxdMK1rnwdqA+IK1PNg6cOr8saGFxQdgjaCxB629ITUqKaCuhP95eqZjz95glQpLr0IgO83H5aorjw7+Ra7Z1BFZ1vmYQgo3Uq3bdr4qWluwU6Njtv3XfQuxBt5u2mOqxf4gOSUdJpOiU/gFTLQ7R7XMOBzKHuDl6Kk7lcktKd12GT+9R6MNWkMRNOFtJ4GdJS8G8qhx8BK8Oy+yUOwMqsJxoy8r09YT5uoGbTnhV5ps0iTj01s0I0EABe84uUOavMUm3ixlk5yKGV7URXmpZKaSket1YVY3t7DLpzV3yurCYenlUuWUWG+cGNljqd6mY7kttruw3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ULNgEXIdwwQGMYZLblb14lW21AVOQjqSqY7fPxsNyI=;
 b=jGH6fjrKLKond6atk9M6JsqYJlBtGMmoNXqrvYGPqjbjHcNNnuN0nW7K2oscamsMI4LWBhvU+iJje+GJqrIJ68KjYcjAVk0DQ5tGLR46TcXotPZqRdR8eDR6dJREXqLUtHWfSF5Ybjm+YXzpXICz5GTUoaDCJmrrGRA35nQE41xa6jzfidJQGaoL/hD4TXaXOLfPUaKSjcDjR4bPhlNmzhSQ7+hr1ljjb/k/X9VrTxyCtUMBil5kHqJHjmfbK3MtlTv+x5HFV44Huiicqpj82Yc6GJ/K432Zqw2Jbja1dk6YKRZwhf/+iTr2DeF9r7Es3CrwLs7Ph1E17qE4+YFT/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ULNgEXIdwwQGMYZLblb14lW21AVOQjqSqY7fPxsNyI=;
 b=lo7lfmoC/qS/z4LHyHzrzGBNokTm1u1XZV5W+nStwcseFnMjaIgUAwGUOIvt6OZLcGb3tCuDSbZ+e1cnc+fsk2yMTPS03iKgn6PbwYyOz0vyOZn2nsPxgsS3RQ/scz8yU/EhTH3rLu6F2JQzZVlxEW6P10gLBCYq8TBJQQIeMga4ZzY8Dh9lxdIAAyY/5xxIPCrstTKqN6SgtJmEJhd1XLAEdkqI8FKMG66dZRwdtqOd5ujHh/AXHJZI+Qc1MlrMuMLZKqTObpqHlGG5uubRUQyQBCPb46re2knYOkOaER9h8e52CaV86zHNIo8lUaRb/Hs+kgAcrWvSNGa08Re/nw==
Received: from AS8P251CA0014.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::13)
 by PR3PR07MB6586.eurprd07.prod.outlook.com (2603:10a6:102:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 10:07:09 +0000
Received: from AM2PEPF0001C716.eurprd05.prod.outlook.com
 (2603:10a6:20b:2f2:cafe::e1) by AS8P251CA0014.outlook.office365.com
 (2603:10a6:20b:2f2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM2PEPF0001C716.mail.protection.outlook.com (10.167.16.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:08 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2e024723;
	Tue, 5 Nov 2024 10:07:07 GMT
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
Subject: [PATCH v5 net-next 04/13] tcp: extend TCP flags to allow AE bit/ACE field
Date: Tue,  5 Nov 2024 11:06:38 +0100
Message-Id: <20241105100647.117346-5-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C716:EE_|PR3PR07MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a18570-9580-4ff1-8603-08dcfd819c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NW9Tc3EvaFU0ejRteE9haEFseERVa0x0ZTFNRkVvaVlkSHlsbEZaTnJ0TUVx?=
 =?utf-8?B?U1ZvVXRTMmgxY0RuU2xlaUQ2N05ZY04zWDdtQVdWcGRTdzdBWXhuNVhLeWhQ?=
 =?utf-8?B?bU81TDVkUWNjUExpREFuRVVWUjU4dFhoYXN0ZnNuZFdyMFQ2Qm5rbm5Ja1R3?=
 =?utf-8?B?U1orcXRCZ1did0VVb3JNYjZTM2FRYzZYTkdUREpkcEExazhheDhzVy9DRVph?=
 =?utf-8?B?a3dMaHJDN1hkWkFFZUtWME9NS042emhOUTVaZUdrNnF6d0s0T0N4UTRyM0RG?=
 =?utf-8?B?V253cy8ydlVRSVFmMmNtR0RjUHZ2c0djZk1uN2ZoaWc1dDZKNVBadkJtTU03?=
 =?utf-8?B?YWxvZCtMdWF5SlVsZE1jMWRqdzF0eVlzUEFReU8yTlI3bzUrVU9TSDNyNnFT?=
 =?utf-8?B?UFFCdEVUSld5KytVWU5LMHIzSGMxQ1NrOWp1N3Y0cDhiUGV5b1VEQ01IVnBw?=
 =?utf-8?B?MDVZQmZ6TThCeDVLRENXVnE2cTFTbkZUTDFoR21jdFRBUkhFMEc2S1NZUUZU?=
 =?utf-8?B?Qm81bXNLaGZ3UE1QQTFuWWRZUUVSazlhc0QxVm44VG5PcWRMMGZYc21ET1Ro?=
 =?utf-8?B?NW9iWDF5Z001cGRWNkpZQlpEUDgvMG8reEUyZUo4eWtScUxhVnVWbW1GeXRu?=
 =?utf-8?B?QVMvUWxkdjFtYjVUbmZVYjlnQUQ0ZXJFaHIzb3NPeW9KaWNRaWNYK1RxaWFZ?=
 =?utf-8?B?OHNlU1lHcFVEbU1PLzdyZkZEalpyMytBZEphYXNRazZsYWNac2tVL04yMTBO?=
 =?utf-8?B?SDdBb1FXUUlFMUFpNk5UZlZTVHlOTXVKSmJUaktqdXcvMkd6aW04dWxnSDB5?=
 =?utf-8?B?ZFJSZjBJeVRHbEtwRUJvbThKTlFFMmZNRUc1MSsycWdEOW5iZjFnV3RxTkNn?=
 =?utf-8?B?elZZdzdjMmg1T05obWxlT2ljSEFxbWh2cVVHOFdTMmNCd0hCVkJCZGE0WkI2?=
 =?utf-8?B?OGlXSXBCZHNhQytYbElFb2N3bldRVm1YdEhNZ3pQb3d3ZWNhbE9hZWY0N2Rt?=
 =?utf-8?B?VkxMOS9QWjF2b0h5b2g4OEs4b2dtUUVYM0hsQ1FBTStaZEp1RU8zK0FWa3JR?=
 =?utf-8?B?djBrUWtWQXR1TDhERjRYT3YvV2x5aU9XYXRhcGYwbG03ODZYSzlxWDRYVEtO?=
 =?utf-8?B?UmZiNk12anc5MCtpdFltNkVEZ3NXbElmYmo0NmtIRkNwYVcreWJ4OTNReHht?=
 =?utf-8?B?cXB3NWZqa1AyMWdiRWVhRjlWcmpEVUtQdjVhd3pwYzR6OXVPUEZVOEQyMUZu?=
 =?utf-8?B?NU1vVUtHYmtaTUhqTHhMYkliOWo2YWVRM2V2a2NNOXpieTZyRENscXovRGNs?=
 =?utf-8?B?T0RObWlOMVcvemxITlVmWXFzakRLbEM2bThSTVpXd00zUmtNdDY1MkxicnBr?=
 =?utf-8?B?UDhmVTd2azFmZVJQUDIyRURENEFHbGFyUUVrWERPZnQzNERva1RCZ0JPb3dw?=
 =?utf-8?B?U2IwOVR0cU1RbTdwY2k2SXBaUkJOVlZGREprenoza25CdmhqWWFWamIwNkpF?=
 =?utf-8?B?Qmc4eVFhQU5uZllEdEtoaGlYOGFTWDlNc0MyREhzNHVNWnpPc0sxOTl5VDBU?=
 =?utf-8?B?VjNVUko5ZVN2Wnh2VEovcmZsZE1yaW14Y2c4ZVc1UnB5Rk9Ycy85RTZCMlZ5?=
 =?utf-8?B?ZE5vSjZKSlVUR3dRckh4NGJxSE1rRUdRd0dJOGhhbC9vN3ZXRHlhTnpYVVo4?=
 =?utf-8?B?SS9rbjlYeFZZUEJRTnJSWGl6SnNoQ2hxMXV4VnU2Yk1DWU95NmtHckdxWnZ1?=
 =?utf-8?B?a0dEUzBVNEtyUjVWbWVsYVU4Nlg0cUEvSjl1TTRLU2NXVzVhOFhXblNVKy9O?=
 =?utf-8?B?WXMvSmd5c29qdjVxbCtGZHNrWWZEbHZsYXdvTWNVN2RxQS9abGttVEc0VmNt?=
 =?utf-8?B?UkZXQWc5cHZRRnRtL0xoRjJERVc3Y0hyWU1jaG5FbzU3VmQ3Z2hjSHRwY3dY?=
 =?utf-8?Q?nfhxePjHo14=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:08.8315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a18570-9580-4ff1-8603-08dcfd819c01
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C716.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR07MB6586

From: Ilpo Järvinen <ij@kernel.org>

With AccECN, there's one additional TCP flag to be used (AE)
and ACE field that overloads the definition of AE, CWR, and
ECE flags. As tcp_flags was previously only 1 byte, the
byte-order stuff needs to be added to it's handling.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h             | 11 +++++++++--
 include/uapi/linux/tcp.h      |  9 ++++++---
 net/ipv4/tcp_ipv4.c           |  2 +-
 net/ipv4/tcp_output.c         |  8 ++++----
 net/ipv6/tcp_ipv6.c           |  2 +-
 net/netfilter/nf_log_syslog.c |  8 +++++---
 6 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index cccc6b739532..a9948fe3537a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -920,7 +920,14 @@ static inline u32 tcp_rsk_tsval(const struct tcp_request_sock *treq)
 #define TCPHDR_URG	BIT(5)
 #define TCPHDR_ECE	BIT(6)
 #define TCPHDR_CWR	BIT(7)
-
+#define TCPHDR_AE	BIT(8)
+#define TCPHDR_FLAGS_MASK (TCPHDR_FIN | TCPHDR_SYN | TCPHDR_RST | \
+			   TCPHDR_PSH | TCPHDR_ACK | TCPHDR_URG | \
+			   TCPHDR_ECE | TCPHDR_CWR | TCPHDR_AE)
+#define tcp_flags_ntohs(th) (ntohs(*(__be16 *)&tcp_flag_word(th)) & \
+			    TCPHDR_FLAGS_MASK)
+
+#define TCPHDR_ACE (TCPHDR_ECE | TCPHDR_CWR | TCPHDR_AE)
 #define TCPHDR_SYN_ECN	(TCPHDR_SYN | TCPHDR_ECE | TCPHDR_CWR)
 
 /* State flags for sacked in struct tcp_skb_cb */
@@ -955,7 +962,7 @@ struct tcp_skb_cb {
 			u16	tcp_gso_size;
 		};
 	};
-	__u8		tcp_flags;	/* TCP header flags. (tcp[13])	*/
+	__u16		tcp_flags;	/* TCP header flags (tcp[12-13])*/
 
 	__u8		sacked;		/* State flags for SACK.	*/
 	__u8		ip_dsfield;	/* IPv4 tos or IPv6 dsfield	*/
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index dbf896f3146c..3fe08d7dddaf 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -28,7 +28,8 @@ struct tcphdr {
 	__be32	seq;
 	__be32	ack_seq;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u16	res1:4,
+	__u16	ae:1,
+		res1:3,
 		doff:4,
 		fin:1,
 		syn:1,
@@ -40,7 +41,8 @@ struct tcphdr {
 		cwr:1;
 #elif defined(__BIG_ENDIAN_BITFIELD)
 	__u16	doff:4,
-		res1:4,
+		res1:3,
+		ae:1,
 		cwr:1,
 		ece:1,
 		urg:1,
@@ -70,6 +72,7 @@ union tcp_word_hdr {
 #define tcp_flag_word(tp) (((union tcp_word_hdr *)(tp))->words[3])
 
 enum {
+	TCP_FLAG_AE  = __constant_cpu_to_be32(0x01000000),
 	TCP_FLAG_CWR = __constant_cpu_to_be32(0x00800000),
 	TCP_FLAG_ECE = __constant_cpu_to_be32(0x00400000),
 	TCP_FLAG_URG = __constant_cpu_to_be32(0x00200000),
@@ -78,7 +81,7 @@ enum {
 	TCP_FLAG_RST = __constant_cpu_to_be32(0x00040000),
 	TCP_FLAG_SYN = __constant_cpu_to_be32(0x00020000),
 	TCP_FLAG_FIN = __constant_cpu_to_be32(0x00010000),
-	TCP_RESERVED_BITS = __constant_cpu_to_be32(0x0F000000),
+	TCP_RESERVED_BITS = __constant_cpu_to_be32(0x0E000000),
 	TCP_DATA_OFFSET = __constant_cpu_to_be32(0xF0000000)
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a38c8b1f44db..536767723584 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2163,7 +2163,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
 				    skb->len - th->doff * 4);
 	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
-	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
+	TCP_SKB_CB(skb)->tcp_flags = tcp_flags_ntohs(th);
 	TCP_SKB_CB(skb)->ip_dsfield = ipv4_get_dsfield(iph);
 	TCP_SKB_CB(skb)->sacked	 = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5485a70b5fe5..1b2f4a2e7332 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -400,7 +400,7 @@ static void tcp_ecn_send(struct sock *sk, struct sk_buff *skb,
 /* Constructs common control bits of non-data skb. If SYN/FIN is present,
  * auto increment end seqno.
  */
-static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u8 flags)
+static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u16 flags)
 {
 	skb->ip_summed = CHECKSUM_PARTIAL;
 
@@ -1382,7 +1382,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	th->seq			= htonl(tcb->seq);
 	th->ack_seq		= htonl(rcv_nxt);
 	*(((__be16 *)th) + 6)	= htons(((tcp_header_size >> 2) << 12) |
-					tcb->tcp_flags);
+					(tcb->tcp_flags & TCPHDR_FLAGS_MASK));
 
 	th->check		= 0;
 	th->urg_ptr		= 0;
@@ -1603,8 +1603,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	struct sk_buff *buff;
 	int old_factor;
 	long limit;
+	u16 flags;
 	int nlen;
-	u8 flags;
 
 	if (WARN_ON(len > skb->len))
 		return -EINVAL;
@@ -2159,7 +2159,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 {
 	int nlen = skb->len - len;
 	struct sk_buff *buff;
-	u8 flags;
+	u16 flags;
 
 	/* All of a TSO frame must be composed of paged data.  */
 	DEBUG_NET_WARN_ON_ONCE(skb->len != skb->data_len);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c748eeae1453..fec9acffb167 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1737,7 +1737,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
 				    skb->len - th->doff*4);
 	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
-	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
+	TCP_SKB_CB(skb)->tcp_flags = tcp_flags_ntohs(th);
 	TCP_SKB_CB(skb)->ip_dsfield = ipv6_get_dsfield(hdr);
 	TCP_SKB_CB(skb)->sacked = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 58402226045e..86d5fc5d28e3 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -216,7 +216,9 @@ nf_log_dump_tcp_header(struct nf_log_buf *m,
 	/* Max length: 9 "RES=0x3C " */
 	nf_log_buf_add(m, "RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) &
 					    TCP_RESERVED_BITS) >> 22));
-	/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
+	/* Max length: 35 "AE CWR ECE URG ACK PSH RST SYN FIN " */
+	if (th->ae)
+		nf_log_buf_add(m, "AE ");
 	if (th->cwr)
 		nf_log_buf_add(m, "CWR ");
 	if (th->ece)
@@ -516,7 +518,7 @@ dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 
 	/* Proto    Max log string length */
 	/* IP:	    40+46+6+11+127 = 230 */
-	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
+	/* TCP:     10+max(25,20+30+13+9+35+11+127) = 255 */
 	/* UDP:     10+max(25,20) = 35 */
 	/* UDPLITE: 14+max(25,20) = 39 */
 	/* ICMP:    11+max(25, 18+25+max(19,14,24+3+n+10,3+n+10)) = 91+n */
@@ -526,7 +528,7 @@ dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 
 	/* (ICMP allows recursion one level deep) */
 	/* maxlen =  IP + ICMP +  IP + max(TCP,UDP,ICMP,unknown) */
-	/* maxlen = 230+   91  + 230 + 252 = 803 */
+	/* maxlen = 230+   91  + 230 + 255 = 806 */
 }
 
 static noinline_for_stack void
-- 
2.34.1

