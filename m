From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: iptables: fix use of cluster match with
 32	nodes
Date: Fri, 24 Apr 2009 17:02:43 +0200
Message-ID: <49F1D493.5000305@trash.net>
References: <20090424102534.30250.37215.stgit@Decadence> <20090424103031.30250.30352.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZDXPCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:02:50 -0400
In-Reply-To: <20090424103031.30250.30352.stgit@Decadence>
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
> (1 << 32) is 1. Thus, the checking fails. This patch skips the case
> in which total_nodes is 32 and it adds an extra validation to ensure
> that we don't go over 32 nodes.
> 
> BTW, I said this before but I insist: I have only tested the cluster
> match with 2 nodes getting ~45% extra performance in an active-active setup.
> The maximum limit of 32 nodes is still completely arbitrary. I'd really
> appreciate if people that have more nodes in their setups let me know.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks good, but I think we can simpify it a bit further:

> diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
> index 6c48476..04af29e 100644
> --- a/net/netfilter/xt_cluster.c
> +++ b/net/netfilter/xt_cluster.c
> @@ -135,7 +135,13 @@ static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
>  {
>  	struct xt_cluster_match_info *info = par->matchinfo;
>  
> -	if (info->node_mask >= (1 << info->total_nodes)) {

This could either use 1ULL << info->total_nodes to make sure
we don't have an undefined operation, or

> +	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
> +		printk(KERN_ERR "xt_cluster: too many total nodes (%u > %u)\n",
> +				info->total_nodes, XT_CLUSTER_NODES_MAX);
> +		return false;
> +	}
> +	if (info->total_nodes < XT_CLUSTER_NODES_MAX &&
> +	    info->node_mask >= (1 << info->total_nodes)) {

we could alternatively use fls.

>  		printk(KERN_ERR "xt_cluster: this node mask cannot be "
>  				"higher than the total number of nodes\n");
>  		return false;
> 

Let me know what you think, either way is fine with me.
