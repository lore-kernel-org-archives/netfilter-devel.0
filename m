From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 0/3] support ct/meta key lookups at runtime
Date: Thu, 27 Oct 2016 18:58:43 +0200
Message-ID: <20161027165843.GD23011@breakpoint.cc>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
 <20161027164810.GA15837@salvia>
 <20161027165116.GA17182@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:32786 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934935AbcJ0RAM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:00:12 -0400
Content-Disposition: inline
In-Reply-To: <20161027165116.GA17182@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 27, 2016 at 06:48:10PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 27, 2016 at 12:36:05AM +0200, Florian Westphal wrote:
> > > I have a patch series to add support of hash (skb hash) and sym hash
> > > (symmetric skb hash) to nft_meta.
> > > 
> > > This series would allow extending meta without adding new hash/symhash
> > > keywords in the scanner.
> > > 
> > > What do you think?
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Only one suggestion, instead of:
> > 
> >  return error(loc, "Could not parse %s, known ct keys are: %s", str, buf);
> > 
> > Looking at current error reporting:
> > 
> >  # nft add rule x y ct
> >  <cmdline>:1:18-18: Error: syntax error, unexpected newline
> >  add rule x y ct
> >                 ^
> > Probably something like looks better:
> > 
> >  "syntax error, unexpected %s, known keys are %s"
> 
> Actually, if we follow this approach, we probably have to revisit all
> other existing error messages...
> 
> Keep this as it is, we can revisit this later.

Are you sure?  I like the suggestion.
