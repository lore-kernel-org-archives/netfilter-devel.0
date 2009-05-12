From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 16:45:19 +0200
Message-ID: <4A098B7F.6050605@netfilter.org>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <4A097752.4030303@netfilter.org> <alpine.DEB.2.00.0905121524020.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45158 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZELOp2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 10:45:28 -0400
In-Reply-To: <alpine.DEB.2.00.0905121524020.28379@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 12 May 2009, Pablo Neira Ayuso wrote:
> 
>> First of all, this is clashing with seven big patches that I have here
>> including one to kill the notifier call chain :), I'm waiting for
>> Patrick to open nf-next-2.6 to send them all. I can send them now.
> 
> (I have promised patches ;-). Yes, I know they're clashing, I should have 
> added the RFC tag to the subject. As soon as your patches are integrated 
> I'll adapt my patches.

Great, thanks! First, my patches have to pass Patrick's review :).

>>> The patch adds support to control the in-kernel event generation.
>>> In practice we face two problems: we should support a fine-grained
>>> event generation in netfilter, in order to be able to catch and follow
>>> the different state changes. At the same time, for example for conntrack
>>> replication, a too fine-grained event generation can easily result in
>>> a high, unnecessary system load. BFP and/or userspace event filtering
>>> is not effective enough to avoid it: the resources are already burnt
>>> on building up the netlink messages.
>> Yes, some fine-grain filtering to avoid the message building would be
>> interesting, however, what you're proposing is not flexible enough for
>> two different applications that are interested in different events. Time
>> ago, I proposed a netlink unicast-based interface for ctnetlink similar
>> to nfnetlink_queue and the NFQUEUE target. Still, it needed yet another
>> table (at the end of postrouting) for something very specific.
> 
> But if application A is interested in event X and application B is 
> interested in event Y, then why would it be any problem for the solution 
> I'm proposing? Just proper rules are required, then the events X and Y 
> will be generated and delivered to the clients. What do I miss here?

Nothing I think, I'm refering to the approach itself. If there's one
application A that want to receive all events and another B that only
wants one event, A and B will receive all events. I think that this
should be per-process.

[...]
> Yes, but the kernel must supply all events the different applications 
> want. So actually, it's simpler on the kernel side: it needs just to know 
> the events wanted. And does not really matter, which application wants 
> which event.

Yes, it's simpler from the kernel-side but allowing selecting this from
user-space provides more flexibility.

> [...] 
>> In my patches I have added a per-ct event cache like this (but using the
>> conntrack extension infrastructure) to add reliable event reporting,
>> which is something that we also need for logging and synchronization.
>>
>> BTW, I don't like using connmark for this.
> 
> You mean the CONNMARK target? I deliberately avoided using the connection 
> marks. Or "marking" the connections by the eventmask? But that is the most 
> effective way to filter the events.

I see, but something similar to nfnetlink_queue/NFQUEUE (per-process)
together with an extended version of the `conntrack match' for events
would be more flexible.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
