From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 11:36:43 +0400
Message-ID: <4E0C278B.7010403@yandex.ru>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>	 <1309340843.2532.112.camel@edumazet-laptop>	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru> <1309416426.2532.119.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward4.mail.yandex.net ([77.88.46.9]:59650 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1F3HqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:46:12 -0400
In-Reply-To: <1309416426.2532.119.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  On 30.06.2011 10:47, Eric Dumazet wrote:
> Le jeudi 30 juin 2011 =C3=A0 10:20 +0400, Kuzin Andrey a =C3=A9crit :
>> On 29.06.2011 14:08, Eric Dumazet wrote:
>>> Le mercredi 29 juin 2011 =C3=A0 11:55 +0200, Anders Nilsson Plymoth=
 a =C3=A9crit :
>>>> Hi Eric,
>>>>
>>>> Thanks for your reply.
>>>> Yes, I am sure I set the verdict, as right now I do it on all pack=
ets
>>>> by default.
>>>> I will try upgrading and see if it works. Do you know if commit
>>>> c463ac972315a0 solves the problem you mentioned?
>>> No, it doesnt solve the problem, only make things faster.
>>>
>>> But if some packets are never dequeued (because something is wrong =
with
>>> your program, failing to give verdict), they stay forever in the li=
st
>>> and each dequeue is slower since it has to go past these packets...
>>>
>>> 2.6.37 also contains commit 29b4433d991c88d86ca48a4c1cc33c671475be4=
b
>>> (net: percpu net_device refcount) which helps a lot netfilter
>>> queue/dequeue if your machine is SMP.
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netfilter=
-devel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>> Hello.
>> I'am using NFQUEUE several years on our main network router, and pro=
blem
>> with packets stuck in the queue is still not resolved.
>> But in the past when i use libipq, it not have this problem. I try t=
o
>> use simple program with ACCEPT verdict on all packets, and after som=
e
>> time queue has packets without any verdict, result is large (and
>> increased) delays on every packet and waste CPU time.
>>
>> I'am write patch for this, but it doesn't apply by any netfilter
>> developers. Today i'am not using any kernel without this NFQUEUE pat=
ch.
>>
>> diff --git a/net/netfilter/nfnetlink_queue.c
>> b/net/netfilter/nfnetlink_queue.c
>> index 8c86011..74fc322 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -169,17 +169,29 @@ __enqueue_entry(struct nfqnl_instance *queue,
>> struct nf_queue_entry *entry)
>>           queue->queue_total++;
>>    }
>>
>> +#define NFQNL_TIMEOUT_ENTRY_DROP 20
>> +
>>    static struct nf_queue_entry *
>>    find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
>>    {
>> -       struct nf_queue_entry *entry =3D NULL, *i;
>> +       struct nf_queue_entry *entry =3D NULL, *next, *i;
>> +       ktime_t kt =3D ktime_get_real();
>>
>>           spin_lock_bh(&queue->lock);
>>
>> -       list_for_each_entry(i,&queue->queue_list, list) {
>> +       list_for_each_entry_safe(i, next,&queue->queue_list, list) {
>>                   if (i->id =3D=3D id) {
>>                           entry =3D i;
>>                           break;
>> +                } else {
>> +                       struct timeval tv =3D
>> ktime_to_timeval(ktime_sub(kt, i->skb->tstamp));
>> +                       if (tv.tv_sec>  NFQNL_TIMEOUT_ENTRY_DROP) {
>> +                               printk(KERN_ERR "nf_queue: drop
>> timeouted packet "
>> +                                       "(queue_num=3D%d seq_id=3D%d=
)\n",
>> queue->queue_num, i->id);
>> +                               list_del(&i->list);
>> +                               queue->queue_total--;
>> +                               nf_reinject(i, NF_DROP);
>> +                       }
>>                   }
>>           }
>>
> You do realize we have to find out what happened to these packets, wh=
y
> no verdict was given at all ?
>
> Also, where skb->tstamp is set exactly ? This depends on
> netstamp_needed ?
>
Every day netfilter code become  more and more difficult to understand.=
=20
IPQ mechanism don't have
this problems, migration to NFQUEUE by simply modifications of function=
=20
names in original program
code led to these problems. I think it very hard to find this error in=20
netfilter code and may be sometimes
NFQUEUE will be rewritten from scratch to NGQUEUE (next generation queu=
e) ;)
I wrote this patch as simply as possible (one-hour solution) to solve=20
the problem for the our paid services.
Early no one netfilter developer did not pay any attention to messages=20
about this problem.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
