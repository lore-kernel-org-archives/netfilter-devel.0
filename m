Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2047.outbound.protection.outlook.com [40.107.249.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188FC1D364C;
	Tue,  5 Nov 2024 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801245; cv=fail; b=c2HzUD0Imi0PkAOBrWl9NtJnmgNN3D5o1kXkmMXwlY6Y9h2iDJQwngl/XtCkiT1YmnVDs/zpMubdgXwdchAV1Y4hP8bsOvt//MJBkkVe7DOOCn8cyZW+4kEfUnKu2BAU5cefSfOTmvjExX8ExuJ/tSDs9qWQ/13uT+qJRzUK7AI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801245; c=relaxed/simple;
	bh=A0alP3i7BChIrDcYCJQzCBSK6YQw6QqGYkRVrg1e4vU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bW0vmV5lFixlOwS/VcD/+DUJD94I4Y3QRji34NUd1QM8UOBf9zBANlI5crcv0LwdiYnM8N5nL/R5DqVbvJFR04tPcKCbPZVx5h+oLwEoW7znbRsvTc/0I30pWeZsKCN7znlMljr3kqIM19IT/9tT4b/amD1H6seKe1kza+F6Ebg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=Hd1Ue/0f; arc=fail smtp.client-ip=40.107.249.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="Hd1Ue/0f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pk0NPsf+7FcUFOoHOoFtv/0nB+JeDD0m7ZnLuvSoAT259GWWbR77Uq1TNyrn6tgL49J7oV201gxCHn9BitUr4xJBw9KM+yygUaY6RAWPdeHC2vy8gxNMvRLKhvOdwRhQ26VCzvYJxA7WZGGjqdU9EljLYMHYwHM5XZ4HaP0wrF+/YbGcC8/LAQ9sBX3CILP96ZEBW4/gOwe+1yirsErJRiH6DHfMC+AReipzL+iIfXV39BsIAIYXkw5fot7aEolMGk/z96g2PeElQ5xMpcmpdTLxucRXTm+bjuFeGbl5E1ZuV3wriLu+youNinLjdrl9CW1haUZflmGPOEtlIqLwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNStub9z4iTqc3XDC4qBDpx4QNkLlRs6W6piM1aLW4w=;
 b=xAbw0EeTDh8tjXVwn1ObNqmLvtHR4zpTlVfIvlZUgrqsxQAJvaQVjqdwFBPeq59rttTsIlCqzGEXLViHBzfykaOZy+zRYGxl1haE+KhIihj6Em0ODjXvmkYs2rlkATQNiEBFtIOD0zwjsOCmEit9k3tAFaRlfh59Wb5no53plb44Sgqv2l6HiqZSU++Lu4HlUEJIL8Sxg12c3oM0VdNPxM2ZpfI3LP1YxH9g/GJcd4uWSmILCpf2+5q6f92AdqNV5GveMogClZV/j4NhEl6uPKiJ3aF/3auYbnEGz2zZ123lQUawz/Sm1a1nce091pfnWIAFsE+fXyDm1LzwtHn7ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNStub9z4iTqc3XDC4qBDpx4QNkLlRs6W6piM1aLW4w=;
 b=Hd1Ue/0fFR6qSPM7JjnlYWsId6mKzLEgC44UdCYh/Bi6VJjvofmbQS/KF1+z22tQkoOXfao6l05CaoQKXrM2Wr8MoIjKyoPddt0c+v4DVrQtBlYjwJz/8LhMyaxXDCY49O5Ef1cxCFDo0Ksej/D5T089ueDddLNVOJ47NUDeWJBa7AquQ8LkOzUabRAN4Z77kBia6V6luheTAvwTp825wI9P/W8FWXFfGH8Qwj/Abyiaatn/ybSVdaFoMCxSmK1X/ss6GJUZqwIvCT5VJpK+fCAXkvavM+4gazdQ1T7ruSXgUegSfegE5hwE1XDS37es/3ZRuR7hx2h5ZLOq0VeoYw==
Received: from DU7P250CA0023.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::11)
 by AS2PR07MB9169.eurprd07.prod.outlook.com (2603:10a6:20b:559::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 10:07:17 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::32) by DU7P250CA0023.outlook.office365.com
 (2603:10a6:10:54f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:17 +0000
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
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:17 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2l024723;
	Tue, 5 Nov 2024 10:07:15 GMT
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
Subject: [PATCH v5 net-next 11/13] tcp: allow ECN bits in TOS/traffic class
Date: Tue,  5 Nov 2024 11:06:45 +0100
Message-Id: <20241105100647.117346-12-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D02:EE_|AS2PR07MB9169:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f4f258-120e-4b67-f133-08dcfd81a122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1Z5RVNlMkVRSG5uTWNmdEtaYzJ4T0VJTVQ4Uk9velFYRTlqbm0zMjB6T0JV?=
 =?utf-8?B?L3lnL1NDV2pqcDU2VGxHY0dPeDFmSE10czVsVzMzUzN0bTNyMzdtSUV3ZjIy?=
 =?utf-8?B?OG56UU1NSFlFemE1Qks5VDkyVWw3UHR6aGkyVGFwamVuSHJ0TFZ0emV0bXdJ?=
 =?utf-8?B?cGhUdnlQbFh2bkpoalg2VnJhdFpFakhpWnowV2xuOEMvZHlpOThaaVMyMVNt?=
 =?utf-8?B?T0RCdEZKRUVSMklOb2hRYk5zZ3Zoc3dBSldZbmdNNEJFdEt4R2o1SzlCdDRp?=
 =?utf-8?B?ZUxiVUtXZExPanlGaDNEUEJwUXBoK05FRHg3NUVrRkZZVjlhc1JFYy9nb3ZO?=
 =?utf-8?B?U0dRY2w5RmVJbXBRNFRETGRFaDBUWVU1QlBNK1pQL3RtdkpEa2htVThxdldL?=
 =?utf-8?B?UjMraWZGK1NXb0krUWR3dG8ybWJsQnBJZ0x5QWdqWVlsWDNQWXIraGNkcEZn?=
 =?utf-8?B?am50YjY2M1lYTVdLZGp5RHZOMVVuNUNrSktaVnpNYnRkNEN1ZTJIRjl2VGpQ?=
 =?utf-8?B?bWVMWGVTand3ZmVkVjR1U25aaXR1dG9jM2UxVXNyUzdGR051RmpyTitGSEJT?=
 =?utf-8?B?d0I1THZlUVFsajlkRG13WVNTaUlsZWNUdlZnYUhLaTJkWHdVeHpLQWVBRG9x?=
 =?utf-8?B?RmtqcVU5dlRGby9xaTNDM29WcjZ5K0VQdWlROTJYQnFZWEJuMURBNlZ0Ukpm?=
 =?utf-8?B?czNPUTA2dWIweDk4RUZVWVVjblVHK04rYWN6Qko1Z0U4YnJDcmlBNk5MMC9B?=
 =?utf-8?B?WHpyK3BLclJvU3lOd2VkcFZDaFZNdUp2QlV3Um10NHYvQlJlVUM1Mkt3L2p5?=
 =?utf-8?B?N0xWVDd2Y2FaaWNRNUU2eVRUdzlCVTdrNTYyREs5QXBhVFdpUm1pTjJnbTBw?=
 =?utf-8?B?RHBrRWdkWllWb2lmaVd0OHZOQWxWOS82eWhSMENuZWZmOGNXaDhqSjkwNmk0?=
 =?utf-8?B?c2ZPdlE4bi9FZWpweWtyZjQ0RFcxK2s0S1JoV0x0OHJiQ1VnZVl6VHo3ZW1r?=
 =?utf-8?B?ZklFdGVSTE9DckJaNDgvTWlGK0k2VnNTTGhVZFh4ZkxEeTdtVHEyZE1QbEl2?=
 =?utf-8?B?d1VoMjR5dHcxSHR1MzVrMmNSWXB6Y2xQZDdNTllWZlZQdzNhTU0vK2d3bkh2?=
 =?utf-8?B?cEY4OGpycE9sOHh4dkhQNENobWcyT2FJNHFTMXNMZkUzbFA1TjBxZ1Ixd3Nl?=
 =?utf-8?B?ODROckVva0ZGQUJpMENhUm1Jd3hqR1p0NXVldklzRm02MjBSTVRWME9jQWhz?=
 =?utf-8?B?TktoL0JnVXBTenVVbm0zWDVLQWpBODZWa1RLeFFHdnNDWTlDL041YnRWOFZy?=
 =?utf-8?B?R2kyNjRmUWxUaUdlRlZpMTVjVkZ2TDE0bW92bE9oelN2cGY5eGdlRXFuV2hE?=
 =?utf-8?B?ZjN2NGVsWUQzRy85emprR1duUjdJYkNVVHNUb281ZTlRQ2dyZ0E4aHh6QzZI?=
 =?utf-8?B?NXI2WjJJT0pLczJFY0I0aUljTlh6NTlIZ1F3OGJXNGJMYWpTejU3d3pwU2NV?=
 =?utf-8?B?bGtGOGtlMlh0R25PSUV1UWVwTVJiL0RZaDRpSTJ2RlhTZjQ3Rjh4Z0FaZjRB?=
 =?utf-8?B?eWlmNFJLM1QxeU9YL2RoSjJxVE9WNUJ5cU84aW9WK0NsSHl2cVNyK1daUGFy?=
 =?utf-8?B?VlFoMmpJWGFNMnRobkppVmJrQ2x1U3czNlVlRkVyaGJxSUdYWjU3cTY3N1hn?=
 =?utf-8?B?UjZ5M1hOdll2N3Eyb1p6TzRGOUVSa01hYUx1NVF5WDAybEpmUmRiQWcvWXpy?=
 =?utf-8?B?WUwvUThRQi82TjNyT3lsdlBLNzBIN25BYnRpYTJZV3E5RGRxNm9PQ2V3Q3Z2?=
 =?utf-8?B?Zi9xRlk4TDYzWFVHTEdYZkRlTUVzZ2JBaDlHblFQZ3hESDRiUWVpZFpsVzB2?=
 =?utf-8?B?SGlObGRZK3VMSjY0eGd0OXozU1JQbnBnM2xERUE0WXI0WVFhaFpzQytaMTg2?=
 =?utf-8?Q?8dTTInZqAbs=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:17.4079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f4f258-120e-4b67-f133-08dcfd81a122
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR07MB9169

From: Ilpo Järvinen <ij@kernel.org>

AccECN connection's last ACK cannot retain ECT(1) as the bits
are always cleared causing the packet to switch into another
service queue.

This effectively adds a finer-grained filtering for ECN bits
so that acceptable TW ACKs can retain the bits.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h        |  3 ++-
 net/ipv4/ip_output.c     |  3 +--
 net/ipv4/tcp_ipv4.c      | 23 +++++++++++++++++------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv6/tcp_ipv6.c      | 24 +++++++++++++++++-------
 5 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 215b7ba105be..3a8782874333 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -417,7 +417,8 @@ enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
 	TCP_TW_RST = 1,
 	TCP_TW_ACK = 2,
-	TCP_TW_SYN = 3
+	TCP_TW_SYN = 3,
+	TCP_TW_ACK_OOW = 4
 };
 
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0065b1996c94..2fe7b1df3b90 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -75,7 +75,6 @@
 #include <net/checksum.h>
 #include <net/gso.h>
 #include <net/inetpeer.h>
