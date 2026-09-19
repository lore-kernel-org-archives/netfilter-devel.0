Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B4292B2E;
	Sat, 19 Sep 2026 13:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789824891; cv=none; b=sj7PoUqp6fz0+4dNiTFqg3tNRvYJVgf7pXNJaaisBmaeXUIWdFFCyh4qO9chjZHxvaDk7J1qDxdNZX/LFcUgtaQ/3QDcNAvGdXebcdgCtWP4AfTZFUk/5R5+tzEUzVYrrzZu423X6wPw4me90PW5PKW1MsQUI560K0uDXj7o+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789824891; c=relaxed/simple;
	bh=amOa4ik1PTVWeYvFkEtA4dL+9mgJHFzDJB5ZnPokJcs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=euLsZpu3iyTlCiHPSvX5eZMtzaQWAc7NIkQrG7hMYQemKqQzNqrUX/5DhuBwL+ytOqIuzviwmt/65U3Hxbz2TPFveI7W5126nLhxsfOVnCOu3Rk28fIvipsIIpGad9GBeQt0/WfzU0M6UEKBfqjdC1xWR+IgdOs5dwm4e35gQpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOsm1Uno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOsm1Uno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B751F000FF;
	Sat, 19 Sep 2026 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789824889;
	bh=PRlwBBwix2SI9u8sQAIJulPQFFMLUXw1J4AP0vddEmc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SOsm1UnoVpAJs7n4Db/5VJSFZ0NstGfrxbzmV5fRYAHLKEm34jyRUvoKEPV3aLYgx
	 VdrpJnwOjX+Lo1VgWy3L/GN0cy+rsR5G+yi717EoodENqGq80pX+JjqQ888eNN4nE0
	 GRC0BoRkwV4Rhpe0pqZkhmGgnciNDs58uEDNCSyBEbEEUhZJl8E1DfnoIqSWc4hWCh
	 tFVy3sJj/JoguU3L6xC3MnePuCDfKjUQplQHjRQ81NWN0ndd2ZE2ABRn2qGVGKFYrP
	 ouBet0S9uEWE+Su4Pa2na9dMESOsBZWJipHP68VKkdjk/aUDdQwFnZ3FKzS8Wdbmz5
	 pEPex3CuQre2g==
Subject: Re: [PATCH net 1/8] netfilter: flowtable: publish HW_DEAD after
 worker is done
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 19 Sep 2026 13:34:48 +0000
Message-ID: <178982488874.22033.15959147673465185831@kernel.org>
In-Reply-To: <20260918112844.194503-2-pablo@netfilter.org>
References: <20260918112844.194503-2-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] Incomplete fix: the FLOW_CLS_STATS (and, in a narrower window,
  FLOW_CLS_REPLACE) offload work items still hold an unreferenced, non-…

--

netfilter: flowtable: publish HW_DEAD after worker is done

The NF_FLOW_HW_DEAD publication is moved out of flow_offload_work_del()
into the common flow_offload_work_handler() epilogue, after
NF_FLOW_HW_PENDING is cleared, so that the destroy work item does not
touch the flow after garbage collection is allowed to free it.

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 801a3dd9ceea..6757fd89c1f1 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -995,7 +995,6 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
>  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>  		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> -	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }
>  
>  static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> @@ -1059,6 +1058,12 @@ static void flow_offload_work_handler(struct work_struct *work)
>  	}
>  
>  	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
> +	if (offload->cmd == FLOW_CLS_DESTROY) {
> +		/* Publish after the worker's last flow access. */
> +		smp_mb__before_atomic();
> +		set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> +	}
> +
>  	kfree(offload);
>  }

[Severity: High]
Does this reordering also cover the FLOW_CLS_STATS and FLOW_CLS_REPLACE work
items?  The clear_bit() above runs for every command, and for stats work the
flow can already be gone by the time the worker reaches it.

The sequence I think is still possible, all on a flow that has NF_FLOW_HW set:

A remote FIN/RST marks the flow closing in nf_flow_state_check():

net/netfilter/nf_flow_table_ip.c:nf_flow_state_check() {
	if ((tcph->fin || tcph->rst) &&
	    !test_bit(NF_FLOW_CLOSING, &flow->flags))
		set_bit(NF_FLOW_CLOSING, &flow->flags);
}

nf_flow_offload_gc_step() then queues the destroy work, and the flow stays
linked in the rhashtable:

net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
	} else if (test_bit(NF_FLOW_CLOSING, &flow->flags) &&
		   test_bit(NF_FLOW_HW, &flow->flags) &&
		   !test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
		nf_flow_offload_del(flow_table, flow);
	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
		nf_flow_offload_stats(flow_table, flow);
	}
}

The destroy worker now clears NF_FLOW_HW_PENDING and publishes
NF_FLOW_HW_DEAD.  Since NF_FLOW_HW, NF_FLOW_HW_DYING and NF_FLOW_HW_DEAD are
never cleared again anywhere in the tree, a later garbage collection pass on
the same flow falls through to the last branch above and queues a stats work
item, because nf_flow_offload_work_alloc() only gates on the pending bit:

net/netfilter/nf_flow_table_offload.c:nf_flow_offload_work_alloc() {
	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
		return NULL;
	...
	offload->flow = flow;
}

So a stats work item can exist for a flow that already has HW_DYING and
HW_DEAD set.  When NF_FLOW_TEARDOWN is then set (expiry, ct dying, dst
invalid, netdev down, or a SYN on the closing flow via
nf_flow_state_check() -> flow_offload_teardown()), the next pass frees it:

net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
	if (teardown) {
		if (test_bit(NF_FLOW_HW, &flow->flags)) {
			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
				nf_flow_offload_del(flow_table, flow);
			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
				flow_offload_del(flow_table, flow);
	...
}

flow_offload_del() -> flow_offload_free() -> call_rcu(&flow->rcu_head,
flow_offload_free_rcu) waits only for RCU readers.  The stats worker holds no
reference and no RCU read lock, and it sleeps in
down_read(&flowtable->flow_block_lock) and in the driver callbacks, so can
the grace period elapse while flow_offload_work_stats() is still using the
flow here?

net/netfilter/nf_flow_table_offload.c:flow_offload_work_stats() {
	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
	...
	offload->flow->timeout = max_t(u64, offload->flow->timeout,
				       lastused + flow_offload_get_timeout(offload->flow));
}

and then in the shared epilogue:

	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);

That looks like the same "worker writes flow flags after the flow may have
been freed" pattern the commit message describes, just reached through the
stats work item instead of the destroy one.

The ordering in nf_flow_table_gc_cleanup() seems to make this explicit on the
netdev-down and flowtable-delete paths:

net/netfilter/nf_flow_table_core.c:nf_flow_table_gc_cleanup() {
	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
	flush_delayed_work(&flowtable->gc_work);
	nf_flow_table_offload_flush(flowtable);
}

Teardown is set, the gc flush frees the HW_DEAD flows, and only afterwards
are the add/del/stats workqueues drained.  Should the flush of the offload
workqueues happen before the gc flush here?

Would it make sense for the free decision in nf_flow_offload_gc_step() to
also consult NF_FLOW_HW_PENDING, or for the work items to take a reference
on the flow (or for work admission to be refused once NF_FLOW_HW_DYING is
set), rather than only reordering the two bit operations in the destroy
worker?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
