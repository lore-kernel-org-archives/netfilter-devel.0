From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 15:01:48 +0100
Message-ID: <499971CC.6040903@netfilter.org>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33885 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756513AbZBPNxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:53:36 -0500
In-Reply-To: <49994643.8010001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch adds the iptables cluster match. This match can be used
>> to deploy gateway and back-end load-sharing clusters.
> 
> I'm mixing comments to the cluster match and the ARP mangle target.
> 
>> Assuming that all the nodes see all packets (see below for an
>> example on how to do that if your switch does not allow this), the
>> cluster match decides if this node has to handle a packet given:
>>
>>     jhash(source IP) % total_nodes == node_id
>>
>> For related connections, the master conntrack is used. The following
>> is an example of its use to deploy a gateway cluster composed of two
>> nodes (where this is the node 1):
>>
>> iptables -I PREROUTING -t mangle -i eth1 -m cluster \
>>     --cluster-total-nodes 2 --cluster-local-node 1 \
>>     --cluster-proc-name eth1 -j MARK --set-mark 0xffff
>> iptables -A PREROUTING -t mangle -i eth1 \
>>     -m mark ! --mark 0xffff -j DROP
>> iptables -A PREROUTING -t mangle -i eth2 -m cluster \
>>     --cluster-total-nodes 2 --cluster-local-node 1 \
>>     --cluster-proc-name eth2 -j MARK --set-mark 0xffff
>> iptables -A PREROUTING -t mangle -i eth2 \
>>     -m mark ! --mark 0xffff -j DROP
>>
>> And the following commands to make all nodes see the same packets:
>>
>> ip maddr add 01:00:5e:00:01:01 dev eth1
>> ip maddr add 01:00:5e:00:01:02 dev eth2
>> arptables -I OUTPUT -o eth1 --h-length 6 \
>>     -j mangle --mangle-mac-s 01:00:5e:00:01:01
>> arptables -I INPUT -i eth1 --h-length 6 \
>>     --destination-mac 01:00:5e:00:01:01 \
>>     -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
> 
> Mhh, is the saving of one or two characters really worth these
> deviations from the kind-of established naming scheme? Its hard
> to remember all these minor differences in my opinion.

Hm, you mean the name "mangle" or the name of the option 
"--mangle-mac-d"? This is what we currently have in kernel mainline and 
arptables userspace, it's not my fault :). I can send you a patch to fix 
it with a consistent naming without breaking backward compatibility both 
in kernel and user-space.

>> arptables -I OUTPUT -o eth2 --h-length 6 \
>>     -j mangle --mangle-mac-s 01:00:5e:00:01:02
>> arptables -I INPUT -i eth2 --h-length 6 \
>>     --destination-mac 01:00:5e:00:01:02 \
>>     -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
>>
>> In the case of TCP connections, pickup facility has to be disabled
>> to avoid marking TCP ACK packets coming in the reply direction as
>> valid.
>>
>> echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
> 
> I'm not sure I understand this. You *don't* want to mark them
> as valid, and you need to disable pickup for this?

If TCP pickup is enabled, one TCP ACK packet coming in the reply 
direction enters TCP ESTABLISHED state. Since that's a valid 
state-transition, the cluster match will consider that this is part of a 
connection that this node is handling since it's a valid 
state-transition. The cluster match does not mark packets that trigger 
invalid state transitions.

> Unrelated to this patch, but maybe the target would also be
> better named "NAT" instead of the much more generic term "mangle".
> Why is it using lower case letters btw?

No idea who has done this, but I can send you a patch to fix this naming 
without breaking backward.

>> The match also provides a /proc entry under:
>>
>> /proc/sys/net/netfilter/cluster/$PROC_NAME
>>
>> where PROC_NAME is set via --cluster-proc-name. This is useful to
>> include possible cluster reconfigurations via fail-over scripts.
>> Assuming that this is the node 1, if node 2 is down, you can add
>> node 2 to your node-mask as follows:
>>
>> echo +2 > /proc/sys/net/netfilter/cluster/$PROC_NAME
> 
> Does this provide anything you can't do by replacing the rule
> itself?

Yes, the nodes in the cluster are identifies by an ID, the rule allows 
you to specify one ID. Say you have two cluster nodes, one with ID 1, 
and the other with ID 2. If the cluster node with ID 1 goes down, you 
can echo +1 to node with ID 2 so that it will handle packets going to 
node with ID 1 and ID 2. Of course, you need conntrackd to allow node ID 
2 recover the filtering.

Now, I see that there is a possible optimization that consists of 
checking if one node has its node mask all set with regards to the total 
number of nodes, so that hashing can be skipped. But that's something 
that we can add later I think.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
