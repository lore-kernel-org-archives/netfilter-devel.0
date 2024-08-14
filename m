Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C5A1AE039;
	Wed, 14 Aug 2024 12:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723640025; cv=fail; b=kBmMnoqevqWdO2q6gM0iS4tjTc1QXjVEv9bpuKhR6xRPfaGRQ59Hi+nkbowwUwR0GBHv/Rj4J4ePUMjfG3ABAwz2eACdtYc+1yYrZsDBiZ3lWytN7U70UwaIcsXcvIQcLKNsQX7HcCOecNMdp4SrYxWyj9V/zKiV0UjVk4+NZs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723640025; c=relaxed/simple;
	bh=3plnB6xqZRtwzBlAL2UeWAkg41a4SJz6bCPKDWvuPzc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KDUP0dga97gZyK9Kq42iOBIu68ryjIyXppB3QsyS/ifuEXVuHsh+LHSPsxFBKylrQJAQMT/eEzdPnT+y90AihOS7feAG9E1QnJ1/nJ55lcp+RnMpGKe1hB6s6pJsEAPVmxLclKe+2oS+S39y2l17JvmUWpg7XFnG6JMXXLl2KgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RmYGlHpr; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RmYGlHpr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPFNG60yTi53fBZRWr1otnQ2eEK+Ash3qosElOOYSxTplNQY7YyeZQHDZzzdeC9NK8aNjATvxX7J7vz4adZ+2RLibJwVtdR4PxGXKbxY1i9yxJH3gCEaSnJYcqVwB5YqHyLDnpT8u/SqK/hnmtYcaq1RRddAjhffxpOlUMxwPhIAjNNDQFCtWCz0o2tE7pEBuEUioTGMNr15HI9b2r7sMOl0IbzOEkCyRhH1cI63YCt2dRzYtrgsWPWN/osgcw+bMJzhfX8DlUuuxZr1Npy4KCWFTHQNrm8mIiF2FvNbVz5JSp0ga7NVFbj+58nPXpi3y/3GoRk5sw1w31Vf4Vm/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMfTB57IYat7gsejzQEfxKSVA+XOHdOW3uuLIo8KwKM=;
 b=busZzMARnuoZmmvCgSohD9uD3LAgDtaI5KZPZkY8bcE9uvphpz6v9wKf/r6XMWR4H6zipgyh8ZjqKjzT2/uWhiPnHITSQHseh4KNZy73dQGXwOQ9CqR1Xm2l3DH7WbCT0yA5EIXFHNh6cNipwoJ1SbKIWU4/pBXYtJEGePV8DArZnXhzUiPpEK6kLM2mjW0UBOGU8Z2fSWZlGbonWcGdKY77Z/mCkqZB/qsbCDnmFz/9Nz/u2PIkFNktDZPtilQ0vsxQTHAGpDQWxieXFx+IOHZbMZ2IPEpb1eWLhea9g3eYpHrUwLBGoC01AJsDVjOa+le3W8C7kapURSZLlEnLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMfTB57IYat7gsejzQEfxKSVA+XOHdOW3uuLIo8KwKM=;
 b=RmYGlHprRS7M9YvNFVG02d/9CyCIjSgEXvtUV3N9kAZmhSThZ3iPkpJdKWIH1HRRH/YQ0SM+rk9Qc4FTJuSzQfZ3UJKs6qh8yXHiw/5n7jhhKKfGeiUSjKFGvCCGHmvJ3qTtkcy2QY/pL9tEGnTRu1kZojjC+JXfREOxQsSzD0mv5d6Tp7WmJIHNdBJh5sO3yZyJbQaAek4f4g1Hpn2UusSjju2g6k/FBnou2vJS0szhthKl4H5iE5X6k7aEZLfhVNYuzqLKU5cI+FIl1HPmYoDIYFC24fY2U2fT0/DyzrzNsje7zbZOuAb6AZjU8nEQdPf5rMWd2HT1QZB/JQ+TYg==
