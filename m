Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA11D26FA7B
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2025 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752155767; cv=none; b=cL5PH/gnIrKy1ewWlAHzB7gr6v3mxMmqW/CEOIfp6EtmL2TSl2Hec8YodG+wfau/CCteYM4FmQSAScI3nQshrrh5XeaG9h02v1K9FIw0Gn9mzgHYy7r9rlpfn9xA9xA6ALsLoVFfFNdjtZLC5lQXe5LvyuwxVR5qFjghUAgObmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752155767; c=relaxed/simple;
	bh=5wWfP24HgJLd1r4rrITCOSI6YqcsgVpKvrjffjQ1nY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCc8AkUfD5cOQDG/5xjAicxCLAYpRt0Xx34xeLgFPY2ZTmmr5X7exbt0OJj8cLbMW1H/irYGOrlb7BMejfjHiDJTqv+2YhIX9DRjm5xh5DLs8JzgZ2JXaRKu+byGOjYqFqyPRWuxb+H/aLwXmak0uD53CGQbeHJgetCjCU0oVSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l6EApxXG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l6EApxXG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J0w1hGBeLIK9BSbnNACzhZPQOFJpmW93uuGZEFzVKyw=; b=l6EApxXG9GnklQToN2ECVO60ZS
	02iyd6Gga/JabxsQVrQKT1x+aslxw6TGGmyNFbP7VnJLqLvERxiuqtwYLkv5HoYP9V+syP5uGK4jb
	Y9/d5HdjoyYmBsv0pFdwxSfy1La2N2kqRUDzb0ps6XRSDdeKWVNTvmiX91xRqpWNAq8cK75vpqpsk
	S+CzBUqfqG/DMGwmIx5QVO9AplrRAfuhG6J2lx32+CriOgcfS4Kb92kyUL8Fq4QdyQavtx665hakA
	WJiju4cUt3wCWa1SX8VIFdyqc7pCaJelRgNBGPaC9rbQzJJV96RhHSTUsmm3+qwJjTs6mZXDdY7Vf
	99T3JXhQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uZrki-000000005Tl-2O4D;
	Thu, 10 Jul 2025 15:55:56 +0200
Date: Thu, 10 Jul 2025 15:55:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aG_GbJyabgb21jdZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG7wd6ALR7kXb1fl@calendula>

Hi Pablo,

On Thu, Jul 10, 2025 at 12:43:03AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 08, 2025 at 04:38:44PM +0200, Phil Sutter wrote:
> > On Mon, Jul 07, 2025 at 09:25:50PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 04, 2025 at 04:04:39PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > Please keep in mind we already have 'nft list hooks' which provides
> > > > > hints in that direction. It does not show which flowtable/chain actually
> > > > > binds to a given device, though.
> > > > 
> > > > Its possible to extend it:
> > > > - add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
> > > > - add
> > > > 
> > > > static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
> > > >                                    const struct nfnl_dump_hook_data *ctx,
> > > >                                    unsigned int seq,
> > > >                                    struct nf_flowtable *ft)
> > > > 
> > > > to nfnetlink_hook.c
> > > > 
> > > > it can use container_of to get to the nft_flowtable struct.
> > > > It might be possibe to share some code with nfnl_hook_put_nft_chain_info
> > > > and reuse some of the same netlink attributes.
> > > > 
> > > > - call it from nfnl_hook_dump_one.
> > > > 
> > > > I think it would use useful to have, independent of "eth*" support.
> > > 
> > > This is a good idea to place this in nfnetlink_hook, that
> > > infrastructure is for debugging purpose indeed.
> > > 
> > > If this update is made, I also think it makes sense to remove the
> > > netlink event notification code for devices, I don't have a use case
> > > for that code in the new device group other than debugging.
> > > 
> > > If Phil's intention is to make code savings, then extending
> > > nfnetlink_hook and removing the existing device notification group
> > > make sense to me.
> > > 
> > > User can simply resort to check via dump if a matching hook is
> > > registered for eth* in nfnetlink_hook.
> > 
> > What is the downside of having it? Are you concerned about the need to
> > maintain it or something else (as well)?
> 
> I was considering that nfnetlink_hook is a better fit for this
> purpose, these event notifications that report new devices could come
> from net/netfilter/core.c instead. That is, nf_register_net_hook() and
> nf_tables_unregister_hook().
> 
> You also mentioned you originally used this syntax:
> 
>         nft monitor hooks
> 
> which, after Florian's suggestion, made me think all this belongs to
> nfnetlink_hook.
> 
> This would avoid an asymmetry in the API. At this moment, new device
> hooks are reported via nftables, but listing will be retrieved via
> nfnetlink_hook.

Ah, I see.

> This would also provide a generic infrastructure to report hook
> registration and unregistration, as a side effect.

OK, fair with me!

> If you accept this suggestion, it is a matter of:
> 
> #1 revert the patch in nf.git for the incomplete event notification
>    (you have three more patches pending for nf-next to complete this
>     for control plane notifications).
> #2 add event notifications to net/netfilter/core.c and nfnetlink_hook.
> 
> Only -rc kernels have been release containing the incomplete device
> event notification. It is a bit late to revert to be honest, but
> better late than never. This infrastructure is triggering more debate
> than expected.
> 
> And that would be more work on your pile to respin, which is always a
> hard sell.

No problem. I'll quickly submit a revert for nf.git and attempt an
implementation in nfnetlink or core code "later" - I assume the
flowtable support in 'nft list hooks' output is fine to satisfy the
traceability requirement for name-based hooks and so we're good to go
with the user space implementation?

> > I had extended the monitor testsuite to assert correct behaviour wrt.
> > adding/removing devices. Implementing this is in a shell test is
> > trivial, but still work to be done. :)

I'll then drop the 'nft monitor' addon for now and write a shell test
using 'nft list hooks' to validate correct behaviour instead.

Thanks, Phil
