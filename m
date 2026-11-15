Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785225;
	b=QKiftlEnXsmHH0KePoTfT7NdWlR5QWctp4SOnSMP1lqXF1Ylz3pIiVZHTj0vLAtKTDb4
	 kFuCx6A6uxiNku6ewLc0V9SIwi0cXMtm+WYux9TJV7uY//O3wSLQm/BKQebFtBMCMwQDr
	 7pFzxXsmusgCp9q5+RR0MQqiPdz+V0REMyrPUbvUl9O/ata4NKOYxrX//beEVUNsTf+5t
	 00C92/JI7yKKy9NhYKeI8K3QQjGErHbskkv7nrLz3gLXP9M4OuAmzI27y7yq18tPgYolY
	 hfYZSsp2g/4unDTzHGtf0Dp8oljUoAmDvrvbnsoumLHVn4I4CcrkxV3hACLZRf6utcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785225;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=YDBQMRk8u4eUBipzgG+fYcGFzrq69NKY+0LjrryidbI=;
	b=dEUWKSHg1k/Wdf8X7LT3mJmtKVpAYpDC6nTkusBLV/Og9GaT8k2mh6O/Xgdo8uIDTVJp
	 V0zrs/MIRj1apWaZlXKxuGGpeAT4/dR0to3Acrn/KF3TjP3D5nLLD4qXC0jsEaNiZDAkX
	 4KzX3YxnZdb9GjowO0w2Was5Hwkr64w6AVzV46nCl/zfik5I0G1otPx958L+9qzhH7vZJ
	 ss/q2qUWu0r4Hm4+275lUtTTG+0BF2FNuSHTfwPInobr71GzPDAzRkrjaoVALSyI9HOAo
	 oqvbjc0M98kN5Q7cMg2b+4CdHxtKgsYc5Fz81qNs+h4rmvnWPZgGCkxbwAyBKZBjG/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="c2H/qwV5";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 742B2606A31F;
	Sun, 15 Nov 2026 23:27:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 742B2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=c2H/qwV5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794785222;
	bh=YDBQMRk8u4eUBipzgG+fYcGFzrq69NKY+0LjrryidbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c2H/qwV5YxVSuplECSTbYdc7Mc5rKMBxdx92eFq1qAhvmPbZauZ29lEf/Hv9wvAdW
	 PAtdNxGbPX0i22WSbNhJT+MPNqXpD3hrFRNck//jnUgYaNWivVcXqa/EWLMV22T8ed
	 kuXnuDPZKmqW74+1FPdv6SSBhqdCj/bdWulK85FYMSaWNafoA2JYoR600HA6oO/+C7
	 PsHURNo+M+9qvrXC+AqkeZJsBVnU6yjqNNrojjYRlCj4By4UbIWCrCK/I5cAOQALF/
	 lsTVxSOzdxtBcHk67CwlfMBiCvcrGpEgKjPh9l1Qlr1LkN+uFYe6XRqUG3GfaVhmvd
	 vgt0SqdOO/CRA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1E9AB602A3;
	Mon, 16 Nov 2026 00:27:02 +0100 (CET)
Date: Mon, 16 Nov 2026 00:26:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 05/15] net: airoha: update stats on flow deletion
Message-ID: <avo_w5dBTlwektmY@chamomile>
References: <20261113031251.2437074-6-pablo@netfilter.org>
 <179462662336.2199510.7109174272716218011@kernel.org>
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
In-Reply-To: <179462662336.2199510.7109174272716218011@kernel.org>

