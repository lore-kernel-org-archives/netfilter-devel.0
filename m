From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH RESEND v3] netfilter: xtables: add quota support to nfacct
Date: Fri, 14 Feb 2014 08:20:44 -0700
Message-ID: <CANLsYkxyO7=0BQY1m-r5=Gqey+FH1LGzioQZJcn6oLCwNS9CZQ@mail.gmail.com>
References: <1391292671-26466-1-git-send-email-mathieu.poirier@linaro.org>
	<20140201225726.GF776@breakpoint.cc>
	<CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
	<20140202204012.GJ776@breakpoint.cc>
	<CANLsYkw=vVbc_cCAHHusxHmFi2EXg3jM6baG8jV355SDeHa1Pg@mail.gmail.com>
	<20140212103325.GA15713@localhost>
	<CANLsYky+Zo5GG0uDiwcXBb72nZDMDnKC2Q3hSUNaj9mu=cCp6Q@mail.gmail.com>
	<20140212221631.GA22457@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:48688 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaBNPUo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:20:44 -0500
Received: by mail-yh0-f42.google.com with SMTP id a41so11823196yho.29
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2014 07:20:44 -0800 (PST)
In-Reply-To: <20140212221631.GA22457@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 February 2014 15:16, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 12, 2014 at 09:58:28AM -0700, Mathieu Poirier wrote:
> [...]
>> > I can see that packet and byte counters are not in sync, but I don't
>> > see why that should be a problem for your quota extension. Your
>> > accounting is based on packet *OR* byte counters.
>>
>> If we have a filter reporting the amount of packets and bytes that
>> have gone through a chain the least we can do is make them coherent.
>> Otherwise the numbers simply can't be trusted.  Fixing that problem is
>> what I've done in the 4th version of my patchset sent on Monday.
>>
>> > Moreover, if you inspect the result of the counter update via
>> > atomic_inc_return / atomic_add_return, you can ensure that packets
>> > running out of the quota limit will always match.
>>
>> Thanks for Florian Westphal's hint on 'cmpxchg' I came up with a match
>> algorithm that requires no spinlock and doesn't mandate that packet
>> count be synchronised with bytes.  Before sending it out I'd like us
>> to reach a consensus on the above - I think the current accounting
>> method is broken and ought to be fixed.
>
> I really think we should skip that spinlock with atomic64. That
> doesn't make sense to me.

I'm not fond of it either.

>
>> If the current situation is fine with you I'll simply send another
>> version that works without counts being synchronised - but I really
>> think we can do better.
>
> Given the interferences that you described, I think you can use this
> approach to ensure that only one event is delivered:
>
>         if (old < info->quota && new >= info->quota &&
>             test_and_set_bit(0, info->quota_reached))
>                 deliver_event(...);

I had something similar but I used atomic_cmpxch() instead:

         if (val >= info->quota)
                 if (atomic_cmpxchg(&info->priv->notified, 0, 1) == 0)
                        nfnl_quota_event(info->nfacct);

Note that I've embedded 'notified' in a private field since userspace
doesn't need to know what we do in the kernel.  I've also used an
atomic value... Get back to me with your preference.

>
> On top of that, there's another problem that needs to be solved now
> that we have a quota_reached field in the info area. This needs a
> "database of quota objects" that are identified by a name, otherwise
> iptables rule updates will trigger a new (unnecessary event) event
> every time *any* new rule is added.
>
> If you want to test what I mean, try this:
>
> iptables -I INPUT -m quota --quota 1000 -j LOG --log-prefix "quota: "
>
> then keep an eye on /var/log/messages, ping somewhere to generate
> traffic. You should see log messages for each packet until the quota
> is reached.  After a couple of ICMP packets, you will see no more logs
> since the quota has been reached.
>
> Now, keep monitoring /var/log/messages and add any rule, eg. iptables
> -I INPUT. The quota matches again and you'll start seeing more log
> messages since every rule updates "resets" the internal state of the
> match. This is a known problem. To solve this, you have to use a
> specific quota object with a refcnt that is identified by a name. See
> xt_hashlimit.c for instance. Note that the quota_reached can't be
> added to the existing nfacct object since it's a valid configuration
> to have two rules using with different quota values that refer to the
> same nfacct object (think of a scenario in which you want to throttle
> to N Kbytes/s after X bytes has been consumed, then throttle to a
> lower M Kbytes/s after X+Y bytes has been consumed).

Thanks for pointing this out - I was able to reproduce the problem
with the quota filter.  I'll look at the effect on nfacct and will get
back to you if I have questions.

>
> Thus, the iptables command for this should look like:
>
> iptables -I INPUT -p icmp \
>         -m nfacct --mode packets --quota 100 --quota-name icmp-quota-100
>
> In _mt_check you have to look up for "icmp-quota-100" in the list of
> quota objects to attach it to the rule. If it doesn't exist you create
> it. In the _destroy path, you have to put the refcnt, if it reaches
> zero, it will be released. It may sound tricky, but this will work
> fine in practise.
>
> Please, take the time to digest this and let us know if you have any
> question. Thank you.
