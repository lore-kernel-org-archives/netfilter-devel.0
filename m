Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003E2F6920;
	Fri, 18 Sep 2026 02:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697057; cv=none; b=e29XVEMvH4cTSAAgnwVT2I0CaF2Y9g7n7TfVXg+iaSKz+QYaMTsfdlJQssRYj3AubrhZlCiTgO9NgcVQk1rH2ne8rKzKcnuM6hCpJdO9ak/veEfN23V1njHfj5uDUV9XZznPFZxfSI/ccPUagaW3EbO0UVjbV9hfVYCvlCp38Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697057; c=relaxed/simple;
	bh=BSaMaj9ThBC4ebL0Qas/kMRfN7b4mliUAF5mS2mWi/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ob2q1RIFUNEsgcw4Onr5OzXZlnctaUJjbJYdXsPOUy+iM7rMwfTKp/MQnpgaW7KwnKvKNTAx6j6msc/JWSewcGhQAWVjkQMXg65CKKcbZcIOtv2cSa/86D/+LTjtvy6sGKGPNHgWpUOfEftgQpCc7ddyZooeH7pXBt8o+vmeNtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOCmXdZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOCmXdZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC711F00893;
	Fri, 18 Sep 2026 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789697050;
	bh=M217qkgdd1STms7C0pMa3ofp24XB/0WG5bbZ8Mdp2TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOCmXdZh4kK3UgMsNa0tAyZHOVtHu7KbrigzowrpDE/JD9Ka4MvSUVROQqy0dtoLP
	 gFCOmhtyiQ/POjhOZSfFA+7IDJonnsrDyGxLFzOYKal7MSTkQXMO++3mkXdW9T9XLC
	 i/l8OpRLhHxddmVF/0OMEk/6ZIEnOziF/cA8Zj75BckcNxpBAqrrWVq/O/CclVdXiQ
	 WpudmvmDmaNQx6m7jllK9NKL/2v43KRf/NpQQBw8ncyZW+AociWSuirA3gNnUXBUEK
	 sxjdqwfmliP6htIYVum+t/Vx0UJJZtBLWwHYOwwXuKlv/3Hs16Ol7Ft9mGZGqBVsTB
	 VbnBtpI6kW+xQ==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 02/10] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
Date: Thu, 17 Sep 2026 19:04:08 -0700
Message-ID: <20260918020409.3513342-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231652.127456-3-pablo@netfilter.org>
References: <20260916231652.127456-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

This takes the NFNL_SUBSYS_QUEUE mutex around the instance destroy loop in
nfqnl_rcv_nl_event() so that the NETLINK_URELEASE notifier can no longer run
in parallel with nfqnl_recv_config().  The stale comment in nfqnl_recv_config()
is updated to describe the new serialization.

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index c727668b0c5be..a3bc002800510 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1593,6 +1593,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
>  	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
>  		int i;
>  
> +		nfnl_lock(NFNL_SUBSYS_QUEUE);
>  		/* destroy all instances for this portid */
>  		spin_lock(&q->instances_lock);
>  		for (i = 0; i < INSTANCE_BUCKETS; i++) {

[Severity: Medium]
This is a pre-existing issue, not something introduced here, but does waiting
on the nfnl queue mutex here make it easier to destroy an instance that belongs
to a different socket?

The destroy loop in nfqnl_rcv_nl_event() picks victims by portid only:

	hlist_for_each_entry_safe(inst, t2, head, hlist) {
		if (n->portid == inst->peer_portid)
			__instance_destroy(inst);
	}

and net/netlink/af_netlink.c:netlink_release() makes the portid reusable well
before the notifier runs:

netlink_release()
	netlink_remove(sk);		/* portid is free for reuse here */
	sock_orphan(sk);
	...
	blocking_notifier_call_chain(&netlink_chain,
				     NETLINK_URELEASE, &n);

With the new nfnl_lock(NFNL_SUBSYS_QUEUE), the notifier now blocks for the
whole duration of any NFQNL_MSG_CONFIG handling (including instance_create()
and its sleeping rhashtable_init()), in any netns, since
net/netfilter/nfnetlink.c:nfnl_lock() takes the single global
table[NFNL_SUBSYS_QUEUE].mutex.  So this sequence looks possible:

thread 1: close() of a NETLINK_NETFILTER socket with portid X
	  netlink_remove() releases X, notifier is pending

thread 2: binds portid X, sends NFQNL_CFG_CMD_BIND
	  nfnetlink_rcv_msg() -> nfqnl_recv_config() under the queue mutex
	  instance_create() links a fresh instance with peer_portid == X

thread 1: notifier finally acquires the mutex, matches
	  inst->peer_portid == X and calls __instance_destroy() on the
	  brand new instance

Can the ownership check that the new comment relies on detect this?

	queue = instance_lookup(q, queue_num);
	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {

peer_portid matches in the recycled-portid case, so the check passes and the
instance is still torn down by the older socket's notification.

There is no memory safety problem, the instance is unlinked once and freed via
queue_rcu_work().  The visible effect is that a live socket's queue silently
disappears, its queued packets are flushed, packets hitting the NFQUEUE rule
then fail with -ESRCH (dropped unless fail-open or bypass is set), and later
CONFIG messages for that queue number return -ENODEV.  It requires
CAP_NET_ADMIN in the netns and a concurrent close/bind, and no later commit in
this series touches net/netfilter/nfnetlink_queue.c.

>  			}
>  		}
>  		spin_unlock(&q->instances_lock);
> +		nfnl_unlock(NFNL_SUBSYS_QUEUE);
>  	}
>  	return NOTIFY_DONE;
>  }
> @@ -1925,9 +1927,9 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
>  
>  	/* Lookup queue under RCU. After peer_portid check (or for new queue
>  	 * in BIND case), the queue is owned by the socket sending this message.
> -	 * A socket cannot simultaneously send a message and close, so while
> -	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
> -	 * socket close) cannot destroy this queue. Safe to use without RCU.
> +	 * nfqnl_rcv_nl_event() will block on the nfnl subsys mutex that is
> +	 * held by the caller, so the queue cannot be destroyed in parallel,
> +	 * even after we drop the RCU read lock.
>  	 */

[ ... ]
