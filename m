Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1704C43C076;
	Tue, 29 Sep 2026 03:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653561; cv=none; b=NM06n+szUWcNuG2w4bK+8dayIpNDswWJGm1fIBH+8FPD+bTQhZ4fgA7jfJ4I36Cmk57IJFxYDdVdKrBSgziu79f257hNlIGKR1zV3Fp3lfRIyV49PioAhBEEUSSVIl7GXu4oLl8eTe+aHZSp5qGXOdfvzo8gogjRw+w1BJMdlGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653561; c=relaxed/simple;
	bh=mi6IZ5xPl3AVxu0lfG1ueBw8s2iHNQ/4ffsQGv6A3cI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kpk6PSQjsEfQYzZVyI3x6BrqQ8AD823YPzHLTUDnFkThHCA7w7RNQfxPuCdvBmCH7+2S/5+ex8h8+cRrtnCkuu3J7qqlFtjoF+MVe8fQufilNTh5amfUdAZfCaIEcLv07x4IQVjhTQVCKlXrKpIibaVRPJDM3Nk1F7ybEiGv3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHseI1Ur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHseI1Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D791F0089F;
	Tue, 29 Sep 2026 03:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790653558;
	bh=vszimT7HlU7NlgzQayHk0YBvZa6Achmt2AS0UdLXvP4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aHseI1UrQ72zqWW+Bq1IM5oxyqZol/3lPl/GgxPUjHstZzvdtRlc5XJzUCNtOpFcO
	 /sxiZf5WiwjCapDU4NXW8YF50NP0+hb28IvjOjeKUwXpB2AqkRmXrDPDxYOoWCUL7K
	 0DjNk0dBP7DCIMyTGJ6dB3AZWDSP+lJVicVRxGM772sc+azMEiF3+ChrI0V0uf23rV
	 f5Xc7QXzwctYJiuEwXUHniL+nr3kZjU1YcueYhth/qgwYlx70VbMrY1w3upJUtW2oc
	 EUup4HNjs4pRqksdaIj94fNd2DC0p+Bs9xVp9qXWMkIN+2jjJSJniYsVYPkRGaxZ9W
	 p2prE3B1E4Otw==
Subject:
 Re: [PATCH net v4] net: cap skb->queue_mapping when the tx queue is picked
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 jiri@resnulli.us, vinicius.gomes@intel.com, horms@kernel.org,
 xiangxia.m.yue@gmail.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, victor@mojatatu.com, zdi-disclosures@trendmicro.com,
 hybris@mojatatu.ai, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org, edumazet@google.com
Date: Tue, 29 Sep 2026 03:45:56 +0000
Message-ID: <179065355672.434549.4187901591797286003@kernel.org>
In-Reply-To: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
References: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 (1) · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] skb_at_tc_egress() treats skb->nf_skip_egress &&
  !tc_at_ingress as meaning "inside sch_handle_egress()".
- [Medium] The fix keeps skip_txqueue inside one xmit frame only if every
  nested __dev_queue_xmit() takes the egress_needed_key branch.
- [Low] After this patch, skb->nf_skip_egress also gates tc behaviour:
  skb_at_tc_egress() decides whether tcf_skbedit_act() arms skip_txqueue.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is high
  severity.

--

net: cap skb->queue_mapping when the tx queue is picked

This patch keeps the per-CPU skip_txqueue flag inside the xmit frame that
runs sch_handle_egress(). It saves the flag before the hook and restores
it afterwards. tcf_skbedit_act() may now arm the flag only when
skb_at_tc_egress() reports tc egress. The patch also writes the capped
value back into skb->queue_mapping in netdev_tx_queue_mapping(), and
builds skb->nf_skip_egress under CONFIG_NET_EGRESS.

Link: https://lore.kernel.org/netdev/CANn89iLwYx8nCVf0pCEk_MmEiyC6kQaMwCQT9WkQVeeNzNQHqQ@mail.gmail.com/
Link: https://lore.kernel.org/netdev/179008581937.2160803.7117814290574262942@kernel.org/
Link: https://lore.kernel.org/netdev/179033713973.2160803.4914570693994398206@kernel.org/
Link: https://lore.kernel.org/netdev/20260925180407.63647514@kernel.org/
Link: https://lore.kernel.org/netdev/CANn89i+k-mZKDQVtvws_MEXeuMTAdaCcOXFZE-RfhcGTu90sjA@mail.gmail.com/

