Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2087.outbound.protection.outlook.com [40.107.249.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D69A1F9F59;
	Fri, 27 Dec 2024 19:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326788; cv=fail; b=h+a3iQXsiY93Krvapa6xUV7q86tt2AWIuZiXbk2Kc05TDPTkXSbQn+UZ2FQLxRDvlZ/6xQD4Qe50opEDnwm+jlfAWF2zltVKcFQ4bL6hTP0i3XV3P3kpFbtXIBe8h8YW0kd9ATJxFGqNktxrnGtH3KaPrvXiOjIxJVHBnlJVC4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326788; c=relaxed/simple;
	bh=U2TGYxnhFCwvfX8sqP0/i02ZCL0Wrh2uoB+wx2UgPqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDhnymxwGLPMx2UfvpMnbHKxbfxtuYJK2i7Cxk6yj08fUncmqGuMudrk+SX1QbGrqeRwp+tnzyxI3Vs5ri8AQIO3nmAy7FJt3hWS6FZ1WQhl2DoHgHJAs3uKl2iZOO3Lhk7sxExvsYPcd3vL/XZkoThsj5WgXts6sznjqej8hSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=dYZuJq1j; arc=fail smtp.client-ip=40.107.249.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="dYZuJq1j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gPPSjTlkD4k/3t5PoJM8KxV/qjmZisnd87NGMAHu2D9eCbD2+4RF5dLW1glzOquMUqnllUYsonIx87486q4rR8lG3NxC25ruTLsG+3VQcoCgPYNiRGBeNUfNcI2mOKZWwkPqFTsHPUqg8VZ6QiSv0RTz/XxLM3M5NtlzQTH8w3UcdN2mWC05l2Z2iz1XZBlMi2CUDrdqaW/bEBoBEmdYNIjn6YCyz19eiU3iW8PDd6DjroBymeaqOsdh8cyyNYxjkl6PI8l3oKHj74l4jTxCyV3qSYXViSDdv7ebSpOV9qJhiYwGgZ1VFFgEZ+YwkL7kYbZhR34rQuFh45CTNxyxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeCjce9jeD36fMnKu1YVL/NvCavnCJuGYN8QKTggfZI=;
 b=dYeeLkYaYRG89vg1d75ye5o5ZfVPwcZ3Dovrh91WNzCGdRVmMt0zqyL69pa/B+PYh4h/4eRKUPQx1iIY5np8XVnjPV/Ey0byqI0hztqCo9rv+UKPcgXjNBxL74oi8Yr3inBOLHDJeqN194G6Pe9p16Sk7loSHX/P1BwLwHkF/bu58Zt7FtRGtb4HUy0Tc6iXKjRNV1pRFCKECWjpflw7gUfhY07wUbNO8hLIWahZreXwjRbnQZaxkT7FGf8Gtx9s9lpjQgG6yZ/hA3ftw27gZubEEt/FG/q3j8/yljcJE+FPIPKh62FMc2BuCLEnm4UhuPAQf73GvysjFnBe+/p5cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeCjce9jeD36fMnKu1YVL/NvCavnCJuGYN8QKTggfZI=;
 b=dYZuJq1jFQy7s4FCX6VYt+SfmOHMZXUVG3gybY0vAjzbOriNn5mS5eAitKBzeu0h0Zlc8y32iXCz9q5IHddbBDZSYTndr0LR6jPXJ1sbHsJ+z6CrKBKVMNlw63gijk5U8YcjiggY9neW6MvoDkx0YmvX+gGXEu6W77h0rJTYMGvlRP4j/j/ObkwvuAg/lqxEHXByG3+UOotFcVIOXJHMHZVYO/D7g1obWfS8eyUPVZcJLeBuWGJBFbWq5KhwO+jHNtgIxnEQ0hto6uhtBEct4hqEXF57A7BPInJtvOavy+d24dYIETQ0REPcIEh93/0yXkZq+t7mbShEeYok7d7Z5Q==
Received: from DUZPR01CA0193.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::14) by VI1PR07MB6606.eurprd07.prod.outlook.com
 (2603:10a6:800:185::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 19:12:57 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::cc) by DUZPR01CA0193.outlook.office365.com
 (2603:10a6:10:4b6::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:57 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2d011940;
	Fri, 27 Dec 2024 19:12:57 GMT
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
Subject: [PATCH v6 net-next 13/14] tcp: add new TCP_TW_ACK_OOW state and allow ECN bits in TOS
Date: Fri, 27 Dec 2024 20:12:10 +0100
Message-Id: <20241227191211.12485-14-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DB1PEPF000509FD:EE_|VI1PR07MB6606:EE_
X-MS-Office365-Filtering-Correlation-Id: cab1a928-3e26-4550-11b9-08dd26aa7905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWlZcnczZ2puaWNBYzA3L2pMcVRsY2luTHZiU0xqWnFtbGVkc1Z0em81VkF2?=
 =?utf-8?B?VEdobXQ1U0R0SzAzUkZ5VlBITTd1SWRwclhOL240Z3lhNlF2OENUSlkvSURT?=
 =?utf-8?B?bTFCQlRWeG5CWkNaWDBPU3U4dll3V1VheEY0RG5pTXhRR0tlYklFckZyM29X?=
 =?utf-8?B?MlJTOURJak9RcUFtK1BGWnRKdW1sU0M2aVdSdmdzTlR0ZTlNbVp0aVpuLzNr?=
 =?utf-8?B?Wjg1ZGZ0NCs4c0xrZ1J5UVBXZ2RRTjluMDJlQVpEL21yWVhNRkswZm1tamFG?=
 =?utf-8?B?eXFETG4vblJxM0puL1dXc3VVZVJ2VHZZb1ZpR1lEaXBxZER6VnR3VmdjT280?=
 =?utf-8?B?TUIzWGpKaml2WWVPVlVJTnI1VmVUNmxmclhKWDlNTThuL1dTTXRmK3pvUzIw?=
 =?utf-8?B?bjhJZndENGRPL0Jxb1RpMkZVN2s1WTJNS094bmJwRXVrdU9CNk9uamtOYk80?=
 =?utf-8?B?TEVDVzJmd1NtSmozSm9tVkR3VXJ4NGhtVVJkNTJ0YnZ3MEQxVi9PQ2pCU25h?=
 =?utf-8?B?TDF4WE1wMGF0ZnZlWE9BVU4xZGFlNjg2UUU4d0ZweVA3a1p5L1A2dnRkR3Qz?=
 =?utf-8?B?QTYzcE9ubXBhRm9GNVUxRTM3ejlOMHZ2NmdkMzRITzhzbW8wZ3l6VTRGc1VH?=
 =?utf-8?B?R0tTTTdkMWJ2U0pDaXhERE1CRE5kRU8rTDAvRVAwNW02L0M3UmhnVGNXQjI3?=
 =?utf-8?B?U0xRT2NKYjFNL1BDM3NhVmszVCtROUhXcUJBaTlKN2xqd0t5VUFKelBONm4r?=
 =?utf-8?B?MncvRHE5YnVSeHM1RlVLQ2JTUldHNlRtMmVCN0N3b0JubzhFSzMydWtKYUdo?=
 =?utf-8?B?bTlFaGZ4ODIxdlBNR2N4MFhPWEpMc042SjJidll4c1FKdGJlMU55c205Tlpl?=
 =?utf-8?B?OTdsU0F2L2VYVzkwazBSWFhGWGFiQzVXeld2Ni9kTUJtZ3lmcExBZERHSWpl?=
 =?utf-8?B?MVJVV0RiQUlIdlNKZVJhdTZsV3NsSWRIOFhNWG1JNU9RakxWMVpUTk9DRU5R?=
 =?utf-8?B?OHJxMDFuUjBDSVhhRXpvb0RnYVY4YXdjazRlODZBWVNyTjh5UC94bWQxWElS?=
 =?utf-8?B?dEZYalpjekl3QTRFVExaMmZPZFljcUF2aXZHeWpoS3VPdXhEUzF6OVRoMGdm?=
 =?utf-8?B?a2RlSVFDRFd0VDR4M2NXWXZWakxEMjN2UFdrd3RhMVI1WkxDVG82Znp5N2FX?=
 =?utf-8?B?b2RmcVV1V0s4dXh1SURSSVhWVVBhMDEzWVVDQW1KaG4wRWVSS3NsSHdMQnJ2?=
 =?utf-8?B?RS9lUy9NV3ZGV3lUNHhJeUVGT25TZ1dnL0ZPajNObFFKazY5YXNkdjVUaXNl?=
 =?utf-8?B?T3lDblZzNHBlSG00eXFBdmhPTHhjOGNsWmMvenlXbmdnWGxTenY3VkJZeElq?=
 =?utf-8?B?ZE0ycWVLa0lyTmhYdFZoeWNoNXBkalhwakhPQ09pYVlUbkx5bDhvUTJoQmdS?=
 =?utf-8?B?NkV4MElzcGt6NGJ2SzRVbDE5NmtESkJ0N3QyaStoczNCTjlOQ0lMQ0ZWUzkv?=
 =?utf-8?B?aDRDYllRWmEybjRKaEdra1oxL2lmdG5Jc0J3T3pkVkoyUzY0SGs0ajJOL1Zh?=
 =?utf-8?B?cWgrL0FMSlViNm1BdWFhYWQwNkpuWEttY1RtcWgxUXFMVFVxQTMxQWZyemZm?=
 =?utf-8?B?MUdoWXJ0b0owNUV5TkJLREN6K1ZGak94UXdPMUFCUDhtU055djRVNUVoRXdK?=
 =?utf-8?B?NFlPVGR6TXJTY1gwRkhPVVk0WnlaWEJvY015c2RXZ2cvUlRpSytaU0laMkk5?=
 =?utf-8?B?eWhkSmpNZGwyaUxPNVhIVXFLNGVCcUJucnJkNk90OG51U3JMTm13QWdyQ0s4?=
 =?utf-8?B?V2FyaGZOWDJ0UmlXMk1oOHlGZStaR052Wld1TVdvYjFNZ3oxZEJmbC9VWmNT?=
 =?utf-8?B?Q282QU0rVmNXUldaeEY2S3JqNkJ2aVpRbm5zVDc5QitZVHNhOCtBbmNCZjR0?=
 =?utf-8?B?TzJseVJldzhBTkVKdjd4YVVEV3pEa2tmdFIwOGhISlhLb1VDWEE3YjhOUlNH?=
 =?utf-8?B?QTQxWmZOKzYwd1pNZHc0cEp6L2xSdXJvRkhodXpiQWduZUFnUUs4TVI3T3lL?=
 =?utf-8?Q?+GkGy5?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:57.1274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cab1a928-3e26-4550-11b9-08dd26aa7905
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6606

From: Ilpo Järvinen <ij@kernel.org>

ECN bits in TOS are always cleared when sending in ACKs in TW. Clearing
them is problematic for TCP flows that used Accurate ECN because ECN bits
decide which service queue the packet is placed into (L4S vs Classic).
Effectively, TW ACKs are always downgraded from L4S to Classic queue
which might impact, e.g., delay the ACK will experience on the path
compared with the other packets of the flow.

Change the TW ACK sending code to differentiate:
- In tcp_v4_send_reset(), commit ba9e04a7ddf4f ("ip: fix tos reflection
  in ack and reset packets") cleans ECN bits for TW reset and this is
  not affected.
- In tcp_v4_timewait_ack(), ECN bits for all TW ACKs are cleaned. But now
  only ECN bits of ACKs for oow data or paws_reject are cleaned, and ECN
  bits of other ACKs will not be cleaned.
- In tcp_v4_reqsk_send_ack(), commit 66b13d99d96a1 ("ipv4: tcp: fix TOS
  value in ACK messages sent from TIME_WAIT") did not clean ECN bits of
  ACKs for oow data or paws_reject. But now the ECN bits rae cleaned for
  these ACKs.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 include/net/tcp.h        |  3 ++-
 net/ipv4/ip_output.c     |  3 +--
 net/ipv4/tcp_ipv4.c      | 29 +++++++++++++++++++++++------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv6/tcp_ipv6.c      | 24 +++++++++++++++++-------
 5 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4987cb0c59c4..a68c414b9407 100644
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
index ea7a260bec8a..6e18d7ec5062 100644
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
@@ -1640,7 +1639,7 @@ void ip_send_unicast_reply(struct sock *sk, const struct sock *orig_sk,
 	if (IS_ERR(rt))
 		return;
 
-	inet_sk(sk)->tos = arg->tos & ~INET_ECN_MASK;
+	inet_sk(sk)->tos = arg->tos;
 
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 24ec0ade8ae9..f001f991a984 100644
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
@@ -889,7 +890,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 	BUILD_BUG_ON(offsetof(struct sock, sk_bound_dev_if) !=
 		     offsetof(struct inet_timewait_sock, tw_bound_dev_if));
 
-	arg.tos = ip_hdr(skb)->tos;
+	/* ECN bits of TW reset are cleared */
+	arg.tos = ip_hdr(skb)->tos & ~INET_ECN_MASK;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
 	local_lock_nested_bh(&ipv4_tcp_sk.bh_lock);
@@ -1035,11 +1037,21 @@ static void tcp_v4_send_ack(const struct sock *sk,
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
+	/* Cleaning only ECN bits of TW ACKs of oow data or is paws_reject,
+	 * while not cleaning ECN bits of other TW ACKs to avoid these ACKs
+	 * being placed in a different service queues (Classic rather than L4S)
+	 */
+	if (tw_status == TCP_TW_ACK_OOW)
+		tos &= ~INET_ECN_MASK;
+
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao_info;
 
@@ -1083,7 +1095,7 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			READ_ONCE(tcptw->tw_ts_recent),
 			tw->tw_bound_dev_if, &key,
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			tw->tw_tos,
+			tos,
 			tw->tw_txhash);
 
 	inet_twsk_put(tw);
@@ -1153,6 +1165,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			key.type = TCP_KEY_MD5;
 	}
 
+	/* Cleaning ECN bits of TW ACKs of oow data or is paws_reject */
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
 			tcp_synack_window(req) >> inet_rsk(req)->rcv_wscale,
@@ -1160,7 +1173,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			READ_ONCE(req->ts_recent),
 			0, &key,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			ip_hdr(skb)->tos,
+			ip_hdr(skb)->tos & ~INET_ECN_MASK,
 			READ_ONCE(tcp_rsk(req)->txhash));
 	if (tcp_key_is_ao(&key))
 		kfree(key.traffic_key);
@@ -2181,6 +2194,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	enum skb_drop_reason drop_reason;
+	enum tcp_tw_status tw_status;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
 	const struct iphdr *iph;
@@ -2407,7 +2421,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
@@ -2428,7 +2444,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
index 64d242571449..54612c07c511 100644
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
index e373ca997ee0..6eaa20430fee 100644
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
@@ -1745,6 +1752,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	enum skb_drop_reason drop_reason;
+	enum tcp_tw_status tw_status;
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
@@ -1965,7 +1973,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto csum_error;
 	}
 
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn)) {
+	tw_status = tcp_timewait_state_process(inet_twsk(sk), skb, th, &isn);
+	switch (tw_status) {
 	case TCP_TW_SYN:
 	{
 		struct sock *sk2;
@@ -1990,7 +1999,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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

