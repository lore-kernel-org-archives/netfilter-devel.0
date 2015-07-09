From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next 3/4] netfilter: xtables: don't save/restore
 jumpstack offset
Date: Thu, 9 Jul 2015 02:29:55 +0200
Message-ID: <20150709002955.GJ16864@breakpoint.cc>
References: <1436390139-4405-1-git-send-email-fw@strlen.de>
 <1436390139-4405-4-git-send-email-fw@strlen.de>
 <alpine.LSU.2.20.1507082344210.16936@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	eric.dumazet@gmail.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37950 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbbGIA35 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 20:29:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1507082344210.16936@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Wednesday 2015-07-08 23:15, Florian Westphal wrote:
> 
> >The jump stack overflow tests are no longer needed as well -- since 
> >->stacksize is the largest call depth we cannot exceed it.
> 
> The tests were once added for the rare case that a cloned packet hits 
> another TEE. Can we be sure they are no longer needed?

Hmm, not sure I understand.

If a TEE'd skb hits another TEE target there is no reentry since the
tee_active percpu indicator is true.

So where can we enter ip(6)tables *twice* via TEE?
Sure, a TEE'd packet can e.g. hit REJECT which then causes another
reentry into ip(6)tables. But it should be ok since we 'only' clobber
the "alternate" jumpstack and a DROP will be issued by REJECT.

Could you please outline a problematic scenario?  Thanks!

> >+	/* No TEE support for arptables, so no need to switch to alternate
> >+	 * stack.  All targets that reenter must return absolte verdicts.
> 
> absolute

Thanks, will fix

> >+	/* Switch to alternate jumpstack if we're being invoked via TEE.
> >+	 * The problem is that TEE issues XT_CONTINUE verdict on original
> >+	 * skb so we must not clobber the jumpstack.
> 
> Well that is not really a problem but a feature :)

Sorry, I did not mean to imply TEE was misbehaving.  I'll shorten this
to: "TEE will issue XT_CONTINUE verdict" ...

Thanks for reviewing.
