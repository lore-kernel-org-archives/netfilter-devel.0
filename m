Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010010.outbound.protection.outlook.com [52.101.85.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D2118B0A;
	Wed, 14 Oct 2026 03:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791947868; cv=fail; b=APBMFhITEK3n2Y3iziTxVAnFKORuBHbDKPR/p9ZUBuc/rtTz6o44uzxErmWzNK5jgaR54HLlFaK3ZZNV3xBHlk+KTB6QhdFi2xucBHWqfb1YB2crL40xAELES5zj2a8KnqEkOwQQSn7Ss5WAbRrIEvA/7gZHry3lmrGdVCdoPP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791947868; c=relaxed/simple;
	bh=HrXJweVyqGY8PMwJYn+Z447iu+/0+Ha/NuBX4IY6egA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a3bEod+rObPS4AbeROhXOSNav0QlhMRU4BPekDpaNBu5DjsolAq/0E7HM2xxBS790h/h4GWxiAqouungE/ovcZ9RHN7SPr558hEnwAuw9/T1y/b0s2lUyIVSQK7E3BQkgeHYZD/ZajtQ0DL4afHDqUUJwu66V0UBPzErsxaZQIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FukwMs5c; arc=fail smtp.client-ip=52.101.85.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FukwMs5c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B9lEVvDgYYmxMfeYB8rxEywFZY8N8Ujt7oRL+OYJnlA3oJ5gSTTKr/rFxJxNkqqviCQ3FrfSxK+CWoT6Lwb/zHJzNJyTMBetBcHfytswrh9PG/Mv/lRe1vOAR/9sSPJ+XK+PQ6nlDrY7YKZCOo4iZymRfR4FCBRN/XhHvBMv9tk6ZqOh40jw4gTMV4Y6NJofmJADLzg+Xw/b7zqBbg7yNAtAPc06pgruX8+mA8KNdcx9tr336gzmIfiJIczgQTKWxqUMbVJWgibM3rWzxmM+PzpYtQmb4C+kXmxAewryt3I5NcazdccA//H6MnoMQitj4CcBd2GXsYlHTW58r8jU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kL8oBs/1JPwv1vs8iPTM+H3vHOob8w+C+Ebxc7ulJk=;
 b=PtrEx2l6Q/IhcrtAXbsxvQHvn3DkXagd5E6uXLMLmvL2Xx/kWuhk/lP10P6HMpf05H3QmXirxX7h3r4Un5gSdNoRlrGDZ6eAHZ5aXJIwFv1w6/ks83fbMcdsqiEIoXuM/hk384b0F85BdGFKeeSksn3SWULGaa+y7LDAhtwXD5+ObUr/G7bQo42HnvdgXrjgJU3TEOA5pgkF63k7wh8kK5qyrLVSJBDd+s0X+7YSmQ/qDCp5wyTC5dHwDjIkpjwfXOyjSzf+tRrbIwinnCy/wkqoe7n3DV2XgIDXO7X4ipIAbCS+fJqciuzhWrSb7xcZSL7HTxgDSD3MRX7dZl8EBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kL8oBs/1JPwv1vs8iPTM+H3vHOob8w+C+Ebxc7ulJk=;
 b=FukwMs5co0TsVm1Qjnwn8EDCw+ZAStWsrK5eFWtL0IRtTFUyYL68CIgo2IqcAzgd6LfxyyT/+SmIRBdCF+nh3dDtp+HRTW6oywNnGE/mqPwQK19N59D/ivnn2EQblYtoVizHDP9mFxZmx/5Y3C0fDutu6OWWZlNWo6w6VselhbJrNtZpYjaN9ygpTLQPN70X6orn5DUE79X0puYkH8cdhpw5oxBHaKOn0fx2TOCqJW+DalYRhDbLbpMVYnl3wN7MdYw927+PngVr83A/5JdsaP9UTIhm7tDCMUk2vqkmT2CBdRGkrlzGDfYpGotDZwTtnI5CBYKjdQ83LgSzFwuv9A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by DS7PR12MB5909.namprd12.prod.outlook.com
 (2603:10b6:8:7a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 03:17:41 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 03:17:41 +0000
Message-ID: <b4aa46a5-dd8a-4520-8574-d008a3877f28@nvidia.com>
Date: Wed, 14 Oct 2026 11:17:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on
 flowtable offload
To: Julius Bairaktaris <julius@bairaktaris.de>, pablo@netfilter.org,
 fw@strlen.de
Cc: phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, lorenzo@kernel.org, nbd@nbd.name,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 rdunlap@infradead.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261004171636.3545085-1-julius@bairaktaris.de>
 <20261004171636.3545085-2-julius@bairaktaris.de>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <20261004171636.3545085-2-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|DS7PR12MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc0b751-8545-4b35-ea38-08df29a1b4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kA8f/qsQS36PB7mSdciJr1MEQjR9QaammDV/YaeJZ0bk4Luia2GQREKKY6e+kw6LlWWoWPYyanzIYbORr0MBh69CxV6LMmN3peVwVw2/uXmHbO2r4FeumSa4t4ULwN1mnaGNx+f0FpaTVXaB0QiAB4mEUWviKyCcCd2H8Ccyn/GybmgfCrjhpddbRZJZdO57OLE7EIQTazVqVoSw7JIiKc2POw+2bNmP+/UzfU7hiquldjJfel0LXHclYdGPdfe+FQAeSG29Yc2302DJzDwGLuXtd1TT9DKVjvXO4Q90YkeuLVeRUsuTo58w5daURiJVKdWQnInRwbjDCGJlN0i68B5K+wG9XYmmpL1wAoUBc35s14ndYpUn2ymgg4jhIABFW8dmTP/OuG9He0W86TQOOv3DOw5FBH2XWO9cIhvc+Epis1F4BvbpOwqTunndsShlVfYN6F6+MqWb+x/lU/gHko8B46AellhYGB6GQ5RxhgNiPGtNWhrdZxLxtLJ0fEQ82qNIrFGvN7KHFub28JHepbwQuhoytmxWYPNYX2CLNOSDRh6eIBwHMkMGrlHqWEJFYblrSrzGOocAi4yTQ6sNmCO9ggFnZOfsz5BZr4MnKkKYDf80eMNDyY9JXq4uzsGCBTV8tw55bHK/HCsx26husA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djJWTEtkTUMwU3IxWTRwTHZ4dy9mU3RzOEZ4L0NQN2lnc05NMjJ1S0xpM2d6?=
 =?utf-8?B?MFF0M1pMUDNZZkhvbi9jbUJnSnBNYm1ZbHJTcGRmbi9obG9jUU5idnUrWkNN?=
 =?utf-8?B?SVVjaitHYW5JbklaRVE2L0JOL2p0SGM4TU02dkxWbEZENU1wVzUvTFZESmFK?=
 =?utf-8?B?YmNUZ0QzOWlUdFJoMUlObVlpRStERXdBd3c0VTIvWFZLdDlFNDhtcU1TakQx?=
 =?utf-8?B?WlgvMTJLMGk1bXdTTExqYmd6VDJ4UmNCbFY0bXhGaEVMNThjeTYrY254Sk1w?=
 =?utf-8?B?a3NweS9ydW5DNXByR1FqS1ZHYlpMUWY5T2pUcmV2NkpISTN5TnFsY0tsSWpz?=
 =?utf-8?B?S0NBYUxseG9nNElyRWxiNjI5YXJ5VUx4TmR5dTFWV3hSNUZWK0ZTM2ljbkcw?=
 =?utf-8?B?N0IxNXpTL0JIZG8zTUJBYUJxRERIOGlZcERLMFY0dTFhMTFNN2VPOVVkNzNs?=
 =?utf-8?B?bmVtYUh4c1B3QlNjNEttWmdMTmx5d2hYamI3N0R5Y0NHK25TdGFqMlc0Mmhq?=
 =?utf-8?B?M3N3bGVHc0RYQ1M1TzlUaFVvY0pUUCtTSTYxa0g2YUNHR3U5OHRjcHo3cERT?=
 =?utf-8?B?eDQwVHdjK2UvZTVOcGNRdGRoT2dqVnVEOUFKMERHUCtYeG5sSk13SVhESElt?=
 =?utf-8?B?bG1IVTFLSVBZQkZzYTRhN1JuK1J3b3pIelRQNHdIUTJkV0ZBaVkzYjdzR2Mx?=
 =?utf-8?B?L1VmV2xhYXhQYVR2a1RKanMrUy9LSmk1TWVQZFZVWDRlZCtlUUZZMnpVRjlx?=
 =?utf-8?B?QWF5cno5Nk9POVVBdW4yaEQ5T1pVMWZnRGhCMGttYlFETDRRTXl1cFUreHFT?=
 =?utf-8?B?Sk81NnVmYXRzVmlwc0Vna1pVcGhwZ1FobjYvOGlsaUN3SW5SNXE0aHhQY09D?=
 =?utf-8?B?VE05cEtZN2lxbHpLY3JHVUR3WEQ3Z1ZOVXJWZEFyOTc2WXE5aXJiUWUzYmxJ?=
 =?utf-8?B?MG1ObzB5ZFJOUUVzYjc3RWZPTVlHQ0JVM3c0THJiR0NMb1JvZ0J6UjlWZ295?=
 =?utf-8?B?OGJoMjVPcU90RXVhaUJEbEJjcVNzRnVQb2FsL1ZBNTVnZXQ2ZHE4SER1MzlN?=
 =?utf-8?B?emd0dm82YVdVVVR4amE4OHZqS2QvV1B6MTNYQ2lxMElRbk5za2RQYm5XUXM1?=
 =?utf-8?B?MWIyaUtsYXVKa1gzNVBRcUxGOUZSL1RySXRFRHdGQ0FCbEVFcGZ2Yk9pOWla?=
 =?utf-8?B?MGFEWE5vdHkxUDBiejVaMnlseHJLMkRGVklHdXNqYW5INldTL0VQOGNReWlO?=
 =?utf-8?B?UDdYUkVDMUp2NUZwS1gxTlo1M1V0WTZiNGlYVVR1Mkd6MGxYdDc1TEM3S2J4?=
 =?utf-8?B?Wm1YZnlOcFppQlpiSGdOZnc4cWovVFJsT1VqaUczUys4b0pmT3UwdTIrT0JL?=
 =?utf-8?B?Q2oyM1RoaWU3VElQeDZPYkFKdTR1Z3VzNDR3bGJGNHpLWnd6WnFPbGwwT0tW?=
 =?utf-8?B?ZktnbXVmVU9EZlZVYkNOREQwYktueTdDRm5yZ3o0bHFCT3JkazFqTG16N1c5?=
 =?utf-8?B?UmZxMzcvQ21TcFlrVDFZazV0ckdrRE1VWTZvclpQL0RFdlB1NklMSXZzRXBF?=
 =?utf-8?B?QnhpNXVBdDl2Snl5ZlpBSWtKcXN5U1ZieWRYbTZ1bHFWYXArSmJWUnB0VjQ3?=
 =?utf-8?B?REpoUmxtaFNOaUlha1lMMGVRUVlpNzVRWlI3L0JybVZHa082am95b080bG1p?=
 =?utf-8?B?S3oyT05oNHFFWmt1Y0V5WnpMblVLQzhCVkprQk4wZ0VHZnFOVEFkeFdPcnd5?=
 =?utf-8?B?L1V0aFdhSXo0NUhjR1hiQWJpSWtQazYzRVhHS2VrODhCUUEzVXlFR3F3MFBI?=
 =?utf-8?B?czRtSmZ1OU9XOXp2T2RTQkYrNWtBS0FVZlAxUGJHT0lnbCtuZG5YZmR5OHdN?=
 =?utf-8?B?OHdOTU9SaUV2cDlBaTlCaVFadytveG96MnlUY0ljd3h6OHhvUTIzWDVBenla?=
 =?utf-8?B?OVd4MUJLSGM2dVRmUEl2Z3JUakJva1NUS3d1M1d1cTBlYkdZT1VtNWxCR0lm?=
 =?utf-8?B?YUNlZnZnSHJ5L2YwWFFZYklwMXhEdS96L0JWTnpNR3BWaDhMQThpTFQxRWVK?=
 =?utf-8?B?dUtrQzNiM3hPZWhCS2ZVR1JYUW5HMGoxWHlNaWVEZnNPTDhKbU96WDFlMVd2?=
 =?utf-8?B?L09uMG1pdTNncUhTYnBvS2VzV3RoelZocUlCRWRFVURSbEdpeXlwU1ZXNW95?=
 =?utf-8?B?aUtOdFZtSUJ0dXYvbUpLUUFwQTd0cVZLSUg2OExIQjAwNWs1MWdvTEtrSlFx?=
 =?utf-8?B?UjhjOTNBTmNzNmxKTDFtSjRpaVJ4c2haem1zeW1LT1lDMmc0bEdqeVJOVERK?=
 =?utf-8?B?VE9UMDZidVhjUjJCbDE4WUovbzN5VEVIckhNUWZrRzZQa093ZURwUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc0b751-8545-4b35-ea38-08df29a1b4c1
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 03:17:41.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADuRsCGrOiriwqV0vWjcxR1hNuzm0gqdRffuL7ryKcXnwmwidk503AdJTK3X4oUhbdn2aKF/j9tJEoJ9tk0D6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5909



On 10/5/2026 1:16 AM, Julius Bairaktaris wrote:
> The next patch makes the flowtable emit FLOW_ACTION_PRIORITY for flows
> with a non-zero skb->priority, which on IPv4 includes the priority
> ip_forward() derives from the TOS by default. mlx5 would reject these
> rules and stop offloading flows it offloads today.
> 
[...]
> +	/* The eswitch does not apply skb->priority to flowtable flows. */
> +	if (mlx5e_is_ft_flow(parse_state->flow))
> +		return 0;

The handler is only in tc_acts_fdb[] and only accepts flowtable flows,
so NIC mode and tc flower rules are rejected as before. Looks good.

The comment says what the code does, but the consequence is worth a line
in the commit message. Because the action is ignored, the priority only
reaches packets still on the software fast path, where
nf_flow_offload_forward() sets skb->priority. Once the flow is offloaded
to the FDB, mlx5 forwards it without touching skb->priority, so the
offloaded packets do not carry it. Refusing the flow to honor the
priority would keep it in software, so ignoring the action and keeping
the offload is the better tradeoff, it is just not obvious from the code.

I checked this on ConnectX-7: with the series the priority-carrying 
flows stay offloaded to the FDB like plain flows, and without patch 1/3 
they fallback to software.

Nit: "prio" already means flow table priority in mlx5; skbedit_prio
would be clearer. Not a blocker.

Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
