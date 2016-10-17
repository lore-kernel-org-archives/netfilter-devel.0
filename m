From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH nf,v2] netfilter: nf_queue: don't re-enter same hook on packet reinjection
Date: Mon, 17 Oct 2016 15:29:27 -0400
Message-ID: <f7th98aixk8.fsf@redhat.com>
References: <1476441446-19611-1-git-send-email-pablo@netfilter.org>
        <f7tzim3j8yy.fsf@redhat.com> <20161017170320.GA5538@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33555 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965005AbcJQT3b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 15:29:31 -0400
Received: by mail-qk0-f196.google.com with SMTP id f128so14312224qkb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 12:29:31 -0700 (PDT)
In-Reply-To: <20161017170320.GA5538@salvia> (Pablo Neira Ayuso's message of
        "Mon, 17 Oct 2016 19:03:20 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, Oct 17, 2016 at 11:23:01AM -0400, Aaron Conole wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> writes:
>>
>> > Make sure we skip the current hook from where the packet was enqueued,
>> > otherwise the packets gets enqueued over and over again.
>> >
>> > Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
>> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> > ---
>> > v2: Make sure next hook is non-null, otherwise we are at the end of the
>> >	hook list and we can skip nf_iterate().
>> >
>> >  net/netfilter/nf_queue.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
>> > index 96964a0070e1..691e713d70f5 100644
>> > --- a/net/netfilter/nf_queue.c
>> > +++ b/net/netfilter/nf_queue.c
>> > @@ -185,8 +185,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>> >	}
>> >
>> >	entry->state.thresh = INT_MIN;
>> > +	hook_entry = rcu_dereference(hook_entry->next);
>> >
>> > -	if (verdict == NF_ACCEPT) {
>> > +	if (hook_entry && verdict == NF_ACCEPT) {
>> >	next_hook:
>> >		verdict = nf_iterate(skb, &entry->state, &hook_entry);
>> >	}
>>
>> ACK.	I thought switch case below could have a problem, but re-checked
>> the first nf_queue leg, and it seems okay.
>
> Argh, still not right. If we get a NF_QUEUE verdict to re-enqueue
> again, then hook_entry may become NULL.
>
> 	switch (verdict & NF_VERDICT_MASK) {
> 	case NF_ACCEPT:
> 	case NF_STOP:
> 		local_bh_disable();
> 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
> 		local_bh_enable();
> 		break;
> 	case NF_QUEUE:
> 		RCU_INIT_POINTER(entry->state.hook_entries, hook_entry); <--
>
> Attaching new patch.
>
> From c1a731c68791bcd504a7fe5d28f5f0fd59d66118 Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 13 Oct 2016 08:14:03 +0200
> Subject: [PATCH nf,v3] netfilter: nf_queue: don't re-enter same hook on packet
>  reinjection
>
> If the packet is accepted, we have to skip the current hook from where
> the packet was enqueued. Thus, we can emulate the previous
> list_for_each_entry_continue() behaviour happening from nf_reinject(),
> otherwise the packets gets enqueued over and over again.
>
> Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_queue.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 96964a0070e1..0b5ac3c9c2bc 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -187,8 +187,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	entry->state.thresh = INT_MIN;
>  
>  	if (verdict == NF_ACCEPT) {
> -	next_hook:
> -		verdict = nf_iterate(skb, &entry->state, &hook_entry);
> +		hook_entry = rcu_dereference(hook_entry->next);
> +		if (hook_entry)
> +next_hook:

Should the above two lines be transposed to this?

 next_hook:
 		if (hook_entry)

Sorry if I'm misunderstanding it.  Too many special cases for my tiny
brain...

-Aaron
