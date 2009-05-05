From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: iptables: fix use of cluster match with
 32	nodes
Date: Tue, 05 May 2009 17:47:02 +0200
Message-ID: <4A005F76.7000206@trash.net>
References: <20090505131219.7241.85258.stgit@Decadence> <20090505131403.7241.25297.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45248 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZEEPrG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 11:47:06 -0400
In-Reply-To: <20090505131403.7241.25297.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch fixes a problem when you use 32 nodes in the cluster
> match:
> 
> % iptables -I PREROUTING -t mangle -i eth0 -m cluster \
>   --cluster-total-nodes  32  --cluster-local-node  32 \
>   --cluster-hash-seed 0xdeadbeef -j MARK --set-mark 0xffff
> iptables: Invalid argument. Run `dmesg' for more information.
> % dmesg | tail -1
> xt_cluster: this node mask cannot be higher than the total number of nodes
> 
> The problem is related to this checking:
> 
> if (info->node_mask >= (1 << info->total_nodes)) {
> 	printk(KERN_ERR "xt_cluster: this node mask cannot be "
> 			"higher than the total number of nodes\n");
> 	return false;
> }
> 
> (1 << 32) is 1. Thus, the checking fails.
> 
> BTW, I said this before but I insist: I have only tested the cluster
> match with 2 nodes getting ~45% extra performance in an active-active setup.
> The maximum limit of 32 nodes is still completely arbitrary. I'd really
> appreciate if people that have more nodes in their setups let me know.

Applied, thanks Pablo.
