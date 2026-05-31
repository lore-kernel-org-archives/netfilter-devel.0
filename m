Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D9373BE0;
	Sun, 31 May 2026 12:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780229846; cv=fail; b=M0KvdfC8h2HtFg4KnLyGq25hy6SjAhqYK76PsGOXUbdroQavvOJ716QXunZtUs+wo5dYmDt89G9kRWd9T61bY9khZ9Wb8N0TopPFChi/xnISeTMBQEtjmXkzPYvuYMKnvBsoQvLWcLfh+k6FfEj2EasaV+1D96Obdd/9bl7vH5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780229846; c=relaxed/simple;
	bh=48vxZayvdtHhAy6PNs/yM2dRdorhEBBWQL4ANsWZJnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=POAUHGkkBaR3rYfb/mqsZ3gIJuSGMOE1VOx4wH0TRravjUjEK3fSYvGJe+R7vZjwQkjEv/414zio6Q8kyCfkRcL0qLkwyYYaDi6oHlbm6vbH87+LpdDrKtAh+1vExCeigifvFmS/J6+jWIaIB6ejcy0PYKAjFem1xfb+M7X8qUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HsKU85y2; arc=fail smtp.client-ip=52.101.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HsKU85y2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fA2sO3tRQ8XxZoz4CfRcizcIaTZXkRxrpWvTMc4bc9ld3WTNMg2P6Ttx0jx5sARYYqobgVHiOA3Bw7j6NA6za05U7czvJeT/PJNasECsdSwly80lD1YJyx3BMV71OUVgeHXP6EwXg8tj84iqJwqlTKdCRRdpqUeqMnnuSFyyU20hBwKwKdMItYqyZBjh/nkGqFaXVJj4IRggmwAgS3iILTOhvs3ncT7RXQCfZodJtfWzIzn9AM1DzV7IORMsVYp0FUwC1UPfzmdC38T6CtC6kp8s7+7bt64EMNROBw8e0+TWKXVm0X1my8QWgkhy6A07Qvu/PIDBjlz/BFuwx1X2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpDSLUDhcZeCY6Mn/X88UhfIufeO+0T8Q8HJS0+36LY=;
 b=i2ZKHLKwwQiHeq/rawIzXuBVfmHzQy0CtykgM7VTsfedhrPTZ6qaufWsQs2y+tcy6qu9al5X/WC2vhQenv6wNVGkltwNVrODqcRYG8U+TojJ+OK1nj/DJ2uIiTb3LFYkvJpLkQY0c88TCGvZ+rhURchMvYv6vtmpmivVbqX5KamwSbM5+5q/RXQ/6BtwpikRZZX3uyFDusGTGVbXupHkSeZjDQWa3f3rBmFQHyTcTFjhParAhKz/4UGleFrGX0rmWCXOi2EDRUZWw3Wrbn6shAhLaJZc9USCMr9LlN97hr/X92xvwhe3V5XUhB+Uq4xNapmYUhaaVFZWptjddOwm4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpDSLUDhcZeCY6Mn/X88UhfIufeO+0T8Q8HJS0+36LY=;
 b=HsKU85y2VFQC8hNpm4MdyRDz+LB36gwPnH8QIuGQQyAcG6SFlH7rX3+FbPRekxQB5QfpNGZi72AcLVBE0ExStYUCdotEZZK3BDMvc8qmobuUYmyq3rEl+gO3783/moMZgu8TTpASPGHKJjrOaJ3WKni90/vBMPB5p/1RhQFxXoqpA6E8i5gYwXAxjN1OCmL/1+AWFYCDmVvspHbesuInDYOf24jAzGys3OE+W2y5hPeF03jM4cTp1icsSjgAYZfnQ1bnyCjxBeTVwHR7sOwfj7RqGH/B7F1NyuIFU3WvrupfMzOgpQKRIFMZPdlWxAvN6p2yvn4UvOoV+huh3hJuIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by SJ2PR12MB9209.namprd12.prod.outlook.com (2603:10b6:a03:558::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Sun, 31 May
 2026 12:17:21 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%6]) with mapi id 15.21.0071.015; Sun, 31 May 2026
 12:17:20 +0000
Date: Sun, 31 May 2026 15:17:11 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Qi Tang <tpluszz77@gmail.com>
Cc: fw@strlen.de, jiayuan.chen@linux.dev, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org, dsahern@kernel.org, horms@kernel.org,
	lyutoon@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH net] ipv4: validate ip_forward_options() option fields
 against skb tail
