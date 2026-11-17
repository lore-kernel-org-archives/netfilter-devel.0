Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874967;
	b=14l6//ye8SWd1JrzPhugSje3NsHzYAJFjB85ewV126b9+p8IMC/AP2kFRlUldfmEi2Pt
	 /OzBViLOVM4sGBNZxbMmfndPZDzOVErl2ooQ+4Fl9caTd8k132VE56gK1annhq0X8rd1a
	 wYAy7LHxv75YOgVYGqKRIjEOfYfUQPD1YN3PEBPlIIjghR3qh0B62CcjtYut5YG5FKu/S
	 DP+CRue5Licem6jHuPyQFxpK0pNRDIinf4Vin9nbFgyngwLdZE6Gi3E3IOw7E4eIA/QSn
	 QdrTtYLDQq9rY2W9d5zS4+qyMimVkOiZgQoo3Ma/H5oZyHBJmzhAye25+Vfs7SR4laQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874967;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=MAeQuZijSZsqS7He+oeUHCWmU87s9tjP3gNCLSBS5L0=;
	b=XfBXYtiOUMysxyUwAvNNnRtiE4vAvV9Pv1qB102vLw6T/NnQKaJWmXwcToFQbRUWG+qS
	 CLPenwwE9msH+Dq/gw8TqKAaKsayLH4j1OFUWNRSSRH2ygz9bCOfiHtu3KnLyLsHdLngU
	 3ppr/hHEBVi2PRlBWXl/AceZszKPS1YQwYPSpdt9fG9Ddw6OJi9QsejkKDFg9t9HJSsRQ
	 +4QCW0pkUvSFD+9QDhafJhjbOr7dq8DOV69M9ux/8z6MGbxKa1nt5LqoZ6ekZ+Mb2ST4O
	 epMnRSP9fpE9fKrptMKEhEwLbsPrZHcXaqU6UYrGFE7jyn8GEXpsCdZ4ZIPxvb+K/zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlQmbszt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5022606A332;
	Tue, 17 Nov 2026 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlQmbszt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50841F000C7;
	Tue, 17 Nov 2026 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874967;
	bh=MAeQuZijSZsqS7He+oeUHCWmU87s9tjP3gNCLSBS5L0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PlQmbsztmPvqcmpywEOzhCdcDBp0q92cG9Xp9i3wJzex4o5GdvW9HEa9A6HSVQ24f
	 utD3CWq8tSfu+D3zzvK2KJdul4Re2y81ua8xVBAy6G9sYcKbHrsayXY9Onpc99arNR
	 9KNW3bJwHf7AU7kP2wb6RS9CHd0hj+O/PIE8Dxj7++QoubmrN9Mpe6YQf5OTCjN0ec
	 w7zKJ9JJy6CPdSIKMAFtBQGSZAlYN1Mof9mM0SvUdTTsZ9W5+oqSkrFfZk4jkMHydu
	 ITY6jYKZ8m8qH18tOPScwnZRQYIkhtThnEJzmWh/cFsgC2GhKoypxG4JimwRaNrtQr
	 dJpEWR1HoNrYw==
Subject: Re: [PATCH net-next 03/13] net: ethernet: mtk_ppe: update stats on
 flow deletion
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:46 +0000
Message-ID: <179487496641.3136.14593435463868891598@kernel.org>
In-Reply-To: <20261116001612.2806263-4-pablo@netfilter.org>
References: <20261116001612.2806263-4-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mtk_flow_offload_update_stats()
  (drivers/net/ethernet/mediatek/mtk_ppe_offload.c:539) uses…
- [Medium] mtk_flow_offload_destroy()
  (drivers/net/ethernet/mediatek/mtk_ppe_offload.c:557-559) takes the…
- [Medium] net: mtk_ppe: mtk_flow_offload_update_stats() reads MIB 0 on
  L2 flows

--

net: ethernet: mtk_ppe: update stats on flow deletion

This commit moves the stats collection out of mtk_flow_offload_stats()
and into a new helper, mtk_flow_offload_update_stats(). The helper is
also called from mtk_flow_offload_destroy(), so final counters are
reported when a flow is deleted, following "netfilter: flowtable:
retrieve stats on flow deletion".

> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> index 99b28aaa7cc47..8ca694bb5e1b7 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -526,6 +526,24 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
>  	return err;
>  }
>  
> +static void
> +mtk_flow_offload_update_stats(struct mtk_eth *eth, struct flow_cls_offload *f,
> +			      struct mtk_flow_entry *entry)
> +{
> +	struct mtk_foe_accounting diff;
> +	u32 idle;
> +
> +	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
> +	f->stats.lastused = jiffies - idle * HZ;
> +
> +	if (entry->hash != 0xFFFF &&
> +	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
> +				  &diff)) {

[Severity: Medium]
Does this hash check catch bridge flows?

mtk_flow_offload_replace() allocates the entry with kzalloc_obj(), so
entry->hash starts at 0. For MTK_PPE_PKT_TYPE_BRIDGE,
mtk_foe_entry_commit() returns via mtk_foe_entry_commit_l2() before
entry->hash is set to 0xffff:

drivers/net/ethernet/mediatek/mtk_ppe.c:mtk_foe_entry_commit() {
    ...
	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
		return mtk_foe_entry_commit_l2(ppe, entry);

	hash = mtk_ppe_hash_entry(ppe->eth, &entry->data);
	entry->hash = 0xffff;
    ...
}

mtk_foe_entry_commit_l2() sets entry->type to MTK_FLOW_TYPE_L2 and adds
the template to ppe->l2_flows, but leaves entry->hash alone. Hardware
FOE slots only go to the MTK_FLOW_TYPE_L2_SUBFLOW entries on
entry->l2_flows. mtk_flow_entry_update() and __mtk_foe_entry_clear()
both check for MTK_FLOW_TYPE_L2 before using entry->hash, but this
helper only checks entry->hash != 0xFFFF.

So for a bridge flow it looks like mtk_foe_entry_get_mib() runs with
hash 0. Because mtk_ppe_start() enables MTK_PPE_MIB_CFG_RD_CLR, that
read also clears hardware MIB counter 0. The bridge rule is credited
with another flow's packets and bytes, and whatever L3/L4 flow is
bound at FOE index 0 loses them from its next FLOW_CLS_STATS delta.

This already happens on FLOW_CLS_STATS today, but calling the helper
from mtk_flow_offload_destroy() adds the same destructive read on
every FLOW_CLS_DESTROY of a bridge flow, and those bogus counts end
up in the final stats handed back to the caller.

Should the helper skip entry->type == MTK_FLOW_TYPE_L2, or should
mtk_foe_entry_commit_l2() initialize entry->hash to 0xffff? If bridge
flows are expected to report stats at all, would the counters of the
subflows on entry->l2_flows need to be summed instead?

[Severity: Medium]
Does this hash check work for bridge (MTK_FLOW_TYPE_L2) base entries?

mtk_flow_offload_replace() allocates the entry with kzalloc_obj(), so
hash starts at 0. For MTK_PPE_PKT_TYPE_BRIDGE, mtk_foe_entry_commit()
returns before hash is set to 0xffff:

drivers/net/ethernet/mediatek/mtk_ppe.c:mtk_foe_entry_commit() {
    ...
	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
		return mtk_foe_entry_commit_l2(ppe, entry);

	hash = mtk_ppe_hash_entry(ppe->eth, &entry->data);
	entry->hash = 0xffff;
    ...
}

mtk_foe_entry_commit_l2() only sets entry->type. mtk_flow_entry_update()
takes the goto out path for L2 entries. L2 masters are never placed on
foe_flow[]. So the master's hash appears to stay at 0.

If so, mtk_foe_entry_get_mib(ppe, 0, &diff) runs for bridge flows.
mtk_ppe_start() enables MTK_PPE_MIB_CFG_RD_CLR, so this read also clears
hardware MIB slot 0.

With the new call in mtk_flow_offload_destroy(), every FLOW_CLS_DESTROY
of a bridge flow now read-clears slot 0. Would an unrelated L3/L4 flow
bound at FOE index 0 then lose those packets and bytes from its next
FLOW_CLS_STATS delta, and undercount its conntrack counters?

The bridge flow's own subflow counters (the cur->hash entries on
entry->l2_flows) also don't seem to be read before
__mtk_foe_entry_clear() frees them.

L2 masters keeping hash == 0 predates this patch and already affects
mtk_flow_offload_stats(). The destructive read on the destroy path is
new, though. Could the helper skip entries with
entry->type == MTK_FLOW_TYPE_L2? Alternatively, could
mtk_foe_entry_commit_l2() set hash to 0xffff?

> +		f->stats.pkts += diff.packets;
> +		f->stats.bytes += diff.bytes;
> +	}
> +}
> +
>  static int
>  mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
>  {
> @@ -536,6 +554,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
>  	if (!entry)
>  		return -ENOENT;
>  
> +	mtk_flow_offload_update_stats(eth, f, entry);
> +
>  	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);

[Severity: Medium]
Can traffic forwarded between the stats snapshot and the invalidation
go missing from the final counters?

The read-clear happens in this chain:

mtk_flow_offload_update_stats()
  -> mtk_foe_entry_get_mib()
    -> mtk_mib_entry_read()

It runs while hwe->ib1 is still MTK_FOE_STATE_BIND, and it holds only
mtk_flow_offload_mutex, not ppe_lock. The entry is invalidated later, in
a separate critical section:

drivers/net/ethernet/mediatek/mtk_ppe.c:__mtk_foe_entry_clear() {
    ...
	if (entry->hash != 0xffff) {
		struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, entry->hash);

		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
		dma_wmb();
		mtk_ppe_cache_clear(ppe);
		...
			acct->packets = 0;
			acct->bytes = 0;
	}
	entry->hash = 0xffff;
    ...
}

The PPE counts packets it forwards in that window into the MIB slot, but
they never reach f->stats. The flowtable core now passes f->stats to
nf_ct_acct_add() as the final sync. This can happen whenever traffic is
still flowing at deletion time (flowtable flush, conntrack -D, device
teardown).

__mtk_foe_entry_clear() zeroes only the software acct_table copy and
then drops the index, so the leftover hardware MIB counts are never
drained. If the hardware doesn't reset the slot on rebind, could those
counts be charged to the next flow bound at that index? That part
predates this patch, and the patch makes it smaller.

Just moving the helper call after mtk_foe_entry_clear() won't work,
because entry->hash is reset there. Could the code instead save the
hash, invalidate and flush the entry, and then do the final read-clear
on the saved index?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
