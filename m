Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9270E194A70;
	Thu,  7 Nov 2024 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973442; cv=fail; b=gF1jmI9s8tk1OSpGCaxICbEBhb5vGIL9w18AfYes9oMWLtUww8iXmol3tymWEcP47WRBAc5l80eNYa5wnHZ1suu85tAaz5ruvHgmY+vXnWwg4E+fcyfFjTw/s/Dk98AnZCwR8qR0fwUURve/zqIHUiohbUaJwlitB7uaUEOHz24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973442; c=relaxed/simple;
	bh=iZehKhNYg4uvaNTeqF3fiy1+mFTvRV2lkQ6rYU3SmE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Sbv9OQYzca59FtH+iBgqp5EDCiFNPh28KAblBOOdYIERCZmaP1QAQVOxxSiDiXlAN9c5+oPfr/PMi6MP3EcLuDs+ulqFxjJ7AmCXL30QjQpPZ5/5SqE7oE6Lipqk1sa4Pmi5igKEs/Vm/UE2hdfi+CdKAbb9kHSXVWcWg+IaIgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VDSDzqgq; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VDSDzqgq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ivnvktd5qbjcUeELq4m2xS5akZx7wULTcgzriNlHVTAmes43IVp2Pnb6KvefrpGCMCb2oYVw6eYuaMvTHUzHz61MinLm5m2hVyNv1hAXY0KPbqxw227aX2JVDoSaB419Ys/YJIV/fEpQoOgveY+RC8VBhJzVVXTi9yuc2FtyZEfjxDDmOvfYuM2ADEu0NhJMxcYLXNugtpPSnSV9DZxjZ5C7BSYDfwTl9drElX4vqUSp55tuNIyDEeUl5MInAaWoadCaAy5gJfA5/JiIbcCZRBTkq30m6veDT1Uec7Qs3jxlN4GEYdq5XKInNYuajQhQItlsK0JCZV1sWzfgV4lQXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MpimmCokEcT5mPnvtm2Q7frTV/a8WgO7XBYhxYbp1c=;
 b=d9rR0OkgkvkaNSu98HRnx3NJl1WUqDJygiysEM1Wt2NVviDJa+d/RV/Rm350oY5FrLqiVnU7CSofyXszgL+yn/3IsRL8MzQWXs8HP6CAgtNVSuMk0SjYlxVMhB9pVNqXCN/84cbtybmnB+Q6C3/djON5g/qm1Bpg+9CDfN407IAcOhHCCQGp92eXc4zeWbJFavfw2XKvrE+UEGIjhvCCd8d+y0d5WNyQTa/lUAg001TVuKGRFud30VAs/ZPlc0JAo2fKsoY9peeP7FIaVUTGf0ZxW/djQ0BAtiVdzSbZcj6Lcnrihvlu8GfwPwt97FfdsjiFJwe5wdPGC6U5YiCe6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MpimmCokEcT5mPnvtm2Q7frTV/a8WgO7XBYhxYbp1c=;
 b=VDSDzqgqGyoIn0Lut41s5K6eExL+I57N8ChoKK1DJGcCdSMQlHLEwuCry+G8MzA0gtw7D8YgDJ2wiPZLUUZdWuXjsQFJgmcGOiOapINtNlSWA2kzJSgLgAjWj+RiC83b6Z45+yEsaWgB26qPcZXJ32BgFz6juLWGZBzmp+ttvAhT5OjroTHUsNqnZdg5+4QQgHkMjJKFowk7Ox737BFcWcY/BCpgm5nxna2/oBcOTR6vt2+vvEeHcu0SiWfRULxWj7McF8n2suNQHEbmCndAX2HBVyDf2rgJxdJ/RErDUDGklGL1oLA7LTWQXHAFZEg1v4VXDUM0IM0LB7x+9POScA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by PH7PR12MB7139.namprd12.prod.outlook.com (2603:10b6:510:1ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:57:15 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::66fc:f8a2:1bfb:6de8]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::66fc:f8a2:1bfb:6de8%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:57:15 +0000
Date: Thu, 7 Nov 2024 11:57:05 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net-next] ipv4: Prepare ip_route_output() to future
 .flowi4_tos conversion.
