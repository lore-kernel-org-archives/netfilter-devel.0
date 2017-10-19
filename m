From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables and iptables nat coexistence
Date: Thu, 19 Oct 2017 13:18:12 +0200
Message-ID: <20171019111812.GC16796@breakpoint.cc>
References: <20171018135650.GA16796@breakpoint.cc>
 <20171019101529.GA2224@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56296 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751579AbdJSLSQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 07:18:16 -0400
Content-Disposition: inline
In-Reply-To: <20171019101529.GA2224@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Wed, Oct 18, 2017 at 03:56:50PM +0200, Florian Westphal wrote:
> > Hi.
> > 
> > Couple of month ago I sent 2 RFC patches to allow using nftables and
> > iptables NAT at same time.
> 
> Hm, I think we forgot to talk about this during the NFWS.

Yes.  We can try Netdev 2.2 next 8-)

> > If this is unwanted (there was concern wrt. to the new hooks I had to
> > add for this), we should at least improve/restrict iptables and nftables
> > to
> > 
> > 1. not allow load if iptable_nat when nft nat hook is active.
> 
> I guess this would apply the other way around.

Both ways.

> > 2. make it a requirement to register empty nat hook (required for
> > the reply direction).
> 
> I'm seeing many posts on the lack of automatic registration of the
> empty NAT chain. This is a pitfall where many people are falling one
> after another in migrations.  I know there's a bold sentence in the
> documentation, but I think it's a sympton that we're doing something
> that is unintuitive to users, and it should be a wake up call for us.

I agree.

> Can we just autoregister the empty nat chain using the default
> priority? If an explicit chain is registered, then disable this.
>
> Does this sound too complicated to you?

I'll look into it.

> > 3. Do not permit more than one nat type per family/hook.
> 
> Yes, this makes sense to me.
> 
> > 4. we should probably also add more checks on nat priority
> > for nftables to reject hooks that can't work due to no-conntrack
> > information being available at that point.
> 
> Yes, this would be good too.
> 
> > I think not allowing nft and iptablles nat at the same time is fine
> > as mixing has problems on its own, especially which transformation
> > gets precedence, so I suspect the old RFC patches resolve one issue
> > and add another one :)
> 
> My only concern is, may this cause problems when migrating from
> iptables to nftables?

I don't see any however once we do it we cannot remove such additional
hooks anymore (right now it won't work, if we do it iptable_nat and
nftables nat will work (plus multiple nftables nat chains types
if the priority is before the implicit null-binding hook so if we revert
that we break such setups that rely on the new implicit hooks.

Registering implicit nat hook, making iptables_nat and nftables nat
at the same time impossible (reject from kernel) etc. is more
convenient as we cannot break existing setups and only prevent
configuring a non-working/broken state rather than allowing things
that do not work at the moment.
