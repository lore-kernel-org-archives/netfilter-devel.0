Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874966;
	b=EnxffAIwJmQUyIGyDj6VpZFuqI6hvOco2ewzW7yP2g4tjFhl8yAgX8shxjNNGXLr44D1
	 1qDKYj2dTba7gzTKeTy6ZchCTtsZNat8/MNroapTVh/SkZrqhP1cOsSI1cww0vRrvEPNn
	 yIsHNb5Ai9/IQjf03j9BUcLn+3AnjpxAMoZ1rjRqRHXrXKWbrkS37yXhE4wqjc+RkT8BQ
	 RiksnL334G5jLblUV1vBYXyx4Rx8W+fYgY4W2HrxIrQzNUaXaRkYpIH7WaY1zqOzu72yn
	 8unFQSuUTlshI2Feif3b6n+zAGBQ/6tWniEYyUlGEZe5LICs4TN+mpDa/sM5XHXnbww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874966;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=tTwP+TYbtyv9AfS6DHhWvTmxGIqrXHsxpagAs0d6eLA=;
	b=CKUowns6nRURralS4PlL+tE6dVV0s5iqWbz9bNe2fXsHfpFSUhfYvje7SklqwPWKTioH
	 iRw47aHvC1Td0By5xzYcNtWNZVIZ8xGxhoz4ubPzIrnP9pW9WuXt3aNC00PtSxvisK7Ib
	 MJF8Inl3bb4dRZwdd1z7TRdurR/OuIRSZ4HG2K4HBuuCswkMNSA2Gb1ZWoClqZ7WEMLDd
	 GTa5x3TDokrkDbc6riJywtV5O5uxMzY03JJ8xRCwwO+lrrw0A4AFXsMV4vKuUpnc+M9mB
	 wvYshCZ29BSdNxBQIN8VOGCYFV+btK3jek52ABOscu/94dLzcKRXmO5AYhVVZU1KvZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bRsk+T/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6005F606A334;
	Tue, 17 Nov 2026 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRsk+T/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2031F000C4;
	Tue, 17 Nov 2026 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874966;
	bh=tTwP+TYbtyv9AfS6DHhWvTmxGIqrXHsxpagAs0d6eLA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bRsk+T/z5TI1Sfcb4VB2aeDANy5yTXxiiCwROQN+GIGpwXa7MsWi6z8N+8OZ6bVnf
	 CXtNHFwvfaVNZ53sTr+FpzdbC6vNfcrHWoBPfuFztkaCaU779JipvsYnZv3RkkHqke
	 SLuLRkkW6ZPH25NIF0FGqHRvVMgCXi+ussLUYteYUu5mCQp/m24pzb6zsqROOeJwvd
	 FjzwlEFq/IbG3pTMsdHhXtUi3xX4yeo/UR7zFo+kNpUoZWoZdG+O/z9AA9fbLbGQWw
	 Q//4FZWRRnDZwPZxzrpoRpOF6WFydCbxpeI4YySmjOo17LI19W0dugH/NpWlkzqbWv
	 4XPTyKZw9x0dg==
Subject: Re: [PATCH net-next 02/13] netfilter: flowtable: retrieve stats on
 flow deletion
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:45 +0000
Message-ID: <179487496533.3136.15267350352021671450@kernel.org>
In-Reply-To: <20261116001612.2806263-3-pablo@netfilter.org>
References: <20261116001612.2806263-3-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Destroy-time stats only work for drivers that fill `f->stats`
  on FLOW_CLS_DESTROY, and the series converts only two.
- [Medium] netfilter: flowtable: broken timeout update in
  flow_offload_update_stats()

--

netfilter: flowtable: retrieve stats on flow deletion

The flowtable offload code now passes a stats object to drivers with
FLOW_CLS_DESTROY. The result goes through a new flow_offload_update_stats()
helper, which the FLOW_CLS_STATS path also uses, so the last hardware
counters can be synced to conntrack when a flow is deleted. Drivers have
to be updated to fill in the stats at destroy time.

Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dreyksmail@gmail.com/

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 3a18fa48cadb0..c302051489f23 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c

[ ... ]

> +static void flow_offload_update_stats(struct flow_offload_work *offload,
> +				      struct flow_stats *stats)
> +{

[ ... ]

> +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> +		if (stats[0].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> +				       stats[0].pkts, stats[0].bytes);
> +		if (stats[1].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_REPLY,
> +				       stats[1].pkts, stats[1].bytes);
> +	}
> +}

