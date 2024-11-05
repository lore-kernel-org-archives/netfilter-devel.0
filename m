Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2055.outbound.protection.outlook.com [40.107.105.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77AB1D2232;
	Tue,  5 Nov 2024 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801235; cv=fail; b=lhPJbHg1F9O+kJ6wc1yiv3GqzoM4pUjI3pyGee9TPZA0ORa2iveBeG00Rb5yK6dpUs2eSWrKlUDTiTRGOaRvuaek6YQCZfn7kp5HzHCDx3zvD54CDeWIbPZkMHQpd3uiIquAOzg02q7k+R7ZiCxfRH+7m8ML0KihJusIV2Iyd4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801235; c=relaxed/simple;
	bh=VHilEMYxpKn5hhen868ZcLWPndwq2c439JHOD2fLgIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=twHw+Iph940mggJ7UcdXtylEZY6YUEcvOOsZB6uhhUXiI7gEeB4C4RGTKlK7L8deyoijEYyUfqZo2ZZEPuVCvNIQel+xVLDMs/1JWChsDurC6kRtCe8oOm36PLxtJi0sDpmPhDbDiKkAQvJJTchmL/y/QZt+LqIHnbwDiSgd0jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=ivyt2rSY; arc=fail smtp.client-ip=40.107.105.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="ivyt2rSY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogeuAeruFfwnVRfOxGWXL8Z0/oixKj14CoV9fAVMeyNQVoJNqDgL4RYXdLOcpOF3JOMjE29hVoApQ8PHKVjZ9kOlDrxX0y/Ec4+h6caGsBktK2Qb7/9YhCvXbBpzPjJn2bfnMxCTswhh39CkKbRUC23u3napatTylVgSXMUrt0yF4cnwZFNSP1rP30wi+Vsq3hmc7lNzb/fqq3xXOiv8Rfezf1QhzD+dYbIl5dhWl4TW/DsS+4kSgbdtUCu64E+xMXNkF64/2TNPdedYQFo9B4kHKgaMmmH1jB5p7418jBLGQOJh6lzuh/lPhJ1Dz65vgqu04Lg9lKnmmXvt8b6ITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iG33npHxgvNvqmIUpLFwRjxAsBrazRJD/A6KR/X9W4=;
 b=Vptjv6ZKRDlBIxfbxIFY9zO1hPnbQqIgcYBhUOLQ8crj+V6L5MzvIItKSOXWT8hHdVBtgtEh+ZKbtlwVe57YQO5lHGJCH5ID/1f0DTxG+7CdURukt6MAJnqbPnDGQ2QCLSl58zUfQGEJw+8Yz5gxN2RQ21wt1TfoLsV20VcbP1dXywTWsWCeW8TlEX7r+KBkcC33+hXIc5n1s/5YkCOMQIUID4o1EDrxMzSWAy/VI66/m7hMFrZrOs2aiJqbpuamEqWLYMYZCYw+1VoCl2EPbEz+K4lkXDszeC2xd/P8L3iI8ZKExk7NS7u/j5oWGjAVcgRTLCckn8Jv3TxV1+hzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iG33npHxgvNvqmIUpLFwRjxAsBrazRJD/A6KR/X9W4=;
 b=ivyt2rSY1c5TA697UJ/IBmka/iYRRDHnNUmSGOXKepnIhPFUAJxYnBUiAeh2NED/aJM8fWaCz7lJK04/6BSuMka2KDaM69YUpbUJXNTNwVzYYrrRiiQqkttkBVeiZzi1gErJEdpQrJ5PiCxCIEEqRHD4NFOKC0wEWSqXiVf8mh3s8z2WGBfQa/V69LdkFL2hpwZiJMx7vxsRARoC+i4hgAGCBwzACSsOxsCyC+R4rJMSHi0w0Huf4saGMEHII5OBil9q7Jx2XIjAtI3nw3XMiXYlLJw0308/vuv6govkqpjHg/EQ8H6znbtVb7+4dRN0zUlGiuhT0GCaG54z0KuIPQ==
Received: from AS9P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:50f::10)
 by DBAPR07MB6790.eurprd07.prod.outlook.com (2603:10a6:10:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 10:07:07 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:20b:50f:cafe::2) by AS9P251CA0002.outlook.office365.com
 (2603:10a6:20b:50f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:07 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2d024723;
	Tue, 5 Nov 2024 10:07:06 GMT
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
Subject: [PATCH v5 net-next 03/13] tcp: use BIT() macro in include/net/tcp.h
Date: Tue,  5 Nov 2024 11:06:37 +0100
Message-Id: <20241105100647.117346-4-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AMS1EPF00000049:EE_|DBAPR07MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 0928bf4a-64c2-4350-9564-08dcfd819b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cndsd0sreS9nUkJHRXA0RmtRZ2FZUE5Kbk1jMDdUMUd5RnNhV01wZTczWXVY?=
 =?utf-8?B?alFMZzU3cUtkNHROdG1Lb1NFWUc4YXp2akR3Mmc0NnI1UkkxclFML0REb3Iz?=
 =?utf-8?B?eUYyWXJ5U3NXR0xJemtSdHFhc0ZsZWFrWEpvVkRaTjBqWkMrbG9rMFIwby9n?=
 =?utf-8?B?NmE3bDA1MUhSUkY1NUFWdVNjYWh5NmdhSnZzUnhCNWpuRTRXRUhiSmNac0Z3?=
 =?utf-8?B?dk9LaThYeXpPZEk5R09BMU9nM3VYK0hBN3dMTnRxc3Fvc05aL0dRaG1HbndF?=
 =?utf-8?B?dnRubkpiWVVYOTVleGtDNDhlY1J1eTQ2cGZRNG1sS0JxS2ljOWFBQUU4N1Zm?=
 =?utf-8?B?ajNpRElwL0ZNR05Ea0s4aTMwTUczRGRaSi9DUnhmc0hhOVlna2NNaWovK0dJ?=
 =?utf-8?B?TDJ5UXZXcmE0NnZ1UWE4VHh0ckR1WTBnT2V4NVdwV1VTNlRXeEYzOGJ2bXhm?=
 =?utf-8?B?bHBPOVFJdVhZZlZtSTAxeDExSkhDRTJXbnNSQXJzOTUyelpMc1BGTnkreVMv?=
 =?utf-8?B?RGptMWVVTWEwYUZDYlJKZThCaXBMNlR6UHZjY1NCMS91bjQ0ekY4TVNmKzVu?=
 =?utf-8?B?akVOVHpZRFJVWFhDRGZkNnRVMG1tZkRZZ0RvVk5MQ0ZBL3RqYTZUb0ZXbU1w?=
 =?utf-8?B?dzRoYm13VTdMdGdEVlZ3SmFEWGY3SWU4eDMzMmYzUzJWaXVKTUNDQ0kxNUlV?=
 =?utf-8?B?cnkza2RQUGpXOEw4RWtjK0hCd2dwSlZxR3dMM1ZnZDdkZjBmVXQreHd0am9h?=
 =?utf-8?B?LzlHYWg2L1VmZ0ZOdGJYNWhsc0xHQ1R6N2xkUkpzOVNRb2l2NE5uUXdHTm5D?=
 =?utf-8?B?Q3M4Z3k5WExxOW9pZXd5M2VmSGM4NnpGcVpzYmp2Q1gwUXA1SmdnOXRPcG4z?=
 =?utf-8?B?Q0Y0YWs2QTFRemxYL2FISlhkV3Ixc0hZU0l6Ykd3akFYdzdxdUxtd0UycmtR?=
 =?utf-8?B?MWRlc3FONEJPV2JDdWtwUEZITWdXbHRVRDh2c1pqMFB6U0h0aUg0UVpEUlBv?=
 =?utf-8?B?RUlpNm5OWEVLaVphNjlWT2RPVFpqSXAxMk05aFFCNDVVaGVIYTlaTS9HT1JW?=
 =?utf-8?B?WDZydFRoTmd6QUk5dTd0SXdpYWdOWkd5bllNVGtlVEJWcWdsaUpBRU9DaGdX?=
 =?utf-8?B?L2JTMXFGTlg3cTdqNUZ3UXgzR3VEQkhjVFVOemo4SngxNjlFQi84SE9SZSth?=
 =?utf-8?B?eHNCSU41aUNpajVZRXhNWHBpZW93SGVHNDBDSFdlS3FFbjMzMlMwQlgwVFlO?=
 =?utf-8?B?bnVyL29vVzZtZys3VjBMZ2tKd20raldPN3F6KzBhN0ZpaVlBVTcybUY4eWdp?=
 =?utf-8?B?bUlUekxYYWFSdXpkejNjYVRKRlphZ0pHL0ZUZ1dwS1hNQThKVVpWS1pCRk1Z?=
 =?utf-8?B?ZlMxWFU3VnNhaHBUS0JwM01ORWp4bHhRbTZHcWo2bDBubkJ4WDNDRE5DazUr?=
 =?utf-8?B?ZXVjVCtxWEVrM052UTYvWkQ5WTlwbVhENE0wYmY5bjk5VVVxZlB0NE9zeUFh?=
 =?utf-8?B?QU9jSGU4NlRIaHpLamNTRWRGZkhETUFHeG1zVnFrdkpjSzNkZnJmYjJ0ZExk?=
 =?utf-8?B?NkpyLzR5Um84UHV1eUpEUW90WTVaY3NUelk4U0YrZ2Y2cm9EVkNOeHN1ZFo1?=
 =?utf-8?B?UGF2RjBXOWVHWnlNRU1ubFAwR0pXOEhPRVZMbnRpaFpqSTZsdXJPSm5uRk82?=
 =?utf-8?B?Z2NseXI2dGRNeTBBL1ZGcFNNMHFqTGxpejN2MFlFdmkxUGlvbkdUaEtzUmpN?=
 =?utf-8?B?S3JnTnJ4cHlHd3hoaXZ4bms4YUJPSWg3S1U4M3EzVFg5T1pHYW5VVUlxbXhK?=
 =?utf-8?B?dk9DanMzU1NYYmRDVEdOY2hkY1UxSGhuT1dtVlpldjF6d1Bxdjh2VXBTdGZv?=
 =?utf-8?B?a2RrVGxpTzRQMUpxNmVjQzNCT0FKRHZtSG9FaUNSV2o3OEJBbnpkT0RrV2xV?=
 =?utf-8?Q?9SkB/00/2fE=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:07.4647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0928bf4a-64c2-4350-9564-08dcfd819b2e
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6790

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Use BIT() macro for TCP flags field and TCP congestion control
flags that will be used by the congestion control algorithm.

No functional changes.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Ilpo Järvinen <ij@kernel.org>
---
 include/net/tcp.h | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e9b37b76e894..cccc6b739532 100644
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

