From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 03/10] netfilter: bridge: kill
 NF_HOOK_THRESH() and state->tresh
Date: Thu, 13 Oct 2016 17:25:16 +0200
Message-ID: <20161013152516.GC20580@breakpoint.cc>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-4-git-send-email-pablo@netfilter.org>
 <20161013122545.GB14002@breakpoint.cc>
 <20161013150148.GA1301@salvia>
 <20161013151055.GB20580@breakpoint.cc>
 <20161013152157.GA3124@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39558 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932307AbcJMPrN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 11:47:13 -0400
Content-Disposition: inline
In-Reply-To: <20161013152157.GA3124@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> int br_nf_hook_thresh(unsigned int hook, struct net *net,
>                       struct sock *sk, struct sk_buff *skb,
>                       struct net_device *indev,
>                       struct net_device *outdev,
>                       int (*okfn)(struct net *, struct sock *,
>                                   struct sk_buff *))
> {
>         struct nf_hook_entry *elem;
>         struct nf_hook_state state;
>         int ret;
> 
>         elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
> 
>         while (elem && (elem->ops.priority <= NF_BR_PRI_BRNF))
>                 elem = rcu_dereference(elem->next);
> 
>         ...
> 
>         nf_hook_state_init(&state, elem, hook, NFPROTO_BRIDGE, indev, ...
> 
> Hm, but this code (before actually calling nf_hook_slow) is skipping
> the hook until we get to NF_BR_PRI_BRNF + 1.
> 
> Then hook state sets hook_entry to elem.
> 
> Am I missing anything?

Yes, I'm a moron -- Ignore.  I'll turn off the computer now.
