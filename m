Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39F1224D2;
	Thu, 25 Jul 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721913539; cv=fail; b=HwJTNjgefyOt5JutS/VF6xzlUWsyNIuuQc92JPRAR4GCUt7nyCC7hcn7OGiac861yy3teex6JUOWLecFiOvTYAN9MaSGKMLK9nGc9Fr3HzgbSgY2wSIkwssCTRRsIpB8VEw+aYRvBNWI4PVsWBvVL5JHd67MNO3DafHOs0xi/Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721913539; c=relaxed/simple;
	bh=SHNI49nLPzrFwO3696vHUh36WwSCV7cSxQhn1mNykCQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rV6cEaAdw0xlzQQQtgV0pkhBeo4vM+Ps3S11TkAQSo/udp6q5lXZ+M5x/5GWa2qWydL6KsLzsasQhGEZgOqXIE/sdz9g4r3zUTKNqHJFj27FbSoWEp8DOaYRQ1R98Lmc2c6F01NWd6kqVoj4l77SK9oAXwSyeVxi1OL4AUcNcdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lK/yHxIp; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lK/yHxIp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNolPBfrCHzOA3dBCywGk+Rvu8KnKaW1KS5ST/4sWyuQd08OkUJrM8BUPfoAzPZq5M5SudNtrfnlufeOvKkAUjH1YCu/xBxp5izkjs38l+ryDf5mBdS314d5c+pw45UBf8Q2IX5B9CdOGZwcaphNX4ZuPk3OC+qxeMErZk9DG6do32nA+0eAC80KJSTrL1FSG7gluAr4ImvbCe1zw9BOIbTflnNTaCpCHoBNI2KBiJu48+xtkjR8XVvrTKS4HathcSo8Di6slf+xY7PJB8FUyxuqGkfDuyZ9C1OkbQ8xl8DVSibeItByZk9awbabbNhVXtrnrrlHjtTYGEdwZOxZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TBiWNrb5B+FutDGxOvnchnbGUshnNaWqYw0Y3VVQtA=;
 b=oc4zkwHxy6+rDHx9lpqarZpeWBtqlKIwiFAbrWAh4+M2FXk3sexV3urwwp2WjtoRynn+JECEIFtbCXu+5hlKCxz7MkWK0/ejf/q2vqWeWX2/NGVpwQ9rTxhJC7Io3Si2DLVYaFvGnd1r2+TiC7wYEv9dhOaNY+B2d2e9d7pBmHhuAExXkjPaYxmqC4mGvhggPx8g3ls+SaIFmWszYMOBgX+z9J+fsDB6WqEgxcOKbCGTDLYFGVSVy3TSriylPlQID7XDoYn3vabFH7784dLOL3hg8Sxae3KgTTHRQmxs11i9/r6Z7GnTF6/j7et+c9/YuY68kBp899EZg5QEosUrhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TBiWNrb5B+FutDGxOvnchnbGUshnNaWqYw0Y3VVQtA=;
 b=lK/yHxIpdVudNhQzorCliMY729jSjFU2hoXFEQQ7krjWML7FCc/OMjB8+R9o6mfminLQH3LIuFU66RiuHkq4IYDUyWNSN0SmlLL7lpDuCqJRyl1yHfNHSnZcWMipIaqeVEb3YJR6SGtiYdyzwHxYX2YGms6g1wQ7QCePfRz9E+mPdAP2BTfLd9zk6I3pCDy0DHFpVBNON89JCGl5BEK7TcmUOQ1W0WJ3rO7NFT7IUWj3sT2s5FzKsu8oUbQdJtSeVgpCgpYQC9kr8XJus2CQPx66r+JkUbw01TScqOeu5n9+VMDz4cHk4TCIVmPRI8Yq4jCSuMWmPuTlC7w33d4RgQ==
Received: from BN9PR03CA0448.namprd03.prod.outlook.com (2603:10b6:408:113::33)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Thu, 25 Jul
 2024 13:18:54 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:113:cafe::21) by BN9PR03CA0448.outlook.office365.com
 (2603:10b6:408:113::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28 via Frontend
 Transport; Thu, 25 Jul 2024 13:18:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.11 via Frontend Transport; Thu, 25 Jul 2024 13:18:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 25 Jul
 2024 06:18:37 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 25 Jul 2024 06:18:33 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/3] ipv4: Centralize TOS matching
