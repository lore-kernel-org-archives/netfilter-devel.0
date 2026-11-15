Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794757611;
	b=wYcT+SVJrp2cXUlPOda1YTP2rmwMCOnOjoqSRZU94cBk6rJVyzD6jKRDruyMXqpWQ4/q
	 kSyzthJnH+c+qUa9JR1E0gkdIjDi9DXMK92ZAfoiu2OiIE+1boPmUu4+F23R/sPbXWvNP
	 EiksZqFZfjWBct3hhQBc4FjDXxJCg+EmNvfORA19GqUjSUvZ8UwB60M/MUVOYz5ke7QFP
	 IMq0jRqOm9ES8cfPWBBBonbfUjIo2KKFPqxp/Y8WXZFvasTLtl+BAwpzdtXbqJRIp9VhA
	 JqGdEYpRUR7kYOmVnjTo6x8HJkb6Plkx94HMKkx1Nhgi5I3HatzT8tCtgLIx8slcGsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757611;
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
	bh=XgFVgtZJKwd0/J16bgpaB5ANWZ4t9GVYEDengX8O708=;
	b=3nQwe5IDacpZ+CqrKen4cFtreBzmrC+gwUFMynXiYN2ilOVZLDMZejqFVs03OSOGlc45
	 j5oDBJvDmbE9Y9s+hXMNnuNapGfKx4GCgObUucP171ERHvgD8Etx3lx1fyiVTxBeZwso1
	 ESdREeB7+ScMR95+KI4nhg4tq2WffdGHkrl+m90wI07MHR1zQJFTYciukc1VHf6itc25L
	 9nSOjv6O1gvLkyEaC1fJt88PJawOAHoPOgXI4dBtKeT//ii3mLsfZ0ETa+XWbREet3+oe
	 QDeSdPIETrPEDOJQT5srhfZuvTUL9UsiXjoDWeNqjfz9zJWm4rUndN0nOJ7lr6/tGrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="iGv8ml/t";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.38
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3921F606A31D;
	Sun, 15 Nov 2026 15:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3921F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iGv8ml/t
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EE61sxprMzk/mWM6070x0iEyhCRlH30mftQG5v5V1TreElcPO45o8YMJCzEIIUQJRoCDIpI45VwFPZRbmnPVvyTn0B5R1qfJvwV5XdgboIXPsMu8SVdN38Ie8CWhwlUPi4+REBfYlrYlHgikg8VqAQchrfwkbJKyf1XUNZyPhiwlMASFbHHZklwooB4lYLF8YbUityxYan9efigidYhnoAB0i/CyLgf20HaVPcQCSQJXDfuPeapoTXlPnibur0JeWcpFsydWXxAXjPgXkN8sexXAMZtAZtruRzZauQq/XVxVeTvXjV4agqIvdrmZoaWpVWRlo+u6iE+jjWpiiiNh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgFVgtZJKwd0/J16bgpaB5ANWZ4t9GVYEDengX8O708=;
 b=xUztpdbThU6QLzUjowCKH3RSE8ifY0nXNTkUmgvBSHR4pdsSkjEjXlLHTFRSTeMEEI22FBYBG6GV6aK9Bs4SKbnmFVK3QCWcVD6gfTPj1bKde7nJg2cjzv+a4qbPVVp29Jc2RM1zj2AmeCUcofx/JQ86CFUL6tFK+oErck1oCHmE70g4zJemL2N71F83zfSffzeyutUZNb6pD8MdFbx19euqozH7A3uCe6qh91oYia9l0gp8CJw2ePtp0g4S/r5YUsBnCUe1yGvS4w0y/eesThAutrsw8WPPriySgZ8MyiqdHhQZWw+yb/Ta2pcK/fB5D2tv8f41lJYroUVtG8G+lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgFVgtZJKwd0/J16bgpaB5ANWZ4t9GVYEDengX8O708=;
 b=iGv8ml/tg97cugoJ73pR8wvuxEqMle5pD5wGaB5jAUWz580rrhCmjDjTcojIRK8l0AXqZu7UqgdWY+FhEb0mbbgC6dD01/67kGrgN/JTPfM8/Ivo/du7wilqtAZMGVCxsNGNBfmGM4BBlSgjtW7CYdrQ+zsQjADuBgOLSG8W00KmTH7CaBvuKZ49tpzW7x3ZGVkYNzmyZ0SLIqqrwSbSh8W4vrIeAPLQmDK8bo1ZAjzNW3yavrddaI3YVOYHHoPC5jUS57RpYkF97aA+PGdhRAix4H5QRzToPqRkRkTDrc/7uvyW/WByey01a15q/U4RZPyvNP1Dvmk7kQWdP3ZP2w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by SJ2PR12MB9164.namprd12.prod.outlook.com (2603:10b6:a03:556::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sun, 15 Nov
 2026 15:46:47 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Sun, 15 Nov 2026
 15:46:47 +0000
Date: Sun, 15 Nov 2026 17:46:39 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Leonard Lausen <leonard@lausen.nl>
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
Subject: Re: [PATCH net v2 1/2] ipv6: honor prefix-length suppression in raw
 FIB lookups
Message-ID: <20261115154639.GA4121811@shredder>
References: <20261115114434.10343-2-leonard@lausen.nl>
 <20261115114434.10343-4-leonard@lausen.nl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115114434.10343-4-leonard@lausen.nl>
X-ClientProxiedBy: MR1P264CA0110.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::19) To LV8PR12MB9407.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|SJ2PR12MB9164:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e6bfd1-e951-4428-d60d-08df432fa815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|11063799006|5023799004|4143699003|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026140227099003|261022105027099003|261022075727099003|261026121527099003|261028144727099003|20052099010|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	rDkP8eLVVTQyeAI7Fh7HpkyKE74NBSiVihhfvQYdK3kEwVHKLz237H1xBiiG2iglVyafDpgOcGTKHYGmL6cthKlG/nvICqOs+ZyqqjQXqdKWz0YKaeunENN/pU5h4F6ozFGMvIU5IWA7HN6ZOPeAYtIJ3B389cn2GnAtJtkoSFfAytmxrOtjWmDaevyCFU5Nc3gWX2Z3IO6tviUO3DNBQjbx7T5zWGHAymNq59rXW/TexnzniGG7yNxo40k9H0KoxyXl0RjrnYgBwpVeLjJ8910Y9dVTe/qYCEMHfTyohSFARJtdl5UJEHajIVNyzikN79pg0J8Q1NP5Jz9T+/xTOpXO/y7ZetA7nQ9WM+OlSmSiZxcbDu/76mBKRBVQ3GEZvCJ5VVMKcEDqrTnBqPnSqMMPdehrepHbJlo0TZ/M51NOP0le8r5cmYLawUu2rH7X7OEg08b/w1zPeT8bPxV+dmSgzvhC3Oh1C5zrb6KBDY9nFnh4FQSmtb6vdQSwdeQgOIVockSv5ITMI1RYPRsLhe/wnQhJf8cz6POzlLtCBHJcCL8YDZHH5Gw+tNBK6cFtnQWS9MDG5NUf/EtIhTNigt6nOLjomFSOTqT4EGJ+jDlxUmkQR8uGMS/6kXIv3dXoS7IzvTEDYl0wS5sprulWldzre2EYKOCO2rR8yELfJgk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026140227099003)(261022105027099003)(261022075727099003)(261026121527099003)(261028144727099003)(20052099010)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SzVSTZc7Y6F5bixiby+P7ds6XQTexv0Jfs2xl82gzSB4zEfqpTpmS+GMFYiH?=
 =?us-ascii?Q?zXG3k7tRnEeKsXJwjLtGxa+ua7GyDCYjHPwclyRS+itvNhtgv/PfyDiqZDM8?=
 =?us-ascii?Q?Jyf1o7egc1HID8ka8VvVZ6Vb0gJnTtmmGJ6WQ2ZtzBgCmOW1lkJY1ViJOcQH?=
 =?us-ascii?Q?3bGO9GnpLS42z+KBXzmEnkEzmf1SApPpPLRGkymKPQ+xMpWKboKeTsgAdpQ/?=
 =?us-ascii?Q?MHrJNipbEgBdVYcvTNT4KuLwgLwZ5T6LZOhgwrdHcXC1+7mZidxHMvgsxQz9?=
 =?us-ascii?Q?gffPJm33uDvsz4RQOlpU28d83QYOE4pis2vM5Nkh+455t+WNtvNjivSWTLXF?=
 =?us-ascii?Q?GtoXQT3Iss6Ejzs0JTLqWfqAKeIwR3aO6bZz4AoxlRUYmSqo3v6f9a9ei8nB?=
 =?us-ascii?Q?iFmAQjwPoMdkRIozX0+FwgMhBu7fMeuSXPC0U5dGeDskvsAMfJlNXQjUcW5Z?=
 =?us-ascii?Q?iCuDA9j6q0W0HVaZzPawUIa7TsWM5HVKRXqc1InD3sSASoCSlpuS2GYyHhVS?=
 =?us-ascii?Q?d12/8YAyrCenftAg7rWUCjHyDeCbFnVEhA0PNLz144rcXpjPhY3jPuHqDfqk?=
 =?us-ascii?Q?YpXEZkSajzBBLXSN4rNlG/OHzQ/VanaUQN/JiMPxDMl077jmWZM+yJxbkJVx?=
 =?us-ascii?Q?hMOWnW2K6TLtWdOW9Ehc9Fd3yhbNgbcdqfbM9ATOCTV8ODANWY4NgObQ0mnR?=
 =?us-ascii?Q?NIqowBy2aO1CUP9o4TM4iDodVNGrViLOIHRJXk2OZcQPga7St5uR2+S5A7oG?=
 =?us-ascii?Q?+/ng8uZ+ZbxRgdi8swHU3NmpusDst925hrjlNTnEw08yTqDgouCIzMhkXjW0?=
 =?us-ascii?Q?DXO9ITGLRSvSWoqBEQyRkL6Vz4c9RSQ5z7Lo6E81hQu4GxKcxAfO7hCV3jvo?=
 =?us-ascii?Q?mV2j4XcxaW2FiR+VHoSz4cWdjfw522Q6FIY8pql+kGiQgYO7h2EkIQsh29O/?=
 =?us-ascii?Q?jnBHhtaYnhuqfv93KWVQfMILVa3iEUGa/Cy/vVt0Zn00C6nJxoy6ifJn+jn4?=
 =?us-ascii?Q?GY2KPQj6sk0z/HrBef8jS4qOlFPvbiONPGmDGz/tbo47h/uftcHNKEP1yNbu?=
 =?us-ascii?Q?xy4Da7EHz6/t7Jd4HJwZOoQ6V2w4UHtZtpNp9v5YIkoo/14B9m4MWG188xI3?=
 =?us-ascii?Q?2BVjPoQJHHlWD1g8TsseOENW7dsU1w1Rial3JPDMa7ND4yFyOKm7xyNpKXDy?=
 =?us-ascii?Q?7zmTkKD6pPWOc7qoKS08Vx3lsyBsR++Q+BpsECdeFKTb/Kq5qc+xXopVqgaB?=
 =?us-ascii?Q?k9XhWlWFbcTLu153c9CN+Rxlpl+d9eY/Sn1tsf1NVFz/KgE2Luu49EpnQZXs?=
 =?us-ascii?Q?MfjkGeK7nLfkbfvA+PK1zfMxipF/muYnN55he+OSC+JDCPDHHT86ICLrf9zH?=
 =?us-ascii?Q?TiQsm8pprFx1fAAWfW7tIFCr99gaePss8JBPUjNU2bbtGxqY/PU64q+AsGxj?=
 =?us-ascii?Q?tXblBS5mnPxnGor4kcQra2oNmKnnH25816UTEqFQH9M6l7Lq8dlQqi9tmeG4?=
 =?us-ascii?Q?XhxMuiqEOlEZACf+ogtUM/9ezDQFHvYZUsVNITbR1+CUjxQGEfgmJgcq0l77?=
 =?us-ascii?Q?ZWJD23sqxp/UB37aL3jpx8y4FYcMVNg6dRhGIkvdiy0n3tzsXZTKVnYELMzn?=
 =?us-ascii?Q?BZK3tPmbZcvmD4t+hHj9XWd8use3vQEr5pinelxyvBB8Wh1EJsz6OqfDDUua?=
 =?us-ascii?Q?MVP5SVxQlCr0oDbiGxDDyGV1En+z2PK4OLP/fLGBJtiP2dRL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e6bfd1-e951-4428-d60d-08df432fa815
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 15:46:47.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3113TvLNSWv56b0PNAtRz7txxgrbfa48zYMaLYAlSutdUsbUylp+/5+yz+AmoE3f70cqn7o/S/UI3AF6444Qyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9164

