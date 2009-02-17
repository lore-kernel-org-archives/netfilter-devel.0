From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 17 Feb 2009 11:46:47 +0100
Message-ID: <499A9597.4070608@netfilter.org>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org> <499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57724 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752048AbZBQKrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:47:03 -0500
In-Reply-To: <499981FA.3040106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
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

While reworking this, I think that I have found one argument to support
the /proc interface that looks interesting in terms of resource
consumption. Assume that we have three nodes, where two of them are
down, thus, the only one active would have the following rule-set:

iptables -A PREROUTING -t mangle -i eth0 -m cluster \
        --cluster-total-nodes 3 --cluster-local-node 1 \
        -j MARK --set-mark 0xffff
iptables -A PREROUTING -t mangle -i eth0 -m cluster \
        --cluster-total-nodes 3 --cluster-local-node 2 \
        -j MARK --set-mark 0xffff
iptables -A PREROUTING -t mangle -i eth0 -m cluster \
        --cluster-total-nodes 3 --cluster-local-node 3 \
        -j MARK --set-mark 0xffff
iptables -A PREROUTING -t mangle -i eth0 \
        -m mark ! --mark 0xffff -j DROP

Look at the worst case: if the packet goes to node 3, the hashing must
be done to check if the packet belongs to node 1 and node 2. Thus, the
hashing is done three times. This makes the cluster hashing O(n) where n
is the number of cluster nodes.

A possible solution (that thinking it well, I don't like too much yet)
would be to convert this to a HASHMARK target that will store the result
of the hash in the skbuff mark, but the problem is that it would require
a reserved space for hashmarks since they may clash with other
user-defined marks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
