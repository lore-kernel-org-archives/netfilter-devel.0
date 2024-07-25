Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB1224D2;
	Thu, 25 Jul 2024 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721913528; cv=fail; b=o2m0w1fa0ALo8MRtwRuJbRzD94a1qJ3oAmMx3KXOBp2x85E+3qlud5oHib/36NVCz5Zhj8Oh8L6gLyNGdJBbaBkEKVJWqhTcSnP/yuKT8MKJlwlU4LT2+97FZNw2affYUvEmw4fuoe/dM9ritOO81jfST5Lx0jGAaAgFFHdONHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721913528; c=relaxed/simple;
	bh=QYBJReG9HT8EC0dk40BK1Q1cc7BB17M1hx4EEkN7IOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjopNyC6JnGcTMh4V7aFWSQPgUVaIv+O7M8o/WyNTcGF7oKSMHqIGiq+K0x4O4DaEQMahIm/pwNjwjSqjmtVyaikmQ6llFNI2oMbZpBAl7I2EEu3SccsX/AqECr4tSuULUp3BbPeIF4Oa9FrNQPZ+brdLAG/wBKTiPIM/z70kV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dH48yCh9; arc=fail smtp.client-ip=40.107.236.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dH48yCh9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npgGzmsuKjfA16PrsApoacgfxSbA6PtjxIPf88lAWnsTIhe67rJhqwzh0Tf6T4oBRX9L0WlM6I4pr2a0r/fKlPztZqbQB17T11l/J2h5cQei9cgDPOpk2LCqogRzv+Ync4rNuDCBQuqBxMHWfzBP/j09QBqBw4FFFF0C7JJ2EEcEXp/n/10eo2HSzBnz7OxdNMyL6eyrX5H0btRxMR+N+PQYI1PbafOY7tr8s5VvdWDx5ykxKvlmCmI12x2QH5RJPm6AtLXxW0ramg9VVGlOj/hPok2GffbdeP9hbczRGhsCrZrL2FevdZDR+JZsarY4m6vq+2XnZWnouyCDLjwuyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zr2CyH0AzhParzFpZ76RXVQ9krFZXUBh2Xxr+llPRSU=;
 b=l9q7swY2gU4JtzL7N++ePg4XbpUJV0awbFkV4EEHnwPC7H9LEo1Sn2eYnv9XYSf2F30TMtPyyZEmqHIyqBALWAni5LsPt8Ow6stowQRrf9u9nAB7dNdRQbf1Hb0pgnSw5bY01q6a8SDTgPJROoCbS2Xm+4W8ksEvsyo6gSRK3vDaC3tA4yunP5AYHRHFeEq4qXGfbOh01x6We1hqXLMgLF55lHmokPRLciy/43Z6snxZSDpx62n9E0vMV6eEu0TvXW4IsxmmXpeDLLvG9ytDbeCnmu9cnEVfXIgBiiSF1TRYCu9IiM7JWyOJp2I76ODHWylRahk+hVYc8NUn5z6XDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zr2CyH0AzhParzFpZ76RXVQ9krFZXUBh2Xxr+llPRSU=;
 b=dH48yCh9ROTPRlK8Vw4XCFBlVaZl11gBQ3eR8FFYdTqfLlS2X/V1JpflCNxgAw0hufz/E0GfxBdNKz9u6cEsHbXdb0ovbuZL5cVZiEjGfUcdB/BNhdzCnexEq49DJnbNlAVU0ny2ADkfE1BFt+yVUzKx8a5vPqC20WpxCqni2z059txIYfCwDJp51QHeqFUQCLDGJjRqgQFmXKReRTJaR8k/YA2K+ORsn3wGrH9lnTzumCYyGvndH9f0tkiE+v/Q8ho/xsgLMyWer1MhtsI5HYQHNUZ6aaTT4bvlh71EmNRwEa4/SDER1Uia5RvrAkxofhj/8RH6ZQs4iFrHbZ5LYQ==
Received: from BN9PR03CA0338.namprd03.prod.outlook.com (2603:10b6:408:f6::13)
 by PH0PR12MB7886.namprd12.prod.outlook.com (2603:10b6:510:26e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Thu, 25 Jul
 2024 13:18:43 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:408:f6:cafe::e5) by BN9PR03CA0338.outlook.office365.com
 (2603:10b6:408:f6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Thu, 25 Jul 2024 13:18:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.11 via Frontend Transport; Thu, 25 Jul 2024 13:18:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 25 Jul
 2024 06:18:28 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 25 Jul 2024 06:18:24 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/3] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
