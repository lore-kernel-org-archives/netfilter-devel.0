Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9074F1F9405;
	Fri, 27 Dec 2024 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326773; cv=fail; b=EMrd20S9xwKWJJvrxVUe4wvNFOFQ2E4vbka0kUrnKdb1aBu5nt7l8ZzEfxdIcL8PoD2NQengt7grepMYhVphiWkUbjvo2wX6NVEm6mv+Tb2/TUT7zfaVna4iOoDAeZ8E95pD/blTcq8Ue4Xb7rHyAfFIZpRpD1r96yhxNbTb5ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326773; c=relaxed/simple;
	bh=mtpprwWOrrtuVp6ibY5rP/eipJJmjic/wQVn+ofJYi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaBkthgNiCiJ8k8uA5fSlOAN965I1mBM5J32fA5O2F3QhAbq/syO3IPkYafnXY+CNI/vsdI7y4NPNbHW98oIYirhHy/kwPzxRIAhHpbMCkMcCEmg25ZwbYlBVvi2xa6VIqgBo/mowR6rOuxVY63JdItQzM9cpdTQz7YS3AwBGjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=EDTNYCDu; arc=fail smtp.client-ip=40.107.22.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="EDTNYCDu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vx40OS1o5qTgdkwLBRVYPLL/X2kM3wLr8fDnOFCel37R022gbW0PpAiapJhJAGkA+52zwA7X45r0YwxKYc7SdEMd8xDZLmsYiM/VbGRklB498x6ojgwnAXm9nb/NzfNKXeHdsDmz/VfRQ68LAXdGtvLri9lj2zaHuPBI44FvIXZZDpcsVn3FgiW9CpowyNXzdlvlVLqqTU3lGxupekjR0hPJOqc8JDuaT+hgCzv2o720O1fJqQapxcnozCxhBsTH5AXXEU5X9jZ8fGh7CSyNmNlHli6fs361Icx7tt/awCKXvaBm8eWWlZAL/EtpZ0kZf+1486ZoNHShuLBQT4ViBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+GA9ZAEJCNCHB7hW5C+kom/iLrrAaNs/Q/YYKoaKyY=;
 b=KWUSGkSx8+ygoeKnGyeH1xb/KzBR9luQ3eGk9KBTlWzKe1GgJIpXF7Cp/oHyso0vS0swmssgVlzQ4F95uvWz/LoRn07X4NyH2m9I+0xHotSMffsBymy3fxJ4CavKpzWwiWQvEiYSrjMshP9xf37SJ788JOnHprARIGIOUQhFELvDOUOy0RcueEBuFUOBTPXR6tDPNHyhIGaK6OoYd0QQ/gSdRpvLgy4G6hwTkNHLfj+w2hj/tvWUlGRNN/uPv5oJ41eTwP+sm5/aXpoUieG1DXXZcwsS1QmsJhhWs74UT3VGKhUXvirKCRpvBJDxLOBhGPjYiRjdCgicA/57e7ftUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+GA9ZAEJCNCHB7hW5C+kom/iLrrAaNs/Q/YYKoaKyY=;
 b=EDTNYCDujKn/h89uwRhQFvWlZhvKYKlU3tBSFYzv8T/Msr4ZogYaiWlHJUnMIMO7VAMlBYoUUVmnkiJ8g0v758IerHLTJPU3rp5G+tUXlJkVbypHFr+iVX7Ymd5biVLwmN99VMzR2xdrU2pyzJdFgB12d4NZt4IF8NRINh5KrNnjUeQlAYTNFDK4M+gq0FGuaG8F3EKkLgPE5ezdla5UH6+sxIQJEM3OFB+cDpIbgHoBLDwkqGAf60IKSGrkU7rIqUDRS+nOhnNlfYvwU0eQOHdS9aWzKCgARE+3lIt4qDeVbOOjK15tisDMNvjrV+BbS7Q8warRHoxl4Nbio16a5Q==
