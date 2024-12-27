Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2061.outbound.protection.outlook.com [40.107.247.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6911F8AF0;
	Fri, 27 Dec 2024 19:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326776; cv=fail; b=QV16X8gf0w5uFDpgL/DucXK94TjHJDZOOYfxaQY6Msm5bU72ISunUEhpBw/EMurtXYBpbC7zld3ZQpRPwdOAnAzrga2O0t2u697rCuqxQ8UU7lbD1h3JG2DtCa4dEfdErs5pMPRJ6sRR2FabFm00VMWx+QaeMpKiHHLE0QsUDjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326776; c=relaxed/simple;
	bh=UEW0ed4J2/qSG3G1YZN9et+ZmquoEkvZs57N8NehlbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=klmDSxENFv9ZGZkCgRjITe6+/pvWv04mfV5eLkMfIh3BFXpMyuqaZT7y6Gh0xf01W2C/SVT9f4ah9RTnLhjyjs+jkoR+N7HnoDd3TOciHjzTt16Am3U5hsgEgF1B82GkfxsX99KZPD7QJI9S52lMuL06kzC1QOv5cuNSBm0rhcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=SuQ0LyzL; arc=fail smtp.client-ip=40.107.247.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="SuQ0LyzL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ybccg2EaQkqF2As+me96WoUUXzSBZqwmQ8AZinItzDQ8qza8vv3/dgQJjhUd6/q0CHgzVb+oiWiG2LXfauwBNjVZP0xrZqGiMXD7QrSr4z8Gn9SE1Ww9jJSMtfkSUhb8cJiuDTrRuKQfMwTCg24d4nx2Ng7Gv46aMIr7bB1A9luHj2A65YWxDSv+bwyPTiiV/eUKwieKcVjB9CA+x6Sz20O1dKpYsuu0YAnIgRTyTYJEig6WLIgTI5KsQwkdx2PrJ995NRBy+GrMJ6XTc4vdTTCjwj41HB28TT//eSP946bbEDLg9fUloEK73ADFRtrklL7jai/9nBQ0cGwgGoPz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1PFN8qO9zvJ0vyV4Mr9uN8oxSmktBTjV8wyvOKiPVw=;
 b=pevuB/c15eMl/hr6yHeg9IaIYBLRwvSLd83um5EJHtZW+adbW7l9iRrAFnZMbWdTRNqGT6K36nkAVqN562KbPH50sqs6PocIYtfj7VyusZxm2DLisDMgs+V523O00W3H+tphWKBaZrI6NrDwGdGbf4fKIYKqVbJHSe3oU+VGVvdJQDVeLmGKG2EE8ucyRxdb0dhlF+/cw7nWmx9M9JkpT2OJsACAnxc1UnufgHdtKzXBs6VgIImuKLL0j39ckuEUcNlGywgH0eWSmhG3Q7LYPoUJWpxmIg+DfphBPC+YW8Hf9qI2bHBfO8onAnSb4/AbHsbqcabPPyqZdubxkOjUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=temperror action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1PFN8qO9zvJ0vyV4Mr9uN8oxSmktBTjV8wyvOKiPVw=;
 b=SuQ0LyzLlqHpBr6Hvbp+nNngYCoZqCIX/4KiBWBWbfayBlCT0V7BTkNjouqpCN31dHW5S7UwVhgAo34bTNY9OnxZOb42WPoArUfY+PCVjjK+m2cOBbDqOqgQBcFLzq3SkYLlZDH8q1Xe6BzybRGlB6Jv9RaYLZptH3vMIb/lloWUmshUAAjzm2aY9u+FMID+HB655vNVlmo0pAoW160PrOmf+Fg7S7nvfdV6mNgBBv+D4jLP/BJDWhAlHvh2IPaCobRwzH7S/BX5fEbAcMmdnKn8at9bx4rEpQGeRjiTR/nJJn7crFbSs/4a2A42k3uPEG3Z5cd9I7DKCqQZqzsRYg==
Received: from AM9P193CA0013.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::18)
 by VI1PR07MB6720.eurprd07.prod.outlook.com (2603:10a6:800:179::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 19:12:47 +0000
Received: from AM4PEPF00027A5F.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::f2) by AM9P193CA0013.outlook.office365.com
 (2603:10a6:20b:21e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:47 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 131.228.6.100) smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not
 signed) header.d=none;dmarc=temperror action=none
 header.from=nokia-bell-labs.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nokia-bell-labs.com: DNS Timeout)
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AM4PEPF00027A5F.mail.protection.outlook.com (10.167.16.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:45 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2W011940;
	Fri, 27 Dec 2024 19:12:45 GMT
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
Subject: [PATCH v6 net-next 06/14] tcp: rework {__,}tcp_ecn_check_ce() -> tcp_data_ecn_check()
Date: Fri, 27 Dec 2024 20:12:03 +0100
Message-Id: <20241227191211.12485-7-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM4PEPF00027A5F:EE_|VI1PR07MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4863fa-7477-44c7-fa25-08dd26aa720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3M0RDVscUtKZVhGeFY5UkdjZU16TDkrdExqY0M3cktFT2kzQ3BXRVo5cDNx?=
 =?utf-8?B?U1g4d3hNSHV2akp3ejJSdndBTXlNNHBWVVUyekY0dVgrUTFVc0RDczhGRlc1?=
 =?utf-8?B?dEg1SGFranZkRGVYckQvcDdIVDdkZjlLREZ4dUY1bVhMdTZQeDBOVGRRMklN?=
 =?utf-8?B?Q2hteFc2L0IwZ0NiN25KQ1c5a2pERi95K013R2xrZFNLZGU5blhXL3JGS3lk?=
 =?utf-8?B?YjJKem10cFl0a3J1RmMyMjlQMUZvZksyaUl0QmFqVmZWN3ZZUVd1c2dTUFNC?=
 =?utf-8?B?ekt6akxLU01pSzJCemdhK2ZBYUp5bHZ0SFBQTGxEd2FnVGtTSHFCRU9VakZM?=
 =?utf-8?B?b2NkN1U0aHZDbzJGR1N0OTd0SlBMODVnS01CQkZFVFB2V1FjMnNBT1EvcWNs?=
 =?utf-8?B?MWFBMytqLzdzQnRPN01hSE1oQUhCbWk4UUY2WnhHMHJpSmVQVlMxaDJaVFZU?=
 =?utf-8?B?b2hhUFFCaXJkaS9qNjJlMnNoRTZNeVRYci81V2RGN3loejd2NEVnd0NrcUtX?=
 =?utf-8?B?OUgyZ2Y4dkxZL3pKQ1NJdE9MdUViYjh3Q3dlVzdIQnJlZFozOHcza1B2RVFu?=
 =?utf-8?B?MXN2ekZWS0xyNGtCSGcxMGtiVnJGUC9KMU5xbVo0WmxVL2p4ZGt1S1QxT2xY?=
 =?utf-8?B?eER5Z0QyWUVWNWtPNXNGVmFVYUhDUldlUnJDdzlzU3FQSTYrQjlaVm85MFYy?=
 =?utf-8?B?U2dVNXE2WHQrL2dIdUFFNzBQdWJJWmczTmk2S0lzc2V1UURpczJrbWJINlBx?=
 =?utf-8?B?emtNaVBsbzRCdGxpdmtxNW1RSnpFaFBSR3MrOS8zTlN0VUtGREVySlFGcTlV?=
 =?utf-8?B?bnRVUTN2bW94RHlmV2NsQTJ1NW1RdDZmbFY2ZHJNbjREVzEzVkhMS2o3NCtQ?=
 =?utf-8?B?cXBZR2ozcFlDRm9laTBqalBySzBLbmtXcHdRTjh1Skp3LzY1bVl6T1haMG4v?=
 =?utf-8?B?Y1ZVNC9TeHBOUzZsTGkvYjQ3V3ZqUTVYYi9kOFdSTXFlbVV5TDk3RG5Sd0RR?=
 =?utf-8?B?MEIvVkN4MnJoSFhGR1RzNU1JN3hWL3BnL3FxUGdmQ1FDOUNWYVhlVmg0cWtY?=
 =?utf-8?B?Q0dPcFc2WGhkK1lkY0hHaFBwSldrd1Npa0lmcGVjODlJa1Q5ODRWcjNEK0VP?=
 =?utf-8?B?aGV1T3hmZE9pVHQvZVluSGUyczR0OGp0T1J0c2xYbVpleDNXMEpPVmxVbWRi?=
 =?utf-8?B?NFpDSFMrNW9PaFhyYXcvVGFqVHE2anQrUDdvRFQ4OUMySmcwNGx0TGhFaytD?=
 =?utf-8?B?SGdFQ3JZbEhyK04yNU9Qblh2cFZsTW1mY2JENExTbk14amhoYVJxU2NCLzJI?=
 =?utf-8?B?RFJnMm40ZklSaldtODZLVk1qeCtOYk5qUHBaZ3haK0xsN0R5OTI0VElPS1I1?=
 =?utf-8?B?VXRTZGN3R2hodnV4aWZ5L1llMnoyZGM1cHhidnJsSUQzY3oyWGozcFNMZXhw?=
 =?utf-8?B?bkEzYVRTSk1YN1JmL0FrTk85WDFMM2xidGF2UVA2RG5jZGF6RW5sdGFSelR5?=
 =?utf-8?B?VmpkeHh2UnA4dndnNVBlU2xQL01oM2RQUHRIYkVOOFhHT1RMM0dFUDZ4RnZL?=
 =?utf-8?B?ZzFSMnQxRFFRV1pwUmEwd3NNdXc3T3NCWjZCM08vNEluekQ2SGUxaTBUYXY1?=
 =?utf-8?B?UnF3TStKbFdKS2F5akJUem5mOEkzUnI0VldaY3BsQkZpSE9US3M5Y0NNejNB?=
 =?utf-8?B?YkhJUUVTMDl2YjdNTDlKVEhBZERIM1cxUkh1aXlETkxoTmZkS2F2b0N5aVZB?=
 =?utf-8?B?eTZKMkd1dUNubjZTQ0pXam0vWnBrU21FeElGeDZiTWZLdVU3c0l1UG9MUU1i?=
 =?utf-8?B?ekhqRnF3bXZBZFRod0J6OGVFOU8xMnpVRDVQdmNZZGQvUUxEZEZYUnZORW9I?=
 =?utf-8?B?emE5ODVVZ0ZyTStyT3BqUmRWbm9jNFIzZzNRMkhjWnBDYmZSOU82bkY3Z2My?=
 =?utf-8?B?bHdNdmIvYVNXbVkvZ2FkOE9HQnZBN2d2a1BIQklMN1RTVTYxSTNhVHlhWnVK?=
 =?utf-8?B?UU9zUklscGZndm04aW5LalJNRUFpaXBmMzNLaXFGb2RlSVVXSGpLMXFaL29L?=
 =?utf-8?Q?qhw3Iu?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:45.5330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4863fa-7477-44c7-fa25-08dd26aa720f
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6720

From: Ilpo Järvinen <ij@kernel.org>

Rename tcp_ecn_check_ce to tcp_data_ecn_check as it is
called only for data segments, not for ACKs (with AccECN,
also ACKs may get ECN bits).

The extra "layer" in tcp_ecn_check_ce() function just
checks for ECN being enabled, that can be moved into
tcp_ecn_field_check rather than having the __ variant.

No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eebe3a99aa90..4751f55a79ad 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -357,10 +357,13 @@ static void tcp_ecn_withdraw_cwr(struct tcp_sock *tp)
 	tp->ecn_flags &= ~TCP_ECN_QUEUE_CWR;
 }
 
-static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
+static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	if (!(tcp_sk(sk)->ecn_flags & TCP_ECN_OK))
+		return;
+
 	switch (TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK) {
 	case INET_ECN_NOT_ECT:
 		/* Funny extension: if ECT is not set on a segment,
@@ -389,12 +392,6 @@ static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
-static void tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
-{
-	if (tcp_sk(sk)->ecn_flags & TCP_ECN_OK)
-		__tcp_ecn_check_ce(sk, skb);
-}
-
 static void tcp_ecn_rcv_synack(struct tcp_sock *tp, const struct tcphdr *th)
 {
 	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || th->cwr))
@@ -866,7 +863,7 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 	icsk->icsk_ack.lrcvtime = now;
 	tcp_save_lrcv_flowlabel(sk, skb);
 
-	tcp_ecn_check_ce(sk, skb);
+	tcp_data_ecn_check(sk, skb);
 
 	if (skb->len >= 128)
 		tcp_grow_window(sk, skb, true);
@@ -5028,7 +5025,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	bool fragstolen;
 
 	tcp_save_lrcv_flowlabel(sk, skb);
-	tcp_ecn_check_ce(sk, skb);
+	tcp_data_ecn_check(sk, skb);
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
-- 
2.34.1

