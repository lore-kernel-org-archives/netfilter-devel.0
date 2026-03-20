Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BE12DFF3F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774001825; cv=none; b=s5VB8/rRtTsgw/icyEFTcgTPZ9wjnB0iULdN3QgaleCCPi+H7dL2QV5GfmORt/kIzcnWLn521mo/MqA6NRwWjwrFu5sB/n0bFGIQjOeF6vD3cf+AUY7k83K+ibnfT1nc5h2fOyaJ1MtTOeHM2siHh2q8tZXaSDn73rjkNSEdUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774001825; c=relaxed/simple;
	bh=iXHKCgP6q49l0g0nHraKLqf26dAsqgpB9zLzeWkmQ94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lz+3F3zv682ev56kwFNq4DiI0pOP0ATm3Qc28dD3EP7pW7ImeCT2HnFZT5+i1av9M+Ue9iQslloAjD3uZX4c2v0WQSzNUmspWtaR273le9UT6/9P5vc94i568/vlAx38wp6i7Y7cof5/GScSPLcgieLT8kswfsqxBUqweQmi1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Cym9aFqm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Cym9aFqm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OcXZQgmTzjk8alCmy4JvPds2UMydSvFhwQwkaolpuDY=; b=Cym9aFqmCi4IX6X9Y4n5ER5S/q
	DymZdNK9A78ahT5howMZlSAWGvJ7lgVM3n6Afreybs5vul1yLEDPjbiv5kvl348KU8Dyt1hFwSaQI
	/nqVq7ZKg+FQw/GekKuItNeRXWzWBE4xAKJ+ghiFw8l0jR4zWAQoBJJrHgSSQR0HXO99T4k2tUqZX
	4iXgFc/9ZRLveNXYh2HdpaRHp1Z2tIyXLQijaAWtpcSkrNZKgSy2biWqC1D/UdEOAqwuupdAvZBzJ
	HUSY+wZ4GAx11JMY/CLnatx6XkrXlLr5d0l7PVK9EVuZkAacz2xg37kBHTJTnKCXov+mQoIP205eM
	nDyLZKww==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3Wua-000000005kl-2Jub;
	Fri, 20 Mar 2026 11:17:00 +0100
Date: Fri, 20 Mar 2026 11:17:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abyTyJBv47f3v9gd@chamomile>

Hi Pablo,

On Fri, Mar 20, 2026 at 01:24:40AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 19, 2026 at 10:08:30PM +0100, Phil Sutter wrote:
> > On Thu, Mar 19, 2026 at 06:06:10PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > Ah, so the nat-type chain's priority value orders it inside the
> > > > dispatcher's list.
> > > 
> > > Yes.
> > > 
> > > > Maybe I should print them below the dispatcher hook with extra
> > > > indentation? Maybe extra braces could further clarify, e.g.:
> > > > 
> > > > | hook postrouting {
> > > > |         +0000000100 nf_nat_ipv6_out [nf_nat] {
> > > > |                 +0000200000 chain inet nat postrouting [nft_chain_nat]
> > > > |         }
> > > > |         +2147483647 nf_confirm [nf_conntrack]
> > > > | }
> > > 
> > > Actually  one could override the hook value with the one of the
> > > nat base hook.  The ordering inside the dispatcher is whats important,
> > > the exact numerical value isn't important.
> > 
> > Hmm. I like how one can use 'list hooks' output to find a good spot for
> > a new base chain. The real nat chain priority value is needed for that,
> > but no point in considering made up use-cases. Seeing the chains
> > attached to a given nat dispatcher is already a step forward, and having
> > their ordering is probably well enough.
> 
> I guess the goal is to expose iptables and nftables in place?

No, I merely want to expose nat-type nftables chains. With iptables, I
see that we only get ipt_do_table instead of a chain name, but "fixing"
that is probably not worth the effort.

> Is it really needed to expose this internal +0000200000?
> 
> Maybe simply report instead?
> 
>          +0000000100 nf_nat_ipv6_out [nf_nat]: chain ip nat POSTROUTING [iptable_nat]
>          +0000000100 nf_nat_ipv6_out [nf_nat]: chain inet nat postrouting [nft_chain_nat]
> 
> Yes, it looks like a duplicate, but it is sort of how it works now, no
> need to expose dispatcher details.

A remark from a practical perspective: Florian's suggestion to dump the
nat-type chains in their order with the dispatcher's priority value is
super-easy to implement (just have to pass the priority value to
nfnl_hook_dump_one() via parameter) and does not require adjustments in
user space.

Given the benefit for current and older user space, I'd go with that
first and decide if we add extra netlink attributes to nat-type chain
messages for user space to print more details.

Cheers, Phil