Date: Thu, 25 Jul 2024 16:17:27 +0300
Message-ID: <20240725131729.1729103-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240725131729.1729103-1-idosch@nvidia.com>
References: <20240725131729.1729103-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|PH0PR12MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a032c15-ec72-4d49-d679-08dcacac4e70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mfdoSRhY4skPf5mbusjORbA3no/eLP/WNYOWv1JLfp3Py9Mz4fwPmV9Smgpg?=
 =?us-ascii?Q?XUsYjvPSnMoAHAtmzwfrujFClty2ZUEySPmi9VDsdnvSzDH4BYBKazPvvBwH?=
 =?us-ascii?Q?420kJ6cmkWyYa0M4Z1LXqtBKtVcc2Q2king1dJg9NEffsgTiOFnVLYA41W5D?=
 =?us-ascii?Q?9TvXfKvorkzc6M5Rk7rkegR2tvEJ5frUXSQZi4xWGRV6R+SFRriM8N2220Ba?=
 =?us-ascii?Q?9RuT+2H5Elykyu7micLZTEd8XQK0EkgcK6I6WRzyplnIV3DyVkHkHIdBs4bR?=
 =?us-ascii?Q?hIGUEIeZj8GHKTJz4h6Qn0DhPJ/BIizzZiuocoN0iymmxqMOXlkyRRpY8FCN?=
 =?us-ascii?Q?06Q/is02MVtZQI5xkc55nA55FVtfWZeiKLwElrSzS//PpkX776kJpy0ZONy2?=
 =?us-ascii?Q?UwVNBS+wHeqkoG0V2aRGFIR+SuWd8bs3cZb/5IBzegufi3qeGGlCo0WjfFa5?=
 =?us-ascii?Q?dj3JhuSV39FlreMfh4VVwb3QDWIQLZSZeVQZURt9/F2aRpvXS+56UYnqTuO4?=
 =?us-ascii?Q?1oFaE3QPNDgtBJwN7LAUMTpXwybL6CUbJnAjEM7jnyNEjdRIilzT1+dTSd/r?=
 =?us-ascii?Q?3XCCSL9z11NylWrst8ZZSyIJzWttpbozHnuMiScppjrlXXOZpFi3YftI/t6e?=
 =?us-ascii?Q?OcChBLbEfYdPM+qG9YkNOmV8g8zZQeOaYITBW1UcBmNaCxCkzKda0FUsh001?=
 =?us-ascii?Q?G+Dlf3sHF7KtZCpXG5JgSGoM1wFvwFnCMVbfIdJ0kj7A9kyAIz7fVkC0tPnq?=
 =?us-ascii?Q?xpL12ikQbuDtyrYc7+0eK0ZRVkXtg9ITQlzZIwX+0Y0RZYOfe8aBnpt0S9M4?=
 =?us-ascii?Q?NaJ36iMOxgeQYxg9aDagHTlFB7bWGCXsHsqRBwNEF8i4UQ3fJfRbzoESSinG?=
 =?us-ascii?Q?sfWCPupWU/09+TWl/YnkaigWuNhdWqh5+HxEQPlRjz4YJ5uBEmdcA+J85Wey?=
 =?us-ascii?Q?jO+zLrIcx1PeQMcjidlMcEB9UapIRgtmgvuO1hvy78c8Bosjl4T+/PJIU1n/?=
 =?us-ascii?Q?N60i/rnNHnVNfovwIqGdYyn6qbya9nbSyMPeWY2HuZfYHELihGZ/CCDhWO84?=
 =?us-ascii?Q?636q7ouFbSRmYlet1E2ClYXsSV/yCy5GsFw/hJVS6+m6cr0LB0d+xbmLVg4/?=
 =?us-ascii?Q?v7hYF4dMS31RuueRTma9j7fjvLJstn4/TbVpSGJxeu4Xz5rAKcm3C4J1896o?=
 =?us-ascii?Q?iBRwdpDtx5A4hH1FQoG5+cd+JNC1enehmcwuafXPZ1IRjVK561H0S/lHcW4U?=
 =?us-ascii?Q?J22cuHhEHGTK2iTSs6bOHHXkElnygnSheL7OzOT7qMIxwDGYGrU7AF/SRO8N?=
 =?us-ascii?Q?3Oe3p7maI0aR8SM3Bpv9/tToUUvf7pLQH26U5dvTAIMhEiH4OOMq9sORLzPA?=
 =?us-ascii?Q?NhUcj8zqnHp6y6foyIDfmmY6N2h68BSX4NHrGghNBppXVp6Cpooho+nIHwUF?=
 =?us-ascii?Q?9p1ZcZYJInKsKrFnrGH5Jc5ydUK87+Hm?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 13:18:42.8106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a032c15-ec72-4d49-d679-08dcacac4e70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7886

The NETLINK_FIB_LOOKUP netlink family can be used to perform a FIB
lookup according to user provided parameters and communicate the result
back to user space.

However, unlike other users of the FIB lookup API, the upper DSCP bits
and the ECN bits of the DS field are not masked, which can result in the
wrong result being returned.

Solve this by masking the upper DSCP bits and the ECN bits using
IPTOS_RT_MASK.

The structure that communicates the request and the response is not
exported to user space, so it is unlikely that this netlink family is
actually in use [1].

[1] https://lore.kernel.org/netdev/ZpqpB8vJU%2FQ6LSqa@debian/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 7ad2cafb9276..da540ddb7af6 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1343,7 +1343,7 @@ static void nl_fib_lookup(struct net *net, struct fib_result_nl *frn)
 	struct flowi4           fl4 = {
 		.flowi4_mark = frn->fl_mark,
 		.daddr = frn->fl_addr,
-		.flowi4_tos = frn->fl_tos,
+		.flowi4_tos = frn->fl_tos & IPTOS_RT_MASK,
 		.flowi4_scope = frn->fl_scope,
 	};
 	struct fib_table *tb;
-- 
2.45.1

