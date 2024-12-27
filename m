Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E831F8AE0;
	Fri, 27 Dec 2024 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326774; cv=fail; b=WVTKfzz78gTQBtJRPhVMtFmKkUQzxXqWX0v+qyJ5wLiugB7aH6dVL1/fBTqjtorK3MBo+9kSuZ/2Zkw71rUQfa59ieYNOsYtWAY2y7fniw6HEKP6DQphWFWPxmrlg4AzvJFY0xm5XorU8eDQrFT7CBW2h5Zr0T7Lo28zVlovVLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326774; c=relaxed/simple;
	bh=tJmiv5zcexXprjb0rePvbqOHx8USh4ij7lk+RuZ/giY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xw4P8DDvIYe4lG8QeBfPZZng5ZfshMXoDeOpT7ic4HYR6+G2zdz11UaUjS4Keb2M/m7uDs0+eCQj9sulpP4DwTzfbdACVT12qUFuvbifROrWyHYmhykoRWLaf2zy/4Adf2ok6NSGexfv/QX+gTlSMh1umhogYO/guo0uw5Fdl3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=qOx3DKs4; arc=fail smtp.client-ip=40.107.22.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="qOx3DKs4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nf9iq8VKw7hSvXcpc4zgoKWb/QDZF3HCiEM03GekyKh1+bK/1yB7J5j0LCCewou2aG4bbc2fxGg1/n9tH9/nvHG+oB6gDey98lB6qurBqn9NELzJRIHxJxPxMTPRmNs8Vx8LHirYJ4SqVCCFy26wgUvvWhWq6Yr+Qre0UZwrgcHZPn4fKyjreigHyhlW9IfM1vh543m1FOfqTj5nZxY9F06j7mzFMm5hfa28v8gqdGoLQ6rhb/pQugPXMh6octqmwnret9S6tkXgTSuSA6oEZ5B86TGBRbjwW05HiD/IOjhhjr8cg3as9rdv/zC/Bf/HMenANoAhCBhu39aC54AYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vvcT2AP4UOe+vI+7Cd7/BC5PwEvYpzbuAeuZWi7zrU=;
 b=G3VKM9iTpBoeD8dxQ8J9vh1ycf/wwFPxIm2LcmLjKm7xP4MWE/fF54UDItqQv1Mj2I6o+YJ1nC3JbZUSNQXcF3TaUyuuFRxwLsvi49c+UOVVJqRfz6003wIZdDfUsDptOMzrSu60EFMGvNyouZul8HixZpSLdjkUfnz65Izyc2W5kUfVOAMNECyY6UyjY9eUK28KFrYeBIOop7vfP7FDk3WWoAh2lMmWjiQ4AX0uTk3rt7DTOFlc75L5p/bvPa/trC2n1BFU+LDFzu+M1NoCnRUsmkq48X8R+5eYkZjIi0qmTBR6sr+at9YJHp0ZUoI4QG20HXYft37YIRjBUDfOFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=temperror action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vvcT2AP4UOe+vI+7Cd7/BC5PwEvYpzbuAeuZWi7zrU=;
 b=qOx3DKs4K8ASLXonHC21DLx0SWyXWqyGyXgDW6bJ8/K8fPgoZP8cMWkO7NvvhTrrktPb7seh/qDYRxgorg/1rDj3lEBt6h+RhVfGjzDuD82YGLNOq/TAJMIRrUX3JEuV4dPXV2h31ihzV7WbZLOX8gRJLN6Df7MQCD0hz7kRnbZpkEJyhCUaJgqDRRBM4NM33N8liZkGbwdrxfwlWCUjTAoTli28kv4NX9X2XpP6A3ljirgrAQn49CozPZZunxreHtrMTaTG9CD/jzB6UIXEG9GSI6M1kfx9AJMelwTRqkzEYb3L6CLOK5awvuEa/s1gux0WOPBeUvKPSJMLNqRoCw==
