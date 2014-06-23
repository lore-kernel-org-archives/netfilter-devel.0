From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH libnetfilter_conntrack] add userspace dump filter
Date: Mon, 23 Jun 2014 20:33:12 +0200
Message-ID: <20140623183312.GA16930@localhost>
References: <20140617123718.GC24712@gmail.com>
 <20140618085936.GA3923@localhost>
 <20140623102650.GD29052@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaFWSd2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:33:28 -0400
Content-Disposition: inline
In-Reply-To: <20140623102650.GD29052@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 23, 2014 at 07:26:50PM +0900, Ken-ichirou MATSUZAWA wrote:
> 2014-06-18 17:59 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Tue, Jun 17, 2014 at 09:37:18PM +0900, Ken-ichirou MATSUZAWA wrote:
> > Please, if you work on this, first send us a patch to generalize the
> > filtering "framework" for ctnetlink dumps and then add the filtering
> > by zone.
>  
> How about using sk_filter? I could have understood it's not efficient
> than the way you told me but BPF seems more versatile and can work
> on the socket which both dumping and listening event.

The main reason for bpf in the event path was ENOBUFS. You can overrun
the socket buffer easily with a high rate of events coming from
interrupt context.

In the dump path, we have quite a lot more bandwidth since everything
is running from user context and the table is dumped in chunks of one
memory page. The motivation for the filtering was to reduce the time
to dump large table.

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index f77024d..189f19d 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -831,10 +831,26 @@ restart:
>  					    cb->nlh->nlmsg_seq,
>  					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
>  					    ct);
> -			rcu_read_unlock();
> -			if (res < 0) {
> +			if (res >= 0) {
> +				struct sk_filter *skfilter
> +					= rcu_dereference(skb->sk->sk_filter);
> +				int ret = 0;
> +
> +				if (skfilter != NULL) {
> +					skb_pull(skb, cb->args[2]);
> +					ret = SK_RUN_FILTER(skfilter, skb);
> +					skb_push(skb, cb->args[2]);
> +					if (ret)
> +						cb->args[2] = res;
> +					else
> +						skb_trim(skb, cb->args[2]);
> +				}


> +				rcu_read_unlock();
> +			} else {
> +				rcu_read_unlock();
>  				nf_conntrack_get(&ct->ct_general);
>  				cb->args[1] = (unsigned long)ct;
> +				cb->args[2] = 0;
>  				spin_unlock(lockp);
>  				goto out;
>  			}
> -- 
> 1.7.10.4
> 
