From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Tue, 19 Jun 2007 15:33:51 +0200
Message-ID: <4677DB3F.8010901@trash.net>
References: <466D8EEB.9080601@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466D8EEB.9080601@netfilter.org>
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
> [CTNETLINK] add TCP protocol state event groups
> 
> This patch adds per-protocol state event groups, so one can only listen to a 
> certain TCP state change such as ESTABLISHED. Although such per-state message
> filtering could be done in userspace, we save CPU cycles since the kernel does
> not need to build and delivery messages that will be later discarded in 
> userspace. This patch is particularly useful for conntrackd.


I can see that this is useful, but one group per protocol state
sounds rather excessive, I would expect that we could group them
more logically, maybe "connection setup, teardown and updates"?
Which states is conntrackd particulary interested in?

I would also like to hear from Holger whether his conntrack daemon
could make use of a mechnism like this too and if the filtering
capabilities you propose will do.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> --- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:31:08.000000000 +0200
> +++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-06-11 02:38:00.000000000 +0200

> @@ -317,7 +331,8 @@ static int ctnetlink_conntrack_event(str
>  	struct sk_buff *skb;
>  	unsigned int type;
>  	sk_buff_data_t b;
> -	unsigned int flags = 0, group;
> +	unsigned int flags = 0, group, proto_group;
> +	bool proto_group_has_listener = false;
>  
>  	/* ignore our fake conntrack entry */
>  	if (ct == &nf_conntrack_untracked)
> @@ -336,7 +351,11 @@ static int ctnetlink_conntrack_event(str
>  	} else
>  		return NOTIFY_DONE;
>  
> -	if (!nfnetlink_has_listeners(group))
> +	proto_group = proto_event_group(ct);
> +	if (proto_group != NFNLGRP_NONE && nfnetlink_has_listeners(proto_group))
> +		proto_group_has_listener = true;
> +
> +	if (!proto_group_has_listener && !nfnetlink_has_listeners(group))
>  		return NOTIFY_DONE;
>  
>  	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
> @@ -396,7 +415,11 @@ static int ctnetlink_conntrack_event(str
>  	}
>  
>  	nlh->nlmsg_len = skb->tail - b;
> +	if (proto_group_has_listener)
> +		atomic_inc(&skb->users);
>  	nfnetlink_send(skb, 0, group, 0);


This will always send to the main group even if only the proto group
has listeners.
