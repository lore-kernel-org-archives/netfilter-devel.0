From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit
 conntrack ID extension
Date: Tue, 28 Nov 2017 21:43:01 +0100
Message-ID: <20171128204301.GB16528@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128105451.GF23412@breakpoint.cc>
 <20171128154401.GA1444@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        richard@nod.at
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52176 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754258AbdK1UoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 15:44:11 -0500
Content-Disposition: inline
In-Reply-To: <20171128154401.GA1444@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > ID assignment is lockless: this patch divides the 64-bit space between
> > 
> > Why do we need an id in the first place?
> > Can you elaborate?
> 
> It's a userspace thing, for statistics and manipulation via ctnetlink,
> eg. delete an entry. To make sure you refer to the same conntrack
> entry when polling for statistics and also for events, in case of
> event loss, you keep context around in case tear-down and re-creation
> happens in little time.

Hmm.  I think for that use case (e.g. do not delete an entry unless
it is the one we initally saw via NEW in case we missed a DELETE in
between even my jhash based patch in patch work is good enough.

However, in most realistic cases there never was such a gurantee, see
below.

> > As far as I know there is no need for this ID at all,
> > the netlink attribute is only provided for backwards compat.
> > 
> > And for that the suggested approach (hash of tuple and memory
> > addresses) will work just fine.
> 
> It's still possible to land a conntrack with exactly the same tuple on
> the same memory address.

Sure, but the chances are already pretty much close to 0.
Remember that we can have connection re-use while conntrack object
remains unchanged (e.g. new SYN while contrack is in TW).

The ID doesn't change in this case even with the old approach.

ANd what are the chances of a full tuple reuse *right* at the moment
of expiry (i.e. before any other new allocation)?

And why would we treat it differently than syn-in-tw case?

> I can just keep this patchset back and push the one that randomizes
> what we dump to userspace (ie. 3/3), I don't need this now, it's just
> a patchset that it's been stuck in my tree for a while.

I am fine with 3/3.  You might want to use hash_ptr anyway just in case
though (and perhaps include ct->ext).