Message-ID: <20260531121711.GA189496@shredder>
References: <ahlfI38aDciPfG2S@strlen.de>
 <20260529104356.911666-1-tpluszz77@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529104356.911666-1-tpluszz77@gmail.com>
X-ClientProxiedBy: FR4P281CA0245.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::9) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|SJ2PR12MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 1845237c-32e6-43cf-7d92-08debf0e901d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|4143699003|11063799006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Tp6fdEaupMoGW5IzFyih52LRTeZKckh+6eWbDNxJYCQi3b+iZXmiFnsV4Equa0GUGhKVqoW/JaWHtNzZICr/k6eU+W1uviMHZdBcdXMdsmrA3nFGNY/zLeCekAh0dy0jt0tFRmvuitW8PFemf+tRlzKlprTqhii7JjD85cj6chMnTu2qqTOJmUz/K+F9dgFIjST6s4CqGtHp0BDVDHKFwCZAomm2xvD3+BbS6OPz0M5+RR6CQLkaQt5RRoA0/xXmhL0K//4b4wVlhf8bTkkpL7DHxSSHpklhJh4Cn/hOR7696IsDfU2B1F0EKhIuogdIK+PRBdjDALJztHmyziMGSAo439da2wHnrt1Gm1tysgtUHG/+1AmfDM2OKmy3kF6h4UeCKS682RQpSVsnPjPo6DtP1xRP8HhiLX/SQAsxZhmZqVh04Hkn/YJxip4uSt2Inu/CvfzBtyuz/dggaU1ecTqmofy21yVdo2J53L5K2Yf4joAlfQm2fKZkokn6n9LqBNM0HyTtxXLXJePfv/d972JFM95zcVp+kumURqqua6GKF8wYgweipbRCvjhsM/gztB8zo1tj+vYBmPJJHn6e3ANyE5R9uItHfuc3GgQXjomA+Rc6MAf9sUpEX6myNQOX5WuJALgkNm0jDiwHyCbeYa9a9x5NRSXBAH546gSKVI9nozqqn4cnxMKcqVl19rOExGXrrApFsJJw0HguRgHOvw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8o26jfrp5SIkpsQlFmbUDNujQf4+9rwhcUrMY52Xfq7dvHX0Yo01446NkjKF?=
 =?us-ascii?Q?0e9Er/2vtRRtGB4iTBIi82yWmOmS3jv2W+N/fWm+KTh7xI8Zf9oa54PntfuM?=
 =?us-ascii?Q?WO2S3rdTuHY3xI9nLUmrrpl4+Ci4EjywHGTqqpgz4YB3o/FBvyKxzeGYu5oM?=
 =?us-ascii?Q?hftY1bv/60EIpo68KGOdRpvP2lOONQ9WUi3N2gTFvXVHAspoUmXSse+r4AKU?=
 =?us-ascii?Q?oGlIlA4JBVj3vfn4We7PLLyCFp05IEo08TtMrErfqwsddinJFBPaNldB8Jfh?=
 =?us-ascii?Q?BomTb0cYfKLJON4+WYk2DsWiGbaxKA184LlWvbI8m1nKYSSgcdAveqJN9ESx?=
 =?us-ascii?Q?d9bDfgraT0b6ZgW5rLU7umjok4pDvQH9uXBLZT+GGtSKdba8KX5FAauH9O0h?=
 =?us-ascii?Q?rQgJm+5Izp2XxcXjK6DTdfUuju9Shp7hXd3zM0CppJ3qKKOafzgSX72bJxZw?=
 =?us-ascii?Q?tVE3fxQqTFkBF/SHVS3TjaPgQXHCN7+yfOMqaXMoYjTljrjNvTWVu8SHMKJ6?=
 =?us-ascii?Q?xVUHkGbHjl13A6YFgSg1it4Lvuw0Ci0aGCLPwlL7VXepKGemcJ3Fko90tUKS?=
 =?us-ascii?Q?BoARwsReqCihQAyLoEI7fpFiO14vYxH7UD7eh31d/iglD+Chx0ZAHUdOp3QT?=
 =?us-ascii?Q?//ulk6ya1X1gECfbBlfqs8dm5JaJjq4246QrU3h7OYpFkA9zCpNByNCnsgNJ?=
 =?us-ascii?Q?9YfCKzo4rSyaX4GF6pGsyzP74QKoa1tM0eTtesvTl5WgA9l5rsJgGWTWJ4+U?=
 =?us-ascii?Q?6LjdAll/nNvM2McrDjrDeD6vw8tw9mBcw7NVaN7qiQggMOqDok6i+aqUga5S?=
 =?us-ascii?Q?k0PZkB6cqk2q/wqZuUTQe0zeYatnd40MPSVluKFDo6LbARLBu5/84c1aG5AB?=
 =?us-ascii?Q?tK+SgUzD6tCkAXftJ+srp+si1ieHqs2IZuFwjScQlYg9nv2Z/WmYwDz/F7he?=
 =?us-ascii?Q?slewy5vT1hCX4GegMJqfcHDagqFZawYmRxHkwXsuc55VuqcrUytdhRxd2nXM?=
 =?us-ascii?Q?rr8u8e91k0dYgJ2vaHfh6gnvadxjsoFFanZNJ3hodi7Cr1AGEST60L02jieU?=
 =?us-ascii?Q?adNFH+kiwYLLsHc6nw8AGuYTVGcbxy9Ap8/KxbXf7MoVX3twIv3viM8GGMYh?=
 =?us-ascii?Q?/ecG2Qx2knVCqkPek3GLBw/ZPmSkDOqA+n0cvB0t8HEgNNiURC8csNOMyylY?=
 =?us-ascii?Q?lC8uHz3N6mwJhr+ShtjAl77fnm4bkwcxr3rgNS3pDCt7DcSoFHr3ITVGGsPg?=
 =?us-ascii?Q?/9rfNxhfWAwCiQjegqubnzGZKkC7u5gzTSV1jI8A04MKNonAUuv8otEBc9P7?=
 =?us-ascii?Q?hs/oT360ApIa/MaTl026Ng35tLN+5E05yKshciGI5rsZqJBkxOPF0B6XvDZo?=
 =?us-ascii?Q?wtpM2TrIqOBHf7MGGspywDmKiM16AZRuvUCziq4nKdXqY//L1EAHlew7W9KN?=
 =?us-ascii?Q?raJInmjMau0pw9Y2D/VEbdZE6zwaV8zAq8TQmOcy37Vo99xS/ZeYAXRtHDKT?=
 =?us-ascii?Q?81WPALGP5sya6aEGfI8qlsPU0lrPbmY/mFNZS9xSPcw2M9HvQReuLPJiPxuI?=
 =?us-ascii?Q?4K23T+TxHfn0gmJJHFtmVPqFIVzywKjiYjFnnM181g5wAjclFMKRlgakAP5m?=
 =?us-ascii?Q?oUNCylw4yFvx1kh2dBrZhQukS8nbdRpK7fDAf79mCYocIKDBm6h73F2lW0b/?=
 =?us-ascii?Q?m2YVkxt8NUTvntKu+qFRSxe7/UlEosbA/hd4FpooHvR0RGvE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1845237c-32e6-43cf-7d92-08debf0e901d
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2026 12:17:20.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVIJgi2moovduHvwSQNz5xNv/0zEwU0TBNqVbS2WIvFomBmUx3ADAkPpd/3t3qvLVIkqCcKrqAK7dlPnqDxkcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9209

