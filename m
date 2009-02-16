From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 15:30:20 +0100
Message-ID: <4999787C.7050203@netfilter.org>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37281 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323AbZBPOWG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:22:06 -0500
In-Reply-To: <49997247.3010105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>>> ip maddr add 01:00:5e:00:01:01 dev eth1
>>>> ip maddr add 01:00:5e:00:01:02 dev eth2
>>>> arptables -I OUTPUT -o eth1 --h-length 6 \
>>>>     -j mangle --mangle-mac-s 01:00:5e:00:01:01
>>>> arptables -I INPUT -i eth1 --h-length 6 \
>>>>     --destination-mac 01:00:5e:00:01:01 \
>>>>     -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
>>>
>>> Mhh, is the saving of one or two characters really worth these
>>> deviations from the kind-of established naming scheme? Its hard
>>> to remember all these minor differences in my opinion.
>>
>> Hm, you mean the name "mangle" or the name of the option 
>> "--mangle-mac-d"? This is what we currently have in kernel mainline 
>> and arptables userspace, it's not my fault :). I can send you a patch 
>> to fix it with a consistent naming without breaking backward 
>> compatibility both in kernel and user-space.
> 
> Great, I wasn't aware that this already existed in userspace :)

Yes, it's hosted by the ebtables projects. That tool really need some 
care. It works but I don't know if it's actively maintained. Probably we 
can offer hosting for it in git.netfilter.org. I'll investigate this.

>>>> In the case of TCP connections, pickup facility has to be disabled
>>>> to avoid marking TCP ACK packets coming in the reply direction as
>>>> valid.
>>>>
>>>> echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
>>>
>>> I'm not sure I understand this. You *don't* want to mark them
>>> as valid, and you need to disable pickup for this?
>>
>> If TCP pickup is enabled, one TCP ACK packet coming in the reply 
>> direction enters TCP ESTABLISHED state. Since that's a valid 
>> state-transition, the cluster match will consider that this is part of 
>> a connection that this node is handling since it's a valid 
>> state-transition. The cluster match does not mark packets that trigger 
>> invalid state transitions.
> 
> Why use conntrack at all? Shouldn't the cluster match simply
> filter out all packets not for this cluster and thats it?
> You stated it needs conntrack to get a constant tuple, but I
> don't see why the conntrack tuple would differ from the data
> that you can gather from the packet headers.

No, source NAT connections would have different headers. A -> B for 
original, and B -> FW for reply direction. Thus, I cannot apply the same 
hashing for packets going in the original and the reply direction. 
Moreover, if this is packet-based, think also about possible asymmetric 
filtering: original traffic direction filtered by node 1 but reply 
traffic filtered by node 2. That will not work for a stateful firewall.

>>>> echo +2 > /proc/sys/net/netfilter/cluster/$PROC_NAME
>>>
>>> Does this provide anything you can't do by replacing the rule
>>> itself?
>>
>> Yes, the nodes in the cluster are identifies by an ID, the rule allows 
>> you to specify one ID. Say you have two cluster nodes, one with ID 1, 
>> and the other with ID 2. If the cluster node with ID 1 goes down, you 
>> can echo +1 to node with ID 2 so that it will handle packets going to 
>> node with ID 1 and ID 2. Of course, you need conntrackd to allow node 
>> ID 2 recover the filtering.
> 
> I see. That kind of makes sense, but if you're running a
> synchronization daemon anyways, you might as well renumber
> all nodes so you still have proper balancing, right?

Indeed, the daemon may also add a new rule for the node that has gone 
down but that results in another extra hash operation to mark it or not 
(one extra hash per rule) :(.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
