Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F71AED23;
	Wed, 14 Aug 2024 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723640014; cv=fail; b=st3uRtaVqyZf8Mm2rPtFaie7Rm73fl+h9Nv9U2wmZQw1OnRe+ro8tE1eeWFjtNKLSf37floSnUszVp01PpxtwXFUIgOVF3p3HNhs127JQx8JgAo+lo4mOTSn99rdLR/1HEbvUAF0r4jRe7aXP6o5NTlgEjq2Qj9R6tSvNHgq5og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723640014; c=relaxed/simple;
	bh=YvgX64vkyPEAF6zL5FpfADD1/bxjqzeklhAZ3T1hjXU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cBEQeLEXGU/3GPq7jRpIEUeXLXK0MB7b5Tb3nAzJsAhPrRlDAqTnLR5SwIJtkrARvs5OwEDEf0MUfy8qaqoW0NvGkN13uHxSv2hJQpcfmpSOZOVjwdAUr5sjVAtNPONDV+VcKawW8H9kJ9iLo2xV52iK94ibX69lTc0XF3dENvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P1Itf9LI; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P1Itf9LI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fQ7ze5bGQN2EjE6V9ptrUmsLZ+/U/t+mJLCgrBFx72Qfl8dIVw2whK89S4KqnEw2tN/kg7v6QhWrEBp4748aqyc2XGGcsXveBikaOV+UurKHZCJDk3aQO0wyKGQWtw28nTU1y4861RRYWOemLhfhxJ4GE4Uzr/g43FMZNfC0H3J4dR/3iGxbT5SzpvIM7pB3tRE6d+r1vOyLq0H7bQ3437GosnJ0M5Xkev1HwfEjwnOwxBcpBVlpFrx088O8KDJMHKoj5dxek2se681fa0dbFjHf6aZtAYs7dkPZohzMjr2QRzb8+Lhgx8opMFEhBha1Cguy2ac7paHK5mydBY0CwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRsBs5jDqs8MqUdlQJAA/Q4OtgDzlwnf5u4Et3KEBY4=;
 b=QFVnUMbHIgeMysd4dPTa9WVRRUlWcM9upxbIOxB8bQgc9HL+G32PLZRW9rWbZWgN+5LdH9PYjulLuAsWqyyij2gHJP0XaYVZeiVhKk4Sxcw62S+cWwlhUIGLB6MOb0CIISJ77bDYDXbmMmHddzh2NQW/14Xj+yCj2wWtVAZVrQDKkYG2mDQx6p+My0rDKmJGYC02kbggI7Mnv0s0TxX712fxUYLvl8unqTg9/vJxxAT4N1sjBy2on/pLfDAiQdIqhysAY4DRBHRQMWx6onjCSF+NKm8fN23UK7ri6WkXpxPtjL/Gb1xJh5Bz6NzakYdIRbBRKTGXO3KK3jNVuPw/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRsBs5jDqs8MqUdlQJAA/Q4OtgDzlwnf5u4Et3KEBY4=;
 b=P1Itf9LIg+6/OV5HQx1uXgOgyVcbNzpkXYWktYO2sSsfxgyvhq3CSqzKIYeJz7r+uQ2sjd8WorEFS4DUdYTFKWkjeWTcRZTwVMqfF0xymsyqJyPUqJMoPu86dydA5NqlSSmGwGQgOhsbkr98TDg1lCZ2jEt+64jKhw7NAJcgL03M263/gdBRD6dpWFN6IaqtyetWhDRDn5QXpHHOGmrPoGcBjH+XK7Cp0j/obZYByiLFXmCedzSnOtThCcm7SCU42aGRNyApzdYajZRAecVUhjKDuVtCdc5aON727YbAxagIvzY8y3ENtp+1+YxQNRTSQRa6ZIZ2atEPp1p4XriaJA==