On Fri, May 29, 2026 at 06:43:56PM +0800, Qi Tang wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > I'm not sure netfilter is the only facility that can munge data this
> > way nowadays.  The plan is to disable arbitrary network header rewrites:
> >
> > https://lore.kernel.org/netfilter-devel/20260527121147.22076-1-fw@strlen.de/
> 
> Agreed, the source side is the better place for this on mainline.
> 
> I went looking for other ways into the window between option compile
> (ip_rcv_options() in ip_rcv_finish_core, after PREROUTING) and
> ip_forward_options(), and only found nft_payload and nfqueue at the
> FORWARD hook. tc/cls-act run before compile (ingress) or after
> ip_forward_options (egress), BPF at the netfilter hook can't write the
> packet (base helpers only, no bpf_skb_store_bytes), and the LWT_IN BPF
> path is blocked by the verifier. So your two-part restriction closes the
> only in-tree triggers I could find.
> 
> This is just one consumer of the pattern; __ip_options_echo(),
> ipmr_cache_report() and the CIPSO/CALIPSO netlbl_skbuff_getattr() path
> are the same, posted as a series here:
> 
>   https://lore.kernel.org/netdev/20260524041442.2432071-1-tpluszz77@gmail.com/
> 
> so if the source-side restriction is the way to go it probably makes
> more sense to drop these consumer-side checks than to fix each site.
> Your call.

FWIW, I agree that it would be better to go with Florian's patches
rather than always assuming that we can't trust the data that was parsed
from the IP options.
