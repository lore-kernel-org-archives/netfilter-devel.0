Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2049.outbound.protection.outlook.com [40.107.241.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F2B1F5435;
	Fri, 27 Dec 2024 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326785; cv=fail; b=lJ9w7dSJKGwTQLu8+1z0aKNWtKlPysXZsJ+ytOUlgJT6GzJhv8gvpqm40wIUpAnhQkSPjkiN/Ts/hrf/rBbl7rPf5/U/0m8pCWPBnchMeQo7wcEebl3OQRFCZRfV+i3mgzGgIhvFQ+WX6LN5zHE9Z5OnDjpICG9iRnsPLY6p77k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326785; c=relaxed/simple;
	bh=CcYlKhlTGVwvxQzpYTCdMrVmnxAenvKmQP4UbtR/PLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YU7yLtNTyBppTH0rufn88VJtxZepvajLMpPDT/hmOrhryZV0+PzXycJCQe1ONl0CkFScp6LMsKpnQTFmKr/j4Im19s+XbsIFJhtklSj8yK7c67abaiQ4VKuL8jzefWK5jtc484xHupCgsmDMAk3F+58pejSwt+VsWyiE+jnp0FE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=LvkTDv12; arc=fail smtp.client-ip=40.107.241.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="LvkTDv12"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4pOpJsz9aT7k3tksT3ONipGXbnWFuixT1bNeeL8/5UXMJg/p4jmUSGrHM7UAn0lNzyCYoq1aLSIqaMJQv2PiZ9lcGZ3Oj+P0dgpoveA9/usJGhuJc+gwm+dWAqTs6V8h3HR78fp6UEZE01tt0HvswN3VrlrOmi9UcT/E3E7kWmdezI6CJ2ncTK02ajtK3G+F/HdhrjouwdtmGJ7y/clhFjyKyMiJ5hFZ60LeVHdgdJlePIKoFBRKHWc9lTDMJ0sI1OZf2QLD6YP425tOtsAJu1KL7X4jQkxBOTNU4mdy6gT4564AeZlNbj+e/gojty1Nlp1TjJVoZkZ8e9r6CKrsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZodM3kenxkLT6tdhtrcBCDtwxzMjkz39v4Wvx5Iq0w=;
 b=lIAgsP4ddonr7l8O+NZW4Du/K4zEchWWDoN5m3niosDopBn2R8n4R0dfkiyt+TzLig8skoFeMg6J7l8sw1TZEGQSXAsIu46ISY0rP2EVkprm0RqNICATAvztOOaRVda1BNTD4L5i+1o9Io2JWbXUueQdmiHUhDYaXM+dELx3/IFOP3Wo8brElj1xosXJ7J0gaQCtsfgO4WGiLq/+SBVj3tdRNdYS/pWG9heOG+TSU5mRzxVLuUyk22j3mrw0JG0xFX0BX1kDydomECfNYmPtEhYw6uG8b0iX+cpMCYkbGJ2e5Cachc5/Llk2dNxHHcBgUMHpRUQgnE1hI80RUE75gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZodM3kenxkLT6tdhtrcBCDtwxzMjkz39v4Wvx5Iq0w=;
 b=LvkTDv12iAlKETVJsNqigQ8s7rQNeKoFJePK2PPM0fgfz7F5fk9lBsKszk4Frahmgpv6mceUmyahLoZVy/qDqsJEsaFhyz9eydSaiEzBm6OIoTts4GjwbUjbejJFTGDJCGXAC2oHYDwJOPio7hXgBqT/wmtXfrqap+qI46g6Nm3xDkcIvI679hbHdcNs5TIv9hMXl56MiXLx4t5e2zc9fpScRXFGSePdOy1m3sKTn13g1u2TFp43UgxP/Wk0hETsAqdSl/nMiX/mXys0/vk4o9zFqlPHfg8Ieuv+1VxQArhqcPasiB5Dz6drysqatz8FM0ix6sVz4NR7GYLRtjv2Mw==
Received: from DUZPR01CA0197.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::11) by PAXPR07MB7872.eurprd07.prod.outlook.com
 (2603:10a6:102:138::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.17; Fri, 27 Dec
 2024 19:12:55 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::90) by DUZPR01CA0197.outlook.office365.com
 (2603:10a6:10:4b6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:55 +0000
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
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:55 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2c011940;
	Fri, 27 Dec 2024 19:12:55 GMT
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
Subject: [PATCH v6 net-next 12/14] tcp: AccECN support to tcp_add_backlog
Date: Fri, 27 Dec 2024 20:12:09 +0100
Message-Id: <20241227191211.12485-13-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DB1PEPF000509FD:EE_|PAXPR07MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9f879e-ef9e-4dea-5819-08dd26aa7808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWNxRG1hVnIwSWJVeEtFVktsOTdENTd6SXg0T3ZBcFErYUtPMHhxYWlVYjU5?=
 =?utf-8?B?TWk2OXZTd1R6azNGWnMvVGRqemh6NXNFaHNqU0s0TWgvcVJzMXdZaXhMUThS?=
 =?utf-8?B?MG53Z3QvVm1wZjlwdUJqdUxETGhJenJJMG8zRWVBNlhId1dUNEh3YkhQaEpi?=
 =?utf-8?B?d3hMRmVzR1dwY2FaNnEyQ3ppaVc0MFdxaGtyWFhlTXlUVlhXSjB1OHhaOG1o?=
 =?utf-8?B?VDJKSmZpM3prNkM3aC8zemtvUlNaSjI3Si9LSEQyY08vV2V3SVhRZHBQQkVC?=
 =?utf-8?B?MjZzdGEwVFc0blUzY3JtUEZMeVA5aWxEVlJyYVM3L2JmdG9DM1pFTWlhSzBj?=
 =?utf-8?B?Z0xvdlcrOWZtSUtHN3FlUzUveHZiQjZJYzluMEluYnRPaEJlNlNOT1IyREZL?=
 =?utf-8?B?K1JzcWdnODVTY0hqVm90bnlrWmpjRkgrUllXK3Vidzd6M3pIbVllNDAzMjIy?=
 =?utf-8?B?VXpHMktiQTlUT3c1elBTemc1TXRxZEVZT1BoNmFTQXpOaWc3Y3YyeFk5MEN6?=
 =?utf-8?B?WVlYOTNwaUZYY01veTBjZ0ljbktFeWtCV0JlbjJySUlpeE1MVTV1SVYzR29P?=
 =?utf-8?B?U2VJRDM0SjFiTkdZcTFNNW1IZ2lyUjlHUWNyNXRKTlExZUdFMmFsaVRrU28r?=
 =?utf-8?B?cm5wcENweVVrRlBHbVMzYktyTWc1NEZMbGlNL1ZsZFF4L2RJRHV4THlGRG5L?=
 =?utf-8?B?ZFIrRk9qaEhrNW95ckZGMm9FNzY0anNUZWcvdEh6UERRWHlReVFWTTUvRnFQ?=
 =?utf-8?B?b1JpVnc5OXViRktEaDU5UmZrTXZqckNPSDBXdXpBeWxKQkxnZkk4eU1Gbktv?=
 =?utf-8?B?YmV0bWI4dHBidm1haWlVcXJ5YXprZlpiYXZDeG5Vbk5VS1g3RHpNMFpNaDJM?=
 =?utf-8?B?Qm5uRDd2c3V5RG1qV2JwVU5IQmZIOHE5Y1lxNmVwZ29zbHdLUjZUQjMvZG95?=
 =?utf-8?B?MkRCeTZWV2Rob2xXREZXaGh6R0tNNUxMKzVNQ29uSE9PSFpLNUtzR0xacDlw?=
 =?utf-8?B?S2U0Q2oweW9YVWVMaU12aUNCWVdWSDJTc0pjc1NxRjE2NGw5YklweUkzQzd6?=
 =?utf-8?B?aTBaajE4NzYzVG81ajcvSlJSZU1jc2xQRVo5WkV0azQycE5GZ2FQa010MVZv?=
 =?utf-8?B?bENBc25CRGRkQjdtVEVvZjZXSGY4NGtyS29vMjVJMHhMZXFJWDJqUExYYmlB?=
 =?utf-8?B?VjFOaXVxejc5UjYwdit0VW9OdXBLZ090TjlJOElMby9XRG9XRmtncER2aDNJ?=
 =?utf-8?B?TlN6NDkvOWkxcUJyNlJtQnpFTDF3YW5WUHNpOWxUMmhNSFk2cGo3NUZ3U1pj?=
 =?utf-8?B?WDM3dUhid1ZubzlyV01EVGo4MENhdUJsWCtpaWxLbG1RUnFWUjZ3K1lJRmdP?=
 =?utf-8?B?bkxuV0NRcTJYOWdtZFRWMlo1bHVwenJheFJPQVRSWEVycEw0OHdDL2I5WWZO?=
 =?utf-8?B?ekcwNmVWc0s3U2lIMm9jektOWlRXZ2lQRTB6MGUvbEgvV3JNYUpCR3hPeFFU?=
 =?utf-8?B?bEhQYWNxWitWdXlBMkdnV0t1dEd2RWJNaDUvdnFFSU5uRk1VblY1NzNtbzVV?=
 =?utf-8?B?YXFwUVpQNTBlSnV6cXQ2aVJUSGM4a0NzTW5nTDlHTHVEbVJ6cWp3cmNIVGo0?=
 =?utf-8?B?MktYOVRDRSt6MEp1dkJvdHlhT21pcFV3Um0wbGhKY29SbkZidGxJVzU1L2hF?=
 =?utf-8?B?WHdCV0szaGxNdjM4MjgrVlpZY3ZOVWVKL2EyZ2RHdVgzNkY1OGJGSjV1UU9k?=
 =?utf-8?B?cE1rS2ZrNzlheWppbXlVVEk5MVd5eGxlVjA1dHBaaEJnakNrbW5GUWJMZEhH?=
 =?utf-8?B?MDMrS3kvdjVKWFp4WnpwZktsYzM4dnJmU25Cd3FNUlZiVUNMcG9wbUdJR3ZK?=
 =?utf-8?B?RC90MnJFbGU3aWcra1IvVDFiUUJDR1ByRDlKTExUam4xMzROaE1hbTRDQ0RT?=
 =?utf-8?B?Unp4NWwyTzcrM0grak5iczFCM2ptajhKSE9IOVdrT09qT3NKUnREam9GK0Zh?=
 =?utf-8?B?cUZxTWZkdCtuZGpQaHB2aldOeFFIVURObEMwTE9zeE10SjNUZm8yMWV6bkIz?=
 =?utf-8?Q?QfWMvf?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:55.5024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9f879e-ef9e-4dea-5819-08dd26aa7808
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB7872

From: Ilpo Järvinen <ij@kernel.org>

AE flag needs to be preserved for AccECN.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b0b8bbfa9386..24ec0ade8ae9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2057,7 +2057,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	    !((TCP_SKB_CB(tail)->tcp_flags &
 	      TCP_SKB_CB(skb)->tcp_flags) & TCPHDR_ACK) ||
 	    ((TCP_SKB_CB(tail)->tcp_flags ^
-	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
+	      TCP_SKB_CB(skb)->tcp_flags) &
+	     (TCPHDR_ECE | TCPHDR_CWR | TCPHDR_AE)) ||
 	    !tcp_skb_can_collapse_rx(tail, skb) ||
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
-- 
2.34.1

