Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586D0224D2;
	Thu, 25 Jul 2024 13:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721913523; cv=fail; b=awa/gPV+kIFpjgiStnKM3WQ4NpqncstNY2w6HwMPpINbWVTxvTLBqCn90m7GC3ja0gzfgBd6SxGkXBUY4CR4xnlUQXfEHC7RxONhHi4+RGHk2uO9x00i2dcWFYd4tefXve1PRViRZwR2PSiwNY0gCVIofk5VS66mYjS5q6mfmXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721913523; c=relaxed/simple;
	bh=BD5wMSBIEBtPgnlOx8iPSdIMhdEyyQuUOMjyz0piTY4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=raMODkZViv3t06kXx6G82eg7JgHRq7xVDF+zAPRvGjoK0ubPwbJ+8M0ET2MzrU0mup5p93iBoQpbgq9ri3yoqmpWsOM7yjrvCUbGhwuxmFCUlAWJ8S5GFmxOdBRcG2cBSsTIe+Dq0CSs0AL7l7cFmBZH567x1ek9D4vaCCY2Msc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JtTmCUlL; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JtTmCUlL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJQAad2rWU6gID1JuHBDMwpJ10m2gZSrjI9tlgaNZc5aZwhIEopdlle11WncG8JvrpHJ01rbmDMcEdodNTWnWYCiqrIqUZqFTpUD1Hv0/o1PRHodX78J7PGuR5YZlfwQlhujB2RUog85s5AUK/bArvx9Tv2bOdRHEdeyWD+2yEL37UeVq4xX4rHhtT7OvEmx1SKi+1/Oay00fxHUtw4XjIzXq5riLXK5YZGw6MBh3P61iv7R1dhG+1Qk61rOQzC2w8nBrFXtM49RhX3RmZ1um+PYytcaLB86RZACVrEyH9+VHaTLGC7ZPhkp8drjdTxk56f6A4Kk0RKoSsfso1w7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgsdwD6lT/O4XttaZHRnPJNJKlCKjyFdExyER9n8g+U=;
 b=GU8dktz5uL8ikRNFRwgOSGbMhs/fiu5o3FC3hnLMzdsrmBY6MFoofgZj8MrG8rgbYYr/vV7/Qs8ngiCNyJbwm0xSeQjNa9Y0Oozq5O8HMqrRxfRlLQA5VUUhiJwn4TZn/OyuHuGcVJW6ZeypokXmTs2e7pFDxmFX1OAhvbMPLcP7aEEm30dYf/U0XWT2HYNay41ZIWDCvzswzaFV2GJMF0Wsh0xnL0NXBJiR8fIaq4fobuRHcspsnOsev4XEVeJBZ1/+lMgTSmiDswxTIHHCu3KBroNi+GM4ivcI2HmrWIy3RPV9Ofik0UWXRzUkMQK+oj3taDxiVfNeTrBUkthVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgsdwD6lT/O4XttaZHRnPJNJKlCKjyFdExyER9n8g+U=;
 b=JtTmCUlLTUrucU5JCImVN78uz096RzacJNxrG81DRjUtguNXpnDl2zOTlEv6DFfkWwG+ALJRUmhOu3bwm8GWKL+pJADDYkMob7y+ZlkwPYkimJRxiy3RXas+DvdPbgQ3i5P2N1dc/YGFi+DBWHks+HXCNGYzrcEWCvfphGfeEp+VRnRqoBs5oytoppkPYpnHkd2S8SACKUNw2hEn4JmYpZTZBwW/afSlbDIDgXHUFkR7ClCUJh/oD6MffT337Cd/3ZqUsjTVmKi3MJxhEIX3XVemI2rM7/HSg/uM2hWRCa825UlG2ifAz3XWoeruPdPnjvBQhE7FvGljn+E5zQ/XlQ==
Received: from PH7P220CA0050.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::28)
 by DM4PR12MB6422.namprd12.prod.outlook.com (2603:10b6:8:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Thu, 25 Jul
 2024 13:18:37 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:510:32b:cafe::f6) by PH7P220CA0050.outlook.office365.com
 (2603:10b6:510:32b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 25 Jul 2024 13:18:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 25 Jul 2024 13:18:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 25 Jul
 2024 06:18:24 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 25 Jul 2024 06:18:20 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/3] Preparations for FIB rule DSCP selector
