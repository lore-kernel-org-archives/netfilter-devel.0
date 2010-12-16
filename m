From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 16 Dec 2010 10:57:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
 <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, tgraf@redhat.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57309 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab0LPJ5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:57:16 -0500
In-Reply-To: <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Cc.ed Thomas Graf (tgraf@redhat.com), Thomas presented some interesting 
ideas on netlink error-codes and strings during NetConf 2010, see:

  http://vger.kernel.org/netconf2010.html
  http://vger.kernel.org/netconf2010_slides/tgraf_netconf10.odp


On Wed, 15 Dec 2010, Jozsef Kadlecsik wrote:
> On Wed, 15 Dec 2010, Jan Engelhardt wrote:
>> On Friday 2010-11-26 20:01, Jozsef Kadlecsik wrote:
>>> On Wed, 24 Nov 2010, Jan Engelhardt wrote:
>>>
>>>> By request of Pablo, I am posting the Xtables2 Netlink interface
>>>> specification for review. Additionally, further documentation and
>>>> toolchain around it is available through the temporary project page at
>>>>
>>>> 	http://jengelh.medozas.de/projects/xtables/
>>>>  * Runnable userspace library (libnetfilter_xtables)
>>>>    with small test-and-debug program
>>> [...]
>>>
>>> Please add fine-grained error reporting to the protocol: in my opinion the
>>> main shortcoming of the current kernel-userspace xtables protocol is the
>>> lack of the proper error reporting. I mean, the new protocol should be
>>> able to carry back which rule caused the error, in the rule whether it was
>>> a general kind of error (ENOMEM), or a table, chain, match or target error
>>> and exactly what was the error at table/chain/match/target level.
>>
>> That should not be a problem. However, what do we do with the general
>> kind of error that is overly general? A.k.a. the dreaded EINVAL.
>>
>> Say a user requested jumping to a chain, but did not give a chain name.
>> Normally that would be EINVAL, but EINVAL is overused already.
>
> When I wrote general error I meant the ones where there is no point (or
> cannot be) to specify the nature of the error exactly. Like in the
> example, ENOMEM: it's needles to report which new data field could not be
> allocated. But if the specified chain does not exists, that must not be
> masked by a general EINVAL. The user must be alerted that the chain with
> the given name does not exist.
>
>> What would you like? Comprehensive error numbers (sort of like the
>> ones Windows is said to use) aka. NFXTE_NO_CHAIN_NAME_GIVEN,
>> or a human-readable string; or something else?
>
> Yes, use comprehensive error codes. And it's the responsibility of the
> userspace tool to translate them to proper error messages.
>
>>> Say, the TCPMSS target should be able to report back that it cannot be
>>> used outside of FORWARD, OUTPUT and POSTROUTING.
>>
>> NFXTE_HOOKMASK_NOT_ADHERED or string?
>
> The former, i.e. error code.
>
>>> Or that the rule must match TCP SYN packets.
>>
>> TCPMSS doing a rule-search for -p tcp is pretty ugly (it must understand
>> the data structures, and that is sort of a backwards shot); Patrick
>> once suggested IIRC that TCPMSS should just silently skip non-SYNs.
>
> For the clarity of the rules I'd prefer the current solution, i.e. check
> and enforce that the rule matches TCP SYN packets. If we relax it, next
> time someone could complain why TCPMSS is restricted to FORWARD, OUTPUT,
> POSTROUTING, why can't the system simply skip the target when called at
> non-appropriate hooks.
>
> But I just picked TCPMSS target for errors which currently expressed
> in EINVAL.
>
>> Maybe both error numbers, and providing extensions with the
>> possibility to send strings? It is impossible to provision error
>> numbers for out-of-tree extensions, so having a way for an extension
>> to return some NFXTA_ERRSTR "One of my parameters is wrong!" seems
>> required at least.

I like this.

> I have got a three-level error coding in my mind: general, standard error
> codes (ENOMEM, EPERM, etc.), general netfilter specific ones (like
> NFXTE_HOOKMASK_NOT_ADHERED) and table/match/target specific ones.
>
> But I do realize that it's much easier (and therefore quite tempting) to
> construct the full error message in kernel space and just send it back.
> However, that'd make quite hard to support internationalization.

To support internationalization, we could just add an error-number-code 
in front of the constructed error message?

I'm a fan of the full error message system from the kernel, becuase its 
much easier to maintain, as we don't need to update iptables userspace 
each time we introduce a new error code/message.


Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
