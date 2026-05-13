Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011042.outbound.protection.outlook.com [52.101.62.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C99B3F4129;
	Wed, 13 May 2026 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778687351; cv=fail; b=avD3O1p9J427cJVDS9feFaHBb0KtS1rtTpDmb42iOkiojP5aTL9fklREQWdh7N2bmjJaUHHTo9dRP08LhVr6BBScJ4xS/R9gyHSMIj3nQLAzYmVKEUi18sq6SBYkN/0W9XnhN6CTU2bNmbXWmaDSlvgRK+HPjTcE/U6dO6CIOv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778687351; c=relaxed/simple;
	bh=0P/1wEZ77wyCPHX4RnpW+oFzd/6A2lXYIg5BS2Dln3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gisp+kLdflcswFxzEXUU3odm6T45URrrOhtl+JLGkN86qrDQ6Pe/t+DpLHQnhGF44PxQoo9uOQfhp9VQUfvNt2XVTbdpa2Z5dtj9faGfpfjGGJEpcmeGTgyMj1BY/n0ocHgW95FjIUvjWK+wIc0Vg0js2OqnXDHO8YdGO4xTBao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QxWDQ/fL; arc=fail smtp.client-ip=52.101.62.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QxWDQ/fL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q50p2xDgLLI7ik57NY1w3RTZoiHSQ8rn4gT5ZLoCFHz9ZzsNOTjegNisWmrI6BU65b3Svhj8xy3sbbIPVBN18kIvI9LcKLXS71ZaUcLFfYcT64SUfsFXrU3Q/RY5gItlk4mrcmQd8CRQtCdq3rCQvdEAS9M6dj3uYyzhd01rfxMblDi7s3cuQ4tvBqHm9ZuNFlcmppHBPbYr1Eg4OoQ0WZMtMIpzc+N2IzIwAKLePA9nMjThnJ8cv+ANem0NpkRPAISn0duSB3mL7Hnjb8xtwSsxgTsiPLudBuuXmgxc8ENpkYjrKWaCCdXoHwXfL6o+1WIJcwx6xCUqWOWGhxeUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHWIhqiyl11CIHz+tHMmOM2CxxEzIPwzkTRcRi7tDVg=;
 b=YyNfO2OUOiZUI7LOl8bqeHyzYP4Z0e989KDrc2iHBWK41yBrkO6aAlp4pArOA3SXWHDt7HLGaamPX1zxWF8PykPN92HQoIrj1o6tRBhLbCPnAZyMPyvsKiYi4jhukXJDYQFScj4q5yrRt8rLap8n4T3FpqoHiC8VhPhXSQZe/wh7/POhpEyOsQqRlgN3Z/BH498adsrCUBMVffe2QCVoKZzii+AQBKjraLkV/GgXFgCgDSsPr3OslAr3LNMRfna+ETkJ/CfHEseYq6xELRTFdVdu08JTlFal02ek4J3MjtwJcIckEQEcZRROp2VNxkm5o4XeZ1zs8A33XZaNQqIkTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHWIhqiyl11CIHz+tHMmOM2CxxEzIPwzkTRcRi7tDVg=;
 b=QxWDQ/fLUcuNIjE8AYcOkR1fD5iNXVH2o7BpZVHx6RDPrTcyWzUL6NgXlLBXZPhBXmFlWlO7Qwh3Uz/UagyfxOW7gvvMIl6i53ZLMK9BFKC2yV9gAnd7BAXQDsGDLe8jI5Lhlc+KPYyOHVrsM/vZFnx0Y6PwJprOI900ca4y3MhfwqlYJ/qQ3Ba3VFWUnZOah7endTabTlFC4FW+f5keUByeDB8T3BUirZ0AndNNTKbW+LNkgw6fP7cVFZqWO7Wg5bp6s9Nh30HXAhOH99KU54zZKwUF6GqJ14uQmCx7m8ddHQ1NgibOct37/TNbigUCW3Thhc717e6Kecqka+U6zQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by IA1PR12MB8238.namprd12.prod.outlook.com (2603:10b6:208:3f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Wed, 13 May
 2026 15:49:05 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%6]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 15:49:05 +0000
Date: Wed, 13 May 2026 18:48:55 +0300
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
Subject: Re: [PATCH net v2] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <20260513154855.GA425676@shredder>
References: <20260511-nf-neigh_hh_bridge-fix-v2-1-c4964c7a7b8f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-nf-neigh_hh_bridge-fix-v2-1-c4964c7a7b8f@kernel.org>
X-ClientProxiedBy: FR4P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::13) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|IA1PR12MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: a9193f31-4be4-4168-da99-08deb10729a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	E8lKVk0hfhGPW93aTcl5yvpQcpe7oa+gOfePCe5caqFJDLrlPTANkr2i1vL3i21KVuR5p+iixlDjxErLIL9I6vdrowGbqslbrsDMRhj7rA6czC0UVhkRg0/9Pn13xTxVCXyRHb6dIfnhVkJmKhbqzLk//lzojG5TfCrdXVO+xv76rB/P0QcneH3HSUqVuMhT64QeegCVRoQDhyXp6iI69dPC8edUUx0SosY4oaUQxDrBYjn3FevrteFH4j+eO4xTfxhJr/nqs1w+NBR2Ll7t43HcgATNomANiMV/J34luhaY+CfgtBNRCgYe2fkKA6i7Abh5//YvhxahNIPqqz8VtTV6qr+L88QmCES2QKYfME8omcQrqgvITUK7zd86b9xYdUpTCufJWZHvjWHGBuzv7RczCH5pZCrWAyS3mD4qvNJB8JL0zGkp7hxhzmzdGLtTU4NLPA7m8kPby1xhH3kkK2+AxDoK68k9U3NT3Dd1LV0KnusbGF+AGEmf0UXAvC28ztQl2spgpr+5ICko/H/Lv6n1iHuKF46+i1wr6oFNVrn/lN968tWzQUcTP8s9dVrLdIYeN1sw/KzT8YGGxMSzbFkR7jLHMiCfElyUdpKN8d+fjFJCJUBsBm5HpBPmIxUF6G2FbRp8Yfcth1Yfv36Ao+pcyWjCa8HBP2XCr+vFVmMTddIdg5UmZQyyGlFWP6Sk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4eF41KplNhj3ibVN9udaPpFKXzfIbLyypJ4eEbq4EFHIyIq8pDsSyzozjl6Z?=
 =?us-ascii?Q?XTHTWeV3nT1DG3tuGZVtdG+nO7Sxux4PZjLmvw884A+RrOI8u5Il2ke2df2q?=
 =?us-ascii?Q?XUDqpeKblSOmafLtu1ZijODRnMMCTaR00PNqWra8RezmcAZNEbydVL+8aH9S?=
 =?us-ascii?Q?ZJjB79A1FSWV6gPCczB1H6fy5nIyedvKrbmT5UcyU96Y5bOfvBBDihNjhexL?=
 =?us-ascii?Q?pjSdkOgGkWNyMW1ca+AUdkLJmUL6trSaLf/BtxSfY9EHI2xJ3vZHq5TKmKsx?=
 =?us-ascii?Q?o3MXmBUdt46olHHlNF8i5tSYtTr1ccPbGDv/lx/6XrJnmhx04vpWcEQFnjLq?=
 =?us-ascii?Q?H5ku2VnVg15/4+cTaLSa1xEn2SQwJaifq9pm3yGl2bJhWe8b4aLrL13idUXQ?=
 =?us-ascii?Q?fNFMyPBpVQGH+LkrI0ZY29JC3GtulzezcnnVctGl7HoCseLt0OKZfrMBTJMB?=
 =?us-ascii?Q?iEcQxWEQAUjyTvH5cZRXhZ6bXPuxJUWsDo1yvXKekVsNhvkH6x+kYIv9O92V?=
 =?us-ascii?Q?ki0t/atVpYXqMnZapZCsSQQ2QEY8kvxdO3dsNC9u1tzpNPud17YijVOLylAl?=
 =?us-ascii?Q?YL/OR3aOEKQ2Xlie+F+lsylSwzBJnTh9pi1vKuexe/0mUZLwmEo8flhSM8CC?=
 =?us-ascii?Q?qHflIKrjBVatF2mjN0fmwPDQsHmkgKIlMHriuJYpkGukRKxjOPwW4KBye2Da?=
 =?us-ascii?Q?Q8lqh73VGpn6HnS14yGWbwfabb4Fmn1KwUoLzTuLjAqHnlPBPDtcQx6qZy7x?=
 =?us-ascii?Q?YYTYu0yfj0Qn0DYkK+/4VhnouPqFFPAtfZiddnrM563Il76Jb51a2WSXPXcW?=
 =?us-ascii?Q?mPZB2dztetyijCF4a2cQtjP5veb3k3Nk/b9/eQ/QVkIB1Kul0D2wrtzuyz1X?=
 =?us-ascii?Q?2B6ZjGvQTCK7Y9sCDeMjgolAI8TmEJIA683BuB/5uHMRFgvy4bq+3fOnWHce?=
 =?us-ascii?Q?Ea3s42Tiw/SIHkNcjdD9JVf9qX3nY5sufd5IeR/LuzRH/IAvINou8l22ynWa?=
 =?us-ascii?Q?qCSemfaE3WBqPJJ8tbfjzEu7OIeX0yywudZ0xOiqAOfTiAOLd7jgY+rbC0O9?=
 =?us-ascii?Q?WpbHmiFhsnId0fmI9d6uv+Oc0zXq4cd4GvS+dsrDpXZ2VBlCNrVV8k15R6SG?=
 =?us-ascii?Q?kyOkevOGeCr137ZYRC2M7hYudNB5kmrNBoMq+hSqyhns50NztI4xkgdwsC8X?=
 =?us-ascii?Q?ssX7GPbP1zb6kLw+s54yXJhqZOVnDf+FqjxgezYoRyntW0BYjpxMy4orqiHQ?=
 =?us-ascii?Q?AHQfzA8uctm5QuoYaY10e+Mi132bwmEdAYViJ6kbCARA3GZZtptVzvzMsKsI?=
 =?us-ascii?Q?7o5gVUpEEYpfUfTxPD9fKEpvIrVZKEFkMt9m1418VOnNLmSQiczI3p3YCVvC?=
 =?us-ascii?Q?uJsiijWvv2lT1om7114Q93I5TlfRkiYHyQw7rkY95ced3rHqDYW4TcWzdPcF?=
 =?us-ascii?Q?u0EpHCRtCyhA4rFsAcvkAK4Jn8OI8T1tTdhFPemNrJQmij/f5q8c4+kv8qG8?=
 =?us-ascii?Q?UKWvDcA5OK+5iHlK/ZVbqRDLEKpR+8veQ33Goch3nWGVdrxRtYceEcipzDkC?=
 =?us-ascii?Q?xVpeIiv6FRcmYYY3a4MeNpxHXLOmb5bjyQweLCXkjRGP1FlekTLkLsmHTRhO?=
 =?us-ascii?Q?VPS8F9IczS1Btco1CltI5Z75WGzvaDxyiijQnCF8bJsuJEINpPxjME6WOd0+?=
 =?us-ascii?Q?wrRP6ssJ8LtzRQKlSi1qiDQb36LJLoG9sFhNuQPW5fZNYeN4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9193f31-4be4-4168-da99-08deb10729a8
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 15:49:05.7329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6qlRwU6cM67Uio6ePnVHkQCv7yEbd2CWE5S9jfhqr/YhrCmxqwlhws442ikfjDgpY0VsMBdv5oEi84N48r3wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8238

