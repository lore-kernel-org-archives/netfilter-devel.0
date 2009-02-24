From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 24 Feb 2009 14:46:51 +0100
Message-ID: <49A3FA4B.5000107@trash.net>
References: <20090223101354.7104.45999.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZBXNqy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:46:54 -0500
In-Reply-To: <20090223101354.7104.45999.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> +enum xt_cluster_flags {
> +	XT_CLUSTER_F_INV	= (1 << 0)
> +};
> +
> +struct xt_cluster_match_info {
> +	u_int32_t		total_nodes;
> +	u_int32_t		node_mask;
> +	u_int32_t		hash_seed;
> +	u_int32_t		flags;
> +};

This doesn't seem like such a hot idea. I haven't seen the new
userspace patch, but assuming you're interested in the flags and
not ignoring them in userspace, the user has to specify the hash
seed for rule deletions.

You also have to chose the same seed for all nodes in a cluster.
This seems needlessly complicated, I'd suggest to simply use zero.
