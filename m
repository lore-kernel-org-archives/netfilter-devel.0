From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ingress: translate 0 nf_hook_slow
 retval to -EINPROGRESS
Date: Tue, 6 Dec 2016 11:35:45 +0100
Message-ID: <20161206103545.GA4129@salvia>
References: <1480329606-6592-1-git-send-email-fw@strlen.de>
 <1480329606-6592-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753052AbcLFKfx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:35:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23BD9C9EC0
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:35:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12E1CDA729
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:35:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E050DA729
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:35:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480329606-6592-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 11:40:05AM +0100, Florian Westphal wrote:
> The caller assumes that < 0 means that skb was stolen (or free'd).
> 
> All other return values continue skb processing.
> 
> nf_hook_slow returns 3 different return value types:
> 
> A) a (negative) errno value: the skb was dropped (NF_DROP, e.g.
> by iptables '-j DROP' rule).
> 
> B) 0. The skb was stolen by the hook or queued to userspace.
> 
> C) 1. all hooks returned NF_ACCEPT so the caller should invoke
>    the okfn so packet processing can continue.
> 
> nft ingress facility currently doesn't have the 'okfn' that
> the NF_HOOK() macros use; there is no nfqueue support either.
> 
> So 1 means that nf_hook_ingress() caller should go on processing the skb.
> 
> In order to allow use of NF_STOLEN from ingress we need to translate
> this to an errno number, else we'd crash because we continue with
> already-free'd (or about to be free-d) skb.
> 
> Random dice roll has chosen EINPROGRESS.  The errno value isn't checked,
> its just important that its less than 0.

Not really comments to block anything, so take them lightly.

Probably we can just set this to -1, I know this maps to some errno
value, but at least from code reading it will be make think that we
meant to return EINPROGRESS. If you agree, I can just mangle the
patch.

One more question below.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter_ingress.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
> index 2dc3b49b804a..d5027e470a24 100644
> --- a/include/linux/netfilter_ingress.h
> +++ b/include/linux/netfilter_ingress.h
> @@ -19,6 +19,7 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
>  {
>  	struct nf_hook_entry *e = rcu_dereference(skb->dev->nf_hooks_ingress);
>  	struct nf_hook_state state;
> +	int ret;
>  
>  	/* Must recheck the ingress hook head, in the event it became NULL
>  	 * after the check in nf_hook_ingress_active evaluated to true.
> @@ -29,7 +30,11 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
>  	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
>  			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
>  			   dev_net(skb->dev), NULL);
> -	return nf_hook_slow(skb, &state, e);
> +	ret = nf_hook_slow(skb, &state, e);
> +	if (unlikely(ret == 0))
> +		return -EINPROGRESS;

Do you prefer to keep this branch as unlikely? I understand most
people are not using fwd much so far, but we're targeting to enrich
ingress so I would expect users will be using this more and more.
Anyway, we can revisit this later on.
