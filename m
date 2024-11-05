Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2086.outbound.protection.outlook.com [40.107.247.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DEA1D26E6;
	Tue,  5 Nov 2024 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801235; cv=fail; b=ucejwDEFfPAXIRC7lGGz6soXTXX9oRB9Kk6xI/uwCdwZlrMkh4ufq/R4JHiOO8um1CeBlVI0vTf26FFq4C0+IWpPM94mafd+E7looT47ZP+G5lIaPxZ+rWwB8TkOdir4biwBi65QMoohnKVulSpKorqr0QZ83dULEbnjRSqyQaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801235; c=relaxed/simple;
	bh=+fN0wQlh7EjE+4+Ds/P2ZVcJsFXPLcFSJmVQ6ZFXzUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQQq+a1kwHYpDJk6korFoaR9bvAGgKGJsmehBfaMBjbSWTFH6dUcJGAm1Z1Who7Rjog/Mo2XfHR5d7twYAYm/mLx3P5HFqoaWJWt66fRNdek5f9m2d6/ecEdouKQj0zwmR3mj6yCj8/Wfuirq00izLOpfbdfd3vAIomz4p4GXjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=m7Nz1TgS; arc=fail smtp.client-ip=40.107.247.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="m7Nz1TgS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVGKAua8oFA9STICXM2nSz2z2xUKgtdn5PQWfRpoPcpJAtVCzxoeJuercNrA/eCAuZiKfq3N1p60PUIb08BiCdY+Ux69Rv3OWXdC7VARUzgyS0Q4nq/3pkTZHIpS5vUDc1Z7shXywTBaesptpbG17yvgH8Ntbiv8t7JIucT23+y6g3hGsOQBoPNlnmDvtJxD8sYOglhYeyLq7a9EpC/UfkdSaq6e1CIzxj3NsqlTJu/y6hrYH86ERiip3J18OY6F13gtW60u8P6fJNTEn2Fx8lqQLvTxJStmvNedpwNK05CiVIV0NyHb/nGoHk1oAhBOFTFRDvkLdvs4Emr0h0Yf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxzfKuQL2ymqWZHjJRTMeflBQuu80RXXH9l9hWW5VEc=;
 b=v6e1MMJpNu3CCIbqrDGRzQt7BW8/Gm+ycbI0jNFy/F85xjzOzcFIlePRedVPR8ETkgEbGfvXqM09EgAwSp3vYeGk8fTjP24LZb7wtsQZMKzfNUCdqGJTFY9WNJgv+RSlzS6fTYjnWZKfYj2Z1Sfqr7Qfqyqo5YBwZUg6hihE0hlzzmO/Iil6eL2djKnHF/o1QiwuycdLPaO9KCyb/SINj4sJ1SW1+F8niYBMKyT6Qw3D9F/Q6TsEbVXEhzFB1y09gK8VVU/oqTKyCGlH0FKu9aaswVJ9Ion/g7HmJYb+qYmBFsQc6ldE8KbBoQv1GW8vXiUOKsOP3euMqIwsfl8jhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxzfKuQL2ymqWZHjJRTMeflBQuu80RXXH9l9hWW5VEc=;
 b=m7Nz1TgS9G4Yj5l8m+K5YjKniosyhSwRm75yid0mWnpj0jJ5gm0RZK3AQ7hrzUHXAamhktWOiweyTJNlW0Fvgiaf7sWDbYevrMt+18+59QZ5aSa4gnVhhnNLTmcg6YZ8khZXJX8RlkgzsEoKZ+MCES7ggHMaVCxb44qBIlY/KEYLAi5al8EztKJrIdQaO6Qpw/GOgIfWjS68Qwl9ClrxhikWgvwQEgt6A56AxzyPxSAjZGGpO/98dtj1yk7LfDNSGQTG6fJXpe91iDsuPuWJ2dTidkcdo4HdzARCv+p5qjBh7ZDIKhjNgu5jjYWJ+oW0tDsaDpJH/EUr55B4navtWw==
Received: from AS4PR09CA0025.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::15)
 by PAXPR07MB7888.eurprd07.prod.outlook.com (2603:10a6:102:13c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Tue, 5 Nov
 2024 10:07:10 +0000
Received: from AM2PEPF0001C712.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::8b) by AS4PR09CA0025.outlook.office365.com
 (2603:10a6:20b:5d4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM2PEPF0001C712.mail.protection.outlook.com (10.167.16.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:09 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2f024723;
	Tue, 5 Nov 2024 10:07:08 GMT
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
Subject: [PATCH v5 net-next 05/13] tcp: reorganize SYN ECN code
Date: Tue,  5 Nov 2024 11:06:39 +0100
Message-Id: <20241105100647.117346-6-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C712:EE_|PAXPR07MB7888:EE_
X-MS-Office365-Filtering-Correlation-Id: d69751fa-a3a9-4aee-8261-08dcfd819cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFNhSVJsUmRNQjB1Z3pRNVJFdE5jSkEyM28wWXdzdnMweHBTN0h2ZkJuNU1U?=
 =?utf-8?B?ampSdnhRZWJJU0ttNGdrbjdkV3IxT1p5VGtqamk2YXUyeWdLMjY0WFQxeiti?=
 =?utf-8?B?Wm1yZ0w0ZUxKY2ZaejhDMHRod3NyVlJUd25TNmJtSUFpV01OaWkwK3kydmZT?=
 =?utf-8?B?ODlMR0xETDJqdG1QUzI0WnpUZVBJYXdjWTl0T2tUS2E5YVJMYmYvbTdwbm5n?=
 =?utf-8?B?SER5M1BGYU1PK2xSbkZNQW50ajF0ZGVROTFkeEU3TDN4MCsydEovUXRzTG5E?=
 =?utf-8?B?YWkwRkxzVEIySHZOdUtMTVdUUDNBZU9YWkRyU09jdVkrNEFmNmRDQTZRQWpQ?=
 =?utf-8?B?ZlRpS0hLaWh0cEpzQ1R6c1ZoTTk2WWNDMjBJb0duNlpMbkJpNmU1SkJ2SVlQ?=
 =?utf-8?B?T2Z5cFRzMzNHejl1T1cwQWZKb3NuYjdycElObDhNZTNWMG9IWDNkb1pNdFdE?=
 =?utf-8?B?cVpqNy9Ib3Y5S1JwcnhDQVZSTnZsem43aUI1Zk1GUFF2SVpaNmgydy9ETnI1?=
 =?utf-8?B?SnRMT0p5VlpRcWZ5YUFZdG5Qd0ZMSDZIM0dPMHRDZ21lQnRFd1FnRHdGU2VB?=
 =?utf-8?B?MFNMUDc2WWZxZTJWOUhuV3hQYkVHUndZRURRL0pqcUhIWEdlZzdwelFRM2Nm?=
 =?utf-8?B?dzJUYTVLVTB5eXp6d0ZKZXQ4enJjRW9yaXNRQmFMV1ZaV2xRcmFQczFBUjJl?=
 =?utf-8?B?WnAvUkdqQWFpMzBZdk1Uc1gyVUhYWGR2SGhkcDBwSGlwazZabFY5dHZZbzg1?=
 =?utf-8?B?czhoN3FNTjV6RXdrdDdEU1QvOHViUmhKOWFFUEwxMDBGR3g0YVdTeWI4SUIw?=
 =?utf-8?B?MEtnVXEwQ2lNMktjUWNXd3JLbXU3VTBQWHUzRVk4QWNvdVU1NE12SVYxUnIr?=
 =?utf-8?B?R21OOEFxdzVMOUd4dG1iT25tWjhKdC9uVVBGT3RQd1VZc2hTdXMzZzVNaU83?=
 =?utf-8?B?VGVSR3NCS0FFaDlzRWJWdTM4ZHBtaEo1ZXpmb0Raa3R5akgvOS8zVGZjQjVN?=
 =?utf-8?B?eFZ6ekwwOFZDWm5JNGF0S3dLc3pZckYwZ3cxVEUxN1JDR2RwWHlzZGN1MzYr?=
 =?utf-8?B?eDJNaThIWE5NSXNxNUZxWWJ5ZzJTMzI1NVhPbSthTFdJMGhheDlUM3NKVEUv?=
 =?utf-8?B?VzF2OFlyVGxTdGF5VitXeGFkcmYyQ0VGMFJxL25ia2Y2K0Z1bVhVL0dKbjkr?=
 =?utf-8?B?WnpubUc3bTRrcXVKSGs4dzhQZGtpemo1TFFZanJPUTFUcllXeFlGWmZEQVhQ?=
 =?utf-8?B?VGVOQVloeFkxbGYvaFRYWndSUGRQc3NIS2ZUd0w2ZXFzbldBbVl3Z1ZNd092?=
 =?utf-8?B?cENaS1ltQWdQWUNjVjhWT3hUY29Rd2pOdzZDZXVNbmh3cHhHT3V1VTJ6aHhu?=
 =?utf-8?B?R3R0WlR2OXJWdWU3S2dTcklwdFF5K0hqS2tudW45Zkh3UkdQV1JHZzd5K1lI?=
 =?utf-8?B?OEhyekdXMWlSQk4zTWM2citEVEYwem1EdEVmVGVrYW5hZDNQRzkvdUN3VzBC?=
 =?utf-8?B?OGdSVFNISkZIRkxuWGY0TzdtZHJiUXIyVVpqeXlKSDUyQ1FETGJPUVBUdGoz?=
 =?utf-8?B?cnFyQWxTOWNidlg5UWdvdmRRQ1NyOWhrUzZJNmNibDNRYjlyMlhsbTdpOTkz?=
 =?utf-8?B?d1VDVU9OSDEySVVXNDdsSEw4bjkxTGEzOFU2alZKWWh0bHhRbVhSSkQvclZq?=
 =?utf-8?B?YlVtUUl1NlFQQVd6L0phRmxDclJ3K3hOZnBibW5XQ1UvQW1RZm9rTjVrcGtJ?=
 =?utf-8?B?M09Zc0o2NUhnYllRc3E5WXJ3bnNVdHlkd28yZmtFNlovZTVhS3BQTXJiUVV6?=
 =?utf-8?B?cmFZYjROcXZvNTVSS1Q5L0dLbDFabUl1RXV4Y1REcGpZSytrMm9qMVVPbE9o?=
 =?utf-8?B?RkRvMXh4N1BjQkFDQThwYTFYM0IzUUppcU5LbExjYTNRSXFkZk5kbjZlRDZw?=
 =?utf-8?Q?yJ47D41xENo=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:09.7490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d69751fa-a3a9-4aee-8261-08dcfd819cac
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C712.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB7888

From: Ilpo Järvinen <ij@kernel.org>

Prepare for AccECN that needs to have access here on IP ECN
field value which is only available after INET_ECN_xmit().

No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1b2f4a2e7332..9c47b46aa14d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -347,10 +347,11 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 	tp->ecn_flags = 0;
 
 	if (use_ecn) {
-		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_ECE | TCPHDR_CWR;
-		tp->ecn_flags = TCP_ECN_OK;
 		if (tcp_ca_needs_ecn(sk) || bpf_needs_ecn)
 			INET_ECN_xmit(sk);
+
+		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_ECE | TCPHDR_CWR;
+		tp->ecn_flags = TCP_ECN_OK;
 	}
 }
 
-- 
2.34.1

