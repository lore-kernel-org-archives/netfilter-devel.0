Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB77F50AC15;
	Mon, 28 Sep 2026 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639707; cv=none; b=PlTjz9Uy/tKHMIPUt91vFBCBpKQVfKqbmm5biro1+2iKfYENUMr78VOxwQ++9JRbuTEMzPt5MkIucP7Tb1G8oQmKy5udKTc4n2J7fdL9fNniLkLYxzSAY6Pl3Txm6m3EgfkQ7R5GdNaCxzNxhnkK7cZEaulCClhOLr6kvVj0UrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639707; c=relaxed/simple;
	bh=zf29Gt2kDHEVWU5kwUp85rT5hDBBqORRpY0HNsjSpes=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OLY/bDmmfrvRC35uIVIv8M26Pm3HuMsguifSTr9652/ypBEu9QVXCx6Dm1eQq7Qzh5ETOks1bzqZ/yS7RB0/wXd6M731Cj0zF4H8urFTf8ljKbhI3Z4TSSKhHxdXoTUJsDvQtlQNTeGTD5UG/ejX7Y7vbDGnlWpXWReUnXA0qEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8VU8dnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8VU8dnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F941F000FF;
	Mon, 28 Sep 2026 23:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790639705;
	bh=QIirEpJkvKIK16eJFYeEMYWOYwXzKi/NHgEhj6srvPI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V8VU8dnTR5/JwHTLJbrIh3jB+G87OZaYKXn3lPNisZOzLv+EClUPTNwleceRWZvPZ
	 Z8TqdeowTQHL1WYkYT8hDTE//ycn0ro6cSCs6INyv03J5Q20TK3OQX7YXwjo7m6aM6
	 tzdvxF04ePNLEqUPKEYvv9JV4OO9xUI4XAZTTqgIDDQCarW96jHziOK6+yEX1omsGs
	 eUTBSE5TzTvD/BcNX+81TjtM7CSPHkGiZ3CsS5Yzqou0Gb/J0iW6VWU9Jm93n7sDwh
	 j8++XxIZ1ah4b2s6B4t84mm0zDeYybX101biLM24P5vdhLOul+lAGYh+9TD5LDyqwr
	 8Qz8DqIERb8zw==
Subject:
 Re: [PATCH net 10/11] netfilter: flowtable: generalize pending status bit
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 28 Sep 2026 23:55:04 +0000
Message-ID: <179063970489.3145.12908523239374463658@kernel.org>
In-Reply-To: <20260927220816.268206-11-pablo@netfilter.org>
References: <20260927220816.268206-11-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 (1) · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new NF_FLOW_PENDING gate in nf_flow_offload_gc_step()
  (nf_flow_table_core.c:580) is a single relaxed test_bit() snapshot.
- [Low] flow_offload_work_handler() now releases the flow with
  smp_mb__before_atomic() followed by clear_bit(NF_FLOW_PENDING)…

Pre-existing issues:
- [High] nf_flow_table_free()
  (net/netfilter/nf_flow_table_core.c:775-788) does not wait for DESTROY…
- [Medium] The datapath can re-offload a flow that GC has already torn
  down and removed from hardware, and that rule is never deleted.
