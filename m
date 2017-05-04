From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Thu, 4 May 2017 15:44:19 +0200
Message-ID: <20170504134419.GG13320@breakpoint.cc>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56844 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750935AbdEDNol (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 09:44:41 -0400
Content-Disposition: inline
In-Reply-To: <20170504133626.GC5607@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 04, 2017 at 02:34:21PM +0200, Phil Sutter wrote:
> > Being able to retrieve an added rule's handle atomically is a crucial
> > feature for scripts invoking nft command: Without it, there is no way to
> > be sure a handle extracted from 'nft list ruleset' command actually
> > refers to the rule one has added before or that of another process which
> > ran in between.
> > 
> > Extracting an added rule's handle itself is not an easy task already,
> > since there is a chance that a given rule is printed differently than
> > when it was added before. A simple example is port number vs. service
> > name:
> > 
> > | nft add rule ip t c tcp dport { ssh, 80 } accept
> > 
> > There is no way to make 'nft list ruleset' return the rule just like
> > this as depending on whether '-nn' was given or not, it either prints
> > the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
> > that was used when adding it.
> > 
> > This patch prints an identifying string for each added rule which may be
> > used as single parameter to a later 'nft delete rule' command. So a
> > simple scripting example looks like this:
> > 
> > | handle=$(nft add rule ip t c counter)
> 
> This is a hack.
> 
> We should follow the rule description path.

You mean delete-by-name?

Its just as ugly, just a different kind of ugly.

Will you delete the first match?  The last one?  All of them?
