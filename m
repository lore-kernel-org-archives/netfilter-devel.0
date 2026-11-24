Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795537605;
	b=qtLIq73LSx+HVzl1bQ2TIvKYmBqVOzvQ4f5vQTSMlw3zdBykHjQtYFEvFWIWCVzctomg
	 JJi6vOPXhxazNhipwFfQIsPClfwPi1Kp1X5QgTWMRLQbg3p40rxT6fjKLHWtfFroOxu2o
	 jTy8gQH+h4EvdfQcbEQKVxY+/af3eBaohgqNw0eXM8LL0LvTVY1+8zOOCrjHPFs2SbD/1
	 G5XPF7O4t/Aw96GqDTutt3dCFYcMpjFBxeUWRRgWGTyiC3Otgtd8pBilGXfPqQrus+rkZ
	 eAPbes/qMrQ47F8NXjklWCxevKbzRAluk2hE+qieS5FvmgxHCMhO1aSyXclqqMJfgbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537605;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3vQ68VNdOxDXb4S2rebqWRHHBdS4hXmZmINIiO5L3N8=;
	b=pEwQgTsrBMptg0Fo2i9ZfVvEdc1pHcb3a4vLj5OMO2Iia5CIApat2ZEMeHWCOnumXn+C
	 FlDsPhbyi7R26c+7XppbFnRODQ/UC5lCqPcwxwIUdiO7sw+oWp47B6aqWxP3q9ilvrwip
	 uFfeuv+MLCUzlySr/BgmnnGKqlgWlsNOqsCKx0XGMgsXbtWBXumLJ41WOZi7NWNa8PSKH
	 RPlT/WS3Ch/aV8hzaMjROCz3/1L9fU/zICWiOAH0UQQbr/yZyJlryJhfLIapXY19YQNsb
	 hedWlIvlSNWChAs9d44KaLvEBsJGscjp4hNHodx7e+JSuOWLJhLFH0yo5PqQiqpM2Rg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YwC1o1Yj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.33
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41C5606A323;
	Tue, 24 Nov 2026 16:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F41C5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YwC1o1Yj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7VrcMQ4goua/h4vTvMvX8AFjDfxzyYFa+nRgKveOjZXZ9n/jNnyGSYoZH0Z4gHZqAABx7/jtoV26/McudUY8OP0gHB3N0+ZOgBW+tapN0NASYDVllawAL+Uf5ULVdGdx/V69iImK+cZHTJ5kMUaMO0nRLgQvLDIEBnrqUsb2R7ZsYsfMLR0SWTDoqT3CgKldBLJgwqtUIFgS7DFdR6+60p1d9pG1hmtGtNbtNcFR1XxMFKi7ouyRyW4MhzC+z2fbrw+MSon5GvKH0HQKGUBNQxEQ24jJ6pYgS6F6TgRVLPvkAPi/amNvIUCNOHcZWyCj35cniCCF/k3dfnrPGq4qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vQ68VNdOxDXb4S2rebqWRHHBdS4hXmZmINIiO5L3N8=;
 b=BZHiG5OEjeNvrWnrSN+joMUw9LhXtE8SNLf4GOXfnk1WHgRlnY0CXC84nI7cH8cZ1S2sHkuswNeUoLCuR9O8of17yENx6WP3lnbF/LvoQJpqyw/MBZ3Nk+h4xd9GTfbw0F86AXhvWW3o011/0x5psJeOV1qDSTiUL4HTzGqZsmbFBqWzSScGD7fFn1QPyX6OIjvStz5eipiIlm3ifsdJzkton17RWzbE9hNCcvLFPPq6M6Y/eF3WXsiMpi+cqpvL0Uj/9uUgkWqfA4vC41zN6eT4lLjj+vun/oqzp/U7ZTxoK0X/tH7+aovPjrPVCZwsOUccVRTI5mCQctSlZzO54g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vQ68VNdOxDXb4S2rebqWRHHBdS4hXmZmINIiO5L3N8=;
 b=YwC1o1YjhpxhIDFy/TBL/XzxZYtBXO3ZsSYujkzWygeO3OPRGb0+v4/shxk5lbRLNJgTxNGpoYeXnbWho3EJDdu4NHS5FdkvQ2hST01p1yeNIg0vTTYiEZqlAXdMhllO7rwX8NNg94H8vIvKA8THxxugbEZEc1vh/yVFxv4xDOlt+QvSfM0n6qag22IGUyYHPSb7J+dieVZ7ZqYHSIuVtNbGBAN9CxaVEGR/Lfjj51tOLiO6maRiFYuTunDlI8KeCdWVIRxZhjq1NP2/aL3z6Rpp27QlpXwecA6UTsLJKdLFNXsQPd7shHBQQVXCuu3eA8HtliOZ9c2P6yByTbi8bg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CYXPR12MB9385.namprd12.prod.outlook.com (2603:10b6:930:e2::13)
 by SJ5PPFE4FC9FAB3.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 16:26:38 +0000
