From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Tue, 17 Nov 2015 01:03:52 +0100
Message-ID: <20151117000352.GC14892@breakpoint.cc>
References: <20151109133608.GD8098@macbook.localdomain>
 <1447343209-28029-1-git-send-email-fw@strlen.de>
 <20151116215635.GA6601@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41303 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbbKQADx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 19:03:53 -0500
Content-Disposition: inline
In-Reply-To: <20151116215635.GA6601@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> >  So I'm not sure its right to extend nftrace with additional selectors (its
> >  also possible that I failed to understand what you were suggesting  8-} )
> 
> I can see room to extend this infrastructure later on if we need to
> make it more flexible (eg. allow the user to specify what part of the
> packets need to be dumped to userspace). We can probably even add a
> specific 'trace' expression from the kernel to allow more specific
> selection on what packet fields you want to dump to userspace.
> 
> BTW, any reason to remove the existing infrastructure? It's been there
> since almost the beginning (this would break users that are expecting
> the existing behaviour).

No specific reason, but I question the need to keep it around.
Once we have native tooling there should be no reason whatsover
to wade through dmesg output + manual matching of rules...  its just a
PITA and thats why I removed it -- 'nft monitor trace' (or whatever,
I've not decided on what nft side should look like) would be much
simpler/easier to use.

> Moreover, we'll have people using the
> iptables-compat infrastructure also expecting a similar output to
> native iptables.

Hmm, is iptables-compat a worthy focus?

AFAIU even iptables-compat users would be able to use nft trace
infrastructure, right?

Wouldn't it make more sense to convince people to go with real nft
rather than the compat layer?

> You can probably generalize the trace infrastructure through static
> key plus indirections to keep both tracing approaches around (allowing
> only one at the same time should be enough).

I'd like to see a stronger argument than this.

Bottom line is that i want to keep kernel side as simple as possible,
so I'd much rather just get rid of the printk-based tracing
(I'm *NOT* talking about the ip(6)tables stuff, that remains as-is)
rather than add more conditionals or indirect calls to some
trace-backends...

> From userspace, we would need to have a way to indicate that we want
> to use the new infrastructure, not the classic tracing. That syntax
> would need some thinking. Probably we can introduce a 'trace'
> statement, so the syntax looks compact like this:
> 
> 'tcp port 22 limit rate 1/second trace'
> 
> Meaning in this case that the userspace is specifically requesting for
> the new kind of tracing.

Hmm.  I'm not convinced there is any gain in doing this.
Who in their right mind would want to manually decode rules...?

That being said, I am not overly zealous about this, and I can keep the
printk stuff around.
I just think its not needed anymore.

If you have new nft with old kernel:
- you need to look and dmesg output (or syslog output if ypu use
nfnetlink_log logging backend).

if you have new nft with new kernel:
- nft monitor trace (subject to change, I'm open to suggestions)

If you have old nft with new kernel:
- possibly a problem, but then again, if you can update kernel,
why not use a newer nft as well...?

If you don't mind, i would prefer to work on this patch + nft +
libnftables integration and then submit that formally.

If you're then still convinced that its too problematic to remove the printk
based trace i'd consider to rework the kernel patch.

[ I'm not in a hurry, we can discuss this at netdev/netconf if you like ]

Let me know.

Thanks && regards,
Florian