-#include <net/inet_ecn.h>
 #include <net/lwtunnel.h>
 #include <net/inet_dscp.h>
 #include <linux/bpf-cgroup.h>
@@ -1643,7 +1642,7 @@ void ip_send_unicast_reply(struct sock *sk, const struct sock *orig_sk,
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
+	inet_sk(sk)->tos = arg->tos;
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a13d6745d92b..1950d4cd5da8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -66,6 +66,7 @@
 #include <net/transp_v6.h>
 #include <net/ipv6.h>
 #include <net/inet_common.h>
+#include <net/inet_ecn.h>
 #include <net/timewait_sock.h>
 #include <net/xfrm.h>
 #include <net/secure_seq.h>
@@ -887,7 +888,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 	BUILD_BUG_ON(offsetof(struct sock, sk_bound_dev_if) !=
 		     offsetof(struct inet_timewait_sock, tw_bound_dev_if));
 
-	arg.tos = ip_hdr(skb)->tos;
+	arg.tos = ip_hdr(skb)->tos & ~INET_ECN_MASK;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
 	local_lock_nested_bh(&ipv4_tcp_sk.bh_lock);
@@ -1033,11 +1034,17 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	local_bh_enable();
 }
 
-static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
+static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb,
+				enum tcp_tw_status tw_status)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
 	struct tcp_key key = {};
