From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: wrap tracing with a
 static key
Date: Tue, 24 Nov 2015 10:28:47 +0000
Message-ID: <20151124102847.GF2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-3-git-send-email-fw@strlen.de>
 <20151124101332.GC2310@macbook.localdomain>
 <20151124102123.GB1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44573 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754288AbbKXK2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:28:51 -0500
Content-Disposition: inline
In-Reply-To: <20151124102123.GB1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > I'm also wondering if this introduces a race condition on architectures
> > that don't support jump labels. static_key_slow_inc() simply increases
> > the ->enabled counter without further synchronization, so this might
> > happen while we're executing this function and some of the increments
> > might be skipped.
> 
> Hmm, adding synchronization for this is braindead.
> The new trace infrastructure doesn't need this rulenum, I only kept it
> since thats what Pablo asked me to do.
> 
> So we have 3 choices:
> - ignore this
> - don't use static key here
> - kill the old nf_log_packet trace part after all
> 
> I find it sad that we have to keep this rule counting around :-/
> 
> If there are no further comments I'll remove the static key and do
> the rule counting unconditinally.

I wouldn't mind killing the old tracing off, but I think the main reason why
we added it was for ipt compat. So probably not possible at this point.

I agree that having the rule counting is not particulary nice, but I don't
see any other way right now than to do it unconditionally.
