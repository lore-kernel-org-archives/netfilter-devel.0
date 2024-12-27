Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275211F8EE2;
	Fri, 27 Dec 2024 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326770; cv=fail; b=uFX4xH6URE0W1Ch0ucyGWwH6g9PBxb8dZUBqgrUusOKdSLsXUC8J5EmWqdjMWe9d/F4WvV6kgxwsPZtjL71GO6k+QkT8t+akdQ4VA7e+6YrIcjV2AX5uAjk67JY64HVwxzkCcvHioNHlz0J3y/K6lu43UXssnfcnmAjzwSGmyS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326770; c=relaxed/simple;
	bh=MsdAqWnPWRxZPSL/UrZmoKcVK8CirxJipjJtss53gr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nMzP5e8sUQRiGBgJunSZAkbYfrdAABibr3UMtIbLYg/h3gHC83Ho3SQzd/1w3HVS7pNe/Mr+UW5RDPoGYPwx0DxKMqekzfNtwUtCBEiHv5LoXrwIHUKBq5qNaOvJ5wQbLYXmTbWzMBkDpCDaazQhl47ewytQUYhdto7CyrRQN4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=VhiFlpBn; arc=fail smtp.client-ip=40.107.105.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="VhiFlpBn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haUkDeU6SxbjlU6VcnJyMmjQJhJfaEJw6LRTDmivZub5Bem2XBCD1K53h3iOrDhHUWQbwxn8APQUKnd2I/dVvCrmQQNS4KiwPp3H1hBpbrmD6TPI0OBQkOcwrY2RLnD8F3MUfiC0Yqf415Krltj44dhGTikjFk0R4jUZpmBGSp0nnTiyaJbP4wXtCforNmmt3wP/C/4p5ACDgbPiVcANXBm/QE9i9KvLq/UXmFJyJZwp/b1dGjs5Otld3N2qhBpxY0UDCl7XqE3UmsGAYFJmcR90NoBdeVkEf3ypdJyHrsVrxJvlfNeWk+7fodhgj3EURIVoraOw+HX2Vv11GcWvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kv5g0ulzAH5jx/foekk8GpabdDVTZhLYKyA16xv0700=;
 b=jMILg2oKQo5N7XE1N2Rcp2a62/y2bOfFGTqfIw+Ukq9ToPGotOxDtEVAJH23nFeDTBLkEVTGQV39VjhPe/G2/OUzbqFV15XbyHcqxZ0F7H2jYFbqHm8kKTP9s0hiw5bNtZtB66R6zNEktHzAXEBlCYW7dJCzRSPKJIbwJM3UJ51myzHz+6OX1/nKjjIvkKEcgxHkmnj0nSlyfx+3ECPrm4Fud8KpRWvwY/VVflYOqJ4dmIYoTZxKwxXLETB7Oi3E8k1NNMwqsdDnLJcdoWH96cYdO+U1wSv4Jgh6UONbEgskTgpAac47W2YKMfLRShlUrx7JJXvKzcCkmytv/vv6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kv5g0ulzAH5jx/foekk8GpabdDVTZhLYKyA16xv0700=;
 b=VhiFlpBnGpK5hVC/gA+l5xlHYUJtjAsEvl+Y1Kd+CzEDHWPygXw4Yd4oX+IVJn3jbnMB8mzfdHIz0+TkUrRXNf3JY06rW80KZksn+/z6X6SJ/exUNDVjLjeel5UscHQqY3A9b8ZWvfn/spCzNl37Wx69wMLH/j53PBKVvrHy5NlvPl9LKk7hv99gOB2vzTo7kTgxJYIdDeyqZUwC7uA3ceas6WMx42rG7WZv0HZbDso6aLuGGLnJJEwDpvTmb6xqm94knpew0K0hyVj/zUmp4lFFpQNtU90v1MrxW+amrp3S0pxvPqfcWhWr2tCfvjQeO23FGbeH4uxZwWoS5t1J7A==
