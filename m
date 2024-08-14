Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF11AE039;
	Wed, 14 Aug 2024 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723640014; cv=fail; b=eiwvPu/X131kZgNSY200yvrdfiouoH8K9FxvcgAsJeVsDKpvQyPK2Sp2QPLKGVL/qDjpg02TqFdMEtngyznSzVbU3CDMVkIph6ykxXt0iGY4t5m26uJXUkUlweejc1KuBfYpKWokvkajU+IPfhPkDVwVsNPdfPxHsdNBkjA0SDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723640014; c=relaxed/simple;
	bh=Lw2yEYq09oMkwm9UB6Kk0O7Wl7RjoHOSbXpRcsVFDqA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhkRZ4nDi6F+NP+WnwSKmSCPxxSvUfbmegytiDTpheMxeSla8SM2LwWIBAjkdYDEvHTEQvpsKv09y3exhIp4VgZs2+Y702szm96ggq1Ite5MV+dRr9sINJwxkTWtKXGyXDhyn8wreu2PTg4DAkNkwJV0XmXJvaTnUe9X/az0tLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X68e3d8Y; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X68e3d8Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIO+I02nkL2xJijytrUjF2iIe0k2OYByqIJP320AkcIt3DaFpjAaOu8I5skx+FHEv3PAWHiLNtjt10fqUDPycUZ+Kh3q33K0Vx69FVYsqVVHs53CDCu9kG4cF5M5np1GGDSfDA3LMbyHJjZcwlzQ0hsJyRQb7ivgXu4/XDZjPvvPvfWEkViPFPaKJEE6Z0u3mFE2lsUgCvoWw87Xl8vaM2uaasL42wiBzQPodPP5wstfi2eVFWxoddbSxDA0I55cqAEBrZAfTrHwIkjygw+LOvz1C/MO7OxnDYBGGhQuLNWJM2c6NegZTFFrxB6xhAiMeoGyua61gRUii5C74n2fcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPsCXL2T94tERnfsJVNnKkP09hq5Voi6iU2WPn51Xpg=;
 b=n41OyusH4F3vk8xHBEzwk7EgwTMQ5WhSxXDQ4FRrOeAp1DE5RLj6dHFS9zdNb4AYjv8xx9XWvV3nxy/mxTz7v2W6l+n8jg/Hcw1G44g/FhjVRpm5dVDpSXRjs2R06cB5KWbfHwqSEe7q/GdSlIlG33hgT8bkHHCTKS8rPWahcybmLHCS15ya5nX1h8H1WnyJ2LA6qYWmOYvQCfkR8uEyT8r66Oe0bcWOlVP9Ar2yBocvSpuw+k+qfoX4YbwFGCOw44Y8ae2u8aD+h1bi02lpMKslOXmoqBOeoUcXCe0PuJFsdyK85UyjRX2XKotfTQ7/CnC3N33b69rDDtkqqhcBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPsCXL2T94tERnfsJVNnKkP09hq5Voi6iU2WPn51Xpg=;
 b=X68e3d8YMN+6HfyqOvopgjU2X7gTQIAjho2EBEB226OGP+874MCi5wekzHXIiYxOFzcD7s9ltGkb61SGCtsbONKzlA0Yx6sGSvb24XwxRGDyHfr1ul0ASD9iW4wey2p8ziRDIEMoEWuZYBX2nE98L8DC3aUWu9r2hCFQmU2aUQcXDN0lpOYqn2k0YR3Hhx4YDCc00FJwHfjsLZSUFs8FGOT+RCP+MH68sJ76/mBm1D2yRn1hHVjqC4ki3AP5vwb9yqgxbfvE0+Eyw1/0xzNmWgyTFLDCGHEg+OavDuLi8Mmz4TrovJ04t9UHMLqahc6dKcDRKAFA4+o+2BPh64tQiA==
