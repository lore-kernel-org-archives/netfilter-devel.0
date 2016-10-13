From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH 1/2 nf] netfilter: nf_queue: don't re-enter same hook on packet reinjection
Date: Thu, 13 Oct 2016 09:36:44 -0400
Message-ID: <f7tinswmkur.fsf@redhat.com>
References: <1476350587-2837-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33591 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbcJMNgs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 09:36:48 -0400
Received: by mail-qt0-f193.google.com with SMTP id m5so2659073qtb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 06:36:48 -0700 (PDT)
In-Reply-To: <1476350587-2837-1-git-send-email-pablo@netfilter.org> (Pablo
        Neira Ayuso's message of "Thu, 13 Oct 2016 11:23:06 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Make sure we skip the current hook from where the packet was enqueued,
> otherwise the packets gets enqueued over and over again.
>
> Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I managed to reproduce this with a simple test.
>
>  # iptables -I OUTPUT -j QUEUE
>  # cd libnetfilter_queue/utils/
>  # ./nfqnl_test
>
> Without my patch, netfilter munches packets that are reinjected.
>
> @Aaron: Please, I'd appreciate if you can have a look to confirm this bug
>         and the fix. Thanks.

Looks like I missed this in my testing.

Reviewed-by: Aaron Conole <aconole@bytheb.org>

>  net/netfilter/nf_queue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 96964a0070e1..221d7a5c2fec 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -184,6 +184,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  			verdict = NF_DROP;
>  	}
>  
> +	hook_entry = rcu_dereference(hook_entry->next);
>  	entry->state.thresh = INT_MIN;
>  
>  	if (verdict == NF_ACCEPT) {