Received: from PR3P250CA0004.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::9) by
 AM7PR07MB6391.eurprd07.prod.outlook.com (2603:10a6:20b:13e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 19:12:44 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:102:57:cafe::94) by PR3P250CA0004.outlook.office365.com
 (2603:10a6:102:57::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:43 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2V011940;
	Fri, 27 Dec 2024 19:12:44 GMT
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
Subject: [PATCH v6 net-next 05/14] tcp: reorganize SYN ECN code
Date: Fri, 27 Dec 2024 20:12:02 +0100
Message-Id: <20241227191211.12485-6-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM4PEPF00027A5D:EE_|AM7PR07MB6391:EE_
X-MS-Office365-Filtering-Correlation-Id: 96e0d846-dfc7-436b-80c8-08dd26aa7113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjhCTENFK3RVUUFyYktDeTZNU0tVYVR3WmhKcWpncTBNeWlPR21uUHJDbDVT?=
 =?utf-8?B?NFR1UEFjbUk4enpibzNuZWFwU05wV29idEMrZ1M0alF4ODZJakhMbjJWQjlq?=
 =?utf-8?B?bjZDVlZFVHpMMmhvLzNrdkhDaWJGQlE0RWU4a1ZaS0Y3TzFWa1U0RVgwYy9H?=
 =?utf-8?B?clpWcGkvVUlCbXdXV01OL0twR1ExaHNmRVRQd05pckpXUkV4bVViUm1DNC9I?=
 =?utf-8?B?YnJrcDh2N05IcmdLaDRLL0x3QTBFcGJ5blpZS3Q0dVFjaitkOVowZW5tRXlp?=
 =?utf-8?B?bVlmY0trb20rZzREWC9vOVJmY2k0TjROVjhmUmxvZEhHeENsNnVsZGppdXp4?=
 =?utf-8?B?SXhaSzY2V0hnaEFuV0c0QmJGdGtqclc2V3J6bW1SK2hGdXlrV0I2MEVzVEJs?=
 =?utf-8?B?Y1Q1Q3o2VGFkLzVrbGltWjNjSWQ3RFdtSHBjblVQSzRKWGI4UFBYMENGckFu?=
 =?utf-8?B?TW5BT0xIUjBxSzRJblNXNG9MVlRYUEtzbFlGWmNqSnJtc2NlWjlkTWFvaDlN?=
 =?utf-8?B?bVhVZHJLTy9wR3orQ0lWbVUwQ2VYeG1HcG8vdDlOSVFRTFJNVzRiRVQxajJQ?=
 =?utf-8?B?dW42MUNmL3F3djlOWnBvdkt6cUpGTjZ1V2pqd1grbjRoa05ocjY3QThHaUx4?=
 =?utf-8?B?WEdVb2dOMzMwWi9sS214WXhkS3lTSlNrODUrMWNQTmNrbDZsVHZLUDVzVmU4?=
 =?utf-8?B?TWY2d0dIMnc0NnZydi9kanVQcnJMSW0rc3lGSUdkNEFiTFo5dE0zampVcERY?=
 =?utf-8?B?SUV0K0dVdVVEYkxBajZsL25jcjFTVm83V015M3VFdUFkaWMzcUlLbVZKc1FF?=
 =?utf-8?B?ckxGN01QVElUb2ZEczhMKzZrMWNTZDBid0w4c2tHZHROQ1ZQQmNpc0I5Tmx2?=
 =?utf-8?B?eHNZWktSQTZ6elpVT1hmOENwNUFZN0ZEOWl1cjdGZlpBL1lWNlBiYWJhM0pq?=
 =?utf-8?B?S2xhT1VRdlh6dnllMHIyZUtacUcxajlLMDZXU0lMQlpZUUV4cVRURkdOeGRk?=
 =?utf-8?B?WFFjanZUbFZkMVoxdEE0YXFaMC9TeURhMUhFaGh3MGNhb0RZbnk0MGpXRm1Y?=
 =?utf-8?B?V0J4ZXIwUFpYTHFodFY1S0tVTG1nZVU2b2VvQnN5T1BzUkdvN3pQTGs3aGJz?=
 =?utf-8?B?aWZiV3FjR2ErTFBUNDZqS3NPWGpCTWplSW5TN3NpU0tnbmdpZEtrbjNGdlJS?=
 =?utf-8?B?SUZyK0lmcWVYSTlSREFhUGFKVHQrUkxFN1g2VUpsbkFFa3lLSU54NjVIdEkx?=
 =?utf-8?B?bEtaOUwzM2Evc0VqcTZhamRaZkJmVW9jSElibUtxU3Q3cWdyR1dZOG1KSUtO?=
 =?utf-8?B?NExHM3ozWE03VDFCdWVLc2RTUkcwUVQrcmEwR01jOTgramJXV0FIUkxCTm40?=
 =?utf-8?B?N3VUUG0veXRoSWZLRVM1T3ZEMnRIVWRRK2ovWXkwZHNlUFFUeFgwUXdGeStS?=
 =?utf-8?B?YXNOaittMG9DcEYyb2FiOTBnSnNkcFViL24wdTJ0a2FMekEweEF3L2tsclk3?=
 =?utf-8?B?T3dKcyt5UUQ1MmxLZE40M0JMS3NWaVU0OERFYVNOaGhPUVpxQUtLaUNzNE5W?=
 =?utf-8?B?emZNVHdDcitxWm1TSHhHNTFpVEFyOHQ1QWx5cWV2Vm0rWWxJNEpXQnBlOUIv?=
 =?utf-8?B?eEVxUDVIZzFCUlhsNlJYTTVsUGsxYStIZDdqTzdnd1IzMElIMjRMTzQ5am5p?=
 =?utf-8?B?VU14ZitBaklxcGhEUzBmL3NTV0dFa0FQTko5UGQyTE56Y0puczU4S2h6MXV3?=
 =?utf-8?B?ZDZPZGJ1STdZeTVnN3NpV2FyWGZjTXBXZnc3WVJ3ZkxqVWRwMm90SHN5dVpP?=
 =?utf-8?B?cmVCS1Q2bXhzc0hrZGZtWHlsaVZFSDd6ZnRROUNTUE5NQTJLK2laOHNoZzFu?=
 =?utf-8?B?WVZNOThUcWQ2ZmNob1k0YlFMeHpYYVFCNjdFTlh3TVdwYkZPcVJJbkhpRDZs?=
 =?utf-8?B?QUsvc1g5aktGcUZpRk5DdEQzalNqa2F4amlNcng3WEpTUnROU0tkUlhPMnZ0?=
 =?utf-8?B?ZzgxMm1FQzV6MGVneXhGUC8yaERWTXBRakxYS0lCT2FJTUJRd2twcHorbnd6?=
 =?utf-8?Q?4zhB8P?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:43.8627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e0d846-dfc7-436b-80c8-08dd26aa7113
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6391

From: Ilpo Järvinen <ij@kernel.org>

Prepare for AccECN that needs to have access here on IP ECN
field value which is only available after INET_ECN_xmit().

No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 33e73cefcdbc..fde40ffc32ff 100644
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

