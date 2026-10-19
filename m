Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4233557D;
	Mon, 19 Oct 2026 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372885; cv=none; b=bdj4hpu90noin+llbboy31H4fvBRgJf2O8+mnu5lKyq0qnfAqaKMge8hCxRzKo+wiFcU7WrLjhWSBKlg6gTxdZiTn+cjlsV0bC+jWdeNLXUVc9b6CMTmuwAdZs+OHSSC79xj3LjzAGK7puxs4e4XC7tsWihJhyvnUCtbFqGZ5PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372885; c=relaxed/simple;
	bh=eVZ+iql+gsOlBxmELoHNgdtduHWmAFUG1Wt4n37qk7g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AE7GhHJOm5aPdrDWgRg2vRcyQia9wsECKacO6zKosxQ0xAv/jXJ7ADQt0HJ3Gb10hpvbSAdQ044d7pbGmHpDMeC2yL0Ji7bHEcPMNc3ki8VUOeuhLcB1iCDTGMBVcsU+ChGdOFCeaJm5HbRh+V3sms/9n7rNaO32XDjr+CCZKw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1/ixAI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1/ixAI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B801F000C4;
	Mon, 19 Oct 2026 01:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372883;
	bh=hDxg0TY4g38UCWnPfPaGedDVsYLal8DfB1HAeRKEDt4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=H1/ixAI8r7sBPEdS1XOcBUaQVty4koJ37Tvb0ZlmcSg4viDESHDPyBs8nrCJdLzgF
	 +5rPDNrVVQjsaDBD6ZQUbDzLjbpjcxkmZMH5Gj/YiC3q7KR5BLw8A8OyAT4DerAtNs
	 QnhHJKIp2F5q2HDrnzT96fLEV6nXDZ1qJfRYcGPCFvbVkPqi+MOmQUU28lwAYM8dbm
	 74cuBpBmYiA3ZVrsmgxHFvl5txuvXSMA/AAo6B7HweOrxbZ0iw7Zd7hDSUlousbT6K
	 2uR9wBS5uyqzlXzDbwQHDhL+V8/ARjUuG0yh6xuBPaA/cSKtSsblllKCwo8CmP+Y8T
	 2YQ3RAuH2b/kg==
Subject: Re: [PATCH net-next 04/15] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:22 +0000
Message-ID: <179237288267.3135.9555179349652175002@kernel.org>
In-Reply-To: <20261018005638.1776148-5-pablo@netfilter.org>
References: <20261018005638.1776148-5-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Use-after-free of module code: after this patch, `rmmod
  br_netfilter` no longer drops queued packets that point into…
- [Medium] Conntrack module unload can now stall on queued packets, and
  the commit message does not mention it.
- [Low] The commit message has no Fixes: tag.

--

netfilter: nf_queue: limit the hook drop flush to the unregistered hook point

This patch passes the nf_hook_ops being unregistered down to the nfqueue
handler. It adds nf_hook_cmp() so that nfqnl_nf_hook_drop() only flushes
queued entries whose state.pf/state.hook match the hook point of the
removed hook. Callers that pass NULL (nf_ct_iterate_destroy() and
__nft_ct_set_destroy()) still flush every entry.

Link: https://lore.kernel.org/netfilter-devel/CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com/

> Before commit 039b40ee5854 ("netfilter: nf_queue: only call
> synchronize_net twice if nf_queue is active") nf_queue_nf_hook_drop()
> received the removed hook and nfqueue only dropped the entries queued by
> that hook.

[ ... ]

> Suggested-by: Florian Westphal <fw@strlen.de>
> Link: https://lore.kernel.org/netfilter-devel/CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Antonio Ojea <aojea@google.com>

[Severity: Low]
Should this have a Fixes: tag?

The commit message describes a user-visible problem: deleting an unrelated
base chain drops queued packets, and the next verdict fails with -ENOENT.
It also names 039b40ee5854 as the commit that removed the per-hook
comparison.

Without the trailer, stable maintainers may miss this fix. The message
also does not say the omission is deliberate.

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 477fc632657f4..90d887546f7db 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1566,9 +1566,39 @@ static struct notifier_block nfqnl_dev_notifier = {

[ ... ]

> +static int nf_hook_cmp(struct nf_queue_entry *entry, unsigned long ops_ptr)
> +{
> +	const struct nf_hook_ops *ops = (const struct nf_hook_ops *)ops_ptr;
> +	unsigned int hooknum = ops->hooknum;
> +	u8 pf = ops->pf;
> +
> +	/* same translation as nf_static_key_inc() */
> +	if (pf == NFPROTO_INET && hooknum == NF_INET_INGRESS) {
> +		pf = NFPROTO_NETDEV;
> +		hooknum = NF_NETDEV_INGRESS;
> +	}
> +
> +	if (entry->state.hook != hooknum)
> +		return 0;
> +
> +	if (pf == NFPROTO_INET)
> +		return entry->state.pf == NFPROTO_IPV4 ||
> +		       entry->state.pf == NFPROTO_IPV6;
> +
> +	return entry->state.pf == pf;
> +}

[Severity: High]
After this change, can packets whose okfn points into br_netfilter.ko stay
queued after that module is unloaded?

br_netfilter calls NF_HOOK() at hook points where it registers no hook of
its own, and passes its own functions as okfn:

net/bridge/br_netfilter_hooks.c:br_nf_forward() {
    ...
	NF_HOOK(pf, NF_INET_FORWARD, state->net, NULL, skb,
		brnf_get_logical_dev(skb, state->in, state->net),
		parent,	br_nf_forward_finish);
    ...
}

br_nf_forward_arp() does the same at NFPROTO_ARP/NF_ARP_FORWARD.
br_nf_post_routing() does it at NF_INET_POST_ROUTING with
br_nf_dev_queue_xmit.

br_nf_ops only has the NFPROTO_BRIDGE hooks and the IPv4/IPv6
NF_INET_PRE_ROUTING hooks. On rmmod br_netfilter the teardown is:

br_netfilter_fini()
  unregister_pernet_subsys()
    brnf_exit_net()
      nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops))
        __nf_unregister_net_hook()
          nf_queue_nf_hook_drop(net, reg)
            nfqnl_nf_hook_drop()
              nf_hook_cmp()

