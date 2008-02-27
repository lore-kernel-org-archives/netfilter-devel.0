From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] Implement connection tracking event over netlink unicast
Date: Wed, 27 Feb 2008 01:39:28 +0100
Message-ID: <47C4B140.3020007@netfilter.org>
References: <47BF22E2.1010204@netfilter.org> <47C2BC69.4070609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54276 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753062AbYB0Ajj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:39:39 -0500
In-Reply-To: <47C2BC69.4070609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch introduces several important changes:
>>
>> * A new table, so-called 'events', which is placed at the end of
>> postrouting once the connection tracking has successfully confirmed a
>> conntrack entry to avoid event delivery of possibly dropped packets in
>> the 'filter' table. In practise, this table is only loaded as module
>> when the user wants to perform event filtering so that it does not
>> introduce any overhead for users that do not need this feature.
> 
> I hate new tables :) Its a bit sad that we need this, its not exactly
> consistent that NOTRACK works in the raw table and this in the events
> table.

I know however I didn't come up with any better idea :(. BTW, can you
think of any other use of this new table apart from NFCONNTRACK as for now?

> Will there also be a new match to filter on connection state?
> Using ESTABLISHED is pretty useless since in the events table
> all connections will be ESTABLISHED.

Indeed. I plan to do this. I'll add such patch for the next round of
this patchset.

>> * A new target, so-called NFCONNTRACK, which can only be inserted in the
>> events table.
>>
>> * An extra hook which is only present if connection tracking event
>> delivery is enabled.
>>
>> In terms of hooks, the changes are the following:
>>
>>         NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
>>         NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
>>         NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,
>>         NF_IP_PRI_LAST = INT_MAX,
>>
>> The 'events' table is placed after the conntrack confirmation, and the
>> final event delivery through the ecache infrastructure is placed at the
>> end. If we schedule for removal events delivery over netlink broadcast
>> we can get rid of NF_IP_PRI_CONNTRACK_EVENTS hook, however, this would
>> break backward anyway. Another choice to remove this hook can be to
>> recover the idea of the per-skbuff event cache, however, this means 4
>> bytes extra per skbuff.
>>
>> Another argument in favor of this patch is that it homogenize the
>> netfilter subsystem so that they all require a target to enable netlink
>> features.
> 
> I don't think we should remove broadcast event delivery. QUEUE and LOG
> are different from conntrack in the sense that conntrack really does
> react to internal events, which are non-existant for QUEUE and LOG.

Makes sense.

>> Comments welcome.
> 
> A general comment: it would make this easier to review if you'd
> split it up more fine-grained, for example:
> 
> - 1: conntrack event delivery changes
> - 2: conntrack unicast event delivery
> - 3: event table
> - 4: NFCONNTRACK target
> 
> Some implementation-specific comments below:
> 
>>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
>> ...
> 
> This stuff shouldn't depend on conntrack-events in my opinion.
> Conntrack-events should merely control whether the event cache
> and similar stuff is included in nf_conntrack, without which
> the ctnetlink event delivery does not work, but the manual
> unicast delivery should work regardless, right?
> 
> OK I see below that it needs the event cache, still it would
> be nice to have this working without the notifications from
> conntrack.

Hm, but then I don't have a way to know when a conntrack have
significantly changed. I mean, I don't see a way to send only the first
TCP established state to userspace without using the event
notifications. Even if we have an iptables match to match protocol
states, all the packets in TCP established state (one for each PSH
packet) would be send to userspace.

>> +
>> +static HLIST_HEAD(equeue_list);
> 
> Are you sure you don't want a small hash table for this?

Indeed, I plan to use one. BTW, isn't 16 buckets too small for the
nfnetlink_queue hashtable considering worst case? Although I don't think
that it would have such many clients at the same time ever.

>> Index: net-2.6.git/include/linux/netfilter_ipv4.h
>> ===================================================================
>> --- net-2.6.git.orig/include/linux/netfilter_ipv4.h    2008-02-22
>> 18:51:48.000000000 +0100
>> +++ net-2.6.git/include/linux/netfilter_ipv4.h    2008-02-22
>> 18:53:39.000000000 +0100
>> @@ -62,9 +62,11 @@ enum nf_ip_hook_priorities {
>>      NF_IP_PRI_FILTER = 0,
>>      NF_IP_PRI_NAT_SRC = 100,
>>      NF_IP_PRI_SELINUX_LAST = 225,
>> -    NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
>> -    NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
>> -    NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
>> +    NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 4,
>> +    NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 3,
>> +    NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
>> +    NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
>> +    NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,
> 
> Why do you need the CONNTRACK_EVENTS hook exactly?

For nothing if I remove the dependency between the ecache and
NFCONNTRACK but, at the moment, I don't see a clear way how to do that.
I'm even thinking on recovering the idea of the per-skbuff event cache,
however, this would increase every skbuff in 4 bytes which is something
that probably you and Davem won't like.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
