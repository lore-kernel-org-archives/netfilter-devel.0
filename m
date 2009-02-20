From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Fri, 20 Feb 2009 10:24:42 +0100
Message-ID: <499E76DA.7010802@trash.net>
References: <20090219231439.6164.354.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44383 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZBTJYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:24:45 -0500
In-Reply-To: <20090219231439.6164.354.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the iptables cluster match. This match can be used
> to deploy gateway and back-end load-sharing clusters. The cluster
> can be composed of 32 nodes maximum (although I have only tested
> this with two nodes, so I cannot tell what is the real scalability
> limit of this solution in terms of cluster nodes).

Thanks Pablo.

> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct == NULL)
> +		return false;
> +
> +	if (ct == &nf_conntrack_untracked)
> +		return false;
> +
> +	if (ct->master)
> +		hash = xt_cluster_hash(ct->master, info);
> +	else
> +		hash = xt_cluster_hash(ct, info);

This makes a lot of sense for helpers like SIP, where the expectation
can arrive from a different source address. I'm just wondering how
this works when not using reliable synchronization - in that case, other
nodes might not be aware of the expectation and also accept the packet.
I don't have a suggestion besides making sure expectations are
synchronized, just thought I'd point it out.

> +static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
> +{
> +	struct xt_cluster_match_info *info = par->matchinfo;
> +
> +	if (info->node_mask > (1 << info->total_nodes)) {
> +		printk(KERN_ERR "xt_cluster: the id of this node cannot be "
> +				"higher than the total number of nodes\n");

This looks like an off-by-one (warning: still at first coffee :)).
It may also not be equal to the mask I'd expect. I can change it
to >= when applying if you agree.
