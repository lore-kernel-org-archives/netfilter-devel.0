From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH][resend] netfilter: ebtables: make broute table work
 again
Date: Mon, 10 Jan 2011 16:31:05 +0100
Message-ID: <20110110153105.GB31228@Chamillionaire.breakpoint.cc>
References: <1294609729-13039-1-git-send-email-fw@strlen.de>
 <1294643102.2709.874.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44174 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab1AJPbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:31:07 -0500
Content-Disposition: inline
In-Reply-To: <1294643102.2709.874.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > index f7e73c3..dd3f201 100644
> > --- a/include/linux/if_bridge.h
> > +++ b/include/linux/if_bridge.h
> > @@ -103,7 +103,7 @@ struct __fdb_entry {
> >  
> >  extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
> >  
> > -typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
> > +typedef int br_should_route_hook_t(struct sk_buff *skb);
> >  extern br_should_route_hook_t __rcu *br_should_route_hook;
> 
> Hi Florian
> 
> It seems I was on crack at that time, but I remember having problem with
> sparse on :
> 
> net/bridge/netfilter/ebtable_broute.c:90:2: error: cannot dereference this type
> 
> Lets ignore sparse for the time being...
> 
> Please dont change the invocation of (*rhook) to make clear its an
> indirect call. Both syntaxes are valid in C.

okay.

> You also can remove one un needed cast now.

You're right about the cast, but removing it causes the sparse splat
you quoted above...

I'll resend a v2 containing the change below only.

Thanks for looking at this,
Florian

> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
>  extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
>  
> -typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
> +typedef int br_should_route_hook_t(struct sk_buff *skb);
>  extern br_should_route_hook_t __rcu *br_should_route_hook;