Date: Thu, 25 Jul 2024 16:17:26 +0300
Message-ID: <20240725131729.1729103-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|DM4PR12MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 285e6d79-a985-44a1-5540-08dcacac4b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EFNly5UWzlQlpUVOtOZxhGpBT+X1A/EH9Ey8X0WtOjtOFaSqIVNPagsGBOUl?=
 =?us-ascii?Q?J1mQThzMa0Q+KW01xvcWAgHFnUtGz12V110Z3VWGlSGGNViDSv3yy64jO0Bp?=
 =?us-ascii?Q?6qOs/VA2vuEaO6WZ6QKyioAfAsBY3xIyc1xq5cvYL/8bMw6l7gXX4/wYEJd7?=
 =?us-ascii?Q?AsYj3B5jfC5Jagrz+k1k1CsIstLrDYpaIlPxScZnsKEidWp7+X2USGJfT7zZ?=
 =?us-ascii?Q?SV0qvWhJpDyVWoUX4HwukTk+t3YziB80U6YwxmbAYkpTJkE0hjbSpZbBkctr?=
 =?us-ascii?Q?cQPfNM4F/7QiHZA1KrJqLqlSM8ZefTZWgNgVwDSFxgWSTteq3WpUjA/y+8Sn?=
 =?us-ascii?Q?o0N2OoIruldsgYNbB4hUBAFH9vj1sDoox5YnspAl4k7F3ZXnnHh+AECAM+F8?=
 =?us-ascii?Q?0FCFEnClgr6ApjfdZN5yYI4Vqt+cYPwouufP63eKqZV7POgwXP4EXSUEmzGz?=
 =?us-ascii?Q?WC5BqnziNdo0FMDzr6dRK+lSYP3G731m+srF4tnD86EB9TTIgEEneGvP3D22?=
 =?us-ascii?Q?eC7hTFKDAD7MBbAhXpL9WHg7bA68LYIPFm2kvNHsUY9mO0FQuA9H2cdVyKiX?=
 =?us-ascii?Q?vLfvNyWsO+Rmx621FO6ZqsEppFMeTxuES5PHKSJxJ2+TtboGJrde7D5en2Ph?=
 =?us-ascii?Q?cufp4VjjZjRD7PRaxaq8FhZCA03Ysqp+gxLzoWwiZBXuGHzWxFGYuLVBQybP?=
 =?us-ascii?Q?LllhVSQmrRXdB9HV6EqAo4gfHekRr8knf4WbPAaipspIodb3/WeQLw4NGJDK?=
 =?us-ascii?Q?TqiBnOxijA8pECfScGM8cl2jpNP5Thiqncvcyj4u84FZ8Oy991P9GkbkGNZN?=
 =?us-ascii?Q?Ei3qbdrNu8qhDKvj7NpmDcV08o2IA71qawuzd2IJmLqGCNrhqgpTLaqlpSS7?=
 =?us-ascii?Q?UX5xuJwyzEIO1P36KzfZF63Szp4ZpfsdLZkTWKZJXzAllJdBEgIQuKGUlyED?=
 =?us-ascii?Q?l+MbP3SswyjV3p4JWVQjHRg/+IaHvy9m+7S/FsVTdOvWVAqaC1lbuh8xtNYV?=
 =?us-ascii?Q?nPMwE9KzCH7kgEKP37hcz+vntg1soWZ+v39d7srOEoVn1552+cZJ8DH7KLnZ?=
 =?us-ascii?Q?ZuPcSauTDhscJya9v00ziRfTE8enridST8f+AtD3RXVF2Nimnu66GbYXZ2rQ?=
 =?us-ascii?Q?HuN6c8fKBjL9Paq4vhNmT/MrlEBnPMrVrHvpSudE477AFtWbGXu0NcFMkEwp?=
 =?us-ascii?Q?cLV+aUDGKYrKJYIib0ShX6JhNcLKQaH3I6wHBGqSRTcKI8znYOu0YPL3c8Ru?=
 =?us-ascii?Q?jBDQoApI+VfqIuunuZvFf0nqo7SP3seZjdj3fw5sdsuUnBLZfW5I19JKHyJZ?=
 =?us-ascii?Q?O2DJLHuGIHDTUK5Xx3lCB0G675DBHl9cSJoJsPY0R9EHaxQtTFQ6dzDyGQly?=
 =?us-ascii?Q?QuA5mzud0wihormwdR6eaKLiEaRIp9aXKyWBHuedrcbls8bin9sskCR0+T8K?=
 =?us-ascii?Q?G8NaD9GQtm/cY+YshCxf9ZX/MbNm1YIN?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 13:18:37.2282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 285e6d79-a985-44a1-5540-08dcacac4b0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6422

This patchset moves the masking of the upper DSCP bits in 'flowi4_tos'
to the core instead of relying on callers of the FIB lookup API to do
it.

This will allow us to start changing users of the API to initialize the
'flowi4_tos' field with all six bits of the DSCP field. In turn, this
will allow us to extend FIB rules with a new DSCP selector.

By masking the upper DSCP bits in the core we are able to maintain the
behavior of the TOS selector in FIB rules and routes to only match on
the lower DSCP bits.

While working on this I found two users of the API that do not mask the
upper DSCP bits before performing the lookup. The first is an ancient
netlink family that is unlikely to be used. It is adjusted in patch #1
to mask both the upper DSCP bits and the ECN bits before calling the
API.

The second user is a nftables module that differs in this regard from
its equivalent iptables module. It is adjusted in patch #2 to invoke the
API with the upper DSCP bits masked, like all other callers. The
relevant selftest passed, but in the unlikely case that regressions are
reported because of this change, we can restore the existing behavior
using a new flow information flag as discussed here [1].

The last patch moves the masking of the upper DSCP bits to the core,
making the first two patches redundant, but I wanted to post them
separately to call attention to the behavior change for these two users
of the FIB lookup API.

[1] https://lore.kernel.org/netdev/ZpqpB8vJU%2FQ6LSqa@debian/

Ido Schimmel (3):
  ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
  netfilter: nft_fib: Mask upper DSCP bits before FIB lookup
  ipv4: Centralize TOS matching

 include/net/ip_fib.h              | 7 +++++++
 net/ipv4/fib_frontend.c           | 2 +-
 net/ipv4/fib_rules.c              | 2 +-
 net/ipv4/fib_semantics.c          | 3 +--
 net/ipv4/fib_trie.c               | 3 +--
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 6 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.45.1

