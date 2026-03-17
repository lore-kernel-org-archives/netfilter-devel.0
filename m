Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C1347FED;
	Tue, 17 Mar 2026 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773778642; cv=fail; b=prL0mBhhxv1K9BGFLJcvn9OueI5XlPt+K5oIkB2z1OcLIMF2UlmhjMI8AvTq1SSuNH+e+GCbg2Oly0rpZLGdu+RGgwjrYTtm9B/gBu/HGdmghdMw1bwDGwh0KobqClKUZ8FCK4rNn29mqUl3869SH0DAPgHOBCjPIM5DQKvTif8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773778642; c=relaxed/simple;
	bh=HoqzypFkcrC5sEg9nWMA9KL9AlPC5sz5L0I/UcLzXzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J/ypOAc9YL8gPSBHO5GGSJXq1TI/4SfCNoXh+983IBXPNR4pJr5hFQcaky25M9R3QZyDko1l+Ss0FKPG1M0SqvNsKo595ks+jT7Y+wJz3cCpQ8SdnDTruObcfdbOXj3QPsRGeGSxOHCzpfSDHP7SgYpdMsXgKih/SXqX4uF/fgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dFC7f1cR; arc=fail smtp.client-ip=40.107.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dFC7f1cR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDRCl3yRwlht0wXAO184ObdJYcjvSwMmgHOnuCvlxuDvOnpmyicT17toNaa7L7tLnurqm+NaoSwAZw7FnIWLo7IQ4D4FADEiwRVe+ukBLQCDvNxaLfByr2cSnEpDBGccN8WUycQ82SnEBwrnlT7Xjmd04eRblnWQFqL2aO4Gme+zt2vRAPbNIS/ugGgvwuJpS8Rr346SqDeOE8iMop/qzzrTaCtKEd66Gyd7o4uitfGZUNi+SVW3xMNG5T6zT0rPfuMEumPd6el/OqsB/5u0NsUU1G2T9k9MzICdJDExlB/nnAHiwnKC1XHXMUjXK4napiao98Ny+Pafa22tXQdefg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1aWs7yI1CPKSMASQi7XEAuG0YHQVgw/MSP96iuNL/I=;
 b=lZTzY20jWOFs5/Akr+rMFz11lYsQ2UlBQLThgeAbc3BaA7wXD0sKq6/vL14QPvKxNInYri1Qi91s2fjoXr26ogIYq6bfO/KAl2g2SORz9COI1ogYVTfi17ZMzulHq8xouPxp5TzFOAmNIJ92XyZ/+xqT/b8j662n4usX31doj1/RyIRpNC4sdtJMou0HOzulrh5rQEGzAIYJXaQMoPAGOE7ediW5B5KQi6Mip/TytpT5MhyimaD+k+LsK+V4U949h0A17CEdXIy/vJJDW258eU3ft4lqk2UWL1NIDCiI3CMw7OxA8uUdW8klnqOgCnidCsoLwTPKWWRHfsg0DKtD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1aWs7yI1CPKSMASQi7XEAuG0YHQVgw/MSP96iuNL/I=;
 b=dFC7f1cRlU1zaqNMq2lrZmdahYz+fNrlIFeEzdxH6re/uAFTxHc59mMxTxONo4Dy35V2encPQXn90sGO99/jkNdVV3cssbg4iS844pLyRLtMsnyS97wms68A0a5RPRrEcXCJA3AegufxB+8TIqcLWjQ+TsolwhqORy0SBJDMC3h04pD6WGT1P1czVZ8Xmia1/dfMxIDqGiexzZBut09Bo0A/P7LjcIOsttzj8Fnhh2erBy3K2agOydOR/pxxdUq3UfdQOG9mUwvEb8O3jQJG3F5TuWEdtVRGNgI/wc/7YB1tyUt5vaJ7uBVvNv3DF71x4AexS/sE1WGSoQ1fpC1D+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB7906.namprd12.prod.outlook.com (2603:10b6:510:26c::10)
 by CH2PR12MB9493.namprd12.prod.outlook.com (2603:10b6:610:27c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 20:17:15 +0000
Received: from PH0PR12MB7906.namprd12.prod.outlook.com
 ([fe80::adae:c781:7ee5:e467]) by PH0PR12MB7906.namprd12.prod.outlook.com
 ([fe80::adae:c781:7ee5:e467%3]) with mapi id 15.20.9723.010; Tue, 17 Mar 2026
 20:17:15 +0000
Date: Tue, 17 Mar 2026 22:17:04 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netdev@vger.kernel.org,
	Ricardo =?iso-8859-1?Q?B=2E_Marli=E8re?= <rbm@suse.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH 10/10 net-next v3] netfilter: remove nf_ipv6_ops and use
 direct function calls
