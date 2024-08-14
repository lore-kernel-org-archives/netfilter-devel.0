Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D31AC447;
	Wed, 14 Aug 2024 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639996; cv=fail; b=a95DYPbpRbik5dk0FDGMZSMZkdQ7G/Ft/2bGaEbcQL9WdQEyfvOweP//AqdXV176OViGngL0WDfrZr/FLaQ4e4MEmmEXONGHtqPLHPwNwUxg7u/kQjFwK6JCMoFdvLPFZtSDDHwt89fThkJdupvwi5yIQxlf7FtYZYgaDDJ8XH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639996; c=relaxed/simple;
	bh=suEzQAsd7/Y7PgxqtIF/SdIKvbu1/BKwbN0IKvzEk9c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a0yDOb8Bkwyqzio/x2Jeqv8kRqFlXfkS0yZeFkSINWzgVnStdDLRAVLb3EKtmdDovGjz/YD7bTErNWY57PP8lBb9i3VwFEZ9DVaLAnEZAOaEWFFIOjYFsYVTc+vNydi3DWQSktZf5U5yGkd3GhBpIHnNdaXNXBqBQp5HdzFHYTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tj17PADk; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tj17PADk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rxyq1Iij6dZHKyTvJR6Px2f+Ar5RbwAtkUxqaQh0KombIOzsFTKvKu6zUc56H79ImwSzv9pnTH9p/ltjOX7WLT84KtlQihfnhCDWksAUM2pfx06xUTektKP5pvZoEcQZkKHeLNAIkrQOidDqLDE++DjQyrdhHH8s1XfruJagCCtnNmh35FQcV+pELfgyic9rw3XUYN0fLXOowuzIrB3m4wOBb+G5B50fQ5cmlhnNZLA3E6LCsC6ZJvXbPoveqe0fotnNaxPPrKEytcNIT4PvE/vXhMYqFGeC85cU7la9lsHyd0A8rB9YpOYKW6Da6SXew6F459ZzxHoJgk/oIKxi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fktX6lfVtoO/o104EPVdrt8JgtsXMHF4RMBHeKPvwII=;
 b=oSjCMM+5408sLKIXsQc8jrOGRHYBF0mD2k062PnTE5HPxyOtrTMivEZmgiQ4z9f148LUk1EO+EL+Ry3/dFMKQomCxnRtktaYzlUPRWv8+6fS1pHfdjGDEl7VTdId9jY0FzgWTbaFmBMETj/5tiDBLlyOSVTRplq13SCL/E+rkZ2CpQ4PR5Ayp84uU+8QMRwy2BJvNG9Acp2SAURlMIdktv6MKhJgsXS4ze3UkSJPHzB5bZd0QW/C28fefVgiytDAQbtAgLCm0AYiIzR2qkqsKcnchJZCa4DArOF+6lqggK7jA6l+5Blbb81cpind+c12wKxcIBLKZ0Gn9lrTlkUeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fktX6lfVtoO/o104EPVdrt8JgtsXMHF4RMBHeKPvwII=;
 b=Tj17PADkrtiMkg/iAQbPFwpRUHHBxUYfL4e3+ojesqCHNXBFl+VA2h6jSOAuPZA7o6t5zYjAdHyj3lngpWSjmycqe7DKZqj30reklVlLcuHXmY40Vy5qd5LZWFx0HqUnEPjUm5wLrzrCPCWxKh0KdCDWeIXS+LcFoLr7VazM50FQjd0zGy5ihJifDFfmtlY+x00kbi8zMHxtahfhT6AS0CvcFsY+tLOurrQc6vkj9N20AoZjD20SmwcMYMpxbqLRtgsI/G62S37NbU0VLZnl/03mszMjBx10kwfq2eFc/tcDGxc6LL8GGJ1hHtldxRqxSqU4/uWvOmymgpcK5ih5hw==
