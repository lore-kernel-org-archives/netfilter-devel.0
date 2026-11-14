Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626622;
	b=Tb51aYmM/3kV+x/Q3x0RPZNiFWCGmnyA6f8ZyQ4mtNMJMjvmvkg/UN9YtIqZTZ+Q0zsg
	 IBALoqDCUD3lLRzYvKsuyxkYWzqfz2XGXdLaqHK5M3wUjXzssUzgO4PV1tPvIdklQyfj+
	 MrFOQn2i7JEBekKvB/P005aoyHHxExO8yg8IWODnfl77yxj+iwzH/Bals4rllZSC8HUou
	 ++IBe0tWA7zOqrv71ywNIRQXwOoFRBr8sjzuZjIPTbSaIpppwKFCkr2VSbG6Bau2iZBHB
	 /gSW1FVpw9K6bYpPSrJgXFOV4im9kDvEOhk4Ng8Pvzslh590w4ACEzvo4uWMdgUD/6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626622;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=S2knM01CTgxUYDjhrubFbbZ13vwWICkyKiPGhue8nfA=;
	b=GWYNoLe+WyxtWihlrc6OB+L5OVazYLPbSo+apn1wyKqhBJFXREclFh6pdu47Zk6g4qUI
	 C/WOUSVbW7yuZ3Ruqav45QzN8O0n+qALqjZo9bdpkfJLeEh6h8PawofSWFczzVX5Oxqh8
	 J+NIzcFC4260B5zrqWF+LBZ2FTMdaZuOnenJaceEBcZ2XukDBNuka9qpdhGeiSnmbEfhY
	 xF4A8HQZn7EAmP7O7kXRdsXlljbQWganKLn/XvHIdFBXMdsWXA6P/+IHFPQLnbkLlEzH8
	 EGmq0mz/j5VyLz/hX+LVeEkFaSCQxoqvt7w/mvDgWzkABsY5GQGii9w2z2xKx6GpiXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFgE90v3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF65606A331;
	Sat, 14 Nov 2026 03:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFgE90v3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893131F000C7;
	Sat, 14 Nov 2026 03:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626622;
	bh=S2knM01CTgxUYDjhrubFbbZ13vwWICkyKiPGhue8nfA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EFgE90v3N4wnFDXDAcBMlxbVNIM/pbrb73xmNBFIPWKq/YMplLFP33rkLtp4J+5nC
	 j4MOh/fWZZUmsQtNgnTDMwygj/iibGpV3rO0FF+jgIQic8kyq9pnNRS3RIvuHryeX5
	 fnD72XvCm9DicIhEBUhQax4XDn1OhgCat+sNIb3u3egIHyeFM/0x99lWdoj0JNSwKp
	 6EyaibHBNhlMe/NHHjEMyEJsTuUjnqT9EzY9tZPXIkowpWNeWaWLm1413oTPiqGvvB
	 KyaBy9oAoCmYx+16LxckhY1DMsFR/j2HATpHWIN14lZIC2PDPBn2LZWh7e4arqlL9+
	 2SlyYGqOkdE4g==
Subject: Re: [PATCH net-next 03/15] netfilter: flowtable: retrieve stats on
 flow deletion
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:41 +0000
Message-ID: <179462662110.2199510.725528221767942638@kernel.org>
In-Reply-To: <20261113031251.2437074-4-pablo@netfilter.org>
References: <20261113031251.2437074-4-pablo@netfilter.org>
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

- [Medium] The core change only does anything when a driver writes
  f->stats in its FLOW_CLS_DESTROY handler.
- [Medium] The final hardware stats are added to the conntrack
  asynchronously in flow_offload_work_del() ->…

--

netfilter: flowtable: retrieve stats on flow deletion

