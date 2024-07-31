Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D29208A4
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 10:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420612; cv=fail; b=EQR2sLysYxjxbtecU2Ba1q0B6AMz1yNFSb9o/rjqEqtvTfKfogGvVPP95LpkBWQVZ5d6SqQFyuSSqOf0IUY5CKtV3uejEdJkBTflnf5wnApOsBhPQnaZqwSRSXO3EgXCsIgLmS8cJPq04I1Jx+6rCKkYBvk9K1NG+fIP/3Zn29w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420612; c=relaxed/simple;
	bh=u5FV4R3ciYtopVZA8mSIGcndTTZ2oZv5N36bJX1qGnk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ab9OZRM4JCdA/jItYngs9sXyrrGBqzDQNrnAp3+vrc255RwsLDk5elimGtHG/rKEOo6gGXzVAmjFZrCzclvxV4TQkgcy5CfGI6J1GPo29eIN2F+ujKaXMyvJY++7DY8TDXXZjSrDBnkgk3tzKtHb3gRg0Z/4irdySW3aDYViPJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dWYGcBm4; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dWYGcBm4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbzNCEUYJrWIin8FSZB01HAJysO8jq1bXiwvPBstNa0tFW7UHRQHk+U491vHJM3yyWuQFguXxSV63fG+/i1G4VttWPuFP2IiC6Ia4KzPIDlwVJQPaPi/KjCUJZIneApgRGpXH1LDMnNLJBg99mCAy2GyxwKV7TC1sjaFFuRDTvzI5Yt7f/65iM7Ll83P8DSnbqg51FP1wRStbAqdhGKyySIAY4J7cKhKxmD7Shqk9XVSvILqVlwol7d64MHBxFYQqyM/3oM0VwPxdwMhAhda/V91YEq50jw9hBEAbwWy1AWIV1A4aQKgNuMIQ3WE3170i3LOrfsWE6OUzdS8+tvTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I1oDFa7uW56PxUjUgUMj0gL5Qe90EVqHz2oqdxBbHw=;
 b=BGNZ8TNdQynkC0Y3TFLHPytTWWmUCDmqVcQWcHQmE4y57Y/dLkzR75frAFYqx96XvCwd4dOud86ujD5DLeRong5DXIgTajySNPrxKmJ2H02AJF4BN7VpAVlj5cW4h4S3CYvJrTqd1RQHv3rBUaTrJHCjibAQOuJo0KBHz8MxHJj3rHqpA737aOTH6VJU6XKF0Av79DdKtof8Ys+6VTAlC/yN8BCW2/1ARDmR2zzCVYtW9ZDxqy3JzGoFBgDD28zjlajTPMrEguugfnUVhBRCzr6EphtkVuGB1ousYiUoLm1A8rmYu4QypkhM2hWcsc77uDfW/LwOXsbYxfkS2Fg7Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I1oDFa7uW56PxUjUgUMj0gL5Qe90EVqHz2oqdxBbHw=;
 b=dWYGcBm4n/H54kQXKcvXkB/oTAUhQr2wXIC6AJorHtO2wKFYoSDTmvvKlpyyznsq2N4AGkPNFXAdsGcQYHM20ICpG3GTL0wHxB78w0usDyjqHV50M95WaC8CDq+SgcXz6Xd97hsISngYQn2mb8db414wRO5U8GTU+bl4K23krq9bjoiALnsSo4Uf44XCxi0+2eGCznSegSjSEK7EM2/xDvZMA8AsdAbpCvhtjNVosXaYZJ4L3rDUnok1zsFrCAQyByfXCCajO3Ty9X51a57xmS3/vL0nwjzGPp/k7g066ljz8DDw1RXtGLz4o2J+ur4MddjdJ5CJZpZ4CdFAec9tog==