Message-ID: <ZyyO8YWML6fGNbmp@shredder>
References: <0f10d031dd44c70aae9bc6e19391cb30d5c2fe71.1730928699.git.gnault@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f10d031dd44c70aae9bc6e19391cb30d5c2fe71.1730928699.git.gnault@redhat.com>
X-ClientProxiedBy: TL0P290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::12) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|PH7PR12MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: bfefb03b-2151-44d7-9fba-08dcff128ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4a5VBF5j/VpuRnWtOzFroPEP0B79F05qa4UONQrmSSqyCQQ3K+/nHgQK9TId?=
 =?us-ascii?Q?7qcQeJKKy0vhcFxjmBYe+w2fF9TaSGlpfGO7EJaBsvwJkG63rotkHohuCTak?=
 =?us-ascii?Q?p/6lBXSiCuy9H+tCsEQcga/IzZPpz2Buy6HfbUJpRoSGUrTJ6bz7yi2AuxkX?=
 =?us-ascii?Q?3hVVFneia2XAb+wbkjY/hPUaTPo4PlXEKSwEFbKjP57VbR+Zosu579G2M15S?=
 =?us-ascii?Q?y2IpvjMtEua6yo7f4zPQYNMTS352C95w0VHOO9V6mUW5lAoXAnUjuMqPuVKx?=
 =?us-ascii?Q?esMDpi5FFRyg513sJMwlairZJppY5QMsNeDmJGSpHRmpxclDTl+snjc3Ktjb?=
 =?us-ascii?Q?+JzAT27wQWBCOHo0M8mCttKobramscv9o0E79/6y7p9VThkI8Dss8HulhPDT?=
 =?us-ascii?Q?9KqujW6Ct9QJbLFXVO0GIpg9Jg3i4KfIpJ/c1Ab5HwJGvG0TASf0lNpPirUC?=
 =?us-ascii?Q?7v+qgxcjA67PijaAYwwPjF6QvqB5o0k9+eFnbdun8zinWXQD/xKgzq8hZj7F?=
 =?us-ascii?Q?LTZe2LgxgUzXZQzFs8YUBaWNczBCr01QYmOBXBmNpKSvietD522uKyPFS2M4?=
 =?us-ascii?Q?flbnH1Y4eAzRdrX5hxPKEBllBvt5rRDoVbcxwJt1te3ZKM3feUdpSdrbaDqq?=
 =?us-ascii?Q?MlIf9fX5t+4yeDAjGdJ9UCdgWOcFx1TNmDE0nYjBP4/AhWHA4zmHyFC10Ukl?=
 =?us-ascii?Q?A40AIIgDtfZE8Yr31jKYZTp3MLBvFJHzs+aD1AZ6/G02j7qdeIcDOVndWL5q?=
 =?us-ascii?Q?/5jct0qajOcO1vHuNMSj7chf4Qu5++R5ywwIL9OAu6wcaCgW3tUl5+9Fw3I1?=
 =?us-ascii?Q?uKbz9AVHRykaKoOM75KW6x21Z78nSX+D3NlQRm5bUn2jutq38kkZJ6ODIBfI?=
 =?us-ascii?Q?qmMtx/t2bjq78At3pZn59OblP6d27XoO1RkaDH+4XR6Z+oHBYvPjbvM/YtHj?=
 =?us-ascii?Q?mrClC1i/PJLzx0y8j0gXViZTjq40mOboyP1kJiavOtQQR0LinWVYg+QezkDt?=
 =?us-ascii?Q?Fw+6G3sC8sGiUWXAsueFEobb7LQVdV4T48ixcmu4jHOGPbWNqW2Ch4kkRoTF?=
 =?us-ascii?Q?esNdC96fLv2r8bGcEqLM12IfGbuD6X1UK+hlDN6TSwAEhGdasL+wXjrLHYVF?=
 =?us-ascii?Q?/75L7QckKPElZEzaWiGMR/JlEe6GtJ8SGUGO+zCFi2PKtBMJoaaahN5uXb9T?=
 =?us-ascii?Q?TNa08U1ETj4a/8Xta/aetgv7xMXHnPXdXNN2iOapg3miesI6Cg5FszBDuyGL?=
 =?us-ascii?Q?Tf4ae9YrSbW5sAODijUD+FWpngiA68BD2bEHnimV0+mMDfZSYHvEl4XYWEKq?=
 =?us-ascii?Q?SpmnaDQDeKtGq8ayUPRdcOk2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ujKKeHbizbO0E3tkfzEXClwPC8bVq/jh+aHhMdtKz6bXlBtXba+Mzv4kNmfv?=
 =?us-ascii?Q?o21BONkWwvMhGnSk+kiwVuu+Mo+Bay83+pNL3E8xhbBaWp6jiK/yy6jdE/GK?=
 =?us-ascii?Q?3TT4nm9I++vrEN5zuoLX/v0dVmnRLBN5Lqy6TT/AlfYzaVlCz6QJr7O75HV4?=
 =?us-ascii?Q?ltPPT9GDEEYUsczq71hGzFtOa9zE/X0qpQsH1xxuvh96OLL2VENTbRx1rfAw?=
 =?us-ascii?Q?dLCiL5hlbf/L2sWnKAZuCvGEV2G4z8UZoMhLAJJxkknzsGht7RSo/Vb68Dcv?=
 =?us-ascii?Q?tFklBRo3wgfZ80nc5IbGZw3bOrqugy2OpcUK8M+2ovqS/8GbIvXjxqkjzQLy?=
 =?us-ascii?Q?r91zrjPDMCdYM4JkNYTvq4jBt7rPtC0wfrMt2X+n/m4jWNZO+IkzHHRM0Ca8?=
 =?us-ascii?Q?8AqtCTBliO4KLtErJk+2CtYf9seqnHYDN4pH59egg0EShJ3kKmQBVKJBz5NN?=
 =?us-ascii?Q?WYuEJouqyVuLCKMULEsUvkYz6IgY+FKJvZP0RswDMec1dkntbQqVX7qjn5UV?=
 =?us-ascii?Q?BbrX5A5gB3/CIRNClFen68OgSl9MYLWYA2RvSo0IlOXKhRrN/DUrCjKzWtcS?=
 =?us-ascii?Q?d6iGOoZ34MU0uQyy2sy8Qv2oey1Lqq+nhAEGO/ZzjO0HRgqiHoGYj/oujc3S?=
 =?us-ascii?Q?qQ2IapJgXIwowZsPkVN0VqJXqVLxnVXmw1/5xpoB4TeTxbZC/3nyznETYo74?=
 =?us-ascii?Q?c445ohakWN5D0JkvbZLAtNnUIIx3VT92V6y0lWFB6cvqxWx0cijBXy6le6Op?=
 =?us-ascii?Q?oP/z6BedxY2refQJ2BS+OD1hg3tGgmRG2jtMBc/eLCQJDu/W731oTmBRcFfz?=
 =?us-ascii?Q?EmKcoFNLFORr+vGzGOUQPcQ4ISwn52VSfeD/H9ijv2cDO71nQ40nJkqvmu3S?=
 =?us-ascii?Q?b36m3V639bZJZoRXvQMPPCIWBU15t+CYYTvS3gw26+kjSRxGefrUS3UU3uZV?=
 =?us-ascii?Q?AyDgtJhndExZnlrVjgWCcU6p0uSCVE4TcvVx6OKI1wMJUqVNBYjVsLaRRta7?=
 =?us-ascii?Q?jQsLbf0NtIlikMakA54DJPNDAGkWBH+sMDmvpmMt0AXB7vzOZMYk36+sY5qm?=
 =?us-ascii?Q?uNDeExlBXUeEdArKIRXX6AOyacXD6Nc/jPuolH7wKA86kPnP8KMdfIpg3qcX?=
 =?us-ascii?Q?SKHGHN2w3qMarB0VfnuNDpyXZe+GbKtOuaBJKWv2sq9L5KpWFsRCv307Pral?=
 =?us-ascii?Q?klW+HAoWBjGX3iQ1XzhOcjMzqCdOn2G1EeFvesPL/OwuJUAvmdISa01dJbZi?=
 =?us-ascii?Q?N47FjV5v47GtBIgbV4MoU4DjdKK0nMbIDa742J5Fxw49Amu85iI7e4SE9YI8?=
 =?us-ascii?Q?YfgItIEE1A4TWy0NoFdRM4xwKhvDQydc660Zifb+nRWxZpjz05y7P6c/BoST?=
 =?us-ascii?Q?C7HwcOlVJIZmjDTGxhVi4ASYYemp9lMhQ6VNPQtjqxqnZQFy3OPnzaNemy/P?=
 =?us-ascii?Q?VUpTe+SsMZP93CGXIe9vWwjEkQgMo74LGcGY6sy0IwSwpFd3dQtxIEMkZefN?=
 =?us-ascii?Q?bqdkhMNnCSS4GEKuOCXp7V9p6mgvaP0yU8EPCK+ryvKRO0IMTTdpDh/T7Deq?=
 =?us-ascii?Q?9Yj8XsHrmwa54cvFB6qOGSYEJU+racuJmEussGeq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfefb03b-2151-44d7-9fba-08dcff128ecf
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 09:57:15.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heQYAc7bwm/jcyN0oGrcn/gRYJJKDrEu0zezvllmE/b+lniNf8zAtei4DjGaWpvqI8L4MHK70e8SW0K8qFbv5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7139

On Wed, Nov 06, 2024 at 10:37:32PM +0100, Guillaume Nault wrote:
> Convert the "tos" parameter of ip_route_output() to dscp_t. This way
> we'll have a dscp_t value directly available when .flowi4_tos will
> eventually be converted to dscp_t.
> 
> All ip_route_output() callers but one set this "tos" parameter to 0 and
> therefore don't need to be adapted to the new prototype.
> 
> Only br_nf_pre_routing_finish() needs conversion. It can just use
> ip4h_dscp() to get the DSCP field from the IPv4 header.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
