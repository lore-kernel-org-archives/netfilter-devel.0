From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH nf,v2] netfilter: nf_queue: don't re-enter same hook on packet reinjection
Date: Mon, 17 Oct 2016 11:23:01 -0400
Message-ID: <f7tzim3j8yy.fsf@redhat.com>
References: <1476441446-19611-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36032 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755068AbcJQPXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:23:05 -0400
Received: by mail-qt0-f193.google.com with SMTP id y38so6345501qta.3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 08:23:04 -0700 (PDT)
In-Reply-To: <1476441446-19611-1-git-send-email-pablo@netfilter.org> (Pablo
        Neira Ayuso's message of "Fri, 14 Oct 2016 12:37:26 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Make sure we skip the current hook from where the packet was enqueued,
> otherwise the packets gets enqueued over and over again.
>
> Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: Make sure next hook is non-null, otherwise we are at the end of the
>     hook list and we can skip nf_iterate().
>
>  net/netfilter/nf_queue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 96964a0070e1..691e713d70f5 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -185,8 +185,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	}
>  
>  	entry->state.thresh = INT_MIN;
> +	hook_entry = rcu_dereference(hook_entry->next);
>  
> -	if (verdict == NF_ACCEPT) {
> +	if (hook_entry && verdict == NF_ACCEPT) {
>  	next_hook:
>  		verdict = nf_iterate(skb, &entry->state, &hook_entry);
>  	}

ACK.  I thought switch case below could have a problem, but re-checked
the first nf_queue leg, and it seems okay.

-Aaron
