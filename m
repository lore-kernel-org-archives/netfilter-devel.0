From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 24 Feb 2009 15:06:26 +0100
Message-ID: <49A3FEE2.3000601@trash.net>
References: <20090223101354.7104.45999.stgit@Decadence> <49A3FA4B.5000107@trash.net> <49A3FE90.50305@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33053 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZBXOGa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:06:30 -0500
In-Reply-To: <49A3FE90.50305@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> +enum xt_cluster_flags {
>>> +    XT_CLUSTER_F_INV    = (1 << 0)
>>> +};
>>> +
>>> +struct xt_cluster_match_info {
>>> +    u_int32_t        total_nodes;
>>> +    u_int32_t        node_mask;
>>> +    u_int32_t        hash_seed;
>>> +    u_int32_t        flags;
>>> +};
>>
>> This doesn't seem like such a hot idea. I haven't seen the new
>> userspace patch, but assuming you're interested in the flags and
>> not ignoring them in userspace, the user has to specify the hash
>> seed for rule deletions.
> 
> The user has to specify the hash seed to delete the rule if it's 
> non-zero, otherwise it must be specified. The hash seed is optional. I 
> don't quite see the problem.

Its a parameter without a meaning, the user is needlessly bothered
with this.

>> You also have to chose the same seed for all nodes in a cluster.
>> This seems needlessly complicated, I'd suggest to simply use zero.
> 
> One may want to forge traffic to flood a single node? The hash seed 
> avoids this.

No, it only makes it easier to shut off since I have to use the same
source address to be sure I hit the same node. This seems like a valid
argument though.

The fact that you have to specify it for deletion still seems unnecesary
though. You would never have two rules differing only in the seed value
since that would mean the node is part of two clusters. So we might as
well move it to the end and ignore it in userspace. What do you think?
In case you agree, I also think "secret" would be a more fitting name.
