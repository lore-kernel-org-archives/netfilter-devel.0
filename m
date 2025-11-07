Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1C4A0C;
	Fri,  7 Nov 2025 00:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762473977; cv=none; b=buKjeVzW32rI4EkRLth49xlx8Qb/W8exjMrHVyqTBLcyJa/BpYUtS7xbLXU4DD2TyQrmmuJfNlbKogsojzOUrdv5kgfTt+WDVKakjrz38HF/yuePs3UH0SsAblhHWJgu4SjVO10F7qsKAEIaycpmFzTB6yTH9DRwkYfwASRmGKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762473977; c=relaxed/simple;
	bh=lAEFtF4IVOn7eBjUXI7mHzgCxFs5I6xmj63FmnOrf+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=acRucjui8xdXrGjFrES6KZVlffT9/m4S1XElRbyEiqhJo6aDlBfEZFgrO1EuonWn3xtG11xk3ubdnRL6bKrJT/b+Jiq2ixpL6oV5tPkx6P5j8iQJPvZpv/ohqASyMe57Z7EfMVPNiHKXBjgbPssW9oGrDpndxd1aEO8i4xwdapQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A7ED7601A1; Fri,  7 Nov 2025 01:06:13 +0100 (CET)
Date: Fri, 7 Nov 2025 01:06:13 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v16 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aQ039Zn_r9woDImN@strlen.de>
References: <20251104145728.517197-1-ericwouds@gmail.com>
 <20251104145728.517197-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104145728.517197-4-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> In nft_do_chain_bridge() pktinfo is only fully populated for plain packets
> and packets encapsulated in single 802.1q or 802.1ad.
> 
> When implementing the software bridge-fastpath and testing all possible
> encapulations, there can be more encapsulations:
> 
> The packet could (also) be encapsulated in PPPoE, or the packet could be
> encapsulated in an inner 802.1q, combined with an outer 802.1ad or 802.1q
> encapsulation.
> 
> nft_flow_offload_eval() also examines the L4 header, with the L4 protocol
> known from the conntrack-tuplehash. To access the header it uses
> nft_thoff(), but for these packets it returns zero.
> 
> Introduce nft_set_bridge_pktinfo() to help populate pktinfo with the
> offsets, without setting pkt->tprot and the corresponding pkt->flags.
> 
> This will not change rule processing, but does make these offsets
> available for code that is not checking pkt->flags to use the offsets,
> like nft_flow_offload_eval().

Thanks.  I think this is fine and we can extend/change this later on.

> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr;
> +
> +		if (!pskb_may_pull(skb, VLAN_HLEN))
> +			return -1;
> +		vhdr = (struct vlan_hdr *)(skb->data);
> +		*proto = vhdr->h_vlan_encapsulated_proto;
> +		skb_set_network_header(skb, VLAN_HLEN);

Could you move the skb_set_network_header() calls
to places where we know that we have an ip/ipv6 proto
in the upper header?

You already return the length of the encap header
anyway, might as well restrict the skb nh update
to when it will be useful.

Or was there another reason to do it this way?

If you prefer you can only resend this patch, I believe there
are two different use cases:

This patch as requirement for future ft offload of ip/ip6 packets
in bridged pppoe/qinq and this patch as starting point to eventually
allow 'ip saddr 1.2.3.4' to auto-match for PPPoE, Vlan, etc.
