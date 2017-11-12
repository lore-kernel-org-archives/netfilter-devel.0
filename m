From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH v4 12/18] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 12 Nov 2017 12:02:23 +0300
Message-ID: <de9bd0eb-a0f5-1329-4825-e17048528191@virtuozzo.com>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
 <c0d49d64-d46b-21e6-02e4-4c445600bd39@virtuozzo.com>
 <20171112085232.GJ5512@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:14608 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdKLJCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 04:02:31 -0500
In-Reply-To: <20171112085232.GJ5512@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-11-12 11:52, Florian Westphal wrote:
> Vasily Averin <vvs@virtuozzo.com> wrote:
>> Be sure that instance_table array initialized in net_init hook
>> was return to initial state.
> 
>> +	for (i = 0; i < INSTANCE_BUCKETS; i++)
>> +		if (WARN_ON_ONCE(!hlist_empty(&q->instance_table[i])))
>> +			break;
> 
> This looks strange, why if/break?

I did not want to generate huge number of messages on each non-empty hash bucket.

> Plain WARN_ON_ONCE should be enough, but thats a nit so:

Oh, you're right.
In first patch version WARN_ON  was used here.
I've missed that only first message will be printed with _ONCE check.

> Acked-by: Florian Westphal <fw@strlen.de>
> 
