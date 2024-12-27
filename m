Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2081.outbound.protection.outlook.com [40.107.105.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331B71F9A8A;
	Fri, 27 Dec 2024 19:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326779; cv=fail; b=lw3ZlGifdU7L7XLzDe4vLwboEwD1iTYu0iMUsUq+N8zAKFN1PN0qNqiPP2wYu8hqzjiUhwAMhqmzv0EL3Z7TG+1TR1hEiSUCL1axgQZokob6wUQUZU9BFU3jMS3uXyesTnjzLTaGPXVOyJliIO9si+soSm53mMZ8e/LaLZdBqZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326779; c=relaxed/simple;
	bh=4j5SJ5HYuPel2Dv+IBBWRsO/17dTAoza3QBOY2Scc+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2fxChsbL9fIjELNUnWe+pbWkqzQ83DmAXekHvommQqoao4Vm8hCW7NmGhuboYAErlrMNIS1CEA6vgwfu8rouCQJGdIVYZie3uGACwikZhYSwwXlKkXpXCr1jpl3jdwcUH5hs178TR2TN5jc6740cvo9arEf4eLZiDs/14qXXKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=tZx0VqIk; arc=fail smtp.client-ip=40.107.105.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="tZx0VqIk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QZdeHPC7UaTWg122T1Y98/6oqzYtsL3++oygdMWY95VJQWMdkQ9pnfYHxM9PcCIQ+oOjTJWWmjQfVagnykpuCITGFHHeF9Y9ofB7c3/GpoOgCCVJ5gUjDNHtqplZRx1vcJdoT3SF7FEwERxuvqAwyFDoFXhKpf8LnLiEM2utGWvrgyNcgFoqnEIsXPG35GEnvuFPv8xVBh1BLY3sXQ6Ro7JHgtwY7t1MziL4dwXXMOcM0bK5PwnYI6Qdi8A9diaTh0eFDhJVCZyt/J03s1J/C7fUDA7AVVdaDkOvSWk5IysdkB/rM+/yzHw3G2CP0haWIqwpoeEuzJgS7BeKVPKHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSA7eqx5WtqjVvMOGIZmeD65xQRrVJgg0ZR6KM5OeDg=;
 b=InpEBXnVAhDcx84F9UknpgHC6TBGoRoCqNIeq0uUfW7cz/zk4XMBx4MMFrbLr6EgV3x7XhMLi5jn+WCXjRMEgqWfoOgsoMpnMzu8gSqZ8FPx3IqmvrzX4AU4YdrU5mNMFCDVLauD6ED28p7oKKiuinQt0TxaX9ccA8AL4byuVY/s1iMnPhEq/Ptcyk0C4Qx0uhK8EpnelDtGCyB5buFaPiJGmvUApRYOO1vQHfEZvtMOZosO+6SPMHhGKrVdZxk6QkEigPRLwPv0qD21LpyESm2PDIU808aQi7ICx/Dh0CkFERuY+00kZPArDjRa2kFethVtjX+XLR5PqD48rzH7Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSA7eqx5WtqjVvMOGIZmeD65xQRrVJgg0ZR6KM5OeDg=;
 b=tZx0VqIkqcI7lafapn9eDI7CjyeBR22AinzznHlzolzh+7u6MEGGa8RxGufyn6qinUGhJtJVbCltfAN+9wBq5kPf2sXxAGCrvj3afROFVeEQ9VHi4mpu8pSBrZstqD+Z11L7amChpOc6dWxtM4gJPrCaiPY55fpHnx41TMLvFynMafJng0HiCZIf1E4Sz5lIbA7hirvkZ9rslZXeLlCiJSyOkkL7jSed7GbzQbqCaAoxPkAEAMSWqH8bYDAkrbYwomWTlsCcJb6lXkPVtUEEyqz95GdpFrYd2DaFrBEXoIgW1yt9P50PyVCkb+DjHm0rag2iduS+ZVSFGAW+gXap2A==
Received: from DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13)
 by PAWPR07MB9369.eurprd07.prod.outlook.com (2603:10a6:102:2e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 19:12:50 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::61) by DU2PR04CA0278.outlook.office365.com
 (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:50 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2Z011940;
	Fri, 27 Dec 2024 19:12:50 GMT
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
Subject: [PATCH v6 net-next 09/14] gro: prevent ACE field corruption & better AccECN handling
Date: Fri, 27 Dec 2024 20:12:06 +0100
Message-Id: <20241227191211.12485-10-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DB5PEPF00014B90:EE_|PAWPR07MB9369:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c83a26-03c2-45b8-3f69-08dd26aa7519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHYyL3dKMklFYmxWSS85elJzbHJwdGtxTmc2VmFNLzRQTktwRHlxSGNuc2NL?=
 =?utf-8?B?OStwY05Qci82NmlKMUhNelpFZGIvalJOYlBya0VTZ2NnOHpGRnYycjdwTG4w?=
 =?utf-8?B?dU9DamRsMVdjTTJGSW8yeXJDNWFvUjZxZFU5Sk42dnQ2c0VPK1dFRzY3cGcw?=
 =?utf-8?B?YVRrVDU2Z0cyaFJObG9GWDRJdVhocjZvM1kzVURRdXRLcU9Zbzg4NmNjcTdO?=
 =?utf-8?B?NjdyYjIycDFiZWpuejJUcXdEcEZ1WWtIL2NxbU03aGJKMG0yTy9CSEwzbkJL?=
 =?utf-8?B?dzAzUGRleHdvM3VUaFZpT3NKbmtHVzd3eTY1WmpDN2d1aUpFZjVJb1Y4b3ZD?=
 =?utf-8?B?WUIxOVBiSm9pZndkTll4ZmhPc2d6NzdLV0o1U0RLZTFEWG9qN05RQTBuYWdG?=
 =?utf-8?B?aG9sVXc5WFNvSkVuNmJDTEIzRVJ6aDNhTEh2eWVzM1BGdzYrUDdwd2NxYnpw?=
 =?utf-8?B?b2daOWxJWU9ob3dZajdsUk92c3lRTldkcU1mMkRsclBtS2krNWdFbEFPa2x1?=
 =?utf-8?B?SmtibVpQU3cvbElUY2ZJVVE3SGFTZm1ueWU4ckRuL1ZNdWhUZmZzcHl4WGNt?=
 =?utf-8?B?dWZQZnE2L2lVZzBTQ2luakw5dG4zUUIvVUpaZjR2WXFoaE9meVRYZ21kcXpG?=
 =?utf-8?B?N3NLRGlXSnl6bWNoR0hGMVRROHJWNlplQVhrclZHUW4vZkJUNTBPL21abEpu?=
 =?utf-8?B?L25OZTdaYytRRXd0QWxWOGsrMTk4M0oxdDJPS2tHNlo5RGJWMXFhdC9wSEZM?=
 =?utf-8?B?QkRzNUJvbDZUYUg3cmdTenpFL1NBditBQk5scTdlRlVNY3pLeGQrWS8weS8w?=
 =?utf-8?B?eXZGMGFRY2RvZHVyZGY1blpXV05sSU85WnlURERhaFQ1UEJCNy9KZ1N6Szhl?=
 =?utf-8?B?SURLakJ2ZzZOblpjVkg4bStheFFUejRhUFZtM28wNW9nWmhUNFVkQlFhQU5Y?=
 =?utf-8?B?ODRuWEdtWVVSSE4zaC9CNE9WQXBOWGFJT3VFQzN3UCtSN2R6MDkrdmZiZW1h?=
 =?utf-8?B?OXVJTUtTWE5mWFd1NzBId3VhRzFKWkhxcXhkODk5S3RsaUlOUmo3MmxPcE9Y?=
 =?utf-8?B?RlpHQjgzTk5zcU1PcVNiK0VhMjNaMjFSTmhkR3p2K0h0eFZ5cTBsN09BSkZw?=
 =?utf-8?B?c1pNY0V3ZmZGUlh4dG1lQTRoQkJyOEQzb2s3OElIdXNyZE0wdWdOZlNxLy91?=
 =?utf-8?B?YThZN1BoQVg0N0xUYjhGTkkwU3dxY2w0VWw5ZEswbUs5cTcxS2l6a21iNlp0?=
 =?utf-8?B?SFJPZTFjRzNWY3dvRHZERjJYaTgxKzQvcnFram9MWU4raWZTdVNQOU1YWmU4?=
 =?utf-8?B?VTBaRG83ZlhwaG5ldk9Qdmo0NlNMQ0hWa3QxSCtuZ1Fta2N3Z1VmUlY4V3l0?=
 =?utf-8?B?NGttQVk0eWxXL2E0ZitDc0NxR3F4eXA1ei9GMmlVRXFxVkE2V0VOYzdkQ1dm?=
 =?utf-8?B?Vm1VK0xlY0pkd1NPQkxCVWZ2OVczTDVSVmFObVV4T2lpR0hYL2lzOUxMWFZS?=
 =?utf-8?B?cEJydTdXMERpYVVNMzhuM0xQbWh1eXNrQU53c2RSVzNwNFFPR0VsMDZzWFYy?=
 =?utf-8?B?MlVKaHNkeDJwWUUzM2lBd3Uvc2ZsbGxhUzRNS2R5eU0rYkt5ZXdhNjlGVmx1?=
 =?utf-8?B?aGVtcU1iSUp0Z09yVGF3b0doV0RCQ0U1a1N5a3NNS0NwQURxR2RCcGp4V3Vs?=
 =?utf-8?B?a3BISDk4VVg3Ni9jRHdmRVpCWmhCR1hZbENrQWlyQ3hUZnlibFpuRzVsVnR2?=
 =?utf-8?B?NXZHTWVjV2pyczJzMmdKVUprWXE0Q253UnJhSWJNUEFmRnV1QXhFdDE0bjQy?=
 =?utf-8?B?WFU2NmJ6UE8wOFZEcGNweXZtYTRob2RVdC9FZy9kMVVCeHV5WlM2ZUNWU3k4?=
 =?utf-8?B?QkVySTZlTHBXNmMrU0lyUEtxZUNTTEdMcXdmUHlCMkZNQVJwUFBhR0taeE5S?=
 =?utf-8?B?WU91aS9jY253cEY0cFhaRW00dnpieHNUUlcwMThMMjJSeTVvMG5FUXZ5dzBZ?=
 =?utf-8?B?UGRvaCtxR0hOeTZROURFQUVxREdIUFpHTThmUWdHUFhCM0F6Qm1NR3d0bHkz?=
 =?utf-8?Q?I834RU?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:50.5956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c83a26-03c2-45b8-3f69-08dd26aa7519
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR07MB9369

From: Ilpo Järvinen <ij@kernel.org>

There are important differences in how the CWR field behaves
in RFC3168 and AccECN. With AccECN, CWR flag is part of the
ACE counter and its changes are important so adjust the flags
changed mask accordingly.

Also, if CWR is there, set the Accurate ECN GSO flag to avoid
corrupting CWR flag somewhere.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 net/ipv4/tcp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 0b05f30e9e5f..f59762d88c38 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	th2 = tcp_hdr(p);
 	flush = (__force int)(flags & TCP_FLAG_CWR);
 	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
-		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
+		  ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
 	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
 	for (i = sizeof(*th); i < thlen; i += 4)
 		flush |= *(u32 *)((u8 *)th + i) ^
@@ -405,7 +405,7 @@ void tcp_gro_complete(struct sk_buff *skb)
 	shinfo->gso_segs = NAPI_GRO_CB(skb)->count;
 
 	if (th->cwr)
-		shinfo->gso_type |= SKB_GSO_TCP_ECN;
+		shinfo->gso_type |= SKB_GSO_TCP_ACCECN;
 }
 EXPORT_SYMBOL(tcp_gro_complete);
 
-- 
2.34.1

