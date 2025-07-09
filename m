Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF6241CB2
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 22:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752100994; cv=none; b=WrqWCHQvaZMN+2TiW0ACSHl7Dql8BURabS9QBGiu87ryrprseNLXpAN+k7v+2e93ylP53VF9KTYktBxHNXJEYQdQqnMFVc8ehgEk5q9E3vzCpFJrRSWbrIotxqnxOCmoL93op3jqv80mi+v8yTxRAqYpw8P7OP6Ed+9JL8x0WAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752100994; c=relaxed/simple;
	bh=NoE8h3olPCfGj4q/dfkiV31VbcBv1DI90Zef9TttsRo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZPoTBGktivA0lBnSX14NeEPsa9FLsAb4d9KqkTqpU2asrdUJAgUXYk4XcfzJi83/EH8r1VTazaJ/7KzS8UAgile2soGobMGG+UX1UcnJgruSO/y4KYx/6zTxFx8aZHXbCIfoK+mY+aVXNfg9ffLac+KtftKu2XI07TWKAlhFCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iqsdItf8; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oclgqTAl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iqsdItf8";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oclgqTAl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B405F60289; Thu, 10 Jul 2025 00:43:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752100987;
	bh=R8F+L/rTAALKIXS/lfLPKVppmVSzhjIVHt74KTIH0bA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=iqsdItf8u03aYjW4GqQG8aKuM2SX5oBNnqYw+boZaqSS53I0EJoEn0QZ7z+w+2FLZ
	 RSdeUs/fQg2dgkeEVM3RLxf3KVXhfK8SH7J3dlNeVrlNlL/L/tXokN9CUWQuC7Hkf/
	 tXYeOCyrJsTDAoPNMbXwCd9kY2mgfUIhAlLFpr6P62Gt7iW9kgL56Por+RsIJ7sRAw
	 //Archhxg27wI08ZiFmZLBKf4qqwRFGhfedElRMsKuqFgxj5XCt5KN+oORg5KaFzjj
	 XWMi2mzGzPJE/DvkbpqwGxiHrBsWp4S4cn3Kkb1X7YzYcJgvm7rJ4yCa19/Z9s3F5W
	 MYrus1vipfkzA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8950860285;
	Thu, 10 Jul 2025 00:43:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752100986;
	bh=R8F+L/rTAALKIXS/lfLPKVppmVSzhjIVHt74KTIH0bA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=oclgqTAlPNjpNDvtkL5cnZTFiXvxPfzS8T+/Ibaetto1KPQ6DeNGaCArDZmsQt2Ss
	 yz2vxzr7BsnMnjt1UHrAcydCWAUuvKV0jX2kMwo8BBlcQ8qoL//7v5d7W4kbjW13cE
	 FmZkrHOHP7MYec7G9mQRWxrBHnWIOkJ4aEDvPYdkVfG46YWL3RlrhbGou6iEl8OcEl
	 sqMzUHY6R0q/y/h6+MuPVTFjUaypMA7aEo1PQ+CpqYKiwSMaafLqp8Tq51PRMrrXFw
	 v5WYzve77y6lFMit2fjZLtHaePoQpsR5wB2mPJxAra75IXyBb8WcuADSBy8bvM+XZ/
	 CqrInnsqJlLow==
Date: Thu, 10 Jul 2025 00:43:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aG7wd6ALR7kXb1fl@calendula>
References: <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aG0tdPnwKitQWYA6@orbyte.nwl.cc>

Hi Phil,

On Tue, Jul 08, 2025 at 04:38:44PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Jul 07, 2025 at 09:25:50PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 04, 2025 at 04:04:39PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > Please keep in mind we already have 'nft list hooks' which provides
> > > > hints in that direction. It does not show which flowtable/chain actually
> > > > binds to a given device, though.
> > > 
> > > Its possible to extend it:
> > > - add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
> > > - add
> > > 
> > > static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
> > >                                    const struct nfnl_dump_hook_data *ctx,
> > >                                    unsigned int seq,
> > >                                    struct nf_flowtable *ft)
> > > 
> > > to nfnetlink_hook.c
> > > 
> > > it can use container_of to get to the nft_flowtable struct.
> > > It might be possibe to share some code with nfnl_hook_put_nft_chain_info
> > > and reuse some of the same netlink attributes.
> > > 
> > > - call it from nfnl_hook_dump_one.
> > > 
> > > I think it would use useful to have, independent of "eth*" support.
> > 
> > This is a good idea to place this in nfnetlink_hook, that
> > infrastructure is for debugging purpose indeed.
> > 
> > If this update is made, I also think it makes sense to remove the
> > netlink event notification code for devices, I don't have a use case
> > for that code in the new device group other than debugging.
> > 
> > If Phil's intention is to make code savings, then extending
> > nfnetlink_hook and removing the existing device notification group
> > make sense to me.
> > 
> > User can simply resort to check via dump if a matching hook is
> > registered for eth* in nfnetlink_hook.
> 
> What is the downside of having it? Are you concerned about the need to
> maintain it or something else (as well)?

I was considering that nfnetlink_hook is a better fit for this
purpose, these event notifications that report new devices could come
from net/netfilter/core.c instead. That is, nf_register_net_hook() and
nf_tables_unregister_hook().

You also mentioned you originally used this syntax:

        nft monitor hooks

which, after Florian's suggestion, made me think all this belongs to
nfnetlink_hook.

This would avoid an asymmetry in the API. At this moment, new device
hooks are reported via nftables, but listing will be retrieved via
nfnetlink_hook.

This would also provide a generic infrastructure to report hook
registration and unregistration, as a side effect.

If you accept this suggestion, it is a matter of:

#1 revert the patch in nf.git for the incomplete event notification
   (you have three more patches pending for nf-next to complete this
    for control plane notifications).
#2 add event notifications to net/netfilter/core.c and nfnetlink_hook.

Only -rc kernels have been release containing the incomplete device
event notification. It is a bit late to revert to be honest, but
better late than never. This infrastructure is triggering more debate
than expected.

And that would be more work on your pile to respin, which is always a
hard sell.

> I had extended the monitor testsuite to assert correct behaviour wrt.
> adding/removing devices. Implementing this is in a shell test is
> trivial, but still work to be done. :)
