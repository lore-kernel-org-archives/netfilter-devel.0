Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784941;
	b=H/Jg+EoYi9ashpBQF+rMD/3x2qpR7re+CkM64XSFdc+EpzlYnGJQngU1MH7OzaXvRMw1
	 047XaSBfHuI7svjl1a0HcoIwuPXqRgiWrD6OoXcz7qrBIPn0YgJ3h8QsP31x7qDVeX8n7
	 B/8NWG/vnoPprAto5VNK6q4B9flDTHyzLJPHd/Cwmb6MVxXypasiR2zKf0Fme/Jnk6NWA
	 RP5Sy1xX9x/ixHGOzGaKLZzzeU0p87JsBhMuxAw3+Q/Gj4lGf665+zToTJOfNg6eEyDZb
	 crSIcyGKJDOcWWqYVu8PgJcs1aXONgGhDY5oUifnyFYJnYOG7bFRZ9WnAW5aKdsUvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784941;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=b4jQmNawSjSHqB5fVJ+kRjeQyAtQ1zxyer+bS5dJA+c=;
	b=mi2kqlSblVZCcAf1fYP5KyoMg1a1SoHMvK0sCIgVDIgvvAqxgu0GWdnU9o6Os7xXCZZS
	 2jkaAft19K3UwvKoLe3UcWZEgjOWv7RM2PwYtXmEUJmVun5Z6a+aKfdiXUMzhfwVLUBJG
	 7EsEKqB6fqKrlucqfYseTYmV+DZ11XZojc63lNKU2gg07EWW89/61IUD/P2/q4ip1qDhD
	 UmwaKPmrZWcCNP5bEAgTxH5KdSxypkBwGWcPQTybvg4bnLyOHrb0YKKmsVn8YLGbDZ1M/
	 Son8xB0+hNQo04eYPiOHz91PZ422vaQSU3iGXmyKmIZHGF5kbvNOXLlBJvoYnuRvgGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dLg8WuIr;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 25B5F606A32F;
	Sun, 15 Nov 2026 23:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25B5F606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dLg8WuIr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794784937;
	bh=b4jQmNawSjSHqB5fVJ+kRjeQyAtQ1zxyer+bS5dJA+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLg8WuIrcRXUUambAdPnZKXnlw0968hrh26SNKSJmIoBdC3RD90lB86ojqee/gmGB
	 bqpIez8xiohL1gjKM71A6zHdkwKYbU9FhYJhpvRcHU/bMhQpLPxfpDwbd+OfZaXgOh
	 YfLeZ/+Qu7bhBkIWxS1oOp1coA7BZBK2/5hNOzUJiR+YENf6b/wdtixrs8/WEjIkKs
	 K7DiZFUAb9UZL1LKjtSTxZ6CkwYjNkm21+iNy2IZOIc0UQ+sQHn+qB7jmqcQ/C7yH1
	 u8WmwdJRGM4T4nxMygd8a4Batqt+cZLOdr/K68m20+laUP1y/cNZmZ2vwCVofpU5Oh
	 QBB3MJKEh128Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 22C44601C9;
	Mon, 16 Nov 2026 00:22:17 +0100 (CET)
Date: Mon, 16 Nov 2026 00:22:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 03/15] netfilter: flowtable: retrieve stats on
 flow deletion
Message-ID: <avo-pZueHXPEOl66@chamomile>
References: <20261113031251.2437074-4-pablo@netfilter.org>
 <179462662110.2199510.725528221767942638@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179462662110.2199510.725528221767942638@kernel.org>

On Sat, Nov 14, 2026 at 03:23:41AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The core change only does anything when a driver writes
>   f->stats in its FLOW_CLS_DESTROY handler.
> - [Medium] The final hardware stats are added to the conntrack
>   asynchronously in flow_offload_work_del() ->…
> 
> --
> 
> netfilter: flowtable: retrieve stats on flow deletion
> 
> This commit passes a flow_stats object to the driver on FLOW_CLS_DESTROY,
> so the final hardware counters can be synced into the conntrack entry
> when a flow is removed from hardware. The stats update logic moves out of
> flow_offload_work_stats() into a new flow_offload_update_stats() helper,
> which both the stats path and the delete path now use.
> 
> Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dreyksmail@gmail.com/
> 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 3a18fa48cadb0..c302051489f23 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -928,12 +928,33 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
> 
> [ ... ]
> 
> > +static void flow_offload_update_stats(struct flow_offload_work *offload,
> > +				      struct flow_stats *stats)
> > +{
> > +	u64 lastused;
> > +
> 
> [ ... ]
> 
> > +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > +		if (stats[0].pkts)
> > +			nf_ct_acct_add(offload->flow->ct,
> > +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > +				       stats[0].pkts, stats[0].bytes);
> 
> [Severity: Medium]
> When we get here from flow_offload_work_del(), could the conntrack entry
> already have been deleted and reported?
> 
> One of the triggers that queues the DESTROY work is a dying ct in
> nf_flow_offload_gc_step():
> 
> net/netfilter/nf_flow_table_core.c:nf_flow_offload_gc_step() {
>     ...
> 	    nf_ct_is_dying(flow->ct) ||
>     ...
> }
> 
> By that point nf_ct_delete() has already set IPS_DYING, unlinked the
> entry and sent IPCT_DESTROY. That event carries the ct accounting
> counters to ctnetlink/ulogd:
> 
> net/netfilter/nf_conntrack_core.c:nf_ct_delete() {
>     ...
> 	if (test_and_set_bit(IPS_DYING_BIT, &ct->status))
> 		return false;
>     ...
> 	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
> 				    portid, report) < 0) {
>     ...
> }
> 
> So when an offloaded ct is removed by conntrack -D or -F