Received: from AM5PR0301CA0021.eurprd03.prod.outlook.com
 (2603:10a6:206:14::34) by DB9PR07MB7930.eurprd07.prod.outlook.com
 (2603:10a6:10:2a2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Fri, 27 Dec
 2024 19:12:41 +0000
Received: from AMS0EPF000001A9.eurprd05.prod.outlook.com
 (2603:10a6:206:14:cafe::c3) by AM5PR0301CA0021.outlook.office365.com
 (2603:10a6:206:14::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AMS0EPF000001A9.mail.protection.outlook.com (10.167.16.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:40 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2T011940;
	Fri, 27 Dec 2024 19:12:40 GMT
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
Subject: [PATCH v6 net-next 03/14] tcp: use BIT() macro in include/net/tcp.h
Date: Fri, 27 Dec 2024 20:12:00 +0100
Message-Id: <20241227191211.12485-4-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AMS0EPF000001A9:EE_|DB9PR07MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e659a4-e3c4-4ce7-4f10-08dd26aa6f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmw2TDBTVk56SEpyRDhyYmlQbDk2dTB4NkI2VTJtQ2xJYmNaS0ZEekhTSUxG?=
 =?utf-8?B?TS83bDI5VXZOMlFkNkF0NEdCZWk3enpaQVo3bmtQMDdhQWZ4MkpyRzNNSkc1?=
 =?utf-8?B?YS9PYnFJSnVaVVcwUitmdmJqcWN5WDh2MThkWjFpSG1kZ3h0eW1NeDByVWU1?=
 =?utf-8?B?N0djaTh2OTQ2VUViWmlOMmR3QXp2Z0VLWm0ySDJaOHF3ODQ1S1JBNmM4QlZM?=
 =?utf-8?B?Ukx1VXFqWFNWZGtJaU1COWJ5Z3g1emFFbUs0dm5Qem92TXJidU1MM1dkWXpO?=
 =?utf-8?B?Y0lLL2dkbG8rdXJRWWhLVUJLZG95ZlRFN3U2ek1PMUFNdmE0WUNYQnk4RHdD?=
 =?utf-8?B?R3hHc0I5R1pGa0Z0dkVuTEtqWC9KMUpVNlpGcHZxZFlQbDY2RUI3T1dGN0Fs?=
 =?utf-8?B?VVdvdmtUaUN6L3JWZHVWRVpyY2pzQlQ1TWNpUlFsaWVuZE5Ba2dHK3pFMWpD?=
 =?utf-8?B?cDlVYy9FT3FzVi9VSFJCS015WmRJVjlvcnp2eEloRmUzWTFGd21Ya3FzbTV3?=
 =?utf-8?B?eHlVaXhyeWxwRmx0VE9Tb1M2eTZzODh2MDF1aElKVDlMa2gzZmdEM1YzRVRI?=
 =?utf-8?B?OU9yc082STJpZk5MK2xuSGpYU1hNR1FoMFpiN2VOMWFlVjdYMVg5YmVSQmJt?=
 =?utf-8?B?ck4vd0dkTGdVdnd2d2k0S3VWYVUyVURYSS8wWUZnVU9yeVR1RU9qV1VmT3Fv?=
 =?utf-8?B?K0tZSGlxT2ZDTmJRRm1RcE1OWFRGK2VZMkoyWVlDNCtuOFV1Nm5VRVp1U3B1?=
 =?utf-8?B?eFhwSjB4MmYwTlo1eDRPTUhMdWZDNVoxYXBCcUFLR3g0T3RBWmhaSFZDZmYx?=
 =?utf-8?B?bWh3dkpRa2xTN2hnZDZMQVk0aDJaOEtJNTQzOExZQzlTeXBwdmJxQ1dIbFdZ?=
 =?utf-8?B?S3lYSFVWZDhvcW9nUmVDSndLUStKaFpOclhjMUZrOTQ3bkVWWXZpSm8vT05h?=
 =?utf-8?B?RXY3QmcrbGFQMG1lbmhrVVF5aVVQZGFTalJ0L29UQWp1cms3YndSU3dXMXUy?=
 =?utf-8?B?YWFNQ3FuS2ZRb3pCVEpkRmhQZ3dXalNSa3A3N0xyMVBXTGZkMWJkWmo2azVK?=
 =?utf-8?B?SHNaVWJtT1drdHdXaGp2Q3VEbjJuU05MM3dtK29IZEp0VUE5UzRMcmc0cldu?=
 =?utf-8?B?MlFSZnVTbXIxQnJvVll5ZmNrb3c3d1N4QVdlQ1UzUWJEajFxZmltem5abmFy?=
 =?utf-8?B?Ry9IRVp2ZDhIckNpSisreDhsWjRGdE10VDNKRWVDM3hjTnZCWWMxYVhqaDB2?=
 =?utf-8?B?NlJhK1lTZnF5Um5PUFdSRnNwZ2M5SUlmcytlOUxJSThEU1hpSlVZZVd1c1hs?=
 =?utf-8?B?dFVEOUNUelhmU0JGZWtXemhEbXhKQ2s5RUtXZ2FBTlNoQWFISGJCRTVTeUc0?=
 =?utf-8?B?U2JLbGV6WXJBK01VK05najVhUzM1Vk5BRUU5WnlvRUVQQXZvajZxZjdDNkF2?=
 =?utf-8?B?a2t1Rkl0SzZEMURpRnAzV0VZMGEwcVMvRytRWTdMZE11aGtxZnJNcXJqcitT?=
 =?utf-8?B?Qm16bzlOV1Z4b2F0YjBYb00rVi9kUzBLbG02V0RCMWJucG1iUml1S3lodElu?=
 =?utf-8?B?U2dCQUdQTkh4amhibkE4U001bGpQblJjVGxDeVN2alllZzc5aWhObFBKeWl6?=
 =?utf-8?B?NkRnNmxrVUY5MVplSVNTMWs3MzkvSGJCTDlxSjBUbytUM1BpcVFhYUhVTlQw?=
 =?utf-8?B?NUlKNUJXSENscUJjY25iZDc1Z1E5WnQxbFlhdnlBcnlmRGdPaHZGbHR3QkhK?=
 =?utf-8?B?UnE3dzJUL2lUSjBwZDZ5UGtPSjE0ekNIdUl1eS9WeHdjWTc1aUJSMHRBaFl6?=
 =?utf-8?B?UFRTVkVtRHFMQnlNa3FDUi9nN3FCbnNBRW83Si9FRnlZaU0xL0lRWDhwQmI3?=
 =?utf-8?B?YjVzcEFyUUp4WUtueHdSeG82dGpDcjk3WGNGd0I3dFZHQmV4ODJoNmVvcS9F?=
 =?utf-8?B?cUxFQldBSzZJTjh4TkIvQndreEFjSkJ0UVcvQUVvUjZYdmY5STZUaDR1d3Qr?=
 =?utf-8?B?TnBObjQzUWVLL3gwcDAwS0RLaC9yakJCait2c3dncTRQL2hyRENHWnRzQWpO?=
 =?utf-8?Q?4WAowC?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:40.5338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e659a4-e3c4-4ce7-4f10-08dd26aa6f1c
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR07MB7930

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Use BIT() macro for TCP flags field and TCP congestion control
flags that will be used by the congestion control algorithm.

No functional changes.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Ilpo Järvinen <ij@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5b2b04835688..99dcbb47eac0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -26,6 +26,7 @@
 #include <linux/kref.h>
 #include <linux/ktime.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/bits.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_timewait_sock.h>
@@ -911,14 +912,14 @@ static inline u32 tcp_rsk_tsval(const struct tcp_request_sock *treq)
 
 #define tcp_flag_byte(th) (((u_int8_t *)th)[13])
 
-#define TCPHDR_FIN 0x01
-#define TCPHDR_SYN 0x02
-#define TCPHDR_RST 0x04
-#define TCPHDR_PSH 0x08
-#define TCPHDR_ACK 0x10
-#define TCPHDR_URG 0x20
-#define TCPHDR_ECE 0x40
-#define TCPHDR_CWR 0x80
+#define TCPHDR_FIN	BIT(0)
+#define TCPHDR_SYN	BIT(1)
+#define TCPHDR_RST	BIT(2)
+#define TCPHDR_PSH	BIT(3)
+#define TCPHDR_ACK	BIT(4)
+#define TCPHDR_URG	BIT(5)
+#define TCPHDR_ECE	BIT(6)
+#define TCPHDR_CWR	BIT(7)
 
 #define TCPHDR_SYN_ECN	(TCPHDR_SYN | TCPHDR_ECE | TCPHDR_CWR)
 
@@ -1107,9 +1108,9 @@ enum tcp_ca_ack_event_flags {
 #define TCP_CA_UNSPEC	0
 
 /* Algorithm can be set on socket without CAP_NET_ADMIN privileges */
-#define TCP_CONG_NON_RESTRICTED 0x1
+#define TCP_CONG_NON_RESTRICTED		BIT(0)
 /* Requires ECN/ECT set on all packets */
-#define TCP_CONG_NEEDS_ECN	0x2
+#define TCP_CONG_NEEDS_ECN		BIT(1)
 #define TCP_CONG_MASK	(TCP_CONG_NON_RESTRICTED | TCP_CONG_NEEDS_ECN)
 
 union tcp_cc_info;
-- 
2.34.1

