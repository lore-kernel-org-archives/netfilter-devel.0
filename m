Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCA63236;
	Sun, 28 Jul 2024 10:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722163877; cv=fail; b=e6pHy+cZRW5WbqvI3r+6SOU9NVtvGF8kQLSKEb3ul/Zb0SSedpzQQgirp6O1b1ulQ0x3dDpBVcp3vvi3HN1Bim7sQqto5GR/U+zk9Q60eAJ0Dc17WuZNYLwokUwwRf7qODfSFMdreWZ8edMRtAWukXDOVQzUYW/78hZsg3pIBA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722163877; c=relaxed/simple;
	bh=qncp+prAV+IdwSasiZ6u7hxH6M7fWpJHVe9KonDVnrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nq0ubzJXWg59uu32CO8T1NVx+hJorbCzIdsOsZz9svrQyLKzUp65X8giCB1Z6YVoKFsUF18/xKRsNXVVoMg/xBKzCor1aeawYdaEhfiaQpnF8Vv10RNv3hqJIxKCX4NHK3LC7Y8W/t3ZVm02NICV92QvJoReM06zRHaK3+3q43Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lHVxFae9; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lHVxFae9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuxOelEAkO4nCYkXjO/6E350Fc+4Lwn2JHKULX4USjq0M5JOq5ANNoUJhs2IM+nFtSIjnR7lGjMhz4KXOcUGYVfWB5N/xSqlYa/Us4ei86iMAdQQCnn5t18k9rQkCTIbBLsyoBzjE7iNnV/VArd3EOCxR08fYtv6KDNWjlE/5i2izWm7HiTnjtJmYB+b0eZGVBC6loDiwFBzWOsPcm7WJq5ug93kMb+8v84rGF0wKJKs0/X+l9OGhZikq+Ykojydfy+x1bOypaX05Xj9G4KUelEiuGIESyFRefD6h6dbCCrjfRzEv1FdPK4Zfoy5JORr21vMIxg9Or7FIY/CooLPUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PETfBZC8+mmkXQ2iTKkhyjtilC5FEobxwxGEnHySxj8=;
 b=aoOtxFkAquFsJxfsEzStMCJMonxl4wsqqqS+hNLzuKh2MBOXUqy1GKgQDlIqPdzpr015ijp/Avw1qoZXS8fgH9Hf7PzZfcnUthnhoeOguCtpH4nnAmULrxlnqZ7VzKO7QtoE69KPEVRAA/JIMxVozUQJEkl7KG6uy34x9ji3+wG5yQ1G6kRKQDRklQwUV0ybOpUZ+BRjqiGqVtOWC3raf7VrTFOZiwQD5RBBPyOt+Aif7A8QVHusjmAEX6uvn9BWPKzLfJK4/1V9FZ33RCD2UuDz8/9S7PR4FCv+ckhjdNzwlyLgqAKxx1Ysh2ensq9cTPw+d3z1pqIcCe63Gos5bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PETfBZC8+mmkXQ2iTKkhyjtilC5FEobxwxGEnHySxj8=;
 b=lHVxFae9E5m98HPyo2fpzLLXQYvs1/4aWKGY0Z6n1UeXMSonBRlJjGdB8ovYzP/lvlLwzl4i7rpa3KPHbZHv6Pz12GtEXv7w5Wb2wHErLhkvpNsvDNFyU1b7W3tgk9ulMEwci4oZuWrNA761LhcLtGCqc/jmuHXM4ZSeR4QJWWDm3B5UP4Cb5hF1tEKgHqgtx2ALru7hAFBlg8zDZjGYyJtCSYlDILEOncyePtWJT91fdhPDbDDQN/5ApAGA1uiZrho7LZDv66vtwulJIqOE13xPxc8Ps3m6mEiZvh36wOcq9GYYDXEj+FBSbbBPYt46ak8xgDA7pGlYI2cffvKE4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB8037.namprd12.prod.outlook.com (2603:10b6:510:27d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Sun, 28 Jul
 2024 10:51:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9ec8:2099:689a:b41f]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9ec8:2099:689a:b41f%5]) with mapi id 15.20.7807.026; Sun, 28 Jul 2024
 10:51:12 +0000
Date: Sun, 28 Jul 2024 13:51:01 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, gnault@redhat.com,
	pablo@netfilter.org, kadlec@netfilter.org
Subject: Re: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP
 bits before FIB lookup
Message-ID: <ZqYilVe9eW0vVg8V@shredder.mtl.com>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-3-idosch@nvidia.com>
 <20240728023040.GA996@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240728023040.GA996@breakpoint.cc>
