From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC netfilter-next 1/3] netfilter: introduce accessor
 functions for hook entries
Date: Thu, 3 Nov 2016 17:15:59 +0100
Message-ID: <20161103161559.GA3362@salvia>
References: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
 <1477592873-4468-2-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757702AbcKCQQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 12:16:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D71EBA7D5A
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:16:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE8087E08E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:16:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6264E7E08D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:16:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477592873-4468-2-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 27, 2016 at 02:27:51PM -0400, Aaron Conole wrote:
> This allows easier future refactoring.
> 
> Signed-off-by: Aaron Conole <aconole@bytheb.org>
> ---
>  include/linux/netfilter.h       | 35 ++++++++++++++++++++++++++++++++++-
>  net/bridge/br_netfilter_hooks.c |  2 +-
>  net/netfilter/core.c            |  8 +++-----
>  net/netfilter/nf_queue.c        |  8 ++++----
>  4 files changed, 42 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index d0beb607..b25386b 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -80,6 +80,38 @@ struct nf_hook_entry {
>  	const struct nf_hook_ops	*orig_ops;
>  };
>  
> +static inline void
> +nf_hook_entry_init(struct nf_hook_entry *entry,	const struct nf_hook_ops *ops)
> +{
> +	entry->next = NULL;
> +	entry->ops = *ops;
> +	entry->orig_ops = ops;
> +}
> +
> +static inline int
> +nf_hook_entry_priority(const struct nf_hook_entry *entry)
> +{
> +	return entry->ops.priority;
> +}
> +
> +static inline nf_hookfn *
> +nf_hook_entry_hookfn(const struct nf_hook_entry *entry)
> +{
> +	return entry->ops.hook;
> +}

I'd suggest something like:

static inline int
nf_entry_hookfn(const struct nf_hook_entry *entry,
                struct sk_buff *skb, struct nf_hook_state *state)
{
        return entry->ops.hook(entry, nf_hook_entry_priv(entry), skb, state);
}

So you can avoid this:

		verdict = nf_hook_entry_hookfn(*entryp)
			(nf_hook_entry_priv(*entryp), skb, state);
