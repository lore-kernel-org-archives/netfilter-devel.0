Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145F730E852;
	Tue,  2 Sep 2025 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819115; cv=none; b=CMdVhw4AyTTyWsbv7yxBqc+9ZD16G3lkntd9gJvf6rgvhUfXBUdC9RzEMCoMrlA+xf9iI3kBvU4U8SAwWuK9HJ0Yv8UZoq4mqllV+QMCFYb6PzaH5e+CyJAR3pV9FEIuB2DPpmqFwdMRU08bhfxYLZDR0bNJgyadC4dZ2EDdwJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819115; c=relaxed/simple;
	bh=wcXHNkBQtrgjmA0wflq1a15s3Jy/DqxokYOrMmypoVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNiw4E2+bq/YUwrO+xTpmJ57cKDNokmWFwi9Y4e9b2hv7ZqDiLDw51aXwf0J7ql0NnKAlGxwruBofJXG0+dyftUUSGy/zYkohK23tTiPFiD3o+vYHQAaVVF3c5ceJsFwTmi1MQYbjHr4LkW04GJXxC5n6LWvkANDYsvk64yM2/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BC8F606DC; Tue,  2 Sep 2025 15:18:31 +0200 (CEST)
Date: Tue, 2 Sep 2025 15:18:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aLbuokOe9zcN27sd@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com>
 <aG2Vfqd779sIK1eL@strlen.de>
 <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com>
 <aHEcYTQ2hK1GWlpG@strlen.de>
 <2d207282-69da-401e-b637-c12f67552d8d@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d207282-69da-401e-b637-c12f67552d8d@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> > Thats because of implicit dependency insertion on userspace side:
> > # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
> > bridge test-bridge input
> >   [ meta load protocol => reg 1 ]
> >   [ cmp eq reg 1 0x00000008 ]
> >   [ payload load 4b @ network header + 12 => reg 1 ]
> >   ...
> > 
> > So, if userspace would NOT do that it would 'just work'.
> > 
> > Pablo, whats your take on this?
> > We currently don't have a 'nhproto' field in nft_pktinfo
> > and there is no space to add one.
> > 
> > We could say that things work as expected, and that
> >  ip saddr 1.2.3.4
> > 
> > should not magically match packets in e.g. pppoe encap.

FTR, I think 'ip saddr 1.2.3.4' (standalone with no other info),
should NOT match inside a random l2 tunnel.

> > I suspect it will start to work if you force it to match in pppoe, e.g.
> > ether type 0x8864 ip saddr ...
> > 
> > so nft won't silently add the skb->protocol dependency.
> > 
> > Its not a technical issue but about how matching is supposed to work
> > in a bridge.
> > 
> > If its supposed to work automatically we need to either:
> > 1. munge skb->protocol in kernel, even tough its wrong (we don't strip
> >    the l2 headers).
> > 2. record the real l3 protocol somewhere and make it accessible, then
> >    fix the dependency generation in userspace to use the 'new way' (meta
> >    l3proto)?
> > 3. change the dependency generation to something else.
> >    But what? 'ether type ip' won't work either for 8021ad etc.
> >    'ip version' can't be used for arp.
> > 
> 
> Hi Florian,
> 
> Did you get any information on how to handle this issue?

Did you check if you can get it to match if you add the relevant
l3 dependency in the rule?

I don't think we should (or can) change how the rules get evaluated by
making 'ip saddr' match on other l2 tunnel protocols by default.

It is even incompatible with any exiting rulesets, consider e.g.
"ip daddr 1.2.3.4 drop" on a bridge, now this address becomes
unreachable but it works before your patch (if the address is found in
e.g. pppoe header).

'ip/ip6' should work as expected as long as userspace provides
the correct ether type and dependencies.

I.e., what this patch adds as C code should work if being provided
as part of the rule.

What might make sense is to add the ppp(oe) header to src/proto.c
in nftables so users that want to match the header following ppp
one don't have to use raw payload match syntax.

What might also make sense is to either add a way to force a call
to nft_set_pktinfo_ipv4_validate() from the ruleset, or take your
patch but WITHOUT the skb->protocol munging.

However, due to the number of possible l2 header chain combinations
I'm not sure we should bother with trying to add all of them.

I worry we would end up turning nft_do_chain_bridge() preamble or
nft_set_pktinfo() into some kind of l2 packet dissector.

Maybe one way forward is to introduce

	NFT_META_BRI_INET_VALIDATE

nft add rule ... meta inet validate ...
(just an idea, come up with better names...)

We'd have to add NFT_PKTINFO_L3PROTO flag to
include/net/netfilter/nf_tables.h.
(or, alternatively NFT_PKTINFO_UNSPEC).

Then, set this flag in struct nft_pktinfo, from
nft_set_pktinfo_ipv4|6_validate (or from nft_set_pktinfo_unspec).

NFT_META_BRI_INET_VALIDATE, would call nft_set_pktinfo_ipv4_validate
or nft_set_pktinfo_ipv6_validate depending on iph->version and set
NFT_BREAK verdict if the flag is still absent.

**USERSPACE IS RESPONSIBLE** to prevent arp packets from entering
this expression. If they do, then header validation should fail
but there would be an off-chance that the garbage is also a valid
ipv4 or ipv6 packet.
