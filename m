From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Tue, 19 Jun 2007 16:44:59 +0200
Message-ID: <4677EBEB.9010905@trash.net>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4677E47F.7010004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4677E47F.7010004@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>>This patch adds per-protocol state event groups, so one can only listen to a 
>>>certain TCP state change such as ESTABLISHED. Although such per-state message
>>>filtering could be done in userspace, we save CPU cycles since the kernel does
>>>not need to build and delivery messages that will be later discarded in 
>>>userspace. This patch is particularly useful for conntrackd.
>>
>>I can see that this is useful, but one group per protocol state
>>sounds rather excessive, I would expect that we could group them
>>more logically, maybe "connection setup, teardown and updates"?
>>Which states is conntrackd particulary interested in?
> 
> 
> Well, why just save a couple of groups if we've got 2^32 event groups?
> Moreover, per protocol state seems to me the most fine-grain and
> flexible solution. Depending on the replication schema I might be
> interested in different states.


Its not only about saving groups. A scheme like this only makes
sense if you introduce groups for every tiny bit, otherwise you
need to subscribe to the "global" group anyway to get the remaining
"unclassified" events you're interested in. And that not only uses
a lot of groups, it also requires dispatching the same event to
potentially many groups. I'm interested, do you already use this
feature in conntrackd? If yes, how do you deal with UDP etc. that
you didn't introduce new groups for?

>>I would also like to hear from Holger whether his conntrack daemon
>>could make use of a mechnism like this too and if the filtering
>>capabilities you propose will do.
> 
> 
> I'm sure he will benefit of it. Currently there are two main CPU cycle
> consumers: event delivery and network transmission, and it is linked to
> the number of messages generated. Not surprisingly, if we reduce the
> number of messages generated, we reduce CPU consumption. Sysadmins may
> enable this tradeoff. BTW, where's Holger's code? :)


I believe we're going to see it at the workshop.

> I have a paper here on conntrackd that I can't release yet. Would you be
> interested in reviewing it? In return, you'll see all the work that I've
> currently done. Do you have some minor spare cycle in your busy agenda? :)


I can try :)

> 
> 
>>>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>>
>>>--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:31:08.000000000 +0200
>>>+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:38:00.000000000 +0200
>>
>>>@@ -317,7 +331,8 @@ static int ctnetlink_conntrack_event(str
>>> 	struct sk_buff *skb;
>>> 	unsigned int type;
>>> 	sk_buff_data_t b;
>>>-	unsigned int flags = 0, group;
>>>+	unsigned int flags = 0, group, proto_group;
>>>+	bool proto_group_has_listener = false;
>>> 
>>> 	/* ignore our fake conntrack entry */
>>> 	if (ct == &nf_conntrack_untracked)
>>>@@ -336,7 +351,11 @@ static int ctnetlink_conntrack_event(str
>>> 	} else
>>> 		return NOTIFY_DONE;
>>> 
>>>-	if (!nfnetlink_has_listeners(group))
>>>+	proto_group = proto_event_group(ct);
>>>+	if (proto_group != NFNLGRP_NONE && nfnetlink_has_listeners(proto_group))
>>>+		proto_group_has_listener = true;
>>>+
>>>+	if (!proto_group_has_listener && !nfnetlink_has_listeners(group))
>>> 		return NOTIFY_DONE;
>>> 
>>> 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
>>>@@ -396,7 +415,11 @@ static int ctnetlink_conntrack_event(str
>>> 	}
>>> 
>>> 	nlh->nlmsg_len = skb->tail - b;
>>>+	if (proto_group_has_listener)
>>>+		atomic_inc(&skb->users);
>>> 	nfnetlink_send(skb, 0, group, 0);
>>
>>This will always send to the main group even if only the proto group
>>has listeners.
> 
> 
> I can improve that. Anyway, AFAIK the main cost here is the message
> allocation and setup. Since we have already do it for the protocol
> group, netlink will just notice itself that there's no listeners for
> that event just a bit later.


There's more overhead, before af_netlink notices that no listeners
are present it will reallocate and trim the skb. This should be
avoided anyway by using a better fitting allocation size though.