Message-ID: <20260317201704.GB3581148@shredder>
References: <20260317140141.5723-1-fmancera@suse.de>
 <20260317140141.5723-11-fmancera@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317140141.5723-11-fmancera@suse.de>
X-ClientProxiedBy: TL0P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::16) To PH0PR12MB7906.namprd12.prod.outlook.com
 (2603:10b6:510:26c::10)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7906:EE_|CH2PR12MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: 388dc3d0-7d55-4b8c-48a9-08de84622e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mKR828qgL3C6RAhpqwQgOOUsJbOKy0RaglbEyC8AhYYxzDNo4E6djn0aRIoS//u3mlJgTa6UooxUXuAkRm9pt4ZlsBG2miI26i0JtAJxc3Umu9jIxyCzt2spDJzB+vQUsXoZ9uBCzfOO6x6O4Fm+PofSvp4r1EUUyqbCSphGTKFBiaqgiH8+ZA3fH7jbEME7ndtRt06Tm9MmB/0DckKFPUqx4B9kAMFHP5V+GcHiNGogM2zT5XvdcDcBHL8LY/vO9e4VKf/l241WbRPp/yJSQDPRaOlys4pgIf5Jq+Uh55zY4jBxKmhMtarKBW7jGv8gbRPK+crelxTjcSTBO4EXm/j8N1Kfi2gxU9JpdwuAsQgyLEWs58LYWi6i3rmBQJKPVLI1PWKH8EYMeymo+5VohOclAN1ZOMWmOzq+5q+Wg+iXUvjgm1tR5Iy5j5L93HTQqc8JD9SkWHCBPUlPdfzpuSgjkWu39pQTUdh9JNvK8YoKYjLQzix5CONPmO4qh0lPyHjlkslTMduPchDCawE3MXYuFxbz2Lz8hK9X486xETXOEqZjN+pC/1AMB7igK1fnLIbj8iIwqghDIOjY4IdLWWHeUdILZf4pzLEvfVIpriDzYMZ148nTS5GlFV9sKybtjvv4AQOB/xSiNUBcN22+l5UI5lZCMKzWFRAnTQc1gJjXp5AXOmN5DiOqLPBcQs/58DpkpV4wX7ElxGbYuW5Ex7vd+TNxFPwSZoDwI2WXNKQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7906.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fheOrz/Jq6nvKet3F5rVqFcER8qE2MZ8HoC1rdZGJInOw+MrrZgNllG1GZYW?=
 =?us-ascii?Q?1wqNITZ/6kgk/MGE/7T9AxIExKXN4N/n2gQ5Om0K0teTgwbAhvMEesxMSy0p?=
 =?us-ascii?Q?NxXHqDsO4W5edLVM0/PEQVSIj/+UPY+2BeRolpI7hESUvsUvJ0vTabBpjKvq?=
 =?us-ascii?Q?KSRBEhad05PVq0QaNDGxHFwwSuY4Y0Vtn/UIbQ+YIwgjuBdcOz40g99zeNju?=
 =?us-ascii?Q?4JiqvLiFz9AEHtG8Xu3/8B0t+UbNZEYjBtoKcjyNs+iXmEuih0N4lol6pOcj?=
 =?us-ascii?Q?YQ7eVQnQXNTd7/x9y927vTKBDd3uEIJ3mRq4RwsgvxUvvEPI4ou0BKuIwGDa?=
 =?us-ascii?Q?lXWUX2rjBvmzB83HzEGoRop2G2G6XOuEqjoMCAueQuXY31M/RxgxNFgjwChq?=
 =?us-ascii?Q?qGTZJVeznK8Eb5oF41ukdI/P+04XEoob+diNbvUpiTzy3LrW71llmA4nAjtk?=
 =?us-ascii?Q?AMdaK85Y4G5wn4E23gjfDYd7SOwLQlv1CMD1NICkKTLRqUNbsTMy07MBjp0d?=
 =?us-ascii?Q?zjFq2hFpzK+pgM8s0dZ0t61TtTTxr0/VLtHDP6us/HKqdGtpOtg6dpMhVAhV?=
 =?us-ascii?Q?HMUawgPz+XPEzzVWxqxGt0ksdRTy7eHw+FIdVE5HtNvND/zZG3faUenBFFtx?=
 =?us-ascii?Q?U9WEm0U1NHnTMVHyZKGOc1kcAdmeLNbgKkVn9SPktVxEFEaXj9It+iKgnt6b?=
 =?us-ascii?Q?mSPI6wuylqgY3eWbGT1NlCGox1FpoTari/GYX37n37b5mgaudIqEfGoKmeTM?=
 =?us-ascii?Q?ae0FpncsOaQjvp65IuOxJTjkimWlLDVrCocu9zYRSGYiFcRLlnTrizehOCEm?=
 =?us-ascii?Q?9YBMreINLZ8+kPFFEJ0fW/vDL6yF1ImVFuTSMNW4Lv5kR5EDqDCwx0Ttuppa?=
 =?us-ascii?Q?DPShm6PlZ5VQosPSoY0sEVrcErzWhSOJXDgf8oG5I1iM5RgCgFw6xNtKm/mE?=
 =?us-ascii?Q?xeHVwn65R6B7smXbV1stlsSschyA81/ehOGGBprnxGe72uIAw2BpEGn35TG2?=
 =?us-ascii?Q?rHe+xis5YA0f5/crfPp3ktmktuFLp5m8BFFnDOsyyDDHt67zKmrnkijoNmCL?=
 =?us-ascii?Q?CSCJs1jR+Ho2/NQ3mfCyg0LiMo8pjDqOAg2Eu9ITkTFdaf5N57SyALdg3QfG?=
 =?us-ascii?Q?H8iLNsL50yNiqvfFfGwaODXZ9fwN3FEsbTVPSRqHcXhjNZ8NTviScF+/GRay?=
 =?us-ascii?Q?Ueon7mQoW9znNX0dzYrq+ILgohiscbBOWJ6ABHAoxBvMKvEfIjv5WqWBHxnC?=
 =?us-ascii?Q?IvDbklRmxR6Ln4QX24z9yKem+6+izUuWg3dX9ZnnSlVVnXMHxeVLlXcB8gbW?=
 =?us-ascii?Q?dlDqh1qEJlfV9YP/Z/jeyo+W7rk1IJni5Jf53sCcht5HZzrismWSWEiLItHi?=
 =?us-ascii?Q?Jq1k0UDfRA0OuJg/YjR4c6eCi/YbtJkhqACxRllTBmJc7pWAoMCmFatnSTqZ?=
 =?us-ascii?Q?b+9ZouJj75MSbzVtyvpN43HsVGA4Ripf2qBMjsSiU49UzyRufv8n08LKQk9o?=
 =?us-ascii?Q?n7VvDgG7VoxJ3XYxpWkGvMOHNtmF46/W3CUQQtZkREndSJpakX9RxA5hew9x?=
 =?us-ascii?Q?cADUYSt8rRnRv9pFY8u+xlutgzM14bWZmyNxHgANrlP7oMN6M7v5aHzG+qHt?=
 =?us-ascii?Q?+faCl2fsvpTwO1TkGEl3dOTfwjk5nupPMbGGAe5KkYB+YuADgVNXlUK6g0W/?=
 =?us-ascii?Q?PUTuXD/HPav3asl+jw0KGJNWCLxzxwyZUDPa/eVaepAyzsG+yA40nEzxxKcB?=
 =?us-ascii?Q?3xGmUEpBog=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388dc3d0-7d55-4b8c-48a9-08de84622e09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7906.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 20:17:15.0580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnKH4pOtzdpqAk8hh/vqRSijJj7eNwad6tn6rlVyLHG3JxA/Ox70i+wJCciMsHIubfp5Lf1ghhbVclo4GfJdeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9493

On Tue, Mar 17, 2026 at 03:01:06PM +0100, Fernando Fernandez Mancera wrote:
> -#if IS_MODULE(CONFIG_IPV6)
> -#define EXPORT_IPV6_MOD(X) EXPORT_SYMBOL(X)
> -#define EXPORT_IPV6_MOD_GPL(X) EXPORT_SYMBOL_GPL(X)
> -#else
>  #define EXPORT_IPV6_MOD(X)
>  #define EXPORT_IPV6_MOD_GPL(X)
> -#endif

We have quite a lot of these throughout the kernel, remove them?
