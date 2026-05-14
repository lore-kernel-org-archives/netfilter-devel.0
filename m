Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012046.outbound.protection.outlook.com [52.101.53.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194253A2E12;
	Thu, 14 May 2026 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778746461; cv=fail; b=iv+kYmh1JhETEJzqVx+UjiHWqe22MZNl6kSqP3u9jA0kVBKbr4JeTKQLu3HhBxYwghafmO8V9wUw83y+lfi3/Q0EsctTM2UEKs40ytg43h3OwD+zSFKNZTiytPbgSQCVo4DXI0QfawrcoZpFcNMF7kolBVzvOuzALXeReAphJpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778746461; c=relaxed/simple;
	bh=/yBxuIeT9H1JBUzQiR+ghS1sPzS7eHByn/6HLPTgxHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=og+zhA83rG8xWWzjM9jRmllazro5xe1hLsdg/tOBk9BlxMP30p2QVjhn8O+nooMmb9nDJkqV2dltxjNbdEchSXqcRNwzcqmCLaihQbTCIPJXWoZN+fcHkAhixBAC5Qs8dBlp2WHcsihnmaFqProlwCfEvIm0hWTIZSUS6+vJgKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GzwidZVD; arc=fail smtp.client-ip=52.101.53.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GzwidZVD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZghQH5Uf5wTFcHsCl4TgrXPCRsnaVPLzsaJvbqeJeiqIKtjH+e0t3MaMB9GLAHr3vOlsk4ZsJYYMWMOMRmv6MgYYfvc+JGLgXRYhFyaMm1WwVG7HcCtoUiyMPL88WI9tJEbj9dJRxrfqadPyuGSxOquY+cftme8cx2NWoied3ndFDkZ6nzJp/ObYJWgXwrxiSrgXyv0yP43D7ifGe0V0TM5ax/qnK6/U3PXjTyB685rTEYhw0yPEccTHJEmPtWioSsuPj5jsnTBeFs3oby4+d09MfsoVxA1OZDoi5+9LoBeA9OH1icriQQw8uTW1kHHslLkR081yo4wVuE75l3aKaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0jCiXv6dPj4BlvpZbx93WIDHn/9ZKSdnb3gU5ZAiMQ=;
 b=Ik3nNDsOjRgfMmyD5jbgSNApDG21tPTlNp/fUE9XuoeuYZ/Gz3zkNY3MUzLjcrbznmWstCo6KcSxAJydKwZfUMcfIh0OJNCO/4O/bO/gyrQL5xw/Gjmtz+LREU+qPwESF/qSKWxDnOaNsjhf4JxMl1zpbX1dW7jQgP60/0ukSZTqhmtwNrezkSgWRk7NYHV6UH+I/qZix6sxT/R+gpOqPl98Lt/txCnm7dWiN1xbkkbcLnweeomU5B6oxZGkn6D6ptiGYJVw7abvbsBNkpS4qUPeqtenSwU1D1QLU8V4fy/NYGyAcSYFMxu4RAKN6Y7ffkK5mseocYUWA+WYliN+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0jCiXv6dPj4BlvpZbx93WIDHn/9ZKSdnb3gU5ZAiMQ=;
 b=GzwidZVDQmdzp2yDubTKQ5Hi0vmlX588b52fR5xM06zIb+ABF/OSotLXqVfw9cY91RF0JrO8w+6CuuydVrqD+oGnhKoXzeA+BxtJnJSBy4tLd8sTlimH8nHcpL0UC+JwDB3749IntCkV8R7BHiGoJbQJDNXsHhbwc4Ms0i31ConutmWQ+R7Sbmia4peb20Pdh4X+ZXRCGg1jSXSNfLgNr+5nvk5g91fWIV1JOBwFYfu1p8mC1uPs2BmiQ87OU1MKPZcuBkNyJTAfhETCOo+ks6KHAgaKw2VpfnuBaKNRYOx7RJiWf4eYoacUWdRJ03RXj4VTfcLS7f4YYM9+aLiaJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by DM6PR12MB4282.namprd12.prod.outlook.com (2603:10b6:5:223::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Thu, 14 May
 2026 08:14:14 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%6]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 08:14:14 +0000
Date: Thu, 14 May 2026 11:14:03 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net v3] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <20260514081403.GA482081@shredder>
References: <20260513-nf-neigh_hh_bridge-fix-v3-1-8ec9353c0909@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513-nf-neigh_hh_bridge-fix-v3-1-8ec9353c0909@kernel.org>
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|DM6PR12MB4282:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bbe3049-7506-4686-676b-08deb190c95f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	MgovQBFewQKfjkFGhFw4mtNQiWkoHxUSznwHXXGyn3Q0/WN8slVMVaIVm2raZakhpJb/AIEjRtfeV52GP9laLPX/5IIB6Z11Nma/p4+ZGCr0mcs4Zoz/iOZLxG7ODJfVPpes70yHs09cYpuHD2sVQuw8giFlYxFDGZlPXV72kx8zYRTbDgsyo5Rh9703kFUk/TkA9wjjVlQgt2TmfAz1hiwswkEdaDjpSZ81lgB8HGqlvmlu9/QUPrPHldpwka2MlxgMOpXfjtO3rf752u+IU/IK/kaKjWBJOt/hUTJ/Zzst4mw3kZckkC7Z9S3qdKKsgFkPPI1ofTAUszLbY5kMl86Hd5Z6ngskuOXGNfzAZmG50+rHLPCPw/7T/CZiSRR4kNpH2bv/w2RehoRf5deuNkHPqkOXernO3/TwPNKL7j9eIaD7wQ0xBTwkiPuXvbLdGNTnirY1byl3omUHiKwW/Z+RNl8mUWx/2S4tkjCTILz8YRww7X1CAHIVDfnAvK0OivqSkcRQnVhbTCCOIW5Ji5eGAzw2WgYG8vYvv3VgU73Soh9dlCEREsVZsF0NpESVkTAkdrcsXo52KxehJ7YJtWTLW1gSxcMTN1ruojU+9AhUCX01rZrPZBnbZYMUZ+fxCy6zy5Q8QtuRr23BBfXy0nxgLJ14Byv5oJ7Hzz5T6APCXngwtAlvMLV+bXQPUd34
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Ul4p0yYTZaT6GLzkvgtj2kZG5jjvPxEIrk557NgNNK/afa8fDGmC26i1280?=
 =?us-ascii?Q?yl7+dQcL7gJizLuo+C5L3TuS3p3uPuNIcmzrMp6R+Ngghoe73mGl3bFGTbfj?=
 =?us-ascii?Q?TwkuihdR1/ppVep2hITtodM1lmEIODYeuLBdc3+Wjo4R9C/n2rKCPY89FA9e?=
 =?us-ascii?Q?tfEIotnl/ixSevUCcUvsQxB8rp23TF1a4dr1RiNGaVtLl/ypGNn42Oh/B6/y?=
 =?us-ascii?Q?b4H9swO58mdiANXi5hxzicGu0aR6WmvP/t2vMpojHAuVbgi2N0/n3buw5EQZ?=
 =?us-ascii?Q?aC+nDzISm+pt3xeLdU6hsSeT3gHtxNSJ/jMk8K4yhW1IgXmUnkEgdBfVbcG/?=
 =?us-ascii?Q?rk4vf18GrcPGtSFUpSAYAYF6bAo+SVPNm0xp9Ni9UtkPmypokTR9eqgg7vxx?=
 =?us-ascii?Q?iUMIGDhYGeDIKc01HqQGxh7hiF8w95SalNqo9bSyOg6ZcfcrGst1jMKzFbO9?=
 =?us-ascii?Q?w6flxBKtGiDiyaVryal5ydK/VByQENOdYhdQfMj83iOXKwd7oEX6s82BvspL?=
 =?us-ascii?Q?jOREZufYbpRj81Lado5/NJN3GfALTE3Ml6EE9O3roh6XCkzCq3uJ9BPbfcfI?=
 =?us-ascii?Q?8wydB3T+9IRbHI3P6m8kXOCyWlMP8/tkT+aKnRUN5djlILrlXBAga8ZyZ+w/?=
 =?us-ascii?Q?RaiaWuZXFR0i9kKd9ur2rj2CgI+AZbwQ7/PXu4NSszS5xdliGasz4+FJkjf6?=
 =?us-ascii?Q?+qxcohFRNFLq45kSQ3o4/0bLqz/tKBCXORp8VVpM2LpOT4TdAV3i9GSpGMOE?=
 =?us-ascii?Q?+ZsFnjLoHSkjzBxg9b3ZFQF/ESVhspW9Y6F00UOtuSm543lYRsSaJ9iCZNOY?=
 =?us-ascii?Q?dxnHOPMEfeiayHLj+JerUJY+LjCWsxh61Ot0CMZup7dljromyjbfEHsLQIB8?=
 =?us-ascii?Q?BAjZFPuisu1jI35eWxtwiLh/zunmN3l4h/t9mL96EFLjcd+RYTfzto6NxnTK?=
 =?us-ascii?Q?2cm4aIjU3apcZUSqTzcf8/oNBrLfkHrZlt1M1vvAnJ7H7LLU/9caK2eZhDI5?=
 =?us-ascii?Q?DcO3c4sRw/yVsudcFd+9nI7khsXJ6g89QhmGe9bflcTU26Vm9fASVi1D6tEc?=
 =?us-ascii?Q?55IMNioC7n10Giw1jFlyIm4vbmPq/omygS2gRdJquawod3DqAla9CsmrEGt2?=
 =?us-ascii?Q?p6v2+ocA9SZ3NIsse5cTHVdzkvVFFnKp7Ra/1PFdeWRta91VXc9+9QnA7OxH?=
 =?us-ascii?Q?Z0Gtd4kifELn4cLhLpyNZ95ZFtxrw4o0HTvW+o4RLUX23Y0/0mKpIvsq8eLN?=
 =?us-ascii?Q?BxwJUbNTc8Fr2ErwmM56lOKGe4dgw2LOIgGzjgeWssBJcMqz0GqvQv0SRb1S?=
 =?us-ascii?Q?t7xOUTUN7jviuS/5L+3yhcw64E8DlYa4TYaw5pgz2DJN6EKNPzuXwdncVF0R?=
 =?us-ascii?Q?QUb9qKtOrX6+jBmRNXOccUmkICK0RgO00krMoyosuiD3CrgN9qOWY01rRyi1?=
 =?us-ascii?Q?zMcz3/6bgOjAqiuT3EeUH1e0pAqqEkOcTSvVefO1wy/Ao/k6pbi58BuOlb5c?=
 =?us-ascii?Q?0Qh4xZvwTJzW/lRA64IgIDg45G10H3Vf30Dw3PmytuAa8xTPhO/+HtGIvRkj?=
 =?us-ascii?Q?SD3G92tieE+tJQ+sZa6GhhjLSIY2wSggcIN1ZhiDq/QapNfSi5fkSMAT1NFH?=
 =?us-ascii?Q?sn/LmVSe2tAgblxgK6UiY2b2WgpAJDUi/246Z9PTIwM7pBibMhfSJ9nokbNw?=
 =?us-ascii?Q?rz6M33o/NDdLzxdWPHsvxhN97qYT/5wUWZAga/Ne+MiBnIbG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbe3049-7506-4686-676b-08deb190c95f
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 08:14:14.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTlYIk6fUwqFIwHu2N3NOH7vT/m0+HA6FcyZ0u11ZwVy4FN4IrIqx7nhBfe81WfhaTlRmtN7Jx9BjxcvsZvlCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4282

