Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326FD244695;
	Tue,  1 Jul 2025 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751369811; cv=none; b=Q1QN1o7TYlIV6LJFnWSxJty8eF6GfotUkV614CPqS2ti1yWHxGizEbPiC1WGJRKB3NlWP6XHyzpXQa6ufw2L91eDVe59nZyabQQ2OMUN9YD5YldG9rJfUs/FOOsyXdyBird29YsCEuhovTyVITgkZLxoVhsVecM3zIbb2MoVeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751369811; c=relaxed/simple;
	bh=wKI4+gcpNu8aIvKh1/2gqYs5mqLtD+6FML0w2e1f3Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnM+c34kn3j6KONxfqs+CGBJpokx29fKEYjcPze6WxkM+ItdQqr5KBxeKybjnkWduYFgURxAik9ktShhToyBRsXkRiZq00CavVpvCChfWW2/2sMExO6AE8bAx/MhNfgAvGPpH/qq1QeRv1nI7tmttqQ+NLoB290DoYdNdjTWlUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 75459602AC; Tue,  1 Jul 2025 13:36:47 +0200 (CEST)
Date: Tue, 1 Jul 2025 13:36:47 +0200
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
Subject: Re: [PATCH v12 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aGPIT00m9THn8ABO@strlen.de>
References: <20250617065835.23428-1-ericwouds@gmail.com>
 <20250617065835.23428-2-ericwouds@gmail.com>
 <aFhksV47fCiriwJ4@strlen.de>
 <9866f2d2-eda8-470f-99fb-5a8d6756de56@gmail.com>
 <753902f3-4b11-44f7-9478-02459365a8ef@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <753902f3-4b11-44f7-9478-02459365a8ef@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> > Adding offset to skb->network_header during the call to
> > nf_conntrack_in() does not work, but, as you mentioned, adding the
> > offset through the nf_conntrack_inner() function, that does work. Except
> > for 1 piece of code, I found so far:
> 
> A small correction, Adding offset to skb->network_header during to call
> to nf_conntrack_in() also works. Then skb->network_header can be
> restored after this call and nf_conntrack_inner() is not needed.

Good, thats even better.

> > nf_checksum() reports an error when it is called from
> > nf_conntrack_tcp_packet(). It also uses ip_hdr(skb) and ipv6_hdr(skb).
> > Strangely, It only gives the error when dealing with a pppoe packet or
> > pppoe-in-q packet. There is no error when q-in-q (double q) or 802.1ad
> > are involved.
> > 
> > Do you have any suggestion how you want to handle this failure in
> > nf_checksum()?

I suspect nf_checksum() assumes skb->data points to network header.
Several places in netfilter assume this, which is the reason for all the
skb pull/push kludges in br_netfilter_hooks.c :-/

git grep -- 'skb->data' net/netfilter net/*/netfilter | wc -l
66

(not all of those are going to be an issue, such as ipvs).

Some callers do this:
if (nf_ip_checksum(skb, hooknum, hdrlen, IPPROTO_ICMP))

where hdrlen is the size of the ipv4 header.

That won't do the right thing when skb->data isn't identical to the
start of the ipv4 header.

Others do this:
 if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {

... where thoff is set via nft_set_pktinfo_ipv4(), so it *might*
be correct if nft_do_chain_bridge() is updated to follow l2 encap
trail (switch nft_do_chain_bridge() to use the flow dissector?).

but in some places thoff comes from this:
        thoff = ipv6_skip_exthdr(skb, ((u8*)(ip6h+1) - skb->data), &proto, &fo);

... which should have the right offset regardless of skb->data is.

So AFAICS the initial step has to be to go through conntrack (and all
conntrack helpers) and get rid of all 'skb->data is l3 header' assumptions.


Then repeat for nat engine, then for nf_tables, then for helpers such as
the nf checksum functions.

IPVS, ipset and xtables can be left as-is AFAICS as they will only see
packets coming from ip stack.
