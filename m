From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Sat, 14 Feb 2009 23:31:33 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902142328170.647@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence> <alpine.LSU.2.00.0902142112590.28575@fbirervta.pbzchgretzou.qr> <49972CBF.3040503@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36357 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZBNWbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:31:35 -0500
In-Reply-To: <49972CBF.3040503@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-14 21:42, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Saturday 2009-02-14 20:29, Pablo Neira Ayuso wrote:
>> 
>>> This patch adds the iptables cluster match. This match can be used
>>> to deploy gateway and back-end load-sharing clusters.
>> 
>> All of this nice text (below) should go into libxt_cluster.man :)
>
>Indeed, that will go into the manpage. I have kept the iptables part
>until you finish with Jamal's libxtables renaming, to avoid any
>clashing.

We are done and ready for release as I understood.

>>> * This match mangles the skbuff pkt_type in case that it detects
>>> PACKET_MULTICAST for a non-multicast address. This may be done in
>>> a PKTTYPE target for this sole purpose.
>>> * This match supersedes the CLUSTERIP target.
>> 
>> The supersedes statement should also go into Kconfig.
>
>Yes, but I was also waiting for Patrick to tell how to proceed with
>this. I think that we also have to add CLUSTERIP to the
>schedule-for-removal list.

We do not have to (there is still xt_state and no mention of
deprecation despite xt_conntrack superseding it) - but it would
be a most logical step indeed.

>>> +	unsigned long		node_mask;
>> 
>You mentioned cpumask_t last time, but this is neither related to NUMA
>nor a CPU mask, so I prefer to keep using a long for this thing,
>moreover test and set bit operations use long.
>
>> /**
>>  * @node_mask:	cluster node mask
>>  */

Hence the need for a comment so that this misunderstanding
is resolved early.
