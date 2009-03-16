From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Mar 2009 17:11:33 +0100
Message-ID: <49BE7A35.1090003@trash.net>
References: <20090223101354.7104.45999.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49754 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPQLg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:11:36 -0400
In-Reply-To: <20090223101354.7104.45999.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the iptables cluster match. This match can be used
> to deploy gateway and back-end load-sharing clusters. The cluster
> can be composed of 32 nodes maximum (although I have only tested
> this with two nodes, so I cannot tell what is the real scalability
> limit of this solution in terms of cluster nodes).
> 
> Assuming that all the nodes see all packets (see below for an
> example on how to do that if your switch does not allow this), the
> cluster match decides if this node has to handle a packet given:
> 
> 	(jhash(source IP) % total_nodes) & node_mask
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
> 
> BTW, some final notes:
> 
>  * This match mangles the skbuff pkt_type in case that it detects
> PACKET_MULTICAST for a non-multicast address. This may be done in
> a PKTTYPE target for this sole purpose.
>  * This match supersedes the CLUSTERIP target.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> 
>  include/linux/netfilter/xt_cluster.h |   15 +++
>  net/netfilter/Kconfig                |   16 +++
>  net/netfilter/Makefile               |    1 
>  net/netfilter/xt_cluster.c           |  164 ++++++++++++++++++++++++++++++++++
>  4 files changed, 196 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/netfilter/xt_cluster.h
>  create mode 100644 net/netfilter/xt_cluster.c

Applied, thanks. I've also added xt_cluster.h to the Kbuild file so
the header will be installed.