Received: from BN8PR16CA0036.namprd16.prod.outlook.com (2603:10b6:408:4c::49)
 by DS0PR12MB7581.namprd12.prod.outlook.com (2603:10b6:8:13d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Wed, 14 Aug
 2024 12:53:38 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:408:4c:cafe::8d) by BN8PR16CA0036.outlook.office365.com
 (2603:10b6:408:4c::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Wed, 14 Aug 2024 12:53:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 14 Aug 2024 12:53:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:19 -0700
Received: from shredder.lan (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 Aug
 2024 05:53:13 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 3/3] ipv4: Centralize TOS matching
Date: Wed, 14 Aug 2024 15:52:24 +0300
Message-ID: <20240814125224.972815-4-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|DS0PR12MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d38872-a6bd-45b6-bf6f-08dcbc601da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HTbgyKLYmQvu2MAsSsaltB57ArU8IM3oWd2N4LtUdXSTGb7u1evXmi4g+2n+?=
 =?us-ascii?Q?4o5UwDDhYZETA+sScxujUsQHItXiTTgEhKV9TbtTq1lo4ztfmaNTi1vNabG6?=
 =?us-ascii?Q?EGLhgTUEPDDLd0tIa52mW78v6UBQDgyZZ9UwLdnU8KdwP1IUlcwGp04KvR0k?=
 =?us-ascii?Q?enisVp1jym+8+2OJiAMd988YDv5d69bb9OGUCN0vKYvu8vJDBmIwp0TcnCxH?=
 =?us-ascii?Q?pr87w3ihvMkJqzRPfJjJTz29meaEMVWE4G2YueBiFo0qK6Y7O4YgCGhTShoC?=
 =?us-ascii?Q?zz3HIRHkyfHILj8PpwdEQ4puWH+S4wRFwCHiTzpguDJH3xNumFp8zIOqPp8i?=
 =?us-ascii?Q?UniCCjd1wB4V5BcaQVN9G5mrd3J1X6wvCeMy0GEjAagDFaHZoJwDyO6RqQW4?=
 =?us-ascii?Q?Ql6kxgxgA6g4Oet+GM4sNYsgqzBdPMg5jJvoJUlCPWY7vNCiWM37kjOGn75p?=
 =?us-ascii?Q?h7f5IA+BDD5LbzUCMTyjvEya8I6Gd/SP1Ogj+ey9k9qnQ4CqlBywKV/m1XVf?=
 =?us-ascii?Q?iuU+27eMJb34lLl3YhFQjd6DTERW/Hjc9CJDs9fpqVg5t6qhHUr15FJXkF1z?=
 =?us-ascii?Q?PAsOgkjaHjgzkWc0hVdU9YQRRT1XPGJm7s91TH3LorXZJ3wZN+QwcNz1AYrF?=
 =?us-ascii?Q?7EN7H25t1YC7KrFA+nafNaq5yqadLpuYkkvIpoF/V6Id5MRWS83ncuhtssxJ?=
 =?us-ascii?Q?ArJ578nP6SZHw517kJBIdmk+PbbUwt3Irb8sFT4UWEvPB9ZcpLImr6oD+mVZ?=
 =?us-ascii?Q?gBLqjE63CAckOtthjDjAuY79zWr4uwNJhq8NsTRJ0FvpinHeUmUe4dGCRQNv?=
 =?us-ascii?Q?ng7BlTgSz0x2GvbcjHvxzxTSQctoclm8JiOgX8x1RXvx9zvCdpIY+DWlyVxw?=
 =?us-ascii?Q?z5jBUFE9vEfcpfXgcc6mNGJFp3Q5iqfGPJoXWWWHEIkotnu9aqEYqNwUpQJZ?=
 =?us-ascii?Q?eLqnHxbWmg56ia7J1chTPplFxRJdpdTOiPrHwD7ofzLMjxFFsCLeGzakwUXK?=
 =?us-ascii?Q?XBs9V0/k18f4VLmYEIrLxYmbhrElN8SoMDGIUuzaU/2NAVcJW8J0nis+Nb8m?=
 =?us-ascii?Q?uqTg5W6tdmH+wR714cIRHZaswLdgTPVK/5beHXcdF+4uZindX+rX0ccn2yZ4?=
 =?us-ascii?Q?nbW4fy6U8Nv6f0VmOztuujTeUNQ2psGGS/tQJam6eDOQt0+6+6g9iR5oOcHU?=
 =?us-ascii?Q?cMgy515FyIcUG0Lx5QcL5lAvU5zP3/T6OZcR8hw8SWSFH9chS2xc+bIAVpSl?=
 =?us-ascii?Q?6skfVO3VffDJZYREWIs8T3V/nZOS9vFymBXHD2giCfNDrHfpYh0fBEVmXSyi?=
 =?us-ascii?Q?Q2jzdaH/QM9cjY3nlUEHUt5UJWrTwg0uFlno7L45gDrNvdIfBdqWi7P7N1lm?=
 =?us-ascii?Q?9lL+xOoQYa/fzWA2BdqfjwNFe1SoCC7jeJAuqwJNXqUGlAV+C868zjRBcVu1?=
 =?us-ascii?Q?Cc84HsRoXR6FRfLK6jVL5qeE3kk20gdR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:53:37.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d38872-a6bd-45b6-bf6f-08dcbc601da8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7581

The TOS field in the IPv4 flow information structure ('flowi4_tos') is
matched by the kernel against the TOS selector in IPv4 rules and routes.
The field is initialized differently by different call sites. Some treat
it as DSCP (RFC 2474) and initialize all six DSCP bits, some treat it as
RFC 1349 TOS and initialize it using RT_TOS() and some treat it as RFC
791 TOS and initialize it using IPTOS_RT_MASK.

What is common to all these call sites is that they all initialize the
lower three DSCP bits, which fits the TOS definition in the initial IPv4
specification (RFC 791).

Therefore, the kernel only allows configuring IPv4 FIB rules that match
on the lower three DSCP bits which are always guaranteed to be
initialized by all call sites:

 # ip -4 rule add tos 0x1c table 100
 # ip -4 rule add tos 0x3c table 100
 Error: Invalid tos.

While this works, it is unlikely to be very useful. RFC 791 that
initially defined the TOS and IP precedence fields was updated by RFC
2474 over twenty five years ago where these fields were replaced by a
single six bits DSCP field.

Extending FIB rules to match on DSCP can be done by adding a new DSCP
selector while maintaining the existing semantics of the TOS selector
for applications that rely on that.

A prerequisite for allowing FIB rules to match on DSCP is to adjust all
the call sites to initialize the high order DSCP bits and remove their
masking along the path to the core where the field is matched on.

However, making this change alone will result in a behavior change. For
example, a forwarded IPv4 packet with a DS field of 0xfc will no longer
match a FIB rule that was configured with 'tos 0x1c'.

This behavior change can be avoided by masking the upper three DSCP bits
in 'flowi4_tos' before comparing it against the TOS selectors in FIB
rules and routes.

Implement the above by adding a new function that checks whether a given
DSCP value matches the one specified in the IPv4 flow information
structure and invoke it from the three places that currently match on
'flowi4_tos'.

Use RT_TOS() for the masking of 'flowi4_tos' instead of IPTOS_RT_MASK
since the latter is not uAPI and we should be able to remove it at some
point.

Include <linux/ip.h> in <linux/in_route.h> since the former defines
IPTOS_TOS_MASK which is used in the definition of RT_TOS() in
<linux/in_route.h>.

No regressions in FIB tests:

 # ./fib_tests.sh
 [...]
 Tests passed: 218
 Tests failed:   0

And FIB rule tests:

 # ./fib_rule_tests.sh
 [...]
 Tests passed: 116
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
v2:

Include <linux/ip.h> in <linux/in_route.h> instead of including it in
net/ip_fib.h
---
 include/net/ip_fib.h          | 6 ++++++
 include/uapi/linux/in_route.h | 2 ++
 net/ipv4/fib_rules.c          | 2 +-
 net/ipv4/fib_semantics.c      | 3 +--
 net/ipv4/fib_trie.c           | 3 +--
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 72af2f223e59..269ec10f63e4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -22,6 +22,7 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
+#include <linux/in_route.h>
 
 struct fib_config {
 	u8			fc_dst_len;
@@ -434,6 +435,11 @@ static inline bool fib4_rules_early_flow_dissect(struct net *net,
 
 #endif /* CONFIG_IP_MULTIPLE_TABLES */
 
+static inline bool fib_dscp_masked_match(dscp_t dscp, const struct flowi4 *fl4)
+{
+	return dscp == inet_dsfield_to_dscp(RT_TOS(fl4->flowi4_tos));
+}
+
 /* Exported by fib_frontend.c */
 extern const struct nla_policy rtm_ipv4_policy[];
 void ip_fib_init(void);
diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
index 0cc2c23b47f8..10bdd7e7107f 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_IN_ROUTE_H
 #define _LINUX_IN_ROUTE_H
 
+#include <linux/ip.h>
+
 /* IPv4 routing cache flags */
 
 #define RTCF_DEAD	RTNH_F_DEAD
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index 5bdd1c016009..c26776b71e97 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -186,7 +186,7 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_match(struct fib_rule *rule,
 	    ((daddr ^ r->dst) & r->dstmask))
 		return 0;
 
-	if (r->dscp && r->dscp != inet_dsfield_to_dscp(fl4->flowi4_tos))
+	if (r->dscp && !fib_dscp_masked_match(r->dscp, fl4))
 		return 0;
 
 	if (rule->ip_proto && (rule->ip_proto != fl4->flowi4_proto))
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2b57cd2b96e2..0f70341cb8b5 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2066,8 +2066,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 
 		if (fa->fa_slen != slen)
 			continue;
-		if (fa->fa_dscp &&
-		    fa->fa_dscp != inet_dsfield_to_dscp(flp->flowi4_tos))
+		if (fa->fa_dscp && !fib_dscp_masked_match(fa->fa_dscp, flp))
 			continue;
 		if (fa->tb_id != tb->tb_id)
 			continue;
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8f30e3f00b7f..09e31757e96c 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1580,8 +1580,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			if (index >= (1ul << fa->fa_slen))
 				continue;
 		}
-		if (fa->fa_dscp &&
-		    inet_dscp_to_dsfield(fa->fa_dscp) != flp->flowi4_tos)
+		if (fa->fa_dscp && !fib_dscp_masked_match(fa->fa_dscp, flp))
 			continue;
 		/* Paired with WRITE_ONCE() in fib_release_info() */
 		if (READ_ONCE(fi->fib_dead))
-- 
2.46.0

