From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Wed, 20 Jan 2010 10:52:59 +0100
Message-ID: <4B56D27B.6070505@trash.net>
References: <4B5575CB.5050207@trash.net> <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu> <4B558C11.9020607@trash.net> <alpine.DEB.2.00.1001200941070.8728@blackhole.kfki.hu> <4B56CED1.1070109@trash.net> <alpine.DEB.2.00.1001201039071.8728@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32866 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0ATJxE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:53:04 -0500
In-Reply-To: <alpine.DEB.2.00.1001201039071.8728@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Wed, 20 Jan 2010, Patrick McHardy wrote:
> 
>> Jozsef Kadlecsik wrote:
>>> On Tue, 19 Jan 2010, Patrick McHardy wrote:
>>>
>>>> Adding an event mask to the ecache extension also looks unproblematic.
>>>> You could then use a rule like this:
>>>>
>>>> iptables -t raw .. -j CT --ctevents new,related,protoinfo,helper
>>>>
>>>> or something like that. Are the existing event types fine grained
>>>> enough for this?
>>> The possible events were cut back strongly and now the conntrack state 
>>> changes ASSURED and SEEN_REPLY cannot be distinguished. In my opinion 
>>> either SEEN_REPLY should not trigger an event at all or IPCT_ASSURED 
>>> should be put back.
>> I think it makes sense to generate an event for SEEN_REPLY since
>> its a synchronizable event (ctnetlink can also set the SEEN_REPLY
>> bit). I'm not opposed to add back IPCT_ASSURED, but I'm wondering,
>> in what case would userspace be interested in only one of both
>> updates?
> 
> I have only one case, but I think that's worth it: "sparse" conntrack 
> replication. Start replicating the conntrack entry after it reached the 
> ASSURED state and that way it's SYN-flood resistant. (Of course conntrack 
> could filter out the NEW/SEEN_REPLY state changes and wait for ASSURED, 
> but then the events are just sent unnecessarily.)

Sounds reasonable :) I'll add back the IPCT_ASSURED bit and will
post the entire series for review.
