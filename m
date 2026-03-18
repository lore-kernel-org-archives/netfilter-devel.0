Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840A52032D;
	Wed, 18 Mar 2026 00:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773793963; cv=none; b=J3quJJMCXzn6FLrEianQ0BTavXOb8tP9nX1OUtGTlKXvg9zJbhzMOj79igXYi2hBX96rsDXx4Dwu8u+AIU8rAsu1rutudIyMoL3BeQnFA9o5rCONH6w3POitmDuDUQv94rdJJMldhtr7OOznyjnM0kS3y55xMQ5qfFDDL0xP0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773793963; c=relaxed/simple;
	bh=+K7vbrPEko/xLvJpG935Ozb3wcIECXD+K7p2132r3ew=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=YTr3nyvt0T0ZZsr7FF70rw4OQl7vzTiZDQVvxeaE37eGaOXDfaSuYyO7ogDNl2oTe2K625j7XsK5NogmhheZ2a0FZLQ3hFkBGufvdOXuv5skAFcJbvRJmlmlml5tnW/N1WCnzo2h3vaahZEvEUt6b7XwnL8JpWvb2X/E+R1eK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEKsmbLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEKsmbLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AECC4CEF7;
	Wed, 18 Mar 2026 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773793963;
	bh=+K7vbrPEko/xLvJpG935Ozb3wcIECXD+K7p2132r3ew=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=KEKsmbLUrOcZRyGZDXU0aYUEQjlp1R4wnHRtHtDlqZzwbHWtvp9kdM1XJd29cdWvG
	 CoyqeDkTjfR4/y+0n/ifER95L2mTcXc65fH5CCJ5dvRz3vOjx39iSmVsQOat3zPBgh
	 pp+5FOR/tI+wmQm9Z050dXwIID3N4kry1pBgf8XHFySjYDVZPDtRpje5nGfNguk7ED
	 pxtmvw+2JMSRXq16BnyPMuaWHUuBoWhDLF92xxnWg/ybQGsK2Lc0WT8fJ3MjxaafTI
	 ygsLru7SXuBNuNqLXefVJvBjKSE44dAEUIKj3bAfsVbXcGakHsRYXSaHQJWResvYuO
	 yM5jrweSdy4XA==
Content-Type: multipart/mixed; boundary="===============8481999304696418550=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <4835dc583eabe4c0d1763a8c08399302896e25490f353ecce51b58a59d20a0d3@mail.kernel.org>
In-Reply-To: <20260317234851.234466-3-anzaki@gmail.com>
References: <20260317234851.234466-3-anzaki@gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: flowtable: update netdev stats with HW_OFFLOAD flows
From: bot+bpf-ci@kernel.org
To: anzaki@gmail.com,netfilter-devel@vger.kernel.org,pablo@netfilter.org,fw@strlen.de
Cc: coreteam@netfilter.org,netdev@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 18 Mar 2026 00:32:42 +0000 (UTC)

--===============8481999304696418550==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 9b677e116487..d340d37589bf 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c

[ ... ]

> +static void flow_offload_netdev_update(struct flow_offload_work *offload,
> +				       struct flow_stats *stats)
> +{
> +	const struct flow_offload_tuple *tuple;
> +	struct net_device *indev, *outdev;
> +	struct net *net;
> +
> +	rcu_read_lock();
> +	net = read_pnet(&offload->flowtable->net);
> +	if (stats[0].pkts) {
> +		tuple = &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
> +		indev  = dev_get_by_index_rcu(net, tuple->iifidx);
> +		if (indev)
> +			dev_sw_netstats_rx_add(indev,
> +					       stats[0].pkts, stats[0].bytes);

dev_sw_netstats_rx_add() and dev_sw_netstats_tx_add() both do
this_cpu_ptr(dev->tstats) internally to update per-cpu software
stats. Can this corrupt memory when the device does not have tstats
allocated?

Drivers that support flowtable hw offload (TC_SETUP_FT) are typically
physical NICs such as mlx5, which do not set pcpu_stat_type and do
not allocate dev->tstats. When dev->tstats is NULL,
this_cpu_ptr(NULL) computes the per-cpu base address rather than
faulting, and the subsequent writes would silently corrupt whatever
per-cpu data lives at offset zero.

All existing callers of dev_sw_netstats_rx_add() call it on device
types known to have tstats (bridges, tunnels, tun/tap, etc.), not
on devices obtained from arbitrary dev_get_by_index_rcu() lookups.

> +
> +		outdev = dev_get_by_index_rcu(net, tuple->out.ifidx);
> +		if (outdev)
> +			dev_sw_netstats_tx_add(outdev,
> +					       stats[0].pkts, stats[0].bytes);

For flows with xmit_type FLOW_OFFLOAD_XMIT_NEIGH (the common L3
routing case), does tuple->out.ifidx return the correct output
interface index?

Looking at the flow_offload_tuple union layout in
nf_flow_table.h and how flow_offload_fill_route() populates it:

For FLOW_OFFLOAD_XMIT_DIRECT:
    flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;

For FLOW_OFFLOAD_XMIT_NEIGH:
    flow_tuple->dst_cache = dst;
    flow_tuple->ifidx = route->tuple[dir].out.ifindex;

The anonymous struct member ifidx sits at a different offset than
out.ifidx in the union -- dst_cache (a pointer, 8 bytes on 64-bit)
occupies offset 0, and the anonymous ifidx follows at offset 8.
Meanwhile out.ifidx is at offset 0.

So for NEIGH flows, reading tuple->out.ifidx actually reads the
low bytes of the dst_cache pointer rather than the output interface
index. dev_get_by_index_rcu() would return NULL for this bogus
value, and outdev tx stats would be silently skipped.

The existing software path in nf_flow_offload_ip_hook() handles
this correctly by checking tuple->xmit_type and using
tuple->out.ifidx only for DIRECT and tuple->ifidx (anonymous
member) only for NEIGH.

> +	}

[ ... ]

> +	rcu_read_unlock();
>  }

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/23222395400
--===============8481999304696418550==--
