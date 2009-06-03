From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 9/9] netfilter: conntrack: replace notify chain by function
 pointer
Date: Wed, 03 Jun 2009 10:05:55 +0200
Message-ID: <4A262EE3.8010607@netfilter.org>
References: <20090602181336.18573.85368.stgit@Decadence> <20090602182115.18573.84532.stgit@Decadence> <4A261711.1020208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56502 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZFCIey (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:34:54 -0400
In-Reply-To: <4A261711.1020208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> -int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
>> +int nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
>>  {
>> -    return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
>> +    int ret = 0;
>> +    struct nf_exp_event_notifier *notify;
>> +
>> +    mutex_lock(&nf_ct_ecache_mutex);
>> +    notify = rcu_dereference(nf_expect_event_cb);
>> +    if (notify != new) {
>> +        ret = -EINVAL;
>> +        goto out_unlock;
>> +    }
> 
> I think these unregistration functions should return void. The only
> reason why they don't currently is because the notifier_chain_unregister
> function for some unknown reasons don't return void, but there's
> a) nothing the caller could possibly do to handle this and b) a bug
> anyways. So I'd suggest to just unconditionally assign NULL.

Would you be OK with something like:

BUG_ON(notify != new);

So we can catch this very unlikely bug, if so.

> Sorry for not bringing this up earlier.
> 
> BTW, you might also consider marking the callback pointers read_mostly.

Done.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