Received: from BL1PR13CA0122.namprd13.prod.outlook.com (2603:10b6:208:2bb::7)
 by SJ2PR12MB9237.namprd12.prod.outlook.com (2603:10b6:a03:554::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 12:53:12 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:2bb:cafe::c) by BL1PR13CA0122.outlook.office365.com
 (2603:10b6:208:2bb::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23 via Frontend
 Transport; Wed, 14 Aug 2024 12:53:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 14 Aug 2024 12:53:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:01 -0700
Received: from shredder.lan (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:52:54 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 0/3] Preparations for FIB rule DSCP selector
Date: Wed, 14 Aug 2024 15:52:21 +0300
Message-ID: <20240814125224.972815-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.46.0
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|SJ2PR12MB9237:EE_
X-MS-Office365-Filtering-Correlation-Id: 4afdc8c1-7067-44d9-1815-08dcbc600dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iv8RZrA0icvhSCoF8DTj/QZ1URRnXtj0gQujk93kjBmcwPEf60msTVijFKNK?=
 =?us-ascii?Q?XYvncd8Aef63w+bD8cEj2zYtb3lCo5KwxI0ZARdpDmyYZKR09J8F4iDd10E1?=
 =?us-ascii?Q?jbrGl+NLZzCDdOyLaYYHs8rGA0+NFx8GDpe7gJYGc71vjZmLUitiFDEe5UJo?=
 =?us-ascii?Q?WSxYStpX7yQAxAunkzZjv8wAcKQkZh+toTIHBmU1NG1VckwM3nCRNDjkRzku?=
 =?us-ascii?Q?+4mYjXmTfQdf/SVni8ue4kQ+1gz/CxCh8fMKTBkPgXRajJ4baNxmnmeMRaF3?=
 =?us-ascii?Q?RTD+hvP/5gUDN+aBVxrtB/xOJtNSxOnM1e+Q/J+NsrfCW1w/HY8PljoOLo+K?=
 =?us-ascii?Q?aOE+31Qo/xq52zC40umIna1EJedA1H+krctO1xTUkVkIxjj0q+/yh/wHG2W1?=
 =?us-ascii?Q?fH+faFtqtdWogbtdOH2ZOHFBPcdr82CjAGua+oE2XWETpA7zAE8S7sHFpURj?=
 =?us-ascii?Q?iykQCpnV0JIeaj/Mtv3dRrMZQFWGaMn+K0v/0Jr8RX+iBZ7lH6evCZgpxAqL?=
 =?us-ascii?Q?WbgfudhN2ljUbdHxaV+SOmSUiaOS1/LPHlQn/USiobo/QNsTnk+irK5D4BhO?=
 =?us-ascii?Q?lafF6AAOhCL/U7YkkGTna8P2qIm+cm3SWBNEnwjqjGE1/DLqHPT/ywOZ2R3g?=
 =?us-ascii?Q?PHU9Qm2l8mqvbGIQqY0aHmSyfPkHjNdSA4Oo+SaUbvDPT52na7lyRHu0cS9E?=
 =?us-ascii?Q?emrv9IUHg1nwRRI/OfpucRKvxWWdqwYOE/vtd0Vyid1ZZh1C31r9paeYp4nl?=
 =?us-ascii?Q?ptt4ReB7sFNt8iDbhZZ0SxXtFmgHPfM8nnVi+Cv5Ej9JEkqhsCNHNizQVPSp?=
 =?us-ascii?Q?i7QT3uEf07L5tyCxCanWXto4HZ0lPM/B7yN6hYUa8PODgvyDFgZFjtLL3teY?=
 =?us-ascii?Q?QPZQ5/FjBPG5OtGLpAy3M1kH94kzbiIAUEvL7/ouqal9wE2HRXtSxT3iYW4A?=
 =?us-ascii?Q?/gZG6Adbw4/zTJGgJtakQIEKglfDopb5R/m1Ithc1I3p7HW2KzKglBsJJfbF?=
 =?us-ascii?Q?4LZQvDEdoEFDflIXKw9Z7/ODzcZKLuoJg0ePNjDFDsZXF76Jh5f7Vm8RwTeF?=
 =?us-ascii?Q?xgXltzvPbn5QBbObUEPw1Rva5SAB1Qj6j09N5F0xo1YDevn/O/U6IHLeHxMF?=
 =?us-ascii?Q?xM44jtjL+jVbyiz13KlVdEx6CGi8MHKPpSpmrsfZzDyyCyR0/M1f1lcU9v7A?=
 =?us-ascii?Q?n5gcb3k5Uz8fWZ8ZI9G3kWl37yb/wCUjOSEvdNYAS0McsYdqkZq00CN3Yd3N?=
 =?us-ascii?Q?aVYfWmRIDbbK3A0q8Bnx69AAqVqEmR8RhRHaRNYVOIvMDPsQ3OY5V7LeCPNz?=
 =?us-ascii?Q?8gVMwzG+I4PJJveFmHleijoiD1NS0ds4sWEEMGsbmCxF9tTi0ygF8lzIvx2d?=
 =?us-ascii?Q?On/PF76at8Gs9hA5oj9ZJQV0fnpI7lRZeJB5H/WiWJ1eqF1W4ESxrpyt1kBm?=
 =?us-ascii?Q?DKUL8MgBXnb6EB/B3FnZ0m4PgRQKFXHr?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:53:11.1770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4afdc8c1-7067-44d9-1815-08dcbc600dc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9237

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

Future patchsets (around 3) will start unmasking the upper DSCP bits
throughout the networking stack before adding support for the new FIB
rule DSCP selector.

Changes from v1 [2]:

Patch #3: Include <linux/ip.h> in <linux/in_route.h> instead of
including it in net/ip_fib.h

[1] https://lore.kernel.org/netdev/ZpqpB8vJU%2FQ6LSqa@debian/
[2] https://lore.kernel.org/netdev/20240725131729.1729103-1-idosch@nvidia.com/

Ido Schimmel (3):
  ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
  netfilter: nft_fib: Mask upper DSCP bits before FIB lookup
  ipv4: Centralize TOS matching

 include/net/ip_fib.h              | 6 ++++++
 include/uapi/linux/in_route.h     | 2 ++
 net/ipv4/fib_frontend.c           | 2 +-
 net/ipv4/fib_rules.c              | 2 +-
 net/ipv4/fib_semantics.c          | 3 +--
 net/ipv4/fib_trie.c               | 3 +--
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 7 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.46.0

