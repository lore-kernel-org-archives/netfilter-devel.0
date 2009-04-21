From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Tue, 21 Apr 2009 14:22:22 +0200
Message-ID: <49EDBA7E.2040200@trash.net>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org> <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu> <49EC896E.5070402@trash.net> <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZDUMW2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:22:28 -0400
In-Reply-To: <alpine.DEB.2.00.0904201838090.11586@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Mon, 20 Apr 2009, Patrick McHardy wrote:
> 
>> Jozsef Kadlecsik wrote:
>>> On Mon, 20 Apr 2009, Pablo Neira Ayuso wrote:
>>>> I wasn't refering to any iptables target. New ulogd2 includes support
>>>> for ctnetlink, which can do this. I know, that means the extra libraries
>>>> dependencies.
>>> I see. Thanks the info, good to know that ulogd2 is capable of this.
>>> (Calling 'conntrack' for logging looked really ugly. :-)
>> In the kernel, we could log the information from the conntrack
>> entry, if any. That would allow to log the manips after they
>> have been set up.
> 
> Yes, but I'd not want an unconditional logging.

I missed the point, you're already doing what I had in mind (use
ct->tuplehash->...) and the new hook is needed to even get a chance
to log the packet after SNAT.

>> Would Pablo's suggestion or the conntrack method work for you?
> 
> Oh, it's not for me at all: at a workshop I was asked how to log the info 
> (hint: conflicker ;-) and embarrased enough I had to admit there was no 
> easy way. That's why I put together the patch, with all it's questionable 
> details.

I can see that it has some informational value, but for things like
locating infected hosts, why not simply look at the traffic before
it is NATed? I currently can't come up with a real use case for
this ...
