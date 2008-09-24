From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 18:01:00 +0200
Message-ID: <48DA643C.5000702@trash.net>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Piotr Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYIXQBC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:01:02 -0400
In-Reply-To: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Piotr Oledzki wrote:
>>From 4407c0b11dde5235b1141ef63bc29f322a73c873 Mon Sep 17 00:00:00 2001
> From: Krzysztof Piotr Oledzki <ole@ans.pl>
> Date: Mon, 21 Jul 2008 17:20:45 +0200
> Subject: netfilter: add locking for counters zeroing
> 
> The memset inside ctnetlink_dump_table() fuction needs locking.
> The lock shoud be grabbed outside the loop to avoid repeatedly
> taking and releasing it again.
> 
> Also add similar locking inside xt_connbytes match where
> the counters get read.

Sorry for the delay. About the patch:

> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 9432da4..ff1bbb0 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>  	u_int8_t l3proto = nfmsg->nfgen_family;
>  
>  	rcu_read_lock();
> +	spin_lock_bh(&nf_conntrack_lock);

We only need the spinlock. I'm not so happy about taking it
unconditionally even though we might not be zeroing the
counters. Moving it in the inner loop will greatly increase
the amount of locks/unlocks on the other hand.

How about moving the inner loop to a new function and adding
back the ctnetlink_dump_counterzero (or whatever it was called)
function? It would take the spinlock, while normal dumping
would only use rcu_read_lock().

