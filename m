From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Nftables HOWTO documentation updates
Date: Wed, 19 Feb 2014 16:55:02 +0100
Message-ID: <20140219155502.GA18700@localhost>
References: <20140218112543.GA4799@localhost>
 <5304CA21.9040309@conversis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbaBSPzL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:55:11 -0500
Content-Disposition: inline
In-Reply-To: <5304CA21.9040309@conversis.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Feb 19, 2014 at 04:13:37PM +0100, Dennis Jacobfeuerborn wrote:
> On 18.02.2014 12:25, Pablo Neira Ayuso wrote:
> >Hi,
> >
> >I have registered a subdomain for nftables that hosts the nftables
> >user HOWTO, you can reach it via:
> >
> >         http://wiki.nftables.org
> 
> I checked out the HOWTO and it gives a really nice concise
> introduction to how nftables work. Good work!
> 
> After browsing through the pages I have two questions:
> 
> Is it possible to comment rules like in iptables? Comments in
> iptables made it really easy to manage rules on a logical level i.e.
> I could define rule "types" by adding a special comment like
> "TYPE:X" and then use that to grep for these rules to batch-remove
> them or retrieve the counter values. It would be nice to be able to
> tag rules like this.

As Arturo said, that's not yet implemented. I've been trying to find a
way which doesn't involve to store that comment string in the kernel,
given that this information is not used by the kernel in any way, but
all what I come out with was overly complicated and not nice.

So, assuming we store this comment string in kernel-space, I see
several possibilities at this moment:

* Add an expression for comments, which is sort of abuse since we'll
  iterate in nft_do_chain() over one expression which does nothing,
  so it adds some runtime overhead to the packet handling. This is
  what the iptables comment match current does, btw.

* Adding a comment field to nft_rule structure, which means that we
  have to consume a 4/8 extra bytes in the nft_rule structure for a
  feature that may not be used by everyone.

* Attach this this at the end of the expression data area (but *not*
  abusing the expression infrastructure). I think this has no runtime
  overhead and no extra memory consumption for those that don't need
  this comment feature, so it's the way to go IMO.

> How do I insert multiple rules? The insertion example show the
> addition of a single rule after a known handle but what if I want to
> add a second rule after that? As far as I can tell from the example
> the add rule command does not return the handle of the inserted rule
> so I have no idea where to insert the second rule. Even if the
> command returned the handle it would still require scripting to add
> multiple consecutive rules so there should be a way to specify to
> add a list of rules (atomically?) after a given handle.

That's not yet support either. I think we'll need to keep some context
information in the batch handling so you can add several list after a
given handle.
