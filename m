From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables and iptables nat coexistence
Date: Thu, 19 Oct 2017 12:15:29 +0200
Message-ID: <20171019101529.GA2224@salvia>
References: <20171018135650.GA16796@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35338 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdJSKPd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 06:15:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C063249C6
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:15:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3944DDA86D
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 12:15:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171018135650.GA16796@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, Oct 18, 2017 at 03:56:50PM +0200, Florian Westphal wrote:
> Hi.
> 
> Couple of month ago I sent 2 RFC patches to allow using nftables and
> iptables NAT at same time.

Hm, I think we forgot to talk about this during the NFWS.

> If this is unwanted (there was concern wrt. to the new hooks I had to
> add for this), we should at least improve/restrict iptables and nftables
> to
> 
> 1. not allow load if iptable_nat when nft nat hook is active.

I guess this would apply the other way around.

> 2. make it a requirement to register empty nat hook (required for
> the reply direction).

I'm seeing many posts on the lack of automatic registration of the
empty NAT chain. This is a pitfall where many people are falling one
after another in migrations.  I know there's a bold sentence in the
documentation, but I think it's a sympton that we're doing something
that is unintuitive to users, and it should be a wake up call for us.
Can we just autoregister the empty nat chain using the default
priority? If an explicit chain is registered, then disable this.

Does this sound too complicated to you?

> 3. Do not permit more than one nat type per family/hook.

Yes, this makes sense to me.

> 4. we should probably also add more checks on nat priority
> for nftables to reject hooks that can't work due to no-conntrack
> information being available at that point.

Yes, this would be good too.

> I think not allowing nft and iptablles nat at the same time is fine
> as mixing has problems on its own, especially which transformation
> gets precedence, so I suspect the old RFC patches resolve one issue
> and add another one :)

My only concern is, may this cause problems when migrating from
iptables to nftables?
