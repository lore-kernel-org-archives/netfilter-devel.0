Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA1E946F
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 06:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722407784; cv=fail; b=t1ZWOzz8cCLmuW3fEzQKMjQi9YyMknZshoaLPJG3oLBCZJzEB4Z8DduAUK/N5sEQ3QT1iULSJeg8zHJ5uFAaR5jdoPt818O/yrZlDvMxAB+6sOY6NlV43jKQ9qlqzUytTdJsZKkq6CRMhdZWULA/C7k/8oGB3ovhcm9TGXXQD0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722407784; c=relaxed/simple;
	bh=Qg5JerSx48buoLM7Wyc4MncvENVPby23AxHtBUvFG08=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oTR0DKsXPvApHoDtnYFvnGa9+7JYwm/JT13vRxbgHB1BPw7rEpG6PJg7iV+SmOJHg1rd8udFQvYvJn4mczssSekH83RJAo8N7P2/Hbes27gMbrx5HD7f6V7VW0VqJs3/6bRKDmfaT9dqrOjeUD5pKW0+uyYeVEyfraOBlgpIG/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sy81+ySs; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sy81+ySs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfAr9wWMD8EpmiWNdtK6HEpYQRgBT0100keSV8myjOQegpJG/1wTmr0RkqMfEq4woOohjkR04qir+plquUq/gSYmm9PGFBV74lWF9KA3kaH19tvrheF2keUslFMFX/4Y18XJRTPhFfja1RDmuwoRCFwAAu1wZuI4tr1VfzeH2AghMNkFiI30ctxkqdZzH0asSOKF+Q1De9GccS7x3ovcFBCaVJ8xKSgMqZGIt4WxD7BhZXhOoQ4/42HTdqN4pXrwnEfM5M/X0pkcr+QpCu95WrmYRVJCer2A/iggAM/1kgV+88pMOvJ6y3TWOevEdCRdFtRTeGRub3ukmAsNRwrfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIacTMVT+2NVAysjTzHbw0pf9IoKzVX4BLPz+UM4r5Y=;
 b=YaLHQ2N0h81uAWcoXVhbEVa68il4n6UddZSfB/JhwfmRXzQNTV9V1v1mMla9A9NRxHhxO3ar7hHIiVbuKFOcG+O2VZ9GQT3m2MKmxFfLEPzK75dMKRr8OMn5+VYeQl9ruI075u3ld9YgbW9yLUVdGSN+jqZ6BO9FxnjA+iesg7RuTcBcIYXwT8aCziM416v+UxCyo9NltjQL/IodZuYg3zFjJTd9XW0ktdZ7gXykHAzj2R4KmwfiVuXYlyVFCDYVeiKkzxZHnK3KLaL6bcgGrGvzKAIx6hYIDaT+LEA8pmbbES1W/i2ugTeNYtb1n+oWMQZOgxmR8srOsitbSVYI4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIacTMVT+2NVAysjTzHbw0pf9IoKzVX4BLPz+UM4r5Y=;
 b=sy81+ySsbNcCE6dldP/uZSYp1OPtTli+QYWti2RYikYAOMDxWl20dNq9gIohjHtGMUEkych/RusSry6sygVkst8wLE0wPb8ZnQPT5GWfAhcLEHL+2NJ3zlrvBnpKS6sepCI+BK4T1oW6SkC4RJURbGWbhAFOnHW0d4+VkD5RfZ6cwimMqTrDrUfJaLyROObT8qiI0jDZYR4SE9mX4yG2pSU55I98Larlu4RUNAEm7dvkQzKQAMvUt/TRcD5n5LodxPiCfGgPPV1XP1BWRboSk3DJe3AFTDlRhONYR6wQr8KL7sGT30oM4WzZd9TparoUohb7sdmpc6/PBHhuWBOSmA==