+	u8 tos = tw->tw_tos;
+
+	if (tw_status == TCP_TW_ACK_OOW)
+		tos &= ~INET_ECN_MASK;
+
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao_info;
 
@@ -1081,7 +1088,7 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			READ_ONCE(tcptw->tw_ts_recent),
 			tw->tw_bound_dev_if, &key,
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			tw->tw_tos,
+			tos,
 			tw->tw_txhash);
 
 	inet_twsk_put(tw);
@@ -1158,7 +1165,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			READ_ONCE(req->ts_recent),
 			0, &key,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			ip_hdr(skb)->tos,
+			ip_hdr(skb)->tos & ~INET_ECN_MASK,
 			READ_ONCE(tcp_rsk(req)->txhash));
 	if (tcp_key_is_ao(&key))
 		kfree(key.traffic_key);
@@ -2179,6 +2186,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	enum skb_drop_reason drop_reason;
+	enum tcp_tw_status tw_status;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
 	const struct iphdr *iph;
@@ -2405,7 +2413,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		inet_twsk_put(inet_twsk(sk));
 		goto csum_error;
 	}
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn)) {
+
+	tw_status = tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn);
+	switch (tw_status) {
 	case TCP_TW_SYN: {
 		struct sock *sk2 = inet_lookup_listener(net,
 							net->ipv4.tcp_death_row.hashinfo,
@@ -2426,7 +2436,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
-		tcp_v4_timewait_ack(sk, skb);
+	case TCP_TW_ACK_OOW:
+		tcp_v4_timewait_ack(sk, skb, tw_status);
 		break;
 	case TCP_TW_RST:
 		tcp_v4_send_reset(sk, skb, SK_RST_REASON_TCP_TIMEWAIT_SOCKET);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index bd6515ab660f..8fb9f550fdeb 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -44,7 +44,7 @@ tcp_timewait_check_oow_rate_limit(struct inet_timewait_sock *tw,
 		/* Send ACK. Note, we do not put the bucket,
 		 * it will be released by caller.
 		 */
-		return TCP_TW_ACK;
+		return TCP_TW_ACK_OOW;
 	}
 
 	/* We are rate-limiting, so just release the tw sock and drop skb. */
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index fec9acffb167..ea85c117bf96 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -997,7 +997,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
-			 tclass & ~INET_ECN_MASK, priority);
+			 tclass, priority);
 		TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 		if (rst)
 			TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
@@ -1133,7 +1133,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 	trace_tcp_send_reset(sk, skb, reason);
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority, txhash,
+			     ipv6_get_dsfield(ipv6h) & ~INET_ECN_MASK,
+			     label, priority, txhash,
 			     &key);
 
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
@@ -1153,11 +1154,16 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			     tclass, label, priority, txhash, key);
 }
 
