Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8B35C694;
	Sat, 19 Sep 2026 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829243; cv=none; b=N/OWkyVyO/WfgeeYuZOOGX3ntfhzeTCJAo3qAkktAvgMukJa35EGhar/DjLk7faWqhwJ7yd1f2GiZTzY7l6sFxv5e2kiTgUCt0hoaz7eePScbyncQCDdh3By/oWXcVcK3jDxB/jUQBRtxOXjppC9JriBMMgpItvOIx18TSH6gSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829243; c=relaxed/simple;
	bh=IiEQH8GbuuuigZZCVChq6S+q0DhP0Gv80e7Rwl+awTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCj3ECvY4sM8L+yLRHIgFJf5Ko7ARKyvj4nLXBO14hC/wKh5CttAP9ItBKWhoqDyn9SE+JxjDVU1zQ/6wI1GzZLGrpy1nqJ2VzW9/mU2F5IOr1yHQYq2rieTDkSFxZxLc/Q5SZ2FNMJcH/m1EFEh9PAqoB5OBEnXM1pdLBfJZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lOxslzOU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lOxslzOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789829230;
	bh=EdHjWGVCwcXILuUkFI3Og4x/jlX7w43tKBkPJl2oQ1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOxslzOU/GYtHiRhPZeHQ9WxnDdL8Zc0EyWURS48iI7tRsYRag14ASmOEhfE8S7mc
	 4KA51JqwQ1yuEiXrzem8+EcMb+2WQHiWLfjNVSHw3gXPFUafACFWg+2+WVdzd68A97
	 bMHzvLrACGwlPYfofuaIG862nbTSrUzyBrboksSAA0vas3C0J0RRCkwFCZdqWqHCOb
	 N/YpxHKW69J7JVCt94itkdR1Y3tGnxP99wcKi91EG5x/UX60CCkhG/x+IcuB9Sl3Fb
	 jIWlUCrh6iFWZIrMgeBIJqq4+e3GpbaSigekGlt79UpGTrQilMT/mKTxZ3b/qyQZdx
	 3DvHIdhWOhuyA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5EB756005A;
	Sat, 19 Sep 2026 16:47:10 +0200 (CEST)
Date: Sat, 19 Sep 2026 16:47:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 1/8] netfilter: flowtable: publish HW_DEAD after
 worker is done
Message-ID: <aq6ga3KjFLr5z3lL@chamomile>
References: <20260918112844.194503-2-pablo@netfilter.org>
 <178982488874.22033.15959147673465185831@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178982488874.22033.15959147673465185831@kernel.org>

On Sat, Sep 19, 2026 at 01:34:48PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
> 
> - [High] Incomplete fix: the FLOW_CLS_STATS (and, in a narrower window,
>   FLOW_CLS_REPLACE) offload work items still hold an unreferenced, non-…
> 
> --
> 
> netfilter: flowtable: publish HW_DEAD after worker is done
> 
> The NF_FLOW_HW_DEAD publication is moved out of flow_offload_work_del()
> into the common flow_offload_work_handler() epilogue, after
> NF_FLOW_HW_PENDING is cleared, so that the destroy work item does not
> touch the flow after garbage collection is allowed to free it.

This is a pre-existing issue. I have a patch for this already in the
queue for the stats case.

This patch is already improving the situation.

> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 801a3dd9ceea..6757fd89c1f1 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
> >  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> >  		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> > -	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> >  }
> >  
> >  static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> > @@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
> >  	}
> >  
> >  	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
> > +	if (offload->cmd == FLOW_CLS_DESTROY) {
> > +		/* Publish after the worker's last flow access. */
> > +		smp_mb__before_atomic();
> > +		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> > +	}
> > +
> >  	kfree(offload);
> >  }
> 
> [Severity: High]
> Does this reordering also cover the FLOW_CLS_STATS and FLOW_CLS_REPLACE work
> items?  The clear_bit() above runs for every command, and for stats work the
> flow can already be gone by the time the worker reaches it.
> 
> The sequence I think is still possible, all on a flow that has NF_FLOW_HW set:
> 
> A remote FIN/RST marks the flow closing in nf_flow_state_check():
> 
> net/netfilter/nf_flow_table_ip.c:nf_flow_state_check() {
> 	if ((tcph->fin || tcph->rst) &&
> 	    !test_bit(NF_FLOW_CLOSING, &flow->flags))
> 		set_bit(NF_FLOW_CLOSING, &flow->flags);
> }
> 
> nf_flow_offload_gc_step() then queues the destroy work, and the flow stays
> linked in the rhashtable:
> 
> net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
> 	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
> 		   test_bit(NF_FLOW_HW, &flow->flags) &&
> 		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
> 		nf_flow_offload_del(flow_table, flow);
> 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
> 		nf_flow_offload_stats(flow_table, flow);
> 	}
> }
> 
> The destroy worker now clears NF_FLOW_HW_PENDING and publishes
> NF_FLOW_HW_DEAD.  Since NF_FLOW_HW, NF_FLOW_HW_DYING and NF_FLOW_HW_DEAD are
> never cleared again anywhere in the tree, a later garbage collection pass on
> the same flow falls through to the last branch above and queues a stats work
> item, because nf_flow_offload_work_alloc() only gates on the pending bit:
> 
> net/netfilter/nf_flow_table_offload.c:nf_flow_offload_work_alloc() {
> 	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
> 		return NULL;
> 	...
> 	offload->flow = flow;
> }
> 
> So a stats work item can exist for a flow that already has HW_DYING and
> HW_DEAD set.  When NF_FLOW_TEARDOWN is then set (expiry, ct dying, dst
> invalid, netdev down, or a SYN on the closing flow via
> nf_flow_state_check() -> flow_offload_teardown()), the next pass frees it:
> 
> net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
> 	if (teardown) {
> 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
> 			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
> 				nf_flow_offload_del(flow_table, flow);
> 			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
> 				flow_offload_del(flow_table, flow);
> 	...
> }
> 
> flow_offload_del() -> flow_offload_free() -> call_rcu(&flow->rcu_head,
> flow_offload_free_rcu) waits only for RCU readers.  The stats worker holds no
> reference and no RCU read lock, and it sleeps in
> down_read(&flowtable->flow_block_lock) and in the driver callbacks, so can
> the grace period elapse while flow_offload_work_stats() is still using the
> flow here?
> 
> net/netfilter/nf_flow_table_offload.c:flow_offload_work_stats() {
> 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> 	...
> 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
> 				       lastused + flow_offload_get_timeout(offload->flow));
> }
> 
> and then in the shared epilogue:
> 
> 	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
> 
> That looks like the same "worker writes flow flags after the flow may have
> been freed" pattern the commit message describes, just reached through the
> stats work item instead of the destroy one.
> 
> The ordering in nf_flow_table_gc_cleanup() seems to make this explicit on the
> netdev-down and flowtable-delete paths:
> 
> net/netfilter/nf_flow_table_core.c:nf_flow_table_gc_cleanup() {
> 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
> 	flush_delayed_work(&flowtable->gc_work);
> 	nf_flow_table_offload_flush(flowtable);
> }
> 
> Teardown is set, the gc flush frees the HW_DEAD flows, and only afterwards
> are the add/del/stats workqueues drained.  Should the flush of the offload
> workqueues happen before the gc flush here?
> 
> Would it make sense for the free decision in nf_flow_offload_gc_step() to
> also consult NF_FLOW_HW_PENDING, or for the work items to take a reference
> on the flow (or for work admission to be refused once NF_FLOW_HW_DYING is
> set), rather than only reordering the two bit operations in the destroy
> worker?
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