Received: from SJ0PR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:33f::27)
 by MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 06:36:19 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::d9) by SJ0PR05CA0052.outlook.office365.com
 (2603:10b6:a03:33f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.20 via Frontend
 Transport; Wed, 31 Jul 2024 06:36:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 06:36:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 30 Jul
 2024 23:36:06 -0700
Received: from dev-r-vrt-156.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 30 Jul 2024 23:36:04 -0700
From: Danielle Ratson <danieller@nvidia.com>
To: <netfilter-devel@vger.kernel.org>
CC: <pablo@netfilter.org>, <phil@nwl.cc>, <fw@strlen.de>, <mlxsw@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Date: Wed, 31 Jul 2024 09:35:51 +0300
Message-ID: <20240731063551.1577681-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.45.0
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|MW3PR12MB4379:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e645f00-6aec-41f0-9d64-08dcb12b1626
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iczQIy4Jf4+yHz790Rg3D68LmUJ25ZQNzJYMmQ8aED/dIfTX53XLFcxVQHoE?=
 =?us-ascii?Q?0IX/uIRw9PyVvD/0NvWHaLRYXc+qFWSskIBUFdI3t6kq6pOs7aZOIriUf5ZQ?=
 =?us-ascii?Q?vJK8c/3gPsrHDH8Zfy8mcj6VmjvEyJNW6v5O36OgYr3QBCg71/cP8YTMD8Eo?=
 =?us-ascii?Q?cTr24N+ErXCicBIi1slU6TQxfxjzU+3jsjQ0Fy1J03QV4lsXDLmdBia1bgYo?=
 =?us-ascii?Q?qGf/QicDMqc9vRY+6BLtGFf5tGcGk3nl90iQTFpClaSoomYZkt77wL8mLpw3?=
 =?us-ascii?Q?IG5oFFvwoK3PDnt4jD9G8td0gqXMzMKg4zFHgt/rPQ6NF/hPVmmWtSaEjkSP?=
 =?us-ascii?Q?2o0sUfjVUOXN3V4KcmhK+hjswuFim9pnkI74cowUAvaQC3E5MgRzB+mhP3Kb?=
 =?us-ascii?Q?TxMY0TXp+/1++dbL6PI77icReB/rVOtofOwAK+G2LNL6XwZC8Y1xu+yEGb6y?=
 =?us-ascii?Q?71hiwCe1nWypS7EsYi43HD4r7vps++gde8X+/7OjZul9dJkDGf6pESeZFadM?=
 =?us-ascii?Q?8DEzS+268PfkpTRHYgDwzp564nCqLmN7jV+9+r2PoWelzVvTzapfD+F9YltB?=
 =?us-ascii?Q?YxJKJ7xecNSTBwMwxTbABm8/1KOxN+grYgZ74KFUpZf8gUshiBsQwG1PF2/c?=
 =?us-ascii?Q?fLk6vZWTaLRZ99tmExYjR0CQJOT27yyUSOFth77zhLrLVqXXKvywYZCJrIJg?=
 =?us-ascii?Q?ue5gqFPXU1m2Xl/l7MOY7PEuLxhS0c+iiOdj0d1Ws7Js6K1JrxePImGvYiTA?=
 =?us-ascii?Q?PQEM3qfq63b72nfAUiWJgL6ClS0+HBCRQeweGEsZ9Ll6Q6GKcWHsdRTRpYZW?=
 =?us-ascii?Q?AKSvKDO8JN+mGT5CkwcR4t1Nq0TrdTD0CdSOjI6m9l/OKX6xnGAVj4l06fz1?=
 =?us-ascii?Q?k5MABLcMvIIOqqj+WN5bBOiCF9Ma4X5Aa5txWFss99U//5/ABccr7omkULBF?=
 =?us-ascii?Q?plwNDmRzQnud/lB8JvGmxStKiPZ4l/6QpCW0CSYxS1NzpLTfv/Qm1cx3ha0i?=
 =?us-ascii?Q?DEm1u6ZyK8udOfniFdR51ycthj7anYbgCbOQf3kC9yBJ/uZfa1/rLuXGRLuX?=
 =?us-ascii?Q?OFJpjSRaxdXFXo2tp+2rS1P0isV+vXqK/uVGdD+qg6pb1Nn483KlRMT0VYuJ?=
 =?us-ascii?Q?eGUlnPCrFdZvxx9bs/wdI2WLJmCfA8qLVcPt+qmr+S7Yt6Pz4h2ro4EPJW8G?=
 =?us-ascii?Q?XShxYxJWnLNugqmRd4c8WMAiJFNQN+MnucRF3Qt85aXSuqj3XfjrUNZLZa0E?=
 =?us-ascii?Q?+RZlgTDJKD3HifYN3Dq0IVBIsgOZLIC9snsLe3Tu69i5/2oLjrX4bc7fRUEn?=
 =?us-ascii?Q?s6lG6TUKVxkVntH7btk74MdgWW3VgUTJo4lUa5hj30mKzVq616L+E1WrK3Sk?=
 =?us-ascii?Q?EeYh43+k2AYpBFLgbARjdPb0s1Y3QkxJi7UvX6KfZWmWZulqt1bbUaK35cLG?=
 =?us-ascii?Q?470On7p0D4pJ+B2f5BtkIXonY386D/nF?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 06:36:19.1857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e645f00-6aec-41f0-9d64-08dcb12b1626
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4379

NLA_UINT attributes have a 4-byte payload if possible, and an 8-byte one
if necessary.

There are some NLA_UINT attributes that lack an appropriate getter function.

Add a function mnl_attr_get_uint() to cover that extract these. Since we
need to dispatch on length anyway, make the getter truly universal by
supporting also u8 and u16.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 include/libmnl/libmnl.h |  1 +
 src/attr.c              | 22 ++++++++++++++++++++++
 src/libmnl.map          |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 4bd0b92..9c03280 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -92,6 +92,7 @@ extern uint8_t mnl_attr_get_u8(const struct nlattr *attr);
 extern uint16_t mnl_attr_get_u16(const struct nlattr *attr);
 extern uint32_t mnl_attr_get_u32(const struct nlattr *attr);
 extern uint64_t mnl_attr_get_u64(const struct nlattr *attr);
+extern uint64_t mnl_attr_get_uint(const struct nlattr *attr);
 extern const char *mnl_attr_get_str(const struct nlattr *attr);
 
 /* TLV attribute putters */
diff --git a/src/attr.c b/src/attr.c
index bc39df4..399318e 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -389,6 +389,28 @@ EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 	return tmp;
 }
 
+/**
+ * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 64-bit value of the attribute payload.
+ */
+EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
+{
+	switch (mnl_attr_get_payload_len(attr)) {
+	case sizeof(uint8_t):
+		return mnl_attr_get_u8(attr);
+	case sizeof(uint16_t):
+		return mnl_attr_get_u16(attr);
+	case sizeof(uint32_t):
+		return mnl_attr_get_u32(attr);
+	case sizeof(uint64_t):
+		return mnl_attr_get_u64(attr);
+	}
+
+	return -1ULL;
+}
+
 /**
  * mnl_attr_get_str - get pointer to string attribute
  * \param attr pointer to netlink attribute
diff --git a/src/libmnl.map b/src/libmnl.map
index e5920e5..cd58863 100644
--- a/src/libmnl.map
+++ b/src/libmnl.map
@@ -77,3 +77,7 @@ LIBMNL_1.2 {
   mnl_socket_open2;
   mnl_socket_fdopen;
 } LIBMNL_1.1;
+
+LIBMNL_1.3 {
+  mnl_attr_get_uint;
+} LIBMNL_1.2;
-- 
2.45.0