This commit passes a flow_stats object to the driver on FLOW_CLS_DESTROY,
so the final hardware counters can be synced into the conntrack entry
when a flow is removed from hardware. The stats update logic moves out of
flow_offload_work_stats() into a new flow_offload_update_stats() helper,
which both the stats path and the delete path now use.

Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dreyksmail@gmail.com/

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 3a18fa48cadb0..c302051489f23 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -928,12 +928,33 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,

[ ... ]

> +static void flow_offload_update_stats(struct flow_offload_work *offload,
> +				      struct flow_stats *stats)
> +{
> +	u64 lastused;
> +

[ ... ]

> +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> +		if (stats[0].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> +				       stats[0].pkts, stats[0].bytes);

[Severity: Medium]
When we get here from flow_offload_work_del(), could the conntrack entry
already have been deleted and reported?

One of the triggers that queues the DESTROY work is a dying ct in
nf_flow_offload_gc_step():

net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
    ...
	    nf_ct_is_dying(flow->ct) ||
    ...
}

By that point nf_ct_delete() has already set IPS_DYING, unlinked the
entry and sent IPCT_DESTROY. That event carries the ct accounting
counters to ctnetlink/ulogd:

net/netfilter/nf_conntrack_core.c:nf_ct_delete() {
    ...
	if (test_and_set_bit(IPS_DYING_BIT, &ct->status))
		return false;
    ...
	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
				    portid, report) < 0) {
    ...
}

So when an offloaded ct is removed by conntrack -D or -F, by
nf_ct_iterate_cleanup() on device or NAT events, or by netns teardown,
the sequence looks like this:

nf_ct_delete()
  IPCT_DESTROY event sent with the current counters
nf_flow_offload_gc_step()
  nf_ct_is_dying() -> flow_offload_teardown() -> nf_flow_offload_del()
flow_offload_work_handler()
  flow_offload_work_del()
    flow_offload_update_stats()
      nf_ct_acct_add()

The counters added here go into a ct that nothing reports any more. On
this path, the hardware traffic since the last FLOW_CLS_STATS poll is
still lost.

The common case, a flow expiring while its ct is still alive, looks
fine. flow_offload_teardown() leaves the ct alive, and this update runs
before the ct's own destroy event.

Is the deleted-ct case meant to be covered by the "missing last stats
sync" that the commit message describes?

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

[Severity: Medium]
Won't stats[] still be all zero here for mlx5 and nfp?

cls_flow is zero-initialised in nf_flow_offload_tuple(). If a driver's
FLOW_CLS_DESTROY handler never writes f->stats, the memcpy() copies back
zeroes, and flow_offload_update_stats() skips nf_ct_acct_add().

Later patches in this series convert mtk_ppe and airoha ("net: ethernet:
mtk_ppe: update stats on flow deletion" and "net: airoha: update stats on
flow deletion"). Two other in-tree consumers still report nothing on
DESTROY at the end of the series.

In mlx5, mlx5_tc_ct_block_flow_offload_del() drops the counter through
mlx5_tc_ct_entry_put(). It never calls mlx5_fc_query_cached() or
flow_stats_update().

In nfp, nfp_fl_ct_handle_nft_flow() does:

	case FLOW_CLS_DESTROY:
		ct_map_ent = rhashtable_lookup_fast(...);
		return nfp_fl_ct_del_flow(ct_map_ent);

Both drivers report packet and byte deltas only from their
FLOW_CLS_STATS handlers, mlx5_tc_ct_block_flow_offload_stats() and
nfp_fl_ct_stats().

Both register through act_ct, which turns on counter accounting:

net/sched/act_ct.c:tcf_ct_flow_table_get() {
    ...
	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
			      NF_FLOWTABLE_COUNTER;
    ...
}

So with tc act_ct offload on mlx5 or nfp, traffic forwarded between the
last FLOW_CLS_STATS poll and the hardware delete is still missing from
the conntrack counters.

Given the Reported-by and Closes tags, should mlx5 and nfp be converted
in this series as well? sfc doesn't seem to be affected, because
efx_tc_ct_stats() only reports lastused.

> +
>  	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
