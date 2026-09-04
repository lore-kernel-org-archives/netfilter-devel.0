Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA1377550;
	Fri,  4 Sep 2026 02:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487317; cv=none; b=aql6nenZx1cLfR1yPL2gxy5CUa+827zoxm1HFkn+WOI3SxcSmmP27+WTDmkORqw0A4ip7BJCpJpYvBdVhDlnRPZsf+0woegbygQJBLXkWYgGeILSVmLx8IAF9WsxBumwjJKiYWXbb/50kTjQr7l8BM6N5MlaYmDAwwERZEwWmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487317; c=relaxed/simple;
	bh=+nibOcGODcN0zKOlivj33cq2XgQew6fQgDTGQvTiMuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueqnXG3mKTqlPHM9j2dqhvM7uiUyEprZ+RDZt8MSGdhZjG4cfhAoels+gZP7tBd44dI+x8YQVVJl87DNk7uyJ65Y9iJMAUIgXPneC4ZsENTvGVEVMWI8NM6dT1eN0caDDtRnivQHDJwqTuWcwGTk6nOBE2APuy+eySyexfxpniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0tSiANP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0tSiANP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5541F000E9;
	Fri,  4 Sep 2026 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487314;
	bh=t8PQ61q8kKSnvaTKEuI+RYzHNnqTXi8DAxuZw98HUAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0tSiANPOa7d2t+1xBTqZHs4n1+1pkIXQf0hDV5ayOTdeuJh5hn4ych6+YBpvBxtI
	 gXnPSvgvE0B7vgO8KItuzFSS0xe6Uak9/SPOL3Ps2HGApuV3Quh9maM6FBzN+e1kDg
	 1MQf9zsatfVvhdANuVTj6uHlgGPDlq3bZkHxZc8TRNXt77pfn5LlQL0nUHAZIWnqrJ
	 JjMYT/RjXuafd2CZkwMcTq+0QMDiDbUM1isNdZGmKriVyhel68/BAGfPuOZqdhS4my
	 WXW9KF+a+VUd5H3m8tVWnfVwWpnpg89XuuKfPG+9cconf1xXVgMW+ATAc8PfGc5vOz
	 OHZfAGpv/jrdw==
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
Subject: Re: [PATCH net 09/12] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
Date: Thu,  3 Sep 2026 19:01:49 -0700
Message-ID: <20260904020149.3549947-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903004149.1037028-10-pablo@netfilter.org>
References: <20260903004149.1037028-10-pablo@netfilter.org>
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

The NETLINK_URELEASE notifier now takes the NFNL_SUBSYS_QUEUE mutex around
the instance teardown loop, so it can no longer run concurrently with
nfqnl_recv_config().  The comment in nfqnl_recv_config() is updated to
explain that the notifier blocks on the subsystem mutex held by the caller.

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index c727668b0c5b..a3bc00280051 100644
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
The new mutex gives mutual exclusion, but does it give any ordering
against the socket unhash?  In netlink_release() the socket is removed
from the hash table before the notifier chain is invoked:

net/netlink/af_netlink.c:netlink_release() {
	...
	netlink_remove(sk);
	sock_orphan(sk);
	...
	if (nlk->portid && nlk->bound) {
		struct netlink_notify n = {
			...
			.portid = nlk->portid,
		};
		blocking_notifier_call_chain(&netlink_chain,
					     NETLINK_URELEASE, &n);
	}
}

Once netlink_remove(sk) has run, the portid is free for anyone else to
claim:

net/netlink/af_netlink.c:netlink_bind() {
	...
	err = nladdr->nl_pid ?
		netlink_insert(sk, nladdr->nl_pid) :
		netlink_autobind(sock);
}

So the sequence below looks possible:

  thread A: close() -> netlink_remove(sk) unhashes portid P
  thread B: bind(P) succeeds
  thread B: NFQNL_MSG_CONFIG / NFQNL_CFG_CMD_BIND
            -> instance_create(q, queue_num, NETLINK_CB(skb).portid)
               stamps inst->peer_portid = P
  thread A: blocking_notifier_call_chain(NETLINK_URELEASE) finally runs

Since the loop here keys ownership only on the numeric portid:

	hlist_for_each_entry_safe(inst, t2, head, hlist) {
		if (n->portid == inst->peer_portid)
			__instance_destroy(inst);
	}

does thread A's notifier then destroy the instance that thread B just
created?  __instance_destroy() does hlist_del_rcu() plus
queue_rcu_work(), and instance_destroy_work() -> nfqnl_flush() drops all
queued packets, after which thread B's NFQNL_MSG_VERDICT calls fail with
-ENODEV from verdict_instance_lookup(), leaving the NFQUEUE rule to drop
or bypass traffic depending on the queue-bypass setting.

The portid-based ownership test itself predates this patch, but does the
new mutex widen the window rather than narrow it?  Before, the notifier
only contended on q->instances_lock and could easily win the race and
find nothing to destroy.  Now, if the notifier arrives at any point while
the re-binding socket is inside nfqnl_recv_config() holding the QUEUE
mutex (which sleeps in kzalloc_obj(GFP_KERNEL_ACCOUNT) and
rhashtable_init()), the notifier is parked until that CONFIG operation
completes, so it is guaranteed to run after the new instance is linked
and will match it.

Would keying ownership on the socket identity, or refcounting instances
as the commit message notes is currently missing, avoid this rather than
relying on the subsystem mutex?

> @@ -1606,6 +1607,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
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
>  	rcu_read_lock();
>  	queue = instance_lookup(q, queue_num);

This finding was flagged as requiring validation, so please double check
whether the portid reuse window described above is reachable in practice
on your side.
