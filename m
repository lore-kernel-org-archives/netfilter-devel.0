Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343F1940A2
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727084859; cv=fail; b=hGxzuu8v5816taatqUQPjH9LlcSC6G4UqwN7PnOQYbEVWhwnIpxaIXtqK1kifQ+sNP2MjU8stxFQhCPrg6htX4ISAGyd+uW0iSH7OIAihNL/pAoabyQ5i6cW0SmgPbOzmyoBe/TnRBGhKG/mzE2j+s1UIsGft/o5dQtqHNhyoK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727084859; c=relaxed/simple;
	bh=pHW6Z9FuRf/gWv8mF3E5Y1XE74Q0KfN/7zUAbdZLG3Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:Content-Type; b=t4YtCfsp8mPuFJnlYkyqPqFiZ0Hb4bX2pnAk054c4vvKN+u1DpQBGgKB4irnerGJNbAKCcDfRqEL7ujsXniuuiIBQcFYzpzSqtqv4En+Df9ilNmd1MWC6uX5IEd6920ALm5yJNwZ8VwTlyAjghYf43lrr9jiAguLG19ORsJYOcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O0XzC3Rm; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O0XzC3Rm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtZCYUS8pJEwkQECCRWBxmaJdA8xrjVlLFmzkj7siPMtx1haVP0PwwzD2tV0ckpJuMG/zlgQ/OiEbanZlgi6K0HdtBbAXV/MWQUm7uQ1OoS1fxtd9LqWlf0LBYgQxGjiKSuZvTbUZB7V502lWgnPDcgCdtQcq12DowryXJoSz0vVrRg2spnD6HyS/dlrmZ/UpUIBcU/F3gGOgzg5i30h1R8AsZjMKWs8cKYjLR3z/Q7GHJslSazZFNvGh2IKnrTHfvknp38ILLLq9/Fta0p1PIrMu/8uJluSaB3MEqqeJoWkdAr0xdyDAKy7gSuw6/N5A5JgvcBksH/pPwK8sxbQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puNCtD+TLU+i1G5aw5ReVJpUZcHHgRmfUN7veI9hgM0=;
 b=oJhbF3RhKomVpwZOcIch4iuMlg7VHC+H47XbLzkVSSbTKeQiECE0FiQ8TUQdDry0DtbR/OMoPPBvd2lm6NI37rYGNJpt0lwKwhIOVUn9cU0XkWjGKsKs/gopnhri6JqlHzneGYQRs09VNx05j21RDvwO4iJJrpqF/BT9yL3aZgaKZNpWQNW9Ql21YZ/ji36dZf9q9GDmhsnmeaEZHpir7aXpB6prmnxgSzqya7pshEDAGUa+uZJ/vDYAEQvkI7u1E4WHu63IMhpoNGI8yp7zZVF34HCt7psifxkmL0N9gLfrzq1/VlSB1l15D0cdHLP/u3SG9adJBLszPbVQaQc1rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puNCtD+TLU+i1G5aw5ReVJpUZcHHgRmfUN7veI9hgM0=;
 b=O0XzC3RmoA4sYIqR0yqHVHrRchei2v/+JZ+lsQxY0pbqiLVrQ/GdfY8WWVC2e+IXX/y/L1XBEguxGu7QWnvXtH+zK12+y43/DvvwjP2zENQu3JEH+LNe1txPR3FRhXVPcl5U0NSXQz2ayBAHIFsf4ARhMavSlYI3j365U9FBh2xGf97Hg/jvoOJ8qob7CoBmQIrx4gBxQex2HpMCE5C7+lAGsSPbNrhmlvo11PuqOMyhozWKGncoH6FtaR50Cf2ZvTvrXMQLEyD3KdP5NL2WkVVtyxZxHOy5t0kT6Qys188yG8USemMcr23WE39MeAbGML1pNl+dWeKtdd3ZfM4ehg==