X-ClientProxiedBy: LO4P265CA0109.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: 641e3b7f-54a9-4ec6-3378-08dcaef33225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JBrpzAbXVNqwBFoncnOoIVcaQwa+bJL3O26WpUAkc5mFc8V/EWIsaDN4EhWv?=
 =?us-ascii?Q?x1QqIQ3L+p+TlhknbvMJlWyRUziTvIwZxV0uPXrUPnKR2Almv1ST61ZWYTrC?=
 =?us-ascii?Q?oOUftKYaicAP2ck3M/qZep8HFG6rbpwpLbOVTSLHKSRvn7phAYxE3hYjDVFL?=
 =?us-ascii?Q?usGKO+SRSb4dXHoPrspno1yklRdoxp0PUeIN25q1cU1qiqmJMpv+JFeAPFLl?=
 =?us-ascii?Q?wbcS9xhKHc+ddyQVsyUjTZvhkmxQdTZLwQH+auUJZ3+RWYkgH++22o8irln0?=
 =?us-ascii?Q?fypoW7hs8RrmoOD1xQ23ajlNoqbJsth8ZMMXhFFCLqFDVlJWkp7l5gG36EDz?=
 =?us-ascii?Q?48OhK6TqlcgUeXzWZZHLXz+xw8JhlrZWsTl4i1D1ENa3n+xVZgDutBYCsLHy?=
 =?us-ascii?Q?Z6aXG/mvwGB9uV2NrZlW7Mx0JNm5L1HdaQgx0R2YwwUJbpMNayc9AR300gjg?=
 =?us-ascii?Q?P8pcx7eRgzK7N/PGshTYmc2CpCAl4Dw2fe3UewtyzfjpDaeXQh2lVxZCVE0p?=
 =?us-ascii?Q?JTcVgB8zkCQoHangEJTYTbox49lOpxzcYRblXOLC9ItgRtBR3tl0tzcUHY96?=
 =?us-ascii?Q?TsarFfR+O+URAEWAkBgcQDWGmjdzuoBjuXS5b+W4LwnpuZzoUmcp3lWNAhom?=
 =?us-ascii?Q?2cpCaK5dVBsQrZSdzVKIaNPMVw1MRGqdkBe3lpLckkIuhVyc659V7yqV8Z6o?=
 =?us-ascii?Q?XtEzCcmq9u4OH9V6XfsTo+ALhEs3r4tzNwPQJ1I27AJo9Cn8lOhbKF6ANaMk?=
 =?us-ascii?Q?eT0JBAIFuRRx0fan/7fnIWdR5Qnf81KU+v7/PrOtkUtzS5w8VkgOXA3t8rEn?=
 =?us-ascii?Q?LPfAt3IeFA2pYc+mrXe62eKoHvg2CS3yV3JoVOiRfvTjAENeFQUwbtyovpnN?=
 =?us-ascii?Q?OcowOcYWQLPI0Z7FTnjO8S4ZDB2FOErBwwg6mfZSbf07njenwEoQ39B8rNJ4?=
 =?us-ascii?Q?T03G7TNXFlcZDBu7lXw/fi7IVWFYoh4PdXTZu2iucLwQo6URZdFYbm+bibk3?=
 =?us-ascii?Q?zDoqX85oF5HlU0HHXxAKk3TQF8KVSMl48oYiq97zeG2LOWQH27JdpSUApjJ0?=
 =?us-ascii?Q?jfDYa2VAu8+4mdSWlqas5AqvIhdnZ4TmChvY3Xd2z0PKTrdfmJdOw1LEewdo?=
 =?us-ascii?Q?yiAs6eoeCQZy1g6agX9u2frVS41fA85llfotLzUdv0bMWTx9A3X7EBhc7g0S?=
 =?us-ascii?Q?iy4jVMKGMlAcnJ5/s8IGa3EUDVN2JcWOQKgHEmB3Kqi+wD4c9DmuUhOmnvCM?=
 =?us-ascii?Q?u1kDuNoJTgvGeQ72rcHuaLb0pbTgsQnUe44HbENtS4O/bC0bVqA8imEd611F?=
 =?us-ascii?Q?oA1JhzUtl9qccRhzFVRmAji/ah46KXegCLD0gp5ST+ugPw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LeakiLlIUKGtu3UpF9G5QVdlvXg3Fc8aUw/4vQBUWX/1yY4A68umHtMDGpwo?=
 =?us-ascii?Q?MGmhwOzebpZTkNRotpmqwJ3bOstcEWzLhs6oO6GAAmUuFnar1Q2XLri9Dsor?=
 =?us-ascii?Q?Oe2HC0XaIscmdr+b93RAJZ316797hzSKb233/qs70hI2qumnpByK45b9witl?=
 =?us-ascii?Q?7kzEqeY4+6sP6Wsjde9bjQ2RVEW49bTmRVwQgMc7IGZWhKMay0Tye/s1oh+d?=
 =?us-ascii?Q?0kgstgSEfKjPCXE5MwqXFzfGSAnG+7f/EvltmVWOBnCiwTDezoMnb3vLD2Iu?=
 =?us-ascii?Q?dqztYuajqTfzz+r4u+qLx1NAr7kSd0dKsX2v9xwAk7Ju4LYa3lRKfOVSaB/f?=
 =?us-ascii?Q?9KWaMtujqRv+hYng3G0+5cmHWm2zKoRKljGNjBRyuMUe1dlvPeGoRyFIDBMS?=
 =?us-ascii?Q?H9f7DbjO/3V37ljMF7dOh278qBFRrhQ3SuoVsT9fzdf9jW9Dc+IehAZMmLEj?=
 =?us-ascii?Q?puXCHqH1vz4wSgeyHn3pxocyPAs4s6p1n8eSNpgwJDWRyD13hT6YPdqbx7Hm?=
 =?us-ascii?Q?31z6nE5cAABwfLJLRDqgqzBKxsaP0XVN99xcQekJGFA/+rmDLVkn3N7d+hJu?=
 =?us-ascii?Q?YloGV+ffbNqspayZ6qd1U8KVQ4cF3eIn5/DlZRdaR9I71b2VD5SOZqCKii6z?=
 =?us-ascii?Q?u5hnpDhQq5pGPIdQOfb73yW5qs5DSqiHdF589swT3ThKbqPjygeIRDr6j6kW?=
 =?us-ascii?Q?+ovFVg0UBSiefhYNSb6MK6SGb2scFF0PjCIyk2IpguYQb/I5ZDrX1P0s5fjJ?=
 =?us-ascii?Q?0z91H9ol+CZX3F1cLjKBWG0IElnrALFpp1S979qH27HXW+0gB7ZLuR5elRpl?=
 =?us-ascii?Q?r+ov7DJKaVCPzUrpAKkzFYoQFjGHXZ0XC/Wpc1Htq7NImlxTnYshOi52BxXB?=
 =?us-ascii?Q?IEEjJGghRdGX5xppA4KlsxNA+1Yu2lfEiTevu/llaZ4RV0MfRSFfIwEqOlwn?=
 =?us-ascii?Q?BMRK7csXZ36DkvGs7Ym4t2rPXHCr16lBjj0XWh4GG3WWYFTlOa1zV8IS55OI?=
 =?us-ascii?Q?JNLsjGWbCP9Cy4M9tNAJ7U9EPPsBsTda8LFabY5BWrw1VjoDuDX3oKaWRJIV?=
 =?us-ascii?Q?N9S2Wxk8gZYNgOBZbwjzHmCPPG9/Xbu0PG8oUCIFIpkt3tzQiXMNwgbIoAjJ?=
 =?us-ascii?Q?jXDebWFTBRaDM49toFI3QcLgZEByrVyeqU+h2MDDV4JE1YzJBW0TR2hjOP5x?=
 =?us-ascii?Q?qY8HPnZ0c/ykYuqDwigkIvGXkWOTEEJWfEOUSt3UYNdjKSLq3XEzY/0FhPLN?=
 =?us-ascii?Q?NOuk/e0aIFERhzMMiQf8PpZD6wKRuny5oB2Nuy8xDlGEipAaa92vCrwOimr2?=
 =?us-ascii?Q?ZiSDV/aCC8RLZgXt10yBd2QBDgobFuLY3Tf8LDFbNcRjYLJXCcOv1tjtFNmw?=
 =?us-ascii?Q?0/ypOFDZjcL9usKwtpxWHc95+HLmzh5JAi/+T14qVP8NRjZMuIhwSPmfRmkG?=
 =?us-ascii?Q?oxJW5pHCv0+laodwGSZl7asvPW3QPNRJGVfSTNMz9pLrvnZAi39aGcUPTN1J?=
 =?us-ascii?Q?biaLHkkRurwTP65nxBk8EwaPSnxoJ/HJ2HBOGY1nB1RuxEKdsPVbUwCKlXvf?=
 =?us-ascii?Q?286MOyJPtT2hbWID5OTgXAATWRm9NiO+lFAbfPEn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 641e3b7f-54a9-4ec6-3378-08dcaef33225
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2024 10:51:12.2442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5frcL7X7vYknbR2lOUoD8/3NSkqNZ6KJGY33xGYOaAakeza+zNlZxP//sedSYlJpWYw/5JfVRp7jq4OT2BTWOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8037