Received: from CYXPR12MB9385.namprd12.prod.outlook.com
 ([fe80::f8b:8279:83a9:3591]) by CYXPR12MB9385.namprd12.prod.outlook.com
 ([fe80::f8b:8279:83a9:3591%3]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 16:26:38 +0000
Date: Tue, 24 Nov 2026 18:26:28 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Leonard Lausen <leonard@lausen.nl>, pabeni@redhat.com, kuba@kernel.org
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261124162628.GA3992049@shredder>
References: <20261117110813.9894-2-leonard@lausen.nl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117110813.9894-2-leonard@lausen.nl>
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To CYXPR12MB9385.namprd12.prod.outlook.com
 (2603:10b6:930:e2::13)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR12MB9385:EE_|SJ5PPFE4FC9FAB3:EE_
X-MS-Office365-Filtering-Correlation-Id: eefe5641-a5ee-4575-9a71-08df4a47b72b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|261026140227099003|11063799006|56012099006|10067099003|261022075727099003|261028144727099003|261022105027099003|261026121527099003|261021121427099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B8az2u6fMrlxKzxJz+TATX+GACqxYWc2cRCUxBpUA6qhgJht9C8lVbbbkguUL/xhTdSNRjlOWcODUjHeZpfD+xP8H+gITOZaC/XcTPhTPK6sKIHogFAijz5idha4np7jTwyVq4wgjmPkX5YdvBG9mtaCHeGeO0EVE63y8Wc7VNCZx2RGciE2Aj57MOg1+Q3fiduwnUwEdKJwNim6Zczw8TmRKa7noOXIODz06pD8GF8M1yYtZ1d9zlg23oUpVJFGeL2rhVqcBFYQzRIywOMJekvqJcdMu6N0SUfydDVxk88OoKjbF+4XWqRIvvFCSTGfp1P8BxToowaMM8T3Affr5l1WhMBM1PI0RSj+d2YbF6ooBGJVKsJyPCjNoOuKV/zA7oFFz3Zga1ZH/87FXce1YVoSXgMm9xrlYsW2ozxsBd6XwtXhVsm8NZXpPR/hXgfcuEdeOdGg8nMOPcrJczU8sg0rmvGPIs4N/CuqkOyE/nvcSzQIMIffwmWEMWeaMcb1+XeKU8dRJztukJ7mURgj5t2fviPuxpXYl2lf9eHG+/Wqnojew85QiZaTXdHRDmUmXoPQmkgzmPDcN3kkz0/I2zU/oF29PVhbCyVoEmtprQmFipCBST6n3soC9bcAJt3SMfiI2Zf+El18SrFkzDlI9RMOKiftQFNRV8y4ZxDJ8Ag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR12MB9385.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(261026140227099003)(11063799006)(56012099006)(10067099003)(261022075727099003)(261028144727099003)(261022105027099003)(261026121527099003)(261021121427099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jZOpTvexrqDDHUSYmqPmqQq6U0Ljt1q/Gpa/GV54lUYjPDP/hUhtecFvhuPp?=
 =?us-ascii?Q?7X/R5feMZ9CjNQMX9Qd2MPEQCvCMPLGuOvgJVr65J3HwKDyoEvwKSRUiEKVg?=
 =?us-ascii?Q?K14uvKyJEvMu8o+WtOu02RqLpUMSTVoepvxRM+gnnNH3Lx3aXsNjeDmDENRB?=
 =?us-ascii?Q?K0iexTAZVyY4x+qqJPghtPcSQBJD4BVcrIuZyNY/FVQStT1sxB2PTPS467g+?=
 =?us-ascii?Q?UoRgfh8N69u0J7DtEL58rKxcF/Qlfoa43C5yrd6vec1h4A6OOLgP7SGlUxeK?=
 =?us-ascii?Q?jZoIgZCj9e/EKAQSVJsz4t27GvJ2P4BXK4mp66B+3oWmMZqbFSeGDpWwPazd?=
 =?us-ascii?Q?W9JJgzuH2aLwgW3J8EUv2Aj4BMzKU+A10IYFk7Easgii+W8vEqSpCkv5BiUC?=
 =?us-ascii?Q?/A+8BpSIb7RLpB6Y4/AGpJpBbYYPvSQ5wbG53Vk4dEk1E1r9yEisWiRIowbO?=
 =?us-ascii?Q?kJwqZwVeUNqaUcNOMnWvX1Rs1cLdqafYjNJWQJnVtPBQRYZpOakwojgm6Opo?=
 =?us-ascii?Q?Gamx0TrnCOqe1vna0jgaP5Y+21/JNanYjWoWIQ1m6yjvTfe/MliErGizOpBc?=
 =?us-ascii?Q?JejAri/cSCww1OTo0/MdMAm9BTX5MKgd6awH9zHA6qLX5E9uIR1sHdi2slYh?=
 =?us-ascii?Q?uhWiq+fvUlVSHHnyiT/EjDK9LYL4U38JluO2B+WLdR2jk+OPgpkyovbusM5I?=
 =?us-ascii?Q?UAnWyQQKLRTRgMY/p35CQrMbTS+oxxtQynvp16Y+ODFZ/Gb4C4MwDpDbnP01?=
 =?us-ascii?Q?zaPByKw+Wxo1ahVjDeIjVxyzX2gxPBgZMyi2QTMLmk0+UQHyBpDEFCeF0JdZ?=
 =?us-ascii?Q?VizGv6c4gYqSSj9qUmFh3Sttnk8Bamxcuh/wlvoxqnStRCMsHIsQKRbHAU/R?=
 =?us-ascii?Q?cvbPrw7/AQ08B1H3I5v0EUFits5wviArCfE4BYDRYnXAKpmM2mpCULkeFMYx?=
 =?us-ascii?Q?BgDk8HLwLScJoJVcR9QTUKy775xNEC/hTK6EyGaytYCnZ2IcXjumK8amghd6?=
 =?us-ascii?Q?X1+UhMKzOs4oVyu7aDfOzLHQf4LGqRHqnpv6pafcvHDUGl5OaSeMPj9aOnij?=
 =?us-ascii?Q?ZIzp+7znitxf5LOFnLPxWimgMthFGivlhfeAsAoMCueL4QxJ0af4lR30GMRX?=
 =?us-ascii?Q?RagUebT+Zv/THo+PGgfFlo7FycGtvbgOTYMv8s2gp1LXxlUKFxtJcQoq5HrF?=
 =?us-ascii?Q?Cd+A1NMwcLI4qde3Dg87bfeUATYzNtthtg+RtD5inmZR7XVK01ZMiJRqgLQ8?=
 =?us-ascii?Q?hbhZkETDkD5fScbnubMsh2Ly5eXkzcSXlOw9GLM/3oSLR02pmkuHeZWYe4Tp?=
 =?us-ascii?Q?FBytXFW2/ow/B6+U5+fO9xdlGY7k8mQReueH10VMCwf9Qr8SXhzJjMMSGEmS?=
 =?us-ascii?Q?u9iSy1wQyrWfIVqVSmUjIGXunlTl7AcoHP/OmbcuAGItCYFpRj3dEiIlK9M/?=
 =?us-ascii?Q?8/yPdE2MzpZY8UjAT9m+nBO5FfgQRVu2JDpkI+o5hd0pPfQAtj9O1FNK+XrP?=
 =?us-ascii?Q?DKjRJWvE0sDwpt52U0Y3avaXPHOyDgVQDc4xUxqo56V0l+a8dDxY9HRe35aq?=
 =?us-ascii?Q?GlGDwRZWpOt0OQBo5rBtycV6GI/c7VkBqtu/ugmqU52qSuOcgev0HtwH8/ZN?=
 =?us-ascii?Q?RwYpq0OkpWKmlMelC3fLNDkIAi3hhxVrQGLA2tqW5NCt3UHy63AiviGMM+EJ?=
 =?us-ascii?Q?cOppRPkSnA0ZCmgltAujYvE3R+K7B6RStmaRearMA2yGU7QW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefe5641-a5ee-4575-9a71-08df4a47b72b
X-MS-Exchange-CrossTenant-AuthSource: CYXPR12MB9385.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 16:26:38.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmTuadfMY1daU/cBvuGifbLXWrg9z0b0EOL6AWFoFwAERdzm04X/j48+xtvr2/g6YEH3goNpy2XxSbd0YuCSWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE4FC9FAB3

On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
> This revision removes the cached-exception patch and its PMTU test, as
> requested. The series fixes the nftables regression introduced by
> 1c32b24c234b and leaves dst-based prefix suppression unchanged. The
> cached-exception work is deferred to net-next after the fib6_lookup()
> fix is present there. Interface-group suppression also remains deferred.
> 
> Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
> terminal reject results, including blackhole nexthop objects. Patch 2
> adds six checks to nft_fib.sh using its existing fixture.

Paolo / Jakub, do you know why this is marked as "Rejected" in
patchwork? What changes are requested?

AFAICT, there was only one medium comment from the bot and I replied
that it's an obscure pre-existing issue ("throw routes") which I can
follow up on.
