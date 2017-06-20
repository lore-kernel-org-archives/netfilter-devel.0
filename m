From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH V2] netfilter: Remove duplicated rcu_read_lock.
Date: Wed, 21 Jun 2017 00:32:57 +0900
Message-ID: <CAMArcTUwfLAMPFvZpX5FBbWkteOXRd_7e7VmvYGxK4EvvTQ_7Q@mail.gmail.com>
References: <20170605152125.24978-1-ap420073@gmail.com> <20170619180449.GA19139@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Julian Anastasov <ja@ssi.bg>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34400 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdFTPc7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2017 11:32:59 -0400
Received: by mail-yb0-f196.google.com with SMTP id b63so6506568yba.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2017 08:32:58 -0700 (PDT)
In-Reply-To: <20170619180449.GA19139@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-06-20 3:04 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Jun 06, 2017 at 12:21:25AM +0900, Taehee Yoo wrote:
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
>> index 8a0f218..bb27e99 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -928,7 +928,6 @@ static unsigned int nfqnl_nf_hook_drop(struct net *net)
>>       unsigned int instances = 0;
>>       int i;
>>
>> -     rcu_read_lock();
>>       for (i = 0; i < INSTANCE_BUCKETS; i++) {
>>               struct nfqnl_instance *inst;
>>               struct hlist_head *head = &q->instance_table[i];
>> @@ -938,7 +937,6 @@ static unsigned int nfqnl_nf_hook_drop(struct net *net)
>>                       instances++;
>>               }
>>       }
>> -     rcu_read_unlock();
>>
>>       return instances;
>>  }
>
> This is called from nfqnl_rcv_dev_event(), are you sure we can get rid
> of this rcu read lock ?

I'm sorry, I couldn't find code that nfqnl_rcv_dev_event() calls
nfqnl_nf_hook_drop().
Could you please tell me where I can find that code?