Received: from DS7PR03CA0045.namprd03.prod.outlook.com (2603:10b6:5:3b5::20)
 by CY8PR12MB7633.namprd12.prod.outlook.com (2603:10b6:930:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Wed, 31 Jul
 2024 10:10:07 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:5:3b5:cafe::f9) by DS7PR03CA0045.outlook.office365.com
 (2603:10b6:5:3b5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 10:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 10:10:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 03:10:01 -0700
Received: from fedora.mtl.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 03:09:59 -0700
From: Petr Machata <petrm@nvidia.com>
To: <netfilter-devel@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>
Subject: [PATCH libmnl] README: Document the contribution process
Date: Wed, 31 Jul 2024 12:08:50 +0200
Message-ID: <20240731100852.817701-1-petrm@nvidia.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|CY8PR12MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: eef0df50-0370-4ce7-b520-08dcb148f406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gEweQ34rXiLskBGHNDaF0VHYGJ0/aA0qjlF4LeyKym21aL0rj3Z/ikC07rFv?=
 =?us-ascii?Q?GSo7DZsrHdS0Rm95J1bcUIx6r61OWkhnEma0WgwO62E/MPYxeQlgz5MWH0pK?=
 =?us-ascii?Q?vWezMgEEDTOsno3wZRF2hpDfewTFynKVB++qtwJq87BnO+N30KrOnN/aVEAz?=
 =?us-ascii?Q?AWxTuCcOYX2bhcn6EP0jo3zTy8U6KxDrBBYdwxUnpLzFvr69XgxsdTWNY74C?=
 =?us-ascii?Q?ktsWJwsMqOkil87wOdzcBQRORkaIn+FOcVkjnJgEMK8h5zCwi61kOuzhJN0L?=
 =?us-ascii?Q?71UHcgLTT+Ci2xfBeGH0ZZPuYLj6DZTbNhJkF8IXnrjP0M8g/zg5GtYg849k?=
 =?us-ascii?Q?gUz4xDV7xzVRewdTtxILw7TS2knQiPt4ItpDsYPkgdj/WdEOAjHZXgsMPV5G?=
 =?us-ascii?Q?U3FF3r6mCZl0E6WvfrBHgqhcbYxx4zGYS5Tp0RnmGJ0y2QogpwMYT+LcTzKn?=
 =?us-ascii?Q?vEzRbOm0KJL4b3Ds+lRQwDPLoXLPuGfKesleGTKWfvv8gQX78jAplN5LmhoJ?=
 =?us-ascii?Q?oZSIkI3tVLfHp0a09+qO5cUuzE/WZ1U+IksPvqxHF41yDUuGW1Z48j9kF5gZ?=
 =?us-ascii?Q?1R04Y9FgyEvXUNu1NiEoxv0lzkTEneCscJKL37rMyooB5idGzi0CEy6ZENqw?=
 =?us-ascii?Q?9QttTrsN3CsvLC2XGfjMEZzB6z9eeZlBJNjNDdpba49VAvGz15EzlRQ1ryl4?=
 =?us-ascii?Q?rg35GQQfdStsnlnfXLAvTaj048HPyvHcoBKWkbUuIRAcqGjlYOKKEEtl6478?=
 =?us-ascii?Q?HBBwERit7CIYMS33jbpNzeqlFXu04eZSQmp3FrkobGRWwtMLWFX9AgUbJpby?=
 =?us-ascii?Q?UulFdfWkg9WWpinXNRA8Vud9XnAL63Y4eK3h1nkL1KeC8RR44Pq20rHFH+5J?=
 =?us-ascii?Q?9kL9P8GXgvTKRLnBLBbtZQ1DPHKtndEPerhsaR3dk99E5LWqXlEF9951Evsh?=
 =?us-ascii?Q?KtPIj1vB0ufk9IjAoUDDHl2yJ5kE1hi1Xx1JQjbqzk/v0wLCRSGpND9sjAIR?=
 =?us-ascii?Q?Egx0c7vIDwSvYGFTZfmDvtvErXvOuCHL4JtkmWdzFf9MaUUD7xR7mjgZOsII?=
 =?us-ascii?Q?LOrZAPcoGihraaTvh0K3IV+e+X/X52GjnD3YRksjsIuozTCXZs9f/0j8xlGm?=
 =?us-ascii?Q?qS297QKk+1MILHPvzfAZSVc6FHvVxN6kkcxITsGh9FYlpa7QruQh5N9jcRwb?=
 =?us-ascii?Q?Q/XEuF02RCNiP4Q8ukiPxSbfX5hWNV49STCDGEy/v6bLknDrwm1F29Sb3X1j?=
 =?us-ascii?Q?QK6ZNJghjHDlgqh0Okunw4WsPRMTcU9ULMd2fxiPEd9r+6AOc8AByZRJKnqw?=
 =?us-ascii?Q?Wu8H9dY61AJ9j9ojzvEvTUIERPYoHatAlt+VDdM9tV2at4PAIqM6oPvyMoJT?=
 =?us-ascii?Q?dpozVbx5U0CskmPXZ6YQG7wteTw41/r3vVymjRflDkK80povTkXCXHiAczkT?=
 =?us-ascii?Q?Qtg8ebbDTwFvspRAW2ibB4s+Rcvr/CTx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 10:10:06.8203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eef0df50-0370-4ce7-b520-08dcb148f406
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7633

The libmnl patch submission process is currently undocumented. Add a small
paragraph to README that deals with it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 README | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/README b/README
index fbac9d2..317a2c6 100644
--- a/README
+++ b/README
@@ -23,6 +23,13 @@ forced to use them.
 You can find several example files under examples/ that you can compile by
 invoking `make check'.
 
+= Contributing =
+
+Please submit any patches to <netfilter-devel@vger.kernel.org>.
+
+The contributions should broadly follow the Linux Kernel process, as detailed
+in https://www.kernel.org/doc/html/latest/process/submitting-patches.html
+
 --
 08/sep/2010
 Pablo Neira Ayuso <pablo@netfilter.org>
-- 
2.45.0

