Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795188957;
	b=WIbH7Mfh6vxrzykD3Ka1dY+tC7XsOjj575opcDX/rxx+Pzhuub8DFYTItI3lE+rSRrwB
	 rEgdDlSpvfgP9mSGuJImqfQIOMuUvAa1LkQXSN1JGanIAqGRRbslylReWKkF4y/Fk2AUk
	 lisZsXaXqwTreXkV2qgqMzY1NwX5w/nm/n9a45TJ8RbC82EYYHHRYce0Qb0SNe1SXjrZe
	 40Wac8j4R+1VLn7vNR2S5zPFNyJ+hA+PuRD37MIuCnYjxMhqv/EHgATwoiD26T3XofbIx
	 rolkZi/+FIOXfGFUe28SSnezsHfvt9ZBCNbmtHBUXMGLQQMk9c+2qTqmvwlF1mPgTZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188957;
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
	bh=De9STSH4FOmn3ATCI97ebSTMlcHhqw9e01nVL+1S6VI=;
	b=RCFKne3jiDM4OCD0K2UsUuVx5+57RQvSrxTI4XVB8QAf3iYm0yQFZPHbDroqT+B8r6CA
	 QoGGH5dgmJ9yppVDzA1BjNLDNfNybLARDMstE+PJNbUxtdN9huTrLecvgLybXrag+akm8
	 MmZPmE9PCPodVPVdZzn8Sf2hG7fZRigi6lNekiYIqvajwUHmvmU8sQEqHD2hXWpGP/OH3
	 FPZwKLDVQKXw80RGEUTK8zJgtEMn6hAN7b6nek8qpO6EDnSCfCdoUkBKn/SOvXy0j3Nww
	 LVbmuPdH/HFJocLuwmMAg6uegF/96UXVOUyRWg62lV5FX/8NQYGdCt8H0JwUWdn19Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="foRC/7ds";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.13
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A117606A32A;
	Fri, 20 Nov 2026 15:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A117606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=foRC/7ds
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LBprvuOjedWcGxUsshXBGfjLaZ+SJJOMcGA6QN3gt4d2+W+x9FTRcdV4HlbvLzikqyYWVNysDBCQXn0ef1rQgOdAhRMNWGaJM+GoDTTlcKW5M2zxPnhUqGf3RUWBHaqorV7LHxIjMOJbVbF5pxuzpZetYPkGtAxzFXeHxONk5Zx233BX13M3LsdvXycX3S0eN0w4GAc/ujdXMi2mCOd2vSB+Fq2JjaMxEdEQI336TQCNyg50BooPwX3GLL4MbhVkdrk1EMDvR9YCH2mq7Y2pMMWVLLv3WI9f6x9BVBjwVUuuO9BydFf1Li9VE+n2Yn4VBsqtc0lNrYCa4Fi1ZIWkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=De9STSH4FOmn3ATCI97ebSTMlcHhqw9e01nVL+1S6VI=;
 b=y/vNncP7ST3UPxPEbtEbQpEay5KcDKxUAA2ES4mzkf4sgVRzusoZD6dWtggcaERcrnt9zWFRGUt0RTRyiKfiZk7ELwS0RiLjrI8gICgfbw45TNybbO7a6DReNVFu/1NsM0/nsYttlUZDbUnF4jG+8J0FZ6gsC7q8/Q5q9CfJOg7e1lG5/yf02klb2ZgZUORzJi/tQ8m9n7stMW+pkJreFBhZgcVo/1PEuwfydDt+1Rfv7M6NnfCQ3i9jZJgMzfTnihb2MCgkecPRpUKeFylOaE+uM9+8SLhJbcBXdDcRU4KKCVLJM2uccPEoAY2y8iMVYPyT6Q1gQKGrtGfCa6JO8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=De9STSH4FOmn3ATCI97ebSTMlcHhqw9e01nVL+1S6VI=;
 b=foRC/7ds/gD8h/hltEwND8/9LtC+iyS150eHTtXPDH+0zuO3mYL7H7QBhVhcQdBK+MSov0y4cDqzuAD6TxlyEasNeX1MPbYtH9cvB3EBU/ZS3I1LUhX2cX8nawIvudJybmooMmz0KKd/JJROppv+GJJNQriyx71W5WAccQgCu5COYTsGYpl8Dc1pCu6b+6QF9Mm5s7hQuZU5io3ommAcSW81Y2z1iPOUC0mO3T19JkU5J4EcW4tyj4iZMrckdl5aQrdxcfG6BMITHNKKlT62NCTNR0uVAgowkCMsFW4mLBzsUhDeFGZecYJcIgNy7oNGPjDOONPXV0otAmCR/R5aPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by CH1PR12MB9694.namprd12.prod.outlook.com (2603:10b6:610:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 15:35:44 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 15:35:44 +0000
Date: Fri, 20 Nov 2026 17:35:35 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: netdev-bot+sashiko@kernel.org
Cc: leonard@lausen.nl, netdev@vger.kernel.org, dsahern@kernel.org,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org,
	fw@strlen.de, phil@nwl.cc, shuah@kernel.org, daniel@iogearbox.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 1/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261120153535.GA2287760@shredder>
References: <20261117110813.9894-3-leonard@lausen.nl>
 <179517305064.3136.1004033364873817896@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179517305064.3136.1004033364873817896@kernel.org>
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To LV8PR12MB9407.namprd12.prod.outlook.com
 (2603:10b6:408:1f9::13)
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|CH1PR12MB9694:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea1d591-4ab0-427b-2095-08df471bf109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|22082099003|18002099003|3023799007|11063799006|56012099006|4143699003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261009223027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	wfPEW4QuudJVJU1P8P5Ejm4paW3dF2oETSds7bUEclI1925/enfOVOoFCOYZ8DMUfaC8paE6cqKtWcs4KQeOrqU0SD9buBzdJ5o/43TxpgW7euGnM8eRBJ5d4F4eALHxgyLNYJY0+1WHUNx29J5H2tG9M5nr6FGKDjfIyzeY8C5KJdJ6fr/EZ5S9Lxf7dzOA4M4XGipnnoje/ntWw6J2BJJ6L/Rv6+M0yM29hMkRCBbQi6c3Igs6KxOataEMbAFOukIqArIxPfGTLjRlyyuHf4fHo0LElybhGgyXY4xeyMqathKDbmryI2nPNkgWL4vSrt6yrCKnrMqoavYALE/hNAqYDuhcl7dk8Jr9dJYTS8Lro+u0mexUzmlXA0Bg1CJY3sM0xfpboe4OzieTRD9CyOZrJ9DZWNTugE3wduwA9FzcXq2s2zFUvyPEsuA+glnnpTFR7S2v70wbAYu9Er0oG70pieFo0M3REKvzZP9a/KkEmkj2/FqQnhlifbSTmJMnzljficjQwgIeWdrLf63uA+sU4CwVU6QM4qtELZR17gY9ivZiuqhTEIXuzvCw8U5cg15P51E9TXbZ4OdaUxLlV7vHas9eCDtRnYqETJQW0lBvoc/6Uo2+kdiFOv1+9vf56JH+2LbZ9UQFvLSdyrsnCnsRfHswCKqMXnvhYZt7dWI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006)(4143699003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261009223027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YdS1uOyqoZNBQZEtFJvUCpPoabNhgfnrLTtl9r/HYud/MTojbwEfrdTb97v3?=
 =?us-ascii?Q?p5xKSvsTcSwriSNu4wTmLHBj8aW/bYPhSVfUF/akeT11fn1IFT0KPj56mo+R?=
 =?us-ascii?Q?ht04sNjKdjxYHzzLVlsqYbIo0yissRZrEqAnumGNQnvyVpSGNq6+qbn1f96y?=
 =?us-ascii?Q?NAMyw3BD7nk+wQ5hJ8fpQTYv9VeYZ+naxiJy4Aohl/XizumyAxtU4cpE3Ood?=
 =?us-ascii?Q?4lfIZ41P/8DBgNSMsDPHt4T72g59phEoPYMe6ru1lC2HUaKz5JLhX3RsB0Y9?=
 =?us-ascii?Q?V8mWxT7hBF/4H7uMTTYyPxHUuKHz5u5tdKEBna3QrVv+qONGiF4DUARNTore?=
 =?us-ascii?Q?NuafjEZoyU1qWgYflT/yjb2YV0hmk4ZMFPBtFe63xOALKTkuXl4kewIiO47S?=
 =?us-ascii?Q?U2bZc4Em+C6esjcdtv+bFmrYbeWGW+yEcAb3mbyA+WhZyMoqpngZMmUTOwib?=
 =?us-ascii?Q?pTYFUhLgXGgM92YGPbSLs+fjBjN3RHOTlj4T5XP2+385tk5seR7wjQNP4GX5?=
 =?us-ascii?Q?JYpnfwRUfm9rD8DjmbDM5t7m55KUXINgR+KH0IOZTxAvID89LGYfi7fTccB2?=
 =?us-ascii?Q?vPj51ZpINaUv4tUJDqiJdfD8RFUH6K6WzE4lZUdj1XXhDGo5WuUj3ps8GNNV?=
 =?us-ascii?Q?pleZ/gpj84s+lU41Ig9jI+hS/0TE1NH4FpRHZCQ9qVXhPV1BRxeJ/ZyUNCHB?=
 =?us-ascii?Q?d/gjs+xoTIR7SF3ow8EyJ16cxYlO43jsRxLDICPRPwUxLgS6kxr8Lbov9r81?=
 =?us-ascii?Q?clmLXK6ddS04iyazxqUN94wT04+C+IHT8c44rvHGjrSO71o87VlW5R5piV3j?=
 =?us-ascii?Q?7PWxYaOMpfiHMJWuXJ+sSQceKhw7hXNk13VYZLUfPQI265Mnhc8iYty7peLt?=
 =?us-ascii?Q?DxsuHW00qsee3c22+KtkfHA/VDiaShnOgjgcOzn5yOj5s+SlnJQXorHD8QEY?=
 =?us-ascii?Q?vuEh7DT3nDHyIiJ1Nkp/Nsu1a5L6XDd/uXD5A4/YF32Rwr/bvkqdf+enDm3K?=
 =?us-ascii?Q?AIxXf0zh0cNfrFmc2WoLz1IdtndPI7AZW+V+rH1wUCgPSh2WyqjxdhSN7Bo5?=
 =?us-ascii?Q?7nU480yQza3L8TcyhcqYepEgJWrdmBzqvcGXVuG5UMWQks77kH6+YIcg/tE0?=
 =?us-ascii?Q?VvXH6yFjK5apO8UsrgUaCIVm0AOpVcipaNTChvJfnldyeM/pt+c83ippQCR0?=
 =?us-ascii?Q?NMJ43gTrg+zxvdGRIOoaXvDmSjpDlRe6RjGI/o3Ch+YXMec1G/6XvLxyP1uk?=
 =?us-ascii?Q?yDN4Uvq1HatHWAQUKD7QZKZXpssyV9Q4q9eeeiv+YwwNSqhq6EUl4vGuhoF5?=
 =?us-ascii?Q?EEFh1WlAA/FC0HdyDa41E+7brdc0LNZIGa1s+paU+y8VJZKIE/DuiJzdkSeW?=
 =?us-ascii?Q?sT2c1c7B84ESQS7F57ORoI7E4V/fDxbOmzO6k9oRZooE/hnj/8Sfgw61Xvjb?=
 =?us-ascii?Q?Vo+/ro8huznhudNoF1T+6AqZIPRMrR5Kj6dSFfiGwNDfU5sO5fJmFag3qYhX?=
 =?us-ascii?Q?KDt+dP0lZ6tUxAawhdBHn5qyejeeBNL8Lh4uIoZo20D863hy9rg8zX364dp5?=
 =?us-ascii?Q?KiA8nnA1U65gF3wqOo4alnl0nyiR2JNKaVEI9i/0sp8kMLGkBYw8EYCJw8iY?=
 =?us-ascii?Q?0UGzAPXRxR+M4AiTydzt80zFXZXYJgWrv1TS2uRO/DXGK0BA4/2friO1NDeY?=
 =?us-ascii?Q?LJkL8KtYEffsRX2ZpC7Yt7fiYMBs07Km8EP/lgXNHppij36K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea1d591-4ab0-427b-2095-08df471bf109
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 15:35:44.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nS2oxENXAedgnKG/+0q2nRrbwH4fEzh7PnAxSIgyZCa/qdNq3TJ1lt9jQUr5jyqkeaW2yxHRXmAanuB998+K6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9694

On Fri, Nov 20, 2026 at 11:10:50AM +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> 
> Does the RTF_REJECT exemption also catch RTN_THROW routes?
> 
> The commit message says:
> 
>     Do not suppress such routes so that they continue to terminate the
>     lookup, as with ip6_route_output() and IPv4.
> 
> But rtm_to_fib6_config() sets RTF_REJECT for throw routes as well:
> 
>     if (rtm->rtm_type == RTN_UNREACHABLE ||
>         rtm->rtm_type == RTN_BLACKHOLE ||
>         rtm->rtm_type == RTN_PROHIBIT ||
>         rtm->rtm_type == RTN_THROW)
>             cfg->fc_flags |= RTF_REJECT;
> 
> On the fib6_lookup() path, fib6_rule_action_alt() returns 0 for any
> matched entry other than fib6_null_entry:
> 
>     err = fib6_table_lookup(net, table, *oif, flp6, res, flags);
>     if (!err && res->f6i != net->ipv6.fib6_null_entry)
>             err = fib6_rule_saddr(net, rule, flags, flp6,
>                                   res->nh->fib_nh_dev);
>     else
>             err = -EAGAIN;
> 
> So fib_rules_lookup() calls fib6_rule_suppress(). This branch returns
> false because RTF_REJECT is set, and the rule walk stops with an
> RTN_THROW result.
> 
> On the ip6_route_output() path, __fib6_rule_action() returns
> rt->dst.error, which comes from fib6_prop[RTN_THROW] = -EAGAIN. IPv4
> fib_table_lookup() returns fib_props[RTN_THROW].error = -EAGAIN. In both
> cases fib_rules_lookup() goes on to the next rule, so a throw route never
> ends the lookup there.
> 
> For example, take "throw default" in the main table with a "table main
> suppress_prefixlength 0" rule. ip6_route_output() would continue to the
> next rule, but fib6_lookup() stops at the throw route.
> 
> nft_fib6_eval_type() then reports RTN_THROW, and nft_fib6_eval() returns
> no oif:
> 
>     if (ret || res.fib6_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
>             return;
> 
> That can lead to strict RPF drops. bpf_ipv6_fib_lookup() also returns
> BPF_FIB_LKUP_RET_NOT_FWDED even though a later rule would match.
> 
> The throw handling in fib6_rule_action_alt() predates this patch.
> However, before 1c32b24c234b the nft code used ip6_route_lookup() and
> nf_ip6_route(), which handled throw routes correctly. The reject-route
> checks described in the notes seem to cover only blackhole, unreachable
> and prohibit routes.
> 
> Could fib6_rule_action_alt() return -EAGAIN when res->fib6_type ==
> RTN_THROW? The RTF_REJECT exemption here would then cover only routes
> that really end the lookup.

Already addressed in:

https://lore.kernel.org/netdev/20261119165758.GA2050378@shredder/

It's a pre-existing issue and one that is unlikely to bother anyone,
unlike the issue being fixed by this patch.