Date: Thu, 25 Jul 2024 16:17:29 +0300
Message-ID: <20240725131729.1729103-4-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: f69a6125-79d5-4847-8940-08dcacac54f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ShBK20uySv0giFVNYFkuEOc2BbGt58fI3b5AMfQiwhNB+twBXrTJ0E3tR5zc?=
 =?us-ascii?Q?lNctrXvkCl6MizgU4ObprV+7Ylz9ZdHPZeVWnD65DJoZn7/8LzeSoWO8hX/c?=
 =?us-ascii?Q?Fbp9G2hNnu6cb/nbAo5/rYHg2K8/mrp5OzIXLdLVzqNP2FnHH6Env7QiPNWV?=
 =?us-ascii?Q?tI6i0bSpXHkc1yhYnedA394vcZILQbMIgYtQMrPz2Jx2zOICqWBeyCpUEIGH?=
 =?us-ascii?Q?ws3QtcLE2nDLPQ+CtAlO3/5PWA+0BQC7gM97GMYUQfmuKsckCADzB1CLTUV6?=
 =?us-ascii?Q?zM0ngfGqp5Av9djnDbMRhAb2pbWm87tOrwWOSJmodjhS9740gB/rIb0JBNsG?=
 =?us-ascii?Q?vSb8a4YSb1c9Psu2NrvmwOiG9ntrrVWWsWei06rtb1IyZZ35T9GzH7bE5qGh?=
 =?us-ascii?Q?1NFlY41CG4/dEtpGGdO5CUM1zm6l0lOilQiyeI6ANC/9WnTsFvDHl6ohjWnr?=
 =?us-ascii?Q?JN5k2I5RVmEMSOq3Zr6bscsQwJvyNfEYDz6kxnlbeQ6m8WJq+TXOj0jGOKcs?=
 =?us-ascii?Q?d1lw62cjfwo2jzqoUsgywN91cGqQRlbQvKiGTI4J8uQOr21MO7wSHyH2KTM0?=
 =?us-ascii?Q?KGuuSoOF4Lg2gsOMiLXo4LAn7xPNcNgVmdA2/mQiYbXP4dNUOIFcDkr01slR?=
 =?us-ascii?Q?Y/NFV928rgwmGVnnce9alebpn/44wMGKEsNBkezDP4iWCrHrzj3mHyTJEjOw?=
 =?us-ascii?Q?xfQPD6CoCq8L7TEYVnj2ix0qyF7rmaaO2ReukkHLbB0pIW1ocFIfaawAiUiz?=
 =?us-ascii?Q?ceZy+5pJIIevvY8hzlXSGznzmeDPXDh/6575tYW2Qoz6/tiENzhJ+U+1a73u?=
 =?us-ascii?Q?ciAR3Gr4+Jz8CtZ9WBgQZr65hUqM9D4Hfa4mW2OChQKl1cNEnDV1YnSjso46?=
 =?us-ascii?Q?b6PJN/C+kW4/UEGt0WDhS5Hu0bLd8WZUqidtJwAt20gg4kQTKejYrsog3FEv?=
 =?us-ascii?Q?Ib3kbbG5cmlNfy/pBMiS5a7XBzC43fGHNggy9bvf5+QG4waJ/7IjDTEGr8OB?=
 =?us-ascii?Q?0+Jqc//RUjbY++vsVORr+OuxwivXPN8EdvRWcb3+1zYbcAux2JGJu6nAVQ5V?=
 =?us-ascii?Q?LSCiVhgFH7DN1wtwU7AsloT6wSKAVNC2leY4THogFa+uNJP4Bdlas9Gy6GvA?=
 =?us-ascii?Q?xWoK04F98J5I2gVp1N/7WkEOfW1yRY5J53JyRzXhdCLYruMyyp3JGziZfgXN?=
 =?us-ascii?Q?CxKJb27EbdiIkOpV7jEBhjYpuXh9rMPckzdTj6nguVMdlirjtFGTMk3fgdyt?=
 =?us-ascii?Q?yGp36XFCbE8mEuHkkPpIAP+sxqlSFU+guE2StU8439zP21KJJh0drfYI+Cwq?=
 =?us-ascii?Q?WpJtBXy6gJJiSHgTTjtvrVnkM4PB6J6CGGSLyZhRvP9W6lSwiNt9wNT4Iu2+?=
 =?us-ascii?Q?YIjbh/bvoRdiBRg4Qn5jkHcJS4HEvyhQSefZfmR+kOVGypgC4gJSi3RjO2H8?=
 =?us-ascii?Q?x5RQEIKCpY+Pdl5FGKafINuHeGs74g3F?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 13:18:53.7960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f69a6125-79d5-4847-8940-08dcacac54f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

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
 include/net/ip_fib.h     | 7 +++++++
 net/ipv4/fib_rules.c     | 2 +-
 net/ipv4/fib_semantics.c | 3 +--
 net/ipv4/fib_trie.c      | 3 +--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 72af2f223e59..967e4dc555fa 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -22,6 +22,8 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
+#include <linux/ip.h>
+#include <linux/in_route.h>
 
 struct fib_config {
 	u8			fc_dst_len;
@@ -434,6 +436,11 @@ static inline bool fib4_rules_early_flow_dissect(struct net *net,
 
 #endif /* CONFIG_IP_MULTIPLE_TABLES */
 
+static inline bool fib_dscp_masked_match(dscp_t dscp, const struct flowi4 *fl4)
+{
+	return dscp == inet_dsfield_to_dscp(RT_TOS(fl4->flowi4_tos));
+}
+
 /* Exported by fib_frontend.c */
 extern const struct nla_policy rtm_ipv4_policy[];
 void ip_fib_init(void);
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
2.45.1