-static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
+static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb,
+				enum tcp_tw_status tw_status)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
+	u8 tclass = tw->tw_tclass;
 	struct tcp_key key = {};
+
+	if (tw_status == TCP_TW_ACK_OOW)
+		tclass &= ~INET_ECN_MASK;
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao_info;
 
@@ -1201,7 +1207,7 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_tw_tsval(tcptw),
 			READ_ONCE(tcptw->tw_ts_recent), tw->tw_bound_dev_if,
-			&key, tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel),
+			&key, tclass, cpu_to_be32(tw->tw_flowlabel),
 			tw->tw_priority, tw->tw_txhash);
 
 #ifdef CONFIG_TCP_AO
@@ -1278,7 +1284,8 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			tcp_synack_window(req) >> inet_rsk(req)->rcv_wscale,
 			tcp_rsk_tsval(tcp_rsk(req)),
 			READ_ONCE(req->ts_recent), sk->sk_bound_dev_if,
-			&key, ipv6_get_dsfield(ipv6_hdr(skb)), 0,
+			&key, ipv6_get_dsfield(ipv6_hdr(skb)) & ~INET_ECN_MASK,
+			0,
 			READ_ONCE(sk->sk_priority),
 			READ_ONCE(tcp_rsk(req)->txhash));
 	if (tcp_key_is_ao(&key))
@@ -1747,6 +1754,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	enum skb_drop_reason drop_reason;
+	enum tcp_tw_status tw_status;
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
@@ -1967,7 +1975,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto csum_error;
 	}
 
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn)) {
+	tw_status = tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn);
+	switch (tw_status) {
 	case TCP_TW_SYN:
 	{
 		struct sock *sk2;
@@ -1992,7 +2001,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
-		tcp_v6_timewait_ack(sk, skb);
+	case TCP_TW_ACK_OOW:
+		tcp_v6_timewait_ack(sk, skb, tw_status);
 		break;
 	case TCP_TW_RST:
 		tcp_v6_send_reset(sk, skb, SK_RST_REASON_TCP_TIMEWAIT_SOCKET);
-- 
2.34.1

