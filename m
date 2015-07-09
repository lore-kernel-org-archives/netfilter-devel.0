From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next 3/4] netfilter: xtables: don't save/restore
 jumpstack offset
Date: Thu, 9 Jul 2015 11:14:15 +0200
Message-ID: <20150709091415.GA17984@breakpoint.cc>
References: <1436390139-4405-1-git-send-email-fw@strlen.de>
 <1436390139-4405-4-git-send-email-fw@strlen.de>
 <1436428454.24939.13.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38597 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbbGIJOR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 05:14:17 -0400
Content-Disposition: inline
In-Reply-To: <1436428454.24939.13.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +	/* Switch to alternate jumpstack if we're being invoked via TEE.
> > +	 * The problem is that TEE issues XT_CONTINUE verdict on original
> > +	 * skb so we must not clobber the jumpstack.
> > +	 *
> > +	 * For recursion via REJECT or SYNPROXY the stack will be clobbered
> > +	 * but its no problem since absolute verdict is issued by these.
> > +	 */
> > +	jumpstack += private->stacksize * __this_cpu_read(nf_skb_duplicated);
> 
> This could eventually be garded by
> 
> #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TEE)
> 
> Or even better, a jump label that would be enabled when TEE module is
> loaded.

I can add a static key, sure.

Thanks for the suggestion Eric.
