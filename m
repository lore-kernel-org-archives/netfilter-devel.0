From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 16:01:38 +0100
Message-ID: <49997FD2.3090208@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60379 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZBPPBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:01:43 -0500
In-Reply-To: <4999787C.7050203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Why use conntrack at all? Shouldn't the cluster match simply
>> filter out all packets not for this cluster and thats it?
>> You stated it needs conntrack to get a constant tuple, but I
>> don't see why the conntrack tuple would differ from the data
>> that you can gather from the packet headers.
> 
> No, source NAT connections would have different headers. A -> B for 
> original, and B -> FW for reply direction. Thus, I cannot apply the same 
> hashing for packets going in the original and the reply direction. 

Ah I'm beginning to understand the topology I think :) Actually
it seems its only combined SNAT+DNAT on one connections thats a
problem, with only one of both you could tell the cluster match
to look at either source or destination address (the unchanged one)
in the opposite direction. Only if the opposite direction is
completely unrelated from a non-conntrack view we can't deal with
it. Anyways, your way to deal with this seems fine to me.

>>>>> echo +2 > /proc/sys/net/netfilter/cluster/$PROC_NAME
>>>>
>>>> Does this provide anything you can't do by replacing the rule
>>>> itself?
>>>
>>> Yes, the nodes in the cluster are identifies by an ID, the rule 
>>> allows you to specify one ID. Say you have two cluster nodes, one 
>>> with ID 1, and the other with ID 2. If the cluster node with ID 1 
>>> goes down, you can echo +1 to node with ID 2 so that it will handle 
>>> packets going to node with ID 1 and ID 2. Of course, you need 
>>> conntrackd to allow node ID 2 recover the filtering.
>>
>> I see. That kind of makes sense, but if you're running a
>> synchronization daemon anyways, you might as well renumber
>> all nodes so you still have proper balancing, right?
> 
> Indeed, the daemon may also add a new rule for the node that has gone 
> down but that results in another extra hash operation to mark it or not 
> (one extra hash per rule) :(.

Thats not what I meant. By having a single node handle all connections
from the one which went down, you have an imbalance in load
distribution. The nodes are synchronized, so they could just all
replace their cluster match with an updated number of nodes.

