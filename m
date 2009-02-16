From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 16:27:45 +0100
Message-ID: <499985F1.6070004@netfilter.org>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org> <499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58567 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814AbZBPPTg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:19:36 -0500
In-Reply-To: <499981FA.3040106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Pablo Neira Ayuso wrote:
>>> Patrick McHardy wrote:
>>>> I see. That kind of makes sense, but if you're running a
>>>> synchronization daemon anyways, you might as well renumber
>>>> all nodes so you still have proper balancing, right?
>>
>> Hm, I was not replying to your question ;). Right, the renumbering 
>> also requires getting the states back to the original node. We can use 
>> the same hashing approach in userspace to know which states belong to 
>> original node that has come back to life when it requests a 
>> resynchronization.
>>
>>> Indeed, the daemon may also add a new rule for the node that has gone 
>>> down but that results in another extra hash operation to mark it or 
>>> not (one extra hash per rule) :(.
>>
>> This is not true. We may have something like this (assuming two nodes):
> 
> To whom are you replying now? :)

To myself, never mind :)

>> if no mark set and hash % 2 == 0, accept
>> if no mark set and hash % 2 == 1, accept
>> if no mark set, drop
>>
>> So we can still do this adding rules with the iptables interface. But 
>> still having the /proc looks like a simple interface for this.
> 
> I'm sure someone would argue that changing TCP port numbers of
> the tcp match through proc would be a nice and simple interface.
> The fact though is that we have an interface for handing a
> configuration to the kernel and this is clearly a configuration
> parameter. We're missing a proper way to use it in userspace
> from within programs (well, hopefully not for long anymore),
> but that needs to be fixed in userspace.

Right right, I have no more arguments to support the /proc interface ;). 
I'll send you a patch without it late at night.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