Received: from BY5PR17CA0072.namprd17.prod.outlook.com (2603:10b6:a03:167::49)
 by CH3PR12MB8657.namprd12.prod.outlook.com (2603:10b6:610:172::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Wed, 14 Aug
 2024 12:53:22 +0000
Received: from SJ1PEPF00002323.namprd03.prod.outlook.com
 (2603:10b6:a03:167:cafe::3e) by BY5PR17CA0072.outlook.office365.com
 (2603:10b6:a03:167::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Wed, 14 Aug 2024 12:53:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002323.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 14 Aug 2024 12:53:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:07 -0700
Received: from shredder.lan (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:01 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 1/3] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
Date: Wed, 14 Aug 2024 15:52:22 +0300
Message-ID: <20240814125224.972815-2-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002323:EE_|CH3PR12MB8657:EE_
X-MS-Office365-Filtering-Correlation-Id: 3493249a-8135-4fd3-20e3-08dcbc60145b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fvd1Fr/OtpXQjR8QQdjuFrEPMeVA/QrD+fcvZvTBBJ6oX7OTBaXsZk3/anla?=
 =?us-ascii?Q?8lw2pMLlYJdMZoaJp3GPonOzLDXf4Fm68RveFETDNR91T1SHRHwVW2u4kZ4m?=
 =?us-ascii?Q?pZArDbS1bud1L92IuTwGUBsJFNevXPWfAtfECAFL7VbtLyaHyv2mzaeHA//I?=
 =?us-ascii?Q?7xo4RWEbBFd/zN1Q+DfYCjCzTzqQmZkKgNRqdUFvSVZm82/MmpHaM3JV7UMO?=
 =?us-ascii?Q?nrrVowv4PBBVFc6OSlOk7mcrPrVQLT1YbxiCfgOiMBXJQiYzTGKGLddx4xcZ?=
 =?us-ascii?Q?J+1s+IpYVyim9CQEK0HiD7xJW1rqZOG547exmAU3MMad1gDFWGom85Nr4jOR?=
 =?us-ascii?Q?yno6OIkCL3/wXvImgiF2RKq8qf2SzZm+0zORx8d/HNOnFOnt8bdbcgNuJrap?=
 =?us-ascii?Q?/83QqSNMdrvXQrIne6NJ2uXpKKsCVf3WfgVhvvS6JCTVFopRRl8WVxesmeJj?=
 =?us-ascii?Q?lqMKJ77GOhrvu+JwQDByzc9yyfCC6YSVvUvUxfP3aMCYJAFXJeZRMlVNMH0V?=
 =?us-ascii?Q?tR20HBCrZbTHApO5BT02daWIiu467r9vP7HxPYUzZ07QtTcXO49hu8nHH0gO?=
 =?us-ascii?Q?nu8vmnwMAjTVmv03P3JoczY5tOMcvoikZSNq4rJ9bZb5I7e1RC/dX6I3Fs61?=
 =?us-ascii?Q?ndOZPrcqdOaAHQHuIqQWAOxUQEVRZ5ULrlkLvCvJCikOG32eXEnX9HrlWyfU?=
 =?us-ascii?Q?pekdbDLqcWhlbUV2L7J24t16AMr0CSeUCZB3WlJ3YkQQ9VAmlPLk8zkqRgzc?=
 =?us-ascii?Q?tw10CLGYDP/fF16mrrevfQLGt51F1RuaQVq7kuDK9kjO2FOOe2dtGO9Bs9WY?=
 =?us-ascii?Q?mW4QVopXTRxgsITPP1s8sXVZiZaLGWw4aRbX2mdmKIEn6rppybaoI+15uVJd?=
 =?us-ascii?Q?1zCP1M/UtlCpL7r0JF2yyIIVwCcGZDXft3T0RIyeRRLg1KX95AJSma3U/UkV?=
 =?us-ascii?Q?RN/zAtQNH46w2LVlVPjUe5UMftviWejWHM+Xt9kAoxM4zmAfwbn33+djzx9P?=
 =?us-ascii?Q?N/YgzmAr2q6VcUN7A4OAhhZCErhHN7LMebgZbpLff65IT8vQRh9HaEWFoLOj?=
 =?us-ascii?Q?ymLqcsaXqRTTi4Vuq0P06dHkwlPCskMRKTMSwbFJYnturflfqscopY1RaxNl?=
 =?us-ascii?Q?cepiQZGamRU+qk+Xq7h47KtUjdWp2XgnFEyXdpyWgKngKEqXQ0XyNMKKvPAT?=
 =?us-ascii?Q?CyQvY1yo+4HA1Nu1hwzGyyggHBVWS+D8QI1pTxk7A30XyGlx82UxMe551LLr?=
 =?us-ascii?Q?QSw1/92xxoOBFwjRoT0efjV2bZKP5EBHe5YSha36/UArANdR+e3mNRXvXaDJ?=
 =?us-ascii?Q?OYSbMdx10/6Ez86iW5sa8B0hegF+RCo9nMtKWh0Kg8dAMPrqLGGPGrDO+mG2?=
 =?us-ascii?Q?Nl6JbSkX6g6v5bTPDerZHhg2+MEaKJZTVEYvYveuPKeIfsj6/bCR2XXOv/9L?=
 =?us-ascii?Q?yscYDvQTiOwBZT4T94KLGLAvDZpXMsUq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:53:22.2604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3493249a-8135-4fd3-20e3-08dcbc60145b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002323.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8657

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
Reviewed-by: Guillaume Nault <gnault@redhat.com>
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
2.46.0

