From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/09]: netfilter: CT target/conntrack zones
Date: Tue, 26 Jan 2010 15:56:03 +0100
Message-ID: <4B5F0283.4030401@trash.net>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <4B5EF6A4.6000201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36442 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0AZO4K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:56:10 -0500
In-Reply-To: <4B5EF6A4.6000201@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> Sorry for the silence, we're in the exams season since last week and
> that nuts a lot.
> 
> Patrick McHardy wrote:
>> The following patches contain a new version of the conntrack zones
>> patchset, including a new xtables target to (among other things) assign
>> conntracks to a specific zone, replacing the device attribute used
>> in the previous version.
>>
>> Quick overview:
>>
>> - Patch 1 adds a struct net * parameter to the xtables target parameter
>>   structures as preparation for the CT target, which needs to allocate
>>   a conntrack entry in the proper namespace
>>
>> - Patch 2 splits up the IPCT_STATUS event as requested by Jozsef. The
>>   CT target can be used for selective conntrack event delivery, this
>>   allows more fine grained control over the delivered events.
> 
> This is indeed interesting.
> 
>> - Patch 3 adds selective conntrack event delivery by adding two masks
>>   for conntrack and expectation events to struct nf_conntrack_ecache,
>>   which are used to filter out events.
> 
> This feature is something that I wanted since time ago. We can reduce
> the CPU consumption by reducing the amount of events. This is
> particularly good for ulogd2 and conntrackd.
> 
> My experiments showed that the BSF-based filtering does not provide any
> significant gain from filtering Netlink message in user-space. The
> problem is that we have to spend cycles building the message which seems
> to be costly.
> 
> AFAICS, this approach has one minor threat since it applies to all
> processes (I'm sure you're aware of it). I'm fine with this anyway, but
> maybe we should think of some way to make it per-process at some point?
> Some netlink unicast-based reporting similar to what NFLOG and NFQUEUE
> would solve this issue although they are implementing multicast over
> netlink unicast.

The question is whether that would really reduce overhead
since we'd like would have to construct messages multiple
times ourselves in that case. But yes, it might help.

>> - Patch 4 fixes ctnetlink to only assign helpers for matching protocols
>>   to conntrack entries and fixes expectation deletion by helper name.
>>   This is also preparation for the CT target, which can also assign
>>   helpers to new connections.
>>
>> - Patch 5 adds support for conntrack templates, which are specially marked
>>   conntrack entries attached to the skb that are used to initialize
>>   specific parameters of new connections.
>>
>> - Patch 6 adds the CT target
>>
>> - Patch 7 contains preparatory work for assigning conntracks to zones:
>>   the template needs to be passed to L4 ->error handlers for ICMP and
>>   ICMPv6 to perform the conntrack lookup in the correct zone
>>
>> - Patch 8 adds zone support to nf_conntrack and the CT target. This works
>>   by incorporating a numerical "zone" identifier into the conntrack/NAT
>>   hashes and comparing it during lookups.
>>
>> - Patch 9 adds zone support to ctnetlink by dumping and parsing a new
>>   CTA_ZONE attribute that contains the zone ID.
> 
> This conntrack zone stuff seems interesting. I'll add support for this
> to libnetfilter_conntrack. Kudos on you.

Great, thanks. I'll probably post a final version within the next
two days.