[ ... ]

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 84308498a3a8..a3ff380d43f0 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1020,7 +1020,7 @@ struct sk_buff {
>  #ifdef CONFIG_NET_REDIRECT
>  	__u8			from_ingress:1;
>  #endif
> -#ifdef CONFIG_NETFILTER_SKIP_EGRESS
> +#ifdef CONFIG_NET_EGRESS
>  	__u8			nf_skip_egress:1;
>  #endif

[Severity: Low]
This isn't a bug, but skb_at_tc_egress() now reads this bit to gate
tcf_skbedit_act(), and the documentation still describes a flag used only
by netfilter.

The struct sk_buff kernel-doc says:

 *	@nf_skip_egress: packet shall skip nf egress - see netfilter_netdev.h

The comment above nf_hook_egress() in include/linux/netfilter_netdev.h
says:

 * The nf_skip_egress flag controls whether netfilter is applied on egress.
 * It is updated by __netif_receive_skb_core() and __dev_queue_xmit() when the

Neither comment mentions the tc egress meaning. The second one also leaves
out ifb_ri_tasklet() and netkit_prep_forward(), which write the bit too.
The new skb_at_tc_egress() has no comment about reusing this bit or about
the precondition it depends on.

Could these comments be updated along with this change?

>  #ifdef CONFIG_SKB_DECRYPTED
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index f35bd06a6bad..1acaadb3e2cf 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -810,6 +810,15 @@ static inline bool skb_at_tc_ingress(const struct sk_buff *skb)
>  #endif
>  }
>  
> +static inline bool skb_at_tc_egress(const struct sk_buff *skb)
> +{
> +#ifdef CONFIG_NET_EGRESS
> +	return skb->nf_skip_egress && !skb_at_tc_ingress(skb);

[Severity: Medium]
Is nf_skip_egress only ever set around sch_handle_egress()? The commit
message says:

  "the marker is set only around the single sch_handle_egress() call and
  ingress path is guarded by tc_at_ingress"

Some other writers seem to leave the bit set on skbs that later reach
__dev_queue_xmit().

__netif_receive_skb_core() sets the bit before sch_handle_ingress(), but
clears it only on the path where the skb survives:

		nf_skip_egress(skb, true);
		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
					 &another);
		...
		if (!skb)
			goto out;

		nf_skip_egress(skb, false);

An ingress mirred redirect consumes the skb and passes it to
dev_queue_xmit() with the bit still set. A mirror does the same with a
clone, which copies the bit through the headers group.

ifb_ri_tasklet() sets the bit and then calls dev_queue_xmit(). On the
from_ingress path it reinjects the skb with tc_skip_classify set, so
__netif_receive_skb_core() never resets the bit:

		skb->tc_skip_classify = 1;
		...
		nf_skip_egress(skb, true);

netkit_prep_forward() also sets the bit. After that, netkit_xmit() calls
skb_do_redirect(), which can reach dev_queue_xmit().

In __dev_queue_xmit(), tcx_set_ingress(skb, false) always runs. The only
reset of nf_skip_egress is inside the egress_needed_key static branch.

Suppose only an ingress clsact is installed, for example one doing
"mirred egress redirect dev qc". The skb then reaches qc's root qdisc
enqueue with nf_skip_egress=1 and tc_at_ingress=0. A skbedit queue_mapping
action in a prio, multiq or htb classifier passes skb_at_tc_egress() and
calls netdev_xmit_skip_txqueue(true). The v4 changelog says this kind of
arming from a transmit-qdisc classifier no longer happens.

Nothing seems to consume this stale value today. Every reader inside the
static branch saves, clears and restores the flag. The one exception is
the static key race described further down.

There is also a config effect. nf_skip_egress() is now built under
CONFIG_NET_EGRESS instead of CONFIG_NETFILTER_SKIP_EGRESS. With
CONFIG_NET_EGRESS=y and CONFIG_NETFILTER_EGRESS=n, the ingress, ifb and
netkit calls used to compile to nothing. Now they write a bit that
skb_at_tc_egress() reads.

Should the reasoning in the commit message be revisited? Otherwise the
planned rename to skb->skip_egress would carry the same assumption
forward.

> +#else
> +	return false;
> +#endif
> +}

[ ... ]

> diff --git a/net/core/dev.c b/net/core/dev.c
> index f660fccfc0db..8638c994bbcb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4404,9 +4404,14 @@ EXPORT_SYMBOL(dev_loopback_xmit);
>  static struct netdev_queue *
>  netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
>  {
> -	int qm = skb_get_queue_mapping(skb);
> +	int queue = skb_get_queue_mapping(skb);
> +	int capped;
>  
> -	return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
> +	capped = netdev_cap_txqueue(dev, queue);
> +	if (unlikely(capped != queue))
> +		skb_set_queue_mapping(skb, capped);
> +
> +	return netdev_get_tx_queue(dev, capped);
>  }

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. The
commit message leaves it for a separate followup. Can a cls_bpf program on
a transmit qdisc still index past the end of dev->_tx[]?

