Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959D198E99
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 11:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547221; cv=none; b=PGjNPstu1U9z99cBl/BfImRxPWVVWQm8VaMBjeEQXLFjOntxcPD77TaS9iChWH//fb9qyKeFcf15p1skdpJouZJddP4nAF9urRowI90Wrv0iHmnmgJ8UGpui6bmMMRtuEtGR3icE99kHBG6AG0b+8xkWLQ8ev4EJ22ldZadNyPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547221; c=relaxed/simple;
	bh=BMUk9SEQMerGo9BbFMGIRF9/354ZEzQ8bNsYjh9So5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRgrEJRFs33cfaWTmnUr0SP/7Vj7IrUpFtGXjZ8MwJynUB8D7eXk1oxJHIoJhagybE+n/9tG12EE6lqN1g4ITKw0iUBwKvZJZzPw2c/cc/GmjqINGdzgLlT3k7DttszsFLXzeBN0zVjy4oG+y9HXxMRMgqwbNDfUFFXxxLrjTso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TdYtgaWP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TdYtgaWP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PqCOrpTB/5/4u0d5HgHrSFVPTHjVPLqcUsUO1kjaYzs=; b=TdYtgaWPFpG4EYYdwXPft5Uj2u
	D9w/vdob/BslB1hl0vt/4oo9anwE5ABflxLLXpMQjkXOJW1J9hvlbaAGs8wyEnglgrWXAO608CHWC
	63TfU5g+woABm7EzjtK5X757blMUqQSXXTznEYbJc4xQMiBUTl7p7B+ZKidYI89Ezq/6lPFhVyT5h
	80Br2JuO93vYbaHJ1U818tipmBorQzF/kYRUbbQ8hVvnqE+ao8FrR1CsBh1UQSSoWx64R47VdyQmq
	XZ6Heb88HWZCtrFn7MQKNF4Qb1ppjn7flaMFjg1JgHDeEGoziLXj3Nrl80ofaoEuGBTdNMGHRt/5o
	GFvAqx6g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sdpMX-000000000eZ-3Vtf;
	Tue, 13 Aug 2024 13:06:49 +0200
Date: Tue, 13 Aug 2024 13:06:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <Zrs-STpwUN2rqnl2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
 <ZqbgmMzuOQShJWXK@calendula>
 <20240729153211.GA26048@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729153211.GA26048@breakpoint.cc>

Hi,

On Mon, Jul 29, 2024 at 05:32:11PM +0200, Florian Westphal wrote:
[...]
> inet ingress is already awkward in my opinion, I'm not sure why it
> got added.

I suppose the ability to reuse other inet family ruleset parts for
ingress was a sought-after feature.

In hindsight, making tables family-agnostic and thus pure "containers"
for grouping ruleset parts might be a superior design choice. (Or maybe
I just miss the rub in doing that. :)

[...]
> I agree that we first need to figure out what 'nft list hooks xxxx'
> should do.  I would prefer 'no guesses' approach, i.e.

Let me suggest a deviation which seems more user-friendly:

> 1. nft list hooks
>   dump everything EXCEPT netdev families/devices

Include netdev here, make it really list *all* hooks. Iterating over
the list of currently existing NICs in this netns is no big deal, is
it?

> 2. nft list hooks netdev device foo
>    dump ingress/egress netdev hooks,
>    INCLUDING inet ingress (its scoped to the device).

Drop 'netdev' from the syntax here. The output really is "all hooks
specific to that NIC", not necessarily only netdev ones. (And "device"
is a distinct identifier for network interfaces in nftables syntax.)

> 3. nft list hooks arp
>    dump arp input and output, if any
> 4. nft list hooks bridge
>    dump bridge pre/input/forward/out/postrouting
> 5. nft list hooks ip
>    dump ip pre/input/forward/out/postrouting
> 6. nft list hooks ip6 -> see above
> 7. nft list hooks inet -> alias for dumping both ip+ip6 hooks.

I wonder if this is more confusing than not - on the netfilter hooks
layer, it doesn't quite exist. The only thing which persists a tad
longer is inet ingress, indicated by nf_register_net_hook() passing it
down to __nf_register_net_hook for nf_hook_entry_head() to return the
same value as for netdev ingress. I guess they could be spliced even
further up.

> This also means that i'd make 'inet device foo' return a warning
> that the device will be ignored because "inet ingress" is syntactic
> frontend sugar similar to inet pseudo-family.

Iff my claim holds true, there is no such thing as an inet hook and
thus also no inet device one. :)

> We could try the 'detect pipeline' later.  But, as per example
> above, I don't think its easy, unless one omits all packet rewrites
> (stateless nat, dnat, redirect) and everything else that causes
> re-routing, e.g. policy routing, tproxy, tc(x), etc.
> 
> And then there is l3 and l2 multicasting...
> 
> But, admittingly, it might be nice to have something and it might be
> good enough if pipeline alterations by ruleset and other entities
> are omitted.

I seem to recall us discussing something like that on NFWS, but to
simulate traversal of a packet with given properties through the
ruleset. Which would also identify the hooks involved, I guess?

Cheers, Phil
