From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Fri, 20 Feb 2009 17:52:01 +0100
Message-ID: <499EDFB1.90308@netfilter.org>
References: <20090219231439.6164.354.stgit@Decadence> <499E76DA.7010802@trash.net> <499EACEC.60702@netfilter.org> <499EB4C8.5090103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43237 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752941AbZBTQwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:52:14 -0500
In-Reply-To: <499EB4C8.5090103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>> For the second problem, this is actually the sort of problems that I
>> want to avoid making netlink reliable by dropping packets. By reducing
>> the chances to lose state information for whatever reason.
> 
> Yes, although the netlink delivery only covers part of it. It might
> be the path where most events are lost though.

Right, to extend this comment, during the failure there can also be some
events pending to be sent in all the existing kernel queues (netlink
queues and device transmission queues) that the daemon did not have time
to propagate during the failure, this is part of the asynchronous
approach. I've been trying to measure this behaviour but I didn't see
any significant amount of lost connections in my testbed, not yet at least.

>>>> +static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
>>>> +{
>>>> +    struct xt_cluster_match_info *info = par->matchinfo;
>>>> +
>>>> +    if (info->node_mask > (1 << info->total_nodes)) {
>>>> +        printk(KERN_ERR "xt_cluster: the id of this node cannot be "
>>>> +                "higher than the total number of nodes\n");
>>>
>>> This looks like an off-by-one (warning: still at first coffee :)).
>>> It may also not be equal to the mask I'd expect. I can change it
>>> to >= when applying if you agree.
>>
>> You're right! Please change it.
> 
> I noticed another problem during compilation:
> 
> net/netfilter/xt_cluster.c: In function 'xt_cluster_mt':
> net/netfilter/xt_cluster.c:124: warning: passing argument 2 of
> 'constant_test_bit' from incompatible pointer type
> net/netfilter/xt_cluster.c:124: warning: passing argument 2 of
> 'variable_test_bit' from incompatible pointer type
> 
> The problem is that is uses a u32 for the mask, but the bitops are
> only defined for unsigned longs. Which is a bit unfortunate since
> they're not well suited for ABI structures. I'd suggest to simply
> open-code the bit tests.

Agreed. The test_bit was a reminiscent of the /proc interface (which
allowed node mask bit setting), so I don't need it. I'm going to resend
you the patch in a couple of minutes (including the off-by-one issue
resolved).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
