Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874968;
	b=Pu8qnNFumzQIjQd1lUKst4c4Pb7uQBGgd9dm0MsdDqOI+vlUYR2kgomlUJhnnvGIamYk
	 lxEH0BKh1xgo9pUg/lc5j88Yk0WSAurVn9/lxXUmpd0ema8ppm8EX+XH11qGTwwRdC34w
	 JYv1I9dnwyNEI1um10tUm6Bed+yy1KifjjfnoY6ONlwZfjJrMfcjqfS2yhZZ8jeYAAu3s
	 Z3LBypqpAWYFPrmFQ2upKsPrJLACHNB46siERLW14LpPfM/SXBHh6qUmKSZoSr/fiVfHU
	 ewVwIREB009ACpCDa/Jz7P5bYsoG1cDVYot91EuYLrJpxFBkWSuS3g0dx51txMl3Uvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874968;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DT5kHdAHo9yy+y8d6Vtdzg5Jnaw+JcLWmakBC4rAG3c=;
	b=Wm/gVndtbIh4CYUA0LraGY/AzUmSO8CZ7lzrezbCZozDzOlZypldvli+tszuogc6I73y
	 itsQiW5ilLo5B6ABl7/fuGP48hQTPsADCb9y5Ylfj4zdVkef2FdNEKHnsTVfEDLUkIbNw
	 HQ4vw/Vm1HqARUt9SST89utia0vDmMr81wYYlukz20W9ODZYQi0gm+X5iamvJroK2avBI
	 6+UZSoJAqws5dR0crh0h6i7Gza+3jaIhlVZ0J3jvpXZgh5mNZM0BzH0u7rtykIAdRIk23
	 YyrJFQTq2Ql6/pom+HiB36Vn3uF1YGjebIr5CAZYBVoGFxTYscvwPxxIDSik3KwS44g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DsutZ9e4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA64606A31C;
	Tue, 17 Nov 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DsutZ9e4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A211F000C8;
	Tue, 17 Nov 2026 00:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874968;
	bh=DT5kHdAHo9yy+y8d6Vtdzg5Jnaw+JcLWmakBC4rAG3c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DsutZ9e4vV9ti3JR2Kx4kmhoX5IhKL9Zk4s3gAnECbtCF5namHSJWAZnczlR/DO04
	 /q61Owo0YDYzNScLzMXoypviHBOxLee0sKrFz4pRiSJNXrCmQLj2CSX30mx2c3f/Ws
	 bfqKpBaVuHX2m5bFsDaYUy51vV24UE8wzk9HTx2WxftcHjC3visRD3V+I80HSENcIu
	 DH35z+QyjGKOSQ3kD7+SOm5sNKtTRVT9wSMqY5flyXXJrFAEG8noIdiRlYbKomsdk3
	 0DBZNRpkTQejwyFEARUFTbxR/xt4R61+EXrGf4aEHoPIMBXjMy2Wp+brKXkSImRZb6
	 GLyAYpuZ4x3vA==
Subject: Re: [PATCH net-next 04/13] net: airoha: update stats on flow deletion
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:47 +0000
Message-ID: <179487496757.3136.17841889831992200764@kernel.org>
In-Reply-To: <20261116001612.2806263-5-pablo@netfilter.org>
References: <20261116001612.2806263-5-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] airoha_ppe_flow_offload_destroy()
  (drivers/net/ethernet/airoha/airoha_ppe.c:1315-1316) takes the 'final'…

--

net: airoha: update stats on flow deletion

This moves the per-flow stats collection into a new helper,
airoha_ppe_flow_update_stats(). The helper is now also called from
airoha_ppe_flow_offload_destroy(), so the flowtable gets the final
counters when a flow is deleted, following ("netfilter: flowtable:
retrieve stats on flow deletion").

> diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
> index f5369c45766d2..af8c7fe9b7f09 100644
> --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> +++ b/drivers/net/ethernet/airoha/airoha_ppe.c

[ ... ]

> @@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
>  	if (!e)
>  		return -ENOENT;
>  
> +	airoha_ppe_flow_update_stats(eth, f, e);
>  	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);

[Severity: Low]
Can packets counted by the hardware after this snapshot be lost from the
final stats?

airoha_ppe_flow_update_stats() reads the counters through
airoha_ppe_foe_entry_get_stats() (memcpy_fromio() of npu->stats[index]
plus ppe->foe_stats[index]). It does this without ppe_lock, while the FOE
entry is still in BIND state.

After that, airoha_ppe_foe_flow_remove_entry() takes ppe_lock and calls:

airoha_ppe_foe_remove_flow()
    e->data.ib1 |= FIELD_PREP(AIROHA_FOE_IB1_BIND_STATE,
                              AIROHA_FOE_STATE_INVALID);
    airoha_ppe_foe_commit_entry(ppe, &e->data, e->hash, false);

Since rx_wlan is false, the commit goes through
airoha_ppe_foe_flow_stats_update(). That function zeroes the counters
for this hash:

    airoha_ppe_foe_flow_stat_entry_reset(ppe, npu, index);

Between the snapshot and the invalidating commit, the PPE keeps
forwarding and counting packets for this flow. That window includes:

  - waiting for ppe_lock, which the NAPI path also takes
    (airoha_qdma_rx_process()->airoha_ppe_check_skb()->
    airoha_ppe_foe_insert_entry())
  - the SRAM MMIO writes
  - the ack poll

Packets counted in that window are then reset and never reach
flow_offload_update_stats() / nf_ct_acct_add(). Flows torn down for idle
timeout are not affected. Flows deleted while still carrying traffic
(conntrack flush, route or device change, one-sided TCP teardown) would
under-report.

Would it work to do this under ppe_lock instead? Save the hash,
invalidate the entry without resetting the counters, read the stats,
then reset them.

The mtk peer patch "net: ethernet: mtk_ppe: update stats on flow
deletion" appears to use the same snapshot-then-clear order.

>  	rhashtable_remove_fast(&eth->flow_table, &e->node,
>  			       airoha_flow_table_params);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