Received: from CH0PR03CA0328.namprd03.prod.outlook.com (2603:10b6:610:118::14)
 by CYYPR12MB8891.namprd12.prod.outlook.com (2603:10b6:930:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 09:47:34 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::14) by CH0PR03CA0328.outlook.office365.com
 (2603:10b6:610:118::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Mon, 23 Sep 2024 09:47:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Mon, 23 Sep 2024 09:47:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 02:47:23 -0700
Received: from [10.19.211.37] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 02:47:21 -0700
Message-ID: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
Date: Mon, 23 Sep 2024 17:47:19 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Chris Mi <cmi@nvidia.com>
Subject: ct hardware offload ignores RST packet
To: Pablo Neira Ayuso <pablo@netfilter.org>, Ali Abdallah <aabdallah@suse.de>
CC: <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|CYYPR12MB8891:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb1d444-095a-4e51-64d1-08dcdbb4bfc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2pJRXpqbUpBWFhTMDl6bHJhUURIMkpWY0RsNStsaFBkcEN6cjFIQlk2RnU3?=
 =?utf-8?B?Nm91VkVEUm5xUXc2b2ZhVEoyaGI3b2dPSlFQb0E3dyttTFViK3ZEdXVXdlFa?=
 =?utf-8?B?T1Z0TWI0aGZ5RUtUNUVaMVRZNW1JZkx2VDVCaWE1bEVHaVpxUmx5UTJ4dmVH?=
 =?utf-8?B?a0plMjRGWERYUlNPazIwaURkb0lJb0NJWVVFRUg5L1hFVUllbjdZUHBLdTRT?=
 =?utf-8?B?L04rTW5rZ2pZai9uaXZmMFJORnVuRlFoUFF0ZG1RWi9iMFQycnFrNzVkSmV6?=
 =?utf-8?B?RFdmd29IRHFyTElnbWw1Y3lVWUt3NitvNHVvdjhySXV1dFZiMHRTTHRrZkRt?=
 =?utf-8?B?N3puRTZZVDgyNlRXOHpqVkpiRlFjVmErMURRWG14aERUV2YzbE9jaEhFeHNI?=
 =?utf-8?B?ZU55eGE1VDRpenFLNndpVjFmYnYyVHNxQVFmN0MwOVVyL2FmbjZIK01RdC9D?=
 =?utf-8?B?emVacWR3NFZxMzRpKzZyMC82V1hmeGx1Z3FkdWxqcGR3aDFzRnV2VU5LK0dY?=
 =?utf-8?B?ZkJpczNBd3plUnhIRENWa1ZidEVOK3N4NkVMOXhwQWRrWHFUWDEyWHFuSUx2?=
 =?utf-8?B?eFlVSjR0clJuaVF0bTJlOUtPNnJlVll4NnBXQlB4Nkl3TXBOTGdXMjNmWHNC?=
 =?utf-8?B?SzNBYkhudUFJdFh5bE1Ldk1ZS2ZyQ0ptWjBseGpZUmF5L3dqZ3F3dnl4ZS90?=
 =?utf-8?B?a1RUNFd3czVtK1I1QkVIeGlIV2VVUFhNTldMQThWUFNYeVFCYmVkejlDdVpK?=
 =?utf-8?B?R0ZDdXJ1Tm5pMmJZMmZQUW83TXZFZ0h5T1djR1FPZlhTMU1IN0tDMmc2cVQw?=
 =?utf-8?B?UUh0RUFGZEZVNThFU2VGNEgyWndPZUp5bTNpSFNPaXpVTVp4eEpuZWRPQmth?=
 =?utf-8?B?ZS9Hbmw1c0JaUElwdlJsdnFOS1g4OGdzU292SmRvSXZLOFZFUjlZRzRwSnhl?=
 =?utf-8?B?Qkx5TVFQbEVxdXorRVAvMUtVNWgrWDRJaldPNjI0WmdWT2Y3YjI5S0dJL3Uv?=
 =?utf-8?B?WTQyMnoxdisvTXR1eGwwRFJPMmIvRGxRcU5tYU9UdDRzV0lkbGkyQVIzUjlC?=
 =?utf-8?B?dWMzYXlqQnJzSTZ2dk9YYU9WWG9oMVQ4QmdFejlDK0g1aFJNV01wOVBMWk5L?=
 =?utf-8?B?M3UvL2ZHTDFtTG5yWC9wVVVWVlRPSTRnRU9TY2M2UVpGODFFMXg3TVhuU2pZ?=
 =?utf-8?B?QzhQVytUei9zSWpMZWtYZG8wTGp2QS9aNzZiNmFGbkdyb04zbjgxRjNacDVV?=
 =?utf-8?B?V1o4NUZiTEg3UHdDeWtCNG9WemtaRHNjbHExRmFyT0lDQTBFZXRpVldXcmo1?=
 =?utf-8?B?WjhXWlJYeHVXaW51UVRERFdVOUVkQXJFaEIyeE1LaHNwUlIvNjJicGYyUzhW?=
 =?utf-8?B?UEhqbVFQMmhGNDRlQjdwNytDVkxZTlJSL2lTNHNnQUZlSHJtTFJsd2svZGFx?=
 =?utf-8?B?VXdKOWpFZjIwNzZOekZ0ZHhyNjUrZ0VvM0lpOElvaTBiK2dMeTA1SlJxU1Bo?=
 =?utf-8?B?QUNsY0FvYzQ3TDluMTRNeXVic0ZyYTc2N3U0T0cxZFpnejY1TTBJS3RXNEh5?=
 =?utf-8?B?cmNkdXMybW82N2krWVAwSkFvNVdETzA1ZVpZVktzWVI1bkYrQk9ad1JBYUt0?=
 =?utf-8?B?MjBHdjVOTDhmVmVvMkhMTC90S0Z2N2w2VURsOVlwb0xhbXlvMUp2bWhIT2ht?=
 =?utf-8?B?QjN4d0FhazZpYzg2NHFzeVc2a1BqM3dQbmFiNTNjaUpjYTgrenU2cjV2Ti9k?=
 =?utf-8?B?ODd5aHQraWsrTndtbEdzMHZPUU00MUc1TlVYMXpBVmtMUzdBMWU0dGROMEla?=
 =?utf-8?B?WkhGTjR2YmhvcFJSVlhrcE9NeTFJSzZiWWFMdXFXNjRuSHJrVUY5WnRHbVdn?=
 =?utf-8?B?TjEyc081cURYZmxmenh5UWthZmVSdlppUGZPREVWSEFJZmk1RkZLNXc1VmZh?=
 =?utf-8?Q?X++jAh/sq1bE3eXVtPjhooe6bjGkGdbV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 09:47:33.6917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb1d444-095a-4e51-64d1-08dcdbb4bfc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8891

Hi Pablo & Ali,

Our customer reported an issue. I found that it can be reproduced like
this. If the tcp client program sets socketopt linger to 0, when the 
client program exits, RST packet will be sent instead of FIN.

But this RST packet doesn't match the expected sequence, server will
ignore it and the ct entry will be in ESTABLISHED state for 5 days.
It seems like an expected behavior due to commit [1].

We found another commit [2] in recent kernel. We tried to set 
nf_conntrack_tcp_ignore_invalid_rst to 1.
It doesn't work as well. And the commit message is too short. We don't
know what's the usecase for it.

In our case, if we have the following diff, ct will be closed normally:

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c 
b/net/netfilter/nf_conntrack_proto_tcp.c
index ae493599a3ef..04c0e5a86990 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1218,7 +1218,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
                         /* ... RST sequence number doesn't match 
exactly, keep
                          * established state to allow a possible 
challenge ACK.
                          */
-                       new_state = old_state;
+                       if (!tn->tcp_ignore_invalid_rst)
+                               new_state = old_state;
                 }
                 if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
                          && ct->proto.tcp.last_index == TCP_SYN_SET)

Before I submit it, I'm wondering if you have any suggestion for this
issue and diff?

Thanks,
Chris

[1] netfilter: conntrack: tcp: only close if RST matches exact sequence
[2] netfilter: conntrack: add new sysctl to disable RST check