- [Low] In nf_flow_offload_gc_step()
  (net/netfilter/nf_flow_table_core.c:609-610), the last branch `else if…

--

netfilter: flowtable: generalize pending status bit

This renames NF_FLOW_HW_PENDING to NF_FLOW_PENDING. nf_flow_offload_gc_step()
now skips any flow that has hardware offload work pending. It also moves the
setting of NF_FLOW_HW_DEAD back into flow_offload_work_del(), reverting
d644b23afe1e, and clears the pending bit after a barrier at the end of
flow_offload_work_handler().

> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 934c6151f558b..36bbc7be2f745 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -575,7 +575,12 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  				    struct flow_offload *flow, void *data)
>  {
> -	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
> +	bool teardown;
> +
> +	if (test_bit(NF_FLOW_PENDING, &flow->flags))
> +		return;

[Severity: High]
Does this check actually stop GC from freeing a flow while offload work is
pending? The test_bit() takes one snapshot, and nothing ties it to the
flow_offload_del() call later in this function.

The datapath can still claim NF_FLOW_PENDING after this check.
flow_offload_refresh() is reached from nf_flow_offload_forward() and
tcf_ct_flow_table_lookup() on a flow that was looked up under RCU. It only
checks NF_FLOW_CLOSING and NF_FLOW_HW:

net/netfilter/nf_flow_table_core.c:flow_offload_refresh() {
    ...
	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
	    test_bit(NF_FLOW_CLOSING, &flow->flags))
		return;

	if (test_bit(NF_FLOW_HW, &flow->flags))
		nf_flow_offload_refresh(flow_table, flow);
}

nf_flow_offload_refresh() then calls nf_flow_offload_work_alloc() with
FLOW_CLS_REPLACE. Its test_and_set_bit(NF_FLOW_PENDING) succeeds as soon as
the DESTROY worker has cleared the bit. TEARDOWN, HW_DYING and HW_DEAD are
never checked on this path.

Could this sequence happen?

CPU0 (datapath)                  GC / offload workqueue
flow lookup finds F
                                 gc_step(): teardown F
                                   nf_flow_offload_del(), queue DESTROY
                                 DESTROY worker:
                                   set_bit(NF_FLOW_HW_DEAD)
                                   clear_bit(NF_FLOW_PENDING)
                                 later gc_step():
                                   test_bit(NF_FLOW_PENDING) == 0
flow_offload_refresh(F)
  test_and_set_bit(PENDING)
  queue FLOW_CLS_REPLACE
                                   HW_DEAD set -> flow_offload_del()
                                     call_rcu(flow_offload_free_rcu)
leaves RCU read section
                                 flow_offload_free_rcu():
                                   nf_ct_put(flow->ct); kfree(flow);
                                 REPLACE worker:
                                   flow_offload_work_add() on freed F
                                   clear_bit(NF_FLOW_PENDING) on freed F

call_rcu() only waits for CPU0 to leave its RCU read section. It does not
wait for the work that CPU0 queued.

GC passes can run back to back through
nf_flow_table_cleanup()->flush_delayed_work() on successive NETDEV_DOWN
events. On PREEMPT_RT the reader can also be preempted for a long time.

The commit message says the bit is used "to inhibit the flowtable GC worker
until pending hw offload work has been completed" and "to prevent a race
between GC and hw offload handler". Is a re-check of TEARDOWN or HW_DYING
needed after the fully ordered test_and_set_bit() in
nf_flow_offload_work_alloc() (or in nf_flow_offload_refresh()) to close
this?

[Severity: Low]
Should this be test_bit_acquire()? flow_offload_work_handler() now does
smp_mb__before_atomic() followed by clear_bit(NF_FLOW_PENDING) as the
release side. The reader here is a relaxed test_bit(), though, and the
if/return control dependency only orders later stores, not later loads.

On weakly ordered CPUs such as arm64, GC can see PENDING already cleared by
a FLOW_CLS_STATS work and still read an old flow->timeout in
nf_flow_has_expired(). That would be the value from before
flow_offload_work_stats() stored:

	offload->flow->timeout = max_t(u64, offload->flow->timeout,
				       lastused + flow_offload_get_timeout(offload->flow));

In that case, could GC tear down a flow that the hardware has just reported
as active? The HW_DEAD read is in the same word as PENDING, so it is not
affected.

> +
> +	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
>  
>  	if (nf_flow_has_expired(flow) ||
>  	    nf_ct_is_dying(flow->ct) ||

[Severity: Low]
This is a pre-existing issue, but the last branch of
nf_flow_offload_gc_step() still queues stats work without checking
NF_FLOW_HW_DYING:

	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
		nf_flow_offload_stats(flow_table, flow);
	}

Take a CLOSING flow whose hardware rule has already been destroyed
(HW_DYING and HW_DEAD set, TEARDOWN not set). Will GC keep queueing
FLOW_CLS_STATS work for a cookie the driver has already removed?

With this patch each of those works also sets NF_FLOW_PENDING, so GC skips
the flow until the work finishes. The stats result itself is harmless, but
it adds redundant driver calls and can delay teardown of the flow by up to
about one GC period. This behaviour dates back to commit fdbaf5163331.

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 6757fd89c1f1a..4365859220e6a 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -995,6 +995,7 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>  		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> +	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }

[Severity: Medium]
This isn't a bug introduced by this patch, but can the datapath re-offload a
flow after this DESTROY work has removed it from hardware?

flow_offload_lookup() filters out TEARDOWN only at lookup time.
flow_offload_refresh() then checks only NF_FLOW_CLOSING and NF_FLOW_HW.
flow_offload_work_add() does not re-check TEARDOWN, HW_DYING or HW_DEAD
before it does this:

	err = flow_offload_rule_add(offload, flow_rule);
	if (err < 0)
		goto out;

	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);

Suppose a reader looks up the flow before GC sets TEARDOWN, and calls
refresh after this worker has set HW_DEAD and cleared PENDING. The REPLACE
work then re-installs the hardware rule.

Once the REPLACE work clears PENDING, the next nf_flow_offload_gc_step()
sees TEARDOWN, HW_DYING and HW_DEAD all set. It calls flow_offload_del()
without issuing another DESTROY.

Doesn't that leave a hardware rule for the 5-tuple, keyed by a cookie that
points into the freed flow_offload? That rule would keep forwarding traffic
outside conntrack and the ruleset until the flowtable or block is torn
down.

[ ... ]

> @@ -1089,12 +1085,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>  {
>  	struct flow_offload_work *offload;
>  
> -	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
> +	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
>  		return NULL;
>  
>  	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
>  	if (!offload) {
> -		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
>  		return NULL;
>  	}

[Severity: High]
This is a pre-existing issue, but what happens during flowtable teardown if
this GFP_ATOMIC allocation fails for a DESTROY request?

If it fails, nf_flow_offload_del() returns without setting NF_FLOW_HW_DYING
and nothing is queued. nf_flow_table_free() then continues with:

	nf_flow_table_gc_run(flow_table);
	nf_flow_table_offload_flush_cleanup(flow_table);
	rhashtable_destroy(&flow_table->rhashtable);

and nf_flow_table_offload_flush_cleanup() does:

	if (nf_flowtable_hw_offload(flowtable)) {
		flush_workqueue(nf_flow_offload_del_wq);
		nf_flow_table_gc_run(flowtable);
	}

The second gc_run now queues the DESTROY work on nf_flow_offload_del_wq,
and nothing flushes that workqueue afterwards. rhashtable_destroy() does not
free the entries, so the flow_offload and its ct and dst references are
leaked.

The callers free the flowtable straight away: kfree(flowtable) in
nf_tables_flowtable_destroy() and kfree(ct_ft) in
tcf_ct_flow_table_cleanup_work(). The queued work then runs:

flow_offload_work_handler()
  read_pnet(&offload->flowtable->net)
  flow_offload_work_del()
    flow_offload_tuple_del()
      nf_flow_offload_tuple()
        down_read(&flowtable->flow_block_lock)
        list_for_each_entry(block_cb, block_cb_list, list)

Isn't this a use-after-free of the nf_flowtable? If the allocation fails
again in the second pass, the flow is simply leaked.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
