Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2060.outbound.protection.outlook.com [40.107.20.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8041D220E;
	Tue,  5 Nov 2024 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801242; cv=fail; b=BRij6BGvaeN5r6Ns05jLcvLbSgh6im7Z7OW83l0c333Omr3FICklxLIPHrVozqB4fpD4yki/s/6jpEgigxoqGbWoT71GYbwayGMfw5JpFdCxnS5JtUviTPIzaO/NWHfYFhXyoUT7Bqocyb+qAWhjxUbk3dE9ZrNPBM9lzC8SvDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801242; c=relaxed/simple;
	bh=eOHWPwMJuz/mcwi6S8cnhycMYE+XI1TmSzdOUd8turs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjUvUFBOEeVPEQ3w80O66b5BfbIclo5coFvotGvdOvUEgATmht0tdACnBxqxmufKDvmVin6H7segfrRRTS+UjdSU7UvbhKi1OShz2Fyw4dgmNdNXTwkS19Knd30WMDqtwl66pJg8p4B68mo+w9yzJJtyfIojncTH69IrvFYudoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=sMOi+AeR; arc=fail smtp.client-ip=40.107.20.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="sMOi+AeR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAEzHhVSb9uk+J0FPWQ38R+4J/DyN3VrvpcmnufJzYr26hPgFezvmkcnOZ5TP+tl+U8CEzycmMke1m9vltsivpy8Lt9Hlq4TALgDX5rWN4Kj2RbBn+oQPngxmCaSDdBLUPrGTm9xtyCARRyawwpW33r+vArGhB+k6mmOTzaVE4IE9ce3yUOs0Jt7GyQRvoT2TomXmgTTksblReui02wdVQkELs+aDs9K74QhXXCQyTMtaWLw/zvKf6qpCV1i8ZIaKazStKbktdQDHGhjkKtqCEqfC9iGTMteehFUL4bK38pA0B3qu63KNCLKqj1zsh0i83a6pKgbDzcBxpO1l8D/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlFDTlzD+PlG4iZfYJwLSQYGNnGbWGzidStYupmxf7U=;
 b=zWJ4wVvHTGyNd/q0c1Z/WrkGi35Ag3DA7cuG1UaCOJ6ZKBWxly7sLt38PfojBJ7aJEt3jTDWSAOzJeWLqzNULlTb16oUZ3BvmOl+qmpchIW4hBUBtnQlw5l1Wb3Qu8QUrvpyeLHvN+NXbX+zvQ1UGnX9ZNeIFvx/yYxOO6+fQz78GgRrWDML0A+V89ZjTMbX0JBeabFa2E4TCJd9HDoq1NZPTLkgPVw/3I/64FGD0xWifnRnNNzena7xgkLHteKEmMspIh5nzBFudq/3o002zec7XXAUOdwPub1AYVhVN34Rk9S+NiPMN5lf9/+pnfRF4j42+pguQr2ngsDmegoIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlFDTlzD+PlG4iZfYJwLSQYGNnGbWGzidStYupmxf7U=;
 b=sMOi+AeRVz/NsK/pe91yJH3WIUtnBaHVrDfZA5P3phoopPbh6D5Il2VuHwhgsuvaJxwYR/qoTaj51HGdF/iW8JxnwbHiCYZkHE+uGQvtN2rx1K/vFcbpMHBkAQ7aFyJLZPXo5cspBrhi+iay7p07kHpCKbm+V3B1HygSLPpeRW2z3Rs2Y9To3ZP+RIweMh6c6f1vUjtq2f+6bqJcTONhzyhqUfiIF2oNhpVse6U1Tx+XoWr12Jigii2Ryh3y5V3yr96al04/8O4uJN9Ss8MMDvl/UqTcpb57cj7TpFK5dhaiEgdfIlJuFS3sblHdrI9z1wwoRxVbidlhACePq6IlyA==
Received: from AM6P192CA0060.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::37)
 by VI1PR07MB9458.eurprd07.prod.outlook.com (2603:10a6:800:1cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 10:07:16 +0000
Received: from AM2PEPF0001C715.eurprd05.prod.outlook.com
 (2603:10a6:209:82:cafe::d5) by AM6P192CA0060.outlook.office365.com
 (2603:10a6:209:82::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM2PEPF0001C715.mail.protection.outlook.com (10.167.16.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:15 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2k024723;
	Tue, 5 Nov 2024 10:07:14 GMT
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
Subject: [PATCH v5 net-next 10/13] tcp: AccECN support to tcp_add_backlog
Date: Tue,  5 Nov 2024 11:06:44 +0100
Message-Id: <20241105100647.117346-11-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM2PEPF0001C715:EE_|VI1PR07MB9458:EE_
X-MS-Office365-Filtering-Correlation-Id: 435a4c7d-3283-476e-e69c-08dcfd81a028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmJaSElIdHB3TzRNQjU1L1lxSmxseVV2SUFjNVhZa3d5SDNyS2I0YURwZHRr?=
 =?utf-8?B?alI2MUFwWklOWEZNVmx0WkEydXAwR0tIWUlpenFOZ1p1K3BJejlsME44NEI4?=
 =?utf-8?B?d093MWUxNE5vL0lncERST3kzcWxLK05KamJqU1FYZGZUWFdFU21Kd2VRNHVP?=
 =?utf-8?B?aWc5WFdENk5abTRZVFNBelhDN0JaYjBnSTNNQkc1QzVyRkw1dU9JQ0N0aXJO?=
 =?utf-8?B?aE81QjAydWNFK0M4aDA1amZ0c3JZWENYNGNVVDZtNVZ3akhMbzJHWTVYMzJx?=
 =?utf-8?B?dVNrMWFxY3M4RytJdnRnbXhIVk9yZGh3QmRpREV2bVBGaWV1ZXFiM2lEdHVt?=
 =?utf-8?B?YUx3RE5qNko5RmxyS2ZGMGNNNnFVUUVTd3dvbHFQTzdncExPUlQ1dmlyN01r?=
 =?utf-8?B?Q2tUTlFtZXNLMkVjVWgrWmhKR2g0K2NsN2VEdDdkYjRxbTlEQnF0Y0RHaFc1?=
 =?utf-8?B?Z1dFRGQvMnRYTm95WGNZbjcyWVUyKzArYVVEVWtXRnJJR3M3YXJnckppZW9Q?=
 =?utf-8?B?dU1qWThBUCtEVHJGelJYdis4QUNNM1JjZjFSaHloWmNSOVJ4aUJNek53Y1FP?=
 =?utf-8?B?SVRqaW02aTc4NXZFK0R6alhCcUFMc0FqdWx1OVhtOE43Z2xyenN6OUZGYnBS?=
 =?utf-8?B?bGF5enJzTG5hSWZUbmF2RG1KZVlOQTFMNmIvSVF4WExWZUFyQzA5Tm4zVzBV?=
 =?utf-8?B?VTFvQ3ZYQ3FDZTdxWm1QSTQzZ2pLNFZEcHZsL0thK0tvelMraUFWQUpqR3dn?=
 =?utf-8?B?cVdwRnlmTklkUHllOTZWbmxzbGFuSW5xaUV4WXdmb1RaeE9LekxwK1lmYXVO?=
 =?utf-8?B?ZmpVVXZTM3Vhbm9VSE9CcVFIcGJUNWtETUlZbGJ4VVRmUXNkVjhGdFV5dmd2?=
 =?utf-8?B?NlhFd2RZWkhPQnVPUWhDNHk0ZERFZ3JpRVZkTm9qNmo0YWxldVBqRW5QSzE5?=
 =?utf-8?B?R1YrK1NCYjB2TTc0MTZCbk5sZmlJMEZ4Ynd1eS9VK1dWNWt3eVlpa2lRWFk5?=
 =?utf-8?B?bkcvelN1N2ZOYWh5VDdDRHNrV1NZRVJyc0FBbnBYOERZdElRTytNbjg4d3BO?=
 =?utf-8?B?VzNFU1BhN1FZMStuVndDbVhIUHlEZkI5Sll4VjNGSTJrb2ZCT1ZtdFVSOEMv?=
 =?utf-8?B?SHhxdHlCWjRHQzhPMW40eGpCVzh5Y2hMSlBhdVRNREtYSTBMVzFuYUc5bzRj?=
 =?utf-8?B?ZDdFQkp2bS9WNlJQL3FVdjFoRDNZbFM5NDFIdmNSYUl3SzU2UW9VcnF4Vm13?=
 =?utf-8?B?cm54K2R2MWNpekozODVHQjBtU2xqVGxFNDFXMUZncDU2ampwUHJTR0tpWXFE?=
 =?utf-8?B?eE1zMWlmblFtWVBvZzVYSjNUck1UY3M0ak9EaGl0NHlnWStUUGZFcW5ESU0w?=
 =?utf-8?B?c1NwUWVheFEva2pIekxLbGMrUmhiV2NwaWJlRUtCZUtRdis1eUg0YmVOQjhS?=
 =?utf-8?B?QzV3cExoREZTcGNFS2FNeVpLRUNOTFYxa3RWYS90TmVPeTJlTEl6QmMyVFVU?=
 =?utf-8?B?MmxkTjJ3dGxJZVNVdk9WUHlrVzVwZ0F0aSt3WVp3Nk02b2oyL0NDU0I0bmkz?=
 =?utf-8?B?ZjdtaWc3Q2c2azFMbUV1dytQV2l2UHprZEFidWRCa2VZckM5TDArbFZKSHRL?=
 =?utf-8?B?TEFtYml3M01IZ0hDbXJ5L1pPR1UxR3luRlNnRWUyOWNYVXdyeUFqK2ZMYWNm?=
 =?utf-8?B?YjJIeG5oQlZtSXQwazF3Z2w4OVNpLzhpL1pKSUtQbWlrU2dEQm03V2pUZGFQ?=
 =?utf-8?B?VjR0K0RVREExNEw4L1NXbTlPZURJTi8wVDQxbkpNRXFGMkFWdzFidEtSNlhL?=
 =?utf-8?B?KzhBaXZ6R0lFai9tV3VYaW5iMk10bStSelc1Ty9MNm1QMHFxd2FNMHFSUEhh?=
 =?utf-8?B?MGtaMGRNcVlGa0xwZmFhOUpuK2Y0MHJlcDVjY2dpNEEzOEpCVlVRUTZMSkht?=
 =?utf-8?Q?zGBwZ7tRs4c=3D?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:15.8005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 435a4c7d-3283-476e-e69c-08dcfd81a028
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB9458

From: Ilpo Järvinen <ij@kernel.org>

AE flag needs to be preserved for AccECN.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_ipv4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 536767723584..a13d6745d92b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2055,7 +2055,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
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