Received: from BN0PR07CA0012.namprd07.prod.outlook.com (2603:10b6:408:141::34)
 by IA0PR12MB7673.namprd12.prod.outlook.com (2603:10b6:208:435::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.24; Wed, 14 Aug
 2024 12:53:25 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:408:141::4) by BN0PR07CA0012.outlook.office365.com
 (2603:10b6:408:141::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Wed, 14 Aug 2024 12:53:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 14 Aug 2024 12:53:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:13 -0700
Received: from shredder.lan (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:07 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 2/3] netfilter: nft_fib: Mask upper DSCP bits before FIB lookup
Date: Wed, 14 Aug 2024 15:52:23 +0300
Message-ID: <20240814125224.972815-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240814125224.972815-1-idosch@nvidia.com>
References: <20240814125224.972815-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|IA0PR12MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: c2ca16d2-4181-40aa-be47-08dcbc601619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3u2fv8J7TZads5Eh7mc/upD3HolgkOwo/zG+O8AXLDiUJo2GkPrnpa/YSYKP?=
 =?us-ascii?Q?prZgv+w1SFqvDv695Pur+xsGF0eSM2GgzYcw+jb17ENaslLnnAZ5hOBu9rJS?=
 =?us-ascii?Q?WENYqPr899XCjhzilUvm8aLoaGiW1At52O4oYlvkEbFqoaCLz6SZ6RYhvvBQ?=
 =?us-ascii?Q?fpVbS3bxjy+K03K+eZquiduzrIMwqYqv9sLjTLYq9ihwjxkpTEh2LQQRQFid?=
 =?us-ascii?Q?dLBz7NAWCfpvrVJF11yNl9KVFKuejwhDPZdjXTYNtfiCI++AdAMOwVs6WPtm?=
 =?us-ascii?Q?L7hL5pN3rovLLvyAboNOnpEoUSPuMV4jw4c9tCb1WrTADNLMQg85R4xBtNs7?=
 =?us-ascii?Q?VoJYFB0CK0KI9NqA1lE960kPpNcxGbaegGTzDX87vsTdt/L9CxyKBzXPYDo7?=
 =?us-ascii?Q?8dJcTlSND+DwSN0G67p9xKKblhcSR/sn3lbpEI9xjYFv+FwYWBjwGn5877y2?=
 =?us-ascii?Q?V2rPpdMfs727/JdK1aPOiWfpD5KbYNQlMOB5EmOJxmPOjPLzJPPSZtgnNvS/?=
 =?us-ascii?Q?jDyCRFOa3Qgy4Ku9Fn9sa5BDuIJ17fy7g9Zn/jK9MoDvpbTHS8q3MbDbq+Sw?=
 =?us-ascii?Q?b5iRv8JBGePqemRIDfs7Vmt0fgk4ms0gN+EcS9oOWzX8jx37RTin8ELVu6N6?=
 =?us-ascii?Q?g9m+MIcIg1B5X20zmCaqmxWmI8yppKeoLKWk8ziZ09Afv3jKYvorEAoRrxO5?=
 =?us-ascii?Q?lP0HklJ/LQrB2qDTnrpa9XSGvbLjz3SyZ9Ijwmtvs0JsjQBrXklr9g1IAlvX?=
 =?us-ascii?Q?pJfvcrUrCMmeoOO2Tr+8BkjBwRjoMS1Y79QqTkQ9qJO8G11yLZ/OtNjKVgE1?=
 =?us-ascii?Q?YuP35LCnjidapR5T+N2SJ0yuwb8ApD7U8W4g78gcj3AfwhHc68QBIicJ6YF+?=
 =?us-ascii?Q?D2NCva0XQCAKjyrrwVwhK/N9GzPROvlq0zkmSQJmoRKfOpwx+EEt0VvHMNcR?=
 =?us-ascii?Q?E3kNwEm2qAo25PEOUtwGQDYrKKL26oBV4O+TsI4gKkYNUANGfyOvOHkHQDK2?=
 =?us-ascii?Q?1mCmA0p4TKnhwqPESq7C8zYWlDKuGm+iMwqQ58Do6sQl0jpk3IgIeXEjcDAE?=
 =?us-ascii?Q?8sWgtGAWrUKUOJ3N8YMe4C0bY3vkQYww8Tslou0BKHt3JNJjKe+6/cn8t2Qw?=
 =?us-ascii?Q?MO1GACMlRTSXku6O+q+D6fP938ToZvmfc94miz+FuYCPI00EszoB27vjL023?=
 =?us-ascii?Q?4PraXjWV6sDhh1wiGGPc51ew/VTqSjjwmD+M2UeJBMfc/BEAcylnsfovNtxB?=
 =?us-ascii?Q?lV7R5UX7As1twm/lPyx4ROr/XczqZbaCZaKitUrk14H9xw74iq/NoB4aLqSS?=
 =?us-ascii?Q?EAwS1wyFFA+kd/K8sBCEzWSZSLX9odRUeWyjLBxsq8mwop6Y2Lk1cpmAH9s5?=
 =?us-ascii?Q?1sjf7OrAQEZ1efOqCfiA6YpCm6QwEBfNwcmXpy2kfKg5aNDwaBGZoQfD7laT?=
 =?us-ascii?Q?mpUbq9qnZe7UUnBnwGvGQXtdk1F+mfyT?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:53:25.2029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ca16d2-4181-40aa-be47-08dcbc601619
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7673

As part of its functionality, the nftables FIB expression module
performs a FIB lookup, but unlike other users of the FIB lookup API, it
does so without masking the upper DSCP bits. In particular, this differs
from the equivalent iptables match ("rpfilter") that does mask the upper
DSCP bits before the FIB lookup.

Align the module to other users of the FIB lookup API and mask the upper
DSCP bits using IPTOS_RT_MASK before the lookup.

No regressions in nft_fib.sh:

 # ./nft_fib.sh
 PASS: fib expression did not cause unwanted packet drops
 PASS: fib expression did drop packets for 1.1.1.1
 PASS: fib expression did drop packets for 1c3::c01d
 PASS: fib expression forward check with policy based routing

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9eee535c64dd..df94bc28c3d7 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -22,8 +22,6 @@ static __be32 get_saddr(__be32 addr)
 	return addr;
 }
 
-#define DSCP_BITS     0xfc
-
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 			const struct nft_pktinfo *pkt)
 {
@@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (priv->flags & NFTA_FIB_F_MARK)
 		fl4.flowi4_mark = pkt->skb->mark;
 
-	fl4.flowi4_tos = iph->tos & DSCP_BITS;
+	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 
 	if (priv->flags & NFTA_FIB_F_DADDR) {
 		fl4.daddr = iph->daddr;
-- 
2.46.0