On Mon, May 11, 2026 at 05:57:39PM +0200, Lorenzo Bianconi wrote:
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 2dfee6d4258a..c2b6196705ef 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -487,16 +487,24 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  }
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> -static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
> +static inline struct sk_buff *
> +neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
>  {
> -	unsigned int seq, hh_alen;
> +	unsigned int seq, hh_alen = HH_DATA_ALIGN(ETH_HLEN);
> +
> +	if (unlikely(skb_headroom(skb) < hh_alen ||
> +		     skb_header_cloned(skb) || skb_shared(skb))) {
> +		skb = skb_expand_head(skb, hh_alen);

I don't think this is correct... The comment above skb_expand_head()
says that it will generate a warning if there is sufficient headroom in
the packet.

I assumed that you would just call skb_cow_head() like the AI review
suggested. There's skb_share_check() in br_handle_frame(), so no need to
worry about the skb being shared.

> +		if (!skb)
> +			return NULL;
> +	}
>  
>  	do {
>  		seq = read_seqbegin(&hh->hh_lock);
> -		hh_alen = HH_DATA_ALIGN(ETH_HLEN);
>  		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HLEN);
>  	} while (read_seqretry(&hh->hh_lock, seq));
> -	return 0;
> +
> +	return skb;
>  }
>  #endif
>  
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0ab1c94db4b9..8d21c88c2116 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -297,7 +297,12 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
>  				goto free_skb;
>  			}
>  
> -			neigh_hh_bridge(&neigh->hh, skb);
> +			skb = neigh_hh_bridge(&neigh->hh, skb);
> +			if (!skb) {
> +				neigh_release(neigh);
> +				return -ENOMEM;
> +			}

This part looks correct.

> +
>  			skb->dev = br_indev;
>  
>  			ret = br_handle_frame_finish(net, sk, skb);
> 
> ---
> base-commit: a450063ef86b9967234ca1f896c0d77400c74f11
> change-id: 20260508-nf-neigh_hh_bridge-fix-9ab775ee23c6
> 
> Best regards,
> -- 
> Lorenzo Bianconi <lorenzo@kernel.org>
> 
