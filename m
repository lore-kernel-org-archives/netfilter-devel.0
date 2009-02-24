From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 24 Feb 2009 15:05:04 +0100
Message-ID: <49A3FE90.50305@netfilter.org>
References: <20090223101354.7104.45999.stgit@Decadence> <49A3FA4B.5000107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47848 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754230AbZBXNzd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:55:33 -0500
In-Reply-To: <49A3FA4B.5000107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> +enum xt_cluster_flags {
>> +    XT_CLUSTER_F_INV    = (1 << 0)
>> +};
>> +
>> +struct xt_cluster_match_info {
>> +    u_int32_t        total_nodes;
>> +    u_int32_t        node_mask;
>> +    u_int32_t        hash_seed;
>> +    u_int32_t        flags;
>> +};
> 
> This doesn't seem like such a hot idea. I haven't seen the new
> userspace patch, but assuming you're interested in the flags and
> not ignoring them in userspace, the user has to specify the hash
> seed for rule deletions.

The user has to specify the hash seed to delete the rule if it's 
non-zero, otherwise it must be specified. The hash seed is optional. I 
don't quite see the problem.

> You also have to chose the same seed for all nodes in a cluster.
> This seems needlessly complicated, I'd suggest to simply use zero.

One may want to forge traffic to flood a single node? The hash seed 
avoids this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
