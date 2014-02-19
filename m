From: Patrick McHardy <kaber@trash.net>
Subject: Re: Nftables HOWTO documentation updates
Date: Wed, 19 Feb 2014 15:59:46 +0000
Message-ID: <20140219155945.GA9425@macbook.localnet>
References: <20140218112543.GA4799@localhost>
 <5304CA21.9040309@conversis.de>
 <20140219155502.GA18700@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40651 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaBSP7w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:59:52 -0500
Content-Disposition: inline
In-Reply-To: <20140219155502.GA18700@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 19, 2014 at 04:55:02PM +0100, Pablo Neira Ayuso wrote:
> > 
> > Is it possible to comment rules like in iptables? Comments in
> > iptables made it really easy to manage rules on a logical level i.e.
> > I could define rule "types" by adding a special comment like
> > "TYPE:X" and then use that to grep for these rules to batch-remove
> > them or retrieve the counter values. It would be nice to be able to
> > tag rules like this.
> 
> As Arturo said, that's not yet implemented. I've been trying to find a
> way which doesn't involve to store that comment string in the kernel,
> given that this information is not used by the kernel in any way, but
> all what I come out with was overly complicated and not nice.
> 
> So, assuming we store this comment string in kernel-space, I see
> several possibilities at this moment:
> 
> * Add an expression for comments, which is sort of abuse since we'll
>   iterate in nft_do_chain() over one expression which does nothing,
>   so it adds some runtime overhead to the packet handling. This is
>   what the iptables comment match current does, btw.
> 
> * Adding a comment field to nft_rule structure, which means that we
>   have to consume a 4/8 extra bytes in the nft_rule structure for a
>   feature that may not be used by everyone.
> 
> * Attach this this at the end of the expression data area (but *not*
>   abusing the expression infrastructure). I think this has no runtime
>   overhead and no extra memory consumption for those that don't need
>   this comment feature, so it's the way to go IMO.

Sounds very reasonable. I'd suggest to not make this specific to comments,
but simply call it "userdata" or something so we we can put whatever we
like in there. Interpretation would be up to userspace.