On Wed, May 13, 2026 at 06:40:28PM +0200, Lorenzo Bianconi wrote:
> neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
> the aligned  L2 header. This assumption can trigger the crash reported
> below using the following netfilter setup:
> 
> $modprobe br_netfilter
> $sysctl -w net.bridge.bridge-nf-call-iptables=1
> 
> $root@OpenWrt:~# nft list ruleset
> table ip nat {
>         chain prerouting {
>                 type nat hook prerouting priority dstnat; policy accept;
>                 ip daddr 192.168.83.123 dnat to 192.168.83.120
>         }
> }
> 
> - iperf3 client (192.168.83.119) --> bridge (192.168.83.118) --> iperf3 server (192.168.83.120)
> 
> the iperf3 client is sending packet for 192.168.83.123 to the bridge device.

[...]

> 
> Fix the issue reallocating the skb headroom if necessary in neigh_hh_bridge routine.
> 
> Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header handling with IP DNAT")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

[...]

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0ab1c94db4b9..cea2352900e9 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -297,7 +297,13 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
>  				goto free_skb;
>  			}
>  
> -			neigh_hh_bridge(&neigh->hh, skb);
> +			ret = neigh_hh_bridge(&neigh->hh, skb);
> +			if (ret) {
> +				neigh_release(neigh);
> +				kfree_skb(skb);
> +				return ret;

Personally I would use 'goto free_skb' after releasing the neighbour, to
be consistent with the other paths that free the packet.

> +			}
> +
>  			skb->dev = br_indev;
>  
>  			ret = br_handle_frame_finish(net, sk, skb);
