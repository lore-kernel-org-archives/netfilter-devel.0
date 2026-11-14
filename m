Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626624;
	b=ahMZUplJTjt+bV9PgIh6vhDnsCbAlUgkO9dL0DSTGrmT0vs4U+l6C2+el7liNtHrMH3s
	 Du77ztscXlGAvIkd06g6ZH6NJN5NnY9ZliIariEE0F84io3HA5j9ZcaFUSOl0LCMGl11v
	 U7/miDYJJpz3PSqkrzGI2OBQO90sD6uTSOyVouUKgc2kcy02dYplXksFRNx8Qt3lfEzuA
	 jjJYEFMOveO2qGC9XcXHfC44QLlP27pn+ETUZj8x/9oVhTvzrmdeTokcKnA797DVLb6Yt
	 CIvHBPHBcqs+ms58eOT4gk3b6UJSPghzlu9sYY2TsrQRrwNRRYWuw2eZCrGM/pcBjBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626624;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ywTZNUzdDeYFYSzCQUyskO5KI+1kN5G5m4XRolGTxVo=;
	b=kesa48ruH+nfpNWsgIry6KEtWGWgN89qCoL0oX/tRNIbm6H/lKWBvKMRzlTAQ1yAa22H
	 fQAIdCH57Cbcgnhqpy1a6a/3m5UU3JUG6/xcMhY7ECCLQVhnksa+PmT9eyeCLUJDjM7Jj
	 v/xHhstHYwfz6GrGeAtjPCjhFp+WSfjzA3VP9fEIdxo03vIwz1txAS0sQvJFTWVYm/n6u
	 iUWlDBUsa6cWu/0kw2Gbytv5taV7WmfpyzwLcpf0iUFTPt3Fuh/98s76LUYyxOPgxLk3a
	 ino0XafcY0TPwC++OhJpR8c+IxZF8s0tFCo9QUc1isa+LohMLvGRMjyjgqS60xQltVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3H+8dab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B2606A89E;
	Sat, 14 Nov 2026 03:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3H+8dab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE181F000C8;
	Sat, 14 Nov 2026 03:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626624;
	bh=ywTZNUzdDeYFYSzCQUyskO5KI+1kN5G5m4XRolGTxVo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I3H+8dabKM/Th3RCB38PFFfWg8EenAPhtxiTkLO+mPHvvrpnVJnSVg3cu1fD28049
	 zh9/9Pz7R7Vl5jR0lhtWExIRCkGY+rkjsltjgfQHNMq3Ur2COqGk+OiWhL9woyntry
	 xMiC9+/q9awhQZgFqGpMvV8ens3/V+O6SrYLcsFzRAruA5kHSl63r2p6nWjNZ28LtZ
	 BYMXnE8l2C2LEIs9vIG/jyyufdKhruOGoGsU+KoJY3ogVfcGqxF61aN99HO0omBRS7
	 9ZtSUP4CbttTcNbJauQUZ9s3Ov+i6mxrqXOgADvQK29lyRHz89J+J6i+rgw/tmzm9a
	 ZKt9mbLax1qhg==
Subject: Re: [PATCH net-next 05/15] net: airoha: update stats on flow deletion
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:43 +0000
Message-ID: <179462662336.2199510.7109174272716218011@kernel.org>
In-Reply-To: <20261113031251.2437074-6-pablo@netfilter.org>
References: <20261113031251.2437074-6-pablo@netfilter.org>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] airoha_ppe_flow_update_stats()
  (drivers/net/ethernet/airoha/airoha_ppe.c, ~1288-1303) computes…
- [Low] In airoha_ppe_flow_offload_destroy() the final counters are
  sampled by airoha_ppe_flow_update_stats() (line 1315) before the…

--

net: airoha: update stats on flow deletion