Suppose a bridged packet is queued by an ip/ip6 FORWARD or POSTROUTING
NFQUEUE rule, or an arp FORWARD rule. nf_hook_cmp() then returns 0 for
every hook in br_nf_ops.

For example, the NFPROTO_BRIDGE NF_BR_FORWARD hook has the same hooknum as
NF_INET_FORWARD, but entry->state.pf is NFPROTO_IPV4 rather than
NFPROTO_BRIDGE.

Before this patch, each unregistration flushed every entry in the netns.
That flush is what removed these packets, since queue entries take no
module reference.

When userspace later sends NF_ACCEPT, the IPv4 FORWARD hook array has not
changed. hook_index is still valid, so nf_reinject() reaches:

	entry->state.okfn(entry->state.net, entry->state.sk, skb);

okfn is br_nf_forward_finish(), which is in the freed module text.

Is a flush-all, such as nf_queue_nf_hook_drop(net, NULL), needed in the
br_netfilter exit path, or some other flush at module teardown for callers
whose okfn is module code?

> +
> +static void nfqnl_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops)
>  {
>  	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
> +	nfqnl_cmpfn cmpfn = NULL;
>  	int i;
>  
>  	/* This function is also called on net namespace error unwind,
> @@ -1581,12 +1611,19 @@ static void nfqnl_nf_hook_drop(struct net *net)
>  	if (!q)
>  		return;
>  
> +	/* ops is NULL when the caller is not unregistering a hook but
> +	 * removing an object queued packets may reference, every entry
> +	 * has to go
> +	 */
> +	if (ops)
> +		cmpfn = nf_hook_cmp;
> +
>  	for (i = 0; i < INSTANCE_BUCKETS; i++) {
>  		struct nfqnl_instance *inst;
>  		struct hlist_head *head = &q->instance_table[i];
>  
>  		hlist_for_each_entry_rcu(inst, head, hlist)
> -			nfqnl_flush(inst, NULL, 0);
> +			nfqnl_flush(inst, cmpfn, (unsigned long)ops);

[Severity: Medium]
Could rmmod nf_conntrack now block while userspace holds verdicts for
queued packets?

When the last conntrack user goes away, nf_ct_netns_do_put() unregisters
ipv4_conntrack_ops/ipv6_conntrack_ops. Those hooks are only at
PRE_ROUTING, LOCAL_IN, LOCAL_OUT and POST_ROUTING.

Before this patch, that unregistration flushed every queued entry. This
released the nf_conn references held through skb->_nfct.

With the filtered flush, packets queued at NF_INET_FORWARD stay queued, for
example from iptables -A FORWARD -j NFQUEUE or an nft forward queue rule.
Their conntracks keep cnet->count above zero.

nf_conntrack_standalone_fini() only calls nf_conntrack_cleanup_start() and
unregister_pernet_subsys(&nf_conntrack_net_ops). It never calls
nf_queue_nf_hook_drop(net, NULL). nf_conntrack_cleanup_net_list() then
keeps looping:

i_see_dead_people:
	busy = 0;
	list_for_each_entry(net, net_exit_list, exit_list) {
		...
		if (atomic_read(&cnet->count) != 0)
			busy = 1;
	}
	if (busy) {
		DEBUG_NET_WARN_ONCE(time_after(jiffies, start + 60 * HZ),
				    "conntrack cleanup blocked for 60s");
		schedule();
		goto i_see_dead_people;
	}

This runs while pernet_ops_rwsem is held for write. Netns creation and
teardown would stall until a verdict is sent or the queue socket is
closed.

The commit message says nf_ct_iterate_destroy() keeps the NULL flush on
module exit. That path covers helpers and NAT, not nf_conntrack itself,
and the message does not mention this case.

Should nf_conntrack's exit path also flush with NULL?

>  	}
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