Received: from DUZPR01CA0138.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::14) by AS4PR07MB8875.eurprd07.prod.outlook.com
 (2603:10a6:20b:4f6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 19:12:43 +0000
Received: from DU2PEPF00028D00.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::6a) by DUZPR01CA0138.outlook.office365.com
 (2603:10a6:10:4bc::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:43 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 131.228.6.100) smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not
 signed) header.d=none;dmarc=temperror action=none
 header.from=nokia-bell-labs.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nokia-bell-labs.com: DNS Timeout)
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DU2PEPF00028D00.mail.protection.outlook.com (10.167.242.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:42 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2U011940;
	Fri, 27 Dec 2024 19:12:42 GMT
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
Subject: [PATCH v6 net-next 04/14] tcp: extend TCP flags to allow AE bit/ACE field
Date: Fri, 27 Dec 2024 20:12:01 +0100
Message-Id: <20241227191211.12485-5-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D00:EE_|AS4PR07MB8875:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e4a6b2e-336b-46eb-1f7c-08dd26aa7035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHhrVFBaTmxRUSt6dTFRNENMeHJDbVhOc1ZFYjArZlRsbHAvSkRranY4T24z?=
 =?utf-8?B?Y0ZCeEdBNjUzd3JLb3d3V0M2cGZFdGxGNUx1d0tSRmRHaVFYcDd0aDN0L3Jx?=
 =?utf-8?B?ejBhUWtQZTNBcFBleWdXUDI5NDA2ekIxckIzM2VsZXlGSGFyWC9EUGxORkVn?=
 =?utf-8?B?UTNvQTZwQktsOUJVRUE3cFE3OEc0WlJIcmlXSnM1WmpiVS85M2xnNFgzZ0h5?=
 =?utf-8?B?b2NpR2srREd1WEowT0QwaksyT2cwS1dDK3hvMzlQdktkZVNtdVZJSURqNlBo?=
 =?utf-8?B?MGlJVU5jTGg3Wlc1OUc5cVF4MlFFbjVFZFZPRXJYUVZYWTJhd1NCRVBSTmY5?=
 =?utf-8?B?QjhTV1V5REpUQTI1ek1LZEN1K0FYN09OLzk0WnhQWktqQjRaaTB4ZU4vYkNF?=
 =?utf-8?B?UmhSbHFqNThyYmUraFpQQys1TUtXaE9FMFM0Y285S1JydTc5Q044am1sNDEr?=
 =?utf-8?B?Mk9mOVFYcXhpb0RLaXUxSXhoRkpUd2RUdVY2blRYWkZPQ2ViZSt3aG9QU1lX?=
 =?utf-8?B?WVBMVU1NSXZXOVhJdThXcnJYdjBuRE9wMmx2djdjRFUwS09kUlRVaGpELzZr?=
 =?utf-8?B?dk9HRit1NWVqWnk1czRZdUVwSnlFS1JYQ0MxRTQ5WGdxWThXWm9FZ1NzYVNT?=
 =?utf-8?B?Mk43RDhudE5wcW13YllJWFZnRk1NMVZ5MmwzK2s1RGUwOFhwS2xzVzRUNkhp?=
 =?utf-8?B?YVoyYzNacFZCdXQwaW5lMDhjbXVXUTZUSXh2eDdBZzE2bTFMYXBYTVRhWFhZ?=
 =?utf-8?B?RkN3SlhKK0p2WVZldkZacE0rUjRWQjY3cTRoeS9vTXQzYzY4aFh5QlZCQWd0?=
 =?utf-8?B?ZjFRY0p0ajc1b29UT3dUdGNpa2hPUHV4b3ZZYWZYd3VuMUZncVQrR0YyL1pH?=
 =?utf-8?B?bGtMNjdBRkViQ0ZXZzFzWUtnYWx1clJVdmlhOXZRMEZsdUhHSDYrMzFHZjJU?=
 =?utf-8?B?NStrODk2dU9OeWgzcGFjRkUzZ1ExV1ZKLzVOaTFNQ0M0elV6VHNEakVLaDRP?=
 =?utf-8?B?N3lWMlRRd3pBaDQzNHBMODVzbHlhekpQd0M0QVZ3Q1RZWXpHdnJUM1B0SGZa?=
 =?utf-8?B?T3dSdjdLeFRpVDFhZG5EQmpRY3p4RUQ1VFUva2FCL0tKajcwWEMzV20ySGMr?=
 =?utf-8?B?MW1VNXVxSDE3SFVlaUtZb0VMOEIzMjdPdlZHb0RoeFJURmFlN0dsdEpBUXN5?=
 =?utf-8?B?b1p3YkJTa0NvVlZFY3VvUVFpZnY2QVQyN3UzRXdSc1hlSTUyeFByOG9NOEZJ?=
 =?utf-8?B?V2RUWG41VFFCT29OOXRsVGI1VGd0RVYvaHBUc3UyUnpoRkJNYnpPWEMvVHdV?=
 =?utf-8?B?c0dFUzE2a1o4VXBYa1RPUEJDT25tM2N5ZHhZelpEc1FHZnZVUkhhKysveTF1?=
 =?utf-8?B?cEpyNnFyeWtkb0kraXZ2OXlYZVluWDJML1pMc0ZxSWlaVlpEZ1E1YXFhdkxM?=
 =?utf-8?B?MUxWYkZuMnZ1K1lZWVRndTlBbTRSK1h3NmV6QXZ4RFJQVXBKUjdLaXI4SVFZ?=
 =?utf-8?B?cVlDeEx2WFlINXRaTENoUW0ydE1FTk5vOC9qeEdidzlOTHduNUZPbkR5aG1v?=
 =?utf-8?B?ZTM2T2lWTUZQOXVzVU1PQ0RKT1BLekdkRy9yeUc1MG5YRk1Ra3Rnc0xQV0lk?=
 =?utf-8?B?VmZzSnROY2lUcjFPc3RyWXlFKzQ0VHNwMzU5WnVuRU9QYlhVbXBNRlIxbDJ2?=
 =?utf-8?B?N29kdXZ5b2ViZXkrck9PcG9qNGlWS1BHdnNkZGFjUkt0aHlyV0VsbW90TTdr?=
 =?utf-8?B?bXVscHduSVJjS0hkc3dKRzgwaHRhb29GV2x5YXd1UzBYOUVxRUxaQ3NkNnF4?=
 =?utf-8?B?UDdidXoyK0dYZWQrR3hmbHdiWHFlcU5GR0FWaGRPTGdEOE50T0hZcWFKQXE4?=
 =?utf-8?B?dWxtQktrWHY4dlZ2RVVKZ1cvT3BlSTAra05aTXRzN1lRRXJLcjk3RnZ3L2ZW?=
 =?utf-8?B?Nm5vUzUxd1c5ODFJUzhZcTNQam0zZ2JHMDdabzdIWnBTeFV3ZVpNYkNMWDdV?=
 =?utf-8?B?SFpzSU1EemRMUEt3aTJDaldqcmM3UWRDNDBiLzd6OUx0WUhkYW1tZHAwOERT?=
 =?utf-8?Q?X1hyLU?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:42.4053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4a6b2e-336b-46eb-1f7c-08dd26aa7035
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR07MB8875

From: Ilpo Järvinen <ij@kernel.org>

With AccECN, there's one additional TCP flag to be used (AE)
and ACE field that overloads the definition of AE, CWR, and
ECE flags. As tcp_flags was previously only 1 byte, the
byte-order stuff needs to be added to it's handling.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h             | 11 +++++++++--
 include/uapi/linux/tcp.h      |  9 ++++++---
 net/ipv4/tcp_ipv4.c           |  2 +-
 net/ipv4/tcp_output.c         |  8 ++++----
 net/ipv6/tcp_ipv6.c           |  2 +-
 net/netfilter/nf_log_syslog.c |  8 +++++---
 6 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 99dcbb47eac0..c9bab41685cf 100644
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
index e45222d5fc2e..b0b8bbfa9386 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2165,7 +2165,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
 				    skb->len - th->doff * 4);
 	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