This commit moves the stats collection code out of
airoha_ppe_flow_offload_stats() into a new helper,
airoha_ppe_flow_update_stats(). The helper is also called from
airoha_ppe_flow_offload_destroy(), so the final counters are reported on
flow deletion, as introduced by "netfilter: flowtable: retrieve stats on
flow deletion".

> diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
> index f5369c45766d2..af8c7fe9b7f09 100644
> --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> +++ b/drivers/net/ethernet/airoha/airoha_ppe.c
> @@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
>  	return err;
>  }
>  
> +static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
> +					 struct flow_cls_offload *f,
> +					 struct airoha_flow_table_entry *e)
> +{
> +	u32 idle = airoha_ppe_entry_idle_time(eth->ppe, e);
> +
> +	f->stats.lastused = jiffies - idle * HZ;
> +	if (e->hash != 0xffff) {
> +		struct airoha_foe_stats64 stats = {};
> +
> +		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
> +		f->stats.pkts += (stats.packets - e->stats.packets);
> +		f->stats.bytes += (stats.bytes - e->stats.bytes);
> +		e->stats = stats;

[Severity: Medium]
Can these subtractions wrap if the entry was re-bound after the last stats
read?

Every time the driver commits a binding, it resets the hardware/NPU counter
slot to zero:

airoha_ppe_foe_insert_entry()
  airoha_ppe_foe_commit_entry(ppe, &e->data, hash, rx_wlan)
    airoha_ppe_foe_flow_stats_update()
      airoha_ppe_foe_flow_stat_entry_reset()
        memset_io(&npu->stats[index], 0, sizeof(*npu->stats));
        memset(&ppe->foe_stats[index], 0, sizeof(*ppe->foe_stats));

e->stats is not cleared on that path. Its only writer is the assignment
above.

Suppose the FOE entry goes UNBIND, either through hardware aging or
because the slot was overwritten. airoha_ppe_foe_insert_entry() then
re-binds it and sets e->hash = hash. The next call here computes
small - old_total in u64, which gives a value near 2^64.

On the DESTROY path, flow_offload_update_stats() passes that value to
nf_ct_acct_add(), which takes unsigned int packets/bytes. The conntrack
counters would then jump by roughly 2^32 - old_total.

The stale baseline already affected the periodic FLOW_CLS_STATS path. But
nf_flow_offload_gc_step() never sends FLOW_CLS_STATS for a flow that has
been torn down. A re-bind between teardown and the DESTROY work used to
go unreported. With this patch it becomes the flow's final accounting
value.

Should e->stats be reset wherever e is recommitted and the hardware counter
is zeroed?

> +	}
> +}
> +
>  static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
>  					   struct flow_cls_offload *f)
>  {
> @@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
>  	if (!e)
>  		return -ENOENT;
>  
> +	airoha_ppe_flow_update_stats(eth, f, e);
>  	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);

[Severity: Low]
Could the final stats miss packets that the hardware forwards between
these two calls?

The counters are read without ppe_lock while the FOE entry is still BIND,
so the PPE keeps forwarding and counting. After that,
airoha_ppe_foe_flow_remove_entry() takes ppe_lock and does:

airoha_ppe_foe_remove_flow()
  e->data.ib1 |= FIELD_PREP(AIROHA_FOE_IB1_BIND_STATE, AIROHA_FOE_STATE_INVALID);
  airoha_ppe_foe_commit_entry(ppe, &e->data, e->hash, false)
    airoha_ppe_foe_flow_stats_update()
      airoha_ppe_foe_flow_stat_entry_reset()
    airoha_ppe_foe_commit_sram_entry()

Packets counted after the snapshot and before the reset are lost. So are
packets counted after the reset and before the SRAM write that
invalidates the entry.

The window is small. Since the goal here is accurate final counters,
would it be better to invalidate the hardware entry first, then read and
reset the counter, all under ppe_lock?

>  	rhashtable_remove_fast(&eth->flow_table, &e->node,
>  			       airoha_flow_table_params);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
