Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33333449B00;
	Thu,  3 Sep 2026 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788447417; cv=fail; b=kUWADVSeN79qjcGWbY00aD4/XpMm+5n785/DD6B8F9oqkVncSWQGsmhLszGa/aaIsGEvMJ9jgYzWwhvaybqOFPQUmclWlTzRjjwOvxoFdNe28RXVZd6KvXp14UgcUD15+3mO67BsBQJuZRVgvte1zohIi70XyeyyWwIIF9cmDUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788447417; c=relaxed/simple;
	bh=HBpfbZrABma3nBhBy8xzDxuNQHS0kSRbzHyJKhn2X0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iw0nmu/8xZxI5wGEfATfsB+Y+4TcWizItp6d3WQFLaeEvt7A4xkDxMLg4E6RPiNwgzKT2rVwxgfLFrt4ktssQ3ZKTImjkp1VqTrYdGxurYbmqT2zS3xki7E0n+9xSOHM7sapbEcBEqzFcS/mW7dHsaOeCTwjkuXegwC/C6Mo/0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bNovHC8g reason="signature verification failed"; arc=fail smtp.client-ip=52.101.201.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bNovHC8g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSHEMyrvfWWEjC/eFkjUsL1YOdGv1mkJHeG50HhJUdZCXNwAgublcq7ebJSedukfLtQXYmz5BOJsznjqVqHzfW6a0De6AutekB01uxduq0TPKPJ/p/JOMp1cG/xuNK3OAkAGQHcoWjLVQxuV2SBk9X8sTq/sULiyJh/E2m470gmc6oOJpEmU/0RpzobU9FsvWn3by9AN3PIGd+iDDOBEfN7iIYpwInM2gSU5+UBwUMU4lfaj5AMHaEoTeXh7fqZHx3cmkyUxKzUNs5z8GY6fkIwGdZdNvvhiycDK9BB1YKZ1NBS//tnhajQfqtLip3PzqbPLwe/z7HE8NKM37hoTeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05XLMyosGQ1n9NZ1btwMp9PFm8zVPT+J1e2//5MTT2o=;
 b=aW10icutl0r4mZfO20WrpFpNIZtJ0oJ24Xc3HS7y+c6wVI7A5DA+uNE4moKqUmA7iFhH/ysqhEXnRpKMs7Tldm9hloXsRxFi8F8/dWSCTIWN+053PXmkRwUlXHR0bSg19IWRR48PvUVoaALYOKzoMQSS4gb93l/SMMiFgR9IQ/olkziUbJNjyDYKU0FnYKbBOvpUrv8Re53Vb+ejgXloSCIgjM9lL9CQiiW2bpY3FufjZDeS5l/PpejZVAXoH2lQikkfdJN8X0t5VWKZXNiF3sj/hohlF1L1mSVRYTzBhfPp96McWGVGYeFxsuLWge2qta2mXXnhjDrjfwypyl9ujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05XLMyosGQ1n9NZ1btwMp9PFm8zVPT+J1e2//5MTT2o=;
 b=bNovHC8gcg2VWMnW+ISpOn9nDu03PgPK92YX3BwfSzKDVUeJU22fFR0PJECx/bXteKlRlgMGoutq1JoDZne8WiQ1hwcSPZ6S2ohDQj9AXfdmyz0zGHa7qQcl+F4AEvIVUO86ZBJ+3arWj0Is4eWIi0MdfPNdT9PjGPr3UcZV/uyAZJEr7m2bczvSkoTFeFZ7dpjh0+ikC2KMTpxQ0ztnJ6E0zNvDCI0rwkIlqbxgjgGBD2zlCs4CNikTZw1L5jAUyj1l8qRzjrF6GF7kFOMh0+X65e1n1eJzKaAVXT9d/eHIUbAtDtLDf1Wsc1w5Bz280dNMH97fkiOB32xuroJY4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22)
 by DS5PPF482CFEB7D.namprd12.prod.outlook.com (2603:10b6:f:fc00::64a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 14:56:41 +0000
Received: from PH0PR12MB7957.namprd12.prod.outlook.com
 ([fe80::9251:acc2:cc63:3499]) by PH0PR12MB7957.namprd12.prod.outlook.com
 ([fe80::9251:acc2:cc63:3499%3]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 14:56:41 +0000
Date: Thu, 3 Sep 2026 17:56:31 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@riseup.net>
Cc: David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Neal Cardwell <ncardwell@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	dcaratti@redhat.com, ihuguet@redhat.com,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>, Phil Sutter <phil@nwl.cc>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Junseo Lim <zirajs7@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Leon Hwang <leon.hwang@linux.dev>,
	Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Qi Tang <tpluszz77@gmail.com>, Joe Damato <joe@dama.to>,
	Breno Leitao <leitao@debian.org>,
	Li RongQing <lirongqing@baidu.com>,
	"open list:VRF" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>
Subject: Re: [PATCH net v2] net/ipv6: don't route packets with unknown source
 address
Message-ID: <20260903145631.GA182962@shredder>
References: <20260903121057.80006-1-ihuguet@riseup.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903121057.80006-1-ihuguet@riseup.net>
X-ClientProxiedBy: FR3P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::9) To PH0PR12MB7957.namprd12.prod.outlook.com
 (2603:10b6:510:281::22)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7957:EE_|DS5PPF482CFEB7D:EE_
X-MS-Office365-Filtering-Correlation-Id: 257fa5b8-496e-4686-7c50-08df09cb9069
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|22082099003|18002099003|3023799007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	9qhu+qbQQfDm/k/22QuNQo3JsdPYxIISdAtiwVGBzt9OnGUejPJhyEADDlXnH3ECq82yUBn1wqHImJAyXsWoCS/HgkYTfHWEzAOs50TKMkWmqDgn+ngPbK5wN6iQdbKJ5XXE0akXBWCduuNfpM6PGWiieoOsQad35lyE76DlJg1grPygZJa2YFS/Up+/WPYXSP/uGHZ8DHPZzQVsaVnHhuRJRoQCUNqnadpbHD2PbJsAu02oyYFwng9ECFb03kAulb/iav4qC2rnofmFNFiddmyBEJZf0ARE1CsiPMHPVJKAJTmqVO45FwIKIDL0sSA4uv9Yy+OV3DDlaclXAVPC+2Z8fd+a0LnNsr1OCmtcpvEn0/1v1g4PqcWfjxzL28el+PzYdOp0UCAhb6pDs+VtsjQ57zHZYQQawuib/K4n0PsO3o+wB/JArrlp+VGljqOP5iqfahuWg1eSg1f67f8PMk+s9EEvIYJval/nM0DrOc45XD4Uh9za/2/xMsBOdZuSHQfbFjN6w/32kZJOUVCFqFGzKbMl8kzSW2AUnjJGPIJmBh0wSjFPmxtk7pEqLI+fdhJ6WkCnxNcpdb6ZbNXq0R3CAfayeTizr5JvRzcqgiTmFwQ9F5KwmHCAE3D2/KYMoMnWL43DHc+qkebCQ5LOWf7ke9F0hcM3cuodGfkviA4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7957.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?29ZQkZLGsoqNZusK2eVOTETr1t9Jm/l98IFmywcZXdtND0te/EuJt4+2pY?=
 =?iso-8859-1?Q?RIoLDa802hD4FAV/7BEBbWv6Pfy7ZdjFYBQQMaJYru+46qjXix2LSvKJVo?=
 =?iso-8859-1?Q?cWR+aFHvfPUYXme8AUtuVrV29/hqWZdgeBAeaJqNXASWMW4lA3C18hdbl/?=
 =?iso-8859-1?Q?kqzUaxarkoGJMHG6iY1Xb6kFt0+lH2C6cstVXSkj7jceUX1r6oIfJQrJqO?=
 =?iso-8859-1?Q?lJGZ3psJqL777y6C18Mo4c2APvjgG0i/WGDuWlPIRRXqMotO44TMmqKdEL?=
 =?iso-8859-1?Q?LRSMnNuERk3/IvEZ9Ehv64oRA2/QBP2loqJSppqYPPInEIfGw8Z5HEaV4L?=
 =?iso-8859-1?Q?Vg5k7K3D1ovW5ufZghQ/xKUDD0B9QZQk7s8Rm6se0ZENP2H/XwWspvbaab?=
 =?iso-8859-1?Q?s0xfS8NlbipUZy4OVI4ObobzwewRHguhMdvla+PImFBAdWP7mz9apGpWT3?=
 =?iso-8859-1?Q?imlCwGZRClCWe7tfOjKcxl2iRtV7DuRp6NFi1UyaDBpPlDVLzHWf9urzy0?=
 =?iso-8859-1?Q?NjVxs5xSKeSD2K4XAXmnAHRj3lq4diSW6o1qFslDjCsNxcMcDiQ+S9LT6V?=
 =?iso-8859-1?Q?VDSCZra/HgsNMfYRnld41Ss5SkcL/CJdtsRAObF9LZ/A36flnyh92fmdEo?=
 =?iso-8859-1?Q?fYG0LV4HhHvNv+qTtPW6BZjewee6FZD0nQoJC/uKqtM/AeEpL+Q4n2oHmY?=
 =?iso-8859-1?Q?VliOaQjgw/D6CmEM9stNd1/cSkFjeeuUFo+6/tPW8PGY9TDuBmAOtIeHle?=
 =?iso-8859-1?Q?a5XntG3xevi0zItE+S1PcXq4pKY/9ZZ33+zX04FbRykhD0KAgejIOGK9Ar?=
 =?iso-8859-1?Q?X5BAH5UgxC9qaiB0LodZijwjGx1yr94FLHc4aM3WZvxtvlF4ru8u+xj8jt?=
 =?iso-8859-1?Q?hRS5ndwzpg2NKKr+Vy36Wycc9TtAcm2I7waTbDBtj8eYHq/Ir7x+K5riQP?=
 =?iso-8859-1?Q?Wmnf0kpO9WDIlgbfQuV3XqgC3XgVlsklfHQA7DllMBLu6oufPnVLWrHVAU?=
 =?iso-8859-1?Q?tUku2R4ep/3x8361YQv+PSFvjZHVqeKcWOqvEuUnTjk/h7eGHDmi9ilgcJ?=
 =?iso-8859-1?Q?tiEI2ItjFuufSLxXLP5uZTwX+STbdhEh6qvEhF9qiZ04cYtQNK0V68djZ5?=
 =?iso-8859-1?Q?9JqYcXDKtKVuWQ3iHZc2gDOZHP86eMKoQ/RcFOyl2HOAZ8X5koER7qrRx9?=
 =?iso-8859-1?Q?AWo/LS5ZOVjyPDy7oSQwbd1uZUqBxX94vROmFKL7eIv8PWYIrfIHxx3DG+?=
 =?iso-8859-1?Q?yb2QNwsLy4shWiCylbS+DoRhYxQsGFdUpjTaR/2C208VG20DXJ58fHTbfL?=
 =?iso-8859-1?Q?iwEZRgil7G55Bb0deG3X2MvM2NRyi5lTnN73UNf7EsxodgEi3vPsdJn58T?=
 =?iso-8859-1?Q?b4K/N7YZfziQLXaTikIxlUVbL22WYLQnLE19z/QprFVdcZny/d+ljpZQVV?=
 =?iso-8859-1?Q?a0WK2yENPEwAGRS5i1C7vyZU4NyrqLUTwd7pylA6hOdSM/VY9+tCsEvF+l?=
 =?iso-8859-1?Q?GlH7Z9pska/NJIiw81w1vcqMR9dmwnJd7q1V7F3zlZ9FM8aICk1n5K6oEI?=
 =?iso-8859-1?Q?tA7e6+vqgPmRIUQxUzx6VayGSd/WSguoJ0TV9FwIJ61IERtJK/VId5cYdE?=
 =?iso-8859-1?Q?VOPxEABabINcR3HWyrfha7m926jkKr0wip98Emo1CZpWLqgkAn+8u+kuQC?=
 =?iso-8859-1?Q?0TOhWmG/SkFEcpLdvhlHsZHlnSIyK8jx+1UijD6folnOdeCJkVsW6m9meZ?=
 =?iso-8859-1?Q?6tioIppXMnGAGuQyE45HW9E2py71Ag1ql/JyBfACIQ8HPG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 257fa5b8-496e-4686-7c50-08df09cb9069
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7957.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 14:56:41.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdPepdS3k0luZrFPAGdAdfoot+nfZXT8AV25bxnCmVFE2z3REgaDECdnaUbL2a5UejH98SRD3Biec5UsbvSqkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF482CFEB7D

On Thu, Sep 03, 2026 at 02:10:40PM +0200, Íñigo Huguet wrote:
> Don't allow routing packets with a source address that is not configured
> in the host. Allow it only in certain cases like when using a
> transparent socket, by setting the ANYSRC flag in flowi_flags.
> 
> Until now, it was possible to send such a packet if a route can be found
> in the routing table for it. For example:
> 1. Configure an address 1:2::3:4/64 and a static route 1:2::/64
> 2. Establish a TCP connection to 1:2::3:4
> 3. Remove the address from the interface, but keep the route.
> 4. Packets are still sent out by the TCP connection because of
>    the static route. No incoming packets are accepted, though.
> 
> This patch prevents the outgoing packets to be sent in normal
> circumnstances.
> 
> This aligns the behaviour with the IPv4 stack. To determine the places
> where the ANYSRC needs to be set, I set the flag in the same places as
> the IPv4 stack does.
> 
> Apart from consolidating the behaviour of both stacks, there is a more
> important reason why this is needed. RFC 4862 states that "an invalid
> address MUST NOT be used as the source address of outbound packets".
> Therefore, sending packets with a source address considered "invalid",
> like an expired address, is disallowed.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>
> 
> ---
> 
> v2:
> - Fix a slab-out-of-bounds bug: in
>   tcp_v6_send_response we must not read the inet_flags because it may
>   not be an inet_sk, but a request socket.
>   Detected by syzbot, Sashiko and other bots.
> - Use the addr_type from saddr instead of daddr in ip6_route_me_harder.
>   Detected by Sashiko.
> - Don't overwrite flowi_flags in tcp_v6_connect when setting the
>   ANY_SPORT flag. Detected by Sashiko.
> - Fixed line length warnings.
> v1: https://lore.kernel.org/netdev/20260901115021.50057-1-ihuguet@riseup.net/
> 
> Testing: tested with a manual reproducer executing the steps described
> above. Tested also with transparent sockets to ensure that the packets
> are sent in that case. Also executed the following selftests to prevent
> potential regressions: fcnal-ipv6, fib_tests, fib-onlink-tests,
> nft_nat, nft_tproxy_tcp, nft_tproxy_udp.
> 
> The change in the netfilter's ip6_route_me_harder function is the one
> that I'm more unsure about. It was not clear to me the reason why it was
> done like this in the IPv4 counterpart. Please review carefully.
> ---
>  drivers/net/vrf.c                |  1 +
>  net/core/lwt_bpf.c               |  1 +
>  net/ipv6/af_inet6.c              |  1 +
>  net/ipv6/datagram.c              |  1 +
>  net/ipv6/inet6_connection_sock.c |  2 ++
>  net/ipv6/ip6_output.c            | 28 ++++++++++++++++++++++++++++
>  net/ipv6/netfilter.c             | 11 +++++++++--
>  net/ipv6/ping.c                  |  1 +
>  net/ipv6/raw.c                   |  1 +
>  net/ipv6/syncookies.c            |  1 +
>  net/ipv6/tcp_ipv6.c              |  4 +++-
>  net/ipv6/udp.c                   |  1 +
>  net/l2tp/l2tp_ip6.c              |  2 ++
>  13 files changed, 52 insertions(+), 3 deletions(-)

1. This is a behavior change, not a bug fix, and should be targeted at
net-next without a Fixes tag.

2. What is the motivation for this drastic change beyond RFC conformance
and parity with IPv4? IMO, these two are not a good enough reason to
make such a change with a huge blast radius.

Here's a recent example of a one line change that argued for IPv4 parity
and was eventually reverted due to regression reports:

https://lore.kernel.org/all/20260104032357.38555-1-yuhuang@redhat.com/
https://lore.kernel.org/netdev/20260521135310.GC977@cmadams.net/

3. See [1] for a list of regressions that AI flagged. Even if v3 fixes
all of them (which means a much bigger diff), I don't think such a
change will be merged without a proper real-world motivation beyond RFC
conformance and IPv4 parity.

Thanks

[1]
1. Any-IP (local prefix routes) stops working

   Setup: ip -6 route add local 2001:db8::/64 dev lo (or the rule + table
   form from commit ab79ad14a2d5), TCP listener on [::].

   Path: tcp_v6_send_synack() -> inet6_csk_route_req() sets
   fl6->saddr = ireq->ir_v6_loc_addr with flags 0 -> ip6_dst_lookup_tail()
   -> ipv6_chk_addr_and_flags() misses because the address is only in the
   FIB, not in inet6_addr_lst -> -ENETUNREACH.

   Same for inet6_csk_route_socket() on the accepted socket,
   tcp_v6_send_response() for RSTs, and icmpv6_echo_reply(), which keeps
   the incoming daddr as saddr when ipv6_unicast_destination() (RTF_LOCAL)
   is true.

   Effect: no SYN-ACK, no echo reply, no RST for any Any-IP address.
   IPv4 avoids this via the local-table fallback in __ip_dev_find().

2. Anycast source addresses rejected

   Anycast addresses live in idev->ac_list, not inet6_addr_lst. Three
   paths pick one deliberately:

   - icmp6_send() uses ipv6_chk_acast_addr_src() to source ICMPv6 errors
     from the anycast daddr of the offending packet.
   - icmpv6_echo_reply() with anycast_src_echo_reply=1.
   - ip6_datagram_send_ctl() accepts an anycast IPV6_PKTINFO source
     (commit 7c90cc2d40ca), then udpv6_sendmsg() ->
     ip6_sk_dst_lookup_flow() fails it.

   Effect: ICMPv6 errors and echo replies for anycast destinations are
   dropped with OUTNOROUTES incremented. UDP sendmsg() with an anycast
   pktinfo passes the ancillary-data check and then fails with
   -ENETUNREACH.

3. TIME_WAIT replies of IP_TRANSPARENT connections dropped

   tcp_v6_send_response() uses "sk && sk_fullsock(sk)" to decide the
   flags. tcp_v6_rcv() reaches it with a timewait socket for both
   TCP_TW_ACK (tcp_v6_timewait_ack() -> tcp_v6_send_ack()) and TCP_TW_RST
   (tcp_v6_send_reset()). sk_fullsock() is false there, flags are 0, and
   fl6.saddr is the proxied non-local address.

   Effect: tproxy'd IPv6 connections send no ACK or RST from TIME_WAIT.
   IPv4 uses inet_sk_transparent(), which reads tw->tw_transparent and
   ireq->no_srccheck.

4. BPF-set non-local IPv6 tunnel sources stop working

   bpf_skb_set_tunnel_key() sets key.flow_flags = FLOWI_FLAG_ANYSRC only
   in the IPv4 branch (commit b8fff748521c, added so a program can use
   e.g. a container address as the outer source). udp_tunnel6_dst_lookup()
   (vxlan, geneve, bareudp) copies key->u.ipv6.src into fl6.saddr and
   never copies key->flow_flags. Before the patch this did not matter
   because IPv6 never checked the source.

   Effect: IPv6 collect_md tunnels with a BPF-chosen non-local source get
   -ENETUNREACH while the IPv4 equivalent keeps working.

5. ICMPv6 errors under IPsec lost in the relookup path

   icmpv6_route_lookup() does a second ip6_dst_lookup() with fl2 from
   xfrm_decode_session_reverse() when the first xfrm_lookup() returned
   -EPERM. fl2.saddr is the daddr of the packet in error, which is a
   remote host when the packet was being forwarded through a gateway. The
   new check fails it, relookup_failed has dst == NULL in the -EPERM case,
   and the function returns ERR_PTR(-ENETUNREACH).

   Effect: RFC 4301 ICMP handling on IPsec gateways with a block policy no
   longer sends the error into the tunnel. icmp_route_lookup() sets
   fl4_2.flowi4_flags |= FLOWI_FLAG_ANYSRC for exactly this relookup.
