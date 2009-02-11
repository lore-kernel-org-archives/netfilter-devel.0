From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Wed, 11 Feb 2009 15:51:25 +0100
Message-ID: <4992E5ED.70607@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net> <4990B910.1050802@netfilter.org> <49918948.5010103@trash.net> <alpine.DEB.2.00.0902101512500.9244@blackhole.kfki.hu> <49918D91.60801@trash.net> <4991C370.9000907@netfilter.org> <4992C3FB.8070606@trash.net> <4992DE8F.5000609@netfilter.org> <4992E219.2090409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51137 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbZBKOvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:51:48 -0500
In-Reply-To: <4992E219.2090409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Pablo Neira Ayuso wrote:
>>>> Patrick McHardy wrote:
>>>>> Jozsef Kadlecsik wrote:
>>>>>> On Tue, 10 Feb 2009, Patrick McHardy wrote:
>>>>>>
>>>>>>> Yes, I know, I'm just wondering why you're using TCP at all for
>>>>>>> synchronizing. Its not for traffic from the Internet I assume
>>>>>>> since the node it ends up on is unknown to the outside anyways.
>>>>>> No, that's not the syncronizing traffic, but the "normal" TCP traffic
>>>>>> to be filtered by the firewalls, which have got multicast MAC
>>>>>> addresses on their interfaces.
>>>>> Multicast traffic is accepted for forwarding just fine, its just
>>>>> local TCP delivery thats refusing it. So it can't be forwarded
>>>>> traffic.
>>>> You usually have some administration facility (like ssh) that would
>>>> break. Please, think that this can be also used to replace CLUSTERIP
>>>> (to
>>>> be used in back-end servers, not only stateful firewalls).
>>> I see. Still, this module has only one purpose, which is to circumvent
>>> valid checks to make a different hack (although a nicer one) work.
>>> Perhaps simply move it into the cluster match (yes yes, I know). That
>>> way we can also avoid a bit of the new-module overhead.
>>
>> Then, the cluster match would become the target match, since skbuff
>> cannot be modified from matches (they are passed as const). Becoming a
>> target means less flexibility :(
> 
> Well, a cast should "fix" that :) But feel free to suggest a
> better method that doesn't need to expose this as a standalone
> feature.

Hm, I forgot another point that is the fact that the PKTTYPE target is
not always required. Actually, if the switch can flood the same packets
to a set of nodes that are part of the cluster via "port mirroring" or
if the switch interprets the VRRP reserved MAC address range correctly
(I did not find any yet), the nodes in the cluster would not need to use
with a multicast MAC address, in that case, the PKTTYPE target would not
be required.

Well, I'll do the hackish solution if that relieves the possible extra
bloat of one target that indeed only has this purpose ;). I'll send you
a new version of the patch asap.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
