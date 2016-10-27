From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/3] support ct/meta key lookups at runtime
Date: Thu, 27 Oct 2016 19:16:12 +0200
Message-ID: <20161027171612.GA20304@salvia>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
 <20161027164810.GA15837@salvia>
 <20161027165116.GA17182@salvia>
 <20161027165843.GD23011@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbcJ0RQR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:16:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAFFB6C16
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:16:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A728DA913
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:16:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E055DA854
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:16:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161027165843.GD23011@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 27, 2016 at 06:58:43PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 27, 2016 at 06:48:10PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 27, 2016 at 12:36:05AM +0200, Florian Westphal wrote:
> > > > I have a patch series to add support of hash (skb hash) and sym hash
> > > > (symmetric skb hash) to nft_meta.
> > > > 
> > > > This series would allow extending meta without adding new hash/symhash
> > > > keywords in the scanner.
> > > > 
> > > > What do you think?
> > > 
> > > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > Only one suggestion, instead of:
> > > 
> > >  return error(loc, "Could not parse %s, known ct keys are: %s", str, buf);
> > > 
> > > Looking at current error reporting:
> > > 
> > >  # nft add rule x y ct
> > >  <cmdline>:1:18-18: Error: syntax error, unexpected newline
> > >  add rule x y ct
> > >                 ^
> > > Probably something like looks better:
> > > 
> > >  "syntax error, unexpected %s, known keys are %s"
> > 
> > Actually, if we follow this approach, we probably have to revisit all
> > other existing error messages...
> > 
> > Keep this as it is, we can revisit this later.
> 
> Are you sure?  I like the suggestion.

Go ahead with it then, we can just make a follow up patch to revisit
other existing spots. Probably we can add a new function so we don't
need to hardcode this everywhere in the code?

We will get one Outreachy student soon btw, we can hand over this task
to her.