On Sun, Nov 15, 2026 at 11:44:32AM +0000, Leonard Lausen wrote:
> IPv6 raw FIB lookups populate f6i and nh in fib6_result, but not rt6.
> fib6_rule_suppress() only examines rt6, so fib6_lookup() ignores
> suppress_prefixlength.
> 
> With a policy rule that suppresses the main-table default before looking
> in a VPN table, an ordinary route lookup selects the VPN while an nftables
> FIB lookup returns the suppressed default. Strict reverse-path filtering
> can then drop replies arriving over the VPN.
> 
> For raw lookups, evaluate suppress_prefixlength against the FIB entry's
> destination prefix length. Preserve results marked RTF_REJECT: raw lookups
> can return zero with a rejection encoded in the result, while dst-based
> lookups return an error and skip suppression. Check the result flags so
> blackhole nexthop objects are covered as well.
> 
> Keep the dst-based path unchanged. Raw suppress_ifgroup handling also
> remains unchanged because the table lookup's nexthop need not be the
> final multipath selection.

Never heard of "IPv6 raw FIB lookups". This commit message [1] is easier
to understand.

BTW, I think that fib6_rule_suppress() should always work on the FIB
entry ('rt->from') instead of the dst entry. Currently, if the default
route has an exception for the destination (e.g., via PMTU), then the
default route will not be suppressed since 'rt->rt6i_dst.plen' is 128.

