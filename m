From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Fri, 5 May 2017 13:56:45 +0200
Message-ID: <20170505115645.GA5016@breakpoint.cc>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia>
 <20170504134419.GG13320@breakpoint.cc>
 <20170504140042.GA6436@salvia>
 <20170504222612.GD20805@orbyte.nwl.cc>
 <20170505104954.GA1676@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, regit@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60916 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751180AbdEEL5G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2017 07:57:06 -0400
Content-Disposition: inline
In-Reply-To: <20170505104954.GA1676@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

[ CC Eric ]

> On Fri, May 05, 2017 at 12:26:12AM +0200, Phil Sutter wrote:
> > While I think it's not a bad idea to allow users experienced with
> > iptables to apply their muscle memory to nftables as well, I don't quite
> > get what should hold us back from leveraging this feature nftables
> > provides over iptables. The existence of a unique identifier is a big
> > plus in my point of view, it's just not really useful yet since users
> > have no safe way to get that handle for the rule they added.
> >
> > Are you OK with providing both alternatives in parallel? If not, why?
> 
> This does not integrate at all into the scripting features we have in
> nftables. We don't want people to use bash (or like) shell scripts
> anymore, they are bad, they break atomicity for us. We should extend
> native nftables scripting capabilities to support what user need,
> natively. Look, this will not work with nft -i either...

Yes.  OTOH I don't think we want programs to parse nft frontend
text output either...

Eric, whats the status wrt libnft?

> And this also will not work for robots using incremental updates via
> nft -f. And we very much want to support such transaction like scheme,
> ie. place a bunch of incremental updates in one single file and apply
> that in one single transaction.

Right.

> This is just covering one very specific usecase, that is, users have a
> quick way to delete the rule that just added. And we have better ways
> to achieve this, and that will work from all the scenarios that I
> described above.

What about (as first step) to extend nft monitor?

f.e. afaics kernels update notifications already contain the netlink
portid of the peer that added a rule, perhaps we can display that?

nft monitor
add rule ip saddr 1.2.3.4 # nlport 123

We could use that to then also display the process that currently owns
this portid, e.g.:

add rule ip saddr 1.2.3.4 # nlportid 123 # nlport 123 (nft?)
delete rule inet filter input handle 5 # nlport 42 (firewalld?)

We might also consider extending it to display/group transaction ids
to the user so its easier to identify batches.

What do you think?

FWIW, I believe that deletion by handle and by textual description
both have their use-cases so its more of a question on how to implement
this in a sensible way.
