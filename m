From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Thu, 2 Jul 2015 22:00:24 +0200
Message-ID: <20150702200024.GF16529@breakpoint.cc>
References: <1435695660-26048-1-git-send-email-fw@strlen.de>
 <20150702113044.GA21930@salvia>
 <20150702114837.GA16529@breakpoint.cc>
 <1435851533.11970.33.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54428 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbbGBUA1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 16:00:27 -0400
Content-Disposition: inline
In-Reply-To: <1435851533.11970.33.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2015-07-02 at 13:48 +0200, Florian Westphal wrote:
> 
> > My plan:
> > 
> > - move tee_active percpu varible to xtables core (suggested by Eric)
> > - in do_table, check if we're TEE'd or not
> > 
> > 1. if no, then just use the jumpstack from offset 0 onwards.
> > 2. If yes, then fetch jumpstack, and use the upper half:
> > 
> > if (__this_cpu_read(xt_tee_active))
> >  	jumpstack += private->stacksize;
> 
> Or maybe not using a conditional
> 
> jumpstack += private->stacksize * __this_cpu_read(xt_tee_active);
> 
> 
> BTW, I do not remember why I used a conditional in
> xt_write_recseq_begin(). This also adds extra setup cost, as @addend has
> to be preserved in the stack.
> 
> Hmm... What about something like :

Hmm.  I don't understand how this would work reliably.

   xt_write_recseq_begin(); /* value is now odd */

  /* other cpu fetches counters, blocks in read seeqlock */
   for_each_rule( .. ) {
	-> packet is sent by some target
  	  /* reentry into do_table */
	  xt_write_recseq_begin(); /* value is now even */

          -> other cpu unblocks since it thinks seqlock is taken

   }

This is problematic because get_counters() (and thus the seqlock) seems
to be used as sync point with table replacement.

And reading Jans email, we can have re-entrancy in do_table() also
via -j REJECT and SYNPROXY, not just TEE :-/

MAYBE its worth investigating a dual stack approach.

Keep a small jumpstack on the local kernel stack

If table traverse exeeds it, switch to the private->jumpstack

This adds a conditional, but would avoid all the setup/restore/save for
most rulesets.
