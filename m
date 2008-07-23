From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 19:20:54 +0200
Message-ID: <48876876.6010006@trash.net>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net> <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net> <48876725.8010404@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40448 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYGWRU5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:20:57 -0400
In-Reply-To: <48876725.8010404@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Patrick McHardy wrote:
>>>> The first thing to try would be to use sane allocation sizes
>>>> for the event messages. This patch doesn't implement it properly
>>>> (uses probing), but should be enough to test whether it helps.
>>>
>>> Thanks a lot. This patch already decreased the CPU usage for ctevtest 
>>> from 85% to 44%. Sweet...
>>
>> Nice. Now we just need to do it properly :)
> 
> What do you mean with properly? Put some kind of cap? Or eliminate the 
> guessing by allocating a reasonable small fixed amount?

Yes, ideally it should use exact allocations, but thats probably
not worth it because it depends on too many factors. The next
best thing would be to allocate exactly the maximum thats needed.
The <<= 1 in my patch might still cause reallocations, some (or
all) of them could be avoided.

>>> nf_conntrack_event is now one of the first functions listed. Do you 
>>> see other ways of improving performance?
>>
>> For some members doing in-place message construction instead of
>> copying the data might help, but I couldn only spot few only
>> used rarely.
>>
>> The module reference stuff (module_put/nf_ct_*_find_get etc)
>> is clearly superfluous, this runs in packet processing context
>> and shouldn't use module references but RCU.
> 
> This goes too deep, that I could help you on this.

Its not really hard, all the nf_ct_*_find_get functions on the event
sending path should be replaced by the corresponding __nf_ct_*_find
functions and the _put functions removed. In case dumping functions
are used by both the event handler and userspace triggered dumps,
the userspace path needs to call rcu_read_lock/rcu_read_unlock.

