From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: xtables: add cluster match
Date: Mon, 09 Feb 2009 16:25:41 +0100
Message-ID: <49904AF5.7060809@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145848.7501.18129.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57298 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZBIPZn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:25:43 -0500
In-Reply-To: <20090128145848.7501.18129.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the iptables cluster match. This match can be used
> to deploy gateway and back-end load-sharing clusters. Assuming that
> all the nodes see all packets (see arptables mcmangle target and
> PKTTYPE iptables targets on how to do that), the cluster match
> decides if this node has to handle a packet given:
> 
> 	jhash(source IP) % nodeID == 0
> 
> For related connections, the master conntrack is used. An example of
> its use for a gateway cluster, in one of the cluster nodes:
> 
> iptables -I PREROUTING -t mangle -i eth1 -m cluster \
> 	--cluster-total-nodes 2 --cluster-local-node 1 \
> 	--cluster-proc-name eth1 -j MARK --set-mark 0xffff
> iptables -A PREROUTING -t mangle -i eth1 \
> 	-m mark ! --mark 0xffff -j DROP
> iptables -A PREROUTING -t mangle -i eth2 -m cluster \
> 	--cluster-total-nodes 2 --cluster-local-node 1 \
> 	--cluster-proc-name eth2 -j MARK --set-mark 0xffff
> iptables -A PREROUTING -t mangle -i eth2 \

While its simple and probably gives good distribution, using the
source IP like this has the major disadvantage that when one node
fails, all nodes need to change rulesets and the existing mapping
of connections becomes at least partially invalid.

Also using conntrack data implies that this can't be used in the
raw table, which seems like the best place to drop foreign packets.
