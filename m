From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] datatype, meta: add new ifname_type for
 iifname/oifname
Date: Tue, 1 Mar 2016 12:00:55 +0100
Message-ID: <20160301110055.GA22817@breakpoint.cc>
References: <1456514374-28827-1-git-send-email-fw@strlen.de>
 <20160229131202.GA16476@salvia>
 <20160229131923.GB7277@breakpoint.cc>
 <20160301101114.GA2654@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48626 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbcCALA4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 06:00:56 -0500
Content-Disposition: inline
In-Reply-To: <20160301101114.GA2654@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Ok, but how do you plan to handle the key length?
> 
> Right, in concatenations we can infer this from the lhs, but in set
> definitions there is not way.

Okay.  So whats the plan there?

> What I would suggest is to recover a patch that Patrick submitted that
> introduces typeof(X) so we can use this from set definitions. We can
> store in the TLV the original subtype X as a string. Thus, when
> listing back to userspace we can use this information to display back
> the typeof(X).

So you mean you'd use something like

nft add set filter ifnames '{typeof(meta iifname); }' ?

That should indeed work since we can derive the size
from the meta iifname (or whatever other field),

> We have to potentially support every meta and packet selector,
> including crazy ones as 48 bits fields, and last time we discussed
> this, we agreed that adding one type per field size is not the way to
> go.

Ok, yes, I see your point.

> Let me know your opinion on this, thanks!

I think typeof would be good; we could indeed derive the key size with
this without the need for a new type.
