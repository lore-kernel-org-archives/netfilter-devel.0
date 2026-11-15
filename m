Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785168;
	b=TWk/s2xJqphGzSc9ZaV87hsfiXY8CB7F9zF/IJ3yDKySZ8P3GHtc4If744rgLzZQ4dq1
	 4cfCHYFOuvRtoAlkS/kJSbOMj479N/tcfo/NsPlEOAXCDnAF1mgDl59M5plxEEahKgWLt
	 5wgHbcfOFMSF3q9N+fRjTrcbBGDxoP6jB+Sh7bvDa2KTCKAhhByRK61uD5zM3EtbvdON1
	 iwK2lGfHVUsYPuy/ba/Y4K/sVKRIh5Mo/jUWwbSmSPBPcqHkKqs+xzx/reMrP4rXCAkzc
	 ewlC1fRiOI+SSSwi/C/Bemw7Ljg62Mo5XhsDZCLWYwARhyl4HBE2DhKghvjxjeZnkMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785168;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=x85rV6ErTUGgBMMy18yTIHAPRKiJWwfdzOK1PAX3FNg=;
	b=bMKQCNjcnySpMFh6n+6m6aGis3dZL68PZ/vH/iuPvNDmDJQz/LgwDfGKCncbhaG5GY5n
	 UmF/BaZlHT5EzrkDa4oqOFozLMzebFCTBNA4TodECIQ7lb8fIm1OUPx3qGt1rJCcjvZJk
	 TxgbYLUybXczi9NVg3LVGBe0t/G1OLXWq07lcy9CMOdkTvt4xrtoT4y3QHdA0iftg3EwF
	 Odd2FGUDC4cXH+QNaWAvdDR5hD9ubk5jzW8D3LBsSM5ajwySLW5W68IgCfAmsldEX8py+
	 OHI6+20yAzqWf7Iq0e7Pnzl2QfAeT0I5MoU4QPV5M/JyJ4axzOA10uwcWkpyucllxcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mNYTx8aA;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E6909606A329;
	Sun, 15 Nov 2026 23:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6909606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mNYTx8aA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794785165;
	bh=x85rV6ErTUGgBMMy18yTIHAPRKiJWwfdzOK1PAX3FNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNYTx8aAV8ChKRG/0mROJZClotygh8Yr1Sme9Agi0Jlt34HRJ9beMresFdEHoU82i
	 vRzO+BItU4yfCIQGUVzO/GlSHFI1asHQar5MjDhktTEQZNva6Wu4OWaDnhEzMjqN8M
	 8yw+584bLiOo14YYtpjuFlu3QuSobxuCMGlKY+sofGMZxQPkzBfplR1OH+cT8vMNgG
	 Hk+SBlKcfSAdq7P7m2UjKcaIxjaU+LIZ05gZnQyJlG7LWr75eUByq2i8RNUU859M12
	 dP1xSJrw6Xht38jleTyzQAcHILau7w7ZjCC7M6wcZqS2rq7c+Mkf/iXV+5o0YLi+wt
	 wkMnUSpdH54lQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 769E3601C9;
	Mon, 16 Nov 2026 00:26:05 +0100 (CET)
Date: Mon, 16 Nov 2026 00:26:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 04/15] net: ethernet: mtk_ppe: update stats on
 flow deletion
Message-ID: <avo_iwv4AZdPu2Lm@chamomile>
References: <20261113031251.2437074-5-pablo@netfilter.org>
 <179462662226.2199510.18334585380250309949@kernel.org>
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
In-Reply-To: <179462662226.2199510.18334585380250309949@kernel.org>