[ ... ]

> @@ -991,10 +1013,15 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
>  
>  static void flow_offload_work_del(struct flow_offload_work *offload)
>  {
> +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
> +
>  	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> -	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> +	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> -		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> +		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
> +
> +	flow_offload_update_stats(offload, stats);
> +

[Severity: Medium]
Moving the timeout update into a shared helper means it now also runs
on FLOW_CLS_DESTROY. Is that safe?

flow->timeout is a u32 stamp that is compared against
nf_flowtable_time_stamp, which is (u32)jiffies. flow_stats.lastused is
a u64 that drivers fill from the full jiffies value. Once a 64-bit
kernel has been up for about five minutes, jiffies is above 2^32. At
that point lastused + flow_offload_get_timeout() always has upper bits
set, so max_t(u64, ...) always picks it over the zero-extended
flow->timeout. The result is then truncated back to u32. The hardware
value always wins, even when it is older than what software has
already recorded.

That u32/u64 mixing already exists in flow_offload_work_stats(), but
on deletion the flow is not necessarily going away.
nf_flow_offload_gc_step() calls nf_flow_offload_del() for
NF_FLOW_CLOSING flows and keeps them in the software flowtable until
flow->timeout expires. If software saw the FIN/RST and refreshed
flow->timeout, the stale hardware lastused can now move flow->timeout
backwards. The closing flow then expires early.

The opposite happens with drivers that don't fill cls_flow.stats on
destroy, which today is every driver until the later patches land.
stats[] stays zeroed and lastused is 0, so the helper computes
max(flow->timeout, offload_timeout). Whenever the u32 flow->timeout has
wrapped into [0, offload_timeout), it gets bumped to offload_timeout.
That silently extends the software lifetime of the flow.

For NF_FLOW_TEARDOWN flows, flow_offload_teardown() has already run
flow_offload_fixup_ct() before nf_flow_offload_del() is queued. So
updating flow->timeout at deletion time doesn't reach conntrack anyway.

Does flow_offload_work_del() need to touch flow->timeout at all, or
would syncing the packet and byte counters be enough there? If the
timeout update has to stay, could it be skipped when lastused is 0?
Could the comparison also be done on the truncated u32 values with a
wrap-safe check, similar to how nf_flow_has_expired() compares
flow->timeout, rather than max_t(u64, ...)?

[Severity: Medium]
This depends on each driver's FLOW_CLS_DESTROY handler filling in
cls_flow.stats. If a driver doesn't touch it, stats[] stays zeroed. Because
of the stats[i].pkts checks, flow_offload_update_stats() then skips
nf_ct_acct_add().

Later patches in this series convert mtk_ppe and airoha. Are there other
in-tree backends that still lose the final counter delta on deletion?

For mlx5 conntrack offload, mlx5_tc_ct_block_flow_offload() in
drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c sends DESTROY straight
to the del handler:

	case FLOW_CLS_DESTROY:
		return mlx5_tc_ct_block_flow_offload_del(ft, f);
	case FLOW_CLS_STATS:
		return mlx5_tc_ct_block_flow_offload_stats(ft, f);

mlx5_tc_ct_block_flow_offload_del() removes the entry and drops the
counter reference. It never does a final mlx5_fc_query_cached() /
flow_stats_update(). The representor nft flowtable path
mlx5e_rep_setup_ft_cb()->mlx5e_delete_flower() seems to behave the same
way.

For nfp, nfp_fl_ct_offload_nft_flow() does:

	case FLOW_CLS_DESTROY:
		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table, &flow->cookie,
						    nfp_ct_map_params);
		return nfp_fl_ct_del_flow(ct_map_ent);

This frees the entry without the delta accounting that nfp_fl_ct_stats()
does for FLOW_CLS_STATS.

act_ct always sets NF_FLOWTABLE_COUNTER in tcf_ct_flow_table_get(). On
these drivers, could packets and bytes counted in hardware between the
last FLOW_CLS_STATS poll and deletion still never reach the conntrack
counters? That looks like the same missing last stats sync that the
Closes: tag refers to.

sfc doesn't look affected, since efx_tc_ct_stats() only reports lastused.

Could the new driver contract also be documented? The DESTROY-time values
need to be deltas since the last FLOW_CLS_STATS, the same as the STATS
paths report, not cumulative totals. Otherwise nf_ct_acct_add() counts
some traffic twice. They also need to be read before the hardware counter
or MIB slot is released.

>  	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
