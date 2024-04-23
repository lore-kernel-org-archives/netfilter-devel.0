Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C04E45C0C
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713883518; cv=fail; b=oIdnGZAxyZT+47Cv2S9CSkegzAfH1KkLQOf+MPIlhI4hXq74czFL3WbNTSPdtLPF0vGOZSuQivgX0cW4nKzrHJS5XSAQ2YZ8F3j3owEXQoiLfYLOATw79UFji+M4FbDuh+XLlkv6+FYhJ2sehEu4zlVDxp5w8UCT3nCJhY6jt5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713883518; c=relaxed/simple;
	bh=zb5o6r0iDxn0qD7GpWgoHYMy9i8tZJkty1p1kBTSZh4=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=q5fChtXxOn02L5tc50VHf0Aq8mn1Cm3fJaK0l2OWhfKW0bnrFQge2ERer9kowAdC0yVnlFfdevahr+aB8JgF1Nqu9Jn7y+NcDTpD+h0l9NUHIY5mGti7t3VsxItEz/8rMCiIu1gdWfwipVucWOFdZLdkAg/lgWlIoR00QnA9aRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iRgTEV5a; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iRgTEV5a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVpZNEmwIlcD7zuRoyTJAVd5g8pOUiF34T6s2iPP4QM6yMUGc6Ngh4Be+jIffWodS3SaWFpcPNlDjJ2aRxxsv9UJIACgQHEmlVqzs09Zu/a6vzE4EWFt2l6oPJtfX28XKrJXrC2NE/TjtJcYXmRX8pFa8ekE+Vwe5+Ds/EgQlC0v/E1gbAe6vpEddNcqGG/1So3BgdgxiCS89Mhh6eUX857tUEh1yMNuRc3B07HS/+h/OSTQvOcK2OeWh0CrWqYvPR37YckeYxxiLeY0ifU3xdQGpkBFOYyN7yP/lMpXIQIKPPpsXaew6NRw3rnyNJqYJETaXYeOJ/DZDSFoLjHEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EM3seeHs2e5F2Rs5Pw4E4Z/qo2P19RvP91CQoHGyNbc=;
 b=lyss1CMhiRwRdtaV6p8zRt8bYPssaEsNAfjWQK1+kNMEKTQm1pfZAcgsYd3TNr+GLqclKIprhiOKmMGmO/dzAq1eaE4+BV0+GdZwJIp/fBlrpl78PKRtnz8HK8/jN8zf6LFlh4Rh48CDjWjr2LyIkU1pjJ7IjaUMZVZ9jDlCW73OB6aUgMEIFGn3HoTRoYBkjt4J7SeZiwVpBwbkvOJLMZKugh843FPlgS+lLpXQTnL2cqUptbXqr0tz+53zomft6aRH5R9E1dcM3SefAoff/ooj17hwUwdZ0t3VrgwHbDe4cQiJVMF++Cji02Txqy3D5wDQcq5mFAwtZ2YRu1Ibsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EM3seeHs2e5F2Rs5Pw4E4Z/qo2P19RvP91CQoHGyNbc=;
 b=iRgTEV5agE504a57FC9WxyjXzASMjS0er27Jr/Ygbqurk6gXsxYItcPblcnQGSzsbels3M9VTFomPvPC3a1vuRM08IIonTZUHB1rvVO9WkS3n4rq0Bi3uQPpCiL+iRas9+Z5dEoK2zQrUfjm3lR0ch4N2S1N9w0rmRnXVjFjchcpHQKax7Ep15/mT9geOz4nv4QgmqKtv7n6BgCzYcHiYres6mJdUHkXA37VQhWOXITO1HGYkdXlQR4d+7KxF/0dy1CRMyrBgd3ak36UCiYF6F4Uhn3voRBgUwM2Y++ZMSvtOT3wltzPthtnHtYUfDKMQgjYDPGSkD4X+ve1mnk0wQ==
