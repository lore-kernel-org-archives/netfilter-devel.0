From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 17 Feb 2009 14:50:43 +0100
Message-ID: <499AC0B3.5040902@netfilter.org>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org> <499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net> <499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48200 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751018AbZBQNux (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:50:53 -0500
In-Reply-To: <499A9689.7090208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> While reworking this, I think that I have found one argument to support
>> the /proc interface that looks interesting in terms of resource
>> consumption. Assume that we have three nodes, where two of them are
>> down, thus, the only one active would have the following rule-set:
>>
>> iptables -A PREROUTING -t mangle -i eth0 -m cluster \
>>         --cluster-total-nodes 3 --cluster-local-node 1 \
>>         -j MARK --set-mark 0xffff
>> iptables -A PREROUTING -t mangle -i eth0 -m cluster \
>>         --cluster-total-nodes 3 --cluster-local-node 2 \
>>         -j MARK --set-mark 0xffff
>> iptables -A PREROUTING -t mangle -i eth0 -m cluster \
>>         --cluster-total-nodes 3 --cluster-local-node 3 \
>>         -j MARK --set-mark 0xffff
>> iptables -A PREROUTING -t mangle -i eth0 \
>>         -m mark ! --mark 0xffff -j DROP
>>
>> Look at the worst case: if the packet goes to node 3, the hashing must
>> be done to check if the packet belongs to node 1 and node 2. Thus, the
>> hashing is done three times. This makes the cluster hashing O(n) where n
>> is the number of cluster nodes.
>>
>> A possible solution (that thinking it well, I don't like too much yet)
>> would be to convert this to a HASHMARK target that will store the result
>> of the hash in the skbuff mark, but the problem is that it would require
>> a reserved space for hashmarks since they may clash with other
>> user-defined marks.
> 
> That sounds a bit like a premature optimization. What I don't get
> is why you don't simply set cluster-total-nodes to one when two
> are down or remove the rule entirely.

Indeed, but in practise existing failover daemons (at least those
free/opensource that I know) doesn't show that "intelligent" behaviour
since they initially (according to the configuration file) assign the
resources to each node, and if one node fails, it assigns the
corresponding resources to another sane node (ie. the daemon runs a
script with the corresponding iptables rules).

Re-adjusting cluster-total-nodes and cluster-local-nodes options (eg. if
one cluster node goes down and there are only two nodes alive, change
the rule-set to have only two nodes) seems indeed the natural way to go
since the alive cluster nodes would share the workload that the failing
node has left. However, as said, existing failover daemons only select
one new master to recover what a failing node was doing, thus, only one
runs the script to inject the states into the kernel.

Therefore AFAICS, without the /proc interface, I would need one iptables
rule per cluster-local-node handled, and so it's still the possible
sub-optimal situation when one or several node fails.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
