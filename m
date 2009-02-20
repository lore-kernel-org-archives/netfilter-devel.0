From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Fri, 20 Feb 2009 14:48:56 +0100
Message-ID: <499EB4C8.5090103@trash.net>
References: <20090219231439.6164.354.stgit@Decadence> <499E76DA.7010802@trash.net> <499EACEC.60702@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51000 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZBTNs7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:48:59 -0500
In-Reply-To: <499EACEC.60702@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> +    if (ct->master)
>>> +        hash = xt_cluster_hash(ct->master, info);
>>> +    else
>>> +        hash = xt_cluster_hash(ct, info);
>>
>> This makes a lot of sense for helpers like SIP, where the expectation
>> can arrive from a different source address. I'm just wondering how
>> this works when not using reliable synchronization - in that case, other
>> nodes might not be aware of the expectation and also accept the packet.
>> I don't have a suggestion besides making sure expectations are
>> synchronized, just thought I'd point it out.
> 
> Indeed.
> 
> This sort of problem is interesting, just in case that you have some 
> spare time to think about other synchronization-related problems 
> (otherwise you can skip the following below :)). Conntrackd does not 
> synchronize expectations (at least, it's not in my plans yet), it 
> synchronizes conntrack entries, and that includes the relationship 
> between master and related conntracks. Thus, after the failover, the new 
> primary node knows that the master connection has a helper (so it can 
> create new expectations) and already existing established-related 
> connections are linked to the master conntracks.
> 
> Still I see two possible problematic situations with these approach:
> 
>  * If expectations are not propagated, this means than a FTP-data 
> connections that is about to start would not success if that connection 
> happens during a failover as the expectation information is lost.
> 
>  * If the state information is lost for whatever reason (like not using 
> conntrackd at all or losing the state information due to netlink 
> unreliability), then the former expected connection would be handled 
> like a normal connection by one cluster node. For example, this would 
> break if destination nat is used in the case of FTP (and similarly for 
> other helpers I think).
> 
> For the first problem, I can say that conntrackd can be tuned to reduce 
> the chances of this to happen (at the cost of investing more resources 
> in the synchronization). Moreover, connections that are about to start 
> may retry in short and no data was exchanged indeed.

Good point.

> For the second problem, this is actually the sort of problems that I 
> want to avoid making netlink reliable by dropping packets. By reducing 
> the chances to lose state information for whatever reason.

Yes, although the netlink delivery only covers part of it. It might
be the path where most events are lost though.

>>> +static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
>>> +{
>>> +    struct xt_cluster_match_info *info = par->matchinfo;
>>> +
>>> +    if (info->node_mask > (1 << info->total_nodes)) {
>>> +        printk(KERN_ERR "xt_cluster: the id of this node cannot be "
>>> +                "higher than the total number of nodes\n");
>>
>> This looks like an off-by-one (warning: still at first coffee :)).
>> It may also not be equal to the mask I'd expect. I can change it
>> to >= when applying if you agree.
> 
> You're right! Please change it.

I noticed another problem during compilation:

net/netfilter/xt_cluster.c: In function 'xt_cluster_mt':
net/netfilter/xt_cluster.c:124: warning: passing argument 2 of 
'constant_test_bit' from incompatible pointer type
net/netfilter/xt_cluster.c:124: warning: passing argument 2 of 
'variable_test_bit' from incompatible pointer type

The problem is that is uses a u32 for the mask, but the bitops are
only defined for unsigned longs. Which is a bit unfortunate since
they're not well suited for ABI structures. I'd suggest to simply
open-code the bit tests.