On Sat, Nov 14, 2026 at 03:23:42AM +0000, netdev-bot+sashiko@kernel.org wrote:
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
> - [Medium] Bridge (L2) flows on mtk_ppe: the new destroy-time call to
>   mtk_flow_offload_update_stats() read-clears the hardware MIB counter…
> - [Medium] mtk_flow_offload_destroy() takes the final MIB snapshot before
>   it invalidates the hardware FOE entry, so the 'last stats sync' on…
> 
> --
> 
> net: ethernet: mtk_ppe: update stats on flow deletion
> 
> This moves the stats collection out of mtk_flow_offload_stats() into a new
> helper, mtk_flow_offload_update_stats(). The helper is also called from
> mtk_flow_offload_destroy(), so the final hardware counters are reported
> when a flow is deleted. This follows "netfilter: flowtable: retrieve stats
> on flow deletion".
> 
> > diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> > index 99b28aaa7cc47..8ca694bb5e1b7 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> > @@ -526,6 +526,24 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
> >  	return err;
> >  }
> >  
> > +static void
> > +mtk_flow_offload_update_stats(struct mtk_eth *eth, struct flow_cls_offload *f,
> > +			      struct mtk_flow_entry *entry)
> > +{
> > +	struct mtk_foe_accounting diff;
> > +	u32 idle;
> > +
> > +	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
> > +	f->stats.lastused = jiffies - idle * HZ;
> > +
> > +	if (entry->hash != 0xFFFF &&
> > +	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
> > +				  &diff)) {
> 
> [Severity: Medium]
> When a bridge (L2) flow is destroyed, can this read-clear the hardware
> counter of an unrelated flow?

Maybe, but that is a pre-existing issue.

This patch is just adapting the driver to use the new call to stats
when deleting a flow, it reuses the existing codebase.

> For a flower rule with only ETH_ADDRS, mtk_flow_offload_replace()
> allocates the entry with kzalloc_obj(), so entry->hash starts at 0.
> mtk_foe_entry_commit() then takes the L2 path:
> 
> drivers/net/ethernet/mediatek/mtk_ppe.c:mtk_foe_entry_commit() {
> 	...
> 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
> 		return mtk_foe_entry_commit_l2(ppe, entry);
> 
> 	hash = mtk_ppe_hash_entry(ppe->eth, &entry->data);
> 	entry->hash = 0xffff;
> 	...
> }
> 
> mtk_foe_entry_commit_l2() never sets entry->hash = 0xffff. The base L2
> entry is not on the foe_flow lists, so __mtk_ppe_check_skb() never updates
> its hash. mtk_flow_entry_update_l2() only touches the subflow hashes. As a
> result, the base entry keeps hash == 0 for its whole lifetime.
> 
> That means the entry->hash != 0xFFFF check passes and
> mtk_foe_entry_get_mib(ppe, 0, &diff) runs. mtk_ppe_start() enables
> MTK_PPE_MIB_CFG_RD_CLR, so this read zeroes the MIB counter of whatever
> flow is bound at FOE index 0, for example an nf_flowtable L3 flow. Those
> packets and bytes get charged to the L2 rule and never reach their real
> owner.
> 
> The bridge flow's own counters live in the subflow slots on
> entry->l2_flows, and this function never reads them. So the destroy-time
> stats for L2 flows are wrong as well.
> 
> The missing 0xffff on L2 base entries is not new. Before this patch,
> though, mtk_flow_offload_destroy() never touched the MIB. Now every
> FLOW_CLS_DESTROY of a bridge flow does this read-clear, even when nobody
> requested stats for that rule.
> 
> Should L2 base entries be skipped here? Alternatively, should
> mtk_foe_entry_commit_l2() set entry->hash to 0xffff?
> 
> > +		f->stats.pkts += diff.packets;
> > +		f->stats.bytes += diff.bytes;
> > +	}
> > +}
> > +
> >  static int
> >  mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
> >  {
> > @@ -536,6 +554,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
> >  	if (!entry)
> >  		return -ENOENT;
> >  
> > +	mtk_flow_offload_update_stats(eth, f, entry);
> > +
> >  	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);
> 
> [Severity: Medium]
> Is this snapshot really the final one for the flow?
> 
> mtk_flow_offload_update_stats() read-clears MIB[entry->hash] while the
> hardware FOE entry is still in BIND state. ppe_lock is dropped between
> the two steps. The entry is only invalidated later, under ppe_lock, in
> __mtk_foe_entry_clear():
> 
> drivers/net/ethernet/mediatek/mtk_ppe.c:__mtk_foe_entry_clear() {
> 	...
> 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
> 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
> 		dma_wmb();
> 		mtk_ppe_cache_clear(ppe);
> 
> 		if (ppe->accounting) {
> 			...
> 			acct->packets = 0;
> 			acct->bytes = 0;
> 		}
> 	}
> 	entry->hash = 0xffff;
> 	...
> }
> 
> Between the MIB read and the invalidation, the PPE keeps forwarding and
> counting packets for this flow. That traffic never reaches f->stats. It
> stays in the hardware MIB counter, because only the software acct_table
> is zeroed here.
> 
> __mtk_foe_entry_commit() doesn't clear the MIB either. So the next
> read-clear of that index charges those packets to whichever flow binds
> the slot next.
> 
> This happens whenever an active flow is torn down, for example on a
> flowtable flush, a conntrack flush or a ruleset deletion.
> 
> Would it work to invalidate the entry first and then drain
> MIB[saved hash]?
> 
> >  	rhashtable_remove_fast(&eth->flow_table, &entry->node,
> >  			       mtk_flow_ht_params);
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