On Sun, Jul 28, 2024 at 04:30:40AM +0200, Florian Westphal wrote:
> Ido Schimmel <idosch@nvidia.com> wrote:
> >  void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
> >  			const struct nft_pktinfo *pkt)
> >  {
> > @@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  	if (priv->flags & NFTA_FIB_F_MARK)
> >  		fl4.flowi4_mark = pkt->skb->mark;
> >  
> > -	fl4.flowi4_tos = iph->tos & DSCP_BITS;
> > +	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;
> 
> I was confused because cover letter talks about allowing both tos or dscp depending on
> new nlattr for ipv4, but then this patch makes that impossible because dscp bits get masked.
> 
> patch 3 says:
> ----
> A prerequisite for allowing FIB rules to match on DSCP is to adjust all
> the call sites to initialize the high order DSCP bits and remove their
> masking along the path to the core where the field is matched on.
> ----
> 
> But nft_fib_ipv4.c already does that.
> 
> So I would suggest to just drop this patch and then get rid of '&
> DSCP_BITS' once everything is in place.
> 
> But feel free to handle this as you prefer.

My preference is to first align all the users to mask the upper DSCP
bits (patches #1-#2), then move the masking to the core (patch #3) and
finally remove the masking from the various call sites (future
patchsets). Will make it clearer in the cover letter.

Thanks!