tc_cls_act_is_valid_access() allows writes to __sk_buff queue_mapping.
bpf_convert_ctx_access() only drops stores of NO_QUEUE_MAPPING or larger:

net/core/filter.c:bpf_convert_ctx_access() {
    ...
			if (BPF_CLASS(si->code) == BPF_ST && si->imm >= NO_QUEUE_MAPPING) {
				*insn++ = BPF_JMP_A(0); /* noop */
				break;
			}

			if (BPF_CLASS(si->code) == BPF_STX)
				*insn++ = BPF_JMP_IMM(BPF_JGE, si->src_reg, NO_QUEUE_MAPPING, 1);
			*insn++ = BPF_EMIT_STORE(BPF_H, si, offset);
    ...
}

The stored value is never compared with dev->num_tx_queues or
real_num_tx_queues. A program attached under a prio or htb root runs
inside q->enqueue(). That is after netdev_core_pick_tx() or
netdev_tx_queue_mapping() has already capped the mapping, so the program
can store any value up to 0xfffe.

On dequeue:

qdisc_restart()
  txq = skb_get_tx_queue(dev, skb)
    netdev_get_tx_queue()
      DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
      return &dev->_tx[index];
  sch_direct_xmit(skb, q, dev, txq, ...)
    HARD_TX_LOCK(dev, txq, cpu)

The gso_skb and skb_bad_txq requeue paths in dequeue_skb() also call
skb_get_tx_queue().

That would take txq->_xmit_lock, write xmit_lock_owner and read txq->state
in memory past the end of the dev->_tx allocation. Loading the program
needs CAP_BPF and CAP_NET_ADMIN, or a delegated BPF token. Even so, the
program has passed the verifier and should not be able to corrupt kernel
memory.

[ ... ]

> @@ -4848,21 +4861,25 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>  	tcx_set_ingress(skb, false);
>  #ifdef CONFIG_NET_EGRESS
>  	if (static_branch_unlikely(&egress_needed_key)) {
> +		bool skip_txq;
> +
>  		if (nf_hook_egress_active()) {
>  			skb = nf_hook_egress(skb, &rc, dev);
>  			if (!skb)
>  				goto out;
>  		}
>  
> -		netdev_xmit_skip_txqueue(false);
> +		skip_txq = netdev_xmit_skip_txqueue(false);
>  
>  		nf_skip_egress(skb, true);
>  		skb = sch_handle_egress(skb, &rc, dev);
> -		if (!skb)
> +		if (!skb) {
> +			netdev_xmit_skip_txqueue(skip_txq);
>  			goto out;
> +		}
>  		nf_skip_egress(skb, false);
>  
> -		if (netdev_xmit_txqueue_skipped())
> +		if (netdev_xmit_skip_txqueue(skip_txq))
>  			txq = netdev_tx_queue_mapping(dev, skb);
>  	}
>  #endif

[Severity: Medium]
Does the flag stay confined to this frame if egress_needed_key is turned
off while an outer frame is inside sch_handle_egress()?

Each nested __dev_queue_xmit() reads the static key again.
net_dec_egress_queue() is a plain static_branch_dec() and does not wait
for RCU-bh readers that are already inside the branch. Consider:

CPU1                                     CPU2
__dev_queue_xmit(qa)
  static key is on
  skip_txq = netdev_xmit_skip_txqueue(false)
  nf_skip_egress(skb, true)
  sch_handle_egress()
                                         clsact_destroy()
                                           net_dec_egress_queue()
                                             static_branch_dec()
    tcf_mirred_forward()
      (mirror clone has nf_skip_egress=1)
      dev_queue_xmit(qc)
        static key is off: no save/restore,
        no nf_skip_egress reset
        q->enqueue() -> prio classifier
          tcf_skbedit_act()
            skb_at_tc_egress() is true
            netdev_xmit_skip_txqueue(true)
  nf_skip_egress(skb, false)
  netdev_xmit_skip_txqueue(skip_txq) returns true
  txq = netdev_tx_queue_mapping(dev, skb)

In this sequence, qa's surviving skb picks its tx queue from its own
queue_mapping, even though it never went through skbedit. For a forwarded
packet that value is the ingress rx_queue + 1.

The capped write-back in netdev_tx_queue_mapping() still prevents the
taprio out-of-bounds access. The result would be a wrong but valid tx
queue, and possibly the ratelimited "selects TX queue" warning.

The commit message says the flag is now owned by the xmit frame the
egress hook runs in. Is this cross-frame leak meant to be covered as well?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-9R8V.v4.20260928081529%40mojatatu.com