Received: from CH0PR03CA0112.namprd03.prod.outlook.com (2603:10b6:610:cd::27)
 by MN2PR12MB4143.namprd12.prod.outlook.com (2603:10b6:208:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 14:45:04 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::fd) by CH0PR03CA0112.outlook.office365.com
 (2603:10b6:610:cd::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Tue, 23 Apr 2024 14:45:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.19 via Frontend Transport; Tue, 23 Apr 2024 14:45:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 23 Apr
 2024 07:44:41 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 23 Apr
 2024 07:44:40 -0700
References: <20240423134434.8652-1-fw@strlen.de> <87sezc2rro.fsf@nvidia.com>
 <20240423130553.GB18954@breakpoint.cc>
User-agent: mu4e 1.10.5; emacs 29.2.50
From: Vlad Buslov <vladbu@nvidia.com>
To: Florian Westphal <fw@strlen.de>
CC: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove flowtable
 early-drop test
Date: Tue, 23 Apr 2024 17:40:47 +0300
In-Reply-To: <20240423130553.GB18954@breakpoint.cc>
Message-ID: <87o7a02l61.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|MN2PR12MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bfcb137-f0f9-40da-5504-08dc63a3f656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jSoB70pXqNiT1Why8Sc8Y8RIID4/71Fk/L+3NOmvprziuGYJ2LZyB8UMwhY6?=
 =?us-ascii?Q?ElpNpMyg8cyeqKPRELrW3BqAj1o6afOcpPFIXsgwNvUwOM9dSKm4MV6sKQT+?=
 =?us-ascii?Q?eW2HBFO4is4ui9DRDtUrKrSg4ykYqyyV/L/mjJjdKvKpMi6uyg2eDVm2j8OD?=
 =?us-ascii?Q?9MwUmlLfQ9v1Wvb2pbTW+vMHTozLHEWlNPUcHnbTbhWER3P8PEeD297R50IR?=
 =?us-ascii?Q?LsgQlfUXe05S/evytcRLPlXsE2xzJjiBjd0IzQv5fvjNu8tvLdkVVNuEZBdg?=
 =?us-ascii?Q?fGRtQ+s4NL8WQWrUjSvycE27EU75GXml4XsW4fRu9xNAZ6KwMY3WHXzz9KQQ?=
 =?us-ascii?Q?kbNe/t0+67TZVnpPmKfeQvuAKs+sN7tFRdU/30R0UlQOJWaO93QdRtUc10G0?=
 =?us-ascii?Q?9pZVJJRicsXJnph8RvEo91Y713QZmNlffHCYxhww7AVAMIsrT1lHgYWGFuLJ?=
 =?us-ascii?Q?Euo5pZhxuDV3JSngeApvc6/1QVCvRbD3TpStxQ98Snh4cJoW6iIBHmSXIVpK?=
 =?us-ascii?Q?pFtZG6lk5Cg5/EFecYvnZB3/FpwYFEZ4IlwXO4i3gvRNSA7UN71hETJtnDtI?=
 =?us-ascii?Q?4naaEy4btmjTys0FwbMRahX2BTi7aXgbSkpEE60m/MTOFY3k4/7lwP0dnhMb?=
 =?us-ascii?Q?2aZpJ7MHWfYo3xJdi0RbseSPPVpBe0zuaTEX+HmyNE4Ebkn1EBxKAy4j39Xa?=
 =?us-ascii?Q?nqcGBzHXgcbVSG01NmsIk+2BO1WWAYyfbhSZUVHyMYxmoVs3bKyx6IGpcyY/?=
 =?us-ascii?Q?cQWZcINawpL1hUmZdUf6Y1kr185YZJS3qlEwmWHeeYMeaZsjAzrqVWHWl3Cw?=
 =?us-ascii?Q?KakJPa/qYcI24XQUNTR42NFXOVSWd5MZGY4Eq/Lpc+fVS/o38FZAxgvGiC3+?=
 =?us-ascii?Q?Kz/BxwhheRCUFhHBIQJLyg9h4XGosCKiFT5sneDm0NK+AoLD5IVqyj1jJd4N?=
 =?us-ascii?Q?Rv25UbPGAPPhICtfGSqyujnAxKGb+/zXIifJge94HZdTzcKwSFNZcISgBm4I?=
 =?us-ascii?Q?A23si+7CP2hJ6kfLlWK64GRcDk20LaWbgjq8DVxHLY6nrNE5c8FQ6xzwTO0r?=
 =?us-ascii?Q?9I3hgQoO0zd66lG5+VgE9cxt5sTpNH4PXpzjFxVyJ698VNOeXuYbLAZ7rJp+?=
 =?us-ascii?Q?iJJ/eFzigaad/U8G0AIdKaF6D0LfwUa80LJsQABO3ihS7vodvrRbgbxArTy/?=
 =?us-ascii?Q?2X7b9N7yr5PvqJUM+kZcclSApE1NjX8f9Wxr1Ey4obS0gpL1R4RRVstNCmj9?=
 =?us-ascii?Q?pNs+P2Vu+Xtt/r6n2zvntXhHT1MotEL1YkMaCkP6hBNt7E2LpFrkzVv82eff?=
 =?us-ascii?Q?eRzh2npJ972+L2RKDOmhdTQtlHDa3ImHjF8n6VM4P9dTN4kMJG2cZxCCFk7l?=
 =?us-ascii?Q?9VbpLbXZIta9/xwFyswQBQs1VWaB?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 14:45:04.1721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bfcb137-f0f9-40da-5504-08dc63a3f656
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4143


On Tue 23 Apr 2024 at 15:05, Florian Westphal <fw@strlen.de> wrote:
> Vlad Buslov <vladbu@nvidia.com> wrote:
>> > ---
>> >  Vlad, do you remember why you added this test?
>> 
>> I added it when I introduced UDP NEW connection offload. As far as I
>> remember the concern was that since at the time early drop algorithm
>> completely ignored all offloaded connections malicious user could fill
>> the whole table by just sending a single packet per range of distinct 5
>> tuples and none of the resulting connections would be early dropped
>> until they expire.
>
> Ok, so it was indeed this:
>
>> >  and maybe was just a 'move-it-around' from the check in
>> >  early_drop_list, which would mean this was there from the
>> >  beginning.  Doesn't change "i don't understand why this test
>> >  exists" though :-)
>
> In this case I think this change is fine, ie. remove offload
> special treatment, its not needed.

The change will also enable early dropping offloaded non-ASSURED
connections for all other protocols though.

>
> Thanks for checking!

