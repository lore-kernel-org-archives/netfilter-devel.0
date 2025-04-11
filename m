Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE6C221276;
	Fri, 11 Apr 2025 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369077; cv=none; b=ehjH808AqKPEx5RgPE+QOnovegqvU0WgbiM/eIWbuemfErKmf3TXc73bE0GASo7oKuWzKhJFltyyhuBPJvZuY3Npk+d/S5x/JffjZHmHzRCk+45MtUXXBR1KlMqNxgO+nzQTJlMgRVA/85UXoIea97Gxjm+O4hnND7CWKfJLEME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369077; c=relaxed/simple;
	bh=dOLfMsGYoa8n4VxA/SB6P5E9xmgLVBfZVob9Iy+LyNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRIl2VG4TMwXKcyK+k1q3T7l6J45VJHiy3c2u6Ojl71VBtmb6Q+c2eB5Mk89X1YCWqQX5nw9y91mCm6G8B9r6TVXkgBoIVhVH2hUEJ51TWOsJxoJexW9/37k1v4FZDI2KqaPIz3W0gZ/vO+AeNF8YRd3q/BYzdkQzMSNvEkm9iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGXHXDtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGXHXDtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3876C4CEE2;
	Fri, 11 Apr 2025 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744369077;
	bh=dOLfMsGYoa8n4VxA/SB6P5E9xmgLVBfZVob9Iy+LyNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGXHXDtfuIbGy03F6HlfruFGf18al3w2/1qb/klvReuXxiJa7BWPX22nTC3N/bVQX
	 aXqrMWZ6DKIkz6JUHvZkJmzGiPwHhMPP3JSIlk8g+T631xA980hEXxdbKlPVJVYOlY
	 SWxw1Y/bA9yJ2+s0barJuUgyHoh1BsEe6BgJHyoxMK8MGsx5dKH0xzZz0t5+S/xgGw
	 Ym5YY8NK1A/zFCaZKomCv0E5O4TSpCvLv6A7Er2YrbzYNrxkAjuL143zcNWsUlbjgc
	 EFcKxH8U9WR4oNp0uvgGGVHr00XvcHHVH+Ke1S3a2FNBs1Y5mx9W/KdyKkAObG6WB4
	 +7yffSBFTUGsw==
Date: Fri, 11 Apr 2025 11:57:51 +0100
From: Simon Horman <horms@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH v11 nf-next 6/6] netfilter: nft_flow_offload: Add
 bridgeflow to nft_flow_offload_eval()
Message-ID: <20250411105751.GA1156507@horms.kernel.org>
References: <20250408142802.96101-1-ericwouds@gmail.com>
 <20250408142802.96101-7-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408142802.96101-7-ericwouds@gmail.com>

On Tue, Apr 08, 2025 at 04:28:02PM +0200, Eric Woudstra wrote:
> Edit nft_flow_offload_eval() to make it possible to handle a flowtable of
> the nft bridge family.
> 
> Use nft_flow_offload_bridge_init() to fill the flow tuples. It uses
> nft_dev_fill_bridge_path() in each direction.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_flow_offload.c | 148 +++++++++++++++++++++++++++++--
>  1 file changed, 143 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c

...

> +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
> +				    struct nft_flowtable *ft,
> +				    enum ip_conntrack_dir dir,
> +				    const struct net_device *src_dev,
> +				    const struct net_device *dst_dev,
> +				    unsigned char *src_ha,
> +				    unsigned char *dst_ha)
> +{
> +	struct flow_offload_tuple_rhash *th = flow->tuplehash;
> +	struct net_device_path_ctx ctx = {};
> +	struct net_device_path_stack stack;
> +	struct nft_forward_info info = {};
> +	int i, j = 0;
> +
> +	for (i = th[dir].tuple.encap_num - 1; i >= 0 ; i--) {
> +		if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
> +			return -1;
> +
> +		if (th[dir].tuple.in_vlan_ingress & BIT(i))
> +			continue;
> +
> +		info.encap[info.num_encaps].id = th[dir].tuple.encap[i].id;
> +		info.encap[info.num_encaps].proto = th[dir].tuple.encap[i].proto;
> +		info.num_encaps++;
> +
> +		if (th[dir].tuple.encap[i].proto == htons(ETH_P_PPP_SES))
> +			continue;
> +
> +		if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
> +			return -1;
> +		ctx.vlan[ctx.num_vlans].id = th[dir].tuple.encap[i].id;
> +		ctx.vlan[ctx.num_vlans].proto = th[dir].tuple.encap[i].proto;
> +		ctx.num_vlans++;
> +	}
> +	ctx.dev = src_dev;
> +	ether_addr_copy(ctx.daddr, dst_ha);
> +
> +	if (dev_fill_bridge_path(&ctx, &stack) < 0)
> +		return -1;
> +
> +	nft_dev_path_info(&stack, &info, dst_ha, &ft->data);
> +
> +	if (!info.indev || info.indev != dst_dev)
> +		return -1;
> +
> +	th[!dir].tuple.iifidx = info.indev->ifindex;
> +	for (i = info.num_encaps - 1; i >= 0; i--) {
> +		th[!dir].tuple.encap[j].id = info.encap[i].id;
> +		th[!dir].tuple.encap[j].proto = info.encap[i].proto;
> +		if (info.ingress_vlans & BIT(i))
> +			th[!dir].tuple.in_vlan_ingress |= BIT(j);
> +		j++;
> +	}
> +	th[!dir].tuple.encap_num = info.num_encaps;
> +
> +	th[dir].tuple.mtu = dst_dev->mtu;
> +	ether_addr_copy(th[dir].tuple.out.h_source, src_ha);
> +	ether_addr_copy(th[dir].tuple.out.h_dest, dst_ha);
> +	th[dir].tuple.out.ifidx = info.outdev->ifindex;
> +	th[dir].tuple.out.hw_ifidx = info.hw_outdev->ifindex;
> +	th[dir].tuple.out.bridge_vid = info.bridge_vid;

Hi Eric,

I guess I am doing something daft.
But with this patchset applied on top of nf-next I see
the following with allmodconfig builds on x86_64.:

  CC [M]  net/netfilter/nft_flow_offload.o
net/netfilter/nft_flow_offload.c: In function 'nft_dev_fill_bridge_path':
net/netfilter/nft_flow_offload.c:248:26: error: 'struct <anonymous>' has no member named 'bridge_vid'
  248 |         th[dir].tuple.out.bridge_vid = info.bridge_vid;
      |                          ^
net/netfilter/nft_flow_offload.c:248:44: error: 'struct nft_forward_info' has no member named 'bridge_vid'
  248 |         th[dir].tuple.out.bridge_vid = info.bridge_vid;
      |                                            ^

> +	th[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> +
> +	return 0;
> +}

...