This patch does not handle the conntrack -D or -F scenario, that would
require postponing the event delivery.

That is a pre-existing issue, this patch is not targeting at this
scenario.

I don't think the fix needed for this belong to this patch.

> by nf_ct_iterate_cleanup() on device or NAT events, or by netns teardown,
> the sequence looks like this:
> 
> nf_ct_delete()
>   IPCT_DESTROY event sent with the current counters
> nf_flow_offload_gc_step()
>   nf_ct_is_dying() -> flow_offload_teardown() -> nf_flow_offload_del()
> flow_offload_work_handler()
>   flow_offload_work_del()
>     flow_offload_update_stats()
>       nf_ct_acct_add()
> 
> The counters added here go into a ct that nothing reports any more. On
> this path, the hardware traffic since the last FLOW_CLS_STATS poll is
> still lost.
> 
> The common case, a flow expiring while its ct is still alive, looks
> fine. flow_offload_teardown() leaves the ct alive, and this update runs
> before the ct's own destroy event.
> 
> Is the deleted-ct case meant to be covered by the "missing last stats
> sync" that the commit message describes?
> 
> > +		if (stats[1].pkts)
> > +			nf_ct_acct_add(offload->flow->ct,
> > +				       FLOW_OFFLOAD_DIR_REPLY,
> > +				       stats[1].pkts, stats[1].bytes);
> > +	}
> > +}
> 
> [ ... ]
> 
> > @@ -991,10 +1013,15 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
> >  
> >  static void flow_offload_work_del(struct flow_offload_work *offload)
> >  {
> > +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
> > +
> >  	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> > -	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> > +	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
> >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> > -		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> > +		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
> > +
> > +	flow_offload_update_stats(offload, stats);
> 
> [Severity: Medium]
> Won't stats[] still be all zero here for mlx5 and nfp?
> 
> cls_flow is zero-initialised in nf_flow_offload_tuple(). If a driver's
> FLOW_CLS_DESTROY handler never writes f->stats, the memcpy() copies back
> zeroes, and flow_offload_update_stats() skips nf_ct_acct_add().
> 
> Later patches in this series convert mtk_ppe and airoha ("net: ethernet:
> mtk_ppe: update stats on flow deletion" and "net: airoha: update stats on
> flow deletion"). Two other in-tree consumers still report nothing on
> DESTROY at the end of the series.
> 
> In mlx5, mlx5_tc_ct_block_flow_offload_del() drops the counter through
> mlx5_tc_ct_entry_put(). It never calls mlx5_fc_query_cached() or
> flow_stats_update().
> 
> In nfp, nfp_fl_ct_handle_nft_flow() does:
> 
> 	case FLOW_CLS_DESTROY:
> 		ct_map_ent = rhashtable_lookup_fast(...);
> 		return nfp_fl_ct_del_flow(ct_map_ent);
> 
> Both drivers report packet and byte deltas only from their
> FLOW_CLS_STATS handlers, mlx5_tc_ct_block_flow_offload_stats() and
> nfp_fl_ct_stats().
> 
> Both register through act_ct, which turns on counter accounting:
> 
> net/sched/act_ct.c:tcf_ct_flow_table_get() {
>     ...
> 	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
> 			      NF_FLOWTABLE_COUNTER;
>     ...
> }
> 
> So with tc act_ct offload on mlx5 or nfp, traffic forwarded between the
> last FLOW_CLS_STATS poll and the hardware delete is still missing from
> the conntrack counters.
> 
> Given the Reported-by and Closes tags, should mlx5 and nfp be converted
> in this series as well? sfc doesn't seem to be affected, because
> efx_tc_ct_stats() only reports lastused.
> 
> > +
> >  	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> >  }
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
