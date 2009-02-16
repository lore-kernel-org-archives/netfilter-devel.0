From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 11:56:03 +0100
Message-ID: <49994643.8010001@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53439 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZBPK4G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:56:06 -0500
In-Reply-To: <20090214192936.11718.44732.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the iptables cluster match. This match can be used
> to deploy gateway and back-end load-sharing clusters.

I'm mixing comments to the cluster match and the ARP mangle target.

> Assuming that all the nodes see all packets (see below for an
> example on how to do that if your switch does not allow this), the
> cluster match decides if this node has to handle a packet given:
> 
> 	jhash(source IP) % total_nodes == node_id
> 
> For related connections, the master conntrack is used. The following
> is an example of its use to deploy a gateway cluster composed of two
> nodes (where this is the node 1):
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
> 	-m mark ! --mark 0xffff -j DROP
> 
> And the following commands to make all nodes see the same packets:
> 
> ip maddr add 01:00:5e:00:01:01 dev eth1
> ip maddr add 01:00:5e:00:01:02 dev eth2
> arptables -I OUTPUT -o eth1 --h-length 6 \
> 	-j mangle --mangle-mac-s 01:00:5e:00:01:01
> arptables -I INPUT -i eth1 --h-length 6 \
> 	--destination-mac 01:00:5e:00:01:01 \
> 	-j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

Mhh, is the saving of one or two characters really worth these
deviations from the kind-of established naming scheme? Its hard
to remember all these minor differences in my opinion.

> arptables -I OUTPUT -o eth2 --h-length 6 \
> 	-j mangle --mangle-mac-s 01:00:5e:00:01:02
> arptables -I INPUT -i eth2 --h-length 6 \
> 	--destination-mac 01:00:5e:00:01:02 \
> 	-j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
> 
> In the case of TCP connections, pickup facility has to be disabled
> to avoid marking TCP ACK packets coming in the reply direction as
> valid.
> 
> echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose

I'm not sure I understand this. You *don't* want to mark them
as valid, and you need to disable pickup for this?

Unrelated to this patch, but maybe the target would also be
better named "NAT" instead of the much more generic term "mangle".
Why is it using lower case letters btw?

> The match also provides a /proc entry under:
> 
> /proc/sys/net/netfilter/cluster/$PROC_NAME
> 
> where PROC_NAME is set via --cluster-proc-name. This is useful to
> include possible cluster reconfigurations via fail-over scripts.
> Assuming that this is the node 1, if node 2 is down, you can add
> node 2 to your node-mask as follows:
> 
> echo +2 > /proc/sys/net/netfilter/cluster/$PROC_NAME

Does this provide anything you can't do by replacing the rule
itself?
