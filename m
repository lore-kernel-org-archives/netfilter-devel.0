From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Thu, 21 Jun 2007 17:47:43 +0200
Message-ID: <467A9D9F.7070507@netfilter.org>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4677E47F.7010004@netfilter.org> <4677EBEB.9010905@trash.net>
	<4679613B.6040100@netfilter.org> <467966A8.4060405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467966A8.4060405@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>
>>>> Well, why just save a couple of groups if we've got 2^32 event groups?
>>>> Moreover, per protocol state seems to me the most fine-grain and
>>>> flexible solution. Depending on the replication schema I might be
>>>> interested in different states.
>>>
>>> Its not only about saving groups. A scheme like this only makes
>>> sense if you introduce groups for every tiny bit, otherwise you
>>> need to subscribe to the "global" group anyway to get the remaining
>>> "unclassified" events you're interested in. And that not only uses
>>> a lot of groups, it also requires dispatching the same event to
>>> potentially many groups. I'm interested, do you already use this
>>> feature in conntrackd? If yes, how do you deal with UDP etc. that
>>> you didn't introduce new groups for?
> 
> You skipped my question.

Sorry, I'm lazy :-)

>> The patch is incomplete but you can guess the schema. Consider a patch
>> to add the following groups:
>>
>> NFNLGRP_CONNTRACK_PROTO_UDP_NEW,
>> NFNLGRP_CONNTRACK_PROTO_UDP_UPDATE,
>> NFNLGRP_CONNTRACK_PROTO_UDP_DESTROY,
>> NFNLGRP_CONNTRACK_PROTO_ICMP_NEW,
>> NFNLGRP_CONNTRACK_PROTO_ICMP_UPDATE,
>> NFNLGRP_CONNTRACK_PROTO_ICMP_DESTROY,
>> NFNLGRP_CONNTRACK_PROTO_SCTP_...,
>> NFNLGRP_CONNTRACK_PROTO_UNCLASSIFIED_NEW,
>> NFNLGRP_CONNTRACK_PROTO_UNCLASSIFIED_UPDATE,
>> NFNLGRP_CONNTRACK_PROTO_UNCLASSIFIED_DESTROY
>>
>> At a glance I see the function netlink_update_listeners that is O(n),
>> that could be the bottleneck if we have a lot of groups. Still
>> objections with this approach?
> 
> So far I presume conntrackd still listens to the global group. So
> I would like to know how many groups we'll end up with until this
> scheme is really fine-grained enough that it allows conntrackd
> to avoid listening to the global group and what types of events
> it would ignore (so I can understand the performance improvement
> this might yield). The above still only contains protocol specific
> groups.

OK, let me develop the issue a bit more. In my initial experiments, I
used the patch to replicate only TCP connections, so conntrackd was not
listening the global group but just TCP state events. I currently have a
clause that looks like:

Replicate ESTABLISHED TIME_WAIT for TCP

Thus, only established and time_wait states are replicated. My plan is
to add similar clauses for other protocols so:

Replicate ESTABLISHED for STCP
Replicate NEW DESTROY for UDP
Replica NEW DESTROY for UNCLASSIFIED

The sysadmin manually may tune the states that it wants to replicate to
reduce the CPU overhead.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