-	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
+	TCP_SKB_CB(skb)->tcp_flags = tcp_flags_ntohs(th);
 	TCP_SKB_CB(skb)->ip_dsfield = ipv4_get_dsfield(iph);
 	TCP_SKB_CB(skb)->sacked	 = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0e5b9a654254..33e73cefcdbc 100644
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
 
@@ -1384,7 +1384,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	th->seq			= htonl(tcb->seq);
 	th->ack_seq		= htonl(rcv_nxt);
 	*(((__be16 *)th) + 6)	= htons(((tcp_header_size >> 2) << 12) |
-					tcb->tcp_flags);
+					(tcb->tcp_flags & TCPHDR_FLAGS_MASK));
 
 	th->check		= 0;
 	th->urg_ptr		= 0;
@@ -1605,8 +1605,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	struct sk_buff *buff;
 	int old_factor;
 	long limit;
+	u16 flags;
 	int nlen;
-	u8 flags;
 
 	if (WARN_ON(len > skb->len))
 		return -EINVAL;
@@ -2161,7 +2161,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 {
 	int nlen = skb->len - len;
 	struct sk_buff *buff;
-	u8 flags;
+	u16 flags;
 
 	/* All of a TSO frame must be composed of paged data.  */
 	DEBUG_NET_WARN_ON_ONCE(skb->len != skb->data_len);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2debdf085a3b..e373ca997ee0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1735,7 +1735,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
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

