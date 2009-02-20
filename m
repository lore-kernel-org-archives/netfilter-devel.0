From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Fri, 20 Feb 2009 14:15:24 +0100
Message-ID: <499EACEC.60702@netfilter.org>
References: <20090219231439.6164.354.stgit@Decadence> <499E76DA.7010802@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46985 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752095AbZBTNGf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:06:35 -0500
In-Reply-To: <499E76DA.7010802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> +    ct = nf_ct_get(skb, &ctinfo);
>> +    if (ct == NULL)
>> +        return false;
>> +
>> +    if (ct == &nf_conntrack_untracked)
>> +        return false;
>> +
>> +    if (ct->master)
>> +        hash = xt_cluster_hash(ct->master, info);
>> +    else
>> +        hash = xt_cluster_hash(ct, info);
> 
> This makes a lot of sense for helpers like SIP, where the expectation
> can arrive from a different source address. I'm just wondering how
> this works when not using reliable synchronization - in that case, other
> nodes might not be aware of the expectation and also accept the packet.
> I don't have a suggestion besides making sure expectations are
> synchronized, just thought I'd point it out.

Indeed.

This sort of problem is interesting, just in case that you have some 
spare time to think about other synchronization-related problems 
(otherwise you can skip the following below :)). Conntrackd does not 
synchronize expectations (at least, it's not in my plans yet), it 
synchronizes conntrack entries, and that includes the relationship 
between master and related conntracks. Thus, after the failover, the new 
primary node knows that the master connection has a helper (so it can 
create new expectations) and already existing established-related 
connections are linked to the master conntracks.

Still I see two possible problematic situations with these approach:

  * If expectations are not propagated, this means than a FTP-data 
connections that is about to start would not success if that connection 
happens during a failover as the expectation information is lost.

  * If the state information is lost for whatever reason (like not using 
conntrackd at all or losing the state information due to netlink 
unreliability), then the former expected connection would be handled 
like a normal connection by one cluster node. For example, this would 
break if destination nat is used in the case of FTP (and similarly for 
other helpers I think).

For the first problem, I can say that conntrackd can be tuned to reduce 
the chances of this to happen (at the cost of investing more resources 
in the synchronization). Moreover, connections that are about to start 
may retry in short and no data was exchanged indeed.

For the second problem, this is actually the sort of problems that I 
want to avoid making netlink reliable by dropping packets. By reducing 
the chances to lose state information for whatever reason.

>> +static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
>> +{
>> +    struct xt_cluster_match_info *info = par->matchinfo;
>> +
>> +    if (info->node_mask > (1 << info->total_nodes)) {
>> +        printk(KERN_ERR "xt_cluster: the id of this node cannot be "
>> +                "higher than the total number of nodes\n");
> 
> This looks like an off-by-one (warning: still at first coffee :)).
> It may also not be equal to the mask I'd expect. I can change it
> to >= when applying if you agree.

You're right! Please change it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

