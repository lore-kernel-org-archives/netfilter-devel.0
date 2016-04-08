From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Fri, 8 Apr 2016 13:43:51 +0200
Message-ID: <20160408114351.GA6869@salvia>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
 <20160407214942.GB731@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758128AbcDHLoC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 07:44:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 89317E839A
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:44:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72596DA399
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:44:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B313DA398
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:43:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160407214942.GB731@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 11:49:42PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Several examples on how this would look from userspace:
> > 
> > * Add the 'tcp-counter' counter to the 'filter' table:
> > 
> >  # nft add counter filter tcp-counter
> > 
> > * Delete this counter (only possible if not dereferenced from a rule):
> > 
> >  # nft delete counter filter tcp-counter
> > 
> > * List existing named counters:
> > 
> >  # nft lists counters
> >  table ip filter {
> >         counter tcp-counter {
> >                 packets 6086 bytes 6278052
> >         }
> >         counter udp-counter {
> >                 packets 272 bytes 64690
> >         }
> >         counter icmp-counter {
> >                 packets 10 bytes 840
> >         }
> >  }
> 
> Can't you already create a 'named counter' via
> 
> chain tcp-counter {
> 	counter
> }
> 
> ?
> 
> Seems to me we only would have to teach nft list to
> allow filtering output on chain names, e.g.
> 
> nft list table filter \*-counter
> 
> to have something similar using exsiting feature set.

Right, but we still need a way to uniquely identify this stateful
expression for atomic dump'n'reset.

> > So far, only counters are supported, but it should be possible to
> > support named limits. I have another (imcomplete) patch that allows to
> > update the named expressions parameters, this can be useful to
> > dynamically update the ratelimiting policies, the command line should
> > look like:
> > 
> >  # nft update limit name user01234 rate 250 mbytes/day
> 
> Similar comment here, you could create
> 
> chain user01234 {
> 	limit rate 100 mbytes/day
> }

Right, we can replace this rule via the handle, but I see two problems
with this:

1) The user needs to track the rule handle, not so much of a problem
   since userspace can do this at the cost of a bit of more
   complexity.

2) When replacing the rule, the new expression starts from no history
   as it will be a new expression, we'll be basically reseting it.

Using 'nft update limit...' I think we should be capable of upgrading
the ratelimit by keeping around the quota that the user has already
consumed.

The idea is, if we know the previous cost of every byte/packets in
terms of tokens, given that tokens are generated per nanosecond and
that know how many tokens we have already consumed, then we can
recalculate the quota that has been already consumed and add this to
the limit update, eg. if limit rate is 100 mbytes/day but the user
already consumed 50 mbytes, when calling:

        nft update limit rate 200 mbytes/day

we can keep the 50 mbytes that were already consumed around.

Let me know, thanks.