I will add it to my TODO list. This patch doesn't need to fix it.

> 
> Fixes: 138118ec96cb ("net/ipv6: Add fib6_lookup")

Should be:

Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")

The tag should point to the commit that introduced the regression.

> Link: https://github.com/firewalld/firewalld/issues/1600
> Assisted-by: LLM

Please remove this tag. See commit 1e035297ffda ("docs: remove
Assisted-by references").

> Signed-off-by: Leonard Lausen <leonard@lausen.nl>
> ---
> Investigated with AI assistance after VPN failures. Reproduced on
> unmodified v7.4-rc2 and verified with nft_fib.sh on the rebuilt kernel.
> 
>  net/ipv6/fib6_rules.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 0ffd7b47a046..ceb4180bcf2f 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -283,9 +283,16 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>  						struct fib_lookup_arg *arg)
>  {
>  	struct fib6_result *res = arg->result;
> -	struct rt6_info *rt = res->rt6;
> +	struct rt6_info *rt;

Unnecessary change, please drop. It also breaks reverse xmas tree:

https://docs.kernel.org/next/process/maintainer-netdev.html#local-variable-ordering-reverse-xmas-tree-rcs

>  	struct net_device *dev = NULL;
>  
> +	if (arg->lookup_ptr == fib6_table_lookup) {
> +		/* Raw lookups report reject routes without an error. */

/* fib6_table_lookup() returns 0 for reject routes. */

> +		return !(res->fib6_flags & RTF_REJECT) &&
> +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
> +	}
> +
> +	rt = res->rt6;
>  	if (!rt)
>  		return false;
>  
> -- 
> 2.55.0
> 

[1]
ipv6: Honor suppress_prefixlength in fib6_lookup()

When custom FIB rules are configured, fib6_lookup() performs the lookup
via fib6_rule_action_alt() which calls fib6_table_lookup() and only
populates the f6i, nh, fib6_flags and fib6_type fields of the FIB
result. However, fib6_rule_suppress() only examines the rt6 field, which
is only populated when the lookup is performed via one of the callers of
fib6_rule_lookup() such as ip6_route_output(). As a result,
fib6_lookup() ignores suppress_prefixlength.

This was not a problem for nftables until commit 1c32b24c234b
("netfilter: nft_fib_ipv6: switch to fib6_lookup") switched the FIB
expression from ip6_route_lookup() / nf_ip6_route() to fib6_lookup().
Since then, with a rule that suppresses the default route in the main
table before looking up a VPN table (as commonly configured for
WireGuard), the FIB expression returns the suppressed default route
instead of the VPN route. Strict reverse path filtering then drops
replies received over the VPN.

Fix by evaluating suppress_prefixlength against the prefix length of
the FIB entry when the lookup is performed via fib6_lookup().

fib_rules_lookup() only invokes the suppress callback when the rule
action returns 0. Unlike __fib6_rule_action(), fib6_rule_action_alt()
returns 0 for reject routes and instead sets RTF_REJECT in the result.
Do not suppress such routes so that they continue to terminate the
lookup, as with ip6_route_output() and IPv4. Check the flags in the
result rather than in the FIB entry so that blackhole nexthop objects
are also covered.

suppress_ifgroup is not handled since fib6_table_lookup() does not
perform multipath selection and the nexthop it returns might not be the
one that is eventually used.