On Sat, Nov 14, 2026 at 03:23:43AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] airoha_ppe_flow_update_stats()
>   (drivers/net/ethernet/airoha/airoha_ppe.c, ~1288-1303) computes…
> - [Low] In airoha_ppe_flow_offload_destroy() the final counters are
>   sampled by airoha_ppe_flow_update_stats() (line 1315) before the…
> 
> --
> 
> net: airoha: update stats on flow deletion
> 
> This commit moves the stats collection code out of
> airoha_ppe_flow_offload_stats() into a new helper,
> airoha_ppe_flow_update_stats(). The helper is also called from
> airoha_ppe_flow_offload_destroy(), so the final counters are reported on
> flow deletion, as introduced by "netfilter: flowtable: retrieve stats on
> flow deletion".
> 
> > diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
> > index f5369c45766d2..af8c7fe9b7f09 100644
> > --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> > +++ b/drivers/net/ethernet/airoha/airoha_ppe.c
> > @@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
> >  	return err;
> >  }
> >  
> > +static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
> > +					 struct flow_cls_offload *f,
> > +					 struct airoha_flow_table_entry *e)
> > +{
> > +	u32 idle = airoha_ppe_entry_idle_time(eth->ppe, e);
> > +
> > +	f->stats.lastused = jiffies - idle * HZ;
> > +	if (e->hash != 0xffff) {
> > +		struct airoha_foe_stats64 stats = {};
> > +
> > +		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
> > +		f->stats.pkts += (stats.packets - e->stats.packets);
> > +		f->stats.bytes += (stats.bytes - e->stats.bytes);
> > +		e->stats = stats;
> 
> [Severity: Medium]
> Can these subtractions wrap if the entry was re-bound after the last stats
> read?

Maybe, but that is a pre-existing issue.
 
This patch is just adapting the driver to use the new call to stats
when deleting a flow, it reuses the existing codebase.

Same as with the previous patch.

> Every time the driver commits a binding, it resets the hardware/NPU counter
> slot to zero:
> 
> airoha_ppe_foe_insert_entry()
>   airoha_ppe_foe_commit_entry(ppe, &e->data, hash, rx_wlan)
>     airoha_ppe_foe_flow_stats_update()
>       airoha_ppe_foe_flow_stat_entry_reset()
>         memset_io(&npu->stats[index], 0, sizeof(*npu->stats));
>         memset(&ppe->foe_stats[index], 0, sizeof(*ppe->foe_stats));
> 
> e->stats is not cleared on that path. Its only writer is the assignment
> above.
> 
> Suppose the FOE entry goes UNBIND, either through hardware aging or
> because the slot was overwritten. airoha_ppe_foe_insert_entry() then
> re-binds it and sets e->hash = hash. The next call here computes
> small - old_total in u64, which gives a value near 2^64.
> 
> On the DESTROY path, flow_offload_update_stats() passes that value to
> nf_ct_acct_add(), which takes unsigned int packets/bytes. The conntrack
> counters would then jump by roughly 2^32 - old_total.
> 
> The stale baseline already affected the periodic FLOW_CLS_STATS path. But
> nf_flow_offload_gc_step() never sends FLOW_CLS_STATS for a flow that has
> been torn down. A re-bind between teardown and the DESTROY work used to
> go unreported. With this patch it becomes the flow's final accounting
> value.
> 
> Should e->stats be reset wherever e is recommitted and the hardware counter
> is zeroed?
> 
> > +	}
> > +}
> > +
> >  static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
> >  					   struct flow_cls_offload *f)
> >  {
> > @@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
> >  	if (!e)
> >  		return -ENOENT;
> >  
> > +	airoha_ppe_flow_update_stats(eth, f, e);
> >  	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);
> 
> [Severity: Low]
> Could the final stats miss packets that the hardware forwards between
> these two calls?
> 
> The counters are read without ppe_lock while the FOE entry is still BIND,
> so the PPE keeps forwarding and counting. After that,
> airoha_ppe_foe_flow_remove_entry() takes ppe_lock and does:
> 
> airoha_ppe_foe_remove_flow()
>   e->data.ib1 |= FIELD_PREP(AIROHA_FOE_IB1_BIND_STATE, AIROHA_FOE_STATE_INVALID);
>   airoha_ppe_foe_commit_entry(ppe, &e->data, e->hash, false)
>     airoha_ppe_foe_flow_stats_update()
>       airoha_ppe_foe_flow_stat_entry_reset()
>     airoha_ppe_foe_commit_sram_entry()
> 
> Packets counted after the snapshot and before the reset are lost. So are
> packets counted after the reset and before the SRAM write that
> invalidates the entry.
> 
> The window is small. Since the goal here is accurate final counters,
> would it be better to invalidate the hardware entry first, then read and
> reset the counter, all under ppe_lock?
> 
> >  	rhashtable_remove_fast(&eth->flow_table, &e->node,
> >  			       airoha_flow_table_params);
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
